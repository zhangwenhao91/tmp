#!/usr/bin/env python3
"""l1ub 消融运行器（NPU 机上跑）。

逐个 load + launch + sync，定位 0x7bc87 (ACL_ERROR_RT_AICORE_EXCEPTION)
是崩在哪一条指令形态。判据只关心"是否 AICORE_EXCEPTION"：

  control       原版 l1ub（带 gemm，已知必崩）-> 复现基线
  l1ub_a bf16 r16/r128  循环内只有 L1->UB 一跳（mov.l1.to.ub.v310）
  l1ub_b bf16 r16/r128  循环内 L1->UB + UB->L1 往返（mov.ub.to.l1.v310）

推断：
  A 崩            -> 根因在 L1->UB（mov.l1.to.ub.v310）本身
  A 过、B 崩      -> 根因在 UB->L1（mov.ub.to.l1.v310）
  A、B 都过       -> 根因在与 gemm 的交互（仅 control 崩）

输入在机内生成（固定 seed，无须 npy 准备）；每个 case 用独立 stream，
某个 case 崩不会污染后续。PASS 时顺带用 torch 校验 OUT1/OUT2 vs X@W。
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from bench_run import _load_rt

M, K, N = 16, 256, 16
DTYPE = "bfloat16"
KNAME = "l1ub_kernel"
MODE = "aic"

CASES = [
    ("control-l1ub,bf16,16x256,r16", "new_env/n6_l1ub_bfloat16_16x256_r16_single.o"),
    ("A-l1ub-only,bf16,16x256,r16", "new_env/n6_l1ub_a_bfloat16_16x256_r16_single.o"),
    ("A-l1ub-only,bf16,16x256,r128", "new_env/n6_l1ub_a_bfloat16_16x256_r128_single.o"),
    ("B-roundtrip,bf16,16x256,r16", "new_env/n6_l1ub_b_bfloat16_16x256_r16_single.o"),
    ("B-roundtrip,bf16,16x256,r128", "new_env/n6_l1ub_b_bfloat16_16x256_r128_single.o"),
]


def prep(seed=42):
    rng = np.random.default_rng(seed)
    x = (rng.standard_normal((M, K)) * 0.5).astype(np.float32)
    w1 = (rng.standard_normal((K, N)) * 0.05).astype(np.float32)
    w2 = (rng.standard_normal((K, N)) * 0.05).astype(np.float32)
    if DTYPE == "bfloat16":
        import ml_dtypes
        x = x.astype(ml_dtypes.bfloat16).view(np.uint16)
        w1 = w1.astype(ml_dtypes.bfloat16).view(np.uint16)
        w2 = w2.astype(ml_dtypes.bfloat16).view(np.uint16)
    return x, w1, w2


def golden(x, w1, w2):
    try:
        import torch
    except ImportError:
        return None
    xb = torch.from_numpy(x.copy())
    w1b = torch.from_numpy(w1.copy())
    w2b = torch.from_numpy(w2.copy())
    if DTYPE == "bfloat16":
        xb, w1b, w2b = (xb.view(torch.bfloat16), w1b.view(torch.bfloat16), w2b.view(torch.bfloat16))
    return ((xb.float() @ w1b.float()).numpy(), (xb.float() @ w2b.float()).numpy())


def upload(rt, arr):
    p = rt.malloc_device(arr.nbytes)
    rt.memcpy_h2d(p, arr.tobytes(order="C"))
    return p


def main():
    rt = _load_rt()
    rt.init_runtime(None)
    rt.set_device(0)

    x, w1, w2 = prep()
    xp, w1p, w2p = upload(rt, x), upload(rt, w1), upload(rt, w2)
    o1p = rt.malloc_device(M * N * 4)
    o2p = rt.malloc_device(M * N * 4)
    g = golden(x, w1, w2)

    print("=== l1ub 消融（0x7bc87 定位）===")
    for label, rel in CASES:
        path = os.path.join(HERE, rel)
        if not os.path.exists(path):
            print(f"[{label}] SKIP (missing {rel})")
            continue
        with open(path, "rb") as f:
            obytes = f.read()
        stream = rt.create_stream()
        try:
            module, func = rt.load_kernel(KNAME, obytes, 0, MODE)
        except Exception as e:
            rt.destroy_stream(stream)
            print(f"[{label}] LOAD-FAIL: {e}")
            continue
        try:
            rt.launch_kernel(
                func=func,
                stream=stream,
                blocknum=1,
                kernel_args=[
                    ("ptr", xp), ("ptr", w1p), ("ptr", w2p),
                    ("ptr", o1p), ("ptr", o2p), ("int32", 0),
                ],
            )
            rt.synchronize_stream(stream)
        except Exception as e:
            # 期望：AICORE_EXCEPTION 0x7bc87（control 必须复现，否则判据失效）
            print(f"[{label}] FAIL: {e}")
            rt.destroy_stream(stream)
            continue
        try:
            rt.unregister_kernel(module)
        except Exception:
            pass
        o1 = np.frombuffer(rt.memcpy_d2h(o1p, M * N * 4), dtype=np.float32).reshape(M, N)
        o2 = np.frombuffer(rt.memcpy_d2h(o2p, M * N * 4), dtype=np.float32).reshape(M, N)
        e1 = "?" if g is None else float(np.abs(o1 - g[0]).max())
        e2 = "?" if g is None else float(np.abs(o2 - g[1]).max())
        print(f"[{label}] PASS  max_err O1={e1} O2={e2}")
        rt.destroy_stream(stream)

    rt.finalize_runtime(0, True)


if __name__ == "__main__":
    main()
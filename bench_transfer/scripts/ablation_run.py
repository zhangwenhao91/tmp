#!/usr/bin/env python3
"""l1ub 消融运行器（NPU 机上跑）。

逐个 load + launch + sync，定位 0x7bc87 (ACL_ERROR_RT_AICORE_EXCEPTION)
是崩在哪一条指令形态。判据只关心"是否 AICORE_EXCEPTION"：

  control       原版 l1ub（带 gemm，已知必崩）-> 复现基线
  l1ub_a bf16 r16/r128  循环内只有 L1->UB 一跳（mov.l1.to.ub.v310）
  l1ub_b bf16 r16/r128  循环内 L1->UB + UB->L1 往返（mov.ub.to.l1.v310）
  baseline bf16 r16/r128 无任何 L1<->UB（GM->L1 + L1 常驻 gemm）-> 最后一刀
  diag-c910/-c920      同一 l1ub cube 内核，CANN 9.1.0 vs 9.2.0 ccec 生成
                       -> 判别是否编译器版本 codegen 问题

实测进度（74fdee2 之后）：
  control/A/B/base-A0 全部 0x7bc87 -> 连零 L1<->UB 的 GM->L1+gemm kernel
  也在 cube 核上崩。历史所有 aic/cube 形态内核从未成功执行过（仅 aiv 的
  ub2ub/ub_scalar 通过），diag 只注册未执行。c910/c920 判别 cube 路径是否
  存在编译器版本依赖；若仍崩，下一个动作是抓 CANN plog 故障 PC（需
  ASCEND_GLOBAL_LOG_LEVEL=1 重跑）确认崩在哪条指令。

推断：
  baseline 过   -> 实锤 v310 L1<->UB 搬运（mov.l1.to.ub.v310）
  baseline 崩   -> 问题比 L1<->UB 更基础：下一刀 c910/c920 判别是否
                   ccec 编译器版本；再不行 -> plog 故障 PC。

输入在机内生成（固定 seed，无须 npy 准备）；每个 case 用独立 stream，
某个 case 崩不会污染后续。PASS 时顺带用 torch 校验输出 vs golden。

case 记录：(label, .o 相对路径, kname, 指针数，类型)
  5-ptr：X/W1/W2/O1/O2（l1ub 系，golden=OUT vs X@W1 / X@W2）
  3-ptr：X/W/O   （baseline，golden=OUT vs X@W）
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from bench_run import _load_rt

M, K, N = 16, 256, 16
DTYPE = "bfloat16"
MODE = "aic"

CASES = [
    ("control-l1ub,bf16,16x256,r16", "new_env/n6_l1ub_bfloat16_16x256_r16_single.o", "l1ub_kernel", 5),
    ("A-l1ub-only,bf16,16x256,r16", "new_env/n6_l1ub_a_bfloat16_16x256_r16_single.o", "l1ub_kernel", 5),
    ("A-l1ub-only,bf16,16x256,r128", "new_env/n6_l1ub_a_bfloat16_16x256_r128_single.o", "l1ub_kernel", 5),
    ("B-roundtrip,bf16,16x256,r16", "new_env/n6_l1ub_b_bfloat16_16x256_r16_single.o", "l1ub_kernel", 5),
    ("B-roundtrip,bf16,16x256,r128", "new_env/n6_l1ub_b_bfloat16_16x256_r128_single.o", "l1ub_kernel", 5),
    ("base-A0,bf16,16x256,r16", "new_env/n6_baseline_bfloat16_16x256_r16_single.o", "baseline_kernel", 3),
    ("base-A0,bf16,16x256,r128", "new_env/n6_baseline_bfloat16_16x256_r128_single.o", "baseline_kernel", 3),
    ("diag-c910,l1ub,16x256,r16", "new_env/diag_l1ub_bf16_16x256_r16_align4_ccec910.o", "l1ub_kernel", 5),
    ("diag-c920,l1ub,16x256,r16", "new_env/diag_l1ub_bf16_16x256_r16_align4_ccec920.o", "l1ub_kernel", 5),
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
    g1 = (xb.float() @ w1b.float()).numpy()
    g2 = (xb.float() @ w2b.float()).numpy()
    return g1, g2, g1  # 5-ptr: O1/O2; 3-ptr(baseline): 只用 g1(golden for W=w1)


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
    for label, rel, kname, nptrs in CASES:
        path = os.path.join(HERE, rel)
        if not os.path.exists(path):
            print(f"[{label}] SKIP (missing {rel})")
            continue
        with open(path, "rb") as f:
            obytes = f.read()
        stream = rt.create_stream()
        try:
            module, func = rt.load_kernel(kname, obytes, 0, MODE)
        except Exception as e:
            rt.destroy_stream(stream)
            print(f"[{label}] LOAD-FAIL: {e}")
            continue
        try:
            if nptrs == 3:
                args = [("ptr", xp), ("ptr", w1p), ("ptr", o1p), ("int32", 0)]
            else:
                args = [
                    ("ptr", xp), ("ptr", w1p), ("ptr", w2p),
                    ("ptr", o1p), ("ptr", o2p), ("int32", 0),
                ]
            rt.launch_kernel(
                func=func,
                stream=stream,
                blocknum=1,
                kernel_args=args,
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
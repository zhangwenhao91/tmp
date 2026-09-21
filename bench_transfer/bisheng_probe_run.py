#!/usr/bin/env python3
"""bisheng/新ccec 编译产物的真机运行器（NPU 机上跑，依赖 bisheng_probe.sh）。

读 new_env/arch_probe/bisheng_probe_cases.txt（默认由 bisheng_probe.sh 生成：
"tag:kname:指针数"），逐个 load+launch+sync。哪个 arch 编译出的 .o 能 PASS
就证明 Ascend950 的 cube 架构对齐到了哪一档（bisheng<arch> vs ccec<arch>）。

kname 由 kernerel 决定：baseline_kernel=3ptr(X/W/O+int32), l1ub_kernel=5ptr。
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
CASES_FILE = os.path.join(HERE, "new_env/arch_probe/bisheng_probe_cases.txt")


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
    return g1, g2, g1


def upload(rt, arr):
    p = rt.malloc_device(arr.nbytes)
    rt.memcpy_h2d(p, arr.tobytes(order="C"))
    return p


def main():
    if not os.path.exists(CASES_FILE):
        print(f"[FATAL] {CASES_FILE} 不存在；先跑 ./bisheng_probe.sh")
        return
    rt = _load_rt()
    rt.init_runtime(None)
    rt.set_device(0)

    x, w1, w2 = prep()
    xp, w1p, w2p = upload(rt, x), upload(rt, w1), upload(rt, w2)
    o1p = rt.malloc_device(M * N * 4)
    o2p = rt.malloc_device(M * N * 4)
    g = golden(x, w1, w2)

    print("=== bisheng/新ccec arch 探测（Ascend950 cube）===")
    npass = 0
    with open(CASES_FILE) as f:
        cases = [ln.strip().split(":") for ln in f if ln.strip()]
    for tag, kname, nptrs in cases:
        nptrs = int(nptrs)
        path = os.path.join(HERE, "new_env/arch_probe", f"{tag}.o")
        if not os.path.exists(path):
            print(f"[{tag}] SKIP (missing .o)")
            continue
        with open(path, "rb") as fp:
            obytes = fp.read()
        stream = rt.create_stream()
        try:
            module, func = rt.load_kernel(kname, obytes, 0, MODE)
        except Exception as e:
            rt.destroy_stream(stream)
            print(f"[{tag}] LOAD-FAIL: {e}")
            continue
        try:
            if nptrs == 3:
                args = [("ptr", xp), ("ptr", w1p), ("ptr", o1p), ("int32", 0)]
            else:
                args = [
                    ("ptr", xp), ("ptr", w1p), ("ptr", w2p),
                    ("ptr", o1p), ("ptr", o2p), ("int32", 0),
                ]
            rt.launch_kernel(func=func, stream=stream, blocknum=1, kernel_args=args)
            rt.synchronize_stream(stream)
        except Exception as e:
            print(f"[{tag}] FAIL: {e}")
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
        print(f"[{tag}] PASS  max_err O1={e1} O2={e2}")
        npass += 1
        rt.destroy_stream(stream)

    rt.finalize_runtime(0, True)
    print(f"=== {npass}/{len(cases)} PASS ===")


if __name__ == "__main__":
    main()
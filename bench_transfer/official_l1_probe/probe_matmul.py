#!/usr/bin/env python3
"""官方通道探针：确认 设备/固件/官方运行时 matmul 可用。

动机：6_l1ub*（L1->UB / UB->L1 / L1->L1，mix 双核与单核 AIC 均）在板上全部
rtStreamSynchronize 0x7bc87 core-exception，而纯 UB 内核全 PASS。
本脚本用官方 torch_npu 跑 cube matmul（Atb900 GE cube gemm 内部经 L1 暂存 B
侧 L0B），验证官方 L1 路径在此机器/固件上是否正常。

判读：
  - 本脚本 PASS + 6_l1ub*.o 全崩 => 机器/固件正常，问题在我们工具链产出的内核
    属性/加载方式（缺 L1 相关 kernel attr 等），不是硬件禁用 L1。
  - 本脚本也崩 => 机器/固件层面 L1 不可用，另说。
无需任何算子开发环境，板上有 torch + torch_npu 即可。
"""
import sys
import time

import torch

try:
    import torch_npu
except ImportError as exc:
    sys.exit(f"[FAIL] 板上没有 torch_npu: {exc}")

try:
    torch.npu.set_device(0)
except Exception as exc:
    sys.exit(f"[FAIL] npu 不可用: {exc}")


def get_version(mod, name):
    v = getattr(mod, "__version__", None)
    return v if v else getattr(getattr(mod, "_version", ""), "string", "?")


def bench(M, K, N, iters=100):
    a = torch.randn(M, K, dtype=torch.float16, device="npu")
    b = torch.randn(K, N, dtype=torch.float16, device="npu")
    for _ in range(3):  # warmup
        c = torch.matmul(a, b)
    torch.npu.synchronize()
    t0 = time.perf_counter()
    for _ in range(iters):
        c = torch.matmul(a, b)
    torch.npu.synchronize()
    dt_us = (time.perf_counter() - t0) / iters * 1e6
    ref = (a.float() @ b.float()).half()
    ok = torch.allclose(c, ref, atol=1e-2, rtol=1e-2)
    print(f"[matmul] {M}x{K}x{N} f16: {'PASS' if ok else 'FAIL'}  {dt_us:.1f} us")
    return ok


def main():
    print(f"device : {torch_npu.npu.get_device_name(0)}")
    print(f"torch  : {torch.__version__}")
    print(f"torch_npu: {get_version(torch_npu, 'torch_npu')}")
    results = [
        bench(64, 64, 64),
        bench(256, 256, 256),
        bench(256, 3072, 256),
        bench(1024, 1024, 1024),
    ]
    if all(results):
        print("[RESULT] OK: 官方 matmul 全过，官方(L1)路径在本机可用")
    else:
        print("[RESULT] FAIL: 至少一个规格数值错误，见上")


if __name__ == "__main__":
    main()
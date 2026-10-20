"""d806 HBM 带宽探针：校准 bench_mha.py 的峰值带宽（替换 3200 占位）。

三个口径：
- copy     ：整块 clone，读+写对称，是最稳的峰值下界；
- read     ：纯读规约；
- strided  ：按 MHA kernel 的真实访问模式读（256B 连续段、行间 8KB 步长，
             对应 [rows, H, D] 池按 head 列整页读），衡量该模式下可达带宽。

末行输出 PEAK_GBPS=<值>（copy/read 取大者），供 BENCH_PEAK_BW_GBPS 使用。
"""
import statistics
import time

import torch
import torch_npu  # noqa: F401

DEV = torch.device("npu", 0)
REPEAT = 20


def timed(fn):
    fn()  # 预热
    torch.npu.synchronize()
    ts = []
    for _ in range(REPEAT):
        t0 = time.perf_counter()
        fn()
        torch.npu.synchronize()
        ts.append(time.perf_counter() - t0)
    return statistics.median(ts)


def main():
    n = 512 * 1024 * 1024  # 1 GiB fp16
    x = torch.randn(n, dtype=torch.float16, device=DEV)
    y = torch.empty_like(x)
    # 模拟 kernel 的 K/V 页读：32 头、D=128，取 h=4 一列，256B 段 + 8KB 行步长
    x3 = x.view(-1, 32, 128)
    h = 4

    t_copy = timed(lambda: y.copy_(x))
    t_read = timed(lambda: torch.sum(x, dtype=torch.float32))
    t_strided = timed(lambda: x3[:, h, :].sum(dtype=torch.float32))

    gb = n * 2 / 1e9
    copy_gbps = 2 * gb / t_copy
    read_gbps = gb / t_read
    strided_gbps = gb / t_strided
    print(f"copy   : {copy_gbps:7.1f} GB/s  (读+写)")
    print(f"read   : {read_gbps:7.1f} GB/s  (纯读)")
    print(f"strided: {strided_gbps:7.1f} GB/s  (纯读, 256B chunk / 8KB stride)")
    print(f"PEAK_GBPS={max(copy_gbps, read_gbps):.0f}")


if __name__ == "__main__":
    main()

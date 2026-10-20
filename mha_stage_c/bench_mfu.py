"""MHA decode 的 MFU 基准：固定形状重复调用，算有效 FLOPs 与算力利用率。

在 ~/TileOPs 目录下运行（依赖已 pip install -e 的 tileops）：
    python3 bench_mfu.py

口径说明：
- decode 的有效 FLOPs 按 QK^T + PV 两个 GEMM 计（业界惯例，softmax/exp 等不计）：
    FLOPs = 4 * B * H * S_q * real_sum * D
  （每个 (query 行, key 行) 对：QK 2*D + PV 2*D）；
- 峰值算力不猜纸面规格，先用大 fp16 matmul 实测可达峰值（PEAK_TFLOPS，可用
  BENCH_PEAK_TFLOPS 环境变量覆盖）；
- MFU = 有效 FLOPs / 耗时 / 峰值算力。decode 是访存受限负载，MFU 低是算术强度
  决定的本质现象，此数字仅作参考记录，验收口径仍是 MBU；
- 计时口径与 bench_mha.py 一致：per-call 中位 + amortized 平均。

输出：人类可读表格 + 末尾一行 "MFU_JSON: {...}" 便于机器解析。
"""

import json
import os
import statistics
import time

import torch
import torch_npu  # noqa: F401

from tileops.ops import MHADecodePagedWithKVCacheFwdOp

DEV = torch.device("npu", 0)
PEAK_TFLOPS = os.environ.get("BENCH_PEAK_TFLOPS")  # None = 实测校准
NUM_STAGES = os.environ.get("TILEOPS_MHA_NUM_STAGES", "1")

WARMUP = 3
REPEAT = 20
# 与 bench_mha.py 完全相同的形状表（S_q=1 全部）
SHAPES = [
    ("s1_B1H8_kv2048_p128",      1,  8, 2048, 128, 1.0, torch.float16),
    ("s2_B8H8_kv2048_p128",      8,  8, 2048, 128, 1.0, torch.float16),
    ("s3_B16H8_kv1024_p128",    16,  8, 1024, 128, 1.0, torch.float16),
    ("s4_B8H32_kv4096_p256",     8, 32, 4096, 256, 1.0, torch.float16),
    ("s5_B8H8_kv2048_p128_half", 8,  8, 2048, 128, 0.5, torch.float16),
    ("s6_B4H8_kv4096_p256_half", 4,  8, 4096, 256, 0.5, torch.float16),
    ("s7_bf16_B8H8_kv2048_p128", 8,  8, 2048, 128, 1.0, torch.bfloat16),
    ("s8_B2H32_kv16384_p256",    2, 32, 16384, 256, 1.0, torch.float16),
]
D = 128


def make_inputs(B, H, kv_rows, page_size, fill, dtype):
    W = (kv_rows + page_size - 1) // page_size
    pool_rows = W * page_size
    torch.manual_seed(0)
    q = torch.randn(B, 1, H, D, device=DEV, dtype=dtype) * 0.5
    kp = torch.randn(pool_rows, H, D, device=DEV, dtype=dtype) * 0.5
    vp = torch.randn(pool_rows, H, D, device=DEV, dtype=dtype) * 0.5
    full = W * page_size
    real = torch.full((B,), max(1, int(full * fill)), device=DEV, dtype=torch.int32)
    table = torch.arange(W, device=DEV, dtype=torch.int32).repeat(B, 1)
    return q, kp, vp, real, table


def calibrate_peak_tflops():
    """大 fp16 GEMM 实测可达峰值算力：2*N^3 FLOPs / 耗时。"""
    n = 8192
    a = torch.randn(n, n, device=DEV, dtype=torch.float16)
    b = torch.randn(n, n, device=DEV, dtype=torch.float16)
    for _ in range(3):
        torch.matmul(a, b)
    torch.npu.synchronize()
    t0 = time.perf_counter()
    for _ in range(10):
        torch.matmul(a, b)
    torch.npu.synchronize()
    ms = (time.perf_counter() - t0) * 1e3 / 10
    tflops = 2 * n**3 / (ms * 1e-3) / 1e12
    print(f"calibration: {n}^3 fp16 matmul {ms:.3f} ms -> achievable peak {tflops:.1f} TFLOPS")
    return tflops


def bench_one(name, B, H, kv_rows, page_size, fill, dtype):
    q, kp, vp, real, table = make_inputs(B, H, kv_rows, page_size, fill, dtype)
    op = MHADecodePagedWithKVCacheFwdOp(page_size, target="ascend")

    torch.npu.synchronize()
    t0 = time.perf_counter()
    op(q, kp, vp, real, table)
    torch.npu.synchronize()
    first_ms = (time.perf_counter() - t0) * 1e3

    for _ in range(WARMUP):
        op(q, kp, vp, real, table)
    torch.npu.synchronize()

    per_call = []
    for _ in range(REPEAT):
        torch.npu.synchronize()
        t0 = time.perf_counter()
        op(q, kp, vp, real, table)
        torch.npu.synchronize()
        per_call.append((time.perf_counter() - t0) * 1e3)

    t0 = time.perf_counter()
    for _ in range(REPEAT):
        op(q, kp, vp, real, table)
    torch.npu.synchronize()
    amort_ms = (time.perf_counter() - t0) * 1e3 / REPEAT

    real_sum = int(real.sum().item())
    flops = 4 * B * H * 1 * real_sum * D  # QK^T + PV，S_q=1
    med_us = statistics.median(per_call) * 1e3
    amort_us = amort_ms * 1e3
    row = {
        "name": name,
        "dtype": str(dtype).replace("torch.", ""),
        "first_ms": round(first_ms, 1),
        "median_ms": round(statistics.median(per_call), 3),
        "amortized_ms": round(amort_ms, 3),
        "real_sum": real_sum,
        "flops_G": round(flops / 1e9, 3),
        "median_TFLOPS": round(flops / (med_us * 1e-6) / 1e12, 3),
        "amortized_TFLOPS": round(flops / (amort_us * 1e-6) / 1e12, 3),
        "median_MFU": round(flops / (med_us * 1e-6) / 1e12 / float(PEAK_TFLOPS) * 100, 3),
        "amortized_MFU": round(flops / (amort_us * 1e-6) / 1e12 / float(PEAK_TFLOPS) * 100, 3),
    }
    print(
        f"{name:<28} {row['dtype']:<9} first={row['first_ms']:>8}ms "
        f"med={row['median_ms']:>8}ms amort={row['amortized_ms']:>8}ms "
        f"flops={row['flops_G']:>8}G med={row['median_TFLOPS']:>7}T "
        f"({row['median_MFU']:>6}%) amort={row['amortized_TFLOPS']:>7}T "
        f"({row['amortized_MFU']:>6}%)"
    )
    return row


def main():
    global PEAK_TFLOPS
    if PEAK_TFLOPS is None:
        PEAK_TFLOPS = calibrate_peak_tflops()
    print(f"peak_tflops={PEAK_TFLOPS} warmup={WARMUP} repeat={REPEAT} num_stages={NUM_STAGES}")
    rows = []
    for spec in SHAPES:
        try:
            rows.append(bench_one(*spec))
        except Exception as e:  # 单形状失败不拖垮整表
            import traceback
            traceback.print_exc()
            print(f"{spec[0]:<28} FAILED: {e}")
    print("MFU_JSON: " + json.dumps(rows, ensure_ascii=False))


if __name__ == "__main__":
    main()

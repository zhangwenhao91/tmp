import sys
import torch
import triton
import triton.language as tl

# 二分变体诊断：用法
#   KERNEL_PATH=/abs/path/6_gemm_v1.o python diag_gemm_variants.py 64 128 128 64
#   KERNEL_PATH=/abs/path/6_gemm_v2.o python diag_gemm_variants.py 16 64 128 16
# 参数：M K N BM（与编译产物形状一致，KERNEL_PATH 命中后 Triton 仅作 launch 载体）

M_, K_, N_, BM_ = (int(x) for x in sys.argv[1:5])


@triton.jit
def gemm_kernel(
    a_ptr, b_ptr, out_ptr, M, K: tl.constexpr, N: tl.constexpr,
    BM: tl.constexpr, BK: tl.constexpr, BN: tl.constexpr,
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BN)
    ks = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + ks[None, :])
    b = tl.load(b_ptr + ks[:, None] * N + cols[None, :])

    c = tl.dot(a, b)

    tl.store(out_ptr + rows[:, None] * N + cols[None, :], c)


if __name__ == "__main__":
    torch.manual_seed(0)
    a = torch.randn((M_, K_), device="npu", dtype=torch.bfloat16)
    b = torch.randn((K_, N_), device="npu", dtype=torch.bfloat16)

    out = torch.empty((M_, N_), dtype=torch.float32, device=a.device)
    gemm_kernel[(M_ // BM_,)](a, b, out, M_, K=K_, N=N_, BM=BM_, BK=K_, BN=N_)

    ref = a.to(torch.float32) @ b.to(torch.float32)
    torch.npu.synchronize()

    print(f"=== variant M={M_} K={K_} N={N_} BM={BM_} ===")
    print("=== ref (2x4) ===")
    print(ref[:2, :4])
    print("=== out (2x4) ===")
    print(out[:2, :4])

    diff = (out - ref).abs()
    print("=== stats ===")
    print(f"max |diff| = {diff.max().item():.4f}")
    print(f"mean |diff| = {diff.mean().item():.4f}")
    print(f"out is all zero: {(out == 0).all().item()}")
    print(f"out is nan: {out.isnan().any().item()}")

    row_bad = (diff > 0.1).any(dim=1)
    bad = row_bad.nonzero().flatten().tolist()
    print(f"bad rows (>0.1 diff): {bad[:16]}{' ...' if len(bad) > 16 else ''} (total {len(bad)}/{M_})")

    verdict = "PASS" if diff.max().item() < 0.1 else "FAIL"
    print(f"VERDICT: {verdict}")

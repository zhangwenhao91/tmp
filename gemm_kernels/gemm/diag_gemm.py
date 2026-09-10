import torch
import triton
import triton.language as tl

# 诊断版：不 assert，打印实际 vs 期望的数值模式，定位是搬运错位、
# 累加错误还是完全没算（全 0 / 垃圾值）。
BM = 16
BK = 128
BN = 128


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
    M, K, N = 32, 128, 128
    torch.manual_seed(0)
    a = torch.randn((M, K), device="npu", dtype=torch.bfloat16)
    b = torch.randn((K, N), device="npu", dtype=torch.bfloat16)

    out = torch.empty((M, N), dtype=torch.float32, device=a.device)
    gemm_kernel[(M // BM,)](a, b, out, M, K=K, N=N, BM=BM, BK=BK, BN=BN)

    ref = a.to(torch.float32) @ b.to(torch.float32)
    torch.npu.synchronize()

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

    # 每行错误分布：定位是行错位（搬运问题）还是整体错（计算问题）
    row_bad = (diff > 0.1).any(dim=1)
    print(f"bad rows (>0.1 diff): {row_bad.nonzero().flatten().tolist()}")

    # 检查半块模式：mix aiv 是 2 个子块各搬 8 行，看 0-7 / 8-15 是否分块正确
    print(f"row0 diff: {diff[0].abs().max().item():.4f}")
    print(f"row8 diff: {diff[8].abs().max().item():.4f}")
    print(f"row16 diff: {diff[16].abs().max().item():.4f}")

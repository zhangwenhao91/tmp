import torch
import triton
import triton.language as tl

# 契约对齐版：测试 shape 与 tilelang 0_gemm.py 定义一致——
#   A(32,128) bf16, B(128,128) bf16 -> OUT(32,128) fp32；
#   C = A @ B（cube 核 MAD.bf162f32，fp32 累加）；
#   T.Kernel(2)，每核 BM=16 行，BK=K=128，BN=N=128。
# triton kernel 仅作为参数/launch 载体（KERNEL_PATH 命中时加载预编译 .o）。
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

    a = tl.load(a_ptr + rows[:, None] * K + ks[None, :])  # (BM, BK) bf16
    b = tl.load(b_ptr + ks[:, None] * N + cols[None, :])  # (BK, BN) bf16

    c = tl.dot(a, b)  # fp32 累加，与 .o 的 MAD.bf162f32 语义一致

    tl.store(out_ptr + rows[:, None] * N + cols[None, :], c)


def run_gemm(a: torch.Tensor, b: torch.Tensor) -> torch.Tensor:
    a = a.contiguous()
    b = b.contiguous()
    M, K = a.shape
    K2, N = b.shape
    assert K == K2, f"K mismatch: {K} vs {K2}"
    assert K == BK and N == BN and M % BM == 0, (
        f"expect A(n*{BM}, {BK}) @ B({BK}, {BN}), got {a.shape} @ {b.shape}"
    )

    output = torch.empty((M, N), dtype=torch.float32, device=a.device)

    gemm_kernel[(M // BM,)](
        a,
        b,
        output,
        M,
        K=K,
        N=N,
        BM=BM,
        BK=BK,
        BN=BN,
    )

    return output


if __name__ == "__main__":
    M, K, N = 32, 128, 128
    a = torch.randn((M, K), device="npu", dtype=torch.bfloat16)
    b = torch.randn((K, N), device="npu", dtype=torch.bfloat16)

    triton_output = run_gemm(a, b)  # (32, 128) fp32

    # golden：同样的 bf16 输入按 fp32 精确累加
    torch_output = a.to(torch.float32) @ b.to(torch.float32)

    torch.npu.synchronize()
    assert torch.allclose(triton_output, torch_output, atol=1e-2), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

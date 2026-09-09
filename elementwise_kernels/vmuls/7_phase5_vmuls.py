import torch
import triton
import triton.language as tl

# 契约对齐版：测试 shape 与 tilelang 0_vmuls.py 定义一致——
#   A(32,128), S(1,) -> OUT(32,128)，逐元素标量乘法 OUT = A * S[0]；
#   T.Kernel(2)，每核 BR=16 行。
# triton kernel 仅作为参数/launch 载体（KERNEL_PATH 命中时加载预编译 .o）。
BM = 16
BK = 128


@triton.jit
def vmuls_kernel(
    a_ptr, s_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)
    s = tl.load(s_ptr)                                       # scalar

    c = a * s

    tl.store(out_ptr + rows[:, None] * K + cols[None, :], c)


def run_vmuls(a: torch.Tensor, s: torch.Tensor) -> torch.Tensor:
    a = a.contiguous()
    s = s.contiguous()
    M, K = a.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {a.shape}"
    assert s.numel() == 1, f"expect scalar (1,), got {s.shape}"

    output = torch.empty_like(a)

    vmuls_kernel[(M // BM,)](
        a,
        s,
        output,
        M,
        K=K,
        BM=BM,
        BK=BK,
    )

    return output


if __name__ == "__main__":
    M, K = 32, 128
    a = torch.randn((M, K), device="npu")
    s = torch.randn((1,), device="npu")

    triton_output = run_vmuls(a, s)  # (32, 128)

    torch_output = a * s

    torch.npu.synchronize()
    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

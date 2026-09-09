import torch
import triton
import triton.language as tl

# 契约对齐版：测试 shape 与 tilelang 0_vsub.py 定义一致——
#   A(32,128), B(32,128) -> OUT(32,128)，逐元素相加；T.Kernel(2)，每核 BR=16 行。
# triton kernel 仅作为参数/launch 载体（KERNEL_PATH 命中时加载预编译 .o）。
BM = 16
BK = 128


@triton.jit
def vsub_kernel(
    a_ptr, b_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)
    b = tl.load(b_ptr + rows[:, None] * K + cols[None, :])

    c = a + b

    tl.store(out_ptr + rows[:, None] * K + cols[None, :], c)


def run_vsub(a: torch.Tensor, b: torch.Tensor) -> torch.Tensor:
    a = a.contiguous()
    b = b.contiguous()
    M, K = a.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {a.shape}"

    output = torch.empty_like(a)

    vsub_kernel[(M // BM,)](
        a,
        b,
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
    b = torch.randn((M, K), device="npu")

    triton_output = run_vsub(a, b)  # (32, 128)

    torch_output = a + b

    torch.npu.synchronize()
    assert torch.allclose(triton_output.cpu(), torch_output.cpu(), atol=1e-5), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

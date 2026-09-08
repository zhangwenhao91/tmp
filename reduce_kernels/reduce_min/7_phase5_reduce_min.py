import torch
import triton
import triton.language as tl

# 契约对齐版：测试 shape 与 tilelang 0_reduce_min.py 定义一致——
#   A(32,128) -> OUT(32)，每行最小值；T.Kernel(2)，每核 BR=16 行。
# triton kernel 仅作为参数/launch 载体（KERNEL_PATH 命中时加载预编译 .o）。
BM = 16
BK = 128


@triton.jit
def reduce_min_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)

    r = tl.min(a, axis=1)  # (BM,) 每行最小值

    tl.store(out_ptr + rows, r)


def run_reduce_min(input_tensor: torch.Tensor) -> torch.Tensor:
    input_tensor = input_tensor.contiguous()
    M, K = input_tensor.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {input_tensor.shape}"

    output = torch.empty(M, device=input_tensor.device, dtype=input_tensor.dtype)

    reduce_min_kernel[(M // BM,)](
        input_tensor,
        output,
        M,
        K=K,
        BM=BM,
        BK=BK,
    )

    return output


if __name__ == "__main__":
    M, K = 32, 128
    input_tensor = torch.randn((M, K), device="npu")

    triton_output = run_reduce_min(input_tensor)  # (32,)

    torch_output = input_tensor.min(dim=1).values  # (32,)

    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output:", triton_output)
    print("\nSample Input (First 2x4 values):")
    print(input_tensor[:2, :4])

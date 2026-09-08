import torch
import triton
import triton.language as tl

# 契约对齐版（驱动预编译 kernel.o）：
# 与 6_reduce_max.o 的固化形状逐项一致——
#   .o:  T.Kernel(M//BR=2) 网格，每核直排处理 BR=16 行，K=128 整行归约
#        A(32,128) -> OUT(32)，kernel 符号名 reduce_max_kernel
# triton kernel 仅作为参数/launch 载体（后端 KERNEL_PATH 命中时直接加载 .o），
# 因此形状必须与 .o 对齐：输入 (32,128)，grid=(2,)，每块 16 行。
# 未设 KERNEL_PATH 时则回退为 triton 真实编译（语义相同）。
BM = 16
BK = 128


@triton.jit
def reduce_max_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)

    r = tl.max(a, axis=1)  # (BM,) 每行最大值

    tl.store(out_ptr + rows, r)


def run_reduce_max(input_tensor: torch.Tensor) -> torch.Tensor:
    input_tensor = input_tensor.contiguous()
    M, K = input_tensor.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {input_tensor.shape}"

    output = torch.empty(M, device=input_tensor.device, dtype=input_tensor.dtype)

    reduce_max_kernel[(M // BM,)](
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

    triton_output = run_reduce_max(input_tensor)  # (32,)

    torch_output = input_tensor.max(dim=1).values  # (32,)

    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output:", triton_output)
    print("\nSample Input (First 2x4 values):")
    print(input_tensor[:2, :4])

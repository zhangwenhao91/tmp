import torch
import triton
import triton.language as tl

# 自适应分块版：把单 block 全量归约拆成多个 block（每 block 至多 CHUNK 个元素），
# 规避单 block 向量规模超出 NPU UB/向量指令限制导致的 MTE/地址对齐错误。
CHUNK = 1024


@triton.jit
def reduce_abs_sum_kernel(
    input_ptr, output_ptr, num_elements, BLOCK_SIZE: tl.constexpr
):
    pid = tl.program_id(axis=0)
    offsets = pid * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < num_elements

    input_data = tl.load(input_ptr + offsets, mask=mask, other=0.0)

    # abs(x) = max(x, -x)
    abs_data = tl.maximum(input_data, -input_data)

    total = tl.sum(abs_data, axis=0)

    tl.store(output_ptr + pid, total)


def run_reduce_abs_sum(input_tensor: torch.Tensor) -> torch.Tensor:
    input_tensor = input_tensor.contiguous().flatten()
    num_elements = input_tensor.numel()

    BLOCK_SIZE = triton.next_power_of_2(CHUNK)
    num_blocks = triton.cdiv(num_elements, BLOCK_SIZE)

    output = torch.empty(num_blocks, device=input_tensor.device, dtype=input_tensor.dtype)

    reduce_abs_sum_kernel[(num_blocks,)](
        input_tensor,
        output,
        num_elements,
        BLOCK_SIZE=BLOCK_SIZE,
    )

    # 各 block 部分和汇总
    return output.sum()


if __name__ == "__main__":
    input_tensor = torch.randn((128, 64), device="npu")

    triton_output = run_reduce_abs_sum(input_tensor)

    torch_output = input_tensor.abs().sum()

    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output:", triton_output.item())
    print("\nSample Input (First 2x4 values):")
    print(input_tensor.view(128, 64)[:2, :4])

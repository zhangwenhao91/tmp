import torch
import triton
import triton.language as tl


@triton.jit
def reduce_sum_kernel(
    input_ptr, output_ptr, num_elements, BLOCK_SIZE: tl.constexpr
):
    pid = tl.program_id(axis=0)
    offsets = pid * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < num_elements

    input_data = tl.load(input_ptr + offsets, mask=mask, other=0.0)

    total = tl.sum(input_data, axis=0)

    tl.store(output_ptr + pid, total)


def run_reduce_sum(input_tensor: torch.Tensor) -> torch.Tensor:
    input_tensor = input_tensor.contiguous().flatten()
    num_elements = input_tensor.numel()
    BLOCK_SIZE = triton.next_power_of_2(num_elements)

    output = torch.empty(1, device=input_tensor.device, dtype=input_tensor.dtype)

    reduce_sum_kernel[(1,)](
        input_tensor,
        output,
        num_elements,
        BLOCK_SIZE=BLOCK_SIZE,
    )

    return output[0]


if __name__ == "__main__":
    input_tensor = torch.randn((128, 64), device="npu")

    triton_output = run_reduce_sum(input_tensor)

    torch_output = input_tensor.sum()

    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output:", triton_output.item())
    print("\nSample Input (First 2x4 values):")
    print(input_tensor.view(128, 64)[:2, :4])

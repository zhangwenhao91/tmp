import torch
import triton
import triton.language as tl


@triton.jit
def vadd_kernel(
    a_ptr,
    b_ptr,
    output_ptr,
    num_elements,
    BLOCK_SIZE: tl.constexpr,
):
    # Program ID is 0 since grid=1
    pid = tl.program_id(axis=0)

    # Compute element offsets for the 1D block
    offsets = pid * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)

    # Mask to keep memory access within bounds
    mask = offsets < num_elements

    # Load input tensors from GPU memory
    a = tl.load(a_ptr + offsets, mask=mask)
    b = tl.load(b_ptr + offsets, mask=mask)

    # Elementwise addition
    output = a + b

    # Store result back to GPU memory
    tl.store(output_ptr + offsets, output, mask=mask)


def run_vadd(a: torch.Tensor, b: torch.Tensor) -> torch.Tensor:
    # Ensure inputs are contiguous float tensors on CUDA
    a = a.contiguous()
    b = b.contiguous()
    output = torch.empty_like(a)

    num_elements = a.numel()  # 128 * 64 = 8192

    # Set block size to cover all 8192 elements in one call
    BLOCK_SIZE = triton.next_power_of_2(num_elements)  # 8192

    # Launch kernel with grid = 1
    vadd_kernel[(1,)](
        a,
        b,
        output,
        num_elements,
        BLOCK_SIZE=BLOCK_SIZE,
    )

    return output


# --- Verification ---
if __name__ == "__main__":
    # Create two [128, 64] input tensors
    a = torch.randn((128, 64), device="npu")
    b = torch.randn((128, 64), device="npu")

    # Run Triton kernel
    triton_output = run_vadd(a, b)

    # PyTorch reference check
    torch_output = a + b

    # Verify correctness
    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

import torch
import triton
import triton.language as tl

# 对照 dsl/phase5_vsub.py 与 phase5_vsub.mlir: C = A - B (128x64 f32)


@triton.jit
def vsub_kernel(
    a_ptr, b_ptr, output_ptr, num_elements, BLOCK_SIZE: tl.constexpr
):
    pid = tl.program_id(axis=0)

    offsets = pid * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < num_elements

    a = tl.load(a_ptr + offsets, mask=mask)
    b = tl.load(b_ptr + offsets, mask=mask)

    output = a - b

    tl.store(output_ptr + offsets, output, mask=mask)


def run_vsub(a: torch.Tensor, b: torch.Tensor) -> torch.Tensor:
    a = a.contiguous()
    b = b.contiguous()
    output = torch.empty_like(a)

    num_elements = a.numel()  # 8192
    BLOCK_SIZE = triton.next_power_of_2(num_elements)

    vsub_kernel[(1,)](
        a,
        b,
        output,
        num_elements,
        BLOCK_SIZE=BLOCK_SIZE,
    )

    return output


if __name__ == "__main__":
    a = torch.randn((128, 64), device="npu")
    b = torch.randn((128, 64), device="npu")

    triton_output = run_vsub(a, b)

    a = a.cpu()
    b = b.cpu()
    torch_output = a - b
    triton_output = triton_output.cpu()

    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

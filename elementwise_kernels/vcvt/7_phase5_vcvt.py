import torch
import triton
import triton.language as tl

# 契约对齐版：测试 shape 与 tilelang 0_vcvt.py 定义一致——
#   A(32,128) fp32 -> OUT(32,128) fp16，类型转换；
#   T.Kernel(2)，每核 BR=16 行。
# triton kernel 仅作为参数/launch 载体（KERNEL_PATH 命中时加载预编译 .o）。
BM = 16
BK = 128


@triton.jit
def vcvt_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK) fp32

    c = a.to(tl.float16)

    tl.store(out_ptr + rows[:, None] * K + cols[None, :], c)


def run_vcvt(a: torch.Tensor) -> torch.Tensor:
    a = a.contiguous()
    M, K = a.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {a.shape}"

    output = torch.empty((M, K), dtype=torch.float16, device=a.device)

    vcvt_kernel[(M // BM,)](
        a,
        output,
        M,
        K=K,
        BM=BM,
        BK=BK,
    )

    return output


if __name__ == "__main__":
    M, K = 32, 128
    a = torch.randn((M, K), dtype=torch.float32, device="npu")

    triton_output = run_vcvt(a)  # (32, 128) fp16

    torch_output = a.to(torch.float16)

    torch.npu.synchronize()
    assert torch.allclose(triton_output, torch_output, atol=1e-3), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape, "dtype:", triton_output.dtype)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

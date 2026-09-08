import torch
import triton
import triton.language as tl

# E1 实验：A + A -> OUT（2 张量，3 参数：2 ptr + 1 i32）
# 目的：验证把 vadd 从 4 参数降到 3 参数（与能跑通的 reduce_max 同构）
# 后 NPU 上能否跑通。跑通 => 4 参数 ABI 是问题；仍超时 => 寻址等其他原因。
# 用法：export KERNEL_PATH=$PWD/6_vadd_e1.o && python 7_phase5_vadd_e1.py
BM = 16
BK = 128


@triton.jit
def vadd_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)

    out = a + a  # E1: 同一张量自加

    tl.store(out_ptr + rows[:, None] * K + cols[None, :], out)


def run_vadd_e1(a: torch.Tensor) -> torch.Tensor:
    a = a.contiguous()
    M, K = a.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {a.shape}"

    output = torch.empty_like(a)

    vadd_kernel[(M // BM,)](
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
    a = torch.randn((M, K), device="npu")

    triton_output = run_vadd_e1(a)  # (32, 128)

    torch_output = a + a  # (32, 128)

    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

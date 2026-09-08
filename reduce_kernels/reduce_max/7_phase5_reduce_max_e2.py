import torch
import triton
import triton.language as tl

# E2 实验：reduce_max 双输出（3 张量，4 参数：3 ptr + 1 i32）
# 目的：给已知能跑通的 reduce_max（3 参数）加上第 3 个张量参数，
# 验证 4 参数 ABI 是否会导致 NPU 超时。
#   跑通 => 4 参数没问题，vadd 失败另有原因（寻址）；
#   超时 => 4 参数 ABI 就是根因。
# 用法：export KERNEL_PATH=$PWD/6_reduce_max_e2.o && python 7_phase5_reduce_max_e2.py
BM = 16
BK = 128


@triton.jit
def reduce_max_kernel(
    a_ptr, out1_ptr, out2_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)

    r = tl.max(a, axis=1)  # (BM,) 每行最大值

    tl.store(out1_ptr + rows, r)
    tl.store(out2_ptr + rows, r)  # E2: 双输出


def run_reduce_max_e2(input_tensor: torch.Tensor) -> tuple:
    input_tensor = input_tensor.contiguous()
    M, K = input_tensor.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {input_tensor.shape}"

    out1 = torch.empty(M, device=input_tensor.device, dtype=input_tensor.dtype)
    out2 = torch.empty(M, device=input_tensor.device, dtype=input_tensor.dtype)

    reduce_max_kernel[(M // BM,)](
        input_tensor,
        out1,
        out2,
        M,
        K=K,
        BM=BM,
        BK=BK,
    )

    return out1, out2


if __name__ == "__main__":
    M, K = 32, 128
    input_tensor = torch.randn((M, K), device="npu")

    out1, out2 = run_reduce_max_e2(input_tensor)  # 两个 (32,)

    torch_output = input_tensor.max(dim=1).values  # (32,)

    assert torch.allclose(out1, torch_output, atol=1e-5), "out1 does not match!"
    assert torch.allclose(out2, torch_output, atol=1e-5), "out2 does not match!"
    print("Success! Output:", out1)
    print("\nSample Input (First 2x4 values):")
    print(input_tensor[:2, :4])

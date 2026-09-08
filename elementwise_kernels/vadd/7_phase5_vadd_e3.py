import torch
import triton
import triton.language as tl

# E3 实验：vadd 静态寻址重写版（3 张量，4 参数，与原版参数 ABI 相同）
# 唯一差异：5_vadd_e3.ll 中 vldsx1/vstsx1 的寻址从
#   "null 基址 + i32 动态 offset 参数" 改为 golden 版
#   "getelementptr 指针寻址 + offset=0"。
# 目的：验证 NPU 超时是否由动态 i32 offset 寻址模式引起。
#   跑通 => 寻址模式是根因，后续所有算子按 golden 寻址模式生成 .ll；
#   仍超时 => 排除寻址，聚焦参数 ABI（看 E1/E2 结果）。
# 用法：export KERNEL_PATH=$PWD/6_vadd_e3.o && python 7_phase5_vadd_e3.py
BM = 16
BK = 128


@triton.jit
def vadd_kernel(
    a_ptr, b_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)
    b = tl.load(b_ptr + rows[:, None] * K + cols[None, :])  # (BM, BK)

    out = a + b  # 逐元素加

    tl.store(out_ptr + rows[:, None] * K + cols[None, :], out)


def run_vadd(a: torch.Tensor, b: torch.Tensor) -> torch.Tensor:
    a = a.contiguous()
    b = b.contiguous()
    M, K = a.shape
    assert K == BK and M % BM == 0, f"expect shape (n*{BM}, {BK}), got {a.shape}"

    output = torch.empty_like(a)

    vadd_kernel[(M // BM,)](
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

    triton_output = run_vadd(a, b)  # (32, 128)

    torch_output = a + b  # (32, 128)

    assert torch.allclose(triton_output, torch_output, atol=1e-5), "Outputs do not match!"
    print("Success! Output shape:", triton_output.shape)
    print("\nSample Output (First 2x4 values):")
    print(triton_output[:2, :4])

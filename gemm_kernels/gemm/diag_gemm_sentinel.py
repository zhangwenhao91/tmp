import sys
import torch
import triton
import triton.language as tl

# Sentinel 诊断：输出预填 777.0，跑 kernel 后检查输出是否被改写。
#   - 仍全为 777      => kernel 输出路径完全没生效（没 launch / 没写 GM / 写错地址）
#   - 部分被改写      => 写了，看模式定位（值错 vs 地址错）
#   - 全被改写但值错  => 搬运 OK，计算/累加错误
# 用法: KERNEL_PATH=/abs/6_gemm.o python diag_gemm_sentinel.py 32 128 128 16
#       KERNEL_PATH=/abs/6_gemm_v1.o python diag_gemm_sentinel.py 64 128 128 64
#       KERNEL_PATH=/abs/6_gemm_v2.o python diag_gemm_sentinel.py 16 64 128 16

M_, K_, N_, BM_ = (int(x) for x in sys.argv[1:5])


@triton.jit
def gemm_kernel(
    a_ptr, b_ptr, out_ptr, M, K: tl.constexpr, N: tl.constexpr,
    BM: tl.constexpr, BK: tl.constexpr, BN: tl.constexpr,
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BN)
    ks = tl.arange(0, BK)

    a = tl.load(a_ptr + rows[:, None] * K + ks[None, :])
    b = tl.load(b_ptr + ks[:, None] * N + cols[None, :])

    c = tl.dot(a, b)

    tl.store(out_ptr + rows[:, None] * N + cols[None, :], c)


def run_once(a, b, out):
    gemm_kernel[(M_ // BM_,)](a, b, out, M_, K=K_, N=N_, BM=BM_, BK=K_, BN=N_)
    torch.npu.synchronize()
    sentinel_cnt = (out == 777.0).sum().item()
    total = out.numel()
    print(f"  sentinel 777 remaining: {sentinel_cnt}/{total}")
    print(f"  out[:2,:4] =\n{out[:2, :4]}")
    nan_cnt = out.isnan().sum().item()
    print(f"  nan count: {nan_cnt}")
    return sentinel_cnt


if __name__ == "__main__":
    torch.manual_seed(0)
    a = torch.randn((M_, K_), device="npu", dtype=torch.bfloat16)
    b = torch.randn((K_, N_), device="npu", dtype=torch.bfloat16)
    ref = a.to(torch.float32) @ b.to(torch.float32)

    print(f"=== sentinel diag M={M_} K={K_} N={N_} BM={BM_} ===")

    print("[run 1] out pre-filled with 777.0")
    out1 = torch.full((M_, N_), 777.0, dtype=torch.float32, device="npu")
    s1 = run_once(a, b, out1)

    print("[run 2] same, second launch on same buffer")
    s2 = run_once(a, b, out1)

    print("[run 3] fresh buffer pre-filled 777.0 again")
    out2 = torch.full((M_, N_), 777.0, dtype=torch.float32, device="npu")
    s3 = run_once(a, b, out2)

    print("=== verdict ===")
    if s1 == out1.numel():
        print("OUTPUT NOT WRITTEN AT ALL: kernel did not write GM (launch/sync/address issue)")
    elif s1 > 0:
        print(f"OUTPUT PARTIALLY WRITTEN: {s1} cells untouched — address/layout mismatch")
    else:
        print("OUTPUT FULLY WRITTEN: values wrong — computation/accumulation issue")
        diff = (out1 - ref).abs()
        print(f"  max |diff| = {diff.max().item():.4f}")
        print(f"  ref[:2,:4] =\n{ref[:2, :4]}")

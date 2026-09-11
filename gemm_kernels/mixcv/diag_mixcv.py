import sys
import torch
import triton
import triton.language as tl

# mixCV 诊断: OUT = A @ B + C  (全 float32, mix 模式 AIC cube + AIV vector)
# Sentinel: OUT 预填 777.0, 跑 kernel 后检查改写情况。
# 用法: KERNEL_PATH=$PWD/6_mixcv_v2.o KERNEL_CV_MODE=mix python diag_mixcv.py 16 128 128

M_, K_, N_ = (int(x) for x in sys.argv[1:4])


@triton.jit
def mixcv_kernel(
    a_ptr, b_ptr, c_ptr, out_ptr, M, K: tl.constexpr, N: tl.constexpr,
):
    pid = tl.program_id(axis=0)
    rows = pid * M + tl.arange(0, M)
    cols = tl.arange(0, N)
    ks = tl.arange(0, K)

    a = tl.load(a_ptr + rows[:, None] * K + ks[None, :])
    b = tl.load(b_ptr + ks[None, :] * N + cols[None, :])
    c = tl.load(c_ptr + rows[:, None] * N + cols[None, :])

    acc = tl.dot(a, b) + c

    tl.store(out_ptr + rows[:, None] * N + cols[None, :], acc)


def run_once(a, b, c, out):
    mixcv_kernel[(1,)](a, b, c, out, M_, K=K_, N=N_)
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
    a = torch.randn((M_, K_), device="npu", dtype=torch.float32)
    b = torch.randn((K_, N_), device="npu", dtype=torch.float32)
    c = torch.randn((M_, N_), device="npu", dtype=torch.float32)
    ref = a @ b + c

    print(f"=== mixcv diag M={M_} K={K_} N={N_} ===")

    print("[run 1] out pre-filled with 777.0")
    out1 = torch.full((M_, N_), 777.0, dtype=torch.float32, device="npu")
    s1 = run_once(a, b, c, out1)

    print("[run 2] same, second launch on same buffer")
    s2 = run_once(a, b, c, out1)

    print("[run 3] fresh buffer pre-filled 777.0 again")
    out2 = torch.full((M_, N_), 777.0, dtype=torch.float32, device="npu")
    s3 = run_once(a, b, c, out2)

    print("=== verdict ===")
    if s1 == out1.numel():
        print("OUTPUT NOT WRITTEN AT ALL: kernel did not write GM (launch/sync/address issue)")
    elif s1 > 0:
        print(f"OUTPUT PARTIALLY WRITTEN: {s1} cells untouched — address/layout mismatch")
    else:
        print("OUTPUT FULLY WRITTEN: checking values vs golden a@b+c")
        diff = (out1 - ref).abs()
        print(f"  max |diff| = {diff.max().item():.4f}")
        print(f"  ref[:2,:4] =\n{ref[:2, :4]}")

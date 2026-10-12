"""在 NPU 上运行 reduce_api_kernels 产出的 .o 并验证精度（vreduce 路线）。

用法（需先 export KERNEL_PATH 指向对应 .o）:
    export KERNEL_PATH=/abs/path/reduce_sum/6_reduce_sum_frag.o
    python verify_precision.py reduce_sum

op ∈ reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax

说明：triton kernel 仅作为参数/launch 载体，KERNEL_PATH 命中时 runtime 会加载
预编译 .o 替换掉 JIT 结果（见 misc/patch_installed_kernel_path.py）。
载体 kernel 名必须与 .o 导出的符号名一致（即 <op>_frag_kernel）。
"""

import os
import sys

import torch
import triton
import triton.language as tl

M, K, BM, BK = 32, 128, 16, 128


@triton.jit
def reduce_sum_frag_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(a, axis=1))


@triton.jit
def reduce_max_frag_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(a, axis=1))


@triton.jit
def reduce_min_frag_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.min(a, axis=1))


@triton.jit
def reduce_abssum_frag_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(tl.abs(a), axis=1))


@triton.jit
def reduce_absmax_frag_kernel(
    a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr
):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(tl.abs(a), axis=1))


KERNELS = {
    "reduce_sum": reduce_sum_frag_kernel,
    "reduce_max": reduce_max_frag_kernel,
    "reduce_min": reduce_min_frag_kernel,
    "reduce_abssum": reduce_abssum_frag_kernel,
    "reduce_absmax": reduce_absmax_frag_kernel,
}

REFS = {
    "reduce_sum": lambda a: a.sum(dim=1),
    "reduce_max": lambda a: a.amax(dim=1),
    "reduce_min": lambda a: a.amin(dim=1),
    "reduce_abssum": lambda a: a.abs().sum(dim=1),
    "reduce_absmax": lambda a: a.abs().amax(dim=1),
}


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: python verify_precision.py <op>", file=sys.stderr)
        return 2
    op = sys.argv[1]
    if op not in KERNELS:
        print(f"unknown op: {op}", file=sys.stderr)
        return 2

    kpath = os.environ.get("KERNEL_PATH", "")
    if not kpath or not os.path.isfile(kpath):
        print(f"KERNEL_PATH not set or not a file: {kpath!r}", file=sys.stderr)
        return 2

    torch.manual_seed(0)
    a = torch.randn((M, K), device="npu", dtype=torch.float32)
    out = torch.empty(M, device="npu", dtype=torch.float32)

    KERNELS[op][(M // BM,)](a, out, M, K=K, BM=BM, BK=BK)

    got = out.cpu()
    ref = REFS[op](a.cpu()).to(torch.float32)
    diff = (got - ref).abs().max().item()
    ok = torch.allclose(got, ref, atol=1e-3, rtol=1e-3)

    tag = "PASS" if ok else "FAIL"
    print(f"[{tag}] {op}  diff={diff:.3e}  kernel={os.path.basename(kpath)}")
    if not ok:
        print("  got[:8]:", got[:8].tolist())
        print("  ref[:8]:", ref[:8].tolist())
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
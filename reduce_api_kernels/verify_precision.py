"""在 NPU 上运行 reduce_api_kernels 产出的 .o 并验证精度。

用法（需先 export KERNEL_PATH 指向对应 .o）:
    export KERNEL_PATH=/abs/path/reduce_sum/6_reduce_sum_shared_float16_32x128.o
    python verify_precision.py reduce_sum shared float16 32 128

参数: <op> <form> <dtype> <M> <K>
  op    ∈ reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax
  form  ∈ frag shared thread
  dtype ∈ float16 bfloat16 float32 int8 int16 int32（各 op/form 的可行域见 _dsl.MATRIX）
  M, K  形状（M 必须是 BR=16 的整数倍；K 为列数）

说明：triton kernel 仅作为参数/launch 载体，KERNEL_PATH 命中时 runtime 会加载
预编译 .o 替换掉 JIT 结果（见 misc/patch_installed_kernel_path.py）。载体 kernel
名固定为 <op>_<form>_kernel，与 .o 导出的符号名一致；dtype/shape 变体共享同一符号名，
靠 KERNEL_PATH 逐次替换。

容差：dtype 相关默认值见 TOL，可用环境变量 ATOL / RTOL 覆盖。
"""

import os
import sys

import torch
import triton
import triton.language as tl

BM = 16  # 与 DSL 的 BR 一致：每 block 处理 BM 行


# 每个 (op, form) 的载体 kernel：名必须与 .o 导出的符号名一致（<op>_<form>_kernel）。
# 同一算子的不同形态（frag/shared/thread）载体主体相同，只是名字不同；dtype/shape
# 通过指针 dtype 与 K/BM/BK 的 constexpr 体现。


@triton.jit
def reduce_sum_frag_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(a, axis=1))


@triton.jit
def reduce_sum_shared_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(a, axis=1))


@triton.jit
def reduce_sum_thread_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(a, axis=1))


@triton.jit
def reduce_max_frag_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(a, axis=1))


@triton.jit
def reduce_max_shared_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(a, axis=1))


@triton.jit
def reduce_max_thread_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(a, axis=1))


@triton.jit
def reduce_min_frag_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.min(a, axis=1))


@triton.jit
def reduce_min_shared_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.min(a, axis=1))


@triton.jit
def reduce_min_thread_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.min(a, axis=1))


@triton.jit
def reduce_abssum_frag_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(tl.abs(a), axis=1))


@triton.jit
def reduce_abssum_shared_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(tl.abs(a), axis=1))


@triton.jit
def reduce_abssum_thread_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.sum(tl.abs(a), axis=1))


@triton.jit
def reduce_absmax_frag_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(tl.abs(a), axis=1))


@triton.jit
def reduce_absmax_shared_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(tl.abs(a), axis=1))


@triton.jit
def reduce_absmax_thread_kernel(a_ptr, out_ptr, M, K: tl.constexpr, BM: tl.constexpr, BK: tl.constexpr):
    pid = tl.program_id(axis=0)
    rows = pid * BM + tl.arange(0, BM)
    cols = tl.arange(0, BK)
    a = tl.load(a_ptr + rows[:, None] * K + cols[None, :])
    tl.store(out_ptr + rows, tl.max(tl.abs(a), axis=1))


KERNELS = {
    ("reduce_sum", "frag"): reduce_sum_frag_kernel,
    ("reduce_max", "frag"): reduce_max_frag_kernel,
    ("reduce_min", "frag"): reduce_min_frag_kernel,
    ("reduce_abssum", "frag"): reduce_abssum_frag_kernel,
    ("reduce_absmax", "frag"): reduce_absmax_frag_kernel,
    ("reduce_sum", "shared"): reduce_sum_shared_kernel,
    ("reduce_max", "shared"): reduce_max_shared_kernel,
    ("reduce_min", "shared"): reduce_min_shared_kernel,
    ("reduce_abssum", "shared"): reduce_abssum_shared_kernel,
    ("reduce_absmax", "shared"): reduce_absmax_shared_kernel,
    ("reduce_sum", "thread"): reduce_sum_thread_kernel,
    ("reduce_max", "thread"): reduce_max_thread_kernel,
    ("reduce_min", "thread"): reduce_min_thread_kernel,
    ("reduce_abssum", "thread"): reduce_abssum_thread_kernel,
    ("reduce_absmax", "thread"): reduce_absmax_thread_kernel,
}

REFS = {
    "reduce_sum": lambda a: a.sum(dim=1),
    "reduce_max": lambda a: a.amax(dim=1),
    "reduce_min": lambda a: a.amin(dim=1),
    "reduce_abssum": lambda a: a.abs().sum(dim=1),
    "reduce_absmax": lambda a: a.abs().amax(dim=1),
}

DTYPE_MAP = {
    "float16": torch.float16,
    "bfloat16": torch.bfloat16,
    "float32": torch.float32,
    "int8": torch.int8,
    "int16": torch.int16,
    "int32": torch.int32,
}
INT_DTYPES = {"int8", "int16", "int32"}
# 整型输入取值范围：控制量级避免累加溢出（int8/int16 只用于 max/min/absmax，int32 用于 sum）
INT_RANGE = {"int8": (-8, 8), "int16": (-1024, 1024), "int32": (-100000, 100000)}
# (atol, rtol)
# 注：NPU 上 reduce 沿 K 按元素类型累加，K 越大累积误差越大；真值接近 0 的行
# 上 rtol 失效，只能靠 atol 兜底。实测 reduce_sum 在 K=512 时 fp16 误差 ~5.1e-2、
# bf16 ~6.7e-2，故二者 atol 取 1e-1（输入由 seed=0 固定，diff 确定、无随机波动）。
TOL = {
    "float32": (1e-3, 1e-3),
    "float16": (1e-1, 2e-2),
    "bfloat16": (1e-1, 2e-2),
}


def parse_args(argv):
    if len(argv) != 6:
        print("usage: python verify_precision.py <op> <form> <dtype> <M> <K>", file=sys.stderr)
        raise SystemExit(2)
    op, form, dtype, M, K = argv[1], argv[2], argv[3], int(argv[4]), int(argv[5])
    if (op, form) not in KERNELS:
        print(f"no carrier registered for {op}/{form}", file=sys.stderr)
        raise SystemExit(2)
    if dtype not in DTYPE_MAP:
        print(f"unknown dtype: {dtype}", file=sys.stderr)
        raise SystemExit(2)
    if M % BM != 0:
        print(f"M={M} must be a multiple of BM={BM}", file=sys.stderr)
        raise SystemExit(2)
    return op, form, dtype, M, K


def make_input(op, dtype, M, K):
    td = DTYPE_MAP[dtype]
    if dtype in INT_DTYPES:
        lo, hi = INT_RANGE[dtype]
        base = torch.randint(lo, hi, (M, K), device="npu", dtype=torch.int32)
    else:
        base = torch.randn((M, K), device="npu", dtype=torch.float32)
    return base.to(td)


def main() -> int:
    op, form, dtype, M, K = parse_args(sys.argv)

    kpath = os.environ.get("KERNEL_PATH", "")
    if not kpath or not os.path.isfile(kpath):
        print(f"KERNEL_PATH not set or not a file: {kpath!r}", file=sys.stderr)
        return 2

    torch.manual_seed(0)
    a = make_input(op, dtype, M, K)
    out = torch.empty(M, device="npu", dtype=DTYPE_MAP[dtype])

    tag = f"{op}/{form}/{dtype}/{M}x{K}"
    try:
        KERNELS[(op, form)][(M // BM,)](a, out, M, K=K, BM=BM, BK=K)
    except Exception as exc:  # noqa: BLE001
        print(f"[FAIL] {tag}  launch error: {type(exc).__name__}: {exc}")
        return 1

    got = out.cpu()
    if dtype in INT_DTYPES:
        ref = REFS[op](a.cpu().to(torch.int64))
        got_i, ref_i = got.to(torch.int64), ref.to(torch.int64)
        diff = (got_i - ref_i).abs().max().item()
        ok = bool(torch.equal(got_i, ref_i))
    else:
        ref = REFS[op](a.cpu().float()).to(torch.float32)
        got_f, ref_f = got.float(), ref.float()
        diff = (got_f - ref_f).abs().max().item()
        atol = float(os.environ.get("ATOL", TOL[dtype][0]))
        rtol = float(os.environ.get("RTOL", TOL[dtype][1]))
        ok = bool(torch.allclose(got_f, ref_f, atol=atol, rtol=rtol))

    print(f"[{'PASS' if ok else 'FAIL'}] {tag}  diff={diff:.3e}  kernel={os.path.basename(kpath)}")
    if not ok:
        print("  got[:8]:", got[:8].tolist())
        print("  ref[:8]:", ref[:8].tolist())
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
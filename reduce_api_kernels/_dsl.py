"""reduce_api_kernels 共享 DSL 生成器（stage0 生产者）。

按 MATRIX（算子 x 形态 x 实测可行 dtype）x SHAPES 生成 stage0 TileLangIR：
    1_<op>_<form>_<dtype>_<M>x<K>_tilelangir.mlir

导出符号名固定为 <op>_<form>_kernel（与 verify_precision.py 的载体名一致）。
同一 (op, form) 的 dtype/shape 变体共享同一符号名，运行时靠 KERNEL_PATH 逐次替换，
因此 610 个变体的 .o 都导出同一个短名即可。

形态说明：
  frag    SimdVF 内 frag->frag
          - sum/max 走 vreduce_* 直连；
          - min/abssum/absmax 因无 vreduce_min/abs 原语，用 (-1) 乘法 + vmax 合成
            （-1 常量用 tirx.const(-1.0, dtype) 生成，以支持 f16/bf16/int；写死
             python float 会与 dtype 冲突，见 build.sh 头注释）。
  shared  SimdVF 内 shared->shared（T.reduce_<op> 宏经 fragment 中转）
  thread  线程域内 shared->shared（translator 自动把 reduce 岛包进 simd scope）

dtype 可行域来源：build.sh 头注释记录的本机全链路实测。
"""

import os

import tilelang
import tilelang.language as T
from tvm import tirx

BR = 16

SHAPES = [
    (16, 64), (16, 128), (32, 64), (32, 128), (32, 256),
    (64, 128), (64, 256), (64, 512), (128, 256), (128, 512),
]

_FLOAT_INT_32 = ["float16", "bfloat16", "float32", "int32"]
_F16_F32_I8_I16_I32 = ["float16", "float32", "int8", "int16", "int32"]
_F16_F32 = ["float16", "float32"]

MATRIX = {
    "reduce_sum": {
        "frag": _FLOAT_INT_32,
        "shared": _FLOAT_INT_32,
        "thread": _FLOAT_INT_32,
    },
    "reduce_max": {
        "frag": _F16_F32_I8_I16_I32,
        "shared": _F16_F32_I8_I16_I32,
        "thread": _F16_F32_I8_I16_I32,
    },
    "reduce_min": {
        "frag": _F16_F32_I8_I16_I32,
        "shared": _F16_F32_I8_I16_I32,
        "thread": _F16_F32_I8_I16_I32,
    },
    "reduce_abssum": {
        "frag": ["float16", "bfloat16", "float32", "int32"],
        "shared": ["float16", "bfloat16", "float32"],
        "thread": ["float16", "bfloat16", "float32"],
    },
    "reduce_absmax": {
        "frag": _F16_F32_I8_I16_I32,
        "shared": _F16_F32,
        "thread": _F16_F32,
    },
}

REDUCE = {
    "reduce_sum": T.reduce_sum,
    "reduce_max": T.reduce_max,
    "reduce_min": T.reduce_min,
    "reduce_abssum": T.reduce_abssum,
    "reduce_absmax": T.reduce_absmax,
}


def _shared(op, dtype, M, K):
    red = REDUCE[op]

    def kern(A: T.Buffer((M, K), dtype), OUT: T.Buffer((M,), dtype)):
        with T.Kernel(M // BR) as bx:
            a_s = T.alloc_shared((BR, K), dtype)
            o_s = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR:(bx + 1) * BR, 0:K], a_s)
            with T.SimdVF():
                red(a_s, o_s, dim=1)
            T.copy(o_s, OUT[bx * BR:(bx + 1) * BR])

    kern.__name__ = f"{op}_shared_kernel"
    return T.prim_func(kern)


def _thread(op, dtype, M, K):
    red = REDUCE[op]

    def kern(A: T.Buffer((M, K), dtype), OUT: T.Buffer((M,), dtype)):
        with T.Kernel(M // BR) as bx:
            a_s = T.alloc_shared((BR, K), dtype)
            o_s = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR:(bx + 1) * BR, 0:K], a_s)
            # 无线程域标记：translator 自动把 reduce 岛包进 simd scope。
            red(a_s, o_s, dim=1)
            T.copy(o_s, OUT[bx * BR:(bx + 1) * BR])

    kern.__name__ = f"{op}_thread_kernel"
    return T.prim_func(kern)


def _frag_direct(op, dtype, M, K):
    """sum/max：vreduce_* 直连。"""
    vred = T.vreduce_sum if op == "reduce_sum" else T.vreduce_max

    def kern(A: T.Buffer((M, K), dtype), OUT: T.Buffer((M,), dtype)):
        with T.Kernel(M // BR) as bx:
            a_s = T.alloc_shared((BR, K), dtype)
            o_s = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR:(bx + 1) * BR, 0:K], a_s)
            with T.SimdVF():
                a_f = T.alloc_frag((BR, K), dtype)
                p = T.alloc_frag((BR,), dtype)
                T.copy(a_s[0:BR, 0:K], a_f)
                vred(a_f, p)
                T.copy(p, o_s[0:BR])
            T.copy(o_s, OUT[bx * BR:(bx + 1) * BR])

    kern.__name__ = f"{op}_frag_kernel"
    return T.prim_func(kern)


def _frag_abs(op, dtype, M, K):
    """abssum/absmax：abs(x)=vmax(x, -x) 合成后 vreduce_sum/max。"""
    vred = T.vreduce_sum if op == "reduce_abssum" else T.vreduce_max
    neg1 = tirx.const(-1.0, dtype)

    def kern(A: T.Buffer((M, K), dtype), OUT: T.Buffer((M,), dtype)):
        with T.Kernel(M // BR) as bx:
            a_s = T.alloc_shared((BR, K), dtype)
            o_s = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR:(bx + 1) * BR, 0:K], a_s)
            with T.SimdVF():
                a_f = T.alloc_frag((BR, K), dtype)
                neg = T.alloc_frag((BR, K), dtype)
                ab = T.alloc_frag((BR, K), dtype)
                m1 = T.alloc_frag((BR, K), dtype)
                p = T.alloc_frag((BR,), dtype)
                T.fill(m1, neg1)
                T.copy(a_s[0:BR, 0:K], a_f)
                T.vmul(a_f, m1, neg)
                T.vmax(a_f, neg, ab)
                vred(ab, p)
                T.copy(p, o_s[0:BR])
            T.copy(o_s, OUT[bx * BR:(bx + 1) * BR])

    kern.__name__ = f"{op}_frag_kernel"
    return T.prim_func(kern)


def _frag_min(dtype, M, K):
    """min：max(-x) 再取负。"""
    neg1 = tirx.const(-1.0, dtype)

    def kern(A: T.Buffer((M, K), dtype), OUT: T.Buffer((M,), dtype)):
        with T.Kernel(M // BR) as bx:
            a_s = T.alloc_shared((BR, K), dtype)
            o_s = T.alloc_shared((BR,), dtype)
            nm_s = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR:(bx + 1) * BR, 0:K], a_s)
            with T.SimdVF():
                a_f = T.alloc_frag((BR, K), dtype)
                neg = T.alloc_frag((BR, K), dtype)
                m1 = T.alloc_frag((BR, K), dtype)
                p = T.alloc_frag((BR,), dtype)
                T.fill(m1, neg1)
                T.copy(a_s[0:BR, 0:K], a_f)
                T.vmul(a_f, m1, neg)
                T.vreduce_max(neg, p)
                T.copy(p, nm_s[0:BR])
            with T.SimdVF():
                tmp = T.alloc_frag((BR,), dtype)
                m1r = T.alloc_frag((BR,), dtype)
                p2 = T.alloc_frag((BR,), dtype)
                T.fill(m1r, neg1)
                T.copy(nm_s[0:BR], tmp)
                T.vmul(tmp, m1r, p2)
                T.copy(p2, o_s[0:BR])
            T.copy(o_s, OUT[bx * BR:(bx + 1) * BR])

    kern.__name__ = "reduce_min_frag_kernel"
    return T.prim_func(kern)


def build(op, form, dtype, M, K):
    if form == "shared":
        return _shared(op, dtype, M, K)
    if form == "thread":
        return _thread(op, dtype, M, K)
    if op in ("reduce_sum", "reduce_max"):
        return _frag_direct(op, dtype, M, K)
    if op in ("reduce_abssum", "reduce_absmax"):
        return _frag_abs(op, dtype, M, K)
    return _frag_min(dtype, M, K)


def emit(op, outdir):
    """生成该算子全部 1_*.mlir，返回产出数量。"""
    n = 0
    for form, dtypes in MATRIX[op].items():
        for dtype in dtypes:
            for (M, K) in SHAPES:
                art = tilelang.lower(build(op, form, dtype, M, K), target="tile")
                name = f"1_{op}_{form}_{dtype}_{M}x{K}_tilelangir.mlir"
                with open(os.path.join(outdir, name), "w") as f:
                    f.write(art.kernel_source)
                n += 1
    print(f"[{op}] emitted {n} stage0 mlir")
    return n
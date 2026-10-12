"""reduce_absmax 端到端 DSL（三条路线）。

    A(M, K) -> OUT(M)，dim=1 每行 |x| 的最大值；grid = M/BR，每 block 处理 BR 行。

形态一（vreduce 路线）：SimdVF 内用 abs(x) = max(x, -x) 合成，再 vreduce_max。
    -x -> vmax 得 abs -> vreduce_max，reduce 为 scope 内最后一个计算。

形态二（T.reduce 路线，SimdVF 内 shared->shared）：
    T.reduce_absmax(a_shared, out_shared, dim=1)。translator 先把 abs 预处理成临时
    fragment（linalg.abs -> npu.abs），再做 max reduce（maximumf，identity -inf）。

形态三（T.reduce 路线，线程域内）：
    不写 T.SimdVF，直接在 T.Kernel 内 T.reduce_absmax(...)；translator 自动把
    reduce 岛包进 simd scope。

SimdVF 内不写循环（行并行由 T.Kernel 网格承担）。
"""

import os

import tilelang
import tilelang.language as T

HERE = os.path.dirname(os.path.abspath(__file__))


def reduce_absmax_frag(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_absmax_frag_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            with T.SimdVF():
                a_frag = T.alloc_frag((BR, K), dtype)
                neg_frag = T.alloc_frag((BR, K), dtype)
                abs_frag = T.alloc_frag((BR, K), dtype)
                minus_one_2d = T.alloc_frag((BR, K), dtype)
                partial = T.alloc_frag((BR,), dtype)

                T.fill(minus_one_2d, -1.0)
                T.copy(a_shared[0:BR, 0:K], a_frag)
                T.vmul(a_frag, minus_one_2d, neg_frag)
                T.vmax(a_frag, neg_frag, abs_frag)
                T.vreduce_max(abs_frag, partial)
                T.copy(partial, out_shared[0:BR])

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_absmax_frag_kernel


def reduce_absmax_shared(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_absmax_shared_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            with T.SimdVF():
                T.reduce_absmax(a_shared, out_shared, dim=1)

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_absmax_shared_kernel


def reduce_absmax_thread(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_absmax_thread_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            # 无线程域标记：translator 自动把 reduce 岛包进 simd scope。
            T.reduce_absmax(a_shared, out_shared, dim=1)

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_absmax_thread_kernel


def _lower(program, out_name):
    artifact = tilelang.lower(program, target="tile")
    out_path = os.path.join(HERE, out_name)
    with open(out_path, "w") as f:
        f.write(artifact.kernel_source)
    print(f"mlir saved to: {out_path}")


if __name__ == "__main__":
    M, K = 32, 128
    _lower(reduce_absmax_frag(M, K, BR=16), "1_reduce_absmax_frag_tilelangir.mlir")
    _lower(reduce_absmax_shared(M, K, BR=16), "1_reduce_absmax_shared_tilelangir.mlir")
    _lower(reduce_absmax_thread(M, K, BR=16), "1_reduce_absmax_thread_tilelangir.mlir")
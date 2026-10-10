"""reduce_abssum 端到端 DSL（两种形态）。

形态 A（线程域内）: fragment -> fragment，直接调用 T.reduce_abssum(frag, frag)
形态 B（SimdVF 内）: shared  -> shared，在 with T.SimdVF() 内调用 T.reduce_abssum(shared, shared)

    A(M, K) -> OUT(M)，dim=1 每行 |x| 求和；grid = M/BR，每 block 处理 BR 行。
注意：T.reduce_abssum 无 clear 参数（内部固定按 clear=True 处理）。
SimdVF 内不写循环（行并行交给 T.Kernel 网格）。
"""

import os

import tilelang
import tilelang.language as T

HERE = os.path.dirname(os.path.abspath(__file__))


def reduce_abssum_frag(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_abssum_frag_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            a_frag = T.alloc_frag((BR, K), dtype)
            out_frag = T.alloc_frag((BR,), dtype)
            T.copy(a_shared[0:BR, 0:K], a_frag)
            T.reduce_abssum(a_frag, out_frag, dim=1)
            T.copy(out_frag, out_shared[0:BR])

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_abssum_frag_kernel


def reduce_abssum_shared(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_abssum_shared_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            with T.SimdVF():
                T.reduce_abssum(a_shared, out_shared, dim=1)

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_abssum_shared_kernel


def _lower(program, out_name):
    artifact = tilelang.lower(program, target="tile")
    out_path = os.path.join(HERE, out_name)
    with open(out_path, "w") as f:
        f.write(artifact.kernel_source)
    print(f"mlir saved to: {out_path}")


if __name__ == "__main__":
    M, K = 32, 128
    _lower(reduce_abssum_frag(M, K, BR=16), "1_reduce_abssum_frag_tilelangir.mlir")
    _lower(reduce_abssum_shared(M, K, BR=16), "1_reduce_abssum_shared_tilelangir.mlir")
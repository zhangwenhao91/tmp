"""reduce_sum 端到端 DSL（三条路线）。

    A(M, K) -> OUT(M)，dim=1 每行求和；grid = M/BR，每 block 处理 BR 行。

形态一（vreduce 路线）：SimdVF 内，shared -> frag -> vreduce_sum(frag, frag) -> shared。
说明：vreduce 的输入必须是 fragment（后端：reduce input must be a fragment
promoted to a vector），因此没有 shared->shared 形态。

形态二（T.reduce 路线，任务点名的 SimdVF 内 shared->shared）：
    T.reduce_sum(a_shared, out_shared, dim=1)。T.reduce 宏会自动经 fragment
    中转（alloc_fragment + copy in + tl.tileop.reduce + copy out），产出的 IR
    天然是 frag->frag，与后端 linalg.reduce 的 fragment 契约一致。

形态三（T.reduce 路线，任务点名的线程域内）：
    不写 T.SimdVF，直接在 T.Kernel 内 T.reduce_sum(a_shared, out_shared, dim=1)。
    translator 会把 reduce 岛（fragment alloc + 拷贝 + linalg.fill/reduce）自动
    包进一个 tilelang.scope mode=simd，借向量路径降级成 npu.reduce；GM<->UB 的
    拷贝留在 scope 外。

SimdVF 内不写循环（行并行由 T.Kernel 网格承担）。
"""

import os

import tilelang
import tilelang.language as T

HERE = os.path.dirname(os.path.abspath(__file__))


def reduce_sum_frag(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_sum_frag_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            with T.SimdVF():
                a_frag = T.alloc_frag((BR, K), dtype)
                partial = T.alloc_frag((BR,), dtype)
                T.copy(a_shared[0:BR, 0:K], a_frag)
                T.vreduce_sum(a_frag, partial)
                T.copy(partial, out_shared[0:BR])

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_sum_frag_kernel


def reduce_sum_shared(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_sum_shared_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            with T.SimdVF():
                T.reduce_sum(a_shared, out_shared, dim=1)

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_sum_shared_kernel


def reduce_sum_thread(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_sum_thread_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            # 无线程域标记：translator 自动把 reduce 岛包进 simd scope。
            T.reduce_sum(a_shared, out_shared, dim=1)

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_sum_thread_kernel


def _lower(program, out_name):
    artifact = tilelang.lower(program, target="tile")
    out_path = os.path.join(HERE, out_name)
    with open(out_path, "w") as f:
        f.write(artifact.kernel_source)
    print(f"mlir saved to: {out_path}")


if __name__ == "__main__":
    M, K = 32, 128
    _lower(reduce_sum_frag(M, K, BR=16), "1_reduce_sum_frag_tilelangir.mlir")
    _lower(reduce_sum_shared(M, K, BR=16), "1_reduce_sum_shared_tilelangir.mlir")
    _lower(reduce_sum_thread(M, K, BR=16), "1_reduce_sum_thread_tilelangir.mlir")
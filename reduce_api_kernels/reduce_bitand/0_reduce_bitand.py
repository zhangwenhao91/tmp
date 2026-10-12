"""reduce_bitand 端到端 DSL（两条 T.reduce 路线）。

    A(M, K) int32 -> OUT(M) int32，dim=1 每行按位与；grid = M/BR，每 block 处理 BR 行。

形态一（T.reduce 路线，SimdVF 内 shared->shared）：
    T.reduce_bitand(a_shared, out_shared, dim=1)。宏经 fragment 中转，translator 把
    arith.andi combiner（identity 全 1）降为 npu.reduce<andi>。

形态二（T.reduce 路线，线程域内）：
    不写 T.SimdVF，直接在 T.Kernel 内 T.reduce_bitand(...)；translator 自动把 reduce
    岛包进 simd scope，GM<->UB 的拷贝留在 scope 外。

位运算无 SimdVF frag 原语（没有 vreduce_bitand），故不提供 frag 形态。
SimdVF 内不写循环（行并行由 T.Kernel 网格承担）。

已知缺口：translator 与 TilelangToNPU 已能产出 npu.reduce<andi>（stage1~4 全通），
但 NpuToCCE 无横向位归约原语，stage5 ccec 会因寄存器溢出失败，故暂无 6_*.o。
"""

import os

import tilelang
import tilelang.language as T

HERE = os.path.dirname(os.path.abspath(__file__))


def reduce_bitand_shared(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "int32"

    @T.prim_func
    def reduce_bitand_shared_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            with T.SimdVF():
                T.reduce_bitand(a_shared, out_shared, dim=1)

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_bitand_shared_kernel


def reduce_bitand_thread(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "int32"

    @T.prim_func
    def reduce_bitand_thread_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            # 无线程域标记：translator 自动把 reduce 岛包进 simd scope。
            T.reduce_bitand(a_shared, out_shared, dim=1)

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_bitand_thread_kernel


def _lower(program, out_name):
    artifact = tilelang.lower(program, target="tile")
    out_path = os.path.join(HERE, out_name)
    with open(out_path, "w") as f:
        f.write(artifact.kernel_source)
    print(f"mlir saved to: {out_path}")


if __name__ == "__main__":
    M, K = 32, 128
    _lower(reduce_bitand_shared(M, K, BR=16), "1_reduce_bitand_shared_tilelangir.mlir")
    _lower(reduce_bitand_thread(M, K, BR=16), "1_reduce_bitand_thread_tilelangir.mlir")
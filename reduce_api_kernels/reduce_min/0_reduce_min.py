"""reduce_min 端到端 DSL（vreduce 路线）。

    A(M, K) -> OUT(M)，dim=1 每行最小值；grid = M/BR，每 block 处理 BR 行。
形态：SimdVF 内用 min = -max(-x) 合成。
后端约束：npu.reduce 之后不允许再有带 vector 类型的操作（reduce 必须是 scope
内最后一个计算），因此“结果取负”不能与 reduce 同段，拆成两个 SimdVF scope，
经 shared buffer 传递：
    scope1: -x -> vreduce_max -> max(-x) 写 negmax_shared
    scope2: 读回 max(-x) -> vmul(-1) -> min(x) 写 out_shared
SimdVF 内不写循环（行并行由 T.Kernel 网格承担）。
"""

import os

import tilelang
import tilelang.language as T

HERE = os.path.dirname(os.path.abspath(__file__))


def reduce_min_frag(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def reduce_min_frag_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            negmax_shared = T.alloc_shared((BR,), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            # scope 1: max(-x)
            with T.SimdVF():
                a_frag = T.alloc_frag((BR, K), dtype)
                neg_frag = T.alloc_frag((BR, K), dtype)
                minus_one_2d = T.alloc_frag((BR, K), dtype)
                partial = T.alloc_frag((BR,), dtype)

                T.fill(minus_one_2d, -1.0)
                T.copy(a_shared[0:BR, 0:K], a_frag)
                T.vmul(a_frag, minus_one_2d, neg_frag)
                T.vreduce_max(neg_frag, partial)
                T.copy(partial, negmax_shared[0:BR])

            # scope 2: -max(-x) = min(x)
            with T.SimdVF():
                tmp_frag = T.alloc_frag((BR,), dtype)
                minus_one_row = T.alloc_frag((BR,), dtype)
                partial = T.alloc_frag((BR,), dtype)

                T.fill(minus_one_row, -1.0)
                T.copy(negmax_shared[0:BR], tmp_frag)
                T.vmul(tmp_frag, minus_one_row, partial)
                T.copy(partial, out_shared[0:BR])

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return reduce_min_frag_kernel


def _lower(program, out_name):
    artifact = tilelang.lower(program, target="tile")
    out_path = os.path.join(HERE, out_name)
    with open(out_path, "w") as f:
        f.write(artifact.kernel_source)
    print(f"mlir saved to: {out_path}")


if __name__ == "__main__":
    M, K = 32, 128
    _lower(reduce_min_frag(M, K, BR=16), "1_reduce_min_frag_tilelangir.mlir")
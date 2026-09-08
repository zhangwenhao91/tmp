import os
import tilelang
import tilelang.language as T

# out = reduce_max(A, dim=1)：每行取最大值，输出 (M,)
#
# 采用行块批量归约模式（与 tilelangir/test/test_DSA_codegen.py 一致）：
#   一次把 BR 行 (BR, K) 载入 fragment，vreduce_max 沿最后一维归约出 (BR,)，
#   再整块写回，避免逐行标量写回（1 元素 fragment -> 标量位置在
#   convert-tilelang-to-npu / cce-pipeline 中不被支持）。
def reduce_max(M, K, BR=32):
    num_blocks = 1
    dtype = "float32"
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"

    @T.prim_func
    def reduce_max_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((M, K), dtype)
            out_shared = T.alloc_shared((M,), dtype)
            T.copy(A, a_shared)

            with T.SimdVF():
                for blk in range(0, M // BR):
                    a_frag = T.alloc_frag((BR, K), dtype)
                    row_max = T.alloc_frag((BR,), dtype)
                    T.copy(a_shared[blk * BR : (blk + 1) * BR, 0:K], a_frag)
                    T.vreduce_max(a_frag, row_max)
                    T.copy(row_max, out_shared[blk * BR : (blk + 1) * BR])

            T.copy(out_shared, OUT)

    return reduce_max_kernel


if __name__ == "__main__":
    M, K = 32, 128
    program = reduce_max(M, K, BR=32)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "reduce_max_tilelangir.mlir"
    )
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

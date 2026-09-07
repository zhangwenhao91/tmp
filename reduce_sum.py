import os
import tilelang
import tilelang.language as T

# out = reduce_sum(A, dim=1)：每行求和，输出 (M,)
#
# 行块批量归约 + VL 分块累积（后端不支持 1 元素/标量写回，故不用 (1,) acc）：
#   每个行块 (BR, K) 按 VL 切成 (BR, VL) fragment，vreduce_sum 沿最后一维
#   归约出 (BR,)，用 vadd 累积到 (BR,) acc，最后整块写回 out_shared。
def reduce_sum(M, K, VL=64, BR=32):
    assert K % VL == 0, f"K must be a multiple of VL ({VL}), got K={K}"
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = 1
    dtype = "float32"

    @T.prim_func
    def reduce_sum_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((M, K), dtype)
            out_shared = T.alloc_shared((M,), dtype)
            T.copy(A, a_shared)

            with T.SimdVF():
                for blk in range(0, M // BR):
                    acc = T.alloc_frag((BR,), dtype)
                    T.fill(acc, 0.0)

                    for i in range(0, K // VL):
                        a_frag = T.alloc_frag((BR, VL), dtype)
                        partial = T.alloc_frag((BR,), dtype)

                        T.copy(
                            a_shared[blk * BR : (blk + 1) * BR, i * VL : (i + 1) * VL],
                            a_frag,
                        )
                        T.vreduce_sum(a_frag, partial)
                        T.vadd(acc, partial, acc)

                    T.copy(acc, out_shared[blk * BR : (blk + 1) * BR])

            T.copy(out_shared, OUT)

    return reduce_sum_kernel


if __name__ == "__main__":
    M, K = 32, 128
    VL = 64
    program = reduce_sum(M, K, VL)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "reduce_sum_tilelangir.mlir"
    )
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

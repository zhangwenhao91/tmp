import os
import tilelang
import tilelang.language as T

# out = reduce_sum(A, dim=1)
# A [M, K] -> OUT [M]
def reduce_sum(M, K, VL=64):
    assert K % VL == 0, f"K must be a multiple of VL ({VL}), got K={K}"
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
                for r in range(0, M):
                    acc = T.alloc_frag((1,), dtype)
                    T.fill(acc, 0.0)

                    for i in range(0, K // VL):
                        a_frag = T.alloc_frag((VL,), dtype)
                        partial = T.alloc_frag((1,), dtype)

                        T.copy(a_shared[r, i * VL : (i + 1) * VL], a_frag)
                        T.vreduce_sum(a_frag, partial)
                        T.vadd(acc, partial, acc)

                    T.copy(acc, out_shared[r])

            T.copy(out_shared, OUT)

    return reduce_sum_kernel


if __name__ == "__main__":
    M, K = 32, 128
    program = reduce_sum(M, K)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reduce_sum.mlir")
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

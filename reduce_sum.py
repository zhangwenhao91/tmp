import os
import tilelang
import tilelang.language as T

# out = reduce_sum(A, dim=1)，纯循环逐元素累加（不使用 vreduce_sum）
def reduce_sum(M, K):
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
                    # 用首元素初始化 acc，避免 linalg.fill（OpenTileAS 不处理）
                    T.copy(a_shared[r, 0:1], acc)

                    for k in range(1, K):
                        elem = T.alloc_frag((1,), dtype)
                        T.copy(a_shared[r, k : k + 1], elem)
                        T.vadd(acc, elem, acc)

                    T.copy(acc, out_shared[r])

            T.copy(out_shared, OUT)

    return reduce_sum_kernel


if __name__ == "__main__":
    M, K = 32, 128
    program = reduce_sum(M, K)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reduce_sum_loop.mlir")
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

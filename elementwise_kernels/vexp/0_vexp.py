import os
import tilelang
import tilelang.language as T

# elementwise vexp: OUT = exp(A), 形状 (M, K) -> (M, K)
# SimdVF 内不使用 for 循环；行并行交给 T.Kernel(M//BR) 网格，每 block 直排。
def vexp(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def vexp_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M, K), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            c_shared = T.alloc_shared((BR, K), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)

            with T.SimdVF():
                a_frag = T.alloc_frag((BR, K), dtype)
                c_frag = T.alloc_frag((BR, K), dtype)
                T.copy(a_shared[0:BR, 0:K], a_frag)
                T.vexp(a_frag, c_frag)
                T.copy(c_frag, c_shared[0:BR, 0:K])

            T.copy(c_shared, OUT[bx * BR : (bx + 1) * BR, 0:K])

    return vexp_kernel


if __name__ == "__main__":
    M, K = 32, 128
    program = vexp(M, K, BR=16)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "1_vexp_tilelangir.mlir"
    )
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

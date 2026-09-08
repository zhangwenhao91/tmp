import os
import tilelang
import tilelang.language as T

# out = vadd(A, B)：逐元素加，A/B/OUT 均为 (M, K)
#
# SimdVF 内不使用 for 循环（前辈提醒 + IR 层面 scf.for-in-simd 易致后端问题）：
#   行并行由 T.Kernel(M//BR) 网格承担，每个 block 直排处理 BR 行；
#   K=128 整行一次 (BR, K) fragment：vload A/B -> vadd -> vstore，
#   scope 内无任何循环（与 vmul 契约一致）。
def vadd(M, K, BR=16):
    assert M % BR == 0, f"M must be a multiple of BR ({BR}), got M={M}"
    num_blocks = M // BR
    dtype = "float32"

    @T.prim_func
    def vadd_kernel(
        A: T.Buffer((M, K), dtype),
        B: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M, K), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            b_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR, K), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)
            T.copy(B[bx * BR : (bx + 1) * BR, 0:K], b_shared)

            with T.SimdVF():
                a_frag = T.alloc_frag((BR, K), dtype)
                b_frag = T.alloc_frag((BR, K), dtype)
                out_frag = T.alloc_frag((BR, K), dtype)
                T.copy(a_shared[0:BR, 0:K], a_frag)
                T.copy(b_shared[0:BR, 0:K], b_frag)
                T.vadd(a_frag, b_frag, out_frag)  # 逐元素加
                T.copy(out_frag, out_shared[0:BR, 0:K])

            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR, 0:K])

    return vadd_kernel


if __name__ == "__main__":
    M, K = 32, 128
    program = vadd(M, K, BR=16)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "1_vadd_tilelangir.mlir"
    )
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

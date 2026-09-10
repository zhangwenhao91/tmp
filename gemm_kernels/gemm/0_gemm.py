import os
import tilelang
import tilelang.language as T

# GEMM: OUT = A @ B，A(M,K) bf16 @ B(K,N) bf16 -> OUT(M,N) fp32。
# Cube 核计算，L0C fp32 累加；搬运走与 vmul e2e 相同的 frag->shared->GM 模式
# （npu.copy 的 split_dim 仅允许 L0C->UB / UB->L1，UB->GM 不能带 split_dim）。
# 与已有 e2e kernel 同风格：M=32, BM=16, T.Kernel(2)。
def gemm(M, K, N, BM=16):
    assert M % BM == 0, f"M must be a multiple of BM ({BM}), got M={M}"
    num_blocks = M // BM
    dtype = "bfloat16"
    accum_dtype = "float32"

    @T.prim_func
    def gemm_kernel(
        A: T.Buffer((M, K), dtype),
        B: T.Buffer((K, N), dtype),
        OUT: T.Buffer((M, N), accum_dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BM, K), dtype)
            b_shared = T.alloc_shared((K, N), dtype)
            acc = T.alloc_fragment((BM, N), accum_dtype)
            c_shared = T.alloc_shared((BM, N), accum_dtype)

            T.copy(A[bx * BM : (bx + 1) * BM, 0:K], a_shared)
            T.copy(B[0:K, 0:N], b_shared)

            T.gemm(a_shared, b_shared, acc, transpose_B=False, clear_accum=True)

            # L0C -> UB -> GM：与 vmul e2e 的 frag->shared->GM 同构
            T.copy(acc, c_shared)
            T.copy(c_shared, OUT[bx * BM : (bx + 1) * BM, 0:N])

    return gemm_kernel


if __name__ == "__main__":
    M, K, N = 32, 128, 128
    program = gemm(M, K, N, BM=16)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "1_gemm_tilelangir.mlir"
    )
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

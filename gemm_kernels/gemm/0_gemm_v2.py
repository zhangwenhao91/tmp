import tilelang
import tilelang.language as T

# 二分变体 v2：BM=16, K=64（M=16, K=64, N=128, rhs_trans=False）
# 与基准 GEMM 的唯一差异：B 的 K 维度 128 -> 64（等价于 FA 第二个 mad QK@V 的形状）。
# 若 v2 正确而基准错误 => 根因在 K=128 的 rhs_trans=False B 搬运路径。
# 若 v2 也错误 => 根因在 m=16 路径。


def gemm(M, K, N, BM=16):
    assert M % BM == 0
    num_blocks = M // BM
    dtype = 'bfloat16'
    accum_dtype = 'float32'

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

            T.copy(acc, c_shared)
            T.copy(c_shared, OUT[bx * BM : (bx + 1) * BM, 0:N])

    return gemm_kernel


if __name__ == '__main__':
    M, K, N = 16, 64, 128
    artifact = tilelang.lower(gemm(M, K, N, BM=16), target='tile')
    with open('1_gemm_v2_tilelangir.mlir', 'w') as f:
        f.write(artifact.kernel_source)

import tilelang
import tilelang.language as T

# 单 block 因果验证版：M=16（num_blocks=1, grid=(1,)）
# 目的：若该版本数值正确而 BM=16/M=32（grid=2）版本错误，
# 则锁定 Triton driver 对 mix .o 的多 block grid 分发 bug。
# 形状 M=16, K=128, N=128, BM=16 —— 与基准 GEMM 唯一差异是 block 数 2 -> 1。


def gemm(M, K, N, BM=16):
    assert M % BM == 0
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

            T.copy(acc, c_shared)
            T.copy(c_shared, OUT[bx * BM : (bx + 1) * BM, 0:N])

    return gemm_kernel


if __name__ == "__main__":
    M, K, N = 16, 128, 128
    artifact = tilelang.lower(gemm(M, K, N, BM=16), target="tile")
    with open("1_gemm_sb_tilelangir.mlir", "w") as f:
        f.write(artifact.kernel_source)

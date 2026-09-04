import os
import tilelang
import tilelang.language as T

# out = reduce_max(A, dim=1)，使用 vreduce_max 函数实现
#
# 说明：本版本去掉内层串行分块循环（原 for i in range(0, K // VL) 的
# 2×64 分段 + 跨迭代 acc 累加），改为整行 (K) 一次 vreduce_max 归约，
# 每行只产生一次 copy/reduce/max，无跨迭代 fragment 状态。
def reduce_max(M, K, VL=128):
    assert K % VL == 0, f"K must be a multiple of VL ({VL}), got K={K}"
    num_blocks = 1
    dtype = "float32"

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
                for r in range(0, M):
                    acc = T.alloc_frag((1,), dtype)
                    # 用首元素初始化 acc
                    T.copy(a_shared[r, 0:1], acc)

                    # 整行一次归约：无内层循环
                    a_frag = T.alloc_frag((K,), dtype)
                    partial = T.alloc_frag((1,), dtype)
                    T.copy(a_shared[r, 0:K], a_frag)
                    T.vreduce_max(a_frag, partial)
                    T.vmax(acc, partial, acc)

                    T.copy(acc, out_shared[r])

            T.copy(out_shared, OUT)

    return reduce_max_kernel


if __name__ == "__main__":
    M, K = 32, 128
    VL = K
    program = reduce_max(M, K, VL)

    artifact = tilelang.lower(program, target="tile")
    mlir_str = artifact.kernel_source

    out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reduce_max.mlir")
    with open(out_path, "w") as f:
        f.write(mlir_str)
    print(f"mlir saved to: {out_path}")

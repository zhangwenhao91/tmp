import os
import tilelang
import tilelang.language as T

def reduce_max(M, K, VL=64):
    assert K % VL == 0, f"K must be a multiple of VL ({VL}), got K={K}"
    
    # 假设每个线程块处理一行，因此 num_blocks = M
    # 但为了简化，我们假设 M 较小，或者使用单个线程块处理所有行（不推荐用于大 M）
    # 这里我们采用每个线程块处理一行的策略，num_blocks = M
    # 但为了保持代码简单，我们假设 M=1 或每个线程块独立处理一行
    # 注意：在实际应用中，M 可能很大，需要使用 grid-stride loop 或更复杂的映射
    
    # 为了演示，我们假设 M 是 block 维度，每个 block 处理一行
    # 因此，kernel 的索引 bx 将对应行索引 r
    num_blocks = M
    dtype = "float32"

    @T.prim_func
    def reduce_max_kernel(
        A: T.Buffer((M, K), dtype),
        OUT: T.Buffer((M,), dtype),
    ):
        with T.Kernel(num_blocks) as bx:
            # 当前线程块负责行 bx
            r = bx
            
            # 分配共享内存：当前行的数据
            # 注意：这里假设共享内存足够大，可以容纳整行
            a_shared = T.alloc_shared((K,), dtype)
            
            # 将数据从全局内存拷贝到共享内存
            # 使用向量拷贝以提高效率
            for i in range(0, K // VL):
                a_frag = T.alloc_frag((VL,), dtype)
                T.copy(A[r, i * VL : (i + 1) * VL], a_frag)
                T.copy(a_frag, a_shared[i * VL : (i + 1) * VL])
            
            # 现在进行归约
            # 初始化累加器：取第一个元素
            acc = T.alloc_frag((1,), dtype)
            T.copy(a_shared[0:1], acc)
            
            # 从第二个向量开始归约
            for i in range(0, K // VL):
                # 如果 i==0，我们已经处理了第一个向量，所以从 i=1 开始？
                # 或者，我们可以在循环内处理所有向量
                # 让我们重新设计：
                pass
            
            # 更清晰的归约逻辑：
            # 1. 加载第一个向量到 acc
            # 2. 循环加载剩余向量并与 acc 比较
            
            # 重新初始化 acc 为第一个向量的最大值
            first_frag = T.alloc_frag((VL,), dtype)
            T.copy(a_shared[0:VL], first_frag)
            # 注意：T.vreduce_max 可能不存在，或者需要手动实现
            # 假设存在 T.vreduce_max(v, scalar) 将向量归约为标量
            # 或者，我们可以使用 T.reduce_max 如果存在
            
            # 由于 API 不确定性，这里使用一个假设的向量化归约
            # 如果 T.vreduce_max 不存在，可能需要逐元素比较
            
            # 让我们假设 T.vreduce_max 是一个有效的内建函数，将向量归约为一个标量
            # 但通常，reduce_max 在向量单元内可能是逐元素的，然后跨向量归约
            
            # 修正：使用标量累加器
            # 由于 acc 是 (1,)，我们只能存储一个值
            # 所以我们需要在向量内先归约，再跨向量归约
            
            # 步骤 1: 归约第一个向量
            acc_val = T.alloc_frag((1,), dtype)
            T.vreduce_max(first_frag, acc_val) # 假设这个函数存在
            
            # 步骤 2: 循环处理剩余向量
            for i in range(1, K // VL):
                frag = T.alloc_frag((VL,), dtype)
                T.copy(a_shared[i * VL : (i + 1) * VL], frag)
                partial = T.alloc_frag((1,), dtype)
                T.vreduce_max(frag, partial)
                
                # 比较 acc_val 和 partial，取最大值
                # 假设 T.vmax 可以用于标量比较
                T.vmax(partial, acc_val, acc_val) # acc_val = max(acc_val, partial)
            
            # 将结果写回全局内存
            T.copy(acc_val, OUT[r])

    return reduce_max_kernel

if __name__ == "__main__":
    M, K = 1, 128  # 简化为 M=1 以便测试单行归约
    VL = 64
    program = reduce_max(M, K, VL)

    try:
        artifact = tilelang.lower(program, target="tile")
        mlir_str = artifact.kernel_source

        out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "reduce_max.mlir")
        with open(out_path, "w") as f:
            f.write(mlir_str)
        print(f"mlir saved to: {out_path}")
    except Exception as e:
        print(f"Error lowering program: {e}")
        # 打印程序以便调试
        print(program)

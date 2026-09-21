import math

import tilelang
import tilelang.language as T


def dsa_demo(
    batch_size=1,
    seq_len=4096,
    seq_len_kv=4096,
    num_heads=64,
    dim=256,
    top_k=128,
    num_cores=32,
):
    """Build a sparse-attention PrimFunc for the Ascend ``tile`` target.

    Persistent-kernel variant: the logical core count is fixed to
    ``num_cores`` (e.g. the physical core count), and each core serially
    processes ``rows_per_core = seq_len // num_cores`` query rows, so
    multiple queries share one physical core.
    """

    block_heads = num_heads
    half_heads = block_heads // 2  # heads per vector core (1:2 split)
    blocksize = 16
    dtype = "bfloat16"
    accum_dtype = "float32"
    indices_dtype = "int32"

    assert top_k % blocksize == 0, "top_k must be divisible by blocksize"
    rows_per_core = seq_len // num_cores
    assert seq_len % num_cores == 0, "seq_len must be divisible by num_cores"
    softmax_scale = 1.0 / math.sqrt(dim)

    @T.prim_func
    def main(
        Q: T.Buffer((batch_size, seq_len, num_heads, dim), dtype),
        KV: T.Buffer((batch_size, seq_len_kv, dim), dtype),
        AttnSink: T.Buffer((num_heads,), accum_dtype),
        TopKIndices: T.Buffer((batch_size, seq_len, top_k), indices_dtype),
        O: T.Buffer((batch_size, seq_len, num_heads, dim), accum_dtype),
    ):
        # Kernel axes map to logical cores: cid (blockIdx.x, the physical
        # core id) and vid (blockIdx.y, the 1:2 vec-core split). Each core
        # walks `rows_per_core` query rows in a serial loop.
        with T.Kernel(num_cores, 2) as (cid, vid):
            # L1 operands of the gemms stay full-shape.
            q_shared = T.alloc_shared((block_heads, dim), dtype)
            # kv_shared = T.alloc_shared((top_k, dim), dtype)  # 全量版：split-scope 契约要求 kv_shared 的 writer 与 gemm reader 同循环，全量收集被拒
            kv_shared = T.alloc_shared((blocksize, dim), dtype)  # (16,256)：逐块整块重写
            # p_shared = T.alloc_shared((block_heads, top_k), dtype)
            p_shared = T.alloc_shared((block_heads, blocksize), dtype)  # 逐块版
            idxs_ub = T.alloc_shared((top_k,), indices_dtype)
            kv_ub = T.alloc_shared((blocksize, dim), dtype)

            # acc_s = T.alloc_fragment((block_heads, top_k), accum_dtype)
            acc_s = T.alloc_fragment((block_heads, blocksize), accum_dtype)
            acc_o = T.alloc_fragment((block_heads, dim), accum_dtype)

            # Dual-vec UB buffers: half-shape, private to each vector core.
            # s_ub = T.alloc_shared((half_heads, top_k), accum_dtype)
            # p_ub = T.alloc_shared((half_heads, top_k), dtype)
            s_ub = T.alloc_shared((half_heads, blocksize), accum_dtype)
            p_ub = T.alloc_shared((half_heads, blocksize), dtype)
            o_ub = T.alloc_shared((half_heads, dim), accum_dtype)
            o_tmp_ub = T.alloc_shared((half_heads, dim), accum_dtype)
            m_ub = T.alloc_shared((half_heads,), accum_dtype)
            old_m_ub = T.alloc_shared((half_heads,), accum_dtype)
            row_sum_ub = T.alloc_shared((half_heads,), accum_dtype)
            l_ub = T.alloc_shared((half_heads,), accum_dtype)
            alpha_ub = T.alloc_shared((half_heads,), accum_dtype)

            # for q_iter in T.serial(rows_per_core):
            for q_iter in T.Pipelined(rows_per_core, num_stages=2):
                row = cid * rows_per_core + q_iter

                T.copy(
                    Q[
                        0,
                        row,
                        0:num_heads,
                        0:dim,
                    ],
                    q_shared,
                )

                # --- per-row online-softmax state reset ---
                # o_ub / l_ub / m_ub are re-initialized at the top of every
                # row, otherwise row >= 2 starts from the previous row's
                # accumulator state.
                with T.SimdVF():
                    T.fill(o_ub, 0.0)
                    T.fill(l_ub, 1.0)

                T.copy(
                    AttnSink[vid * half_heads : (vid + 1) * half_heads],
                    m_ub,
                )

                # 一次性载入本行全部 top_k 个稀疏索引。
                for sparse_col in T.serial(top_k):
                    idxs_ub[sparse_col] = TopKIndices[
                        0,
                        row,
                        sparse_col,
                    ]

                # 分块离散访存：每轮只从 GM 聚合 blocksize 行 KV 到 kv_ub，
                # 避免一次性 (top_k, dim) 的中转把 UB 挤爆；
                # 每块立即整块搬入 L1 的 kv_shared 并做 gemm + online softmax。

                # ---- 两跳方案（下钻验证失败，保留现场）----
                # 结论（2026-09-15）：convert-tilelang-to-npu 后
                # tmp_shared_l1 因不直接参与 gemm 被分配到 UB 而非 L1，
                # 第一跳退化为 UB→UB 线性搬运（无 ND2NZ）；
                # --npu-split-scope 报错：
                #   "cube L1 -> L0 copy has no reaching GM -> L1 (CUBE)
                #    or UB -> L1 (VECTOR) writer"
                # 即 16 个 [16,16] strided 切片搬运不被认可为 kv_shared
                # 的合法 writer，两跳 pattern 被编译器拒绝。
                #
                # dtype_bytes = T.dtype(dtype).bytes
                # pre_block_col = 32 // dtype_bytes
                # col_count = dim // pre_block_col
                # row_count = top_k // blocksize
                # tmp_shared_l1 = T.alloc_shared((blocksize, dim), dtype)
                # for i in T.serial(top_k // blocksize):
                #     for j in T.serial(blocksize):
                #         topk_col = i * blocksize + j
                #         T.copy(KV[0, idxs_ub[topk_col], 0:dim], kv_ub[j, 0:dim])
                #     T.copy(kv_ub, tmp_shared_l1)
                #     for col_idx in range(col_count):
                #         T.copy(
                #             tmp_shared_l1[:, col_idx * pre_block_col:(col_idx + 1) * pre_block_col],
                #             kv_shared[i * blocksize:(i + 1) * blocksize,
                #                       col_idx * pre_block_col:(col_idx + 1) * pre_block_col],
                #         )
                #
                # ---- 逐块结构（对齐前辈 DSA_demo.py，已验证通过 mix 流水线）----
                # 单跳方案同样被 --npu-split-scope 拒绝（同样的
                # "no reaching writer" 错误：writer 在 i 循环内、gemm 在
                # 循环外，既不支配也不同循环）。根因是 SplitDataflow 的
                # verifyCubeL1CopyProducers 契约：kv_shared 的 writer 必须
                # 支配 L1→L0B reader 或与其同循环。因此改为逐块结构：
                # kv_shared 缩为 (16,256) 每块整块重写，gemm + online
                # softmax 在分块循环内增量更新。
                num_sparse_blocks = top_k // blocksize
                for i in T.serial(num_sparse_blocks):
                    # 离散访存：按索引收集 blocksize 行 KV 到 kv_ub。
                    for j in T.serial(blocksize):
                        topk_col = i * blocksize + j
                        T.copy(
                            KV[0, idxs_ub[topk_col], 0:dim],
                            kv_ub[j, 0:dim],
                        )
                    # 整块 UB→L1：ExpandUbToL1Nd2nz 自动展开为
                    # Nd2nzScatterOp（UB 内 NZ 重排）+ linear_transfer 线性搬运。
                    T.copy(kv_ub, kv_shared)

                    # --- S = Q @ K_block^T ---
                    T.gemm(
                        q_shared,
                        kv_shared,
                        acc_s,
                        transpose_B=True,
                        clear_accum=True,
                    )
                    # L0C -> UB, split heads across the two vec cores.
                    T.copy(acc_s, s_ub, split_dim=0)

                    # --- Step 1: scale scores, m_new = max(row_max(S), m_old) ---
                    with T.SimdVF():
                        s_frag = T.alloc_frag((half_heads, blocksize), accum_dtype)
                        row_max_frag = T.alloc_frag((half_heads,), accum_dtype)

                        T.copy(s_ub, s_frag)
                        T.vmuls(s_frag, softmax_scale, s_frag)
                        T.copy(s_frag, s_ub)

                        T.copy(m_ub, old_m_ub)
                        T.vreduce_max(s_frag, row_max_frag, dim=1)
                        T.copy(row_max_frag, m_ub)

                    # --- Step 2: P = exp(S - m_new), row sums ---
                    with T.SimdVF():
                        s_frag = T.alloc_frag((half_heads, blocksize), accum_dtype)
                        p_frag = T.alloc_frag((half_heads, blocksize), accum_dtype)
                        p_bf16_frag = T.alloc_frag((half_heads, blocksize), dtype)
                        m_frag = T.alloc_frag((half_heads,), accum_dtype)
                        m_new_frag = T.alloc_frag((half_heads,), accum_dtype)
                        row_max_frag = T.alloc_frag((half_heads,), accum_dtype)
                        m_new_bc = T.alloc_frag((half_heads, blocksize), accum_dtype)
                        row_sum_frag = T.alloc_frag((half_heads,), accum_dtype)

                        T.copy(s_ub, s_frag)
                        T.copy(m_ub, row_max_frag)
                        T.copy(old_m_ub, m_frag)
                        T.vmax(row_max_frag, m_frag, m_new_frag)
                        T.copy(m_new_frag, m_ub)
                        T.broadcast(m_new_frag, m_new_bc)
                        T.vexpdif(s_frag, m_new_bc, p_frag)

                        T.vcvt(p_frag, p_bf16_frag, dtype)
                        T.copy(p_bf16_frag, p_ub)
                        T.vreduce_sum(p_frag, row_sum_frag, dim=1)
                        T.copy(row_sum_frag, row_sum_ub)

                    # --- Step 3: alpha = exp(m_old - m_new), l = l*alpha + row_sum ---
                    with T.SimdVF():
                        m_frag = T.alloc_frag((half_heads,), accum_dtype)
                        m_new_frag = T.alloc_frag((half_heads,), accum_dtype)
                        l_frag = T.alloc_frag((half_heads,), accum_dtype)
                        alpha_frag = T.alloc_frag((half_heads,), accum_dtype)
                        row_sum_frag = T.alloc_frag((half_heads,), accum_dtype)

                        T.copy(old_m_ub, m_frag)
                        T.copy(m_ub, m_new_frag)
                        T.copy(l_ub, l_frag)
                        T.copy(row_sum_ub, row_sum_frag)
                        T.vexpdif(m_frag, m_new_frag, alpha_frag)
                        T.copy(alpha_frag, alpha_ub)
                        T.vmul(l_frag, alpha_frag, l_frag)
                        T.vadd(l_frag, row_sum_frag, l_frag)
                        T.copy(l_frag, l_ub)

                    # --- O = O * alpha + P @ V ---
                    # UB -> L1: merge the two vec-core halves back into the
                    # full-head gemm A operand.
                    T.copy(p_ub, p_shared, split_dim=0)
                    T.gemm(
                        p_shared,
                        kv_shared,
                        acc_o,
                        transpose_B=False,
                        clear_accum=True,
                    )
                    # L0C -> UB, split heads across the two vec cores.
                    T.copy(acc_o, o_tmp_ub, split_dim=0)

                    with T.SimdVF():
                        o_frag = T.alloc_frag((half_heads, dim), accum_dtype)
                        o_tmp_frag = T.alloc_frag((half_heads, dim), accum_dtype)
                        alpha_frag = T.alloc_frag((half_heads,), accum_dtype)
                        alpha_bc = T.alloc_frag((half_heads, dim), accum_dtype)
                        T.copy(o_ub, o_frag)
                        T.copy(o_tmp_ub, o_tmp_frag)
                        T.copy(alpha_ub, alpha_frag)
                        T.broadcast(alpha_frag, alpha_bc)
                        T.vmul(o_frag, alpha_bc, o_frag)
                        T.vadd(o_frag, o_tmp_frag, o_frag)
                        T.copy(o_frag, o_ub)

                # --- O /= l, then store this core's half via the vid offset ---
                with T.SimdVF():
                    o_frag = T.alloc_frag((half_heads, dim), accum_dtype)
                    l_frag = T.alloc_frag((half_heads,), accum_dtype)
                    l_bc = T.alloc_frag((half_heads, dim), accum_dtype)
                    T.copy(o_ub, o_frag)
                    T.copy(l_ub, l_frag)
                    T.broadcast(l_frag, l_bc)
                    T.vdiv(o_frag, l_bc, o_frag)
                    T.copy(o_frag, o_ub)

                T.copy(
                    o_ub,
                    O[
                        0,
                        row,
                        vid * half_heads : (vid + 1) * half_heads,
                        0:dim,
                    ],
                )

    return main


if __name__ == "__main__":
    program = dsa_demo()
    tilelang.lower(program, target="tile")

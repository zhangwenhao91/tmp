"""分页 MHA 解码最小探针 v5（seqlen_q=1, bf16, D=128, 无 causal, 无 mask）。

目的：验证两个昇腾降级链路风险点——
  R1  block_table 动态寻址：K/V 的 T.copy 源切片起点由
      block_table[bb, t] * PAGE 动态决定（GM int32 load 参与地址计算）
  R2  动态执行：real_seqlen_kv 运行时值参与 tile 守卫条件（动态 trip count
      本身不被 producer 支持，见下）

已实测的 producer 约束（v1-v4 教训，全部来自本探针）：
  - grid 变量不能做整除/取模（FloorDiv: bx // H 报错）→ grid 只承载 batch 维，
    head 维 block 内 T.serial 展开
  - 线程域 Parallel 循环里不支持 T.cast → bf16->f32 全部走 SimdVF 内 T.vcvt
  - LetStmt 中间标量不记录（kv_len = ... 报 "value has not been lowered yet"）
    → GM 派生标量全部内联进使用点
  - FloorDiv 不能做循环 extent，也不在表达式支持列表 → 动态 trip count 无法
    表达，退化为静态上限 MAXP 循环 + 运行时 If 守卫
  - 条件语句：with T.If(cond): with T.Then(): body（eager 模式必须显式 Then）
  - 标量表达式仅支持 Add/Sub/Mul/Div/比较/if_then_else/tl.infinity，
    无 T.max/T.min/T.exp 标量形态 → softmax 全部向量化：
      exp   走 SimdVF 内 T.vexp（vsub 先减 max）
      max   走 T.if_then_else(a > b, a, b)
    标量状态放 (1,) shared，参与向量运算前先广播到 64/128 宽 staging
  - 已验证算子形态来源：vadd/vmul/vsub/vexp/vcvt（elementwise_kernels）、
    T.reduce_sum/max dim=1（reduce_api_kernels）

刻意走已验证路径：
  - 纯 Vector 路线（无 T.gemm/Cube）：QK 用 T.vmul + T.reduce_sum(dim=1)
  - kv_len % PAGE == 0 前提（页对齐 cache），无掩码分支
  - reduce 的 (1, BN) dim=1 归约沿用 reduce_api 已验证形态族

shape（静态编译期）：B=2, H=2, D=128, PAGE=16, MAXP=8，
  池容量 = B*MAXP*PAGE = 256 行；每请求容量 MAXP*PAGE = 128 key。
"""

import os

import tilelang
import tilelang.language as T

B, H, D, PAGE, MAXP = 2, 2, 128, 16, 8
POOL = B * MAXP * PAGE
BN = PAGE  # 一个 key tile 恰好一页：base = block_table[bb, t] * PAGE，无页内偏移
VW = 64    # VF 向量宽度（f32 lane 数），标量广播 staging 用

NEG_FLOOR = -1.0e38  # 运行 max 的有限下界；避免 -inf - -inf 产生 NaN


def paged_decode_probe():
    dtype = "bfloat16"
    accum = "float32"

    @T.prim_func
    def paged_decode_probe_kernel(
        Q: T.Buffer((B, H, D), dtype),            # seqlen_q == 1，压掉 q 维
        K: T.Buffer((POOL, H, D), dtype),         # 物理页池
        V: T.Buffer((POOL, H, D), dtype),
        real_seqlen_kv: T.Buffer((B,), "int32"),
        block_table: T.Buffer((B, MAXP), "int32"),
        OUT: T.Buffer((B, H, D), dtype),
    ):
        with T.Kernel(B) as bx:
            # producer 不支持对 grid 变量做整除/取模 → grid 只承载 batch 维
            bb = bx

            # GM <-> SimdVF 搬运用 bf16 shared；SimdVF 内计算全 f32
            q_s = T.alloc_shared((D,), dtype)
            q_bb = T.alloc_shared((BN, D), dtype)     # q 广播 (BN, D) bf16
            k_s = T.alloc_shared((BN, D), dtype)
            v_s = T.alloc_shared((BN, D), dtype)
            o_s = T.alloc_shared((D,), dtype)
            # f32 shared：SimdVF 产物落点 + 线程域 softmax 工作区
            q_b = T.alloc_shared((BN, D), accum)      # q 广播 (BN, D) f32
            kf32_s = T.alloc_shared((BN, D), accum)
            vf32_s = T.alloc_shared((BN, D), accum)
            scores = T.alloc_shared((BN,), accum)     # QK 一行（vreduce 产物）
            p2 = T.alloc_shared((BN,), accum)         # exp 后概率
            mn_bn = T.alloc_shared((BN,), accum)      # m_new 的 (BN,) 广播
            acc_s = T.alloc_shared((D,), accum)
            rb_s = T.alloc_shared((D,), accum)        # resc 的 (D,) 广播
            # 标量状态：线程域按 [0] 读写；向量域前先广播 staging
            tmax = T.alloc_shared((1,), accum)
            m_new = T.alloc_shared((1,), accum)
            m_run = T.alloc_shared((1,), accum)
            l_run = T.alloc_shared((1,), accum)
            tsum = T.alloc_shared((1,), accum)
            resc = T.alloc_shared((1,), accum)
            diff_s = T.alloc_shared((VW,), accum)     # m_run 的 64 宽广播
            mn_s = T.alloc_shared((VW,), accum)       # m_new 的 64 宽广播
            resc_s = T.alloc_shared((VW,), accum)     # exp(m_run - m_new) 产物

            for hh in T.serial(H):
                T.copy(Q[bb, hh, 0:D], q_s)
                # 同 dtype 广播（bf16），再 SimdVF 内 vcvt 成 f32
                for s, d in T.Parallel(BN, D):
                    q_bb[s, d] = q_s[d]

                with T.SimdVF():
                    qb_f = T.alloc_frag((BN, D), dtype)
                    qb32_f = T.alloc_frag((BN, D), accum)
                    T.copy(q_bb[0:BN, 0:D], qb_f)
                    T.vcvt(qb_f, qb32_f, accum)
                    T.copy(qb32_f[0:BN, 0:D], q_b[0:BN, 0:D])

                for d in T.Parallel(D):
                    acc_s[d] = 0.0
                m_run[0] = NEG_FLOOR
                l_run[0] = 0.0

                # R2': 动态 trip count（FloorDiv extent）不被 producer 支持，
                # 退化为静态上限 MAXP 循环 + 运行时 If 守卫
                for t in T.serial(MAXP):
                    with T.If(t * BN < real_seqlen_kv[bb]):
                        with T.Then():
                            # R1: block_table 动态寻址（base 内联进切片）
                            T.copy(
                                K[block_table[bb, t] * PAGE: block_table[bb, t] * PAGE + BN, hh, 0:D],
                                k_s,
                            )
                            T.copy(
                                V[block_table[bb, t] * PAGE: block_table[bb, t] * PAGE + BN, hh, 0:D],
                                v_s,
                            )

                            with T.SimdVF():
                                kf_f = T.alloc_frag((BN, D), dtype)
                                vf_f = T.alloc_frag((BN, D), dtype)
                                kf32_f = T.alloc_frag((BN, D), accum)
                                vf32_f = T.alloc_frag((BN, D), accum)
                                T.copy(k_s[0:BN, 0:D], kf_f)
                                T.vcvt(kf_f, kf32_f, accum)
                                T.copy(kf32_f[0:BN, 0:D], kf32_s[0:BN, 0:D])
                                T.copy(v_s[0:BN, 0:D], vf_f)
                                T.vcvt(vf_f, vf32_f, accum)
                                T.copy(vf32_f[0:BN, 0:D], vf32_s[0:BN, 0:D])
                                # scores = Q · K^T：vmul + vreduce（frag 形态）
                                qb2_f = T.alloc_frag((BN, D), accum)
                                pr_f = T.alloc_frag((BN, D), accum)
                                sc_f = T.alloc_frag((BN,), accum)
                                T.copy(q_b[0:BN, 0:D], qb2_f)
                                T.vmul(qb2_f, kf32_f, pr_f)
                                T.vreduce_sum(pr_f, sc_f)
                                T.copy(sc_f[0:BN], scores[0:BN])

                            # --- 在线 softmax（全向量化）---
                            # tile max：串行标量 if_then_else 链（(1,) frag 拷贝
                            # 会生成 npu.vstore vector<1>，cce-pipeline 不支持）
                            tmax[0] = NEG_FLOOR
                            for s in T.serial(BN):
                                tmax[0] = T.if_then_else(
                                    scores[s] > tmax[0], scores[s], tmax[0]
                                )
                            # m_new = max(m_run, tmax)：标量只有 if_then_else
                            m_new[0] = T.if_then_else(
                                m_run[0] > tmax[0], m_run[0], tmax[0]
                            )
                            # resc = exp(m_run - m_new)：64 宽向量 vsub+vexp
                            for w in T.Parallel(VW):
                                diff_s[w] = m_run[0]
                                mn_s[w] = m_new[0]
                            with T.SimdVF():
                                d_f = T.alloc_frag((VW,), accum)
                                n_f = T.alloc_frag((VW,), accum)
                                e_f = T.alloc_frag((VW,), accum)
                                T.copy(diff_s[0:VW], d_f)
                                T.copy(mn_s[0:VW], n_f)
                                T.vsub(d_f, n_f, e_f)
                                T.vexp(e_f, e_f)
                                T.copy(e_f[0:VW], resc_s[0:VW])
                            resc[0] = resc_s[0]
                            m_run[0] = m_new[0]
                            # p2 = exp(scores - m_new)：(BN,) 向量 vsub+vexp
                            for s in T.Parallel(BN):
                                mn_bn[s] = m_new[0]
                            with T.SimdVF():
                                sc2_f = T.alloc_frag((BN,), accum)
                                mn_f = T.alloc_frag((BN,), accum)
                                p_f = T.alloc_frag((BN,), accum)
                                T.copy(scores[0:BN], sc2_f)
                                T.copy(mn_bn[0:BN], mn_f)
                                T.vsub(sc2_f, mn_f, p_f)
                                T.vexp(p_f, p_f)
                                T.copy(p_f[0:BN], p2[0:BN])
                            # 行和：串行标量累加（规避 (1,) vstore）
                            tsum[0] = 0.0
                            for s in T.serial(BN):
                                tsum[0] = tsum[0] + p2[s]
                            l_run[0] = l_run[0] * resc[0] + tsum[0]
                            # acc *= resc：(D,) 向量 vmul
                            for d in T.Parallel(D):
                                rb_s[d] = resc[0]
                            with T.SimdVF():
                                af = T.alloc_frag((D,), accum)
                                rf = T.alloc_frag((D,), accum)
                                T.copy(acc_s[0:D], af)
                                T.copy(rb_s[0:D], rf)
                                T.vmul(af, rf, af)
                                T.copy(af[0:D], acc_s[0:D])

                            # PV：p 加权累加 V（serial x vector FMA，规避 dim=0 归约）
                            for s in T.serial(BN):
                                for d in T.Parallel(D):
                                    acc_s[d] = acc_s[d] + p2[s] * vf32_s[s, d]

                for d in T.Parallel(D):
                    acc_s[d] = acc_s[d] / l_run[0]

                # f32 -> bf16 出板：SimdVF 内 vcvt
                with T.SimdVF():
                    acc_f = T.alloc_frag((D,), accum)
                    ob_f = T.alloc_frag((D,), dtype)
                    T.copy(acc_s[0:D], acc_f)
                    T.vcvt(acc_f, ob_f, dtype)
                    T.copy(ob_f[0:D], o_s[0:D])
                T.copy(o_s[0:D], OUT[bb, hh, 0:D])

    return paged_decode_probe_kernel


if __name__ == "__main__":
    program = paged_decode_probe()
    artifact = tilelang.lower(program, target="tile")
    out_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "1_paged_decode_probe_tilelangir.mlir"
    )
    with open(out_path, "w") as f:
        f.write(artifact.kernel_source)
    print(f"mlir saved to: {out_path}")

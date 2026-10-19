"""v1a 最小 decode kernel：单请求单头 S_q=1, D=128, 单页 PAGE=128, fp16, 定长无 mask。

结构完整复用 tilelang/examples/ascend/flash_attention/core.py 的宏族：
qk -> softmax(NZ packing) -> pack_p -> pv -> accumulate_output -> finalize_cast。
仅改三处：
  1. 形状: BR=16 (S_q=1 由 host 补零到 16 行), ROWS=8, BC=128, NUM_KV_BLOCKS=1
  2. dtype: bf16 -> float16 (NZ 打包的 make_ubuf_ptr/vcvt/vsstb 类型串)
  3. 去掉 LSE 输出与 online-softmax 多块遍历（单页时 alpha=exp(-inf-m)=0，
     l = row_sum，finalize 直接除 l —— 宏逻辑天然退化正确）

预期：O row0 == softmax(q @ K^T * scale) @ V，rel < 5e-2；row1-15 有限即可（补零行）。
"""

import math
import sys
import traceback

import torch
import tilelang
import tilelang.ascend.language as T
from tilelang.layout import make_ascend_compact_nz_layout
from tilelang.ascend.language import simd as S

D = 128
BR = 16          # 补零后的 M 行数（S_q=1 + 15 行零）
ROWS = BR // 2   # 每 AIV 半片行数
BC = 128         # == 2*VL，softmax NZ 打包硬约束
VL = 64          # Ascend fp32 SIMD lane 数
PAGE = 128       # 单页 K/V 行数
NUM_KV = PAGE // BC
dtype = "float16"
accum_dtype = "float32"
out_dtype = "float16"
scale = 1.0 / math.sqrt(D)


@T.macro
def qk(kv, K, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub):
    T.copy(K[kv * BC:(kv + 1) * BC, 0:D], K_shared[0:BC, 0:D])
    T.copy(Q_shared[0:BR, 0:D], qk_a_l0)
    T.copy(K_shared[0:BC, 0:D], qk_b_l0)
    T.gemm(qk_a_l0, qk_b_l0, qk_acc_l0c, transpose_B=True, clear_accum=True)
    T.dual_copy(qk_acc_l0c, S_ub[0:ROWS, 0:BC])


@T.macro
def softmax(S_ub, P_nz_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub):
    with T.SimdVF(latency=735):
        softmax_full = S.pset(32, "PAT_ALL")
        softmax_one = S.pset(32, "PAT_VL1")
        softmax_b16 = S.pset(16, "PAT_VL128")
        dst_nz_ptr = S.make_ubuf_ptr(
            T.access_ptr(P_nz_ub[0, 0], "w", ROWS + 1, BC),
            "float16",
        )

        S.vsts(old_m_ub[0], S.vld(m_ub[0], "NORM"), softmax_full, "NORM_B32")

        for r in range(0, ROWS, 2):
            s00 = S.vmuls(S.vld(S_ub[r, 0], "NORM"), T.float32(scale), softmax_full)
            s01 = S.vmuls(S.vld(S_ub[r, VL], "NORM"), T.float32(scale), softmax_full)
            s10 = S.vmuls(S.vld(S_ub[r + 1, 0], "NORM"), T.float32(scale), softmax_full)
            s11 = S.vmuls(S.vld(S_ub[r + 1, VL], "NORM"), T.float32(scale), softmax_full)
            S.vsts(S_ub[r, 0], s00, softmax_full, "NORM_B32")
            S.vsts(S_ub[r, VL], s01, softmax_full, "NORM_B32")
            S.vsts(S_ub[r + 1, 0], s10, softmax_full, "NORM_B32")
            S.vsts(S_ub[r + 1, VL], s11, softmax_full, "NORM_B32")

            max0 = S.vcmax(S.vmax(s00, s01, softmax_full), softmax_full)
            max1 = S.vcmax(S.vmax(s10, s11, softmax_full), softmax_full)
            S.vsts(m_ub[r], max0, softmax_one, "ONEPT_B32")
            S.vsts(m_ub[r + 1], max1, softmax_one, "ONEPT_B32")

        S.mem_bar("VST_VLD")
        merged_max = S.vmax(S.vld(m_ub[0], "NORM"), S.vld(old_m_ub[0], "NORM"), softmax_full)
        S.vsts(m_ub[0], merged_max, softmax_full, "NORM_B32")
        S.mem_bar("VST_VLD")

        for r in range(0, ROWS, 2):
            max0 = S.vld(m_ub[r], "BRC_B32")
            max1 = S.vld(m_ub[r + 1], "BRC_B32")
            p00, p01 = S.vld2(S_ub[r, 0], "DINTLV_B32")
            p10, p11 = S.vld2(S_ub[r + 1, 0], "DINTLV_B32")
            e00 = S.vexpdif(p00, max0, softmax_full)
            e10 = S.vexpdif(p10, max1, softmax_full)
            e01 = S.vexpdif(p01, max0, softmax_full)
            e11 = S.vexpdif(p11, max1, softmax_full)
            row_sum0 = S.vcadd(S.vadd(e00, e01, softmax_full), softmax_full)
            row_sum1 = S.vcadd(S.vadd(e10, e11, softmax_full), softmax_full)
            S.vsts(row_sum_ub[r], row_sum0, softmax_one, "ONEPT_B32")
            S.vsts(row_sum_ub[r + 1], row_sum1, softmax_one, "ONEPT_B32")

            even_f16_0 = S.vcvt(e00, "float16", softmax_full, sat=False, part=0)
            even_f16_1 = S.vcvt(e10, "float16", softmax_full, sat=False, part=0)
            odd_f16_0 = S.vcvt(e01, "float16", softmax_full, sat=False, part=1)
            odd_f16_1 = S.vcvt(e11, "float16", softmax_full, sat=False, part=1)
            merged_bits0 = S.vor(
                T.reinterpret(even_f16_0, "uint16x128"),
                T.reinterpret(odd_f16_0, "uint16x128"),
                softmax_b16,
            )
            merged_bits1 = S.vor(
                T.reinterpret(even_f16_1, "uint16x128"),
                T.reinterpret(odd_f16_1, "uint16x128"),
                softmax_b16,
            )
            dst_nz_ptr = S.vsstb(
                T.reinterpret(merged_bits0, "float16x128"),
                dst_nz_ptr,
                T.int32(((ROWS + 1) << 16) | 1),
                softmax_b16,
                update=True,
            )
            dst_nz_ptr = S.vsstb(
                T.reinterpret(merged_bits1, "float16x128"),
                dst_nz_ptr,
                T.int32(((ROWS + 1) << 16) | 1),
                softmax_b16,
                update=True,
            )

        S.mem_bar("VST_VLD")
        alpha_reg = S.vexpdif(S.vld(old_m_ub[0], "NORM"), S.vld(m_ub[0], "NORM"), softmax_full)
        S.vsts(alpha_ub[0], alpha_reg, softmax_full, "NORM_B32")
        l_scaled = S.vmul(S.vld(l_ub[0], "NORM"), alpha_reg, softmax_full)
        l_updated = S.vadd(l_scaled, S.vld(row_sum_ub[0], "NORM"), softmax_full)
        S.vsts(l_ub[0], l_updated, softmax_full, "NORM_B32")


@T.macro
def pack_p(P_nz_ub, P_shared):
    T.dual_copy(P_nz_ub[0:ROWS, 0:BC], P_shared[0:BR, 0:BC])


@T.macro
def pv(kv, V, P_shared, V_shared, pv_a_l0, pv_b_l0, pv_acc_l0c, O_tmp_ub):
    T.copy(V[kv * BC:(kv + 1) * BC, 0:D], V_shared[0:D, 0:BC], transpose=True)
    T.copy(P_shared[0:BR, 0:BC], pv_a_l0)
    T.copy(V_shared[0:D, 0:BC], pv_b_l0)
    T.gemm(pv_a_l0, pv_b_l0, pv_acc_l0c, transpose_B=True, clear_accum=True)
    T.dual_copy(pv_acc_l0c, O_tmp_ub[0:ROWS, 0:D])


@T.macro
def accumulate_output(O_tmp_ub, O_ub, alpha_ub):
    with T.SimdVF(latency=318):
        rescale_mask = S.pset(32, "PAT_ALL")
        for i in range(ROWS):
            alpha = S.vld(alpha_ub[i], "BRC_B32")
            for c in range(0, D, VL):
                prev = S.vld(O_ub[i, c], "NORM")
                cur = S.vld(O_tmp_ub[i, c], "NORM")
                updated = S.vadd(S.vmul(alpha, prev, rescale_mask), cur, rescale_mask)
                S.vsts(O_ub[i, c], updated, rescale_mask, "NORM_B32")


@T.macro
def init_m_l(m_ub, l_ub):
    with T.SimdVF(latency=400):
        init_mask = S.pset(32, "PAT_ALL")
        zero = S.vdup(T.float32(0.0), accum_dtype, init_mask)
        initial_m = S.vdup(-T.infinity(accum_dtype), accum_dtype, init_mask)
        S.vsts(l_ub[0], zero, init_mask, "NORM_B32")
        S.vsts(m_ub[0], initial_m, init_mask, "NORM_B32")


@T.macro
def clear_O_ub(O_ub):
    with T.SimdVF(latency=142):
        clear_mask = S.pset(32, "PAT_ALL")
        output_zero = S.vdup(T.float32(0.0), accum_dtype, clear_mask)
        for i in range(ROWS):
            for c in range(0, D, VL):
                S.vsts(O_ub[i, c], output_zero, clear_mask, "NORM_B32")


@T.macro
def kv_body(kv, K, V, Q_shared, K_shared, V_shared, P_shared,
            qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0, qk_acc_l0c, pv_acc_l0c,
            S_ub, P_nz_ub, O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub):
    qk(kv, K, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub)
    softmax(S_ub, P_nz_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub)
    pack_p(P_nz_ub, P_shared)
    pv(kv, V, P_shared, V_shared, pv_a_l0, pv_b_l0, pv_acc_l0c, O_tmp_ub)
    accumulate_output(O_tmp_ub, O_ub, alpha_ub)


@T.macro
def finalize_cast(O, O_ub, O_cast_ub, l_ub):
    with T.SimdVF(latency=1780):
        normalize_mask = S.pset(32, "PAT_ALL")
        for i in range(ROWS):
            denominator = S.vld(l_ub[i], "BRC_B32")
            for c in range(0, D, VL):
                normalized = S.vdiv(S.vld(O_ub[i, c], "NORM"), denominator, normalize_mask)
                S.vsts(O_ub[i, c], normalized, normalize_mask, "NORM_B32")
    with T.SimdVF(latency=193):
        cast_full = S.pset(32, "PAT_ALL")
        for r in range(ROWS):
            for c in range(0, D, VL):
                ob = S.vcvt(S.vld(O_ub[r, c], "NORM"), out_dtype, cast_full)
                S.vsts(O_cast_ub[r, c], ob, cast_full, "PK_B32")
    T.dual_copy(O_cast_ub[0:ROWS, 0:D], O[0:BR, 0:D])


def build(use_pipelined):
    @T.prim_func
    def main(
        Q: T.Buffer((BR, D), dtype),
        K: T.Buffer((PAGE, D), dtype),
        V: T.Buffer((PAGE, D), dtype),
        O: T.Buffer((BR, D), out_dtype),
    ):
        with T.Kernel(1) as bx:
            Q_shared = T.alloc_l1((BR, D), dtype)
            K_shared = T.alloc_l1((BC, D), dtype)
            V_shared = T.alloc_l1((D, BC), dtype)
            P_shared = T.alloc_l1((BR, BC), dtype)

            qk_a_l0 = T.alloc_l0a((BR, D), dtype)
            qk_b_l0 = T.alloc_l0b((BC, D), dtype)
            pv_a_l0 = T.alloc_l0a((BR, BC), dtype)
            pv_b_l0 = T.alloc_l0b((D, BC), dtype)
            qk_acc_l0c = T.alloc_l0c((BR, BC), accum_dtype)
            pv_acc_l0c = T.alloc_l0c((BR, D), accum_dtype)

            S_ub = T.alloc_shared((ROWS, BC), accum_dtype)
            P_nz_ub = T.alloc_shared((ROWS + 1, BC), dtype)
            T.annotate_layout({P_nz_ub: make_ascend_compact_nz_layout(P_nz_ub)})
            O_tmp_ub = T.alloc_shared((ROWS, D), accum_dtype)
            O_ub = T.alloc_shared((ROWS, D), accum_dtype)
            # 注意：softmax/init 宏里对 m/l/alpha 等的 PAT_ALL 向量操作固定读写
            # 64 lane（例子 ROWS=64 恰好贴合）；ROWS<64 时必须分配 64 元素防越界，
            # 循环只使用前 ROWS 个标量，多余 lane 为垃圾但无影响。
            m_ub = T.alloc_shared((VL,), accum_dtype)
            l_ub = T.alloc_shared((VL,), accum_dtype)
            alpha_ub = T.alloc_shared((VL,), accum_dtype)
            old_m_ub = T.alloc_shared((VL,), accum_dtype)
            row_sum_ub = T.alloc_shared((VL,), accum_dtype)
            T.annotate_buffer_versions(
                {
                    K_shared: 3,
                    V_shared: 3,
                    qk_acc_l0c: 2,
                    pv_acc_l0c: 2,
                    S_ub: 3,
                    P_nz_ub: 2,
                    alpha_ub: 3,
                    O_tmp_ub: 2,
                }
            )

            T.copy(Q[0:BR, 0:D], Q_shared[0:BR, 0:D])
            init_m_l(m_ub, l_ub)
            clear_O_ub(O_ub)

            if use_pipelined:
                for kv in T.Pipelined(NUM_KV, num_stages=1,
                                      annotations={"enable_offset": True}):
                    kv_body(kv, K, V, Q_shared, K_shared, V_shared, P_shared,
                            qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0, qk_acc_l0c, pv_acc_l0c,
                            S_ub, P_nz_ub, O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub,
                            old_m_ub, row_sum_ub)
            else:
                for kv in T.serial(NUM_KV):
                    kv_body(kv, K, V, Q_shared, K_shared, V_shared, P_shared,
                            qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0, qk_acc_l0c, pv_acc_l0c,
                            S_ub, P_nz_ub, O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub,
                            old_m_ub, row_sum_ub)

            O_cast_ub = T.alloc_shared((ROWS, D), out_dtype)
            finalize_cast(O, O_ub, O_cast_ub, l_ub)

    return main


def ref_attention(q, k, v):
    s = (q.float() @ k.float().T) * scale
    p = torch.softmax(s, dim=-1)
    return p @ v.float()


def main():
    print("=== v1a decode kernel: build & compile ===")
    kernel = None
    for pipelined in (False, True):
        try:
            fn = build(use_pipelined=pipelined)
            kernel = tilelang.compile(fn)
            print(f"COMPILE_OK (loop={'Pipelined' if pipelined else 'serial'})")
            break
        except Exception:
            tb = traceback.format_exc().strip().splitlines()
            keep = [l for l in tb if "Error" in l or "Check failed" in l or "error:" in l]
            print(f"COMPILE_FAIL (loop={'Pipelined' if pipelined else 'serial'}):")
            for line in (keep or tb)[-6:]:
                print("   ", line)
    if kernel is None:
        print("FATAL: both loop forms failed to compile")
        sys.exit(1)

    print("=== run on NPU & compare ===")
    dev = torch.device("npu")
    torch.manual_seed(0)
    q = torch.randn(1, D, dtype=torch.float16, device=dev)
    q_pad = torch.cat([q, torch.zeros(BR - 1, D, dtype=torch.float16, device=dev)], dim=0)
    k = torch.randn(PAGE, D, dtype=torch.float16, device=dev)
    v = torch.randn(PAGE, D, dtype=torch.float16, device=dev)
    o = torch.zeros(BR, D, dtype=torch.float16, device=dev)

    kernel(q_pad, k, v, o)
    torch.npu.synchronize()

    assert torch.isfinite(o.float()).all(), "output contains non-finite values"
    exp = ref_attention(q, k, v)[0]
    got = o[0].float()
    diff = (got - exp).abs()
    rel = (diff / (exp.abs() + 1e-6)).max().item()
    max_abs = diff.max().item()
    ok = rel < 5e-2
    print(f"max_abs_diff={max_abs:.6f} max_rel={rel:.6f}")
    print("PASS: v1a" if ok else "FAIL: v1a accuracy")
    sys.exit(0 if ok else 2)


if __name__ == "__main__":
    main()

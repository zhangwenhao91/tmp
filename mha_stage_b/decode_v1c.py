"""v1c-d2：加性掩码版变长分页 decode（B=2, W=2, fp16, serial）。

消融结论（上一轮）：
  - C1/C2 的 b0 均为 0.0122 PASS → T.If / bx 索引 / BT 二维标量 load 全部无罪
  - C3（vmin 钳位）b0 反而挂 → S.vmin + vdup(-1e30) 路径会破坏有效分数，弃用
  - b1 在 C1/C2 挂属预期：rl=100 尾块第 100~127 行为垃圾数据，需要块内掩码

本轮方案：加性偏置掩码
  - 主机按 rl 预生成 BIAS [B*W, BC] fp32（有效位 0，无效位 -1e30）
  - kv_body 里 GM→UB 拷入 bias_ub，softmax 中 s = vadd(s, bias)
  - 整页 batch（b0, rl=256）bias 全 0，严格不干扰基础路径
  - 尾块（b1, rl=100）第 100~127 位加 -1e30，exp 后权重归 0

变体：
  D1_if_bias   If 守卫 + 掩码（完整 v1c 形态，b0/b1 都应 PASS）
  D2_noif_bias 无 If + 掩码（隔离掩码路径；b1 的整块无效页仍会以均匀权重
               混入垃圾 V，b1 FAIL 属预期，看 b0 是否 PASS）
"""

import math
import traceback

import torch
import tilelang
import tilelang.ascend.language as T
from tilelang.layout import make_ascend_compact_nz_layout
from tilelang.ascend.language import simd as S

D = 128
BR = 16
ROWS = BR // 2
BC = 128
VL = 64
B = 2
W = 2
POOL_PAGES = 8
POOL_ROWS = POOL_PAGES * BC
NUM_KV = W
dtype = "float16"
accum_dtype = "float32"
out_dtype = "float16"
scale = 1.0 / math.sqrt(D)
NEG_BIG = T.float32(-1.0e30)


@T.macro
def qk(kv, BT, bx, KP, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub):
    pid = BT[bx, kv]
    T.copy(KP[pid * BC:(pid + 1) * BC, 0:D], K_shared[0:BC, 0:D])
    T.copy(Q_shared[0:BR, 0:D], qk_a_l0)
    T.copy(K_shared[0:BC, 0:D], qk_b_l0)
    T.gemm(qk_a_l0, qk_b_l0, qk_acc_l0c, transpose_B=True, clear_accum=True)
    T.dual_copy(qk_acc_l0c, S_ub[0:ROWS, 0:BC])


@T.macro
def softmax(S_ub, P_nz_ub, bias_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub):
    with T.SimdVF(latency=735):
        softmax_full = S.pset(32, "PAT_ALL")
        softmax_one = S.pset(32, "PAT_VL1")
        softmax_b16 = S.pset(16, "PAT_VL128")
        dst_nz_ptr = S.make_ubuf_ptr(
            T.access_ptr(P_nz_ub[0, 0], "w", ROWS + 1, BC),
            "float16",
        )

        S.vsts(old_m_ub[0], S.vld(m_ub[0], "NORM"), softmax_full, "NORM_B32")

        # 加性掩码：每行的 128 个 kv 位置拆两个 64-lane 半段，全 batch 共享
        b_lo = S.vld(bias_ub[0], "NORM")
        b_hi = S.vld(bias_ub[VL], "NORM")

        for r in range(0, ROWS, 2):
            s00 = S.vadd(S.vmuls(S.vld(S_ub[r, 0], "NORM"), T.float32(scale), softmax_full),
                         b_lo, softmax_full)
            s01 = S.vadd(S.vmuls(S.vld(S_ub[r, VL], "NORM"), T.float32(scale), softmax_full),
                         b_hi, softmax_full)
            s10 = S.vadd(S.vmuls(S.vld(S_ub[r + 1, 0], "NORM"), T.float32(scale), softmax_full),
                         b_lo, softmax_full)
            s11 = S.vadd(S.vmuls(S.vld(S_ub[r + 1, VL], "NORM"), T.float32(scale), softmax_full),
                         b_hi, softmax_full)
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
def pv(kv, BT, bx, VP, P_shared, V_shared, pv_a_l0, pv_b_l0, pv_acc_l0c, O_tmp_ub):
    pid = BT[bx, kv]
    T.copy(VP[pid * BC:(pid + 1) * BC, 0:D], V_shared[0:D, 0:BC], transpose=True)
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
def kv_body(kv, BT, BIAS, bx, KP, VP, Q_shared, K_shared, V_shared, P_shared,
            qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0, qk_acc_l0c, pv_acc_l0c,
            S_ub, P_nz_ub, bias_ub, O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub,
            old_m_ub, row_sum_ub):
    T.copy(BIAS[bx * W + kv, 0:BC], bias_ub[0:BC])
    qk(kv, BT, bx, KP, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub)
    softmax(S_ub, P_nz_ub, bias_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub)
    pack_p(P_nz_ub, P_shared)
    pv(kv, BT, bx, VP, P_shared, V_shared, pv_a_l0, pv_b_l0, pv_acc_l0c, O_tmp_ub)
    accumulate_output(O_tmp_ub, O_ub, alpha_ub)


@T.macro
def finalize_cast(O, bx, O_ub, O_cast_ub, l_ub):
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
    T.dual_copy(O_cast_ub[0:ROWS, 0:D], O[bx * BR:(bx + 1) * BR, 0:D])


def build(use_if):
    @T.prim_func
    def main(
        Q: T.Buffer((B * BR, D), dtype),
        BT: T.Buffer((B, W), "int32"),
        RL: T.Buffer((B,), "int32"),
        BIAS: T.Buffer((B * W, BC), accum_dtype),
        KP: T.Buffer((POOL_ROWS, D), dtype),
        VP: T.Buffer((POOL_ROWS, D), dtype),
        O: T.Buffer((B * BR, D), out_dtype),
    ):
        with T.Kernel(B) as bx:
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
            bias_ub = T.alloc_shared((BC,), accum_dtype)
            O_tmp_ub = T.alloc_shared((ROWS, D), accum_dtype)
            O_ub = T.alloc_shared((ROWS, D), accum_dtype)
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

            T.copy(Q[bx * BR:(bx + 1) * BR, 0:D], Q_shared[0:BR, 0:D])
            init_m_l(m_ub, l_ub)
            clear_O_ub(O_ub)

            rl = RL[bx]
            for kv in T.serial(NUM_KV):
                if use_if:
                    with T.If(kv * BC < rl):
                        with T.Then():
                            kv_body(kv, BT, BIAS, bx, KP, VP, Q_shared, K_shared, V_shared,
                                    P_shared, qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0,
                                    qk_acc_l0c, pv_acc_l0c, S_ub, P_nz_ub, bias_ub,
                                    O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub,
                                    old_m_ub, row_sum_ub)
                else:
                    kv_body(kv, BT, BIAS, bx, KP, VP, Q_shared, K_shared, V_shared,
                            P_shared, qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0,
                            qk_acc_l0c, pv_acc_l0c, S_ub, P_nz_ub, bias_ub,
                            O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub,
                            old_m_ub, row_sum_ub)

            O_cast_ub = T.alloc_shared((ROWS, D), out_dtype)
            finalize_cast(O, bx, O_ub, O_cast_ub, l_ub)

    return main


def ref_paged_attention_row(q, bt, rl, kp, vp):
    pages_k, pages_v = [], []
    remaining = int(rl)
    for p in bt:
        take = min(BC, remaining)
        if take <= 0:
            break
        pages_k.append(kp[int(p) * BC:int(p) * BC + take])
        pages_v.append(vp[int(p) * BC:int(p) * BC + take])
        remaining -= take
    k = torch.cat(pages_k, dim=0)
    v = torch.cat(pages_v, dim=0)
    s = (q.float() @ k.float().T) * scale
    p = torch.softmax(s, dim=-1)
    return p @ v.float()


def rel_of(got, exp):
    return ((got - exp).abs() / (exp.abs() + 1e-6)).max().item()


def main():
    dev = torch.device("npu")
    torch.manual_seed(0)
    q = torch.randn(B, D, dtype=torch.float16, device=dev)
    q_pad = torch.zeros(B * BR, D, dtype=torch.float16, device=dev)
    for b in range(B):
        q_pad[b * BR:b * BR + 1] = q[b]
    kp = torch.randn(POOL_ROWS, D, dtype=torch.float16, device=dev)
    vp = torch.randn(POOL_ROWS, D, dtype=torch.float16, device=dev)
    bt = torch.tensor([[3, 0], [5, 2]], dtype=torch.int32, device=dev)
    rl = torch.tensor([256, 100], dtype=torch.int32, device=dev)

    # 加性掩码：全局 kv 位置 < rl[b] 为有效（0），否则 -1e30
    pos = torch.arange(W * BC, dtype=torch.float32, device=dev).view(1, W * BC)
    bias = torch.where(pos < rl.view(B, 1).float(), 0.0, -1.0e30).view(B * W, BC)

    # golden（fp32）
    exp_b0 = ref_paged_attention_row(q[0], bt[0], rl[0], kp, vp)
    exp_b1 = ref_paged_attention_row(q[1], bt[1], rl[1], kp, vp)

    variants = {
        "D1_if_bias": (True,),
        "D2_noif_bias": (False,),
    }

    results = {}
    for name, (use_if,) in variants.items():
        print(f"\n--- variant {name}: compiling ---")
        try:
            kernel = tilelang.compile(build(use_if))
        except Exception:
            tb = traceback.format_exc().strip().splitlines()
            keep = [l for l in tb if "Error" in l or "Check failed" in l or "error:" in l]
            print(f"COMPILE_FAIL {name}:")
            for line in (keep or tb)[-6:]:
                print("   ", line)
            continue
        print(f"COMPILE_OK {name}")
        o = torch.zeros(B * BR, D, dtype=torch.float16, device=dev)
        try:
            kernel(q_pad, bt, rl, bias, kp, vp, o)
            torch.npu.synchronize()
            finite = torch.isfinite(o.float()).all().item()
            r0 = rel_of(o[0].float(), exp_b0)
            r1 = rel_of(o[BR].float(), exp_b1)
            results[name] = (finite, r0, r1)
            print(f"{name}: finite={finite} b0_rel={r0:.4f} b1_rel={r1:.4f}")
            print(f"   b0 got[:4] ={o[0, :4].float().tolist()}")
            print(f"   b0 exp[:4] ={exp_b0[:4].tolist()}")
            print(f"   b1 got[:4] ={o[BR, :4].float().tolist()}")
            print(f"   b1 exp[:4] ={exp_b1[:4].tolist()}")
        except Exception:
            tb = traceback.format_exc().strip().splitlines()
            print(f"RUN_FAIL {name}:")
            for line in tb[-4:]:
                print("   ", line)

    print("\n=== ablation verdict ===")
    for name, (finite, r0, r1) in results.items():
        verdict_b1 = "PASS" if r1 < 5e-2 else ("FAIL(expect in D2)" if name == "D2_noif_bias" else "FAIL")
        print(f"{name}: b0 {'PASS' if r0 < 5e-2 else 'FAIL'}, b1 {verdict_b1}")


if __name__ == "__main__":
    main()

"""v1d-d5：查 GA2/GF 残留 0.155 (15.5%) 误差的来源。

v1d-d4 结论：
  - 逐行 1D UB→GM store 是主犯：GA2/GF（dual_copy 块存）把 rel 从
    156/826 降到 0.155/0.0857；GE/GQ 逐位同坏
  - bias 2D copy（④）与 Q 拷贝路径（⑤）均无罪（GF==GA2，GQ==GE 逐位一致）

残留问题：0.155 仍超 5%。注意 d3 的 GC"pad 无罪"结论是在 store 坏掉时测的，
作废。头号嫌疑：未初始化 Q_shared pad 行（4~15 行随机位，可能含 Inf/NaN
fp16）经 softmax/gemm 的某条隐藏路径污染真行。

本轮变体（全部 H=1 非因果，块存，rl=[300,3]）：
  GF_ctrl   d4 的 GF 原样（对照，预期 0.155）
  GF_qpad   ZP 零行填 Q_shared[S_Q:BR]（若 rel 掉回 v1c 量级 ~0.01 -> pad 真凶）
两变体输出统一细粒度诊断：逐行 max_rel、rel>5% 元素计数、最大误差元素的
(b,row,col,got,exp,|exp|)，区分"个别近零分母放大"与"面污染"。
另附主机 fp16 量化 golden 对照，评估 fp16 softmax 的本征误差量级。
"""

import math
import traceback

import torch
import tilelang
import tilelang.ascend.language as T
from tilelang.layout import make_ascend_compact_nz_layout
from tilelang.ascend.language import simd as S

D = 128
B = 2
S_Q = 4
BR = 16
ROWS = BR // 2
BC = 128
VL = 64
W = 3
POOL_PAGES = 8
POOL_ROWS = POOL_PAGES * BC
NUM_KV = W
dtype = "float16"
accum_dtype = "float32"
out_dtype = "float16"
scale = 1.0 / math.sqrt(D)
NEG_BIG = T.float32(-1.0e30)


@T.macro
def qk(kv, BT, b, h, KP, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub):
    pid = BT[b, kv]
    T.copy(KP[pid * BC:(pid + 1) * BC, h, 0:D], K_shared[0:BC, 0:D])
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

        sh_lo = S.vld(bias_ub[0, 0], "NORM")
        sh_hi = S.vld(bias_ub[0, VL], "NORM")

        for r in range(0, ROWS, 2):
            s00 = S.vadd(S.vmuls(S.vld(S_ub[r, 0], "NORM"), T.float32(scale), softmax_full),
                         sh_lo, softmax_full)
            s01 = S.vadd(S.vmuls(S.vld(S_ub[r, VL], "NORM"), T.float32(scale), softmax_full),
                         sh_hi, softmax_full)
            s10 = S.vadd(S.vmuls(S.vld(S_ub[r + 1, 0], "NORM"), T.float32(scale), softmax_full),
                         sh_lo, softmax_full)
            s11 = S.vadd(S.vmuls(S.vld(S_ub[r + 1, VL], "NORM"), T.float32(scale), softmax_full),
                         sh_hi, softmax_full)
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
def pv(kv, BT, b, h, VP, P_shared, V_shared, pv_a_l0, pv_b_l0, pv_acc_l0c, O_tmp_ub):
    pid = BT[b, kv]
    T.copy(VP[pid * BC:(pid + 1) * BC, h, 0:D], V_shared[0:D, 0:BC], transpose=True)
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
def kv_body(kv, BT, BIAS, b, h, KP, VP, Q_shared, K_shared, V_shared, P_shared,
            qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0, qk_acc_l0c, pv_acc_l0c,
            S_ub, P_nz_ub, bias_ub, O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub,
            old_m_ub, row_sum_ub):
    T.copy(BIAS[b * BR:(b + 1) * BR, kv * BC:(kv + 1) * BC], bias_ub[0:BR, 0:BC])
    qk(kv, BT, b, h, KP, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub)
    softmax(S_ub, P_nz_ub, bias_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub)
    pack_p(P_nz_ub, P_shared)
    pv(kv, BT, b, h, VP, P_shared, V_shared, pv_a_l0, pv_b_l0, pv_acc_l0c, O_tmp_ub)
    accumulate_output(O_tmp_ub, O_ub, alpha_ub)


@T.macro
def finalize_cast(O, b, h, O_ub, O_cast_ub, l_ub):
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
    T.dual_copy(O_cast_ub[0:ROWS, 0:D], O[b, h, 0:BR, 0:D])


def build(qpad):
    @T.prim_func
    def main(
        Q: T.Buffer((B, S_Q, 1, D), dtype),
        BT: T.Buffer((B, W), "int32"),
        RL: T.Buffer((B,), "int32"),
        BIAS: T.Buffer((B * BR, W * BC), accum_dtype),
        KP: T.Buffer((POOL_ROWS, 1, D), dtype),
        VP: T.Buffer((POOL_ROWS, 1, D), dtype),
        ZP: T.Buffer((BR - S_Q, D), dtype),
        O: T.Buffer((B, 1, BR, D), out_dtype),
    ):
        with T.Kernel(B * 1) as bx:
            b: T.int32 = bx // 1
            h: T.int32 = bx % 1
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
            bias_ub = T.alloc_shared((BR, BC), accum_dtype)
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

            T.copy(Q[b, 0:S_Q, h, 0:D], Q_shared[0:S_Q, 0:D])
            if qpad:
                T.copy(ZP[0:BR - S_Q, 0:D], Q_shared[S_Q:BR, 0:D])
            init_m_l(m_ub, l_ub)
            clear_O_ub(O_ub)

            rl = RL[b]
            for kv in T.serial(NUM_KV):
                with T.If(kv * BC < rl):
                    with T.Then():
                        kv_body(kv, BT, BIAS, b, h, KP, VP, Q_shared, K_shared, V_shared,
                                P_shared, qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0,
                                qk_acc_l0c, pv_acc_l0c, S_ub, P_nz_ub, bias_ub,
                                O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub,
                                old_m_ub, row_sum_ub)

            O_cast_ub = T.alloc_shared((ROWS, D), out_dtype)
            finalize_cast(O, b, h, O_ub, O_cast_ub, l_ub)

    return main


def ref_mha_decode_paged(q, k_pool, v_pool, real_seqlen_kv, block_table, page_size, is_causal):
    """TileOPs workload ref_program 语义：重组逻辑 KV 后按尾对齐 causal 注意力。"""
    B_, S_q, H_, D_ = q.shape
    seqlen_kv = k_pool.shape[0]
    out = torch.zeros(B_, S_q, H_, D_, dtype=torch.float32, device=q.device)
    for i_b in range(B_):
        kv_len = int(real_seqlen_kv[i_b].item())
        k_logical = torch.zeros(seqlen_kv, H_, D_, dtype=q.dtype, device=q.device)
        v_logical = torch.zeros(seqlen_kv, H_, D_, dtype=q.dtype, device=q.device)
        num_pages = math.ceil(kv_len / page_size) if kv_len > 0 else 0
        for i_paged in range(num_pages):
            start_pos = int(block_table[i_b, i_paged].item()) * page_size
            end_pos = min(start_pos + page_size, seqlen_kv)
            page_len = end_pos - start_pos
            k_logical[i_paged * page_size:i_paged * page_size + page_len] = k_pool[start_pos:end_pos]
            v_logical[i_paged * page_size:i_paged * page_size + page_len] = v_pool[start_pos:end_pos]
        q_b = q[i_b].float().transpose(0, 1)  # [H, S_q, D]
        k_b = k_logical[:kv_len].float().transpose(0, 1)
        v_b = v_logical[:kv_len].float().transpose(0, 1)
        scores = q_b @ k_b.transpose(1, 2) * D_ ** -0.5
        if is_causal:
            last_key = torch.arange(S_q, device=q.device)[:, None] + kv_len - S_q
            visible = torch.arange(kv_len, device=q.device)[None, :] <= last_key
            scores = scores.masked_fill(~visible, float("-inf"))
        probs = scores.softmax(-1).nan_to_num(0.0)
        out[i_b] = (probs @ v_b).transpose(0, 1)
    return out


def make_bias(rl, is_causal):
    """主机 2D 加性掩码 (B*BR, W*BC)：causal 按 query 行尾对齐，pad 行全可见。"""
    pos = torch.arange(W * BC, dtype=torch.float32, device=dev).view(1, 1, W * BC)
    if is_causal:
        row_idx = torch.arange(BR, dtype=torch.float32, device=dev).view(1, BR, 1)
        last_key = row_idx + rl.view(B, 1, 1).float() - S_Q
        visible = pos <= last_key
    else:
        visible = (pos < rl.view(B, 1, 1).float()).expand(B, BR, W * BC)
    return torch.where(visible, 0.0, -1.0e30).to(torch.float32).view(B * BR, W * BC)


def diagnose(tag, got, exp):
    """got/exp: (B, S_Q, D) fp32。打印逐行 rel、超标计数、最大误差元素明细。"""
    rel = (got - exp).abs() / (exp.abs() + 1e-6)
    absd = (got - exp).abs()
    finite = torch.isfinite(got).all().item()
    over = (rel > 0.05).sum().item()
    total = rel.numel()
    print(f"  [{tag}] finite={finite} elements_over_5pct={over}/{total} "
          f"({100.0 * over / total:.2f}%)")
    for bi in range(B):
        for r in range(S_Q):
            rr = rel[bi, r].max().item()
            ad = absd[bi, r].max().item()
            print(f"    b{bi} row{r}: max_rel={rr:.4f} max_absdiff={ad:.6f} "
                  f"|exp|max={(exp[bi, r].abs().max().item()):.4f}")
    idx = rel.argmax()
    bb, rr_, cc = (idx // (S_Q * D)).item(), (idx // D % S_Q).item(), (idx % D).item()
    print(f"  [{tag}] max-rel element: b{bb} row{rr_} col{cc} "
          f"got={got[bb, rr_, cc].item():.6f} exp={exp[bb, rr_, cc].item():.6f} "
          f"(|exp|={abs(exp[bb, rr_, cc].item()):.2e})")


def main():
    global dev
    dev = torch.device("npu")
    torch.manual_seed(0)
    q = torch.randn(B, S_Q, 1, D, dtype=torch.float16, device=dev)
    kp = torch.randn(POOL_ROWS, 1, D, dtype=torch.float16, device=dev)
    vp = torch.randn(POOL_ROWS, 1, D, dtype=torch.float16, device=dev)
    bt = torch.tensor([[6, 2, 4], [1, 7, 0]], dtype=torch.int32, device=dev)
    rl = torch.tensor([300, 3], dtype=torch.int32, device=dev)
    zp = torch.zeros(BR - S_Q, D, dtype=torch.float16, device=dev)
    bias = make_bias(rl, False)
    exp = ref_mha_decode_paged(q, kp, vp, rl, bt, BC, False)  # (B, S_Q, 1, D) fp32

    variants = [
        ("GF_ctrl", False),
        ("GF_qpad", True),
    ]
    kernels = {}
    for name, qp in variants:
        print(f"\n--- variant {name} (qpad={qp}) ---")
        if qp not in kernels:
            try:
                print(f"compiling kernel (qpad={qp}) ...")
                kernels[qp] = tilelang.compile(build(qp))
                print(f"COMPILE_OK (qpad={qp})")
            except Exception:
                tb = traceback.format_exc().strip().splitlines()
                keep = [l for l in tb if "Error" in l or "Check failed" in l or "error:" in l]
                print(f"COMPILE_FAIL (qpad={qp}):")
                for line in (keep or tb)[-8:]:
                    print("   ", line)
                continue
        kernel = kernels[qp]
        try:
            o = torch.zeros(B, 1, BR, D, dtype=torch.float16, device=dev)
            kernel(q, bt, rl, bias, kp, vp, zp, o)
            torch.npu.synchronize()
            got = o[:, 0, :S_Q, 0].float()  # (B, S_Q, D)
            diagnose(name, got, exp[:, :, 0])
            mr = ((got - exp[:, :, 0]).abs() / (exp[:, :, 0].abs() + 1e-6)).max().item()
            print(f"{name}: max_rel={mr:.4f} -> {'PASS' if mr < 5e-2 else 'FAIL'}")
        except Exception:
            tb = traceback.format_exc().strip().splitlines()
            print(f"RUN_FAIL {name}:")
            for line in tb[-6:]:
                print("   ", line)

    # 主机 fp16 量化对照：评估 fp16 softmax 本征误差量级（不含 kernel 因素）
    print("\n--- host fp16-quantized reference (b0) ---")
    kv_len = 300
    k_l = torch.zeros(kv_len, D, dtype=torch.float16)
    v_l = torch.zeros(kv_len, D, dtype=torch.float16)
    for i_p, pid in enumerate([6, 2, 4]):
        k_l[i_p * BC:(i_p + 1) * BC] = kp[pid * BC:(pid + 1) * BC, 0].cpu()
        v_l[i_p * BC:(i_p + 1) * BC] = vp[pid * BC:(pid + 1) * BC, 0].cpu()
    sc = q[0, :, 0].cpu().float() @ k_l.float().T * scale  # (S_Q, kv_len) fp32 累计
    pr = sc.softmax(-1)
    o32 = pr @ v_l.float()
    print(f"fp32-acc ref vs exp b0: "
          f"max_rel={((o32 - exp[0, :, 0].cpu()).abs() / (exp[0, :, 0].cpu().abs() + 1e-6)).max().item():.4f}")
    # 模拟 P 量化 fp16：与 kernel 的 fp16 P 相同精度
    pr16 = pr.to(torch.float16).float()
    o16 = pr16 @ v_l.float()
    print(f"fp16-P ref vs exp b0:   "
          f"max_rel={((o16 - exp[0, :, 0].cpu()).abs() / (exp[0, :, 0].cpu().abs() + 1e-6)).max().item():.4f}")


if __name__ == "__main__":
    main()

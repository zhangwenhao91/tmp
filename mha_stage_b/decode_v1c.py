"""v1c 变长 decode kernel：v1b + B=2 批量 + real_seqlen 变长守卫。

形状：B=2, H=1, S_q=1(pad BR=16), D=128, W=2 逻辑页, fp16。
real_seqlen = [256, 100]：b0 两个整页；b1 只有一个页且页内仅前 100 行有效。

两个新机制：
  1. 整页跳过：`T.If(kv*BC < rl)` 包住 kv_body（探针 E2 已验证 T.If）。
     全无效页若参与 softmax 会使 alpha=exp(old_m-m) 溢出 Inf，必须跳过。
  2. 页内掩码：softmax 里对 scaled score 做 `S.vmin(s, -1e30)` 钳位——
     无效列 exp(-1e30 - m) 精确下溢为 0，row_sum/P 全部零贡献；
     softmax 恒等式 exp(s-m)/Σexp(s'-m) 对 m 不变，数学正确。
     钳位要求无效行 score 有限：池是完整分配的 randn，天然有限。

验收：B=2，b0 页序 [3,0] rl=256；b1 页序 [5,2] rl=100（BT[1] 存在但被跳过）。
每请求 row0 与 torch golden（按 bt 拼 k/v 截断 rl 行）rel < 5e-2。
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
BR = 16
ROWS = BR // 2
BC = 128
VL = 64
B = 2
W = 2              # 每请求最大逻辑页数（编译期）
POOL_PAGES = 8
POOL_ROWS = POOL_PAGES * BC
NUM_KV = W
dtype = "float16"
accum_dtype = "float32"
out_dtype = "float16"
scale = 1.0 / math.sqrt(D)
NEG_BIG = T.float32(-1.0e30)   # 无效列钳位值：exp 下溢为精确 0


@T.macro
def qk(kv, BT, bx, KP, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub):
    pid = BT[bx, kv]
    T.copy(KP[pid * BC:(pid + 1) * BC, 0:D], K_shared[0:BC, 0:D])
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
            # vmin 钳位：页内无效列（score 有限但属于越界行）→ -1e30 → exp 精确 0
            s00 = S.vmin(S.vmuls(S.vld(S_ub[r, 0], "NORM"), T.float32(scale), softmax_full),
                         NEG_BIG, softmax_full)
            s01 = S.vmin(S.vmuls(S.vld(S_ub[r, VL], "NORM"), T.float32(scale), softmax_full),
                         NEG_BIG, softmax_full)
            s10 = S.vmin(S.vmuls(S.vld(S_ub[r + 1, 0], "NORM"), T.float32(scale), softmax_full),
                         NEG_BIG, softmax_full)
            s11 = S.vmin(S.vmuls(S.vld(S_ub[r + 1, VL], "NORM"), T.float32(scale), softmax_full),
                         NEG_BIG, softmax_full)
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
def kv_body(kv, BT, bx, KP, VP, Q_shared, K_shared, V_shared, P_shared,
            qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0, qk_acc_l0c, pv_acc_l0c,
            S_ub, P_nz_ub, O_tmp_ub, O_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub):
    qk(kv, BT, bx, KP, Q_shared, K_shared, qk_a_l0, qk_b_l0, qk_acc_l0c, S_ub)
    softmax(S_ub, P_nz_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub)
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


def build(use_pipelined):
    @T.prim_func
    def main(
        Q: T.Buffer((B * BR, D), dtype),
        BT: T.Buffer((B, W), "int32"),
        RL: T.Buffer((B,), "int32"),
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
            O_tmp_ub = T.alloc_shared((ROWS, D), accum_dtype)
            O_ub = T.alloc_shared((ROWS, D), accum_dtype)
            # softmax/init 宏的 PAT_ALL 向量操作固定读写 64 lane（v1a 教训）：
            # ROWS<64 时必须分配 64 元素，循环只用前 ROWS 个标量。
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
            if use_pipelined:
                for kv in T.Pipelined(NUM_KV, num_stages=2,
                                      annotations={"enable_offset": True}):
                    with T.If(kv * BC < rl):
                        with T.Then():
                            kv_body(kv, BT, bx, KP, VP, Q_shared, K_shared, V_shared,
                                    P_shared, qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0,
                                    qk_acc_l0c, pv_acc_l0c, S_ub, P_nz_ub, O_tmp_ub,
                                    O_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub)
            else:
                for kv in T.serial(NUM_KV):
                    with T.If(kv * BC < rl):
                        with T.Then():
                            kv_body(kv, BT, bx, KP, VP, Q_shared, K_shared, V_shared,
                                    P_shared, qk_a_l0, qk_b_l0, pv_a_l0, pv_b_l0,
                                    qk_acc_l0c, pv_acc_l0c, S_ub, P_nz_ub, O_tmp_ub,
                                    O_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub)

            O_cast_ub = T.alloc_shared((ROWS, D), out_dtype)
            finalize_cast(O, bx, O_ub, O_cast_ub, l_ub)

    return main


def ref_paged_attention_row(q, bt, rl, kp, vp):
    """按 block_table 拼逻辑 KV、截断 rl 行后的单 query attention（fp32）。"""
    pages = []
    remaining = int(rl)
    for p in bt:
        take = min(BC, remaining)
        if take <= 0:
            break
        pages.append(kp[int(p) * BC:int(p) * BC + take])
        remaining -= take
    k = torch.cat(pages, dim=0)
    pages = []
    remaining = int(rl)
    for p in bt:
        take = min(BC, remaining)
        if take <= 0:
            break
        pages.append(vp[int(p) * BC:int(p) * BC + take])
        remaining -= take
    v = torch.cat(pages, dim=0)
    s = (q.float() @ k.float().T) * scale
    p = torch.softmax(s, dim=-1)
    return p @ v.float()


def main():
    print("=== v1c variable-length decode kernel: build & compile ===")
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
    q = torch.randn(B, D, dtype=torch.float16, device=dev)
    q_pad = torch.zeros(B * BR, D, dtype=torch.float16, device=dev)
    for b in range(B):
        q_pad[b * BR:b * BR + 1] = q[b]
    kp = torch.randn(POOL_ROWS, D, dtype=torch.float16, device=dev)
    vp = torch.randn(POOL_ROWS, D, dtype=torch.float16, device=dev)
    bt = torch.tensor([[3, 0], [5, 2]], dtype=torch.int32, device=dev)
    rl = torch.tensor([256, 100], dtype=torch.int32, device=dev)
    o = torch.zeros(B * BR, D, dtype=torch.float16, device=dev)

    kernel(q_pad, bt, rl, kp, vp, o)
    torch.npu.synchronize()

    assert torch.isfinite(o.float()).all(), "output contains non-finite values"
    all_ok = True
    for b in range(B):
        exp = ref_paged_attention_row(q[b], bt[b], rl[b], kp, vp)
        got = o[b * BR].float()
        diff = (got - exp).abs()
        rel = (diff / (exp.abs() + 1e-6)).max().item()
        max_abs = diff.max().item()
        ok = rel < 5e-2
        all_ok = all_ok and ok
        print(f"  b{b} (rl={int(rl[b])}): max_abs_diff={max_abs:.6f} max_rel={rel:.6f} "
              f"{'OK' if ok else 'FAIL'}")
    print("PASS: v1c" if all_ok else "FAIL: v1c accuracy")
    sys.exit(0 if all_ok else 2)


if __name__ == "__main__":
    main()

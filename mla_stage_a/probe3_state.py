"""MLA decode Stage A 探针 3：单块全头架构验证（v1a 骨架）。

架构决策探针：H_kv=1（MQA 形态），一个 block 吃下全部 H=128 个 Q 头——
K tile 驻留 L1，按 8 个 16 行头 tile 循环 gemm，online softmax 状态与 O 累加器
（[128,512] fp32 = 256KB UB）跨 key tile 持久。本探针回答：
  ① L1 能否驻留 K tile [128,512] fp16（128KB）+ PE（16KB）；
  ② UB 能否吃下 O 状态 256KB + m/l/alpha 状态；
  ③ 头 tile 循环 × key tile 循环的嵌套 gemm/softmax 是否数值正确。

实现要点（相对 MHA kernel 的改造）：
  - 无 bias、无分页：softmax 去掉 vadd(bias)，QK 按 D=4x128 分块累积 + PE 尾段
    （clear_accum=False），PV 直接复用 K_shared 按 D 分块（无 V 加载）。
  - m/l/old_m/alpha 从 64 lane 扩到 128 行：向量操作以 [base] 为段基址
    （lane base+i ↔ 行 base+i），ONEPT 写 [base+r]。
  - 输出 GM 为 fp16（沿 MHA finalize 的 cast + dual_copy 路径）。

判据：max_abs < 5e-3（P 以 fp16 进 PV 的量化量级），并输出单块耗时。
"""

import time

import torch
import torch_npu  # noqa: F401
import tilelang
import tilelang.ascend.language as T
from tilelang.ascend.language import simd as S
from tilelang.layout import make_ascend_compact_nz_layout

torch.manual_seed(2)

H, BR, BC, D, PE, S_KV = 128, 16, 128, 512, 64, 256
NT = H // BR          # 头 tile 数 = 8
ROWS = BR // 2        # 每 AIV 行数 = 8
VL = 64
dtype = "float16"
out_dtype = "float16"
accum_dtype = "float32"
scale = (D + PE) ** -0.5
pack_dtype = "float16"
pack_vec = "float16x128"

dev = "npu"
q = (torch.randn(1, H, D, device=dev) * 0.5).to(torch.float16)
q_pe = (torch.randn(1, H, PE, device=dev) * 0.5).to(torch.float16)
k = (torch.randn(S_KV, 1, D, device=dev) * 0.5).to(torch.float16)
k_pe = (torch.randn(S_KV, 1, PE, device=dev) * 0.5).to(torch.float16)


def ref_mla():
    s = (q[0].float() @ k[:, 0].float().T + q_pe[0].float() @ k_pe[:, 0].float().T) * scale
    m = s.amax(dim=-1, keepdim=True)
    e = (s - m).exp()
    l = e.sum(-1, keepdim=True)
    p16 = e.half()                      # kernel 里 P 以 fp16 进 PV
    o = p16.float() @ k[:, 0].float()
    return o / l


REF = ref_mla()


@T.macro
def qk_tile(Q_shared, QPE_shared, K_shared, KPE_shared,
            qk_a, qk_b, qk_a_pe, qk_b_pe, qk_acc, S_ub):
    for d0 in range(0, D, 128):
        T.copy(Q_shared[0:BR, d0:d0 + 128], qk_a)
        T.copy(K_shared[0:BC, d0:d0 + 128], qk_b)
        T.gemm(qk_a, qk_b, qk_acc, transpose_B=True, clear_accum=(d0 == 0))
    T.copy(QPE_shared[0:BR, 0:PE], qk_a_pe)
    T.copy(KPE_shared[0:BC, 0:PE], qk_b_pe)
    T.gemm(qk_a_pe, qk_b_pe, qk_acc, transpose_B=True, clear_accum=False)
    T.dual_copy(qk_acc, S_ub[0:ROWS, 0:BC])


@T.macro
def softmax_tile(S_ub, P_nz_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub, base):
    with T.SimdVF(latency=735):
        full = S.pset(32, "PAT_ALL")
        one = S.pset(32, "PAT_VL1")
        b16 = S.pset(16, "PAT_VL128")
        dst_nz_ptr = S.make_ubuf_ptr(
            T.access_ptr(P_nz_ub[0, 0], "w", ROWS + 1, BC),
            pack_dtype,
        )
        # 段基址的向量操作：lane base+i ↔ 行 base+i
        S.vsts(old_m_ub[base], S.vld(m_ub[base], "NORM"), full, "NORM_B32")

        for r in range(0, ROWS, 2):
            s00 = S.vmuls(S.vld(S_ub[r, 0], "NORM"), T.float32(scale), full)
            s01 = S.vmuls(S.vld(S_ub[r, VL], "NORM"), T.float32(scale), full)
            s10 = S.vmuls(S.vld(S_ub[r + 1, 0], "NORM"), T.float32(scale), full)
            s11 = S.vmuls(S.vld(S_ub[r + 1, VL], "NORM"), T.float32(scale), full)
            S.vsts(S_ub[r, 0], s00, full, "NORM_B32")
            S.vsts(S_ub[r, VL], s01, full, "NORM_B32")
            S.vsts(S_ub[r + 1, 0], s10, full, "NORM_B32")
            S.vsts(S_ub[r + 1, VL], s11, full, "NORM_B32")

            max0 = S.vcmax(S.vmax(s00, s01, full), full)
            max1 = S.vcmax(S.vmax(s10, s11, full), full)
            S.vsts(m_ub[base + r], max0, one, "ONEPT_B32")
            S.vsts(m_ub[base + r + 1], max1, one, "ONEPT_B32")

        S.mem_bar("VST_VLD")
        merged = S.vmax(S.vld(m_ub[base], "NORM"), S.vld(old_m_ub[base], "NORM"), full)
        S.vsts(m_ub[base], merged, full, "NORM_B32")
        S.mem_bar("VST_VLD")

        for r in range(0, ROWS, 2):
            max0 = S.vld(m_ub[base + r], "BRC_B32")
            max1 = S.vld(m_ub[base + r + 1], "BRC_B32")
            p00, p01 = S.vld2(S_ub[r, 0], "DINTLV_B32")
            p10, p11 = S.vld2(S_ub[r + 1, 0], "DINTLV_B32")
            e00 = S.vexpdif(p00, max0, full)
            e10 = S.vexpdif(p10, max1, full)
            e01 = S.vexpdif(p01, max0, full)
            e11 = S.vexpdif(p11, max1, full)
            row_sum0 = S.vcadd(S.vadd(e00, e01, full), full)
            row_sum1 = S.vcadd(S.vadd(e10, e11, full), full)
            S.vsts(row_sum_ub[base + r], row_sum0, one, "ONEPT_B32")
            S.vsts(row_sum_ub[base + r + 1], row_sum1, one, "ONEPT_B32")

            even_pk_0 = S.vcvt(e00, pack_dtype, full, sat=False, part=0)
            even_pk_1 = S.vcvt(e10, pack_dtype, full, sat=False, part=0)
            odd_pk_0 = S.vcvt(e01, pack_dtype, full, sat=False, part=1)
            odd_pk_1 = S.vcvt(e11, pack_dtype, full, sat=False, part=1)
            merged_bits0 = S.vor(
                T.reinterpret(even_pk_0, "uint16x128"),
                T.reinterpret(odd_pk_0, "uint16x128"),
                b16,
            )
            merged_bits1 = S.vor(
                T.reinterpret(even_pk_1, "uint16x128"),
                T.reinterpret(odd_pk_1, "uint16x128"),
                b16,
            )
            dst_nz_ptr = S.vsstb(
                T.reinterpret(merged_bits0, pack_vec), dst_nz_ptr,
                T.int32(((ROWS + 1) << 16) | 1), b16, update=True,
            )
            dst_nz_ptr = S.vsstb(
                T.reinterpret(merged_bits1, pack_vec), dst_nz_ptr,
                T.int32(((ROWS + 1) << 16) | 1), b16, update=True,
            )

        S.mem_bar("VST_VLD")
        alpha_reg = S.vexpdif(S.vld(old_m_ub[base], "NORM"), S.vld(m_ub[base], "NORM"), full)
        S.vsts(alpha_ub[base], alpha_reg, full, "NORM_B32")
        l_updated = S.vadd(
            S.vmul(S.vld(l_ub[base], "NORM"), alpha_reg, full),
            S.vld(row_sum_ub[base], "NORM"),
            full,
        )
        S.vsts(l_ub[base], l_updated, full, "NORM_B32")


@T.macro
def pack_p(P_nz_ub, P_shared):
    T.dual_copy(P_nz_ub[0:ROWS, 0:BC], P_shared[0:BR, 0:BC])


@T.macro
def pv_tile(P_shared, K_shared, pv_a, pv_b, pv_acc, O_tmp_ub):
    T.copy(P_shared[0:BR, 0:BC], pv_a)
    for d2 in range(0, D, 128):
        T.copy(K_shared[0:BC, d2:d2 + 128], pv_b)
        T.gemm(pv_a, pv_b, pv_acc, clear_accum=True)
        T.dual_copy(pv_acc, O_tmp_ub[0:ROWS, d2:d2 + 128])


@T.macro
def accumulate_tile(O_tmp_ub, O_ub, alpha_ub, base):
    with T.SimdVF(latency=318):
        mask = S.pset(32, "PAT_ALL")
        for i in range(ROWS):
            alpha = S.vld(alpha_ub[base + i], "BRC_B32")
            for c in range(0, D, VL):
                prev = S.vld(O_ub[base + i, c], "NORM")
                cur = S.vld(O_tmp_ub[i, c], "NORM")
                updated = S.vadd(S.vmul(alpha, prev, mask), cur, mask)
                S.vsts(O_ub[base + i, c], updated, mask, "NORM_B32")


@T.macro
def finalize_tile(O, ht, base, O_ub, O_cast_ub, l_ub):
    with T.SimdVF(latency=1780):
        mask = S.pset(32, "PAT_ALL")
        for i in range(ROWS):
            den = S.vld(l_ub[base + i], "BRC_B32")
            for c in range(0, D, VL):
                normalized = S.vdiv(S.vld(O_ub[base + i, c], "NORM"), den, mask)
                S.vsts(O_ub[base + i, c], normalized, mask, "NORM_B32")
    with T.SimdVF(latency=193):
        cast_mask = S.pset(32, "PAT_ALL")
        for r in range(ROWS):
            for c in range(0, D, VL):
                ob = S.vcvt(S.vld(O_ub[base + r, c], "NORM"), out_dtype, cast_mask)
                S.vsts(O_cast_ub[r, c], ob, cast_mask, "PK_B32")
    T.dual_copy(O_cast_ub[0:ROWS, 0:D], O[0, ht * BR:(ht + 1) * BR, 0:D])


@T.prim_func
def mla_decode_probe(
    Q: T.Buffer((1, H, D), dtype),
    QPE: T.Buffer((1, H, PE), dtype),
    K: T.Buffer((S_KV, 1, D), dtype),
    KPE: T.Buffer((S_KV, 1, PE), dtype),
    O: T.Buffer((1, H, D), out_dtype),
):
    with T.Kernel(1) as bx:
        b: T.int32 = 0
        skv: T.int32 = S_KV

        Q_shared = T.alloc_l1((BR, D), dtype)
        QPE_shared = T.alloc_l1((BR, PE), dtype)
        K_shared = T.alloc_l1((BC, D), dtype)
        KPE_shared = T.alloc_l1((BC, PE), dtype)
        P_shared = T.alloc_l1((BR, BC), dtype)

        qk_a = T.alloc_l0a((BR, 128), dtype)
        qk_b = T.alloc_l0b((BC, 128), dtype)
        qk_a_pe = T.alloc_l0a((BR, PE), dtype)
        qk_b_pe = T.alloc_l0b((BC, PE), dtype)
        pv_a = T.alloc_l0a((BR, BC), dtype)
        pv_b = T.alloc_l0b((BC, 128), dtype)
        qk_acc = T.alloc_l0c((BR, BC), accum_dtype)
        pv_acc = T.alloc_l0c((BR, 128), accum_dtype)

        S_ub = T.alloc_shared((ROWS, BC), accum_dtype)
        P_nz_ub = T.alloc_shared((ROWS + 1, BC), dtype)
        T.annotate_layout({P_nz_ub: make_ascend_compact_nz_layout(P_nz_ub)})
        O_tmp_ub = T.alloc_shared((ROWS, D), accum_dtype)
        O_cast_ub = T.alloc_shared((ROWS, D), out_dtype)
        O_ub = T.alloc_shared((H, D), accum_dtype)          # 256KB 容量问题在此
        m_ub = T.alloc_shared((H,), accum_dtype)
        l_ub = T.alloc_shared((H,), accum_dtype)
        old_m_ub = T.alloc_shared((H,), accum_dtype)
        alpha_ub = T.alloc_shared((H,), accum_dtype)
        row_sum_ub = T.alloc_shared((VL,), accum_dtype)

        # 初始化：m=-inf、l=0、O=0（128 行全部清）
        with T.SimdVF(latency=400):
            init_mask = S.pset(32, "PAT_ALL")
            zero = S.vdup(T.float32(0.0), accum_dtype, init_mask)
            initial_m = S.vdup(-T.infinity(accum_dtype), accum_dtype, init_mask)
            for b0 in range(0, H, VL):
                S.vsts(l_ub[b0], zero, init_mask, "NORM_B32")
                S.vsts(m_ub[b0], initial_m, init_mask, "NORM_B32")
        with T.SimdVF(latency=142):
            clear_mask = S.pset(32, "PAT_ALL")
            output_zero = S.vdup(T.float32(0.0), accum_dtype, clear_mask)
            for i in range(H):
                for c in range(0, D, VL):
                    S.vsts(O_ub[i, c], output_zero, clear_mask, "NORM_B32")

        for kv in T.serial(S_KV // BC):
            kb0 = kv * BC
            T.copy(K[kb0:kb0 + BC, 0, 0:D], K_shared[0:BC, 0:D])
            T.copy(KPE[kb0:kb0 + BC, 0, 0:PE], KPE_shared[0:BC, 0:PE])
            for ht in T.serial(NT):
                base: T.int32 = ht * BR
                T.copy(Q[0, ht * BR:(ht + 1) * BR, 0:D], Q_shared[0:BR, 0:D])
                T.copy(QPE[0, ht * BR:(ht + 1) * BR, 0:PE], QPE_shared[0:BR, 0:PE])
                qk_tile(Q_shared, QPE_shared, K_shared, KPE_shared,
                        qk_a, qk_b, qk_a_pe, qk_b_pe, qk_acc, S_ub)
                softmax_tile(S_ub, P_nz_ub, m_ub, l_ub, alpha_ub, old_m_ub,
                             row_sum_ub, base)
                pack_p(P_nz_ub, P_shared)
                pv_tile(P_shared, K_shared, pv_a, pv_b, pv_acc, O_tmp_ub)
                accumulate_tile(O_tmp_ub, O_ub, alpha_ub, base)

        for ht in T.serial(NT):
            finalize_tile(O, ht, ht * BR, O_ub, O_cast_ub, l_ub)


kern = tilelang.compile(mla_decode_probe)
o = torch.zeros(1, H, D, dtype=torch.float16, device=dev)
kern(q, q_pe, k, k_pe, o)
torch.npu.synchronize()

diff = (o[0].float() - REF).abs()
max_abs = float(diff.max())
max_rel = float((diff / REF.abs().clamp_min(1e-2)).max())
print(f"[probe3] max_abs={max_abs:.3e} max_rel={max_rel:.3e} "
      f"{'PASS' if max_abs < 5e-3 else 'FAIL'}")

# 粗测单块耗时（B=1 单 block，仅看量级）
for _ in range(3):
    kern(q, q_pe, k, k_pe, o)
torch.npu.synchronize()
t0 = time.perf_counter()
REPS = 20
for _ in range(REPS):
    kern(q, q_pe, k, k_pe, o)
torch.npu.synchronize()
per_call = (time.perf_counter() - t0) / REPS * 1e3
print(f"[probe3] B=1 H=128 S_kv={S_KV} 单块 per-call = {per_call:.3f} ms")

"""MLA decode Stage A 二轮探针 3：多头 tile 状态槽架构（v1a 骨架定型）。

一轮 probe3 的三个错误（均未编译通过所以未暴露）：
  ① 状态 base=ht*BR 段寻址违反 MHA 已证惯例（状态操作必须从 0 开始、[VL] 宽）；
  ② 64 lane 状态操作从 base>0 读会跨 tile 段污染（l 更新引入他 tile 陈旧 row_sum）；
  ③ row_sum_ub[112] 越界 [VL=64] 缓冲。

本版改用 **每 tile 独立状态槽**：Python 列表分配 NT 组 [VL] 状态缓冲 + NT 个
[ROWS, D] O 槽，宏调用按 ht 在 Python 层展开——每槽内部与 MHA 单块结构逐字节
同构（从 0 寻址、AIV 各管 8 行），K tile 每 kv 迭代只加载一次、NT 个头 tile 依次
复用（保住 AI≈248 的算术强度）。

用法：python3 probe3_slots.py <GQ>   # GQ=64（grid=B*(H/GQ)，K 重读 2 倍）
                                    # GQ=128（grid=B，K 只读一次，验 UB 上限）

判据：max_abs < 5e-3；另输出 per-call 耗时（B=1）。
"""

import sys
import time

import torch
import torch_npu  # noqa: F401
import tilelang
import tilelang.ascend.language as T
from tilelang.ascend.language import simd as S
from tilelang.layout import make_ascend_compact_nz_layout

torch.manual_seed(2)

H, BR, BC, D, PE, S_KV = 128, 16, 128, 512, 64, 256
GQ = int(sys.argv[1]) if len(sys.argv) > 1 else 64   # 本 block 吃下的 Q 头行数
NT = GQ // BR          # 头 tile 数（每 tile 16 行，与 MHA 单块同构）
ROWS = BR // 2         # 每 AIV 行数 = 8
VL = 64
NBLK = H // GQ         # grid 里的头块数
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
def softmax_tile(S_ub, P_nz_ub, m_ub, l_ub, alpha_ub, old_m_ub, row_sum_ub):
    """与 MHA 单块 softmax 逐条同构（去掉 bias vadd），全部从索引 0 寻址。"""
    with T.SimdVF(latency=735):
        full = S.pset(32, "PAT_ALL")
        one = S.pset(32, "PAT_VL1")
        b16 = S.pset(16, "PAT_VL128")
        dst_nz_ptr = S.make_ubuf_ptr(
            T.access_ptr(P_nz_ub[0, 0], "w", ROWS + 1, BC),
            pack_dtype,
        )
        S.vsts(old_m_ub[0], S.vld(m_ub[0], "NORM"), full, "NORM_B32")

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
            S.vsts(m_ub[r], max0, one, "ONEPT_B32")
            S.vsts(m_ub[r + 1], max1, one, "ONEPT_B32")

        S.mem_bar("VST_VLD")
        merged = S.vmax(S.vld(m_ub[0], "NORM"), S.vld(old_m_ub[0], "NORM"), full)
        S.vsts(m_ub[0], merged, full, "NORM_B32")
        S.mem_bar("VST_VLD")

        for r in range(0, ROWS, 2):
            max0 = S.vld(m_ub[r], "BRC_B32")
            max1 = S.vld(m_ub[r + 1], "BRC_B32")
            p00, p01 = S.vld2(S_ub[r, 0], "DINTLV_B32")
            p10, p11 = S.vld2(S_ub[r + 1, 0], "DINTLV_B32")
            e00 = S.vexpdif(p00, max0, full)
            e10 = S.vexpdif(p10, max1, full)
            e01 = S.vexpdif(p01, max0, full)
            e11 = S.vexpdif(p11, max1, full)
            row_sum0 = S.vcadd(S.vadd(e00, e01, full), full)
            row_sum1 = S.vcadd(S.vadd(e10, e11, full), full)
            S.vsts(row_sum_ub[r], row_sum0, one, "ONEPT_B32")
            S.vsts(row_sum_ub[r + 1], row_sum1, one, "ONEPT_B32")

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
        alpha_reg = S.vexpdif(S.vld(old_m_ub[0], "NORM"), S.vld(m_ub[0], "NORM"), full)
        S.vsts(alpha_ub[0], alpha_reg, full, "NORM_B32")
        l_updated = S.vadd(
            S.vmul(S.vld(l_ub[0], "NORM"), alpha_reg, full),
            S.vld(row_sum_ub[0], "NORM"),
            full,
        )
        S.vsts(l_ub[0], l_updated, full, "NORM_B32")


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
def accumulate_tile(O_tmp_ub, O_slot, alpha_ub):
    with T.SimdVF(latency=318):
        mask = S.pset(32, "PAT_ALL")
        for i in range(ROWS):
            alpha = S.vld(alpha_ub[i], "BRC_B32")
            for c in range(0, D, VL):
                prev = S.vld(O_slot[i, c], "NORM")
                cur = S.vld(O_tmp_ub[i, c], "NORM")
                updated = S.vadd(S.vmul(alpha, prev, mask), cur, mask)
                S.vsts(O_slot[i, c], updated, mask, "NORM_B32")


@T.macro
def init_m_l(m_ub, l_ub):
    with T.SimdVF(latency=400):
        init_mask = S.pset(32, "PAT_ALL")
        zero = S.vdup(T.float32(0.0), accum_dtype, init_mask)
        initial_m = S.vdup(-T.infinity(accum_dtype), accum_dtype, init_mask)
        S.vsts(l_ub[0], zero, init_mask, "NORM_B32")
        S.vsts(m_ub[0], initial_m, init_mask, "NORM_B32")


@T.macro
def finalize_tile(O, bx, ht, O_slot, O_cast_ub, l_ub):
    with T.SimdVF(latency=1780):
        mask = S.pset(32, "PAT_ALL")
        for i in range(ROWS):
            den = S.vld(l_ub[i], "BRC_B32")
            for c in range(0, D, VL):
                normalized = S.vdiv(S.vld(O_slot[i, c], "NORM"), den, mask)
                S.vsts(O_slot[i, c], normalized, mask, "NORM_B32")
    with T.SimdVF(latency=193):
        cast_mask = S.pset(32, "PAT_ALL")
        for r in range(ROWS):
            for c in range(0, D, VL):
                ob = S.vcvt(S.vld(O_slot[r, c], "NORM"), out_dtype, cast_mask)
                S.vsts(O_cast_ub[r, c], ob, cast_mask, "PK_B32")
    # v1d 教训：dual_copy dst 必须是干净 2D 切片（标量索引掉维），
    # 3D O 的 [0, a:b, 0:D] region 保留 3 维会报 Cannot infer split direction
    T.dual_copy(O_cast_ub[0:ROWS, 0:D],
                O[0, bx, ht * BR:(ht + 1) * BR, 0:D])


@T.prim_func
def mla_decode_slots(
    Q: T.Buffer((1, H, D), dtype),
    QPE: T.Buffer((1, H, PE), dtype),
    K: T.Buffer((S_KV, 1, D), dtype),
    KPE: T.Buffer((S_KV, 1, PE), dtype),
    O: T.Buffer((1, NBLK, GQ, D), out_dtype),
):
    with T.Kernel(NBLK) as bx:
        head0: T.int32 = bx * GQ
        skv: T.int32 = S_KV

        Q_shared = T.alloc_l1((BR, D), dtype)
        QPE_shared = T.alloc_l1((BR, PE), dtype)
        K_shared = T.alloc_l1((BC, D), dtype)
        KPE_shared = T.alloc_l1((BC, PE), dtype)
        P_shared = T.alloc_l1((BR, BC), dtype)

        qk_a = T.alloc_l0a((BR, 128), dtype)
        qk_a_pe = T.alloc_l0a((BR, PE), dtype)
        pv_a = T.alloc_l0a((BR, BC), dtype)
        # L0B 总容量 64KB：qk_b/pv_b 形状相同且生命周期不相交，共用一个 32KB；
        # qk_b_pe 16KB，合计 48KB ≤ 64KB（三者并存会报 Z3 shared.l0b capacity 0）
        kb_l0b = T.alloc_l0b((BC, 128), dtype)
        qk_b_pe = T.alloc_l0b((BC, PE), dtype)
        qk_acc = T.alloc_l0c((BR, BC), accum_dtype)
        pv_acc = T.alloc_l0c((BR, 128), accum_dtype)

        S_ub = T.alloc_shared((ROWS, BC), accum_dtype)
        P_nz_ub = T.alloc_shared((ROWS + 1, BC), dtype)
        T.annotate_layout({P_nz_ub: make_ascend_compact_nz_layout(P_nz_ub)})
        O_tmp_ub = T.alloc_shared((ROWS, D), accum_dtype)
        O_cast_ub = T.alloc_shared((ROWS, D), out_dtype)

        # 每 tile 独立状态槽：Python 列表分配，宏调用按 ht 展开（trace 期解包）
        m_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
        l_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
        old_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
        alpha_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
        rs_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
        o_slots = [T.alloc_shared((ROWS, D), accum_dtype) for _ in range(NT)]

        # 初始化：m=-inf、l=0、O=0（逐 tile 槽）
        for ht in list(range(NT)):
            init_m_l(m_bufs[ht], l_bufs[ht])
        with T.SimdVF(latency=142):
            clear_mask = S.pset(32, "PAT_ALL")
            output_zero = S.vdup(T.float32(0.0), accum_dtype, clear_mask)
            for ht in list(range(NT)):
                for i in range(ROWS):
                    for c in range(0, D, VL):
                        S.vsts(o_slots[ht][i, c], output_zero, clear_mask, "NORM_B32")

        for kv in T.serial(S_KV // BC):
            kb0 = kv * BC
            T.copy(K[kb0:kb0 + BC, 0, 0:D], K_shared[0:BC, 0:D])
            T.copy(KPE[kb0:kb0 + BC, 0, 0:PE], KPE_shared[0:BC, 0:PE])
            for ht in list(range(NT)):
                T.copy(Q[0, head0 + ht * BR:head0 + (ht + 1) * BR, 0:D], Q_shared[0:BR, 0:D])
                T.copy(QPE[0, head0 + ht * BR:head0 + (ht + 1) * BR, 0:PE], QPE_shared[0:BR, 0:PE])
                qk_tile(Q_shared, QPE_shared, K_shared, KPE_shared,
                        qk_a, kb_l0b, qk_a_pe, qk_b_pe, qk_acc, S_ub)
                softmax_tile(S_ub, P_nz_ub, m_bufs[ht], l_bufs[ht], alpha_bufs[ht],
                             old_bufs[ht], rs_bufs[ht])
                pack_p(P_nz_ub, P_shared)
                pv_tile(P_shared, K_shared, pv_a, kb_l0b, pv_acc, O_tmp_ub)
                accumulate_tile(O_tmp_ub, o_slots[ht], alpha_bufs[ht])

        for fb in list(range(NT)):
            finalize_tile(O, bx, fb, o_slots[fb], O_cast_ub, l_bufs[fb])


def main() -> int:
    print(f"[probe3] GQ={GQ} NT={NT} grid=NBLK={NBLK} "
          f"(K 重读 {NBLK} 倍, AI≈{248 // NBLK})")
    try:
        kern = tilelang.compile(mla_decode_slots)
    except Exception as e:  # noqa: BLE001
        print(f"[probe3:GQ={GQ}] COMPILE FAIL: {type(e).__name__}: {e}")
        return 1
    try:
        o = torch.zeros(1, NBLK, GQ, D, dtype=torch.float16, device=dev)
        kern(q, q_pe, k, k_pe, o)
        torch.npu.synchronize()
        diff = (o.view(1, H, D)[0].float() - REF).abs()
        max_abs = float(diff.max())
        ok = max_abs < 5e-3
        print(f"[probe3:GQ={GQ}] max_abs={max_abs:.3e} {'PASS' if ok else 'FAIL'}")

        for _ in range(3):
            kern(q, q_pe, k, k_pe, o)
        torch.npu.synchronize()
        t0 = time.perf_counter()
        REPS = 20
        for _ in range(REPS):
            kern(q, q_pe, k, k_pe, o)
        torch.npu.synchronize()
        per_call = (time.perf_counter() - t0) / REPS * 1e3
        print(f"[probe3:GQ={GQ}] B=1 H={GQ} S_kv={S_KV} per-call = {per_call:.3f} ms")
        return 0 if ok else 1
    except Exception as e:  # noqa: BLE001
        print(f"[probe3:GQ={GQ}] RUN FAIL: {type(e).__name__}: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())

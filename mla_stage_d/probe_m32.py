"""MLA decode Stage D 探针：head tile 合块（BR=16→32）MFU 对比。

基于 mla_stage_b/decode_v1a.py，唯一变量是 BR：
  - BR=16：基线对照（与 v1a 完全一致，NT=8）
  - BR=32：合块变体（NT=4，gemm 发射次数减半、M 翻倍）
形状固定 B=32, H=128, H_kv=1, N_kv=4096, D=512, PE=64（grid=32，刚过饱和线）。

用法（每变体独立进程，防 aicore trap 连坐）：
  python3 probe_m32.py 16
  python3 probe_m32.py 32

判读：m32 相对 m16 的中位耗时降幅 >10% 即值得合入 v2；max_abs < 5e-3。
"""

import sys
import time

import tilelang
import torch
import torch_npu  # noqa: F401

BR = int(sys.argv[1]) if len(sys.argv) > 1 else 16
assert BR in (16, 32), f"BR 仅支持 16/32，收到 {BR}"
TAG = f"m{BR // 16}"  # m16 / m32
BC = 128   # key tile 行数
VL = 64    # PAT_ALL 向量操作 lane 数
ROWS = BR // 2
D, PE = 512, 64
B, H, N_KV = 32, 128, 4096
PEAK_TFLOPS = 372.3
dev = "npu"


def compile_kernel(batch, heads, dim, pe, s_kv, dtype="float16"):
    import tilelang.ascend.language as T
    from tilelang.ascend.language import simd as S
    from tilelang.layout import make_ascend_compact_nz_layout

    B_ = batch
    H_ = heads
    D_ = dim
    PE_ = pe
    SKV = s_kv
    GQ = min(128, H_)    # 本 block 吃下的 Q 头行数
    NT = GQ // BR        # 头 tile 数（状态槽数）：BR=16→8，BR=32→4
    NBLK = H_ // GQ      # 每 batch 的头块数
    NUM_KV = SKV // BC
    accum_dtype = "float32"
    out_dtype = dtype
    pack_dtype = dtype
    pack_vec = dtype + "x128"
    scale = (dim + pe) ** -0.5

    assert H_ % GQ == 0 and GQ % BR == 0, f"H={H_} 须整除 GQ={GQ}"
    assert s_kv % BC == 0, f"N_kv={s_kv} 须是 {BC} 的倍数"

    @T.macro
    def qk_tile(Q_shared, QPE_shared, K_shared, KPE_shared,
                qk_a, qk_b, qk_a_pe, qk_b_pe, qk_acc, S_ub):
        # BC=128 拆两个 64 行半块复用同一 qk_b（16KB）：qk 用转置布局、pv 用正向布局，
        # 两者不能共用 L0B（layout_inference 报 Get different layout），只能各自独立缓冲
        T.copy(QPE_shared[0:BR, 0:PE_], qk_a_pe)
        for kh in range(2):
            for d0 in range(0, D_, 128):
                T.copy(Q_shared[0:BR, d0:d0 + 128], qk_a)
                T.copy(K_shared[kh * 64:(kh + 1) * 64, d0:d0 + 128], qk_b)
                T.gemm(qk_a, qk_b, qk_acc, transpose_B=True, clear_accum=(d0 == 0))
            T.copy(KPE_shared[kh * 64:(kh + 1) * 64, 0:PE_], qk_b_pe)
            T.gemm(qk_a_pe, qk_b_pe, qk_acc, transpose_B=True, clear_accum=False)
            T.dual_copy(qk_acc, S_ub[0:ROWS, kh * 64:(kh + 1) * 64])

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
        for d2 in range(0, D_, 128):
            T.copy(K_shared[0:BC, d2:d2 + 128], pv_b)
            T.gemm(pv_a, pv_b, pv_acc, clear_accum=True)
            T.dual_copy(pv_acc, O_tmp_ub[0:ROWS, d2:d2 + 128])

    @T.macro
    def accumulate_tile(O_tmp_ub, O_slot, alpha_ub):
        with T.SimdVF(latency=318):
            mask = S.pset(32, "PAT_ALL")
            for i in range(ROWS):
                alpha = S.vld(alpha_ub[i], "BRC_B32")
                for c in range(0, D_, VL):
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
    def finalize_tile(O, b_idx, hb, ht, O_slot, O_cast_ub, l_ub):
        with T.SimdVF(latency=1780):
            mask = S.pset(32, "PAT_ALL")
            for i in range(ROWS):
                den = S.vld(l_ub[i], "BRC_B32")
                for c in range(0, D_, VL):
                    normalized = S.vdiv(S.vld(O_slot[i, c], "NORM"), den, mask)
                    S.vsts(O_slot[i, c], normalized, mask, "NORM_B32")
        with T.SimdVF(latency=193):
            cast_mask = S.pset(32, "PAT_ALL")
            for r in range(ROWS):
                for c in range(0, D_, VL):
                    ob = S.vcvt(S.vld(O_slot[r, c], "NORM"), out_dtype, cast_mask)
                    S.vsts(O_cast_ub[r, c], ob, cast_mask, "PK_B32")
        # v1d 教训：dual_copy dst 必须是干净 2D 切片（标量索引掉维），
        # 4D O 的 [b_idx, hb, a:b, 0:D] 两个标量索引正好掉掉前两维
        T.dual_copy(O_cast_ub[0:ROWS, 0:D_],
                    O[b_idx, hb, ht * BR:(ht + 1) * BR, 0:D_])

    @T.prim_func
    def mla_probe_m32(
        Q: T.Buffer((B_, H_, D_), dtype),
        QPE: T.Buffer((B_, H_, PE_), dtype),
        K: T.Buffer((B_, SKV, 1, D_), dtype),
        KPE: T.Buffer((B_, SKV, 1, PE_), dtype),
        O: T.Buffer((B_, NBLK, GQ, D_), out_dtype),
    ):
        h_total: T.int32 = H_  # 仅注解引用的形状名必须钉成闭包自由变量
        with T.Kernel(B_ * NBLK) as bx:
            b_idx: T.int32 = bx // NBLK
            hb: T.int32 = bx % NBLK
            head0: T.int32 = hb * GQ
            skv: T.int32 = SKV

            Q_shared = T.alloc_l1((BR, D_), dtype)
            QPE_shared = T.alloc_l1((BR, PE_), dtype)
            K_shared = T.alloc_l1((BC, D_), dtype)
            KPE_shared = T.alloc_l1((BC, PE_), dtype)
            P_shared = T.alloc_l1((BR, BC), dtype)

            qk_a = T.alloc_l0a((BR, 128), dtype)
            qk_a_pe = T.alloc_l0a((BR, PE_), dtype)
            pv_a = T.alloc_l0a((BR, BC), dtype)
            # L0B 64KB 预算：qk 半块化 16+8KB（转置布局）与 pv_b 32KB（正向布局）
            # 分离——qk/pv 布局形态互斥，共用于同一缓冲会报 Get different layout
            qk_b = T.alloc_l0b((64, 128), dtype)
            qk_b_pe = T.alloc_l0b((64, PE_), dtype)
            pv_b = T.alloc_l0b((BC, 128), dtype)
            qk_acc = T.alloc_l0c((BR, 64), accum_dtype)
            pv_acc = T.alloc_l0c((BR, 128), accum_dtype)

            S_ub = T.alloc_shared((ROWS, BC), accum_dtype)
            P_nz_ub = T.alloc_shared((ROWS + 1, BC), dtype)
            T.annotate_layout({P_nz_ub: make_ascend_compact_nz_layout(P_nz_ub)})
            O_tmp_ub = T.alloc_shared((ROWS, D_), accum_dtype)
            O_cast_ub = T.alloc_shared((ROWS, D_), out_dtype)

            # 每 tile 独立状态槽：Python 列表分配，宏调用按 ht 展开（trace 期解包）
            m_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
            l_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
            old_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
            alpha_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
            rs_bufs = [T.alloc_shared((VL,), accum_dtype) for _ in range(NT)]
            o_slots = [T.alloc_shared((ROWS, D_), accum_dtype) for _ in range(NT)]

            # 初始化：m=-inf、l=0、O=0（逐 tile 槽）
            for ht in list(range(NT)):
                init_m_l(m_bufs[ht], l_bufs[ht])
            with T.SimdVF(latency=142):
                clear_mask = S.pset(32, "PAT_ALL")
                output_zero = S.vdup(T.float32(0.0), accum_dtype, clear_mask)
                for ht in list(range(NT)):
                    for i in range(ROWS):
                        for c in range(0, D_, VL):
                            S.vsts(o_slots[ht][i, c], output_zero, clear_mask, "NORM_B32")

            for kv in T.serial(NUM_KV):
                kb0 = kv * BC
                # K 每 kv 迭代只加载一次，NT 个头 tile 依次复用（保住 AI≈248）
                T.copy(K[b_idx, kb0:kb0 + BC, 0, 0:D_], K_shared[0:BC, 0:D_])
                T.copy(KPE[b_idx, kb0:kb0 + BC, 0, 0:PE_], KPE_shared[0:BC, 0:PE_])
                for ht in list(range(NT)):
                    T.copy(Q[b_idx, head0 + ht * BR:head0 + (ht + 1) * BR, 0:D_],
                           Q_shared[0:BR, 0:D_])
                    T.copy(QPE[b_idx, head0 + ht * BR:head0 + (ht + 1) * BR, 0:PE_],
                           QPE_shared[0:BR, 0:PE_])
                    qk_tile(Q_shared, QPE_shared, K_shared, KPE_shared,
                            qk_a, qk_b, qk_a_pe, qk_b_pe, qk_acc, S_ub)
                    softmax_tile(S_ub, P_nz_ub, m_bufs[ht], l_bufs[ht], alpha_bufs[ht],
                                 old_bufs[ht], rs_bufs[ht])
                    pack_p(P_nz_ub, P_shared)
                    pv_tile(P_shared, K_shared, pv_a, pv_b, pv_acc, O_tmp_ub)
                    accumulate_tile(O_tmp_ub, o_slots[ht], alpha_bufs[ht])

            for fb in list(range(NT)):
                finalize_tile(O, b_idx, hb, fb, o_slots[fb], O_cast_ub, l_bufs[fb])

    return mla_probe_m32


def ref_mla(q, q_pe, k, k_pe, scale):
    """fp32 softmax + fp16-P 进 PV 的参考（与 kernel P 量化语义对齐），逐 batch。"""
    outs = []
    for b in range(q.shape[0]):
        s = (q[b].float() @ k[b, :, 0].float().T
             + q_pe[b].float() @ k_pe[b, :, 0].float().T) * scale
        m = s.amax(-1, keepdim=True)
        e = (s - m).exp()
        l = e.sum(-1, keepdim=True)
        p16 = e.half()
        outs.append((p16.float() @ k[b, :, 0].float()) / l)
    return torch.stack(outs)


def main() -> int:
    GQ = min(128, H)
    print(f"[probe:{TAG}] BR={BR} ROWS={ROWS} NT={GQ // BR} "
          f"compile B={B} H={H} N_kv={N_KV} grid={B * (H // GQ)} ...", flush=True)
    try:
        kern = tilelang.compile(compile_kernel(B, H, D, PE, N_KV))
    except Exception as e:  # noqa: BLE001
        print(f"[probe:{TAG}] COMPILE FAIL: {type(e).__name__}: {e}")
        return 1

    torch.manual_seed(2026)
    q = (torch.randn(B, H, D, device=dev) * 0.5).to(torch.float16)
    q_pe = (torch.randn(B, H, PE, device=dev) * 0.5).to(torch.float16)
    k = (torch.randn(B, N_KV, 1, D, device=dev) * 0.5).to(torch.float16)
    k_pe = (torch.randn(B, N_KV, 1, PE, device=dev) * 0.5).to(torch.float16)
    o = torch.zeros(B, H // GQ, GQ, D, dtype=torch.float16, device=dev)

    try:
        kern(q, q_pe, k, k_pe, o)
        torch.npu.synchronize()
        ref = ref_mla(q, q_pe, k, k_pe, (D + PE) ** -0.5)
        max_abs = float((o.view(B, H, D).float() - ref).abs().max())
        ok = max_abs < 5e-3
        print(f"[probe:{TAG}] max_abs={max_abs:.3e} {'PASS' if ok else 'FAIL'}")
        if not ok:
            return 1

        for _ in range(3):
            kern(q, q_pe, k, k_pe, o)
        torch.npu.synchronize()
        times = []
        REPS = 10
        for _ in range(REPS):
            t0 = time.perf_counter()
            kern(q, q_pe, k, k_pe, o)
            torch.npu.synchronize()
            times.append(time.perf_counter() - t0)
        times.sort()
        med = times[REPS // 2] * 1e3
        flops = 2 * B * H * N_KV * (D + PE + D)
        mfu = flops / (med / 1e3) / (PEAK_TFLOPS * 1e12) * 100
        print(f"[probe:{TAG}] med = {med:.3f} ms  MFU = {mfu:.2f}%  "
              f"(times_ms={['%.3f' % (t * 1e3) for t in times]})")
        return 0
    except Exception as e:  # noqa: BLE001
        print(f"[probe:{TAG}] RUN FAIL: {type(e).__name__}: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())

"""MLA decode Stage A 探针 1：QK 打分 gemm 的 D=512 形态。

要回答的问题（按探针变体）：
  one_shot  K tile [128,512] fp16 整体驻留 L1（128KB）、L0B 一次吃 [128,512]（128KB）、
            L0A 一次吃 [16,512]（16KB），单条 gemm 完成 576 维打分（D 512 + PE 64 两段累积）。
            若编译/运行失败，说明 L1/L0A/L0B 任一容量不够。
  chunked   兜底形态：K tile 仍整体驻 L1，但 gemm 按 D=4x128 分块累积（L0A/L0B 每块
            [*,128]），PE 尾段 [*,64] 同一累加器 clear_accum=False 追加。
            重点验证：①T.gemm 的 clear_accum=False 二次累积是否支持；
            ②L1 是否容得下 [128,512] K tile。

判据：S [16,128] 与 torch fp32 参考比 max_rel < 5e-3。
在服务器上独立运行：python3 probe1_qk.py
"""

import torch
import torch_npu  # noqa: F401
import tilelang
import tilelang.ascend.language as T
from tilelang.ascend.language import simd as S

torch.manual_seed(0)

BR, BC, D, PE = 16, 128, 512, 64
ROWS = BR // 2
dtype = "float16"
accum_dtype = "float32"
scale = (D + PE) ** -0.5

dev = "npu"
q = (torch.randn(BR, D, device=dev) * 0.5).to(torch.float16)
q_pe = (torch.randn(BR, PE, device=dev) * 0.5).to(torch.float16)
k = (torch.randn(BC, D, device=dev) * 0.5).to(torch.float16)
k_pe = (torch.randn(BC, PE, device=dev) * 0.5).to(torch.float16)

ref = (q.float() @ k.float().T + q_pe.float() @ k_pe.float().T) * scale


def build_one_shot():
    @T.prim_func
    def qk_one_shot(
        Q: T.Buffer((BR, D), dtype),
        QPE: T.Buffer((BR, PE), dtype),
        K: T.Buffer((BC, D), dtype),
        KPE: T.Buffer((BC, PE), dtype),
        SGM: T.Buffer((BR, BC), accum_dtype),
    ):
        with T.Kernel(1) as bx:
            Q_shared = T.alloc_l1((BR, D), dtype)
            QPE_shared = T.alloc_l1((BR, PE), dtype)
            K_shared = T.alloc_l1((BC, D), dtype)
            KPE_shared = T.alloc_l1((BC, PE), dtype)
            qk_a = T.alloc_l0a((BR, D), dtype)
            qk_b = T.alloc_l0b((BC, D), dtype)
            qk_a_pe = T.alloc_l0a((BR, PE), dtype)
            qk_b_pe = T.alloc_l0b((BC, PE), dtype)
            acc = T.alloc_l0c((BR, BC), accum_dtype)
            S_ub = T.alloc_shared((ROWS, BC), accum_dtype)

            T.copy(Q[0:BR, 0:D], Q_shared)
            T.copy(QPE[0:BR, 0:PE], QPE_shared)
            T.copy(K[0:BC, 0:D], K_shared)
            T.copy(KPE[0:BC, 0:PE], KPE_shared)

            T.copy(Q_shared, qk_a)
            T.copy(K_shared, qk_b)
            T.gemm(qk_a, qk_b, acc, transpose_B=True, clear_accum=True)
            T.copy(QPE_shared, qk_a_pe)
            T.copy(KPE_shared, qk_b_pe)
            T.gemm(qk_a_pe, qk_b_pe, acc, transpose_B=True, clear_accum=False)
            T.dual_copy(acc, S_ub[0:ROWS, 0:BC])
            T.dual_copy(S_ub[0:ROWS, 0:BC], SGM[0:BR, 0:BC])

    return tilelang.compile(qk_one_shot)


def build_chunked():
    @T.macro
    def qk_chunks(Q_shared, QPE_shared, K_shared, KPE_shared, qk_a, qk_b, qk_a_pe, qk_b_pe, acc):
        for d0 in range(0, D, 128):
            T.copy(Q_shared[0:BR, d0:d0 + 128], qk_a)
            T.copy(K_shared[0:BC, d0:d0 + 128], qk_b)
            T.gemm(qk_a, qk_b, acc, transpose_B=True, clear_accum=(d0 == 0))
        T.copy(QPE_shared[0:BR, 0:PE], qk_a_pe)
        T.copy(KPE_shared[0:BC, 0:PE], qk_b_pe)
        T.gemm(qk_a_pe, qk_b_pe, acc, transpose_B=True, clear_accum=False)

    @T.prim_func
    def qk_chunked(
        Q: T.Buffer((BR, D), dtype),
        QPE: T.Buffer((BR, PE), dtype),
        K: T.Buffer((BC, D), dtype),
        KPE: T.Buffer((BC, PE), dtype),
        SGM: T.Buffer((BR, BC), accum_dtype),
    ):
        with T.Kernel(1) as bx:
            Q_shared = T.alloc_l1((BR, D), dtype)
            QPE_shared = T.alloc_l1((BR, PE), dtype)
            K_shared = T.alloc_l1((BC, D), dtype)
            KPE_shared = T.alloc_l1((BC, PE), dtype)
            qk_a = T.alloc_l0a((BR, 128), dtype)
            qk_b = T.alloc_l0b((BC, 128), dtype)
            qk_a_pe = T.alloc_l0a((BR, PE), dtype)
            qk_b_pe = T.alloc_l0b((BC, PE), dtype)
            acc = T.alloc_l0c((BR, BC), accum_dtype)
            S_ub = T.alloc_shared((ROWS, BC), accum_dtype)

            T.copy(Q[0:BR, 0:D], Q_shared)
            T.copy(QPE[0:BR, 0:PE], QPE_shared)
            T.copy(K[0:BC, 0:D], K_shared)
            T.copy(KPE[0:BC, 0:PE], KPE_shared)

            qk_chunks(Q_shared, QPE_shared, K_shared, KPE_shared,
                      qk_a, qk_b, qk_a_pe, qk_b_pe, acc)
            T.dual_copy(acc, S_ub[0:ROWS, 0:BC])
            T.dual_copy(S_ub[0:ROWS, 0:BC], SGM[0:BR, 0:BC])

    return tilelang.compile(qk_chunked)


for name, builder in [("one_shot", build_one_shot), ("chunked", build_chunked)]:
    try:
        kern = builder()
    except Exception as e:  # noqa: BLE001
        print(f"[probe1:{name}] COMPILE FAIL: {type(e).__name__}: {e}")
        continue
    try:
        sgm = torch.zeros(BR, BC, dtype=torch.float32, device=dev)
        kern(q, q_pe, k, k_pe, sgm)
        torch.npu.synchronize()
        diff = (sgm - ref).abs()
        max_rel = float((diff / ref.abs().clamp_min(1e-3)).max())
        print(f"[probe1:{name}] PASS max_abs={float(diff.max()):.3e} max_rel={max_rel:.3e}")
    except Exception as e:  # noqa: BLE001
        print(f"[probe1:{name}] RUN FAIL: {type(e).__name__}: {e}")

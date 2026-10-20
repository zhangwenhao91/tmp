"""MLA decode Stage A 二轮探针 1：chunked QK gemm（独立进程版）。

一轮结论：one_shot 两次 aicore trap（L0B 装不下 576 维 K），chunked 被同进程
连坐误判。本轮只跑 chunked，独立进程拿真实判决。
修正：ref 去掉 scale（kernel gemm 输出原始点积，一轮版 ref 带 scale 会虚高）。

判据：S [16,128] 与 torch fp32 参考比 max_rel < 5e-3。
"""

import sys

import torch
import torch_npu  # noqa: F401
import tilelang
import tilelang.ascend.language as T

torch.manual_seed(0)

BR, BC, D, PE = 16, 128, 512, 64
ROWS = BR // 2
dtype = "float16"
accum_dtype = "float32"

dev = "npu"
q = (torch.randn(BR, D, device=dev) * 0.5).to(torch.float16)
q_pe = (torch.randn(BR, PE, device=dev) * 0.5).to(torch.float16)
k = (torch.randn(BC, D, device=dev) * 0.5).to(torch.float16)
k_pe = (torch.randn(BC, PE, device=dev) * 0.5).to(torch.float16)

ref = q.float() @ k.float().T + q_pe.float() @ k_pe.float().T


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


def main() -> int:
    try:
        kern = tilelang.compile(qk_chunked)
    except Exception as e:  # noqa: BLE001
        print(f"[probe1c] COMPILE FAIL: {type(e).__name__}: {e}")
        return 1
    try:
        sgm = torch.zeros(BR, BC, dtype=torch.float32, device=dev)
        kern(q, q_pe, k, k_pe, sgm)
        torch.npu.synchronize()
        diff = (sgm - ref).abs()
        max_rel = float((diff / ref.abs().clamp_min(1e-3)).max())
        ok = max_rel < 5e-3
        print(f"[probe1c] {'PASS' if ok else 'FAIL'} max_abs={float(diff.max()):.3e} max_rel={max_rel:.3e}")
        return 0 if ok else 1
    except Exception as e:  # noqa: BLE001
        print(f"[probe1c] RUN FAIL: {type(e).__name__}: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())

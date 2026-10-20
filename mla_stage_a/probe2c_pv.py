"""MLA decode Stage A 二轮探针 2：chunked PV gemm（独立进程版）。

一轮结论：one_shot aicore trap（L0B 装不下 K[128,512]），chunked 被连坐误判。
本轮只跑 chunked，独立进程拿真实判决。验证点不变：
  ① 不带 transpose_B 的正向 gemm（P[16,BC]@K[BC,chunk]）；
  ② L0C 128 宽累加器分块 + dual_copy 到 UB 对应列段。

判据：O [16,512] 与 torch fp32 参考比 max_rel < 5e-3。
"""

import sys

import torch
import torch_npu  # noqa: F401
import tilelang
import tilelang.ascend.language as T

torch.manual_seed(1)

BR, BC, D = 16, 128, 512
ROWS = BR // 2
dtype = "float16"
accum_dtype = "float32"

dev = "npu"
p = (torch.randn(BR, BC, device=dev) * 0.5).to(torch.float16)
k = (torch.randn(BC, D, device=dev) * 0.5).to(torch.float16)
ref = p.float() @ k.float()


@T.macro
def pv_chunks(K_shared, P_shared, pv_a, pv_b, acc, O_ub):
    T.copy(P_shared[0:BR, 0:BC], pv_a)
    for d2 in range(0, D, 128):
        T.copy(K_shared[0:BC, d2:d2 + 128], pv_b)
        T.gemm(pv_a, pv_b, acc, clear_accum=True)
        T.dual_copy(acc, O_ub[0:ROWS, d2:d2 + 128])


@T.prim_func
def pv_chunked(
    P: T.Buffer((BR, BC), dtype),
    K: T.Buffer((BC, D), dtype),
    OGM: T.Buffer((BR, D), accum_dtype),
):
    with T.Kernel(1) as bx:
        P_shared = T.alloc_l1((BR, BC), dtype)
        K_shared = T.alloc_l1((BC, D), dtype)
        pv_a = T.alloc_l0a((BR, BC), dtype)
        pv_b = T.alloc_l0b((BC, 128), dtype)
        acc = T.alloc_l0c((BR, 128), accum_dtype)
        O_ub = T.alloc_shared((ROWS, D), accum_dtype)

        T.copy(P[0:BR, 0:BC], P_shared)
        T.copy(K[0:BC, 0:D], K_shared)

        pv_chunks(K_shared, P_shared, pv_a, pv_b, acc, O_ub)
        T.dual_copy(O_ub[0:ROWS, 0:D], OGM[0:BR, 0:D])


def main() -> int:
    try:
        kern = tilelang.compile(pv_chunked)
    except Exception as e:  # noqa: BLE001
        print(f"[probe2c] COMPILE FAIL: {type(e).__name__}: {e}")
        return 1
    try:
        ogm = torch.zeros(BR, D, dtype=torch.float32, device=dev)
        kern(p, k, ogm)
        torch.npu.synchronize()
        diff = (ogm - ref).abs()
        max_rel = float((diff / ref.abs().clamp_min(1e-3)).max())
        ok = max_rel < 5e-3
        print(f"[probe2c] {'PASS' if ok else 'FAIL'} max_abs={float(diff.max()):.3e} max_rel={max_rel:.3e}")
        return 0 if ok else 1
    except Exception as e:  # noqa: BLE001
        print(f"[probe2c] RUN FAIL: {type(e).__name__}: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())

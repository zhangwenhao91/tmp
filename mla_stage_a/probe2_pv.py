"""MLA decode Stage A 探针 2：PV gemm 的 [16,128]@[128,512] 形态。

MLA decode 的 V 就是 K 的 nope 部分（权重吸收语义），PV 直接吃 QK 已驻留 L1 的
K tile，无独立 V 加载。要回答的问题：
  one_shot  L0B 一次吃 [128,512]（128KB）、L0C 累加器 [16,512] fp32（32KB），
            单条 gemm 完成整行输出宽度。
  chunked   兜底：按 D=4x128 分块，每块 gemm 后 dual_copy 到 UB 对应列段再写 GM。
            重点验证：①不带 transpose_B 的正向 gemm（P[16,BC]@K[BC,chunk]）是否支持；
            ②L0C 32KB 累加器是否放得下。

判据：O [16,512] 与 torch fp32 参考比 max_rel < 5e-3。
"""

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


def build_one_shot():
    @T.prim_func
    def pv_one_shot(
        P: T.Buffer((BR, BC), dtype),
        K: T.Buffer((BC, D), dtype),
        OGM: T.Buffer((BR, D), accum_dtype),
    ):
        with T.Kernel(1) as bx:
            P_shared = T.alloc_l1((BR, BC), dtype)
            K_shared = T.alloc_l1((BC, D), dtype)
            pv_a = T.alloc_l0a((BR, BC), dtype)
            pv_b = T.alloc_l0b((BC, D), dtype)
            acc = T.alloc_l0c((BR, D), accum_dtype)
            O_ub = T.alloc_shared((ROWS, D), accum_dtype)

            T.copy(P[0:BR, 0:BC], P_shared)
            T.copy(K[0:BC, 0:D], K_shared)
            T.copy(P_shared, pv_a)
            T.copy(K_shared, pv_b)
            T.gemm(pv_a, pv_b, acc)
            T.dual_copy(acc, O_ub[0:ROWS, 0:D])
            T.dual_copy(O_ub[0:ROWS, 0:D], OGM[0:BR, 0:D])

    return tilelang.compile(pv_one_shot)


def build_chunked():
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

    return tilelang.compile(pv_chunked)


for name, builder in [("one_shot", build_one_shot), ("chunked", build_chunked)]:
    try:
        kern = builder()
    except Exception as e:  # noqa: BLE001
        print(f"[probe2:{name}] COMPILE FAIL: {type(e).__name__}: {e}")
        continue
    try:
        ogm = torch.zeros(BR, D, dtype=torch.float32, device=dev)
        kern(p, k, ogm)
        torch.npu.synchronize()
        diff = (ogm - ref).abs()
        max_rel = float((diff / ref.abs().clamp_min(1e-3)).max())
        print(f"[probe2:{name}] PASS max_abs={float(diff.max()):.3e} max_rel={max_rel:.3e}")
    except Exception as e:  # noqa: BLE001
        print(f"[probe2:{name}] RUN FAIL: {type(e).__name__}: {e}")

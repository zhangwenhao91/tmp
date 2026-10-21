"""MLADecodeWithKVCacheFwdOp 官方 manifest workload 全量覆盖。

manifest/spec/attention.yaml 里该 op 的 14 个 label、26 个 (label, dtype) 用例
原样实例化：输入由官方 MLADecodeWorkload.gen_inputs 生成，输出与官方
ref_program + verification（Exact atol=rtol=eps，含 first-input-zeroed 控制）
比对，另附中位耗时供参考。官方 benchmarks 框架计时走 CUDA events、conftest
硬拒 npu，故 NPU 侧以本脚本作为 workload 覆盖载体。

在 ~/TileOPs 目录下运行（依赖 repo 内 workloads 包与已装的 tileops）：
    PYTHONUNBUFFERED=1 python3 manifest_workloads_mla.py

注意：24 个形状各含一次 JIT 编译（约 15s/个），全程约 10-15 分钟。
"""

import statistics
import sys
import time

import torch
import torch_npu  # noqa: F401

sys.path.insert(0, "/home/z30086261/TileOPs")  # repo 内 workloads 包

from workloads.device import set_run_device  # noqa: E402

set_run_device(torch.device("npu", 0))

from workloads.attention.mla import MLADecodeWorkload  # noqa: E402
from workloads.numerics import compare_outputs  # noqa: E402
from tileops.ops import MLADecodeWithKVCacheFwdOp  # noqa: E402

# 与 manifest/spec/attention.yaml 的 MLA 节一一对应
# (label, B, H, H_kv, N_kv, D, PE, [dtype...])；ds-v3-4k/32k 为 bf16-only
CASES = [
    ("ds-v2-4k",              32, 128, 1,  4096, 512, 64, [torch.float16, torch.bfloat16]),
    ("ds-v2-32k",              8, 128, 1, 32768, 512, 64, [torch.float16, torch.bfloat16]),
    ("ds-v3-4k",              16, 128, 1,  4096, 512, 64, [torch.bfloat16]),
    ("ds-v3-32k",              4, 128, 1, 32768, 512, 64, [torch.bfloat16]),
    ("ds-v3-single-request",   1, 128, 1,  4096, 512, 64, [torch.float16, torch.bfloat16]),
    ("ds-v3-serving-batch",   12, 128, 1,  6144, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-b128-4096",        128, 128, 1,  4096, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-b128-8192",        128, 128, 1,  8192, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-b128-16384",       128, 128, 1, 16384, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-b128-32768",       128, 128, 1, 32768, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-tp-b1",              1,  64, 1,  4096, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-tp-b2",              2,  64, 1,  4096, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-tp-b6",              6,  64, 1,  4096, 512, 64, [torch.float16, torch.bfloat16]),
    ("mla-tp-b64",            64,  64, 1,  4096, 512, 64, [torch.float16, torch.bfloat16]),
]

WARMUP = 3
REPEAT = 10
DTYPE_NAME = {torch.float16: "fp16", torch.bfloat16: "bf16"}


def _diff_report(got, expected, tag):
    """失败时的定位信息：逐 batch max_abs/max_rel + 全局最差元素坐标。"""
    g, e = got.float(), expected.float()
    absd = (g - e).abs()
    rel = absd / e.abs().clamp_min(1e-6)
    for b in range(g.shape[0]):
        print(f"    [{tag}] batch{b}: max_abs={absd[b].max().item():.3e} "
              f"max_rel={rel[b].max().item():.3e}")
    idx = absd.flatten().argmax().item()
    strides = [int(torch.tensor(g.shape[i:]).prod().item()) for i in range(g.ndim)]
    coord = []
    r = idx
    for i in range(g.ndim):
        strides[i] = strides[i] // g.shape[i]
        coord.append(r // strides[i])
        r %= strides[i]
    print(f"    [{tag}] worst elem at {coord}: got={g.flatten()[idx].item():.6f} "
          f"expected={e.flatten()[idx].item():.6f} absd={absd.flatten()[idx].item():.3e}")


def run_case(label, B, H, H_kv, N_kv, D, PE, dtypes):
    for dtype in dtypes:
        wl = MLADecodeWorkload(B, H, H_kv, N_kv, D, PE, dtype)
        q, q_pe, k, k_pe = wl.gen_inputs()
        op = MLADecodeWithKVCacheFwdOp(target="ascend")

        torch.npu.synchronize()
        t0 = time.perf_counter()
        got = op(q, q_pe, k, k_pe)
        torch.npu.synchronize()
        first_ms = (time.perf_counter() - t0) * 1e3  # 含 JIT 编译

        for _ in range(WARMUP):
            op(q, q_pe, k, k_pe)
        torch.npu.synchronize()
        per_call = []
        for _ in range(REPEAT):
            torch.npu.synchronize()
            t0 = time.perf_counter()
            op(q, q_pe, k, k_pe)
            torch.npu.synchronize()
            per_call.append((time.perf_counter() - t0) * 1e3)
        med_ms = statistics.median(per_call)

        expected = wl.ref_program(q, q_pe, k, k_pe)
        # 正规消费口：结构检查 + Exact validator（atol=rtol=eps，含 zeroed-input 控制）
        try:
            compare_outputs(got, expected, wl.verification(q, q_pe, k, k_pe))
        except AssertionError:
            _diff_report(got, expected, f"{label}/{DTYPE_NAME[dtype]}")
            raise
        print(f"  {label:<22}{DTYPE_NAME[dtype]}  PASS  first={first_ms:7.1f}ms "
              f"med={med_ms:.3f}ms")
        del wl, q, q_pe, k, k_pe, op, got, expected  # 大池场景及时释放

    return label


def main():
    print("MLADecodeWithKVCacheFwdOp manifest workloads (official gen/ref/verification):")
    ok, total = 0, 0
    for spec in CASES:
        total += len(spec[-1])
        try:
            run_case(*spec)
            ok += len(spec[-1])
        except Exception:  # 单 case 失败不拖垮整表
            import traceback
            traceback.print_exc()
    print(f"manifest_workloads_mla: {ok}/{total} PASS")
    sys.exit(0 if ok == total else 1)


if __name__ == "__main__":
    main()

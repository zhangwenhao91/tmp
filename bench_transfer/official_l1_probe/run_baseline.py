#!/usr/bin/env python3
"""baseline（AIC/cube 正统 diamond）单测：切分「AIC 整体不可用」 vs 「L1↔UB 循环跳」。

6_baseline_*.o 结构（.ll 已核）：GM->L1(mov.out.to.l1) / L1->L1(ND2NZ 铺垫) /
gemm(L1->L0) / L0C->UB(fix.l0c.to.ub) / UB->GM(mov.ub.to.out)；无 L1->UB / UB->L1 循环跳。
判读（板上 run）：
  - baseline PASS + l1ub/l1ub_a/w/b/single 崩  => AIC/cube 没问题，崩在 L1↔UB 循环形态
  - baseline 也 0x7bc87                          => AIC/cube 内核整体在我们 rt.load 路径不可用
用法：python official_l1_probe/run_baseline.py
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
BENCH = os.path.dirname(HERE)

sys.path.insert(0, BENCH)
import bench_run  # 复用 _load_rt（核对 kernel_runner 路径）

N = 16


def gen_inputs(dtype, M):
    rng = np.random.default_rng(0)
    if dtype == "float32":
        return rng.standard_normal((M, N)).astype(np.float32), rng.standard_normal((N, N)).astype(np.float32)
    import torch
    return (torch.randn(M, N, dtype=torch.bfloat16).view(torch.uint16).numpy(),
            torch.randn(N, N, dtype=torch.bfloat16).view(torch.uint16).numpy())


def golden(dtype, x, w, M):
    if dtype == "float32":
        return np.matmul(x, w)
    import torch
    xf = torch.from_numpy(x).view(torch.uint16).view(torch.bfloat16).float()
    wf = torch.from_numpy(w).view(torch.uint16).view(torch.bfloat16).float()
    return (xf @ wf).numpy()


def main():
    rt = bench_run._load_rt()
    rt.init_runtime(None)
    rt.set_device(0)
    stream = rt.create_stream()
    ok_all = True
    for dtype, M in (("bfloat16", 16), ("bfloat16", 64), ("float32", 16), ("float32", 64)):
        for R in (16, 128):
            tag = f"baseline_{dtype}_{M}x256_r{R}"
            path = os.path.join(BENCH, f"6_{tag}.o")
            if not os.path.exists(path):
                print(f"[skip] missing {path}")
                continue
            x, w = gen_inputs(dtype, M)
            module = None
            xp = wp = op = None
            try:
                with open(path, "rb") as f:
                    obytes = f.read()
                module, func = rt.load_kernel("baseline_kernel_mix_aic", obytes, 0, "mix")
                xp = rt.malloc_device(x.nbytes)
                wp = rt.malloc_device(w.nbytes)
                op = rt.malloc_device(M * N * 4)
                rt.memcpy_h2d(xp, x.tobytes(order="C"))
                rt.memcpy_h2d(wp, w.tobytes(order="C"))
                rt.launch_kernel(
                    func=func, stream=stream, blocknum=1,
                    kernel_args=[("ptr", xp), ("ptr", wp), ("ptr", op), ("int32", 0)],
                )
                rt.synchronize_stream(stream)
                out = np.frombuffer(rt.memcpy_d2h(op, M * N * 4), dtype=np.float32).reshape(M, N)
                ok = np.allclose(out, golden(dtype, x, w, M), atol=1e-1, rtol=1e-1)
                ok_all &= ok
                print(f"[baseline] {dtype} {M}x256 R={R}: {'PASS' if ok else 'FAIL'}")
            except RuntimeError as e:
                print(f"[ERROR] {tag}: {e}")
                ok_all = False
                try:
                    rt.destroy_stream(stream)
                except Exception:
                    pass
                stream = rt.create_stream()
            finally:
                try:
                    rt.unregister_kernel(module)
                except Exception:
                    pass
                for p in (xp, wp, op):
                    if p is not None:
                        try:
                            rt.free_device(p)
                        except Exception:
                            pass
    rt.destroy_stream(stream)
    print("[RESULT]", "PASS: AIC/cube diamond 在此路径可跑" if ok_all else "存在 ERROR/FAIL，见上")


if __name__ == "__main__":
    main()
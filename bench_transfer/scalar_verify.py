"""标量中转路径上板验证：UB->scalar->UB 与 L1->scalar->L1。

用法（NPU 机上，bench_transfer 目录内）:
    python scalar_verify.py

验证：
  ub_scalar (bf16 16x256, REPEAT=2, AIV):
      OUT == X 恒等
  l1_scalar (bf16 16x256x16, REPEAT=2, MIX 双核 AIC+AIV):
      OUT1 ≈ X@W1, OUT2 ≈ X@W2（标量搬运无损）
编译层已全部验证通过（5_ub_scalar.ll addrspace(6) 标量指令 + vec arch；
5_l1_scalar.ll addrspace(2) 标量指令 + cube arch，含 gemm）。
"""

import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
M, K, N = 16, 256, 16


def _load_rt():
    candidates = []
    env_path = os.environ.get('KERNEL_RUNNER_PATH')
    if env_path:
        candidates.append(env_path)
    for home in (os.path.expanduser('~'), '/home/zwh', '/home/z30086261'):
        for sub in ('tilelang-ascend-private/OpenTileAS/tools/kernel_runner',
                    'OpenTileAS/tools/kernel_runner'):
            candidates.append(os.path.join(home, sub))
    seen = set()
    for p in candidates:
        p = os.path.abspath(p)
        if p in seen or not os.path.isdir(p):
            continue
        seen.add(p)
        sys.path.insert(0, p)
        try:
            from kernel_runner import _ascend_runtime as rt
            return rt
        except ModuleNotFoundError:
            sys.path.pop(0)
            continue
    try:
        from kernel_runner import _ascend_runtime as rt
        return rt
    except ModuleNotFoundError:
        pass
    print('ERROR: kernel_runner not found.', file=sys.stderr)
    sys.exit(1)


def main():
    rng = np.random.default_rng(42)
    import ml_dtypes

    x = (rng.standard_normal((M, K)) * 0.5).astype(np.float32)
    x = x.astype(ml_dtypes.bfloat16)
    w1 = (rng.standard_normal((K, N)) * 0.05).astype(np.float32)
    w2 = (rng.standard_normal((K, N)) * 0.05).astype(np.float32)
    w1b = w1.astype(ml_dtypes.bfloat16)
    w2b = w2.astype(ml_dtypes.bfloat16)

    rt = _load_rt()
    rt.init_runtime(None)
    rt.set_device(0)
    stream = rt.create_stream()
    try:
        # ---------------- ub_scalar: OUT == X ----------------
        path = os.path.join(HERE, "6_ub_scalar.o")
        with open(path, "rb") as f:
            obytes = f.read()
        module, func = rt.load_kernel("ub_scalar_kernel", obytes, 0, "aiv")
        xptr = rt.malloc_device(x.nbytes)
        optr = rt.malloc_device(x.nbytes)
        rt.memcpy_h2d(xptr, x.view(np.uint16).tobytes(order="C"))
        rt.launch_kernel(
            func=func, stream=stream, blocknum=1,
            kernel_args=[("ptr", xptr), ("ptr", optr), ("int32", 0)],
        )
        rt.synchronize_stream(stream)
        out = np.frombuffer(
            rt.memcpy_d2h(optr, x.nbytes), dtype=np.uint16
        ).view(ml_dtypes.bfloat16).reshape(M, K)
        ok = np.array_equal(out, x)
        print(f"[scalar] ub_scalar (UB->scalar->UB, AIV): "
              f"{'PASS' if ok else 'FAIL'} (恒等, 全 {out.size} 元素比对)")
        rt.free_device(xptr)
        rt.free_device(optr)
        rt.unregister_kernel(module)

        # ---------------- l1_scalar: OUT1≈X@W1, OUT2≈X@W2 ----------------
        path = os.path.join(HERE, "6_l1_scalar.o")
        with open(path, "rb") as f:
            obytes = f.read()
        # cube arch .o -> 普通 ELF magic（mode 非 "aiv"）
        # module, func = rt.load_kernel("l1_scalar_kernel", obytes, 0, "aic")
        # mix 双函数 .o：注册 _mix_aic 入口（mode="mix"），runtime 自动配对 _mix_aiv
        module, func = rt.load_kernel("l1_scalar_kernel_mix_aic", obytes, 0, "mix")
        xptr = rt.malloc_device(x.nbytes)
        w1ptr = rt.malloc_device(w1b.nbytes)
        w2ptr = rt.malloc_device(w2b.nbytes)
        o1ptr = rt.malloc_device(M * N * 4)
        o2ptr = rt.malloc_device(M * N * 4)
        rt.memcpy_h2d(xptr, x.view(np.uint16).tobytes(order="C"))
        rt.memcpy_h2d(w1ptr, w1b.view(np.uint16).tobytes(order="C"))
        rt.memcpy_h2d(w2ptr, w2b.view(np.uint16).tobytes(order="C"))
        rt.launch_kernel(
            func=func, stream=stream, blocknum=1,
            kernel_args=[
                ("ptr", xptr), ("ptr", w1ptr), ("ptr", w2ptr),
                ("ptr", o1ptr), ("ptr", o2ptr), ("int32", 0),
            ],
        )
        rt.synchronize_stream(stream)
        o1 = np.frombuffer(
            rt.memcpy_d2h(o1ptr, M * N * 4), dtype=np.float32
        ).reshape(M, N)
        o2 = np.frombuffer(
            rt.memcpy_d2h(o2ptr, M * N * 4), dtype=np.float32
        ).reshape(M, N)
        import torch

        g1 = (torch.from_numpy(x.astype(np.float32)).float()
              @ torch.from_numpy(w1).float()).numpy()
        g2 = (torch.from_numpy(x.astype(np.float32)).float()
              @ torch.from_numpy(w2).float()).numpy()
        e1 = float(np.abs(o1 - g1).max())
        e2 = float(np.abs(o2 - g2).max())
        print(f"[scalar] l1_scalar (L1->scalar->L1, AIC): "
              f"{'PASS' if e1 < 0.5 and e2 < 0.5 else 'FAIL'} "
              f"(max_err O1={e1:.4f} O2={e2:.4f})")
        for p in (xptr, w1ptr, w2ptr, o1ptr, o2ptr):
            rt.free_device(p)
        rt.unregister_kernel(module)
    finally:
        rt.destroy_stream(stream)
        rt.finalize_runtime(0, True)


if __name__ == "__main__":
    main()

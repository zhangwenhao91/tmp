"""bench_transfer 上板测试：UB->UB 与 L1->UB->L1 搬运性能（差分法）。

用法（NPU 机上，bench_transfer 目录内）:
    python bench_run.py prep     # 生成输入 npy（X/W1/W2 各规格）
    python bench_run.py run      # 计时 + 差分带宽报表
    python bench_run.py verify   # 数值正确性验证（r128 版 .o）
    python bench_run.py all

差分法：每个规格编译 REPEAT=16/128 两份 .o，
    t_round = (T(R128) - T(R16)) / (128 - 16)
消去 launch / GM 载入 / gemm / 输出回写等所有与 REPEAT 无关的常数。

variant 说明：
  ub2ub      : UB->UB，AIV，.o 在根目录 6_*.o
  ub_scalar  : UB->标量->UB，AIV，根目录 6_*.o
  l1ub       : L1->UB->L1 mix 双核，AIC 入口带 _mix_aic 后缀，根目录 6_*.o
  l1ub_single: L1->UB->L1 单核 AIC（绕开 mix 跨核同步 0x7bc87），
               .o 在 new_env/n6_l1ub_*_single.o（官方 OpenTileAS ed2beb55 +
               CANN 9.2.0-beta.2 编译，stage3 仅 --npu-plan-memory，
               见 build_l1ub_single.sh），入口名 l1ub_kernel（无后缀，
               AIC ELF 加载，mode="aic"）
l12l1（L1->L1 直连）不参与：编译器无 lowering 支持（stage4
mov.ub.to.l1 类型检查拒绝），仅保留证据 IR。
"""

import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))

K = 256
N = 16
R_LOW, R_HIGH = 16, 128
N_LAUNCH = 50
WARMUP = 5

NP_DTYPES = {"bfloat16": "uint16", "float32": "float32"}

# (variant, dtype, M) —— 与 build_all_bench.sh / build_l1ub_single.sh 的成功矩阵一致
SPECS = [
    ("ub2ub", "bfloat16", 16),
    ("ub_scalar", "bfloat16", 16),
    ("ub2ub", "bfloat16", 64),
    ("ub_scalar", "bfloat16", 64),
    ("ub2ub", "bfloat16", 128),
    ("ub_scalar", "bfloat16", 128),
    ("ub2ub", "float32", 16),
    ("ub_scalar", "float32", 16),
    ("ub2ub", "float32", 64),
    ("ub_scalar", "float32", 64),
    ("l1ub", "bfloat16", 16),
    ("l1ub", "bfloat16", 64),
    ("l1ub", "float32", 16),
    # l1ub 单核版：新环境产物 new_env/n6_l1ub_*_single.o（5 规格 x r16/r128）
    ("l1ub_single", "bfloat16", 16),
    ("l1ub_single", "bfloat16", 64),
    ("l1ub_single", "bfloat16", 128),
    ("l1ub_single", "float32", 16),
    ("l1ub_single", "float32", 64),
]

# 每 REPEAT 轮的被测搬运块数与 DMA 条数
TRANSFERS = {
    "ub2ub": {"blocks_per_round": 1, "dma_per_round": 1},
    "ub_scalar": {"blocks_per_round": 1, "dma_per_round": 1},
    "l1ub": {"blocks_per_round": 2, "dma_per_round": 4},  # 2x(L1->UB) + 2x(UB->L1)
    # 单核版与 mix 版相同链路：每轮 2x(L1->UB) + 2x(UB->L1)
    "l1ub_single": {"blocks_per_round": 2, "dma_per_round": 4},
}


def tag_of(variant, dtype, M, R):
    return f"{variant}_{dtype}_{M}x{K}_r{R}"


def o_path(variant, dtype, M, R):
    # return os.path.join(HERE, f"6_{tag_of(variant, dtype, M, R)}.o")
    # l1ub_single 产物在新环境目录：new_env/n6_l1ub_{dtype}_{M}x{K}_r{R}_single.o
    if variant == "l1ub_single":
        return os.path.join(
            HERE, "new_env", f"n6_{tag_of('l1ub', dtype, M, R)}_single.o")
    return os.path.join(HERE, f"6_{tag_of(variant, dtype, M, R)}.o")


def npy_path(name):
    return os.path.join(HERE, f"bench_{name}.npy")


def dtype_bytes(dtype):
    return 2 if dtype == "bfloat16" else 4


# ---------------------------------------------------------------------------
# prep: 输入生成
# ---------------------------------------------------------------------------
def do_prep():
    rng = np.random.default_rng(42)
    for variant, dtype, M in SPECS:
        nd = NP_DTYPES[dtype]
        x = (rng.standard_normal((M, K)) * 0.5).astype(np.float32)
        if dtype == "bfloat16":
            import ml_dtypes

            x = x.astype(ml_dtypes.bfloat16).view(np.uint16)
        np.save(npy_path(f"X_{variant}_{dtype}_{M}"), x)
        # if variant == "l1ub":
        if variant in ("l1ub", "l1ub_single"):
            for wname in ("W1", "W2"):
                w = (rng.standard_normal((K, N)) * 0.05).astype(np.float32)
                if dtype == "bfloat16":
                    import ml_dtypes

                    w = w.astype(ml_dtypes.bfloat16).view(np.uint16)
                np.save(npy_path(f"{wname}_{variant}_{dtype}_{M}"), w)
    print("[prep] inputs saved")


# ---------------------------------------------------------------------------
# run: 计时 + 差分
# ---------------------------------------------------------------------------
def _load_rt():
    # 1) 环境变量指定路径（优先）
    # 2) 常见路径探测
    # 3) 已 pip install 的全局 site-packages
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
    # fallback: pip install -e . 装到全局 site-packages 的包
    try:
        from kernel_runner import _ascend_runtime as rt
        return rt
    except ModuleNotFoundError:
        pass
    print('ERROR: kernel_runner not found or not compiled.', file=sys.stderr)
    print('On NPU machine, run:', file=sys.stderr)
    print('  cd ~/tilelang-ascend-private/OpenTileAS/tools/kernel_runner', file=sys.stderr)
    print('  pip install -e .', file=sys.stderr)
    print('Or set: export KERNEL_RUNNER_PATH=/path/to/kernel_runner', file=sys.stderr)
    sys.exit(1)

def _bench_once(rt, func, stream, args):
    for _ in range(WARMUP):
        rt.launch_kernel(func=func, stream=stream, blocknum=1, kernel_args=args)
    rt.synchronize_stream(stream)
    t0 = time.perf_counter()
    for _ in range(N_LAUNCH):
        rt.launch_kernel(func=func, stream=stream, blocknum=1, kernel_args=args)
    rt.synchronize_stream(stream)
    return (time.perf_counter() - t0) / N_LAUNCH


def do_run():
    rt = _load_rt()
    rt.init_runtime(None)
    rt.set_device(0)

    # 上传一次所有输入，计时复用
    uploads = {}
    for variant, dtype, M in SPECS:
        x = np.load(npy_path(f"X_{variant}_{dtype}_{M}"))
        ptr = rt.malloc_device(x.nbytes)
        rt.memcpy_h2d(ptr, x.tobytes(order="C"))
        entry = {"X": (ptr, x)}
        # if variant == "l1ub":
        if variant in ("l1ub", "l1ub_single"):
            for wname in ("W1", "W2"):
                w = np.load(npy_path(f"{wname}_{variant}_{dtype}_{M}"))
                wptr = rt.malloc_device(w.nbytes)
                rt.memcpy_h2d(wptr, w.tobytes(order="C"))
                entry[wname] = (wptr, w)
            for oname in ("O1", "O2"):
                optr = rt.malloc_device(M * N * 4)
                entry[oname] = optr
        else:
            optr = rt.malloc_device(x.nbytes)
            entry["O"] = optr
        uploads[(variant, dtype, M)] = entry

    results = []
    stream = rt.create_stream()
    try:
        for variant, dtype, M in SPECS:
            entry = uploads[(variant, dtype, M)]
            # mode = "aiv" if variant in ("ub2ub", "ub_scalar") else "mix"
            if variant in ("ub2ub", "ub_scalar"):
                mode = "aiv"  # AIV 向量核 ELF
            elif variant == "l1ub":
                mode = "mix"  # AIC ELF，runtime 自动配对 _mix_aiv 半核
            else:  # l1ub_single
                mode = "aic"  # 单核 AIC ELF（registerKernel 非 "aiv" 均走 AIC magic）
            # mix 双函数 .o 的入口符号带 _mix_aic 后缀（runtime 自动配对 _mix_aiv）
            # kname = f"{variant}_kernel" if variant in ("ub2ub", "ub_scalar") else f"{variant}_kernel_mix_aic"
            if variant == "l1ub":
                kname = "l1ub_kernel_mix_aic"
            elif variant == "l1ub_single":
                # l1ub_single 复用原 l1ub DSL，单核 .o 入口符号就是 l1ub_kernel（.ll: @l1ub_kernel）
                # kname = f"{variant}_kernel"  # 错误：拼成 l1ub_single_kernel，.o 中无此符号 -> rtFunctionRegister 0x7bc78
                kname = "l1ub_kernel"
            else:
                kname = f"{variant}_kernel"
            times = {}
            for R in (R_LOW, R_HIGH):
                path = o_path(variant, dtype, M, R)
                if not os.path.exists(path):
                    print(f"[skip] missing {path}")
                    times = None
                    break
                with open(path, "rb") as f:
                    obytes = f.read()
                module, func = rt.load_kernel(kname, obytes, 0, mode)
                # if variant == "l1ub":
                if variant in ("l1ub", "l1ub_single"):
                    args = [
                        ("ptr", entry["X"][0]),
                        ("ptr", entry["W1"][0]),
                        ("ptr", entry["W2"][0]),
                        ("ptr", entry["O1"]),
                        ("ptr", entry["O2"]),
                        ("int32", 0),
                    ]
                else:
                    args = [("ptr", entry["X"][0]), ("ptr", entry["O"]), ("int32", 0)]
                times[R] = _bench_once(rt, func, stream, args)
                rt.unregister_kernel(module)
            if not times:
                continue
            t_round = (times[R_HIGH] - times[R_LOW]) / (R_HIGH - R_LOW)
            meta = TRANSFERS[variant]
            block_bytes = M * K * dtype_bytes(dtype)
            move_bytes = meta["blocks_per_round"] * block_bytes
            traffic_bytes = move_bytes * 2  # 读+写
            bw_move = move_bytes / t_round / 1e9
            bw_traffic = traffic_bytes / t_round / 1e9
            dma_us = t_round / meta["dma_per_round"] * 1e6
            results.append(
                (variant, dtype, M, block_bytes,
                 times[R_LOW] * 1e6, times[R_HIGH] * 1e6,
                 t_round * 1e6, dma_us, bw_move, bw_traffic)
            )
            print(
                f"[{variant} {dtype} {M}x{K}] "
                f"T(r{R_LOW})={times[R_LOW]*1e6:.1f}us T(r{R_HIGH})={times[R_HIGH]*1e6:.1f}us "
                f"round={t_round*1e6:.2f}us dma={dma_us:.2f}us "
                f"bw(move)={bw_move:.2f}GB/s bw(traffic)={bw_traffic:.2f}GB/s"
            )

        print("\n===== 差分法汇总（t_round 消除 launch/GM/gemm 常数）=====")
        print(f"{'variant':12} {'dtype':10} {'shape':>10} {'KB':>6} "
              f"{'t_r16us':>8} {'t_r128us':>9} {'round_us':>9} {'dma_us':>7} "
              f"{'GB/s(mv)':>9} {'GB/s(tr)':>9}")
        for r in results:
            print(f"{r[0]:12} {r[1]:10} {str(r[2])+'x'+str(K):>10} {r[3]/1024:>6.0f} "
                  f"{r[4]:>8.1f} {r[5]:>9.1f} {r[6]:>9.2f} {r[7]:>7.2f} "
                  f"{r[8]:>9.2f} {r[9]:>9.2f}")
    finally:
        rt.destroy_stream(stream)
        for entry in uploads.values():
            for key, val in entry.items():
                if key == "X":
                    rt.free_device(val[0])
                elif key in ("W1", "W2"):
                    rt.free_device(val[0])
                else:
                    rt.free_device(val)
        rt.finalize_runtime(0, True)


# ---------------------------------------------------------------------------
# verify: 数值验证（r128 .o）
# ---------------------------------------------------------------------------
def do_verify():
    rt = _load_rt()
    rt.init_runtime(None)
    rt.set_device(0)
    stream = rt.create_stream()
    try:
        for variant, dtype, M in SPECS:
            path = o_path(variant, dtype, M, R_HIGH)
            if not os.path.exists(path):
                continue
            x = np.load(npy_path(f"X_{variant}_{dtype}_{M}"))
            # mode = "aiv" if variant in ("ub2ub", "ub_scalar") else "mix"
            if variant in ("ub2ub", "ub_scalar"):
                mode = "aiv"
            elif variant == "l1ub":
                mode = "mix"
            else:  # l1ub_single
                mode = "aic"
            # kname = "ub2ub_kernel" if variant == "ub2ub" else ("ub_scalar_kernel" if variant == "ub_scalar" else "l1ub_kernel_mix_aic")
            if variant == "l1ub":
                kname = "l1ub_kernel_mix_aic"
            elif variant == "l1ub_single":
                # kname = f"{variant}_kernel"  # 错误：拼成 l1ub_single_kernel，.o 中无此符号 -> 0x7bc78
                kname = "l1ub_kernel"  # 单核 .o 入口符号（.ll: @l1ub_kernel）
            else:
                kname = f"{variant}_kernel"
            with open(path, "rb") as f:
                obytes = f.read()
            module, func = rt.load_kernel(kname, obytes, 0, mode)
            if variant in ("ub2ub", "ub_scalar"):
                xptr = rt.malloc_device(x.nbytes)
                rt.memcpy_h2d(xptr, x.tobytes(order="C"))
                optr = rt.malloc_device(x.nbytes)
                rt.launch_kernel(
                    func=func, stream=stream, blocknum=1,
                    kernel_args=[("ptr", xptr), ("ptr", optr), ("int32", 0)],
                )
                rt.synchronize_stream(stream)
                out = np.frombuffer(
                    rt.memcpy_d2h(optr, x.nbytes), dtype=x.dtype
                ).reshape(x.shape)
                ok = np.array_equal(out, x)
                print(f"[verify] {variant} {dtype} {M}x{K}: {'PASS' if ok else 'FAIL'} (恒等)")
                rt.free_device(xptr)
                rt.free_device(optr)
            else:
                w1 = np.load(npy_path(f"W1_{variant}_{dtype}_{M}"))
                w2 = np.load(npy_path(f"W2_{variant}_{dtype}_{M}"))
                xptr = rt.malloc_device(x.nbytes)
                w1ptr = rt.malloc_device(w1.nbytes)
                w2ptr = rt.malloc_device(w2.nbytes)
                o1ptr = rt.malloc_device(M * N * 4)
                o2ptr = rt.malloc_device(M * N * 4)
                rt.memcpy_h2d(xptr, x.tobytes(order="C"))
                rt.memcpy_h2d(w1ptr, w1.tobytes(order="C"))
                rt.memcpy_h2d(w2ptr, w2.tobytes(order="C"))
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
                # golden: 搬运无损则 OUT1 = X@W1, OUT2 = X@W2
                import torch

                xt = torch.from_numpy(x.copy())
                if dtype == "bfloat16":
                    xt = xt.view(torch.bfloat16)
                w1t = torch.from_numpy(w1.copy())
                w2t = torch.from_numpy(w2.copy())
                if dtype == "bfloat16":
                    w1t = w1t.view(torch.bfloat16)
                    w2t = w2t.view(torch.bfloat16)
                g1 = (xt.float() @ w1t.float()).numpy()
                g2 = (xt.float() @ w2t.float()).numpy()
                e1 = float(np.abs(o1 - g1).max())
                e2 = float(np.abs(o2 - g2).max())
                print(
                    # f"[verify] l1ub {dtype} {M}x{K}: "
                    f"[verify] {variant} {dtype} {M}x{K}: "
                    f"{'PASS' if e1 < 0.5 and e2 < 0.5 else 'FAIL'} "
                    f"(max_err O1={e1:.4f} O2={e2:.4f})"
                )
                for p in (xptr, w1ptr, w2ptr, o1ptr, o2ptr):
                    rt.free_device(p)
            rt.unregister_kernel(module)
    finally:
        rt.destroy_stream(stream)
        rt.finalize_runtime(0, True)


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "all"
    if cmd == "prep":
        do_prep()
    elif cmd == "run":
        do_run()
    elif cmd == "verify":
        do_verify()
    elif cmd == "all":
        do_prep()
        do_run()
        do_verify()
    else:
        print(__doc__)


if __name__ == "__main__":
    main()


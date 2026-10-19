"""探针迭代 v3：拆分"GM 输出路径"×"动态寻址输入"两个正交维度。

v2 结论：
  - plain T.copy(L1→GM) 展开成 store 循环 → 撞 MarkScalarDcacheBypass ICHECK
    （例子能过是因为它所有 GM 写都走 UB + dual_copy）
  - 3D 池跨步读 + BT 标量（C1）已通过 MTE 规划（错误发生在后面的 dcache pass）
  - 2D 扁平池整页读 + BT 标量（E1/E2/G1）挂在 IndexError: Index 2 out of bounds 2

v3 变体（全部 T.Kernel(1)，输出统一尝试 UB→GM plain copy 路径）：
  H1  GM→UB→GM，静态连续 —— 隔离"UB→GM plain copy 是否走 MTE 调用不触 ICHECK"
  J1  H1 但输出改 T.serial 逐元素 store（对照组，预期必触 ICHECK）
  H3  BT 标量 + 3D 池跨步页读 → UB；输出 H1 式 —— C1+UB 组合（候选正解）
  K1  BT 标量 + 2D 扁平整页读 → UB；输出 H1 式 —— E1 换 UB 重试
  K2  BT 标量 + 2D 扁平逐行读 → UB；输出 H1 式 —— G1 换 UB 重试
  L1  H3 + T.If 运行时守卫（rl）—— dynloop 本质 + 候选正解
"""

import traceback

import torch
import tilelang
import tilelang.ascend.language as T

D = 128
H = 4
PAGE = 64
NKV = 8 * PAGE
NKV2 = NKV * H
dtype = "float16"


def make_H1():
    @T.prim_func
    def v(KP: T.Buffer((NKV, D), dtype), O: T.Buffer((PAGE, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_shared((PAGE, D), dtype)
            T.copy(KP[0:PAGE, 0:D], S[0:PAGE, 0:D])
            T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return v


def make_J1():
    @T.prim_func
    def v(KP: T.Buffer((NKV, D), dtype), O: T.Buffer((PAGE, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_shared((PAGE, D), dtype)
            T.copy(KP[0:PAGE, 0:D], S[0:PAGE, 0:D])
            for i, j in T.Parallel(PAGE, D):
                O[i, j] = S[i, j]

    return v


def make_H3():
    @T.prim_func
    def v(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV, H, D), dtype),
          O: T.Buffer((PAGE, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_shared((PAGE, D), dtype)
            pid = BT[0]
            T.copy(KP[pid * PAGE:(pid + 1) * PAGE, 0, 0:D], S[0:PAGE, 0:D])
            T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return v


def make_K1():
    @T.prim_func
    def v(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV2, D), dtype),
          O: T.Buffer((PAGE, H, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_shared((PAGE * H, D), dtype)
            pid = BT[0]
            T.copy(KP[pid * PAGE * H:(pid + 1) * PAGE * H, 0:D], S[0:PAGE * H, 0:D])
            T.copy(S[0:PAGE * H, 0:D], O[0:PAGE, 0:H, 0:D])

    return v


def make_K2():
    @T.prim_func
    def v(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV2, D), dtype),
          O: T.Buffer((PAGE, H, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_shared((PAGE * H, D), dtype)
            pid = BT[0]
            for r in T.serial(PAGE * H):
                T.copy(KP[pid * PAGE * H + r, 0:D], S[r, 0:D])
            T.copy(S[0:PAGE * H, 0:D], O[0:PAGE, 0:H, 0:D])

    return v


def make_L1():
    @T.prim_func
    def v(BT: T.Buffer((2,), "int32"), RL: T.Buffer((1,), "int32"),
          KP: T.Buffer((NKV, H, D), dtype), O: T.Buffer((2, PAGE, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_shared((PAGE, D), dtype)
            rl = RL[0]
            for t in T.serial(2):
                with T.If(t * PAGE < rl):
                    with T.Then():
                        pid = BT[t]
                        T.copy(KP[pid * PAGE:(pid + 1) * PAGE, 0, 0:D], S[0:PAGE, 0:D])
                        T.copy(S[0:PAGE, 0:D], O[t, 0:PAGE, 0:D])

    return v


VARIANTS = {
    "H1_ub2gm_static": make_H1,
    "J1_elemstore_ctrl": make_J1,
    "H3_strided_dynbt_ub": make_H3,
    "K1_flat_dynbt_ub": make_K1,
    "K2_flat_rowloop_ub": make_K2,
    "L1_strided_dynbt_if_ub": make_L1,
}

# 运行期参数构造：返回 (args_tuple, check_fn)
def build_case(name, dev, bt, rl, kp2, kp3, kp_flat):
    if name == "H1_ub2gm_static":
        o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
        return (kp2, o), lambda: torch.equal(o, kp2[:PAGE])
    if name == "J1_elemstore_ctrl":
        o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
        return (kp2, o), lambda: torch.equal(o, kp2[:PAGE])
    if name == "H3_strided_dynbt_ub":
        o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
        return (bt[:1], kp3, o), lambda: torch.equal(o, kp3[int(bt[0]) * PAGE:(int(bt[0]) + 1) * PAGE, 0, :])
    if name == "K1_flat_dynbt_ub":
        o = torch.zeros(PAGE, H, D, dtype=torch.float16, device=dev)
        p = int(bt[0])
        return (bt[:1], kp_flat, o), lambda: torch.equal(o, kp_flat[p * PAGE * H:(p + 1) * PAGE * H].view(PAGE, H, D))
    if name == "K2_flat_rowloop_ub":
        o = torch.zeros(PAGE, H, D, dtype=torch.float16, device=dev)
        p = int(bt[0])
        return (bt[:1], kp_flat, o), lambda: torch.equal(o, kp_flat[p * PAGE * H:(p + 1) * PAGE * H].view(PAGE, H, D))
    if name == "L1_strided_dynbt_if_ub":
        o = torch.zeros(2, PAGE, D, dtype=torch.float16, device=dev)

        def chk():
            covered = [t for t in range(2) if t * PAGE < int(rl[0])]
            good = all(torch.equal(o[t], kp3[int(bt[t]) * PAGE:(int(bt[t]) + 1) * PAGE, 0, :]) for t in covered)
            good = good and all(int(o[t].abs().sum()) == 0 for t in range(2) if t not in covered)
            return good, f"covered={covered}"
        return (bt, rl, kp3, o), chk
    return None, None


def main():
    dev = torch.device("npu")
    torch.manual_seed(0)
    bt = torch.tensor([5, 2], dtype=torch.int32, device=dev)
    rl = torch.tensor([100], dtype=torch.int32, device=dev)
    kp2 = torch.randn(NKV, D, dtype=torch.float16, device=dev)
    kp3 = torch.randn(NKV, H, D, dtype=torch.float16, device=dev)
    kp_flat = kp3.view(NKV2, D)

    kernels = {}
    for name, maker in VARIANTS.items():
        print(f"\n--- variant {name}: compiling ---")
        try:
            kernels[name] = tilelang.compile(maker())
            print(f"COMPILE_OK {name}")
        except Exception:
            tb = traceback.format_exc().strip().splitlines()
            print(f"COMPILE_FAIL {name}:")
            keep = [l for l in tb if "Error" in l or "Check failed" in l or "error:" in l]
            for line in (keep or tb)[-4:]:
                print("   ", line)

    print("\n=== run compiled variants ===")
    for name, kernel in kernels.items():
        try:
            args, chk = build_case(name, dev, bt, rl, kp2, kp3, kp_flat)
            kernel(*args)
            torch.npu.synchronize()
            res = chk()
            good, extra = (res, "") if isinstance(res, bool) else res
            print(f"{name}: {'PASS' if good else 'DATA_MISMATCH'} {extra}")
        except Exception:
            tb = traceback.format_exc().strip().splitlines()
            print(f"RUN_FAIL {name}:")
            for line in tb[-4:]:
                print("   ", line)

    print("\n=== done ===")


if __name__ == "__main__":
    main()

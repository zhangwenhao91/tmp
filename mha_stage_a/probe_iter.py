"""探针迭代 v2：修正 v1 的三个问题后重新二分。

v1 教训：
  R1 所有 kernel 必须包 `with T.Kernel(N) as bx`（AssignCore 需要 tilelang_root）
  R2 GM→L1 MTE 一次只能表达二维 [rows, inner]：三维整页（含动态基址）
     无法折叠 → "Outer-loop lowering is not yet implemented"
  R3 dual_copy 是 split-D 专用（尾维必须减半），普通 GM 写用 T.copy

v2 变体矩阵（全部包 T.Kernel(1)）：
  A1 连续 2D 基线（kernel 上下文 sanity）
  B1 跨步读（静态基地址，KP3[i, 0, :]，stride=H*D）
  C1 跨步读 + BT 标量寻址
  D1 三维整页 copy + BT 标量（预期仍 MTE 失败，确认 R2）
  E1 池 flatten 2D [NKV*H, D]，整页 2D copy + BT 标量（预期正解）
  E2 E1 + T.If 运行时守卫（dynloop 本质）
  G1 E1 失败时的兜底：逐行 copy 循环
"""

import traceback

import torch
import tilelang
import tilelang.ascend.language as T

D = 128
H = 4
PAGE = 64
NKV = 8 * PAGE       # 3D 池行数；2D 扁平行数 = NKV*H
NKV2 = NKV * H
dtype = "float16"


def make_A1():
    @T.prim_func
    def var_A1(KP: T.Buffer((NKV, D), dtype), O: T.Buffer((PAGE, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_l1((PAGE, D), dtype)
            T.copy(KP[0:PAGE, 0:D], S[0:PAGE, 0:D])
            T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return var_A1


def make_B1():
    @T.prim_func
    def var_B1(KP: T.Buffer((NKV, H, D), dtype), O: T.Buffer((PAGE, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_l1((PAGE, D), dtype)
            T.copy(KP[0:PAGE, 0, 0:D], S[0:PAGE, 0:D])
            T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return var_B1


def make_C1():
    @T.prim_func
    def var_C1(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV, H, D), dtype),
               O: T.Buffer((PAGE, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_l1((PAGE, D), dtype)
            pid = BT[0]
            T.copy(KP[pid * PAGE:(pid + 1) * PAGE, 0, 0:D], S[0:PAGE, 0:D])
            T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return var_C1


def make_D1():
    @T.prim_func
    def var_D1(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV, H, D), dtype),
               O: T.Buffer((PAGE, H, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_l1((PAGE, H, D), dtype)
            pid = BT[0]
            T.copy(KP[pid * PAGE:(pid + 1) * PAGE, 0:H, 0:D], S[0:PAGE, 0:H, 0:D])
            T.copy(S[0:PAGE, 0:H, 0:D], O[0:PAGE, 0:H, 0:D])

    return var_D1


def make_E1():
    @T.prim_func
    def var_E1(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV2, D), dtype),
               O: T.Buffer((PAGE, H, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_l1((PAGE * H, D), dtype)
            pid = BT[0]
            T.copy(KP[pid * PAGE * H:(pid + 1) * PAGE * H, 0:D],
                   S[0:PAGE * H, 0:D])
            T.copy(S[0:PAGE * H, 0:D], O[0:PAGE, 0:H, 0:D])

    return var_E1


def make_E2():
    @T.prim_func
    def var_E2(BT: T.Buffer((2,), "int32"), RL: T.Buffer((1,), "int32"),
               KP: T.Buffer((NKV2, D), dtype), O: T.Buffer((2, PAGE, H, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_l1((PAGE * H, D), dtype)
            rl = RL[0]
            for t in T.serial(2):
                with T.If(t * PAGE < rl):
                    with T.Then():
                        pid = BT[t]
                        T.copy(KP[pid * PAGE * H:(pid + 1) * PAGE * H, 0:D],
                               S[0:PAGE * H, 0:D])
                        T.copy(S[0:PAGE * H, 0:D], O[t, 0:PAGE, 0:H, 0:D])

    return var_E2


def make_G1():
    @T.prim_func
    def var_G1(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV2, D), dtype),
               O: T.Buffer((PAGE, H, D), dtype)):
        with T.Kernel(1) as bx:
            S = T.alloc_l1((PAGE * H, D), dtype)
            pid = BT[0]
            for r in T.serial(PAGE * H):
                T.copy(KP[pid * PAGE * H + r, 0:D], S[r, 0:D])
            T.copy(S[0:PAGE * H, 0:D], O[0:PAGE, 0:H, 0:D])

    return var_G1


VARIANTS = {
    "A1_base_contig": make_A1,
    "B1_strided_static": make_B1,
    "C1_strided_dynbt": make_C1,
    "D1_page3d_dynbt": make_D1,
    "E1_page2d_dynbt": make_E1,
    "E2_page2d_dynbt_if": make_E2,
    "G1_page2d_rowloop": make_G1,
}


def compile_variant(name, fn_src):
    print(f"\n--- variant {name}: compiling ---")
    try:
        kernel = tilelang.compile(fn_src)
    except Exception:
        tb = traceback.format_exc().strip().splitlines()
        print(f"COMPILE_FAIL {name}:")
        keep = [l for l in tb if "Error" in l or "Check failed" in l or "error:" in l]
        for line in (keep or tb)[-4:]:
            print("   ", line)
        return None
    print(f"COMPILE_OK {name}")
    return kernel


def main():
    dev = torch.device("npu")
    torch.manual_seed(0)
    bt = torch.tensor([5, 2], dtype=torch.int32, device=dev)
    rl = torch.tensor([100], dtype=torch.int32, device=dev)
    kp2 = torch.randn(NKV, D, dtype=torch.float16, device=dev)
    kp3 = torch.randn(NKV, H, D, dtype=torch.float16, device=dev)
    kp_flat = kp3.view(NKV2, D)

    ok = {}
    for name, maker in VARIANTS.items():
        k = compile_variant(name, maker())
        if k is not None:
            ok[name] = k

    print("\n=== run compiled variants ===")
    for name, kernel in ok.items():
        try:
            if name == "A1_base_contig":
                o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
                kernel(kp2, o)
                exp = kp2[:PAGE]
            elif name == "B1_strided_static":
                o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
                kernel(kp3, o)
                exp = kp3[:PAGE, 0, :]
            elif name == "C1_strided_dynbt":
                pid = int(bt[0])
                o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
                kernel(bt[:1], kp3, o)
                exp = kp3[pid * PAGE:(pid + 1) * PAGE, 0, :]
            elif name == "D1_page3d_dynbt":
                pid = int(bt[0])
                o = torch.zeros(PAGE, H, D, dtype=torch.float16, device=dev)
                kernel(bt[:1], kp3, o)
                exp = kp3[pid * PAGE:(pid + 1) * PAGE]
            elif name in ("E1_page2d_dynbt", "G1_page2d_rowloop"):
                pid = int(bt[0])
                o = torch.zeros(PAGE, H, D, dtype=torch.float16, device=dev)
                kernel(bt[:1], kp_flat, o)
                exp = kp_flat[pid * PAGE * H:(pid + 1) * PAGE * H].view(PAGE, H, D)
            elif name == "E2_page2d_dynbt_if":
                o = torch.zeros(2, PAGE, H, D, dtype=torch.float16, device=dev)
                kernel(bt, rl, kp_flat, o)
                covered = [t for t in range(2) if t * PAGE < int(rl[0])]
                good = all(torch.equal(
                    o[t],
                    kp_flat[int(bt[t]) * PAGE * H:(int(bt[t]) + 1) * PAGE * H].view(PAGE, H, D))
                    for t in covered)
                good = good and all(int(o[t].abs().sum()) == 0
                                    for t in range(2) if t not in covered)
                torch.npu.synchronize()
                print(f"{name}: {'PASS' if good else 'DATA_MISMATCH'} (covered {covered})")
                continue
            else:
                continue
            torch.npu.synchronize()
            good = torch.equal(o, exp)
            diff = (o.float() - exp.float()).abs().max().item()
            print(f"{name}: {'PASS' if good else f'DATA_MISMATCH max_diff={diff}'}")
        except Exception:
            tb = traceback.format_exc().strip().splitlines()
            print(f"RUN_FAIL {name}:")
            for line in tb[-4:]:
                print("   ", line)

    print("\n=== done ===")


if __name__ == "__main__":
    main()

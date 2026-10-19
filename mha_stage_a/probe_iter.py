"""探针迭代版：多变体二分，定位 ScalarDcacheBypass ICHECK 的触发条件。

背景：v1 探针（跨步 GM→L1 copy + BT 标量寻址）编译期挂在
MarkScalarDcacheBypass（"vector-valued buffer store not implemented"）。
该 pass 在 AscendLowerTileOp（copy 展开）和 VectorizeLoop 之后运行，
假设此时 GM 上只剩标量 store；向量 store 会 ICHECK。

变体矩阵（逐个 try/except 编译，编译成功的再上板执行比对）：
  A  纯基线：连续 GM↔L1 copy，无标量、无跨步       —— 期望过
  B  跨步读：KP[i, 0, :]（stride=H*D），静态基地址   —— 隔离"跨步"因素
  C  跨步读 + BT 标量寻址（原探针本质，去掉内层循环）—— 隔离"标量→地址"因素
  D  连续整页 copy [PAGE,H,D] + BT 标量寻址          —— 页级 gather 的可行替代
  E  D + T.If 运行时守卫（原 dynloop 本质）          —— 隔离"If 守卫"因素
  F  A 但输出走 T.dual_copy（例子同款 GM 写法）      —— 隔离"GM 写路径"因素

每个变体独立小 shape（NKV 行 fp16），失败打印 traceback 尾部 3 行。
"""

import traceback

import torch
import tilelang
import tilelang.ascend.language as T

D = 128
H = 4
PAGE = 64
NKV = 8 * PAGE  # 池行数
dtype = "float16"


def make_A():
    @T.prim_func
    def var_A(KP: T.Buffer((NKV, D), dtype), O: T.Buffer((PAGE, D), dtype)):
        S = T.alloc_l1((PAGE, D), dtype)
        T.copy(KP[0:PAGE, 0:D], S[0:PAGE, 0:D])
        T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return var_A, lambda kp, dev: kp[:PAGE]


def make_B():
    @T.prim_func
    def var_B(KP: T.Buffer((NKV, H, D), dtype), O: T.Buffer((PAGE, D), dtype)):
        S = T.alloc_l1((PAGE, D), dtype)
        T.copy(KP[0:PAGE, 0, 0:D], S[0:PAGE, 0:D])
        T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return var_B, lambda kp, dev: kp[:PAGE, 0, :]


def make_C():
    @T.prim_func
    def var_C(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV, H, D), dtype),
              O: T.Buffer((PAGE, D), dtype)):
        S = T.alloc_l1((PAGE, D), dtype)
        pid = BT[0]
        T.copy(KP[pid * PAGE:(pid + 1) * PAGE, 0, 0:D], S[0:PAGE, 0:D])
        T.copy(S[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return var_C, None  # 索引运行时给定


def make_D():
    @T.prim_func
    def var_D(BT: T.Buffer((1,), "int32"), KP: T.Buffer((NKV, H, D), dtype),
              O: T.Buffer((PAGE, H, D), dtype)):
        S = T.alloc_l1((PAGE, H, D), dtype)
        pid = BT[0]
        T.copy(KP[pid * PAGE:(pid + 1) * PAGE, 0:H, 0:D], S[0:PAGE, 0:H, 0:D])
        T.copy(S[0:PAGE, 0:H, 0:D], O[0:PAGE, 0:H, 0:D])

    return var_D, None


def make_E():
    @T.prim_func
    def var_E(BT: T.Buffer((2,), "int32"), RL: T.Buffer((1,), "int32"),
              KP: T.Buffer((NKV, H, D), dtype), O: T.Buffer((2, PAGE, H, D), dtype)):
        S = T.alloc_l1((PAGE, H, D), dtype)
        rl = RL[0]
        for t in T.serial(2):
            with T.If(t * PAGE < rl):
                with T.Then():
                    pid = BT[t]
                    T.copy(KP[pid * PAGE:(pid + 1) * PAGE, 0:H, 0:D], S[0:PAGE, 0:H, 0:D])
                    T.copy(S[0:PAGE, 0:H, 0:D], O[t, 0:PAGE, 0:H, 0:D])

    return var_E, None


def make_F():
    @T.prim_func
    def var_F(KP: T.Buffer((NKV, D), dtype), O: T.Buffer((PAGE, D), dtype)):
        S_ub = T.alloc_shared((PAGE, D), dtype)
        T.copy(KP[0:PAGE, 0:D], S_ub[0:PAGE, 0:D])
        T.dual_copy(S_ub[0:PAGE, 0:D], O[0:PAGE, 0:D])

    return var_F, lambda kp, dev: kp[:PAGE]


VARIANTS = {
    "A_base_contig": make_A,
    "B_strided_static": make_B,
    "C_strided_dynbt": make_C,
    "D_contig_dynbt": make_D,
    "E_contig_dynbt_if": make_E,
    "F_dual_copy_out": make_F,
}


def run_variant(name, fn_src, check):
    print(f"\n--- variant {name}: compiling ---")
    try:
        kernel = tilelang.compile(fn_src)
    except Exception:
        tb = traceback.format_exc().strip().splitlines()
        print(f"COMPILE_FAIL {name}:")
        for line in tb[-4:]:
            print("   ", line)
        return
    print(f"COMPILE_OK {name}; running on device ...")
    try:
        dev = torch.device("npu")
        torch.manual_seed(0)
        bt = torch.tensor([5, 2], dtype=torch.int32, device=dev)
        rl = torch.tensor([100], dtype=torch.int32, device=dev)
        kp2 = torch.randn(NKV, D, dtype=torch.float16, device=dev)
        kp3 = torch.randn(NKV, H, D, dtype=torch.float16, device=dev)
        o = torch.zeros(NKV, dtype=torch.float16, device=dev)  # 占位，下面按变体重设

        if name in ("A_base_contig", "F_dual_copy_out"):
            o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
            kernel(kp2, o)
            exp = kp2[:PAGE]
        elif name == "B_strided_static":
            o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
            kernel(kp3, o)
            exp = kp3[:PAGE, 0, :]
        elif name == "C_strided_dynbt":
            pid = int(bt[0])
            o = torch.zeros(PAGE, D, dtype=torch.float16, device=dev)
            kernel(bt[:1], kp3, o)
            exp = kp3[pid * PAGE:(pid + 1) * PAGE, 0, :]
        elif name == "D_contig_dynbt":
            pid = int(bt[0])
            o = torch.zeros(PAGE, H, D, dtype=torch.float16, device=dev)
            kernel(bt[:1], kp3, o)
            exp = kp3[pid * PAGE:(pid + 1) * PAGE]
        elif name == "E_contig_dynbt_if":
            o = torch.zeros(2, PAGE, H, D, dtype=torch.float16, device=dev)
            kernel(bt, rl, kp3, o)
            covered = [t for t in range(2) if t * PAGE < int(rl[0])]
            ok = all(torch.equal(o[t], kp3[int(bt[t]) * PAGE:(int(bt[t]) + 1) * PAGE])
                     for t in covered)
            ok = ok and all(int(o[t].abs().sum()) == 0
                            for t in range(2) if t not in covered)
            torch.npu.synchronize()
            print("PASS" if ok else "DATA_MISMATCH", f"(covered pages: {covered})")
            return
        else:
            print("SKIP unknown variant")
            return

        torch.npu.synchronize()
        ok = torch.equal(o, exp)
        diff = (o.float() - exp.float()).abs().max().item()
        print("PASS" if ok else f"DATA_MISMATCH max_diff={diff}")
    except Exception:
        tb = traceback.format_exc().strip().splitlines()
        print(f"RUN_FAIL {name}:")
        for line in tb[-4:]:
            print("   ", line)


def main():
    for name, maker in VARIANTS.items():
        fn, check = maker()
        run_variant(name, fn, check)
    print("\n=== all variants done ===")


if __name__ == "__main__":
    main()

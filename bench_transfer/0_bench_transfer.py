"""三种搬运操作的性能测试 kernel 生成。

被测操作（REPEAT 次放大，差分法计时）：
  1. ub2ub   : UB -> UB           （Vector 指令 vld/vst，纯 AIV）
  2. l12l1   : L1  -> L1          （LoadData 线性搬运，AIC）
  3. l1ub    : L1  -> UB -> L1    （两跳中转，可能拆 mix）

三个 kernel 统一结构：
  GM 载入 -> REPEAT x [被测搬运] -> dummy gemm 消费 dst（防 DCE + 满足
  SplitDataflow 契约）-> 输出回 GM。

ub2ub 没有 gemm（UB 无契约要求），保留输出回写防 DCE。
"""

import os
import sys

import tilelang
import tilelang.language as T

OUT_DIR = os.path.dirname(os.path.abspath(__file__))


def _mk_out(name, src):
    path = os.path.join(OUT_DIR, name)
    with open(path, "w") as f:
        f.write(src)
    print(f"saved: {path}")


def _lower(program):
    artifact = tilelang.lower(program, target="tile")
    return artifact.kernel_source


# --------------------------------------------------------------------------
# 1) UB -> UB：纯 AIV kernel，无 gemm、无 L1，无 SplitDataflow 契约问题。
# --------------------------------------------------------------------------
def ub2ub(M, K, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def ub2ub_kernel(X: T.Buffer((M, K), dtype), OUT: T.Buffer((M, K), dtype)):
        with T.Kernel(1) as bx:
            # 无 gemm 引用 -> 推断为 UB
            src = T.alloc_shared((M, K), dtype)
            dst = T.alloc_shared((M, K), dtype)
            T.copy(X[0:M, 0:K], src)  # GM -> UB
            for r in T.serial(REPEAT):
                T.copy(src, dst)  # UB -> UB（被测）
            T.copy(dst, OUT[0:M, 0:K])  # UB -> GM（防 DCE）

    return ub2ub_kernel


# --------------------------------------------------------------------------
# 1b) UB -> scalar -> UB: pure AIV kernel, no gemm, no L1.
#     Scalar load/store (memref.load/store -> PIPE_S scalar pipeline),
#     counterpart to ub2ub's vector DMA path.
# --------------------------------------------------------------------------
def ub_scalar(M, K, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def ub_scalar_kernel(X: T.Buffer((M, K), dtype), OUT: T.Buffer((M, K), dtype)):
        with T.Kernel(1) as bx:
            src = T.alloc_shared((M, K), dtype)  # no gemm -> UB
            dst = T.alloc_shared((M, K), dtype)  # no gemm -> UB
            T.copy(X[0:M, 0:K], src)  # GM -> UB
            for r in T.serial(REPEAT):
                for i in T.serial(M):
                    for j in T.serial(K):
                        dst[i, j] = src[i, j]  # scalar read UB + scalar write UB (under test)
            T.copy(dst, OUT[0:M, 0:K])  # UB -> GM (prevent DCE)

    return ub_scalar_kernel

# --------------------------------------------------------------------------
# 2) L1 -> L1：AIC kernel，交替 gemm + 双 W 结构。
#    v1 教训：x_src 不被 gemm 读 -> 推断为 UB；writer 在循环内 reader 在
#    循环外 -> 违反支配契约。
#    v2 教训：两个 gemm 操作数相同被 CSE 合并 -> 回搬 copy 被判冗余消除
#    -> buf_a 失去 gemm reader 退回 UB。
#    v3：两个 gemm 用不同 B 操作数（W1/W2），acc 累加（clear_accum=False），
#    语义不可合并；每轮 2 次 L1->L1 搬运（a->b + b->a）。
# --------------------------------------------------------------------------
def l12l1(M, K, N, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def l12l1_kernel(
        X: T.Buffer((M, K), dtype),
        W1: T.Buffer((K, N), dtype),
        W2: T.Buffer((K, N), dtype),
        OUT1: T.Buffer((M, N), "float32"),
        OUT2: T.Buffer((M, N), "float32"),
    ):
        with T.Kernel(1) as bx:
            buf_a = T.alloc_shared((M, K), dtype)  # gemm A -> L1
            buf_b = T.alloc_shared((M, K), dtype)  # gemm A -> L1
            w1_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            w2_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            acc1 = T.alloc_fragment((M, N), "float32")
            acc2 = T.alloc_fragment((M, N), "float32")
            out1_ub = T.alloc_shared((M, N), "float32")
            out2_ub = T.alloc_shared((M, N), "float32")

            T.copy(X[0:M, 0:K], buf_a)  # GM -> L1 (CUBE)
            T.copy(W1[0:K, 0:N], w1_shared)  # GM -> L1 (CUBE)
            T.copy(W2[0:K, 0:N], w2_shared)  # GM -> L1 (CUBE)

            for r in T.serial(REPEAT):
                T.copy(buf_a, buf_b)  # L1 -> L1（被测）
                T.gemm(
                    buf_b,
                    w1_shared,
                    acc1,
                    transpose_B=False,
                    clear_accum=True,
                )  # reader 同循环（契约）
                T.copy(buf_b, buf_a)  # L1 -> L1（被测，对称搬回）
                T.gemm(
                    buf_a,
                    w2_shared,
                    acc2,
                    transpose_B=False,
                    clear_accum=True,
                )

            T.copy(acc1, out1_ub)  # L0C -> UB
            T.copy(out1_ub, OUT1[0:M, 0:N])  # UB -> GM
            T.copy(acc2, out2_ub)  # L0C -> UB
            T.copy(out2_ub, OUT2[0:M, 0:N])  # UB -> GM

    return l12l1_kernel


# --------------------------------------------------------------------------
# 3) L1 -> UB -> L1：两跳中转，交替 gemm + 双 W 结构（同 l12l1 v3 修正）。
#    每轮 2 次完整两跳（a->UB->b + b->UB->a，对称往返）。
# --------------------------------------------------------------------------
def l1ub(M, K, N, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def l1ub_kernel(
        X: T.Buffer((M, K), dtype),
        W1: T.Buffer((K, N), dtype),
        W2: T.Buffer((K, N), dtype),
        OUT1: T.Buffer((M, N), "float32"),
        OUT2: T.Buffer((M, N), "float32"),
    ):
        with T.Kernel(1) as bx:
            buf_a = T.alloc_shared((M, K), dtype)  # gemm A -> L1
            buf_b = T.alloc_shared((M, K), dtype)  # gemm A -> L1
            ub_tmp = T.alloc_shared((M, K), dtype)  # 无 gemm -> UB 中转
            w1_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            w2_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            acc1 = T.alloc_fragment((M, N), "float32")
            acc2 = T.alloc_fragment((M, N), "float32")
            out1_ub = T.alloc_shared((M, N), "float32")
            out2_ub = T.alloc_shared((M, N), "float32")

            T.copy(X[0:M, 0:K], buf_a)  # GM -> L1 (CUBE)
            T.copy(W1[0:K, 0:N], w1_shared)  # GM -> L1 (CUBE)
            T.copy(W2[0:K, 0:N], w2_shared)  # GM -> L1 (CUBE)

            for r in T.serial(REPEAT):
                T.copy(buf_a, ub_tmp)  # L1 -> UB（第一跳）
                T.copy(ub_tmp, buf_b)  # UB -> L1（第二跳）
                T.gemm(
                    buf_b,
                    w1_shared,
                    acc1,
                    transpose_B=False,
                    clear_accum=True,
                )
                T.copy(buf_b, ub_tmp)  # L1 -> UB（第一跳，返程）
                T.copy(ub_tmp, buf_a)  # UB -> L1（第二跳，返程）
                T.gemm(
                    buf_a,
                    w2_shared,
                    acc2,
                    transpose_B=False,
                    clear_accum=True,
                )

            T.copy(acc1, out1_ub)
            T.copy(out1_ub, OUT1[0:M, 0:N])
            T.copy(acc2, out2_ub)
            T.copy(out2_ub, OUT2[0:M, 0:N])

    return l1ub_kernel


# --------------------------------------------------------------------------
# 3a) L1 -> UB 消融-A：循环内只有 L1->UB 一跳（无 UB->L1、无 gemm）。
#     buf_a/buf_b 由循环外末尾 gemm 保住 L1，ub_tmp 由 copy->buf_b 消费保住 UB。
#     与 l1ub 对照做消融：若 A 也 AICORE_EXCEPTION，则根因在 L1->UB 本身
#     （mov.l1.to.ub.v310）；若 A 过、B（l1ub_b）崩，则在 UB->L1
#     （mov.ub.to.l1.v310）；若 A、B 都过，则在与 gemm 的交互。
#     两个 prim_func 均命名为 l1ub_kernel（各自独立编译，kname/sed 无需区分）。
# --------------------------------------------------------------------------
def l1ub_a(M, K, N, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def l1ub_kernel(
        X: T.Buffer((M, K), dtype),
        W1: T.Buffer((K, N), dtype),
        W2: T.Buffer((K, N), dtype),
        OUT1: T.Buffer((M, N), "float32"),
        OUT2: T.Buffer((M, N), "float32"),
    ):
        with T.Kernel(1) as bx:
            buf_a = T.alloc_shared((M, K), dtype)  # 末尾 gemm 读 -> L1
            buf_b = T.alloc_shared((M, K), dtype)  # 末尾 gemm 读 -> L1
            ub_tmp = T.alloc_shared((M, K), dtype)  # copy 消费 -> UB
            w1_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            w2_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            acc1 = T.alloc_fragment((M, N), "float32")
            acc2 = T.alloc_fragment((M, N), "float32")
            out1_ub = T.alloc_shared((M, N), "float32")
            out2_ub = T.alloc_shared((M, N), "float32")

            T.copy(X[0:M, 0:K], buf_a)  # GM -> L1 (CUBE)
            T.copy(W1[0:K, 0:N], w1_shared)  # GM -> L1 (CUBE)
            T.copy(W2[0:K, 0:N], w2_shared)  # GM -> L1 (CUBE)

            for r in T.serial(REPEAT):
                T.copy(buf_a, ub_tmp)  # L1 -> UB（被测唯一一跳）

            # 循环外恒定：给 buf_a/buf_b 保 L1、ub_tmp 保 UB（未计量）
            T.copy(ub_tmp, buf_b)  # UB -> L1（const）
            T.gemm(
                buf_b,
                w1_shared,
                acc1,
                transpose_B=False,
                clear_accum=True,
            )
            T.gemm(
                buf_a,
                w2_shared,
                acc2,
                transpose_B=False,
                clear_accum=True,
            )

            T.copy(acc1, out1_ub)
            T.copy(out1_ub, OUT1[0:M, 0:N])
            T.copy(acc2, out2_ub)
            T.copy(out2_ub, OUT2[0:M, 0:N])

    return l1ub_kernel


# --------------------------------------------------------------------------
# 3a-w) UB->L1 写方向消融-W：循环内只有 UB->L1 一跳（无 L1->UB、无 gemm）。
#     与 l1ub_a（循环内只 L1->UB）成对：若 A(读)崩、W(写)过 => 工具链未使能
#     L1->UB 回读（mov.l1.to.ub.v310）；若 W 也崩 => L1 访问整体未使能。
#     与 l1ub_a 相同，两个 prim_func 均命名为 l1ub_kernel。
# --------------------------------------------------------------------------
def l1ub_w(M, K, N, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def l1ub_kernel(
        X: T.Buffer((M, K), dtype),
        W1: T.Buffer((K, N), dtype),
        W2: T.Buffer((K, N), dtype),
        OUT1: T.Buffer((M, N), "float32"),
        OUT2: T.Buffer((M, N), "float32"),
    ):
        with T.Kernel(1) as bx:
            buf_a = T.alloc_shared((M, K), dtype)  # GM -> L1
            buf_b = T.alloc_shared((M, K), dtype)  # 被测 UB->L1 写目标 -> L1
            ub_tmp = T.alloc_shared((M, K), dtype)  # 被测源 -> UB
            w1_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            w2_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            acc1 = T.alloc_fragment((M, N), "float32")
            acc2 = T.alloc_fragment((M, N), "float32")
            out1_ub = T.alloc_shared((M, N), "float32")
            out2_ub = T.alloc_shared((M, N), "float32")

            T.copy(X[0:M, 0:K], buf_a)  # GM -> L1 (CUBE)
            T.copy(W1[0:K, 0:N], w1_shared)  # GM -> L1 (CUBE)
            T.copy(W2[0:K, 0:N], w2_shared)  # GM -> L1 (CUBE)
            T.copy(buf_a, ub_tmp)  # L1 -> UB（const，填被测源）

            for r in T.serial(REPEAT):
                T.copy(ub_tmp, buf_b)  # UB -> L1（被测唯一一跳，写方向）

            # 循环外恒定：给 buf_a/buf_b 保 L1、ub_tmp 保 UB（未计量）
            T.gemm(
                buf_a,
                w1_shared,
                acc1,
                transpose_B=False,
                clear_accum=True,
            )
            T.gemm(
                buf_b,
                w2_shared,
                acc2,
                transpose_B=False,
                clear_accum=True,
            )

            T.copy(acc1, out1_ub)
            T.copy(out1_ub, OUT1[0:M, 0:N])
            T.copy(acc2, out2_ub)
            T.copy(out2_ub, OUT2[0:M, 0:N])

    return l1ub_kernel


# --------------------------------------------------------------------------
# 3b) L1->UB + UB->L1 消融-B：循环内两跳（跳 1 为被测值，跳 2 把复制的中间结果
#     搬回 L1），无 gemm。与 l1ub 对照隔离"完整往返"是否触发 AICORE_EXCEPTION。
# --------------------------------------------------------------------------
def l1ub_b(M, K, N, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def l1ub_kernel(
        X: T.Buffer((M, K), dtype),
        W1: T.Buffer((K, N), dtype),
        W2: T.Buffer((K, N), dtype),
        OUT1: T.Buffer((M, N), "float32"),
        OUT2: T.Buffer((M, N), "float32"),
    ):
        with T.Kernel(1) as bx:
            buf_a = T.alloc_shared((M, K), dtype)  # gemm 读 -> L1
            buf_b = T.alloc_shared((M, K), dtype)  # gemm 读 -> L1
            ub_tmp = T.alloc_shared((M, K), dtype)  # 中间 -> UB
            w1_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            w2_shared = T.alloc_shared((K, N), dtype)  # gemm B -> L1
            acc1 = T.alloc_fragment((M, N), "float32")
            acc2 = T.alloc_fragment((M, N), "float32")
            out1_ub = T.alloc_shared((M, N), "float32")
            out2_ub = T.alloc_shared((M, N), "float32")

            T.copy(X[0:M, 0:K], buf_a)  # GM -> L1 (CUBE)
            T.copy(W1[0:K, 0:N], w1_shared)  # GM -> L1 (CUBE)
            T.copy(W2[0:K, 0:N], w2_shared)  # GM -> L1 (CUBE)

            for r in T.serial(REPEAT):
                T.copy(buf_a, ub_tmp)  # L1 -> UB（第一跳）
                T.copy(ub_tmp, buf_b)  # UB -> L1（第二跳）

            # 循环外恒定（未计量）
            T.gemm(
                buf_b,
                w1_shared,
                acc1,
                transpose_B=False,
                clear_accum=True,
            )
            T.gemm(
                buf_a,
                w2_shared,
                acc2,
                transpose_B=False,
                clear_accum=True,
            )

            T.copy(acc1, out1_ub)
            T.copy(out1_ub, OUT1[0:M, 0:N])
            T.copy(acc2, out2_ub)
            T.copy(out2_ub, OUT2[0:M, 0:N])

    return l1ub_kernel


# --------------------------------------------------------------------------
# baseline：无 REPEAT 搬运，只有 GM 载入 + gemm + 输出。
# 与 l12l1/l1ub 差分可消去 gemm/GM/launch 常数开销。
# --------------------------------------------------------------------------
def baseline(M, K, N, dtype="bfloat16"):
    @T.prim_func
    def baseline_kernel(
        X: T.Buffer((M, K), dtype),
        W: T.Buffer((K, N), dtype),
        OUT: T.Buffer((M, N), "float32"),
    ):
        with T.Kernel(1) as bx:
            x_dst = T.alloc_shared((M, K), dtype)
            w_shared = T.alloc_shared((K, N), dtype)
            acc = T.alloc_fragment((M, N), "float32")
            out_ub = T.alloc_shared((M, N), "float32")

            T.copy(X[0:M, 0:K], x_dst)
            T.copy(W[0:K, 0:N], w_shared)
            T.gemm(
                x_dst,
                w_shared,
                acc,
                transpose_B=False,
                clear_accum=True,
            )
            T.copy(acc, out_ub)
            T.copy(out_ub, OUT[0:M, 0:N])

    return baseline_kernel


VARIANTS = {
    "ub2ub": ub2ub,
    "ub_scalar": ub_scalar,
    "l12l1": l12l1,
    "l1ub": l1ub,
    "l1ub_a": l1ub_a,
    "l1ub_w": l1ub_w,
    "l1ub_b": l1ub_b,
    "baseline": baseline,
}


def main():
    """CLI: 0_bench_transfer.py <variant> <M> <K> <N> <REPEAT> <dtype>

    无参数时编译全部冒烟规格（bf16 64x256 r64）。
    """
    if len(sys.argv) > 1:
        variant, M, K, N, REPEAT = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])
        dtype = sys.argv[6] if len(sys.argv) > 6 else "bfloat16"
        fn = VARIANTS[variant]
        if variant in ("ub2ub", "ub_scalar"):
            program = fn(M, K, REPEAT, dtype=dtype)
        elif variant == "baseline":
            program = fn(M, K, N, dtype=dtype)
        else:
            program = fn(M, K, N, REPEAT, dtype=dtype)
        src = _lower(program)
        _mk_out("1_bench_tilelangir.mlir", src)
        print(f"[OK] {variant} M={M} K={K} N={N} REPEAT={REPEAT} dtype={dtype}")
        return

    # 冒烟规格：bf16 (64, 256)，N=16，REPEAT=64
    M, K, N, REPEAT = 64, 256, 16, 64
    for name, fn in VARIANTS.items():
        if name in ("ub2ub", "ub_scalar"):
            program = fn(M, K, REPEAT)
        elif name == "baseline":
            program = fn(M, K, N)
        else:
            program = fn(M, K, N, REPEAT, dtype="bfloat16")
        try:
            src = _lower(program)
            _mk_out(f"1_{name}_tilelangir.mlir", src)
            print(f"[OK] {name}")
        except Exception as exc:
            print(f"[FAIL] {name}: {exc}")


if __name__ == "__main__":
    main()

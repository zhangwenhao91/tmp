"""标量中转路径可行性测试：UB->scalar->UB 与 L1->scalar->L1。

验证目标（编译链全程 + 指令层）：
  1. ub_scalar : UB  -> 标量循环 -> UB   （标量访问应在 AIV 侧，PIPE_S）
  2. l1_scalar : L1  -> 标量循环 -> L1   （L1 标量访问只有 AIC 能做，看编译器怎么分核）

结构照抄 0_bench_transfer.py：GM 载入 -> REPEAT x [被测标量搬运] -> 输出回 GM。
gemm 消费者保持 L1 推断（l1_scalar 用）。
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
# 1) UB -> scalar -> UB：纯 AIV，无 gemm。
#    标量读写 = memref.load/store，AIV 上应编译到 PIPE_S 标量管线。
# --------------------------------------------------------------------------
def ub_scalar(M, K, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def ub_scalar_kernel(X: T.Buffer((M, K), dtype), OUT: T.Buffer((M, K), dtype)):
        with T.Kernel(1) as bx:
            src = T.alloc_shared((M, K), dtype)  # 无 gemm 引用 -> UB
            dst = T.alloc_shared((M, K), dtype)  # 无 gemm 引用 -> UB
            T.copy(X[0:M, 0:K], src)  # GM -> UB
            for r in T.serial(REPEAT):
                for i in T.serial(M):
                    for j in T.serial(K):
                        dst[i, j] = src[i, j]  # 标量读 UB + 标量写 UB（被测）
            T.copy(dst, OUT[0:M, 0:K])  # UB -> GM（防 DCE）

    return ub_scalar_kernel


# --------------------------------------------------------------------------
# 2) L1 -> scalar -> L1：buf_a/buf_b 被 gemm 引用保 L1，标量循环搬运。
#    关键看点：SplitDataflow 把标量循环分给哪个核；L1 标量访问 ccec
#    已单独验证可编译（cube arch），但 tilelang 管线是否支持待验。
# --------------------------------------------------------------------------
def l1_scalar(M, K, N, REPEAT, dtype="bfloat16"):
    @T.prim_func
    def l1_scalar_kernel(
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
                for i in T.serial(M):
                    for j in T.serial(K):
                        buf_b[i, j] = buf_a[i, j]  # 标量 L1 -> L1（被测）
                T.gemm(
                    buf_b, w1_shared, acc1, transpose_B=False, clear_accum=True
                )
                for i in T.serial(M):
                    for j in T.serial(K):
                        buf_a[i, j] = buf_b[i, j]  # 标量 L1 -> L1（返程）
                T.gemm(
                    buf_a, w2_shared, acc2, transpose_B=False, clear_accum=True
                )

            T.copy(acc1, out1_ub)
            T.copy(out1_ub, OUT1[0:M, 0:N])
            T.copy(acc2, out2_ub)
            T.copy(out2_ub, OUT2[0:M, 0:N])

    return l1_scalar_kernel


VARIANTS = {
    "ub_scalar": ub_scalar,
    "l1_scalar": l1_scalar,
}


def main():
    if len(sys.argv) > 1:
        variant, M, K, N, REPEAT = (
            sys.argv[1], int(sys.argv[2]), int(sys.argv[3]),
            int(sys.argv[4]), int(sys.argv[5]),
        )
        dtype = sys.argv[6] if len(sys.argv) > 6 else "bfloat16"
        fn = VARIANTS[variant]
        if variant == "ub_scalar":
            program = fn(M, K, REPEAT, dtype=dtype)
        else:
            program = fn(M, K, N, REPEAT, dtype=dtype)
        src = _lower(program)
        _mk_out("1_scalar_tilelangir.mlir", src)
        print(f"[OK] {variant} M={M} K={K} N={N} REPEAT={REPEAT} dtype={dtype}")
        return

    # 冒烟：bf16 16x256，N=16，REPEAT=2（只要编译通过验证结构）
    M, K, N, REPEAT = 16, 256, 16, 2
    for name, fn in VARIANTS.items():
        if name == "ub_scalar":
            program = fn(M, K, REPEAT)
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

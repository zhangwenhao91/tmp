"""T.print 端到端 DSL。

    T.print(buf)   -> 整块 buffer 打印（一个 tilelang.print op）
    T.print(expr)  -> 标量表达式打印（一个 tilelang.print op）
    T.print(msg=)  -> 纯消息打印（无 operand）

前端（Stack A）应产出单个 tilelang.print op，不做逐元素展开。
"""

import os

import tilelang
import tilelang.language as T

HERE = os.path.dirname(os.path.abspath(__file__))


def print_program(M=16, N=16):
    dtype = "float16"

    @T.prim_func
    def print_kernel(Q: T.Buffer((M, N), dtype)):
        # Use a multi-block kernel so the expr form prints a real block index;
        # with extent 1 TVM constant-folds blockIdx.x to 0.
        with T.Kernel(4) as bx:
            shared_buf = T.alloc_shared((M, N), dtype)
            T.print(shared_buf)
            T.print(bx, msg="block id")
            T.print(msg="hello")

    return print_kernel


def _lower(program, out_name):
    artifact = tilelang.lower(program, target="tile")
    out_path = os.path.join(HERE, out_name)
    with open(out_path, "w") as f:
        f.write(artifact.kernel_source)
    print(f"mlir saved to: {out_path}")


if __name__ == "__main__":
    _lower(print_program(), "1_print_tilelangir.mlir")
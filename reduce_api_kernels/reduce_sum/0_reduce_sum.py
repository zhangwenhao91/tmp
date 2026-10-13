"""reduce_sum 端到端 DSL 生成入口。

    A(M, K) -> OUT(M)，dim=1 每行求和；grid = M/BR，每 block 处理 BR 行。

三条路线（详见 _dsl.py）：
    frag    SimdVF 内 shared -> frag -> vreduce_sum(frag, frag) -> shared
    shared  SimdVF 内 T.reduce_sum(a_shared, out_shared, dim=1)（宏经 fragment 中转）
    thread  线程域内 T.reduce_sum(...)（translator 自动包 simd scope）

实测可行 dtype（本机全链路到 .o）：
    f16 / bf16 / f32 / i32（i8/i16 因缺 vcadd 8/16-bit intrinsic 不可行；
    f64/i64 位宽 >32 不可行）
产出的 1_*.mlir 由 _dsl.MATRIX x SHAPES 决定（形态 x dtype x shape）。
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))

from _dsl import emit

if __name__ == "__main__":
    emit("reduce_sum", HERE)
"""reduce_absmax 端到端 DSL 生成入口。

    A(M, K) -> OUT(M)，dim=1 每行 |x| 取最大值；grid = M/BR。

三条路线（详见 _dsl.py）：
    frag    SimdVF 内用 vmax(x, -x) 合成 abs 再 vreduce_max
    shared  SimdVF 内 T.reduce_absmax(a_shared, out_shared, dim=1)
    thread  线程域内 T.reduce_absmax(...)

实测可行 dtype：
    frag          f16 / f32 / i8 / i16 / i32
    shared/thread f16 / f32（bf16 缺 vcmax bf16；int 会在 producer 侧 abort）
    f64/i64 位宽 >32 不可行
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))

from _dsl import emit

if __name__ == "__main__":
    emit("reduce_absmax", HERE)
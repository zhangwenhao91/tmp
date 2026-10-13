"""reduce_min 端到端 DSL 生成入口。

    A(M, K) -> OUT(M)，dim=1 每行取最小值；grid = M/BR。

三条路线（详见 _dsl.py）：
    frag    SimdVF 内用 max(-x) 再取负合成 min（无 vreduce_min 原语）
    shared  SimdVF 内 T.reduce_min(a_shared, out_shared, dim=1)
    thread  线程域内 T.reduce_min(...)

实测可行 dtype：f16 / f32 / i8 / i16 / i32（bf16 因缺 vcmin/vcmax bf16 不可行；
f64/i64 位宽 >32 不可行）
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))

from _dsl import emit

if __name__ == "__main__":
    emit("reduce_min", HERE)
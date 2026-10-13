"""reduce_abssum 端到端 DSL 生成入口。

    A(M, K) -> OUT(M)，dim=1 每行 |x| 求和；grid = M/BR。

三条路线（详见 _dsl.py）：
    frag    SimdVF 内用 vmax(x, -x) 合成 abs 再 vreduce_sum
    shared  SimdVF 内 T.reduce_abssum(a_shared, out_shared, dim=1)（linalg.abs 预处理）
    thread  线程域内 T.reduce_abssum(...)

实测可行 dtype：
    frag          f16 / bf16 / f32 / i32
    shared/thread f16 / bf16 / f32（int 会在 producer 侧 linalg.reduce 校验处 abort）
    f64/i64 位宽 >32 不可行
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))

from _dsl import emit

if __name__ == "__main__":
    emit("reduce_abssum", HERE)
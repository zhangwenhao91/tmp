"""stage0 前端探针：把主仓 tilelang.ascend.language.simd (S.*) 嫁接进本机
producer 进程，实测 tl.simd.pset/vld/vsts 在 producer 链路上的报错点。

背景：主仓 examples/ascend/flash_attention/core.py 的 softmax 用 S.* 寄存器级
intrinsic（tl.simd.* op 家族）；本机 producer (tilelang-tileir-ascend) 没有
tilelang/ascend 包。本探针回答：若强行把 S.* 表达式喂给 producer 的
tilelang.lower(target="tile")，在哪一层、以什么错误失败。
"""

import importlib.util
import sys
import traceback
import types

import tilelang  # 必须先 import：producer 在此时装载自带的 tvm
import tilelang.language as T

# --- 嫁接主仓 simd.py 为 tilelang.ascend.language.simd --------------------
MAIN_SIMD = "/home/zwh/tilelang/tilelang/ascend/language/simd.py"

asc = types.ModuleType("tilelang.ascend")
asc.__path__ = []
asc_lang = types.ModuleType("tilelang.ascend.language")
asc_lang.__path__ = []
simd_pkg = types.ModuleType("tilelang.ascend.language.simd")
sys.modules["tilelang.ascend"] = asc
sys.modules["tilelang.ascend.language"] = asc_lang
sys.modules["tilelang.ascend.language.simd"] = simd_pkg

_spec = importlib.util.spec_from_file_location(
    "tilelang.ascend.language.simd._mainrepo", MAIN_SIMD
)
S = importlib.util.module_from_spec(_spec)
sys.modules[_spec.name] = S
_spec.loader.exec_module(S)
print("graft: 主仓 simd.py 装载成功（依赖 alloc_var/access_ptr 均命中 producer 实现）")


@T.prim_func
def simd_probe_kernel(
    X: T.Buffer((64,), "float32"),
    Y: T.Buffer((64,), "float32"),
):
    with T.Kernel(1) as bx:
        ub = T.alloc_shared((64,), "float32")
        with T.SimdVF():
            mask = S.pset(32, "PAT_ALL")          # tl.simd.pset
            v = S.vld(ub[0], "NORM")              # tl.simd.vld
            S.vsts(ub[0], v, mask, "NORM_B32")    # tl.simd.vsts
        T.copy(ub[0:64], Y[0:64])


if __name__ == "__main__":
    try:
        artifact = tilelang.lower(simd_probe_kernel, target="tile")
    except Exception as e:
        print(f"\n[结论] stage0 失败：{type(e).__module__}.{type(e).__name__}")
        msg = str(e).splitlines()
        for line in msg[:12]:
            print("  " + line)
        if len(msg) > 12:
            print(f"  ...（共 {len(msg)} 行）")
        sys.exit(2)
    print("\n[意外] stage0 竟然通过——需人工检查产物")
    sys.exit(1)

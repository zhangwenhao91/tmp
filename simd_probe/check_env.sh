#!/usr/bin/env bash
# 探针前置检查：① producer 侧 simd.py 依赖是否齐备 ② 工具链二进制 op 注册情况
set -u
PY=/home/zwh/work/venv/bin/python

echo "=== [1] producer tvm 依赖检查 ==="
$PY - <<'EOF'
import traceback
try:
    from tvm import tirx
    from tvm.tirx.script.builder.ir import bind, sblock_attr
    from tvm.script.ir_builder import IRBuilder
    print("tirx.script.builder.ir bind/sblock_attr: OK")
except Exception:
    traceback.print_exc()
try:
    from tilelang.language.allocate import alloc_var, alloc_local
    print("tilelang.language.allocate alloc_var/alloc_local: OK")
except Exception:
    traceback.print_exc()
try:
    from tilelang.language.builtin import access_ptr
    print("tilelang.language.builtin.access_ptr: OK")
except Exception:
    traceback.print_exc()
try:
    import tilelang, os
    p = os.path.dirname(tilelang.__file__)
    print("producer tilelang path:", p)
    print("has tilelang/ascend:", os.path.isdir(os.path.join(p, "ascend")))
except Exception:
    traceback.print_exc()
EOF

echo
echo "=== [2] tile-opt 中 tl.simd op 注册 ==="
BIN=/home/zwh/work/tilelang-toolchain/build/bin/tile-opt
echo "tl.simd.* 出现次数: $(strings $BIN | grep -c 'tl\.simd')"
echo "具体 op 名（tl.simd. 前缀）:"
strings $BIN | grep -o 'tl\.simd\.[a-z_]*' | sort -u | head -20
echo "（空 = 未注册任何 tl.simd op）"
echo
echo "=== [3] tile-opt 中 npu 向量 op 全集（npu.v*） ==="
strings $BIN | grep -oE 'npu\.v[a-z_0-9]+' | sort -u
echo
echo "=== [4] tile-translate / ccec 中 vsstb/vsts 痕迹 ==="
for b in /home/zwh/work/tilelang-toolchain/build/bin/tile-translate; do
  echo "$b: vsstb=$(strings $b | grep -c vsstb) vsts=$(strings $b | grep -c vsts) pset=$(strings $b | grep -c 'pset')"
done

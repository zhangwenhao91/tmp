#!/usr/bin/env bash
# paged_decode_probe 降级驱动：DSL -> TileLangIR -> NPU IR -> MIX -> CCE -> LLVM -> .o
# 用法: ./build.sh          # stage0(需 producer venv) + stage1..5
#       SKIP_STAGE0=1 ./build.sh   # 从已有 1_*.mlir 开始
#
# 验证点：R1 block_table 动态寻址 / R2 动态 trip count 能否过全链
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

is_exec() { [ -x "$1" ] || command -v "$1" >/dev/null 2>&1; }
pick() { if [ -n "${1:-}" ]; then printf '%s' "$1"; return; fi; if [ -x "$2" ]; then printf '%s' "$2"; return; fi; printf '%s' "$3"; }

OPT="$(pick "${TILE_OPT:-}"         /home/zwh/work/tilelang-toolchain/build/bin/tile-opt       tile-opt)"
TRANS="$(pick "${TILE_TRANSLATE:-}" /home/zwh/work/tilelang-toolchain/build/bin/tile-translate tile-translate)"
CCEC="$(pick "${CCEC:-}"            /home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec ccec)"
PY="${TILELANG_PYTHON:-/home/zwh/work/venv/bin/python}"
B="paged_decode_probe"

for t in "$OPT" "$TRANS" "$CCEC"; do
  is_exec "$t" || { echo "ERROR: 工具不可用: $t" >&2; exit 1; }
done

if [ "${SKIP_STAGE0:-0}" != 1 ]; then
  echo "== [0/5] DSL -> TileLang IR =="
  "$PY" "0_paged_decode.py" || { echo "FAIL stage0" >&2; exit 1; }
fi

echo "== [1/5] TileLangIR -> NPU IR =="
# producer 的 mlir-python-bindings(20260927) 只提供 linalg.elementwise <op> 新命名，
# toolchain 只认旧命名 linalg.<op>，与 reduce_api_kernels/build.sh 同款归一化
sed -E 's/linalg\.elementwise <([a-zA-Z_]+)>/linalg.\1/' \
  "1_${B}_tilelangir.mlir" > "1_${B}_tilelangir.norm.mlir" || exit 1
"$OPT" "1_${B}_tilelangir.norm.mlir" --convert-tilelang-to-npu --npu-normalize -o "2_${B}_npu.mlir" \
  || { echo "FAIL stage1 convert-tilelang-to-npu" >&2; exit 1; }

echo "== [2/5] NPU IR -> MIX 拆分 =="
"$OPT" "2_${B}_npu.mlir" --npu-split-dataflow --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline \
  -o "3_${B}_mix_npu.mlir" \
  || { echo "FAIL stage2 npu-split-dataflow" >&2; exit 1; }

echo "== [3/5] MIX NPU -> CCE =="
"$OPT" --cce-pipeline="target=dav-351x" "3_${B}_mix_npu.mlir" -o "4_${B}_cce.mlir" \
  || { echo "FAIL stage3 cce-pipeline" >&2; exit 1; }

echo "== [4/5] CCE -> LLVM .ll =="
"$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${B}_cce.mlir" -o "5_${B}.ll" \
  || { echo "FAIL stage4 cce-to-backend" >&2; exit 1; }

echo "== [5/5] ccec -> .o =="
"$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
  -cce-bitcode-is-aicore -c "5_${B}.ll" -o "6_${B}.o" \
  || { echo "FAIL stage5 ccec" >&2; exit 1; }

echo "OK: 6_${B}.o"

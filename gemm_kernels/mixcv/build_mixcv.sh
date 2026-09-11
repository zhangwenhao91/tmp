#!/usr/bin/env bash
# 编译前辈 mixCV 示例：M=16, K=128, N=128（标准 mix 流水线）
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

V="mixcv"

echo "== [$V] DSL -> TileLang IR =="
"$PY" "0_mixcv.py"

echo "== [$V] TileLang IR -> NPU IR =="
"$OPT" "1_${V}_tilelangir.mlir" --convert-tilelang-to-npu --npu-normalize -o "2_${V}_npu.mlir"

echo "== [$V] NPU IR -> MIX 拆分 =="
"$OPT" "2_${V}_npu.mlir" --npu-split-scope --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline -o "3_${V}_mix_npu.mlir"

echo "== [$V] MIX NPU -> CCE =="
"$OPT" --cce-pipeline="target=dav-351x" "3_${V}_mix_npu.mlir" -o "4_${V}_cce.mlir"

echo "== [$V] CCE -> LLVM .ll =="
"$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${V}_cce.mlir" -o "5_${V}.ll"

echo "== [$V] ccec -> .o =="
"$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
  -cce-bitcode-is-aicore -c -v "5_${V}.ll" -o "6_${V}.o"
echo "OK: 6_${V}.o"

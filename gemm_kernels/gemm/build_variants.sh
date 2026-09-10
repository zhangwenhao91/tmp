#!/usr/bin/env bash
# 编译二分变体 v1 / v2：DSL -> TileLangIR -> NPU -> MIX NPU -> CCE -> LLVM -> .o
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

build_one() {
  local V=$1   # v1 / v2
  echo "== [$V] DSL -> TileLang IR =="
  "$PY" "0_gemm_${V}.py"

  echo "== [$V] TileLang IR -> NPU IR =="
  "$OPT" "1_gemm_${V}_tilelangir.mlir" --convert-tilelang-to-npu --npu-normalize -o "2_gemm_${V}_npu.mlir"

  echo "== [$V] NPU IR -> MIX 拆分 =="
  "$OPT" "2_gemm_${V}_npu.mlir" --npu-split-scope --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline -o "3_gemm_${V}_mix_npu.mlir"

  echo "== [$V] MIX NPU -> CCE =="
  "$OPT" --cce-pipeline="target=dav-351x" "3_gemm_${V}_mix_npu.mlir" -o "4_gemm_${V}_cce.mlir"

  echo "== [$V] CCE -> LLVM .ll =="
  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_gemm_${V}_cce.mlir" -o "5_gemm_${V}.ll"

  echo "== [$V] ccec -> .o =="
  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
    -cce-bitcode-is-aicore -c -v "5_gemm_${V}.ll" -o "6_gemm_${V}.o"
  echo "OK: 6_gemm_${V}.o"
}

build_one v1
build_one v2
echo "ALL DONE"

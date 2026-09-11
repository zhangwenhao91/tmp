#!/usr/bin/env bash
# 编译纯 AIC 版 GEMM（不拆 mix）：DSL -> TileLangIR -> NPU -> CCE -> LLVM -> .o
# 与 build_variants.sh 的唯一差异：第 3 步去掉 --npu-split-mix-kernel，
# 单函数保留 cube 计算 + 自身 FIX->UB->GM 搬运，产出单入口 .o（aic 形态）。
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

echo "== [1/5] DSL -> TileLang IR =="
"$PY" 0_gemm.py

echo "== [2/5] TileLang IR -> NPU IR =="
"$OPT" 1_gemm_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize -o 2_gemm_npu.mlir

echo "== [3/5] NPU IR -> 单函数（split-scope / plan-memory，无 mix 拆分、无 sync-pipeline）=="
"$OPT" 2_gemm_npu.mlir --npu-split-scope --npu-plan-memory -o 3_gemm_aiconly_npu.mlir

echo "== [4/5] NPU -> CCE -> LLVM .ll =="
"$OPT" --cce-pipeline="target=dav-351x" 3_gemm_aiconly_npu.mlir -o 4_gemm_aiconly_cce.mlir
"$TRANS" --cce-to-backend -allow-unregistered-dialect 4_gemm_aiconly_cce.mlir -o 5_gemm_aiconly.ll

echo "== [5/5] ccec -> .o（无 -cce-enable-mix）=="
"$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -O2 \
  -cce-bitcode-is-aicore -c -v 5_gemm_aiconly.ll -o 6_gemm_aiconly.o
echo "OK: 6_gemm_aiconly.o"

#!/usr/bin/env bash
# 构建修复版 GEMM sb：去掉 disableVectorCore1 guard，让两个 sub_block 都参与 UB→GM 搬运
# 根因：guardAivFunctionsToFirstVectorCore 把 AIV 体包在 if(subBlock==0)，
#       sub_block 0 只能访问半个 UB → 只搬一半数据。
# 修复：disable-vector-core1=false，不添加 guard
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

V="sb_fix"

echo "== [$V] DSL -> TileLang IR =="
"$PY" "0_gemm_sb.py"  # generates 1_gemm_sb_tilelangir.mlir
cp "1_gemm_sb_tilelangir.mlir" "1_gemm_${V}_tilelangir.mlir"

echo "== [$V] TileLang IR -> NPU IR =="
"$OPT" "1_gemm_${V}_tilelangir.mlir" --convert-tilelang-to-npu --npu-normalize -o "2_gemm_${V}_npu.mlir"

echo "== [$V] NPU IR -> MIX 拆分 =="
"$OPT" "2_gemm_${V}_npu.mlir" --npu-split-scope --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline -o "3_gemm_${V}_mix_npu.mlir"

echo "== [$V] MIX NPU -> CCE（disable-vector-core1=false）=="
# 不用 --cce-pipeline，改为独立 pass 序列（与 Pipeline.cpp buildCcePipeline 一致）
"$OPT" "3_gemm_${V}_mix_npu.mlir" \
  --convert-npu-to-cce="target=dav-351x disable-vector-core1=false" \
  --expand-strided-metadata \
  --cse --canonicalize \
  --cce-simt-scope-outline \
  --convert-scf-to-cf \
  --lower-affine \
  --cce-to-library-call \
  --convert-cce-to-cce-intr \
  --convert-math-to-llvm \
  --convert-func-memref-to-bare-ptr \
  --convert-arith-to-llvm \
  --convert-cf-to-llvm \
  --cce-reconcile-bare-ptr-descriptors \
  --reconcile-unrealized-casts \
  --canonicalize \
  -o "4_gemm_${V}_cce.mlir"

echo "== [$V] CCE -> LLVM .ll =="
"$TRANS" --cce-to-backend -allow-unregistered-dialect "4_gemm_${V}_cce.mlir" -o "5_gemm_${V}.ll"

echo "== [$V] ccec -> .o =="
"$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
  -cce-bitcode-is-aicore -c -v "5_gemm_${V}.ll" -o "6_gemm_${V}.o" 2>&1 | tail -1
echo "OK: 6_gemm_${V}.o"

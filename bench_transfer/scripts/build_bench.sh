#!/usr/bin/env bash
# bench_transfer 编译流水线：3 种搬运 kernel + baseline
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

M="${M:-64}"
K="${K:-256}"
N="${N:-16}"
REPEAT="${REPEAT:-64}"
DTYPE="${DTYPE:-bfloat16}"

echo "== generate stage1 (M=$M K=$K N=$N REPEAT=$REPEAT dtype=$DTYPE) =="
"$PY" 0_bench_transfer.py

fail=0
for v in ub2ub l12l1 l1ub baseline; do
  echo "== [$v] stage2: TileLangIR -> NPU =="
  "$OPT" "1_${v}_tilelangir.mlir" --convert-tilelang-to-npu --npu-normalize \
    -o "2_${v}_npu.mlir" || { echo "[FAIL-s2] $v"; fail=1; continue; }

  echo "== [$v] stage3: split-scope (契约验证) =="
  "$OPT" "2_${v}_npu.mlir" --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline -o "3_${v}_mix_npu.mlir" || {
    echo "[FAIL-s3] $v"; fail=1; continue; }

  echo "== [$v] stage4: NPU -> CCE =="
  "$OPT" --cce-pipeline="target=dav-351x" "3_${v}_mix_npu.mlir" -o "4_${v}_cce.mlir" || {
    echo "[FAIL-s4] $v"; fail=1; continue; }

  echo "== [$v] stage5: CCE -> LLVM .ll =="
  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${v}_cce.mlir" -o "5_${v}.ll" || {
    echo "[FAIL-s5] $v"; fail=1; continue; }

  # mix 拆分检测：stage3 含 part_of_mix 则用 mix 参数，否则纯 AIC/AIV
  if grep -q "part_of_mix" "3_${v}_mix_npu.mlir"; then
    MIXFLAG="-cce-enable-mix"
    echo "== [$v] mix kernel detected =="
  else
    MIXFLAG=""
  fi

  echo "== [$v] stage6: ccec -> .o =="
  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only $MIXFLAG -O2 \
    -cce-bitcode-is-aicore -c -v "5_${v}.ll" -o "6_${v}.o" || {
    echo "[FAIL-s6] $v"; fail=1; continue; }
  echo "[OK] $v -> 6_${v}.o"
done

ls -la 6_*.o 2>/dev/null || true
exit $fail

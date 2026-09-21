#!/usr/bin/env bash
# Build ub_scalar (UB -> scalar -> UB) variant for differential benchmarking.
# Mirrors build_all_bench.sh stage1-6 pipeline but only builds ub_scalar specs.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/cann-9.2.0-beta.2/bin/ccec"

K=256
REPEATS="16 128"

fail=0
total=0

build_one() { # $1=M $2=dtype $3=REPEAT
  local M="$1" dt="$2" R="$3"
  local tag="ub_scalar_${dt}_${M}x${K}_r${R}"
  total=$((total+1))
  echo "===== [$tag] ====="

  "$PY" 0_bench_transfer.py ub_scalar "$M" "$K" 16 "$R" "$dt" >/dev/null 2>&1 || {
    echo "[FAIL-s1] $tag"; fail=$((fail+1)); return; }

  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "2_${tag}_npu.mlir" 2>/tmp/ubsc_s2.err || { echo "[FAIL-s2] $tag"; cat /tmp/ubsc_s2.err | head -3; fail=$((fail+1)); return; }
  grep -qE '(^| )error' /tmp/ubsc_s2.err && { echo "[DIAG-ERR-s2] $tag"; head -3 /tmp/ubsc_s2.err; fail=$((fail+1)); return; }

  "$OPT" "2_${tag}_npu.mlir" --npu-expand-ub-to-l1-nd2nz --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline -o "3_${tag}_mix_npu.mlir" 2>/tmp/ubsc_s3.err || {
    echo "[FAIL-s3] $tag"; head -3 /tmp/ubsc_s3.err; fail=$((fail+1)); return; }
  grep -qE '(^| )error' /tmp/ubsc_s3.err && { echo "[DIAG-ERR-s3] $tag"; head -3 /tmp/ubsc_s3.err; fail=$((fail+1)); return; }

  "$OPT" --cce-pipeline="target=dav-351x" "3_${tag}_mix_npu.mlir" -o "4_${tag}_cce.mlir" 2>/tmp/ubsc_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/ubsc_s4.err; fail=$((fail+1)); return; }
  grep -qE '(^| )error' /tmp/ubsc_s4.err && { echo "[DIAG-ERR-s4] $tag"; head -3 /tmp/ubsc_s4.err; fail=$((fail+1)); return; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${tag}_cce.mlir" -o "5_${tag}.ll" 2>/tmp/ubsc_s5.err || {
    echo "[FAIL-s5] $tag"; fail=$((fail+1)); return; }

  local MIXFLAG=""
  grep -q "part_of_mix" "3_${tag}_mix_npu.mlir" && MIXFLAG="-cce-enable-mix"
  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only $MIXFLAG -O2 \
    -cce-bitcode-is-aicore -c "5_${tag}.ll" -o "6_${tag}.o" 2>/tmp/ubsc_s6.err || {
    echo "[FAIL-s6] $tag"; head -3 /tmp/ubsc_s6.err; fail=$((fail+1)); return; }
  echo "[OK] 6_${tag}.o ($(stat -c%s 6_${tag}.o) bytes)"
}

for dt in bfloat16 float32; do
  if [ "$dt" = "bfloat16" ]; then MS="16 64 128"; else MS="16 64"; fi
  for M in $MS; do
    for R in $REPEATS; do
      build_one "$M" "$dt" "$R"
    done
  done
done

echo "=============================="
echo "total=$total fail=$fail"
ls -la 6_ub_scalar_* 2>/dev/null
exit $fail

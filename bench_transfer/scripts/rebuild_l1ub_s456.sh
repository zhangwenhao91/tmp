#!/usr/bin/env bash
# 重编 l1ub 全部规格：从已重构的 3_*_mix_npu.mlir 跑 stage4/5/6，并验证结构。
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

echo "== structure check =="
bad=0
for f in 3_l1ub_*_mix_npu.mlir; do
  n8=$(grep -c "flag = 8" "$f" || true)
  nv=$(grep -c "linear_transfer, tcore_type = #npu.tcore_type<VECTOR>" "$f" || true)
  echo "$f : old_flag8=$n8 aiv_linear_copy=$nv"
  if [ "$n8" != "0" ] || [ "$nv" -lt 4 ]; then bad=$((bad+1)); fi
done
if [ "$bad" -gt 0 ]; then echo "STRUCTURE CHECK FAILED ($bad files)"; exit 1; fi

fail=0
for f in 3_l1ub_*_mix_npu.mlir; do
  tag="${f#3_}"; tag="${tag%_mix_npu.mlir}"
  echo "===== [$tag] ====="
  "$OPT" --cce-pipeline="target=dav-351x" "$f" -o "4_${tag}_cce.mlir" 2>/tmp/bench_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/bench_s4.err; fail=$((fail+1)); continue; }
  grep -qE '(^| )error' /tmp/bench_s4.err && { echo "[DIAG-ERR-s4] $tag"; head -3 /tmp/bench_s4.err; fail=$((fail+1)); continue; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${tag}_cce.mlir" -o "5_${tag}.ll" 2>/tmp/bench_s5.err || {
    echo "[FAIL-s5] $tag"; head -3 /tmp/bench_s5.err; fail=$((fail+1)); continue; }

  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
    -cce-bitcode-is-aicore -c "5_${tag}.ll" -o "6_${tag}.o" 2>/tmp/bench_s6.err || {
    echo "[FAIL-s6] $tag"; head -3 /tmp/bench_s6.err; fail=$((fail+1)); continue; }
  echo "[OK] 6_${tag}.o ($(stat -c%s "6_${tag}.o") bytes)"
done

echo "== ll check: MOV.L1.TO.UB must live in AIV func only =="
for ll in 5_l1ub_*.ll; do
  aic_end=$(grep -n '^define dso_local ptc_kernel void @l1ub_kernel_mix_aiv' "$ll" | head -1 | cut -d: -f1)
  if [ -z "$aic_end" ]; then echo "$ll : AIV func not found"; fail=$((fail+1)); continue; fi
  n_before=$(head -n "$((aic_end-1))" "$ll" | grep -c "MOV.L1.TO.UB" || true)
  n_after=$(tail -n +"$aic_end" "$ll" | grep -c "MOV.L1.TO.UB" || true)
  echo "$ll : aic_side=$n_before aiv_side=$n_after"
  if [ "$n_before" != "0" ] || [ "$n_after" -lt 4 ]; then fail=$((fail+1)); fi
done

echo "=============================="
echo "fail=$fail"
exit $fail

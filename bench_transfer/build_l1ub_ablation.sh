#!/usr/bin/env bash
# l1ub 消融 A/B 编译（单核 AIC pipeline，与 build_l1ub_single.sh 完全一致）。
#
# 目的：隔离 0x7bc87 (ACL_ERROR_RT_AICORE_EXCEPTION) 首崩指令。
#   control  = 原版 l1ub（已知必崩，作基线对照）
#   l1ub_a   = 循环内仅 L1->UB（mov.l1.to.ub.v310），无 UB->L1、无 gemm
#   l1ub_b   = 循环内 L1->UB + UB->L1（mov.ub.to.l1.v310），无 gemm
#
# 消融判据（NPU 上 ablation_run.py 逐个 launch）：
#   A 崩 -> 根因在 L1->UB 本身；A 过 B 崩 -> 根因在 UB->L1；A、B 都过 ->
#   与 gemm 的交互（control 才崩）。
#
# 产物：new_env/n6_{l1ub_a,l1ub_b}_{dtype}_{M}x256_r{R}_single.o
# 两个变体的 prim_func 均命名为 l1ub_kernel（独立文件编译），kname/sed 无需区分。
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="$HOME/Ascend/cann-9.2.0-beta.2/x86_64-linux/bin/ccec"

NEWD="$HERE/new_env"
mkdir -p "$NEWD"

K=256
N=16
M=16
DT=bfloat16
REPEATS="16 128"
VARIANTS="l1ub_a l1ub_b"

fail=0
total=0

build_one() { # $1=variant $2=REPEAT
  local v="$1" R="$2"
  local tag="${v}_${DT}_${M}x${K}_r${R}"
  total=$((total+1))
  echo "===== [$tag single ablation] ====="

  "$PY" 0_bench_transfer.py "$v" "$M" "$K" "$N" "$R" "$DT" >/dev/null 2>&1 || {
    echo "[FAIL-s1] $tag"; fail=$((fail+1)); return; }

  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "$NEWD/n2_${tag}_npu.mlir" 2>/tmp/bla_s2.err || {
    echo "[FAIL-s2] $tag"; head -3 /tmp/bla_s2.err; fail=$((fail+1)); return; }

  "$OPT" "$NEWD/n2_${tag}_npu.mlir" --npu-plan-memory \
    -o "$NEWD/n3_${tag}_single_npu.mlir" 2>/tmp/bla_s3.err || {
    echo "[FAIL-s3] $tag"; head -3 /tmp/bla_s3.err; fail=$((fail+1)); return; }

  "$OPT" --cce-pipeline="target=dav-351x" "$NEWD/n3_${tag}_single_npu.mlir" \
    -o "$NEWD/n4_${tag}_single_cce.mlir" 2>/tmp/bla_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/bla_s4.err; fail=$((fail+1)); return; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "$NEWD/n4_${tag}_single_cce.mlir" \
    -o "$NEWD/n5_${tag}_single.ll" 2>/tmp/bla_s5.err || {
    echo "[FAIL-s5] $tag"; fail=$((fail+1)); return; }

  # fix 0x7bc78: 纯 cube .o 默认 .text Al=4 -> 加 align 256
  sed -i 's/^\(define dso_local ptc_kernel void @l1ub_kernel(.*)\) #0 {$/\1 align 256 #0 {/' \
    "$NEWD/n5_${tag}_single.ll"
  grep -q 'align 256' "$NEWD/n5_${tag}_single.ll" || {
    echo "[FAIL-s5p] $tag: align 256 not inserted"; fail=$((fail+1)); return; }

  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -O2 \
    -cce-bitcode-is-aicore -c "$NEWD/n5_${tag}_single.ll" \
    -o "$NEWD/n6_${tag}_single.o" 2>/tmp/bla_s6.err || {
    echo "[FAIL-s6] $tag"; head -3 /tmp/bla_s6.err; fail=$((fail+1)); return; }

  local al
  al=$(readelf -SW "$NEWD/n6_${tag}_single.o" | awk '$3==".text" {print $NF}')
  if [ "$al" != "256" ]; then
    echo "[FAIL-align] $tag .text Al=$al (expect 256)"; fail=$((fail+1)); return
  fi
  echo "[OK] n6_${tag}_single.o ($(stat -c%s "$NEWD/n6_${tag}_single.o") bytes, .text Al=256)"
}

for v in $VARIANTS; do
  for R in $REPEATS; do
    build_one "$v" "$R"
  done
done

echo "=============================="
echo "total=$total fail=$fail"
ls -la "$NEWD"/n6_l1ub_{a,b}_*_single.o 2>/dev/null
exit $fail
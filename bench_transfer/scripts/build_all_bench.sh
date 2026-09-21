#!/usr/bin/env bash
# 全量编译 bench_transfer 差分法组合：
#   variant x dtype x M x REPEAT -> 6_{variant}_{dtype}_{M}x{K}_r{REPEAT}.o
# l12l1 不编译（stage4 已证明 L1->L1 无 lowering 支持）。
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

K=256
N=16
REPEATS="16 128"

fail=0
total=0

build_one() { # $1=variant $2=M $3=dtype $4=REPEAT
  local v="$1" M="$2" dt="$3" R="$4"
  local tag="${v}_${dt}_${M}x${K}_r${R}"
  total=$((total+1))
  echo "===== [$tag] ====="

  "$PY" 0_bench_transfer.py "$v" "$M" "$K" "$N" "$R" "$dt" >/dev/null 2>&1 || {
    echo "[FAIL-s1] $tag"; fail=$((fail+1)); return; }

  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "2_${tag}_npu.mlir" 2>/tmp/bench_s2.err || { echo "[FAIL-s2] $tag"; cat /tmp/bench_s2.err | head -3; fail=$((fail+1)); return; }
  grep -qE '(^| )error' /tmp/bench_s2.err && { echo "[DIAG-ERR-s2] $tag"; head -3 /tmp/bench_s2.err; fail=$((fail+1)); return; }

  # "$OPT" "2_${tag}_npu.mlir" --npu-split-scope --npu-plan-memory \
  #   --npu-split-mix-kernel --npu-sync-pipeline -o "3_${tag}_mix_npu.mlir" 2>/tmp/bench_s3.err || {
  # fix 0x7bc87: expand UB->L1 ND copy into nd2nz_scatter (padded mem_unique
  # scratch in UB) + linear transfer; must run before --npu-split-scope.
  "$OPT" "2_${tag}_npu.mlir" --npu-expand-ub-to-l1-nd2nz --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline -o "3_${tag}_mix_npu.mlir" 2>/tmp/bench_s3.err || {
    echo "[FAIL-s3] $tag"; head -3 /tmp/bench_s3.err; fail=$((fail+1)); return; }
  grep -qE '(^| )error' /tmp/bench_s3.err && { echo "[DIAG-ERR-s3] $tag"; head -3 /tmp/bench_s3.err; fail=$((fail+1)); return; }

  "$OPT" --cce-pipeline="target=dav-351x" "3_${tag}_mix_npu.mlir" -o "4_${tag}_cce.mlir" 2>/tmp/bench_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/bench_s4.err; fail=$((fail+1)); return; }
  grep -qE '(^| )error' /tmp/bench_s4.err && { echo "[DIAG-ERR-s4] $tag"; head -3 /tmp/bench_s4.err; fail=$((fail+1)); return; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${tag}_cce.mlir" -o "5_${tag}.ll" 2>/tmp/bench_s5.err || {
    echo "[FAIL-s5] $tag"; fail=$((fail+1)); return; }

  local MIXFLAG=""
  grep -q "part_of_mix" "3_${tag}_mix_npu.mlir" && MIXFLAG="-cce-enable-mix"
  # AIV-only kernel 用 aiv 加载模式（由 bench 脚本按 tag 处理）
  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only $MIXFLAG -O2 \
    -cce-bitcode-is-aicore -c "5_${tag}.ll" -o "6_${tag}.o" 2>/tmp/bench_s6.err || {
    echo "[FAIL-s6] $tag"; head -3 /tmp/bench_s6.err; fail=$((fail+1)); return; }
  echo "[OK] 6_${tag}.o ($(stat -c%s 6_${tag}.o) bytes)"
}

# 规格矩阵：bf16 M=16/64/128，f32 M=16/64（UB 半区 128KB 上限：f32 (128,256)=128KB 超限）
for dt in bfloat16 float32; do
  if [ "$dt" = "bfloat16" ]; then MS="16 64 128"; else MS="16 64"; fi
  for M in $MS; do
    for v in ub2ub ub_scalar l1ub; do
      for R in $REPEATS; do
        build_one "$v" "$M" "$dt" "$R"
      done
    done
  done
done

echo "=============================="
echo "total=$total fail=$fail"
ls -la 6_ub2ub_* 6_l1ub_* 2>/dev/null
exit $fail

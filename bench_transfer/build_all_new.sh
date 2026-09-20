#!/usr/bin/env bash
# 新环境（官方 OpenTileAS ed2beb55 无补丁 + CANN 9.2.0-beta.2 ccec）全量重编译。
# 产物输出到 new_env/，前缀 n2_/n3_/n4_/n5_/n6_，与旧带补丁产物并存对比。
# 流程与旧 build_all_bench.sh 完全一致（pass 序列不变），仅换工具链。
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="/home/z30086261/tmp/bench_transfer"
NEWD="$HERE/new_env"
mkdir -p "$NEWD"
cd "$SRC"

PY="/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/cann-9.2.0-beta.2/bin/ccec"
export PYTHONPATH=/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend

K=256
N=16
REPEATS="16 128"

fail=0
total=0
ok_list=""
fail_list=""

build_one() { # $1=variant $2=M $3=dtype $4=REPEAT
  local v="$1" M="$2" dt="$3" R="$4"
  local tag="${v}_${dt}_${M}x${K}_r${R}"
  total=$((total+1))
  echo "===== [$tag] ====="

  # s1: DSL -> tilelangir（0_bench_transfer.py 固定输出 1_bench_tilelangir.mlir）
  "$PY" 0_bench_transfer.py "$v" "$M" "$K" "$N" "$R" "$dt" >/dev/null 2>&1 || {
    echo "[FAIL-s1] $tag"; fail=$((fail+1)); fail_list="$fail_list $tag(s1)"; return; }

  # s2: convert + normalize
  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "n2_tmp.mlir" 2>/tmp/new_s2.err || { echo "[FAIL-s2] $tag"; head -3 /tmp/new_s2.err; fail=$((fail+1)); fail_list="$fail_list $tag(s2)"; return; }
  grep -qE '(^| )error' /tmp/new_s2.err && { echo "[DIAG-ERR-s2] $tag"; head -3 /tmp/new_s2.err; fail=$((fail+1)); fail_list="$fail_list $tag(s2e)"; return; }
  mv n2_tmp.mlir "$NEWD/n2_${tag}_npu.mlir"

  # s3: expand-nd2nz + split-scope + plan-memory + split-mix + sync-pipeline
  "$OPT" "$NEWD/n2_${tag}_npu.mlir" --npu-expand-ub-to-l1-nd2nz --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline -o "n3_tmp.mlir" 2>/tmp/new_s3.err || {
    echo "[FAIL-s3] $tag"; head -3 /tmp/new_s3.err; fail=$((fail+1)); fail_list="$fail_list $tag(s3)"; return; }
  grep -qE '(^| )error' /tmp/new_s3.err && { echo "[DIAG-ERR-s3] $tag"; head -3 /tmp/new_s3.err; fail=$((fail+1)); fail_list="$fail_list $tag(s3e)"; return; }
  mv n3_tmp.mlir "$NEWD/n3_${tag}_mix_npu.mlir"

  # s4: cce-pipeline
  "$OPT" --cce-pipeline="target=dav-351x" "$NEWD/n3_${tag}_mix_npu.mlir" -o "n4_tmp.mlir" 2>/tmp/new_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/new_s4.err; fail=$((fail+1)); fail_list="$fail_list $tag(s4)"; return; }
  grep -qE '(^| )error' /tmp/new_s4.err && { echo "[DIAG-ERR-s4] $tag"; head -3 /tmp/new_s4.err; fail=$((fail+1)); fail_list="$fail_list $tag(s4e)"; return; }
  mv n4_tmp.mlir "$NEWD/n4_${tag}_cce.mlir"

  # s5: translate -> .ll
  "$TRANS" --cce-to-backend -allow-unregistered-dialect "$NEWD/n4_${tag}_cce.mlir" \
    -o "$NEWD/n5_${tag}.ll" 2>/tmp/new_s5.err || { echo "[FAIL-s5] $tag"; head -3 /tmp/new_s5.err; fail=$((fail+1)); fail_list="$fail_list $tag(s5)"; return; }

  # s6: ccec（arch/flag 与旧脚本一致：cube + mix 按需）
  local MIXFLAG=""
  grep -q "part_of_mix" "$NEWD/n3_${tag}_mix_npu.mlir" && MIXFLAG="-cce-enable-mix"
  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only $MIXFLAG -O2 \
    -cce-bitcode-is-aicore -c "$NEWD/n5_${tag}.ll" -o "$NEWD/n6_${tag}.o" 2>/tmp/new_s6.err || {
    echo "[FAIL-s6] $tag"; head -3 /tmp/new_s6.err; fail=$((fail+1)); fail_list="$fail_list $tag(s6)"; return; }
  echo "[OK] n6_${tag}.o ($(stat -c%s "$NEWD/n6_${tag}.o") bytes)${MIXFLAG:+ [mix]}"
  ok_list="$ok_list $tag"
}

# 规格矩阵（与旧版一致）：bf16 M=16/64/128，f32 M=16/64
for dt in bfloat16 float32; do
  if [ "$dt" = "bfloat16" ]; then MS="16 64 128"; else MS="16 64"; fi
  for M in $MS; do
    for v in ub2ub l1ub; do
      for R in $REPEATS; do
        build_one "$v" "$M" "$dt" "$R"
      done
    done
  done
done

echo "=============================="
echo "total=$total fail=$fail"
echo "OK:$ok_list"
echo "FAIL:$fail_list"

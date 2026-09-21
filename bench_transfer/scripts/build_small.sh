#!/usr/bin/env bash
# 小尺寸搬运 kernel 批量编译：ub2ub（UB->vector reg->UB）与 ub_scalar（UB->scalar->UB）。
# 与本仓 build_all_new.sh 相同的 6 级 pipeline（官方 OpenTileAS ed2beb55 + CANN 9.2.0-beta.2），
# 只测纯 AIV 两条路径（无需 gemm，无 L1/契约约束）。
# 产物输出到 new_env/small/，前缀 n2_/n3_/n4_/n5_/n6_，tag = {variant}_{dtype}_{M}x{K}_r{R}。
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE"
SMALLD="$HERE/new_env/small"
mkdir -p "$SMALLD"

PY="/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/cann-9.2.0-beta.2/bin/ccec"
export PYTHONPATH=/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend

# 小尺寸矩阵（M x K）：从 1x8 一路到 16x64，衔接已有 16x256 数据。
# 也可用环境变量覆盖：SMALL_SHAPES="1x8 8x8 16x32" SMALL_DTYPES="bfloat16"
SHAPES="${SMALL_SHAPES:-1x8 2x8 4x8 8x8 8x16 16x16 16x32 16x64}"
DTYPES="${SMALL_DTYPES:-bfloat16 float32}"
REPEATS="${REPEATS:-16 128}"
VARIANTS="ub2ub ub_scalar"
N="${N:-16}"

fail=0
total=0
ok_list=""
fail_list=""

build_one() { # $1=variant $2=M $3=K $4=dtype $5=REPEAT
  local v="$1" M="$2" K="$3" dt="$4" R="$5"
  local tag="${v}_${dt}_${M}x${K}_r${R}"
  total=$((total+1))

  # s1: DSL -> tilelangir（固定输出 1_bench_tilelangir.mlir）
  "$PY" 0_bench_transfer.py "$v" "$M" "$K" "$N" "$R" "$dt" >/dev/null 2>&1 || {
    echo "[FAIL-s1] $tag"; fail=$((fail+1)); fail_list="$fail_list $tag(s1)"; return; }

  # s2: convert + normalize
  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "$SMALLD/n2_${tag}_npu.mlir" 2>"$SMALLD/n2_${tag}.err" || {
    echo "[FAIL-s2] $tag"; head -3 "$SMALLD/n2_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s2)"; return; }
  grep -qE '(^| )error' "$SMALLD/n2_${tag}.err" && {
    echo "[DIAG-ERR-s2] $tag"; head -3 "$SMALLD/n2_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s2e)"; return; }

  # s3: expand + split-scope + plan-memory + split-mix + sync-pipeline
  "$OPT" "$SMALLD/n2_${tag}_npu.mlir" --npu-expand-ub-to-l1-nd2nz --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline -o "$SMALLD/n3_${tag}_mix_npu.mlir" 2>"$SMALLD/n3_${tag}.err" || {
    echo "[FAIL-s3] $tag"; head -3 "$SMALLD/n3_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s3)"; return; }
  grep -qE '(^| )error' "$SMALLD/n3_${tag}.err" && {
    echo "[DIAG-ERR-s3] $tag"; head -3 "$SMALLD/n3_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s3e)"; return; }

  # s4: cce-pipeline
  "$OPT" --cce-pipeline="target=dav-351x" "$SMALLD/n3_${tag}_mix_npu.mlir" \
    -o "$SMALLD/n4_${tag}_cce.mlir" 2>"$SMALLD/n4_${tag}.err" || {
    echo "[FAIL-s4] $tag"; head -3 "$SMALLD/n4_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s4)"; return; }
  grep -qE '(^| )error' "$SMALLD/n4_${tag}.err" && {
    echo "[DIAG-ERR-s4] $tag"; head -3 "$SMALLD/n4_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s4e)"; return; }

  # s5: translate -> .ll
  "$TRANS" --cce-to-backend -allow-unregistered-dialect "$SMALLD/n4_${tag}_cce.mlir" \
    -o "$SMALLD/n5_${tag}.ll" 2>"$SMALLD/n5_${tag}.err" || {
    echo "[FAIL-s5] $tag"; head -3 "$SMALLD/n5_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s5)"; return; }

  # s6: ccec（AIV 路径无 mix，默认不传 -cce-enable-mix）
  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -O2 \
    -cce-bitcode-is-aicore -c "$SMALLD/n5_${tag}.ll" -o "$SMALLD/n6_${tag}.o" 2>"$SMALLD/n6_${tag}.err" || {
    echo "[FAIL-s6] $tag"; head -3 "$SMALLD/n6_${tag}.err"; fail=$((fail+1)); fail_list="$fail_list $tag(s6)"; return; }
  echo "[OK] n6_${tag}.o ($(stat -c%s "$SMALLD/n6_${tag}.o") bytes)"
  ok_list="$ok_list $tag"
}

for v in $VARIANTS; do
  for dt in $DTYPES; do
    for shape in $SHAPES; do
      M="${shape%x*}"; K="${shape#*x}"
      for R in $REPEATS; do
        build_one "$v" "$M" "$K" "$dt" "$R"
      done
    done
  done
done

echo "=============================="
echo "total=$total fail=$fail"
echo "OK:$ok_list"
echo "FAIL:$fail_list"
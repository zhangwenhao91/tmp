#!/usr/bin/env bash
# 重编全部 ub2ub 规格（对齐证明修复后）：从 3_ub2ub_*_mix_npu.mlir 跑 stage4/5/6。
# 修复：hasKnownAlignedMemrefBase 补 memref::ViewOp 分支后，稠密 UB->UB copy
#       应从 Point 逐元素回退变为 fullVectorChunks 全向量循环。
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"

fail=0
for f in 3_ub2ub_*_r[0-9]*_mix_npu.mlir; do
  tag="${f#3_}"; tag="${tag%_mix_npu.mlir}"
  echo "===== [$tag] ====="
  "$OPT" --cce-pipeline="target=dav-351x" "$f" -o "4_${tag}_cce.mlir" 2>/tmp/bench_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/bench_s4.err; fail=$((fail+1)); continue; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${tag}_cce.mlir" -o "5_${tag}.ll" 2>/tmp/bench_s5.err || {
    echo "[FAIL-s5] $tag"; head -3 /tmp/bench_s5.err; fail=$((fail+1)); continue; }

  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -O2 \
    -cce-bitcode-is-aicore -c "5_${tag}.ll" -o "6_${tag}.o" 2>/tmp/bench_s6.err || {
    echo "[FAIL-s6] $tag"; head -3 /tmp/bench_s6.err; fail=$((fail+1)); continue; }
  echo "[OK] 6_${tag}.o ($(stat -c%s "6_${tag}.o") bytes)"
done

echo "== ll check: 不应再有逐元素 Point 循环（pset pattern 2 + i*N 步进）=="
for ll in 5_ub2ub_*.ll; do
  # 逐元素 Point 特征：vld 的 norm 是 broadcast mode 且 store 带 pset pattern2
  n_point=$(grep -c "pset.b16(i32 2)\|pset.b32(i32 2)" "$ll" || true)
  echo "$ll : point_loop_mask=$n_point"
  if [ "$n_point" != "0" ]; then fail=$((fail+1)); fi
done

echo "=============================="
echo "fail=$fail"
exit $fail

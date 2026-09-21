#!/usr/bin/env bash
# 架构探测：真机 SOC = Ascend950（短版本），本工具链假定 dav-351x/dav-c310-cube，
# 但所有 cube 内核执行必 0x7bc87（AICORE_EXCEPTION），vector(aiv) 正常。
# 假设：Ascend950 的 cube 核可能是 c310-simt/simd 或 c220/m300/dav-c100 编码，
# dav-c310-cube 编码不被接受 -> 首条 cube 指令即异常。
#
# 做法：同一单个 baseline（GM->L1 + L1 常驻 gemm，零 L1<->UB）按
# (cce-pipeline target, ccec -cce-aicore-arch) 矩阵各编一份 .o，
# NPU 上用 arch_probe_run.py 逐个 load+launch+sync，PASS 的组合即正确架构。
# 每个组合共用 s1-s3（arch 无关），只重跑 cce-pipeline / translate / ccec。
#
# 产物：new_env/arch_probe/probe_<tag>.o（tag = opt_target_ccec_arch）
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$HERE"

PY="$HOME/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="$HOME/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="$HOME/Ascend/cann-9.2.0-beta.2/x86_64-linux/bin/ccec"

OUT="$HERE/new_env/arch_probe"
mkdir -p "$OUT"

K=256; N=16; M=16; DT=bfloat16; R=16

# (opt_target, ccec_arch)
MATRIX="
dav-351x|dav-c310-cube
Ascend950DT_9596|dav-c310-cube
Ascend950DT_9595|dav-c310-cube
Ascend950DT_95A1|dav-c310-cube
Ascend950DT_95A2|dav-c310-cube
Ascend950PR_959b|dav-c310-cube
Ascend950PR_959a|dav-c310-cube
Ascend910_9599|dav-c310-cube
Ascend910B4|dav-c310-cube
Ascend950PR_959b|dav-c310
Ascend950PR_959b|dav-c220-cube
Ascend950PR_959b|dav-c100
"

# s1: DSL -> tilelangir（与小尺寸共用 0_bench_transfer.py baseline）
tag_base="baseline_${DT}_${M}x${K}_r${R}"
if [ ! -s "$OUT/np2_${tag_base}_npu.mlir" ]; then
  "$PY" 0_bench_transfer.py baseline "$M" "$K" "$N" "$R" "$DT" >/dev/null 2>&1 || { echo "[FAIL-s1]"; exit 1; }
  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "$OUT/np2_${tag_base}_npu.mlir" 2>/tmp/ap_s2.err || { echo "[FAIL-s2]"; exit 1; }
  "$OPT" "$OUT/np2_${tag_base}_npu.mlir" --npu-plan-memory \
    -o "$OUT/np3_${tag_base}_single_npu.mlir" 2>/tmp/ap_s3.err || { echo "[FAIL-s3]"; exit 1; }
fi

fail=0; total=0
while IFS='|' read -r tgt arch; do
  [ -n "$tgt" ] || continue
  total=$((total+1))
  tag="probe_${tgt}_${arch}"
  echo "===== [$tgt / $arch] ====="
  "$OPT" --cce-pipeline="target=$tgt" "$OUT/np3_${tag_base}_single_npu.mlir" \
    -o "$OUT/np4_${tag}_cce.mlir" 2>/tmp/ap_s4.err || {
      echo "[SKIP-s4] $tag: $(head -2 /tmp/ap_s4.err)"; fail=$((fail+1)); continue; }
  "$TRANS" --cce-to-backend -allow-unregistered-dialect "$OUT/np4_${tag}_cce.mlir" \
    -o "$OUT/np5_${tag}.ll" 2>/tmp/ap_s5.err || {
      echo "[SKIP-s5] $tag"; fail=$((fail+1)); continue; }
  sed -i 's/^\(define dso_local ptc_kernel void @.*(.*)\) #0 {$/\1 align 256 #0 {/' \
    "$OUT/np5_${tag}.ll"
  grep -q 'align 256' "$OUT/np5_${tag}.ll" || { echo "[SKIP-s5p] $tag no align256"; fail=$((fail+1)); continue; }
  "$CCEC" --cce-aicore-arch=$arch --cce-aicore-only -O2 \
    -cce-bitcode-is-aicore -c "$OUT/np5_${tag}.ll" \
    -o "$OUT/$tag.o" 2>/tmp/ap_s6.err || {
      echo "[SKIP-s6] $tag: $(head -2 /tmp/ap_s6.err)"; fail=$((fail+1)); continue; }
  echo "[OK] $OUT/$tag.o ($(stat -c%s "$OUT/$tag.o") bytes)"
done <<< "$MATRIX"

echo "=============================="
echo "total=$total fail=$fail"
ls -la "$OUT"/probe_*.o 2>/dev/null
exit 0
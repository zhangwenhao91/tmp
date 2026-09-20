#!/usr/bin/env bash
# l1ub_single: L1 -> UB -> L1 单核 AIC 版编译。
# 环境：官方 OpenTileAS ed2beb55（无补丁）+ CANN 9.2.0-beta.2。
#
# 与 mix 版（build_all_bench.sh）的关键差异——stage3 只跑 --npu-plan-memory：
#   - 不跑 --npu-split-scope：会给 op 打 crossCoreDeps，plan-memory 对 cbuf->ca 的
#     L1->L0A 装载 copy 报 "failed to recognize single-pipe op"
#   - 不跑 --npu-split-mix-kernel / --npu-sync-pipeline / --npu-split-dataflow：
#     不拆 AIC/AIV 双核，不插 INTRA.BLOCKI 跨核同步（单核无需跨核同步，
#     从根上绕开 mix 版 0x7bc87 设备错误）
#   - 不跑 --npu-expand-ub-to-l1-nd2nz：本 DSL 中 UB->L1 为线性 copy，由
#     cce-pipeline 直接 lower 为 MOV.UB.TO.L1 行循环；expand 反而引入
#     pset.b16 向量谓词循环（形态退化）
#   - stage6 ccec 不加 -cce-enable-mix；产物单入口 l1ub_kernel（AIC ELF）
#
# fix 0x7bc78（2026-09-20 NPU 机验证发现）：纯 AIC(cube) .o 的 .text 段对齐
# 默认为 4，rtFunctionRegister（RT_DEV_BINARY_MAGIC_ELF 路径）注册时报
# 507000（ACL_ERROR_RT_INTERNAL_ERROR）内部错误。修复：给 kernel 函数定义加
# align 256，使 ccec 输出 Al=256 的 .text（offset 0x100），与 mix / AIV .o
# （实测可注册）结构一致。
# 注：-falign-functions=256 对 ptc_kernel 函数无效，只能改 .ll。
#
# DSL 复用 0_bench_transfer.py 原版 l1ub（带 gemm 消费，5 ptr 签名），
# 单核化全部由编译流水线完成，不改 DSL。
#
# 产物：new_env/n6_l1ub_{dtype}_{M}x256_r{R}_single.o（5 规格 x r16/r128）
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
REPEATS="16 128"

fail=0
total=0

build_one() { # $1=M $2=dtype $3=REPEAT
  local M="$1" dt="$2" R="$3"
  local tag="l1ub_${dt}_${M}x${K}_r${R}"
  total=$((total+1))
  echo "===== [$tag single] ====="

  "$PY" 0_bench_transfer.py l1ub "$M" "$K" "$N" "$R" "$dt" >/dev/null 2>&1 || {
    echo "[FAIL-s1] $tag"; fail=$((fail+1)); return; }

  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "$NEWD/n2_${tag}_npu.mlir" 2>/tmp/bl1_s2.err || {
    echo "[FAIL-s2] $tag"; head -3 /tmp/bl1_s2.err; fail=$((fail+1)); return; }

  # 单核关键：stage3 仅 plan-memory，无任何 split/sync/expand pass
  "$OPT" "$NEWD/n2_${tag}_npu.mlir" --npu-plan-memory \
    -o "$NEWD/n3_${tag}_single_npu.mlir" 2>/tmp/bl1_s3.err || {
    echo "[FAIL-s3] $tag"; head -3 /tmp/bl1_s3.err; fail=$((fail+1)); return; }

  "$OPT" --cce-pipeline="target=dav-351x" "$NEWD/n3_${tag}_single_npu.mlir" \
    -o "$NEWD/n4_${tag}_single_cce.mlir" 2>/tmp/bl1_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/bl1_s4.err; fail=$((fail+1)); return; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "$NEWD/n4_${tag}_single_cce.mlir" \
    -o "$NEWD/n5_${tag}_single.ll" 2>/tmp/bl1_s5.err || {
    echo "[FAIL-s5] $tag"; fail=$((fail+1)); return; }

  # fix 0x7bc78: 纯 cube .o 默认 .text Al=4，AIC(ELF magic) 注册路径拒绝；
  # 给 kernel 函数加 align 256 -> ccec 输出 Al=256 的 .text
  sed -i 's/^\(define dso_local ptc_kernel void @l1ub_kernel(.*)\) #0 {$/\1 align 256 #0 {/' \
    "$NEWD/n5_${tag}_single.ll"
  grep -q 'align 256' "$NEWD/n5_${tag}_single.ll" || {
    echo "[FAIL-s5p] $tag: align 256 not inserted"; fail=$((fail+1)); return; }

  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -O2 \
    -cce-bitcode-is-aicore -c "$NEWD/n5_${tag}_single.ll" \
    -o "$NEWD/n6_${tag}_single.o" 2>/tmp/bl1_s6.err || {
    echo "[FAIL-s6] $tag"; head -3 /tmp/bl1_s6.err; fail=$((fail+1)); return; }

  # 对齐校验：必须是 256，否则注册会复现 0x7bc78
  local al
  al=$(readelf -SW "$NEWD/n6_${tag}_single.o" | awk '$3==".text" {print $NF}')
  if [ "$al" != "256" ]; then
    echo "[FAIL-align] $tag .text Al=$al (expect 256)"; fail=$((fail+1)); return
  fi
  echo "[OK] n6_${tag}_single.o ($(stat -c%s "$NEWD/n6_${tag}_single.o") bytes, .text Al=256)"
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
ls -la "$NEWD"/n6_l1ub_*_single.o 2>/dev/null
exit $fail

#!/usr/bin/env bash
# L1->UB->L1 消融-B 全量编译（l1ub_b：循环内仅 L1->UB + UB->L1 两跳，gemm 在循环外）。
# 工具链：OpenTileAS HEAD 49d9dfe9 + 补丁(0001/0003) + mad_l1 修复 + CANN 9.1.0 ccec。
# 流程与 build_all_bench.sh 完全一致（6 级 pipeline）。
set -uo pipefail

cd /home/z30086261/tmp/bench_transfer

PY=/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python
OPT=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt
TRANS=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec
LLVM_LINK=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/llvm-link
LDLD=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ld.lld
export PYTHONPATH=/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend

K=256
N=16
REPEATS="16 128"
VARIANTS="${VARIANTS:-l1ub_b}"

fail=0
total=0
ok_list=""
fail_list=""

build_one() { # $1=variant $2=M $3=dtype $4=REPEAT
  local v="$1" M="$2" dt="$3" R="$4"
  local tag="${v}_${dt}_${M}x${K}_r${R}"
  total=$((total+1))
  echo "===== [$tag] ====="

  "$PY" 0_bench_transfer.py "$v" "$M" "$K" "$N" "$R" "$dt" >/dev/null 2>&1 || {
    echo "[FAIL-s1] $tag"; fail=$((fail+1)); fail_list="$fail_list $tag(s1)"; return; }

  "$OPT" 1_bench_tilelangir.mlir --convert-tilelang-to-npu --npu-normalize \
    -o "2_${tag}_npu.mlir" 2>/tmp/bench_s2.err || {
    echo "[FAIL-s2] $tag"; head -3 /tmp/bench_s2.err; fail=$((fail+1)); fail_list="$fail_list $tag(s2)"; return; }
  grep -qE '(^| )error' /tmp/bench_s2.err && {
    echo "[DIAG-ERR-s2] $tag"; head -3 /tmp/bench_s2.err; fail=$((fail+1)); fail_list="$fail_list $tag(s2e)"; return; }

  "$OPT" "2_${tag}_npu.mlir" --npu-expand-ub-to-l1-nd2nz --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline -o "3_${tag}_mix_npu.mlir" 2>/tmp/bench_s3.err || {
    echo "[FAIL-s3] $tag"; head -3 /tmp/bench_s3.err; fail=$((fail+1)); fail_list="$fail_list $tag(s3)"; return; }
  grep -qE '(^| )error' /tmp/bench_s3.err && {
    echo "[DIAG-ERR-s3] $tag"; head -3 /tmp/bench_s3.err; fail=$((fail+1)); fail_list="$fail_list $tag(s3e)"; return; }

  "$OPT" --cce-pipeline="target=dav-351x" "3_${tag}_mix_npu.mlir" -o "4_${tag}_cce.mlir" 2>/tmp/bench_s4.err || {
    echo "[FAIL-s4] $tag"; head -3 /tmp/bench_s4.err; fail=$((fail+1)); fail_list="$fail_list $tag(s4)"; return; }
  grep -qE '(^| )error' /tmp/bench_s4.err && {
    echo "[DIAG-ERR-s4] $tag"; head -3 /tmp/bench_s4.err; fail=$((fail+1)); fail_list="$fail_list $tag(s4e)"; return; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${tag}_cce.mlir" -o "5_${tag}.ll" 2>/tmp/bench_s5.err || {
    echo "[FAIL-s5] $tag"; head -3 /tmp/bench_s5.err; fail=$((fail+1)); fail_list="$fail_list $tag(s5)"; return; }

  local MIXFLAG=""
  grep -q "part_of_mix" "3_${tag}_mix_npu.mlir" && MIXFLAG="-cce-enable-mix"

  # 官方 catlass 路线（opentileas.cpp runCatlassRoute，693/véry 对齐）：
  # cube/mix 内核经 gemm -> CCEToLibraryCall -> __cce_catlass_ -> 模板调用
  # _mlir_ciface_mma_tile_*（定义在 catlass_mma.*.c310.bc）且带 llvm.hivm.*
  # 重定位。若不合并模板 + 最终 ld.lld 链接，交付的 .o 保留悬空 .rela.text，
  # acl 加载器不解析 -> 首条 hivm/mma 跳转即 0x7bc87（此前全部 L1 内核崩因）。
  BLIB=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/lib
  CATASS=""
  grep -q "__cce_catlass_" "5_${tag}.ll" && CATASS=1
  if [ -n "$CATASS" ]; then
    local TPL="catlass_mma.aic.c310.bc"
    [ -n "$MIXFLAG" ] && TPL="catlass_mma.mix_aic.c310.bc"
    "$LLVM_LINK" --only-needed "5_${tag}.ll" "$BLIB/$TPL" -o "5_${tag}.cat.bc" 2>/tmp/bench_s6a.err || {
      echo "[FAIL-s6a] $tag"; head -3 /tmp/bench_s6a.err; fail=$((fail+1)); fail_list="$fail_list $tag(s6a)"; return; }
    "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only $MIXFLAG -O2 \
      -cce-bitcode-is-aicore -cce-link-aicore-ll-module "$BLIB/libdevice.bc" \
      -cce-link-aicore-ll-module "$BLIB/libdevice_simt.bc" \
      -cce-link-aicore-ll-module "$BLIB/print.bc" -mllvm --cce-vf-auto-sync=global \
      --cce-simd-vf-fusion=false -c "5_${tag}.cat.bc" -o "6_${tag}_ccec.o" 2>/tmp/bench_s6.err || {
      echo "[FAIL-s6] $tag"; head -3 /tmp/bench_s6.err; fail=$((fail+1)); fail_list="$fail_list $tag(s6)"; return; }
    if [ -n "$MIXFLAG" ]; then
      # MIX: relocatable link，重定位原地解析（官方注释：static 会被加载器拒绝）
      "$LDLD" -m aicorelinux -Ttext 0 -r -o "6_${tag}.o" "6_${tag}_ccec.o" 2>/tmp/bench_s7.err || {
        echo "[FAIL-s7] $tag"; head -3 /tmp/bench_s7.err; fail=$((fail+1)); fail_list="$fail_list $tag(s7)"; return; }
    else
      local ENTRY=$(grep -oE "@[a-zA-Z_][a-zA-Z0-9_]*\(" "5_${tag}.ll" | head -1 | tr -d '@(')
      [ -z "$ENTRY" ] && ENTRY="l1ub_kernel"
      "$LDLD" -m aicorelinux -Ttext=0 -static -e "$ENTRY" -o "6_${tag}.o" "6_${tag}_ccec.o" 2>/tmp/bench_s7.err || {
        echo "[FAIL-s7] $tag"; head -3 /tmp/bench_s7.err; fail=$((fail+1)); fail_list="$fail_list $tag(s7)"; return; }
    fi
    rm -f "6_${tag}_ccec.o"
  else
    # 纯 AIV：无模板/无重定位，原生 ccec（已验证可跑）
    "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only $MIXFLAG -O2 \
      -cce-bitcode-is-aicore -c "5_${tag}.ll" -o "6_${tag}.o" 2>/tmp/bench_s6.err || {
      echo "[FAIL-s6] $tag"; head -3 /tmp/bench_s6.err; fail=$((fail+1)); fail_list="$fail_list $tag(s6)"; return; }
  fi
  echo "[OK] 6_${tag}.o ($(stat -c%s "6_${tag}.o") bytes)${MIXFLAG:+ [mix]}${CATASS:+ [catlass-linked]}"
  ok_list="$ok_list $tag"
}

for dt in bfloat16 float32; do
  if [ "$dt" = "bfloat16" ]; then MS="16 64 128"; else MS="16 64"; fi
  for M in $MS; do
    for v in $VARIANTS; do
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
exit $fail
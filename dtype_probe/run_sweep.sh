#!/usr/bin/env bash
# 多 dtype 扫描：stage1->stage5，报告每个 (op,dtype) 的结果
set -uo pipefail
cd /home/zwh/work/tmp/dtype_probe || exit 1

OPT=/home/zwh/work/tilelang-toolchain/build/bin/tile-opt
TRANS=/home/zwh/work/tilelang-toolchain/build/bin/tile-translate
CCEC_DEF=/home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec
if [ -x "$CCEC_DEF" ]; then CCEC="$CCEC_DEF"; else CCEC="$(command -v ccec || true)"; fi

mkdir -p work
SUMMARY="summary.txt"
: > "$SUMMARY"
printf "%-24s %-8s %-8s %-8s %-8s %-8s\n" CASE s1 s2 s3 s4 s5 >> "$SUMMARY"

for f in stage0/1_*_tilelangir.mlir; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  name=${base#1_}
  name=${name%_tilelangir.mlir}
  w=work/$name
  mkdir -p "$w"

  sed -E 's/linalg\.elementwise <([a-zA-Z_]+)>/linalg.\1/' "$f" > "$w/1.norm.mlir"

  "$OPT" "$w/1.norm.mlir" --convert-tilelang-to-npu --npu-normalize -o "$w/2.mlir" >"$w/s1.log" 2>&1
  s1=$?
  if [ $s1 -ne 0 ]; then printf "%-24s %-8s\n" "$name" "FAIL" >> "$SUMMARY"; continue; fi

  "$OPT" "$w/2.mlir" --npu-split-dataflow --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline -o "$w/3.mlir" >"$w/s2.log" 2>&1
  s2=$?
  if [ $s2 -ne 0 ]; then printf "%-24s %-8s %-8s\n" "$name" ok "FAIL" >> "$SUMMARY"; continue; fi

  "$OPT" --cce-pipeline="target=dav-351x" "$w/3.mlir" -o "$w/4.mlir" >"$w/s3.log" 2>&1
  s3=$?
  if [ $s3 -ne 0 ]; then printf "%-24s %-8s %-8s %-8s\n" "$name" ok ok "FAIL" >> "$SUMMARY"; continue; fi

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "$w/4.mlir" -o "$w/5.ll" >"$w/s4.log" 2>&1
  s4=$?
  if [ $s4 -ne 0 ]; then printf "%-24s %-8s %-8s %-8s %-8s\n" "$name" ok ok ok "FAIL" >> "$SUMMARY"; continue; fi

  if [ -n "$CCEC" ] && [ -x "$CCEC" ]; then
    "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -c "$w/5.ll" -o "$w/6.o" >"$w/s5.log" 2>&1
    s5=$?
    if [ $s5 -eq 0 ]; then printf "%-24s %-8s %-8s %-8s %-8s %-8s\n" "$name" ok ok ok ok "PASS" >> "$SUMMARY";
    else printf "%-24s %-8s %-8s %-8s %-8s %-8s\n" "$name" ok ok ok ok "FAIL" >> "$SUMMARY"; fi
  else
    printf "%-24s %-8s %-8s %-8s %-8s %-8s\n" "$name" ok ok ok ok "no-ccec" >> "$SUMMARY"
  fi
done

echo "================ SUMMARY ================"
cat "$SUMMARY"
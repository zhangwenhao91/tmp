#!/usr/bin/env bash
# OpenTile reduce 端到端 —— NPU 侧：用预编译 .o 上机执行 + 精度比对
#
# 前置：
#   1. source CANN（9.3+）的 set_env.sh（使 libruntime/ascendcl 可加载，python3 带 numpy+torch）
#   2. export ASCEND_RT_VISIBLE_DEVICES=<可用卡>（4/5/6 之一）
#   3. 同目录 _work/<stem>/ 下已有本机产出的 <stem>.o（由 build_local.sh 生成并随包交付）
#
# 用法：
#   bash run_npu.sh                       # 跑全部 6 个 float 用例
#   bash run_npu.sh triton_min_dim1       # 只跑指定子集
#
# 输出：每例一行进度 [i/n 时间] <stem> PASS|FAIL|ERROR；仅失败时附详细日志。
set -uo pipefail

PKG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$PKG/_work"
KR="$PKG/kernel_runner"
LOGS="$PKG/_npu_logs"
PY="${PYTHON:-python3}"
mkdir -p "$LOGS"

echo "== env =="
echo "  PKG=$PKG"
echo "  PY=$PY -> $(command -v "$PY" 2>/dev/null || echo MISSING)"
echo "  ASCEND_HOME_PATH=${ASCEND_HOME_PATH:-<未设置>}"
echo "  ASCEND_RT_VISIBLE_DEVICES=${ASCEND_RT_VISIBLE_DEVICES:-<未设置>}"

# --- 0) 环境自检 ---
"$PY" -c 'import numpy, torch' 2>/dev/null || { echo "error: $PY 缺少 numpy/torch（先 source CANN，或用 PYTHON= 指定）"; exit 2; }
command -v ccec >/dev/null 2>&1 || echo "warn: PATH 上没有 ccec（本脚本不编译，仅运行）"

# --- 1) 编译 kernel_runner 扩展（仅首次）---
if ! ls "$KR"/kernel_runner/_ascend_runtime*.so >/dev/null 2>&1; then
  echo "== 编译 kernel_runner 扩展 =="
  ( cd "$KR" && "$PY" setup.py build_ext --inplace ) || { echo "error: kernel_runner 扩展编译失败"; exit 2; }
fi
export PYTHONPATH="$KR${PYTHONPATH:+:$PYTHONPATH}"

# --- 2) 用例表 stem:atol:rtol ---
ALL_CASES=(
  "triton_min_dim1:0:0"
  "triton_max_dim0:0:0"
  "triton_sum_dim1:0.02:0.02"
  "triton_sum_dim0:0.5:0.01"
  "triton_mean_dim1:0.002:0.01"
  "triton_mean_dim0:0.01:0.01"
)
declare -A ATOL RTOL
for spec in "${ALL_CASES[@]}"; do
  IFS=: read -r stem a r <<< "$spec"; ATOL[$stem]="$a"; RTOL[$stem]="$r"
done

if [ $# -gt 0 ]; then
  SELECTED=("$@")
else
  SELECTED=(); for spec in "${ALL_CASES[@]}"; do IFS=: read -r s _ _ <<< "$spec"; SELECTED+=("$s"); done
fi

n=${#SELECTED[@]}; i=0; pass=0; fail=0; failed=()
for stem in "${SELECTED[@]}"; do
  i=$((i+1))
  d="$WORK/$stem"
  log="$LOGS/$stem.log"
  if [ ! -f "$d/$stem.o" ]; then
    printf '[%d/%d %s] %-16s ERROR (缺 %s.o)\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "$stem"
    fail=$((fail+1)); failed+=("$stem"); continue
  fi
  ( cd "$d" && "$PY" -m kernel_runner "$stem.opentile.json" --kernel-o "$stem.o" ) > "$log" 2>&1
  rc=$?
  if [ $rc -ne 0 ] || [ ! -f "$d/out.npy" ] || [ ! -f "$d/golden.npy" ]; then
    printf '[%d/%d %s] %-16s ERROR (run rc=%s)\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "$rc"
    grep -iE 'error|Traceback|failed|abort|assert' "$log" | tail -5 | sed 's/^/      | /'
    fail=$((fail+1)); failed+=("$stem"); continue
  fi
  res="$("$PY" "$PKG/check.py" "$d/out.npy" "$d/golden.npy" --atol "${ATOL[$stem]}" --rtol "${RTOL[$stem]}" 2>&1)"
  crc=$?
  if [ $crc -eq 0 ]; then
    printf '[%d/%d %s] %-16s PASS  %s\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "$(printf '%s' "$res" | tr '\n' ' ' | sed 's/  */ /g')"
    pass=$((pass+1))
  else
    printf '[%d/%d %s] %-16s FAIL  %s\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "$(printf '%s' "$res" | tr '\n' ' ' | sed 's/  */ /g')"
    fail=$((fail+1)); failed+=("$stem")
  fi
done

echo "============================================"
echo "SUMMARY: $pass PASS / $fail FAIL / $n TOTAL"
[ $fail -eq 0 ] || { printf 'failed: %s\n' "${failed[*]}"; exit 1; }
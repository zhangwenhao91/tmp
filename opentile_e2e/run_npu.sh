#!/usr/bin/env bash
# OpenTile reduce 端到端 —— NPU 侧：用预编译 .o 上机执行 + 精度比对
#
# 前置：
#   1. source CANN（9.3+）的 set_env.sh（使 libruntime/ascendcl 可加载，python3 带 numpy+torch）
#   2. export ASCEND_RT_VISIBLE_DEVICES=<可用卡>（4/5/6 之一）
#   3. 同目录 _work/<stem>/ 下已有本机产出的 <stem>.o（由 build_local.sh 生成并随包交付）
#
# 用例清单来自 <PKG>/_e2e_cases.txt（build_local.sh 产出）：
#   stem:atol:rtol:group      group = base|f16|f32|i8|i16|i32
#
# 用法：
#   bash run_npu.sh                # 非 i8 批次（base/f16/f32/i16/i32）——推荐先跑
#   bash run_npu.sh --i8           # 仅 i8 批次（单独分批，避免与其它 dtype 混跑）
#   bash run_npu.sh --all          # 全部用例
#   bash run_npu.sh --list         # 只列出将要执行的用例，不运行
#   bash run_npu.sh <stem> ...     # 指定子集
#
# 环境变量：
#   STOP_ON_FAIL=1   首个失败即停（默认 0，跑完全部再汇总）
#   PYTHON=<python>  指定解释器（默认 python3）
#
# 输出：每例一行进度 [i/n 时间] <stem> PASS|FAIL|ERROR；仅失败时附详细日志。
set -uo pipefail

PKG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$PKG/_work"
KR="$PKG/kernel_runner"
LOGS="$PKG/_npu_logs"
MANIFEST="$PKG/_e2e_cases.txt"
GAPS="$PKG/_build_gaps.txt"
PY="${PYTHON:-python3}"
STOP_ON_FAIL="${STOP_ON_FAIL:-0}"
mkdir -p "$LOGS"

echo "== env =="
echo "  PKG=$PKG"
echo "  PY=$PY -> $(command -v "$PY" 2>/dev/null || echo MISSING)"
echo "  ASCEND_HOME_PATH=${ASCEND_HOME_PATH:-<未设置>}"
echo "  ASCEND_RT_VISIBLE_DEVICES=${ASCEND_RT_VISIBLE_DEVICES:-<未设置>}"

# --- 0) 环境自检 ---
"$PY" -c 'import numpy, torch' 2>/dev/null || { echo "error: $PY 缺少 numpy/torch（先 source CANN，或用 PYTHON= 指定）"; exit 2; }
command -v ccec >/dev/null 2>&1 || echo "warn: PATH 上没有 ccec（本脚本不编译，仅运行）"

# --- 1) 读用例清单 ---
if [ ! -f "$MANIFEST" ]; then
  echo "error: 缺少 $MANIFEST（先在本机跑 build_local.sh 生成并随包交付）"; exit 2
fi
declare -A ATOL RTOL GROUP
ORDER=()
while IFS=: read -r stem a r g; do
  [ -n "$stem" ] || continue
  ATOL[$stem]="$a"; RTOL[$stem]="$r"; GROUP[$stem]="${g:-other}"; ORDER+=("$stem")
done < "$MANIFEST"
[ ${#ORDER[@]} -gt 0 ] || { echo "error: $MANIFEST 为空"; exit 2; }

# --- 2) 选择批次 ---
MODE="safe"; SEL=(); LIST_ONLY=0
for a in "$@"; do
  case "$a" in
    --all)  MODE="all" ;;
    --i8)   MODE="i8" ;;
    --safe) MODE="safe" ;;
    --list) LIST_ONLY=1 ;;
    --*)    echo "error: 未知选项 $a"; exit 2 ;;
    *)      SEL+=("$a") ;;
  esac
done

if [ ${#SEL[@]} -gt 0 ]; then
  SELECTED=("${SEL[@]}")
else
  SELECTED=()
  for stem in "${ORDER[@]}"; do
    case "$MODE" in
      all)  SELECTED+=("$stem") ;;
      i8)   if [ "${GROUP[$stem]}" = "i8" ]; then SELECTED+=("$stem"); fi ;;
      safe) if [ "${GROUP[$stem]}" != "i8" ]; then SELECTED+=("$stem"); fi ;;
    esac
  done
fi
n=${#SELECTED[@]}
[ "$n" -gt 0 ] || { echo "error: 该批次无可执行用例（mode=$MODE）"; exit 2; }

echo "== batch=$MODE  用例数=$n =="
if [ -f "$GAPS" ] && [ -s "$GAPS" ]; then
  echo "  本次未纳入的非 i8 缺口（本机编译失败，见 _build_gaps.txt）："
  sed 's/^/    - /' "$GAPS"
fi
if [ "$LIST_ONLY" -eq 1 ]; then
  for stem in "${SELECTED[@]}"; do echo "  $stem  @${GROUP[$stem]}  atol=${ATOL[$stem]} rtol=${RTOL[$stem]}"; done
  exit 0
fi

# --- 3) 编译 kernel_runner 扩展（仅首次）---
if ! ls "$KR"/kernel_runner/_ascend_runtime*.so >/dev/null 2>&1; then
  echo "== 编译 kernel_runner 扩展 =="
  ( cd "$KR" && "$PY" setup.py build_ext --inplace ) || { echo "error: kernel_runner 扩展编译失败"; exit 2; }
fi
export PYTHONPATH="$KR${PYTHONPATH:+:$PYTHONPATH}"

# --- 4) 逐例运行 ---
i=0; pass=0; fail=0; failed=()
for stem in "${SELECTED[@]}"; do
  i=$((i+1))
  d="$WORK/$stem"
  log="$LOGS/$stem.log"
  if [ ! -f "$d/$stem.o" ]; then
    printf '[%d/%d %s] %-24s ERROR (缺 %s.o)\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "$stem"
    fail=$((fail+1)); failed+=("$stem")
    [ "$STOP_ON_FAIL" = "1" ] && break
    continue
  fi
  ( cd "$d" && "$PY" -m kernel_runner "$stem.opentile.json" --kernel-o "$stem.o" ) > "$log" 2>&1
  rc=$?
  if [ $rc -ne 0 ] || [ ! -f "$d/out.npy" ] || [ ! -f "$d/golden.npy" ]; then
    printf '[%d/%d %s] %-24s ERROR @%-4s (run rc=%s)\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "${GROUP[$stem]}" "$rc"
    grep -iE 'error|Traceback|failed|abort|assert' "$log" | tail -5 | sed 's/^/      | /'
    fail=$((fail+1)); failed+=("$stem")
    [ "$STOP_ON_FAIL" = "1" ] && break
    continue
  fi
  res="$("$PY" "$PKG/check.py" "$d/out.npy" "$d/golden.npy" --atol "${ATOL[$stem]}" --rtol "${RTOL[$stem]}" 2>&1)"
  crc=$?
  if [ $crc -eq 0 ]; then
    printf '[%d/%d %s] %-24s PASS @%-4s %s\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "${GROUP[$stem]}" "$(printf '%s' "$res" | tr '\n' ' ' | sed 's/  */ /g')"
    pass=$((pass+1))
  else
    printf '[%d/%d %s] %-24s FAIL @%-4s %s\n' "$i" "$n" "$(date +%H:%M:%S)" "$stem" "${GROUP[$stem]}" "$(printf '%s' "$res" | tr '\n' ' ' | sed 's/  */ /g')"
    fail=$((fail+1)); failed+=("$stem")
    [ "$STOP_ON_FAIL" = "1" ] && break
  fi
done

echo "============================================"
echo "SUMMARY(batch=$MODE): $pass PASS / $fail FAIL / $n TOTAL"
[ $fail -eq 0 ] || { printf 'failed: %s\n' "${failed[*]}"; exit 1; }
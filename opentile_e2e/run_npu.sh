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
# 跳过清单 <PKG>/_npu_skip.txt（可选手工维护，一行一个 stem，# 开头为注释，行尾可跟原因）：
#   - 已 PASS 无需重跑
#   - 已知会在设备侧 trap / 挂死（例如 i8 横向归约），必须先移出批次
#   自动选批次时跳过清单内的用例；命令行显式点名时会照跑（并提示一句）。
#
# 用法：
#   bash run_npu.sh                # 非 i8 批次（base/f16/f32/i16/i32）——推荐先跑
#   bash run_npu.sh --i8           # 仅 i8 批次（单独分批；dim0 先跑、dim1 排最后）
#   bash run_npu.sh --all          # 全部用例
#   bash run_npu.sh --list         # 只列出将要执行的用例，不运行
#   bash run_npu.sh --force        # 忽略 _npu_skip.txt
#   bash run_npu.sh <stem> ...     # 指定子集
#
# 环境变量：
#   STOP_ON_FAIL=1   首个失败即停（默认 1；一次 trap 会让设备挂死并污染后续所有用例，
#                    所以默认止损。设 0 可跑完全部再汇总）
#   PYTHON=<python>  指定解释器（默认 python3）
#   DEVICE=<id>      健康检查用物理卡号；默认取 ASCEND_RT_VISIBLE_DEVICES 的第一项
#   SKIP_HEALTH_CHECK=1  跳过开跑前的设备健康闸门（仅在 npu-smi 不可用/误判时使用）
#
# 输出：每例一行进度 [i/n 时间] <stem> PASS|FAIL|ERROR；仅失败时附详细日志 + 设备健康状态。
set -uo pipefail

PKG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$PKG/_work"
KR="$PKG/kernel_runner"
LOGS="$PKG/_npu_logs"
MANIFEST="$PKG/_e2e_cases.txt"
GAPS="$PKG/_build_gaps.txt"
SKIP_FILE="$PKG/_npu_skip.txt"
PY="${PYTHON:-python3}"
STOP_ON_FAIL="${STOP_ON_FAIL:-1}"
mkdir -p "$LOGS"

DEVICE="${DEVICE:-${ASCEND_RT_VISIBLE_DEVICES:-}}"
DEVICE="${DEVICE%%,*}"; DEVICE="$(printf '%s' "$DEVICE" | tr -d ' ')"

echo "== env =="
echo "  PKG=$PKG"
echo "  PY=$PY -> $(command -v "$PY" 2>/dev/null || echo MISSING)"
echo "  ASCEND_HOME_PATH=${ASCEND_HOME_PATH:-<未设置>}"
echo "  ASCEND_RT_VISIBLE_DEVICES=${ASCEND_RT_VISIBLE_DEVICES:-<未设置>}"
echo "  STOP_ON_FAIL=$STOP_ON_FAIL"

# --- 0) 环境自检 ---
"$PY" -c 'import numpy, torch' 2>/dev/null || { echo "error: $PY 缺少 numpy/torch（先 source CANN，或用 PYTHON= 指定）"; exit 2; }
command -v ccec >/dev/null 2>&1 || echo "warn: PATH 上没有 ccec（本脚本不编译，仅运行）"

device_health() { # 打印设备健康状态；OK 返回 0，异常/无法确认返回 1
  if [ "${SKIP_HEALTH_CHECK:-0}" = "1" ]; then
    echo "      | 已按 SKIP_HEALTH_CHECK=1 跳过设备健康检查"
    return 0
  fi
  if ! command -v npu-smi >/dev/null 2>&1; then
    echo "      | npu-smi 不可用，跳过健康检查"
    return 0
  fi
  local out row
  out="$(npu-smi info -t health -i "$DEVICE" 2>&1)"
  if printf '%s' "$out" | grep -qiE 'Health[[:space:]]*Status[[:space:]]*:?[[:space:]]*OK'; then
    printf '%s\n' "$out" | head -12 | sed 's/^/      | /'
    return 0
  fi
  # -t health 的语法/输出格式不匹配时，退回解析 npu-smi info 的表格：
  # 设备行形如 "| 4 | Ascend950PR | Alarm | ..."，列位随版本浮动，故在该行内扫健康值
  row="$(npu-smi info 2>/dev/null | awk -v d="$DEVICE" \
        '$1=="|" && $2==d { for (i=3;i<=NF;i++) if ($i ~ /^(OK|Alarm|Critical|Warning)$/) { print $i; exit } }')"
  if [ -n "$row" ]; then
    echo "      | (表格判定) NPU $DEVICE Health=$row"
    [ "$row" = "OK" ]
    return
  fi
  echo "      | 无法确认 NPU $DEVICE 健康状态，按异常处理："
  printf '%s\n' "$out" | head -6 | sed 's/^/      | /'
  return 1
}

reset_hint() {
  echo "      复位步骤："
  echo "        pkill -9 -f kernel_runner"
  echo "        npu-smi info                 # 确认目标卡 Health=OK 且 AICore(%) 回落到 0"
  echo "        若仍为 Alarm/100%，需 npu-smi set -t reset -i $DEVICE（或联系管理员复位）"
}

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

# --- 2) 读跳过清单 ---
declare -A SKIP
if [ -f "$SKIP_FILE" ]; then
  while read -r line; do
    [[ "$line" =~ ^[[:space:]]*(#|$) ]] && continue
    read -r s r <<< "$line"
    [ -n "$s" ] && SKIP["$s"]="${r:-（无说明）}"
  done < "$SKIP_FILE"
fi

# --- 3) 选择批次 ---
MODE="safe"; SEL=(); LIST_ONLY=0; FORCE=0
for a in "$@"; do
  case "$a" in
    --all)   MODE="all" ;;
    --i8)    MODE="i8" ;;
    --safe)  MODE="safe" ;;
    --list)  LIST_ONLY=1 ;;
    --force) FORCE=1 ;;
    --*)     echo "error: 未知选项 $a"; exit 2 ;;
    *)       SEL+=("$a") ;;
  esac
done

nskip=0
if [ ${#SEL[@]} -gt 0 ]; then
  SELECTED=("${SEL[@]}")
  for stem in "${SELECTED[@]}"; do
    [ -n "${SKIP[$stem]:-}" ] && echo "  提示：$stem 在跳过清单内（${SKIP[$stem]}），因显式点名仍将执行"
  done
else
  SELECTED=()
  for stem in "${ORDER[@]}"; do
    if [ "$FORCE" -eq 0 ] && [ -n "${SKIP[$stem]:-}" ]; then nskip=$((nskip+1)); continue; fi
    case "$MODE" in
      all)  SELECTED+=("$stem") ;;
      i8)   if [ "${GROUP[$stem]}" = "i8" ]; then SELECTED+=("$stem"); fi ;;
      safe) if [ "${GROUP[$stem]}" != "i8" ]; then SELECTED+=("$stem"); fi ;;
    esac
  done
fi

# i8 批次重排：dim0 先跑（已验证可用），dim1（i8 横向归约，有设备级 trap 风险）排最后，
# 配合首错即停，一旦 trap 立刻止损，不浪费 18min/例 的运行时超时。
if [ "$MODE" = "i8" ] && [ ${#SEL[@]} -eq 0 ]; then
  LO=(); HI=()
  for stem in "${SELECTED[@]}"; do
    case "$stem" in *_d1_*) HI+=("$stem") ;; *) LO+=("$stem") ;; esac
  done
  SELECTED=()
  [ ${#LO[@]} -gt 0 ] && SELECTED+=("${LO[@]}")
  [ ${#HI[@]} -gt 0 ] && SELECTED+=("${HI[@]}")
fi

n=${#SELECTED[@]}
[ "$n" -gt 0 ] || { echo "error: 该批次无可执行用例（mode=$MODE，已在跳过清单内剔除 $nskip 例）"; exit 2; }

echo "== batch=$MODE  用例数=$n  跳过=$nskip =="
if [ "$nskip" -gt 0 ]; then
  echo "  已按 _npu_skip.txt 剔除："
  for stem in "${ORDER[@]}"; do
    [ -n "${SKIP[$stem]:-}" ] && echo "    - $stem  ${SKIP[$stem]}"
  done
fi
if [ -f "$GAPS" ] && [ -s "$GAPS" ]; then
  echo "  本机编译失败/探针结论（见 _build_gaps.txt）："
  sed 's/^/    - /' "$GAPS"
fi
if [ "$LIST_ONLY" -eq 1 ]; then
  for stem in "${SELECTED[@]}"; do echo "  $stem  @${GROUP[$stem]}  atol=${ATOL[$stem]} rtol=${RTOL[$stem]}"; done
  exit 0
fi

# --- 4) 编译 kernel_runner 扩展（仅首次）---
if ! ls "$KR"/kernel_runner/_ascend_runtime*.so >/dev/null 2>&1; then
  echo "== 编译 kernel_runner 扩展 =="
  ( cd "$KR" && "$PY" setup.py build_ext --inplace ) || { echo "error: kernel_runner 扩展编译失败"; exit 2; }
fi
export PYTHONPATH="$KR${PYTHONPATH:+:$PYTHONPATH}"

# --- 5) 批次开跑前的设备健康闸门 ---
echo "== device $DEVICE 健康检查 =="
if ! device_health; then
  echo "error: 设备 $DEVICE 健康状态非 OK —— 很可能被上一轮 trap 挂死，先把批次停在这里。"
  reset_hint
  exit 3
fi

# --- 6) 逐例运行 ---
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
    echo "  -- 设备 $DEVICE 健康状态 --"
    device_health || { echo "  !! 设备已非 OK：本批剩余用例的结论将不可信，建议在此止损。"; reset_hint; }
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
if [ "$STOP_ON_FAIL" = "1" ] && [ $fail -gt 0 ] && [ $i -lt $n ]; then
  echo "NOTE: 首错即停，已执行 $i/$n 例（剩余 $((n-i)) 例未跑）"
fi
echo "SUMMARY(batch=$MODE): $pass PASS / $fail FAIL / $i RAN / $n TOTAL"
[ $fail -eq 0 ] || { printf 'failed: %s\n' "${failed[*]}"; exit 1; }
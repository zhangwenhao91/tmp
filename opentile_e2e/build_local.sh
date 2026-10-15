#!/usr/bin/env bash
# OpenTile reduce 端到端 —— 本机(WSL)侧：把用例 mlir 降级/编译到 <stem>.o
#
# 复刻 OpenTileAS tools/kernel_runner/run.sh 的步骤 5-7（跳过需要 NPU 的运行步骤）：
#   tile-opt --npu-pipeline -> tile-opt --cce-pipeline -> tile-translate --cce-to-backend
#   -> ccec -> <stem>.o
#
# 用例清单来自 <PKG>/_cases.tsv（由 gen_reduce_matrix.py 生成）：
#   stem \t srcref \t atol \t rtol \t group
#   srcref = fp:<FullPipeline子目录> | src:<_src 文件>
#   group  = base|f16|f32|i8|i16|i32  |  gap
#
# 产出：
#   _e2e_cases.txt  可上机用例 stem:atol:rtol:group（group=gap 的探针不入此表）
#   _build_gaps.txt 未能编译的用例及真实失败层/报错；gap 探针的实测结论也记在此
#
# 用法：
#   bash build_local.sh              # 全部用例
#   bash build_local.sh <stem> ...   # 子集
set -uo pipefail

PKG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLCHAIN="${TOOLCHAIN:-/home/zwh/work/tilelang-toolchain}"
BUILD_DIR="${BUILD_DIR:-$TOOLCHAIN/build}"
SRC_DIR="${SRC_DIR:-$TOOLCHAIN/test/Integration/FullPipeline}"
CCEC="${CCEC:-/home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec}"
OPT="$BUILD_DIR/bin/tile-opt"
TRANS="$BUILD_DIR/bin/tile-translate"
TARGET="${TARGET:-dav-351x}"
WORK="$PKG/_work"
LOGS="$PKG/_build_logs"
mkdir -p "$WORK" "$LOGS"

for t in "$OPT:tile-opt" "$TRANS:tile-translate" "$CCEC:ccec"; do
  p="${t%%:*}"; n="${t##*:}"
  [ -x "$p" ] || { echo "error: $n 不可用: $p"; exit 2; }
done
[ -f "$PKG/_cases.tsv" ] || { echo "error: 缺少 $PKG/_cases.tsv（先跑 gen_reduce_matrix.py）"; exit 2; }

run_one() { # $1=stem $2=srcref
  local stem="$1" ref="$2" d="$PKG/_work/$1" log="$PKG/_build_logs/$1.log"
  local src
  case "$ref" in
    fp:*)  src="$SRC_DIR/${ref#fp:}/$stem.opentile.mlir" ;;
    src:*) src="$PKG/_src/${ref#src:}.opentile.mlir" ;;
    *)     src="$ref" ;;
  esac
  [ -f "$src" ] || { echo "找不到 mlir: $src" > "$log"; return 1; }
  [ -f "$PKG/$stem.opentile.json" ] || { echo "找不到 json: $stem.opentile.json" > "$log"; return 1; }
  rm -rf "$d"; mkdir -p "$d"
  cp "$src" "$d/" && cp "$PKG/$stem.opentile.json" "$d/" && cp "$PKG/golden_impl.py" "$d/" || return 1
  (
    cd "$d" || exit 1
    "$OPT" "--npu-pipeline=fusion-mode=no_fuse target=$TARGET" "$stem.opentile.mlir" -o "$stem.npu.mlir" || { echo "FAIL npu-pipeline"; exit 1; }
    "$OPT" "--cce-pipeline=target=$TARGET" "$stem.npu.mlir" -o "$stem.cce.mlir" || { echo "FAIL cce-pipeline"; exit 1; }
    "$TRANS" --allow-unregistered-dialect --cce-to-backend "$stem.cce.mlir" -o "$stem.ll" || { echo "FAIL cce-to-backend"; exit 1; }
    "$CCEC" "$stem.ll" --cce-aicore-arch=dav-c310-vec --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -o "$stem.o" || { echo "FAIL ccec"; exit 1; }
  ) > "$log" 2>&1
}

reason() { # $1=stem -> "FAIL <stage> | <关键报错>"
  local log="$PKG/_build_logs/$1.log" st det
  st="$(grep -m1 -hoE 'FAIL (npu-pipeline|cce-pipeline|cce-to-backend|ccec)' "$log")"
  det="$(grep -m1 -hiE 'error:|Cannot select|vf stack|is not implemented|Translation failed|failed to|assert' "$log" \
        | sed 's/^[[:space:]]*//' | cut -c1-150)"
  printf '%s | %s' "${st:-FAIL ?}" "$det"
}

# 选择子集
if [ $# -gt 0 ]; then
  SEL=("$@")
else
  SEL=(); while IFS=$'\t' read -r stem _; do [ -n "$stem" ] && SEL+=("$stem"); done < "$PKG/_cases.tsv"
fi

: > "$PKG/_e2e_cases.txt"
: > "$PKG/_build_gaps.txt"
ok=0; bad=0; gap=0
for stem in "${SEL[@]}"; do
  ref=""; a=""; r=""; g=""
  while IFS=$'\t' read -r s rf aa rr gg; do
    [ "$s" = "$stem" ] && { ref="$rf"; a="$aa"; r="$rr"; g="$gg"; }
  done < "$PKG/_cases.tsv"
  [ -n "$ref" ] || { echo "!! 清单中无用例: $stem"; continue; }

  run_one "$stem" "$ref"
  built=0; [ -f "$PKG/_work/$stem/$stem.o" ] && built=1
  why=""; [ $built -eq 0 ] && why="$(reason "$stem")"

  if [ "$g" = "gap" ]; then
    # 探针：规格声称支持但工具链未必打通，只记录实测结论，不进上机清单
    [ $built -eq 1 ] && why="COMPILED -> 该组合已可降级（规格声称落空的部分已打通）"
    printf 'PROBE %-22s %s\n' "$stem" "$why"
    printf '%s\t%s\n' "$stem" "$why" >> "$PKG/_build_gaps.txt"
    gap=$((gap+1))
  elif [ $built -eq 1 ]; then
    printf 'OK    %-22s .o=%-6s @%s\n' "$stem" "$(stat -c%s "$PKG/_work/$stem/$stem.o")" "$g"
    echo "$stem:$a:$r:$g" >> "$PKG/_e2e_cases.txt"
    ok=$((ok+1))
  else
    printf 'FAIL  %-22s @%-4s %s\n' "$stem" "$g" "$why"
    printf '%s\t%s\t%s\n' "$stem" "$g" "$why" >> "$PKG/_build_gaps.txt"
    bad=$((bad+1))
  fi
done
echo "----- local build: e2e OK=$ok FAIL=$bad | gap probes=$gap -----"
echo "上机清单 -> _e2e_cases.txt ; 缺口/探针结论 -> _build_gaps.txt"
[ $bad -eq 0 ]
#!/usr/bin/env bash
# OpenTile reduce 端到端 —— 本机(WSL)侧：把 *.opentile.mlir 降级/编译到 <stem>.o
#
# 复刻 OpenTileAS tools/kernel_runner/run.sh 的步骤 5-7（跳过需要 NPU 的 kernel_runner 运行）：
#   tile-opt --npu-pipeline -> tile-opt --cce-pipeline -> tile-translate --cce-to-backend
#   -> ccec -> <stem>.o
#
# 用法：
#   bash build_local.sh                 # 跑全部用例
#   bash build_local.sh triton_min_dim1 # 子集
#
# 环境：
#   TOOLCHAIN  工具链仓根（含 build/bin/tile-opt|tile-translate）  默认 /home/zwh/work/tilelang-toolchain
#   BUILD_DIR  含 bin/ 的构建目录                                  默认 $TOOLCHAIN/build
#   CCEC       ccec 路径（本机 CANN）                              默认 /home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec
#   SRC_DIR    用例 mlir 目录                                      默认 $TOOLCHAIN/test/Integration/FullPipeline
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

# stem:subdir
CASES=(
  "triton_min_dim1:test_min_dim1"
  "triton_max_dim0:test_max_dim0"
  "triton_sum_dim1:test_sum_dim1"
  "triton_sum_dim0:test_sum_dim0"
  "triton_mean_dim1:test_mean_dim1"
  "triton_mean_dim0:test_mean_dim0"
)
# 额外（本轮不上机）：int8 用例，编译可能失败/上机有 trap 风险
EXTRA_CASES=(
  "triton_min_dim0:test_min_dim0"
  "triton_max_dim1:test_max_dim1"
)

run_one() { # $1=stem $2=sub
  local stem="$1" sub="$2" d="$PKG/_work/$1" log="$PKG/_build_logs/$1.log"
  rm -rf "$d"; mkdir -p "$d"
  cp "$SRC_DIR/$sub/$stem.opentile.mlir" "$d/"
  cp "$PKG/$stem.opentile.json" "$d/"
  cp "$PKG/golden_impl.py" "$d/"
  (
    cd "$d" || exit 1
    "$OPT" "--npu-pipeline=fusion-mode=no_fuse target=$TARGET" "$stem.opentile.mlir" -o "$stem.npu.mlir" || { echo "FAIL npu-pipeline"; exit 1; }
    "$OPT" "--cce-pipeline=target=$TARGET" "$stem.npu.mlir" -o "$stem.cce.mlir" || { echo "FAIL cce-pipeline"; exit 1; }
    "$TRANS" --allow-unregistered-dialect --cce-to-backend "$stem.cce.mlir" -o "$stem.ll" || { echo "FAIL cce-to-backend"; exit 1; }
    "$CCEC" "$stem.ll" --cce-aicore-arch=dav-c310-vec --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -o "$stem.o" || { echo "FAIL ccec"; exit 1; }
  ) > "$log" 2>&1
}

if [ $# -gt 0 ]; then
  SEL=("$@")
else
  SEL=(); for s in "${CASES[@]}"; do SEL+=("${s%%:*}"); done
fi

ok=0; bad=0
for stem in "${SEL[@]}"; do
  sub=""
  for s in "${CASES[@]}" "${EXTRA_CASES[@]}"; do [ "${s%%:*}" = "$stem" ] && sub="${s##*:}"; done
  [ -n "$sub" ] || { echo "!! 未知用例: $stem"; continue; }
  run_one "$stem" "$sub"
  if [ -f "$PKG/_work/$stem/$stem.o" ]; then
    printf 'OK   %-18s .o=%s bytes\n' "$stem" "$(stat -c%s "$PKG/_work/$stem/$stem.o")"; ok=$((ok+1))
  else
    printf 'FAIL %-18s log: %s\n' "$stem" "$PKG/_build_logs/$stem.log"
    tail -4 "$PKG/_build_logs/$stem.log" | sed 's/^/      /'; bad=$((bad+1))
  fi
done
echo "----- local build: OK=$ok FAIL=$bad -----"
[ $bad -eq 0 ]
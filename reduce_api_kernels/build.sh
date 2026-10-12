#!/usr/bin/env bash
# reduce_api_kernels 逐级降级驱动：TileLangIR -> NPU IR -> MIX -> CCE -> LLVM -> .o
#
# 用法:
#   ./build.sh                 # 构建全部算子（5 个，从已提交的 1_*.mlir 开始）
#   ./build.sh reduce_sum      # 只构建指定算子
#   FORCE_STAGE0=1 ./build.sh  # 强制从 DSL(0_*.py) 重新生成 1_*.mlir（需可用的 tilelang python）
#
# 覆盖的 5 个算子: reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax
# 形态: SimdVF 内 frag->frag（vreduce 的输入必须是 fragment，无 shared->shared 形态）
#
# 工具解析顺序（环境变量 > 本地绝对路径 > PATH 上的裸名），因此在本机与 NPU 机都能跑：
#   TILE_OPT        默认 /home/zwh/work/tilelang-toolchain/build/bin/tile-opt      否则 PATH 上 tile-opt
#   TILE_TRANSLATE  默认 /home/zwh/work/tilelang-toolchain/build/bin/tile-translate 否则 PATH 上 tile-translate
#   CCEC            默认 CANN 9.1.0 下的 ccec   否则 PATH 上 ccec
#   TILELANG_PYTHON 默认 python3（仅 stage0 需要）
#
# 降级参数（环境变量可覆盖，默认与 NPU 机上实测通过的链路一致）：
#   NPU_SPLIT_PASS  默认 --npu-split-dataflow（备选 --npu-split-scope）
#   NPU_NORMALIZE   默认 --npu-normalize（置空可关闭）
#   CCEC_ARCH       默认 dav-c310-cube（纯向量可用 dav-c310-vec）
#   CCEC_EXTRA      默认 -cce-enable-mix（置空可关闭）
#
# 注意：任一阶段失败即中止该算子并置 rc=1；失败的算子其 6_*.o 不会被更新
#       （仓里可能仍有上一次的旧 .o，不要当成本次结果）。
#
# 工具链版本要求：abssum/absmax 的 DSL 用到 `tilelang.vmax`，该 op 由
#       gitcode OpenTileIR/OpenTileAS 的 78f11fb (2026-09-14 "feat(npu): compute ops refactor")
#       引入。早于它的 tile-opt 会在 stage1 报：
#         error: unregistered operation 'tilelang.vmax' found in dialect ('tilelang')
#       校验：strings "$(command -v tile-opt)" | grep -x tilelang.vmax
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

# 可执行性判断：绝对/相对路径看 -x，裸名看 PATH
is_exec() { [ -x "$1" ] || command -v "$1" >/dev/null 2>&1; }

# 工具解析：env 覆盖 > 本地绝对路径 > PATH 裸名
pick() { # $1=env值 $2=本地默认绝对路径 $3=PATH 裸名
  if [ -n "${1:-}" ]; then printf '%s' "$1"; return; fi
  if [ -x "$2" ]; then printf '%s' "$2"; return; fi
  printf '%s' "$3"
}

OPT="$(pick "${TILE_OPT:-}"       /home/zwh/work/tilelang-toolchain/build/bin/tile-opt       tile-opt)"
TRANS="$(pick "${TILE_TRANSLATE:-}" /home/zwh/work/tilelang-toolchain/build/bin/tile-translate tile-translate)"
CCEC="$(pick "${CCEC:-}"          /home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec ccec)"
PY="${TILELANG_PYTHON:-python3}"

SPLIT_PASS="${NPU_SPLIT_PASS:---npu-split-dataflow}"
NORMALIZE="${NPU_NORMALIZE:---npu-normalize}"
CCEC_ARCH="${CCEC_ARCH:-dav-c310-cube}"
CCEC_EXTRA="${CCEC_EXTRA:--cce-enable-mix}"
FORCE_STAGE0="${FORCE_STAGE0:-0}"

for spec in "TILE_OPT:$OPT" "TILE_TRANSLATE:$TRANS" "CCEC:$CCEC"; do
  name="${spec%%:*}"; val="${spec#*:}"
  if ! is_exec "$val"; then echo "ERROR: $name 不可用: $val" >&2; exit 1; fi
done

# 单算子的 1->6 降级。注意：这里刻意不依赖 `set -e`——本函数在 `if ( ... )` 语境下
# 执行时 -e 会被忽略，必须逐条显式 `|| return 1`，否则失败会一路穿透到最后。
lower_one() { # $1=算子目录 $2=<op>_<form>
  local d="$1" b="$2"
  cd "$d" || { echo "FAIL [$b] cd $d" >&2; return 1; }

  echo "-- [$b] TileLangIR -> NPU IR"
  # 适配格式差异：producer 的 mlir-python-bindings(20260927) 只提供新 API
  #   linalg.elementwise <mul> ins(...) outs(...)
  # 而 toolchain 的 --convert-tilelang-to-npu 只识别旧命名 op
  #   linalg.mul ins(...) outs(...)
  sed -E 's/linalg\.elementwise <([a-zA-Z_]+)>/linalg.\1/' \
    "1_${b}_tilelangir.mlir" > "1_${b}_tilelangir.norm.mlir" \
    || { echo "FAIL [$b] sed 归一化" >&2; return 1; }
  "$OPT" "1_${b}_tilelangir.norm.mlir" --convert-tilelang-to-npu $NORMALIZE -o "2_${b}_npu.mlir" \
    || { echo "FAIL [$b] stage1 convert-tilelang-to-npu" >&2; return 1; }

  echo "-- [$b] NPU IR -> MIX 拆分 ($SPLIT_PASS)"
  "$OPT" "2_${b}_npu.mlir" $SPLIT_PASS --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline \
    -o "3_${b}_mix_npu.mlir" \
    || { echo "FAIL [$b] stage2 $SPLIT_PASS" >&2; return 1; }

  echo "-- [$b] MIX NPU -> CCE"
  "$OPT" --cce-pipeline="target=dav-351x" "3_${b}_mix_npu.mlir" -o "4_${b}_cce.mlir" \
    || { echo "FAIL [$b] stage3 cce-pipeline" >&2; return 1; }

  echo "-- [$b] CCE -> LLVM .ll"
  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${b}_cce.mlir" -o "5_${b}.ll" \
    || { echo "FAIL [$b] stage4 cce-to-backend" >&2; return 1; }

  echo "-- [$b] ccec -> .o (arch=$CCEC_ARCH $CCEC_EXTRA)"
  "$CCEC" --cce-aicore-arch="$CCEC_ARCH" --cce-aicore-only $CCEC_EXTRA -O2 \
    -cce-bitcode-is-aicore -c "5_${b}.ll" -o "6_${b}.o" \
    || { echo "FAIL [$b] stage5 ccec" >&2; return 1; }
  return 0
}

OPS=("$@")
if [ ${#OPS[@]} -eq 0 ]; then
  OPS=(reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax)
fi

shopt -s nullglob
rc=0
for op in "${OPS[@]}"; do
  d="$HERE/$op"
  echo "############ $op ############"

  srcs=( "$d"/1_${op}_*_tilelangir.mlir )
  if [ "$FORCE_STAGE0" = 1 ] || [ ${#srcs[@]} -eq 0 ]; then
    if ! is_exec "$PY"; then
      echo "ERROR: stage0 需要可用的 TILELANG_PYTHON，当前不可用: $PY" >&2
      echo "       若已有 1_*.mlir 则不设 FORCE_STAGE0 即可跳过 stage0" >&2
      rc=1; continue
    fi
    ( cd "$d" && "$PY" "0_${op}.py" ) || { echo "FAIL stage0: $op" >&2; rc=1; continue; }
    srcs=( "$d"/1_${op}_*_tilelangir.mlir )
  fi

  for mlir in "${srcs[@]}"; do
    base="$(basename "$mlir")"   # 1_<op>_<form>_tilelangir.mlir
    base="${base#1_}"
    b="${base%_tilelangir.mlir}" # <op>_<form>

    if ! ( lower_one "$d" "$b" ); then
      echo "FAIL lower: $b（该算子的 6_${b}.o 未更新，勿用旧产物）" >&2
      rc=1; continue
    fi

    if ! grep -q 'linalg.reduce' "$d/1_${b}_tilelangir.mlir"; then
      echo "WARN [$b]: stage1 未见 linalg.reduce —— 归约未降级，.o 不含归约语义" >&2
    fi
    echo "OK: $d/6_${b}.o"
  done
done

exit $rc
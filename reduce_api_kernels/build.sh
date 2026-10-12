#!/usr/bin/env bash
# reduce_api_kernels 逐级降级驱动：DSL -> TileLangIR -> NPU IR -> MIX -> CCE -> LLVM -> .o
#
# 用法:
#   ./build.sh                 # 构建全部算子
#   ./build.sh reduce_sum      # 只构建指定算子
#
# 覆盖的 5 个算子: reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax
# 形态: SimdVF 内 frag->frag（vreduce 的输入必须是 fragment，无 shared->shared 形态）
#
# 依赖（可用环境变量覆盖）:
#   TILELANG_PYTHON  默认 /home/zwh/work/venv/bin/python3
#   TILE_OPT         默认 /home/zwh/work/tilelang-toolchain/build/bin/tile-opt
#   TILE_TRANSLATE   默认 /home/zwh/work/tilelang-toolchain/build/bin/tile-translate
#   CCEC             默认 CANN 9.1.0 下的 ccec
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

PY="${TILELANG_PYTHON:-/home/zwh/work/venv/bin/python3}"
OPT="${TILE_OPT:-/home/zwh/work/tilelang-toolchain/build/bin/tile-opt}"
TRANS="${TILE_TRANSLATE:-/home/zwh/work/tilelang-toolchain/build/bin/tile-translate}"
CCEC="${CCEC:-/home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec}"

OPS=("$@")
if [ ${#OPS[@]} -eq 0 ]; then
  OPS=(reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax)
fi

for v in "$PY" "$OPT" "$TRANS" "$CCEC"; do
  if [ ! -x "$v" ]; then echo "ERROR: not executable: $v" >&2; exit 1; fi
done

rc=0
for op in "${OPS[@]}"; do
  d="$HERE/$op"
  echo "############ $op ############"
  ( cd "$d" && "$PY" "0_${op}.py" ) || { echo "FAIL stage0: $op" >&2; rc=1; continue; }

  for mlir in "$d"/1_${op}_*_tilelangir.mlir; do
    [ -e "$mlir" ] || continue
    base="$(basename "$mlir")"   # 1_<op>_<form>_tilelangir.mlir
    base="${base#1_}"
    b="${base%_tilelangir.mlir}" # <op>_<form>
    (
      cd "$d" || exit 1
      set -e
      echo "-- [$b] TileLangIR -> NPU IR"
      "$OPT" "1_${b}_tilelangir.mlir" --convert-tilelang-to-npu --npu-normalize -o "2_${b}_npu.mlir"

      echo "-- [$b] NPU IR -> MIX 拆分"
      "$OPT" "2_${b}_npu.mlir" --npu-split-scope --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline -o "3_${b}_mix_npu.mlir"

      echo "-- [$b] MIX NPU -> CCE"
      "$OPT" --cce-pipeline="target=dav-351x" "3_${b}_mix_npu.mlir" -o "4_${b}_cce.mlir"

      echo "-- [$b] CCE -> LLVM .ll"
      "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${b}_cce.mlir" -o "5_${b}.ll"

      echo "-- [$b] ccec -> .o (arch=dav-c310-vec)"
      "$CCEC" --cce-aicore-arch=dav-c310-vec --cce-aicore-only -O2 \
        -cce-bitcode-is-aicore -c "5_${b}.ll" -o "6_${b}.o"
    ) || { echo "FAIL lower: $b" >&2; rc=1; continue; }

    if ! grep -q 'linalg.reduce' "$d/1_${b}_tilelangir.mlir"; then
      echo "WARN [$b]: stage1 未见 linalg.reduce —— 归约未降级，.o 不含归约语义" >&2
    fi
    echo "OK: $d/6_${b}.o"
  done
done

exit $rc
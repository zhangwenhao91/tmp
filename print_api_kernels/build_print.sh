#!/usr/bin/env bash
# print_api_kernels 上机载体构建：device .o + host 可执行文件
#
# 用法:
#   ./build_print.sh            # 用仓内已提交的自包含 6_print.o 构建 host 可执行文件 print_host
#   ./build_print.sh --device   # 先从 1_print_tilelangir.mlir 重新降级生成 6_print.o，再构建 host
#   ./build_print.sh -h
#
# 产物:
#   6_print.o     device 侧自包含 object（内核 _Z12print_kernelPviPN3cce8internal15DebugTunnelDataE_mix_aiv，
#                 含 print 运行时与 DebugTunnel 支持；无未定义符号）
#   print_host    host 侧可执行文件（内嵌 6_print.o 的 .aicore_binary；UNIX）
#
# 为何 host 侧必须带 `--cce-enable-print -cce-enable-mix`:
#   官方 guide 的 host 步骤只写了 `ccec -cc1 -fcce-include-aibinary <device>.o`。实测（本机 ccec）当
#   host 不带 print 开关时，launch stub 为短名 _Z12print_kernelPvi、argSize=0xc（仅 ptr+i32），
#   既不调用 __DebugTunnel_Open 也不追加 .DTData —— 设备侧拿不到 DebugTunnel，不会打印。
#   带 `--cce-enable-print -cce-enable-mix` 后：launch 前 __DebugTunnel_Open(blockDim)、
#   argSize=0x18（ptr+i32+DTData）、launch 后 __DebugTunnel_Close(DTData, stream)，
#   与 device 内核名 ..._mix_aiv + .Mix_Kernel_Type__/.AIV_Kernel_Type__ 元数据配合完成混核派发。
#
# 工具解析顺序（环境变量 > 本地绝对路径 > PATH 裸名），本机与 NPU 机都能跑：
#   TILE_OPT        默认 /home/zwh/work/tilelang-toolchain/build/bin/tile-opt
#   TILE_TRANSLATE  默认 /home/zwh/work/tilelang-toolchain/build/bin/tile-translate
#   CCEC            默认 CANN 9.1.0 下的 ccec（NPU 机可用 $CANN_HOME/tools/bisheng_compiler/bin/ccec）
#   PRINT_BC        默认 /home/zwh/work/tilelang-toolchain/build/lib/print.bc
#   CANN_HOME       默认 /home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0
# 可调参数:
#   AICORE_ARCH     默认 dav-c310-vec（纯 AIV print；置为 dav-c310-cube 会改用 cube 侧编译）
#   CCEC_EXTRA      默认 -cce-enable-mix（置空可关闭）
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

usage() { sed -n '2,30p' "$0"; }

DO_DEVICE=0
for a in "$@"; do
  case "$a" in
    -h|--help) usage; exit 0 ;;
    --device)  DO_DEVICE=1 ;;
    *) echo "ERROR: 未知参数 $a" >&2; usage; exit 2 ;;
  esac
done

is_exec() { [ -x "$1" ] || command -v "$1" >/dev/null 2>&1; }
pick() { # $1=env值 $2=本地默认绝对路径 $3=PATH 裸名
  if [ -n "${1:-}" ]; then printf '%s' "$1"; return; fi
  if [ -x "$2" ]; then printf '%s' "$2"; return; fi
  printf '%s' "$3"
}

OPT="$(pick "${TILE_OPT:-}"        /home/zwh/work/tilelang-toolchain/build/bin/tile-opt        tile-opt)"
TRANS="$(pick "${TILE_TRANSLATE:-}" /home/zwh/work/tilelang-toolchain/build/bin/tile-translate tile-translate)"
CCEC="$(pick "${CCEC:-}"           /home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec ccec)"
# PRINT_BC 是数据文件（.bc），只需存在，不用可执行
pick_file() { # $1=env值 $2=本地默认绝对路径 $3=PATH 裸名
  if [ -n "${1:-}" ]; then printf '%s' "$1"; return; fi
  if [ -f "$2" ]; then printf '%s' "$2"; return; fi
  command -v "$3" >/dev/null 2>&1 && printf '%s' "$(command -v "$3")" || printf '%s' "$3"
}
PRINT_BC="$(pick_file "${PRINT_BC:-}" /home/zwh/work/tilelang-toolchain/build/lib/print.bc print.bc)"
CANN_HOME="${CANN_HOME:-/home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0}"

AICORE_ARCH="${AICORE_ARCH:-dav-c310-vec}"
CCEC_EXTRA="${CCEC_EXTRA:--cce-enable-mix}"

DEV_O="$HERE/6_print.o"
OUT="$HERE/print_host"
WORK="$HERE/work"
mkdir -p "$WORK"

if ! is_exec "$CCEC"; then echo "ERROR: CCEC 不可用: $CCEC" >&2; exit 1; fi

# ---------- device: 可选重新降级 ----------
if [ "$DO_DEVICE" = 1 ]; then
  for spec in "TILE_OPT:$OPT" "TILE_TRANSLATE:$TRANS"; do
    name="${spec%%:*}"; val="${spec#*:}"
    is_exec "$val" || { echo "ERROR: $name 不可用: $val（--device 需要完整工具链）" >&2; exit 1; }
  done
  [ -f "$PRINT_BC" ] || { echo "ERROR: PRINT_BC 不存在: $PRINT_BC" >&2; exit 1; }

  echo "-- [device] TileLangIR -> NPU IR"
  sed -E 's/linalg\.elementwise <([a-zA-Z_]+)>/linalg.\1/' \
      1_print_tilelangir.mlir > "$WORK/1_print.norm.mlir" \
    || { echo "FAIL: sed 归一化" >&2; exit 1; }
  "$OPT" "$WORK/1_print.norm.mlir" --convert-tilelang-to-npu --npu-normalize \
    -o "$WORK/2_print_npu.mlir" || { echo "FAIL: stage1 convert-tilelang-to-npu" >&2; exit 1; }

  echo "-- [device] NPU IR -> MIX 拆分"
  "$OPT" "$WORK/2_print_npu.mlir" --npu-split-dataflow --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline \
    -o "$WORK/3_print_mix_npu.mlir" || { echo "FAIL: stage2 npu split" >&2; exit 1; }

  echo "-- [device] MIX NPU -> CCE（含 print 相关 pass）"
  "$OPT" --cce-pipeline="target=dav-351x" "$WORK/3_print_mix_npu.mlir" \
    -o "$WORK/4_print_cce.mlir" || { echo "FAIL: stage3 cce-pipeline" >&2; exit 1; }

  echo "-- [device] CCE -> LLVM .ll (--enable-print)"
  "$TRANS" --cce-to-backend -allow-unregistered-dialect --enable-print "$WORK/4_print_cce.mlir" \
    -o "$WORK/5_print.ll" || { echo "FAIL: stage4 cce-to-backend --enable-print" >&2; exit 1; }

  echo "-- [device] ccec -> 6_print.o (arch=$AICORE_ARCH $CCEC_EXTRA + print.bc)"
  "$CCEC" --cce-aicore-arch="$AICORE_ARCH" --cce-aicore-only $CCEC_EXTRA -O2 \
    -cce-bitcode-is-aicore -cce-link-aicore-ll-module "$PRINT_BC" -c \
    "$WORK/5_print.ll" -o "$DEV_O" || { echo "FAIL: stage5 ccec" >&2; exit 1; }
fi

[ -f "$DEV_O" ] || { echo "ERROR: device object 不存在: $DEV_O（可加 --device 生成）" >&2; exit 1; }

# device 自包含性 + 内核名断言
if strings -a "$DEV_O" | grep -q '_Z12print_kernelPviPN3cce8internal15DebugTunnelDataE_mix_aiv'; then
  echo "OK: device kernel = _Z12print_kernelPviPN3cce8internal15DebugTunnelDataE_mix_aiv"
else
  echo "ERROR: $DEV_O 未找到预期 print kernel 名（是否用 --enable-print 降级？）" >&2
  exit 1
fi

# ---------- host: 编译并链接出可执行文件 ----------
[ -f "$HERE/print_host.cce" ] || { echo "ERROR: 缺少 print_host.cce" >&2; exit 1; }

echo "-- [host] ccec 编译 print_host.cce 并内嵌 6_print.o"
[ -n "${ASCEND_HOME_PATH:-}" ] || export ASCEND_HOME_PATH="$CANN_HOME"
"$CCEC" --cce-host-only -x cce --cce-enable-print -cce-enable-mix \
  -I"$CANN_HOME/x86_64-linux/include" \
  -Xclang -fcce-include-aibinary -Xclang "$DEV_O" \
  "$HERE/print_host.cce" \
  -L"$CANN_HOME/x86_64-linux/lib64" -lascendcl -lruntime -lstdc++ -lm \
  -Wl,--allow-multiple-definition \
  -o "$OUT" || { echo "FAIL: host 编译/链接" >&2; exit 1; }

chmod +x "$OUT" 2>/dev/null
echo
echo "OK: $OUT"
echo "    运行: ./run_on_npu.sh [deviceId]   （或 LD_LIBRARY_PATH=$CANN_HOME/x86_64-linux/lib64 ./print_host 0）"
echo "    预期: stdout 出现 'buffer<shared_buf, float16>' 数据块、'block id'=0..3、'hello' 三处打印"
#!/usr/bin/env bash
# 在 NPU 机器上运行 print 上机载体，观察 stdout 打印输出。
#
# 前置:
#   1. 已用 build_print.sh 产出 print_host（已内嵌 device 6_print.o）
#   2. 已 source CANN 环境（set_env.sh），使 libascendcl.so / libruntime.so 可加载
#
# 用法:
#   ./run_on_npu.sh [deviceId]     # 默认 device 0
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

if [ ! -x ./print_host ]; then
  echo "ERROR: ./print_host 不存在，请先执行 ./build_print.sh" >&2
  exit 1
fi

# 未 source CANN 环境时，补上运行时库搜索路径（可用 CANN_HOME 覆盖）
if [ -n "${CANN_HOME:-}" ]; then
  export LD_LIBRARY_PATH="$CANN_HOME/x86_64-linux/lib64:${LD_LIBRARY_PATH:-}"
fi

./print_host "${1:-0}"
#!/usr/bin/env bash
# 在 NPU 机器上跑 reduce_api_kernels 的 .o 并验证精度。
#
# 前置：
#   1. 已安装 triton-opentile 并打过 KERNEL_PATH 补丁（misc/patch_installed_kernel_path.py）
#   2. 已用 build.sh 产出各算子的 6_*.o
#   3. 已 source CANN 环境（set_env.sh）
#
# 用法:
#   ./run_on_npu.sh              # 跑全部算子
#   ./run_on_npu.sh reduce_sum   # 只跑指定算子
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

PY="${TILELANG_PYTHON:-python3}"

OPS=("$@")
if [ ${#OPS[@]} -eq 0 ]; then
  OPS=(reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax)
fi

pass=0
fail=0
skip=0
for op in "${OPS[@]}"; do
  o="$HERE/$op/6_${op}_frag.o"
  if [ ! -f "$o" ]; then
    echo "SKIP (no .o): $op"
    skip=$((skip + 1))
    continue
  fi
  echo "===== $op ====="
  # 纯向量 reduce 用 aiv；若 .o 为 mix 拆分产物，改成 KERNEL_CV_MODE=mix
  if KERNEL_PATH="$o" "$PY" verify_precision.py "$op"; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
  fi
done

echo "============================================"
echo "SUMMARY: $pass PASS / $fail FAIL / $skip SKIP"
[ "$fail" -eq 0 ]
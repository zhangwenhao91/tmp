#!/usr/bin/env bash
# 在 NPU 机器上跑 reduce_api_kernels 的 .o 并验证精度。
#
# 前置：
#   1. 已安装 triton-opentile 并打过 KERNEL_PATH 补丁（misc/patch_installed_kernel_path.py）
#   2. 已用 build.sh 产出各算子的 6_*.o
#   3. 已 source CANN 环境（set_env.sh）
#
# 用法:
#   ./run_on_npu.sh                       # 跑全部算子、全部 dtype/shape 变体
#   ./run_on_npu.sh reduce_sum            # 只跑指定算子
#   ./run_on_npu.sh reduce_sum reduce_max # 只跑指定若干算子
#
# 文件名约定：6_<op>_<form>_<dtype>_<M>x<K>.o（由 build.sh 从同名 1_*.mlir 产出）。
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

PY="${TILELANG_PYTHON:-python3}"

OPS=("$@")
ALL_OPS=(reduce_sum reduce_max reduce_min reduce_abssum reduce_absmax
         reduce_bitand reduce_bitor reduce_bitxor)

in_filter() { # $1=op；无过滤参数时恒真
  [ ${#OPS[@]} -eq 0 ] && return 0
  local x
  for x in "${OPS[@]}"; do [ "$x" = "$1" ] && return 0; done
  return 1
}

pass=0
fail=0
for op in "${ALL_OPS[@]}"; do
  in_filter "$op" || continue
  found=0
  for o in "$HERE/$op"/6_${op}_*.o ; do
    [ -f "$o" ] || continue
    found=1
    base="$(basename "$o" .o)"; base="${base#6_}"   # <op>_<form>_<dtype>_<M>x<K>
    shape="${base##*_}"        # <M>x<K>
    rest="${base%_*}"          # <op>_<form>_<dtype>
    dtype="${rest##*_}"        # <dtype>
    rest2="${rest%_*}"         # <op>_<form>
    form="${rest2##*_}"        # <form>
    pop="${rest2%_*}"          # <op>
    M="${shape%x*}"; K="${shape#*x}"
    # 纯向量 reduce 用 aiv；若 .o 为 mix 拆分产物，设 KERNEL_CV_MODE=mix
    if KERNEL_PATH="$o" "$PY" verify_precision.py "$pop" "$form" "$dtype" "$M" "$K"; then
      pass=$((pass + 1))
    else
      fail=$((fail + 1))
    fi
  done
  if [ "$found" -eq 0 ]; then
    # bit* 因 NpuToCCE 无横向位归约原语，其 6_*.o 无法产出（详见 build.sh 头注释）
    echo "SKIP (no .o): $op"
  fi
done

echo "============================================"
echo "SUMMARY: $pass PASS / $fail FAIL"
[ "$fail" -eq 0 ]
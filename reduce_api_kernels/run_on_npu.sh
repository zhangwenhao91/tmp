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
# 每个用例的墙钟上限（秒）。坏 kernel 会让 vector core 挂死、约 10 分钟才报 507034；
# 这里用 host 侧 timeout 把等待压短。设 0 关闭（退回原来"一直等到 device 自己超时"）。
CASE_TIMEOUT="${CASE_TIMEOUT:-120}"
# 命中第一个失败/超时就中止当前算子剩余的用例。坏 kernel 会把卡"焊死"，
# 之后的用例会成片假失败；开启本开关可快速定位坏组合。1=开启，0=关闭。
STOP_ON_FAIL="${STOP_ON_FAIL:-0}"

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
timeout_n=0
for op in "${ALL_OPS[@]}"; do
  in_filter "$op" || continue
  found=0
  op_pass=0
  op_fail=0
  op_timeout=0
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
    rc=0
    if [ "$CASE_TIMEOUT" -gt 0 ]; then
      KERNEL_PATH="$o" timeout -k 10 "$CASE_TIMEOUT" "$PY" verify_precision.py "$pop" "$form" "$dtype" "$M" "$K" || rc=$?
    else
      KERNEL_PATH="$o" "$PY" verify_precision.py "$pop" "$form" "$dtype" "$M" "$K" || rc=$?
    fi
    case "$rc" in
      0)
        pass=$((pass + 1)); op_pass=$((op_pass + 1)) ;;
      124|137)   # 被 timeout 墙钟掐掉 / -k 强杀：坏 kernel 在 device 侧挂死
        timeout_n=$((timeout_n + 1)); op_timeout=$((op_timeout + 1))
        echo "TIMEOUT(${CASE_TIMEOUT}s): ${base}" ;;
      *)
        fail=$((fail + 1)); op_fail=$((op_fail + 1)) ;;
    esac
    if [ "$rc" -ne 0 ] && [ "$STOP_ON_FAIL" -eq 1 ]; then
      echo "STOP_ON_FAIL: 中止 $op 剩余用例（坏用例=${base}）"
      break
    fi
  done
  if [ "$found" -eq 0 ]; then
    # bit* 因 NpuToCCE 无横向位归约原语，其 6_*.o 无法产出（详见 build.sh 头注释）
    echo "SKIP (no .o): $op"
  else
    echo "OP $op: $op_pass PASS / $op_fail FAIL / $op_timeout TIMEOUT"
  fi
done

echo "============================================"
echo "SUMMARY: $pass PASS / $fail FAIL / $timeout_n TIMEOUT"
[ "$fail" -eq 0 ] && [ "$timeout_n" -eq 0 ]
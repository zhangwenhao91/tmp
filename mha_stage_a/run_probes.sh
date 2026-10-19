#!/bin/bash
# 阶段 A 探针运行器（服务器端）。用法：
#   cd /home/z30086261/tmp && git pull && bash mha_stage_a/run_probes.sh
# 输出建议重定向回 error.txt：bash mha_stage_a/run_probes.sh > error.txt 2>&1
set -u
cd "$(dirname "$0")"

# CANN 9.3（与已验证的 MHA 测试保持一致口径；不 source 则用系统默认 8.3，也能跑）
if [ -f /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh ]; then
    # shellcheck disable=SC1091
    source /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh
    echo "CANN: $ASCEND_HOME_PATH"
else
    echo "WARN: CANN 9.3 set_env.sh not found, using ambient env"
fi
export PYTHONUNBUFFERED=1

echo "=== [1/2] probe_gather（运行时间接寻址） ==="
python probe_gather.py 2>&1 | tail -60

echo ""
echo "=== [2/2] probe_dynloop（运行时守卫/动态早退） ==="
python probe_dynloop.py 2>&1 | tail -60

echo ""
echo "=== done ==="

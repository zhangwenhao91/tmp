#!/bin/bash
# 阶段 A 探针运行器（服务器端）。用法：
#   cd /home/z30086261/tmp && git pull && bash mha_stage_a/run_probes.sh > error.txt 2>&1
set -u
cd "$(dirname "$0")"

if [ -f /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh ]; then
    # shellcheck disable=SC1091
    source /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh
    echo "CANN: $ASCEND_HOME_PATH"
else
    echo "WARN: CANN 9.3 set_env.sh not found, using ambient env"
fi
export PYTHONUNBUFFERED=1

echo "=== probe_iter（多变体二分：定位 ScalarDcacheBypass 触发条件） ==="
python probe_iter.py 2>&1

echo ""
echo "=== done ==="

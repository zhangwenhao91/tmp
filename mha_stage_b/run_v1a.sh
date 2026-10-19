#!/bin/bash
# 阶段 B v1a 运行器。用法：
#   cd /home/z30086261/tmp && git pull && bash mha_stage_b/run_v1a.sh > error.txt 2>&1
#   git add error.txt && git commit -m 'Update error.txt' && git push
set -u
cd "$(dirname "$0")"

if [ -f /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh ]; then
    # shellcheck disable=SC1091
    source /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh
    echo "CANN: $ASCEND_HOME_PATH"
else
    echo "WARN: CANN 9.3 set_env.sh not found"
fi
export PYTHONUNBUFFERED=1

echo "=== stage B v1a: minimal decode kernel (B=1,H=1,S_q=1,D=128,1 page,fp16) ==="
python decode_v1a.py 2>&1
rc=$?
echo "exit_code=$rc"

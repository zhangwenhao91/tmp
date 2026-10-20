#!/bin/bash
# MLA decode Stage A 二轮探针 runner。
# 一轮教训：多变体同进程跑，aicore trap 后设备会话毒化、后续全部连坐假失败。
# 二轮改为每变体独立 python 进程 + sys.exit 传 rc。
cd "$(dirname "$0")" || exit 1
rc_sum=0
for f in "probe1c_qk.py" "probe2c_pv.py" "probe3_slots.py 64" "probe3_slots.py 128"; do
  echo "================ $f ================"
  # shellcheck disable=SC2086
  PYTHONUNBUFFERED=1 python3 $f
  rc=$?
  echo "---------------- $f rc=$rc"
  rc_sum=$((rc_sum + rc))
done
echo "FINAL mla_stage_a_r2 rc_sum=$rc_sum"

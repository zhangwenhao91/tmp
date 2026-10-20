#!/bin/bash
# MLA decode Stage A 探针 runner：逐个跑探针，单探针失败不影响后续，汇总 rc。
cd "$(dirname "$0")" || exit 1
rc_sum=0
for f in probe1_qk.py probe2_pv.py probe3_state.py; do
  echo "================ $f ================"
  PYTHONUNBUFFERED=1 python3 "$f"
  rc=$?
  echo "---------------- $f rc=$rc"
  rc_sum=$((rc_sum + rc))
done
echo "FINAL mla_stage_a rc_sum=$rc_sum"

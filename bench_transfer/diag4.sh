#!/usr/bin/env bash
ASC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/asc
echo "===== [1] find asc_copy_l12ub definition ====="
grep -rn "asc_copy_l12ub" $ASC --include="*.h" -l | head -5
echo "===== [2] show definition ====="
grep -rn -A 30 "asc_copy_l12ub" $ASC/impl/tensor_api/arch/utils/arch_utils.h 2>/dev/null | head -50
echo "===== [3] find in other files ====="
for f in $(grep -rln "asc_copy_l12ub" $ASC --include="*.h" 2>/dev/null | head -3); do
  echo "--- $f ---"
  grep -n -B2 -A25 "asc_copy_l12ub" "$f" | head -60
done
echo "===== done ====="

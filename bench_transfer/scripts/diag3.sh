#!/usr/bin/env bash
CANN=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0
echo "===== [1] find ascendc api headers ====="
find $CANN -name "*.h" 2>/dev/null | grep -i -e fixed -e copy -e mte | grep -v python | head -10
echo "===== [2] grep FixL1 / L1ToUb in headers ====="
grep -rln "FIX_L1_TO_UB\|FixL1ToUb\|fix_l1_to_ub" $CANN/include $CANN/x86_64-linux/include 2>/dev/null | head -5
echo "===== [3] search all ascendc dirs ====="
find $CANN -type d -name "*ascendc*" 2>/dev/null | head -5
echo "===== [4] grep FIX_L1 in whole CANN (filenames) ====="
grep -rln "FIX_L1_TO_UB" $CANN 2>/dev/null | head -10
echo "===== [5] OpenTileAS search fix l1 ====="
grep -rn "fix.l1.to.ub\|FixL1ToUb\|FIX_L1" /home/z30086261/tilelang-ascend-private/OpenTileAS/lib /home/z30086261/tilelang-ascend-private/OpenTileAS/include 2>/dev/null | head -10
echo "===== done ====="

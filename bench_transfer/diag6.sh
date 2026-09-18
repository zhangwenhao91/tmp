#!/usr/bin/env bash
OTA=/home/z30086261/tilelang-ascend-private/OpenTileAS
echo "===== [1] DMALowering MOV.L1.TO.UB generation ====="
grep -rn "MOV.L1.TO.UB" $OTA/lib --include="*.cpp" | head -10
echo "===== [2] tmp dir layout ====="
ls /home/z30086261/tmp/ | head -30
echo "===== [3] DSA mlir samples ====="
find /home/z30086261/tmp -maxdepth 2 -name "*dsa*" -o -maxdepth 2 -name "*DSA*" 2>/dev/null | head -10
echo "===== [4] SplitMixKernel comment about l1->ub ====="
grep -n -B5 -A10 "l1.*ub\|L1.*UB\|L1ToUb" $OTA/lib/Dialect/Npu/Transforms/SplitMixKernel.cpp 2>/dev/null | grep -i -B3 -A8 "planner\|invalid" | head -40
echo "===== done ====="

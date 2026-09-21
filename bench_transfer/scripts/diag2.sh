#!/usr/bin/env bash
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec
echo "===== strings: L1->UB variants ====="
strings $CCEC | grep -E "^MOV_L1_TO_UB" | sort -u
echo "----- dotted -----"
strings $CCEC | grep -E "^MOV\.L1\.TO\.UB" | sort -u
echo "===== strings: all *_TO_UB ====="
strings $CCEC | grep -E "_TO_UB" | sort -u | head -40
echo "===== strings: UB->L1 for comparison ====="
strings $CCEC | grep -E "^MOV_UB_TO_L1" | sort -u
echo "===== done ====="

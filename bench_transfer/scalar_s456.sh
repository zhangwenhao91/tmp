#!/usr/bin/env bash
# 标量中转测试的 stage4/5/6：到 .ll 检查指令与 addrspace，再到 .o
set -uo pipefail
cd /home/z30086261/tmp/bench_transfer
OPT=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt
TRANS=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec

for variant in ub_scalar l1_scalar; do
  echo "########## [$variant] s4-s6 ##########"
  "$OPT" --cce-pipeline="target=dav-351x" "3_${variant}_mix_npu.mlir" \
    -o "4_${variant}_cce.mlir" 2>/tmp/sc_s4.err \
    || { echo "[FAIL-s4]"; head -5 /tmp/sc_s4.err; continue; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${variant}_cce.mlir" \
    -o "5_${variant}.ll" 2>/tmp/sc_s5.err \
    || { echo "[FAIL-s5]"; head -5 /tmp/sc_s5.err; continue; }

  echo "-- .ll 标量 load/store 与地址空间 --"
  grep -n "load\|store" "5_${variant}.ll" | grep -v "declare\|target-cpu\|;" | head -8

  # 按函数 target-cpu 决定 ccec arch
  cpu=$(grep -o 'target-cpu"="[a-z0-9-]*' "5_${variant}.ll" | head -1 | cut -d'"' -f4)
  arch=dav-c310-cube
  [ "$cpu" = "dav-c310-vec" ] && arch=dav-c310-vec
  echo "-- ccec arch=$arch (target-cpu=$cpu) --"

  "$CCEC" --cce-aicore-arch=$arch --cce-aicore-only -O2 -cce-bitcode-is-aicore \
    -c "5_${variant}.ll" -o "6_${variant}.o" 2>/tmp/sc_s6.err
  rc=$?
  if [ $rc -ne 0 ]; then echo "[FAIL-s6] rc=$rc"; head -10 /tmp/sc_s6.err; continue; fi
  echo "[OK] 6_${variant}.o ($(stat -c%s "6_${variant}.o") bytes)"
done

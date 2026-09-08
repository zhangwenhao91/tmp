#!/bin/bash
# 编译 E1/E2/E3 三个实验 .o（全部用官方 TO_process 的 ccec 参数组合）
export PATH="/home/z30086261/OpenTileAS/build/bin:$PATH"
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec
VADD=/home/z30086261/tmp/elementwise_kernels/vadd
RMAX=/home/z30086261/tmp/reduce_kernels/reduce_max
set -e

# ---- E1: vadd A+A→OUT (3 参数) ----
cd $VADD
tile-opt --cce-pipeline="target=dav-351x" 3_vadd_e1_mix_npu.mlir -o 4_vadd_e1_cce.mlir
tile-translate --cce-to-backend -allow-unregistered-dialect 4_vadd_e1_cce.mlir -o 5_vadd_e1.ll
$CCEC --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -c 5_vadd_e1.ll -o 6_vadd_e1.o
echo "E1 done"

# ---- E2: reduce_max 双输出 (4 参数) ----
cd $RMAX
tile-opt --cce-pipeline="target=dav-351x" 3_reduce_max_e2_mix_npu.mlir -o 4_reduce_max_e2_cce.mlir
tile-translate --cce-to-backend -allow-unregistered-dialect 4_reduce_max_e2_cce.mlir -o 5_reduce_max_e2.ll
$CCEC --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -c 5_reduce_max_e2.ll -o 6_reduce_max_e2.o
echo "E2 done"

# ---- E3: vadd 静态寻址 (4 参数, getelementptr) ----
cd $VADD
$CCEC --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -c 5_vadd_e3.ll -o 6_vadd_e3.o
echo "E3 done"

echo "===ALL BUILT==="
ls -la $VADD/6_vadd_e1.o $VADD/6_vadd_e3.o $RMAX/6_reduce_max_e2.o

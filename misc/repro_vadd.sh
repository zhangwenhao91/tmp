#!/bin/bash
# 复现 vadd 降级流水线: 3_mix_npu.mlir -> cce.mlir -> ll -> o
export PATH="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin:$PATH"
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec
cd /home/z30086261/tmp/elementwise_kernels/vadd
mkdir -p repro
set -x

# step1: cce-pipeline
tile-opt --cce-pipeline="target=dav-351x" 3_vadd_mix_npu.mlir -o repro/4_vadd_cce.mlir 2>repro/step1.log
tail -3 repro/step1.log

# step2: translate to ll
tile-translate --cce-to-backend -allow-unregistered-dialect repro/4_vadd_cce.mlir -o repro/5_vadd.ll 2>repro/step2.log
tail -3 repro/step2.log

# step3: ccec compile (vec arch, 与 .ll 内 target-cpu=dav-c310-vec 一致)
$CCEC --cce-aicore-arch=dav-c310-vec --cce-aicore-only -O2 -cce-bitcode-is-aicore -c repro/5_vadd.ll -o repro/6_vadd.o 2>repro/step3.log
tail -5 repro/step3.log

set +x
echo "===COMPARE==="
md5sum repro/4_vadd_cce.mlir 4_vadd_cce.mlir
md5sum repro/5_vadd.ll 5_vadd.ll
md5sum repro/6_vadd.o 6_vadd.o
ls -la repro/6_vadd.o 6_vadd.o

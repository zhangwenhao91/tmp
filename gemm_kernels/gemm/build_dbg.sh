#!/usr/bin/env bash
# 构建带 cce.print 调试的 GEMM sb (M=16 K=128 grid=1)：
# mix NPU IR -> CCE raw -> 插 print -> insert-print-copy -> intr -> LLVM -> 修 .ll -> .o
# 运行后 NPU 上打印 L0C(mad 结果) 和 UB(FIX 输出) 中间数据。
# print 函数走 cce::printf，由 print.bc 在 ccec 链接时解析，不依赖 DTData。
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

PY="/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec"
PRINTBC="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/lib/print.bc"

echo "== [dbg 1/7] mix NPU IR -> CCE raw（convert-npu-to-cce，未到 intr）=="
"$OPT" 3_gemm_sb_mix_npu.mlir \
  --convert-npu-to-cce="target=dav-351x" --expand-strided-metadata \
  -o 4a_gemm_cce_raw.mlir

echo "== [dbg 2/7] 插入 cce.print（l0c_acc + ub_fix_out）=="
"$PY" insert_print.py

echo "== [dbg 3/7] insert-print-copy（为 L0C print 插 L0C->UB 搬运）=="
"$OPT" 4a_print.mlir --cce-insert-print-copy -o 4b_print_copy.mlir

echo "== [dbg 4/7] intr + LLVM lowering pass 序列 =="
"$OPT" 4b_print_copy.mlir \
  --cce-to-library-call \
  --convert-cce-to-cce-intr \
  --convert-math-to-llvm \
  --convert-func-memref-to-bare-ptr \
  --convert-arith-to-llvm \
  --convert-scf-to-cf \
  --convert-cf-to-llvm \
  --cce-reconcile-bare-ptr-descriptors \
  --reconcile-unrealized-casts \
  --canonicalize \
  -o 4c_print_intr.mlir

echo "== [dbg 5/7] CCE -> LLVM .ll =="
"$TRANS" --cce-to-backend -allow-unregistered-dialect 4c_print_intr.mlir -o 5_gemm_dbg.ll

echo "== [dbg 6/7] 修 .ll（去 DTData 参数/恢复符号名/补 hivm.annotations）=="
"$PY" fix_dbg_ll.py 5_gemm_dbg.ll 5_gemm_dbg_fixed.ll
cp 5_gemm_dbg_fixed.ll 5_gemm_dbg.ll

echo "== [dbg 7/7] ccec -> .o（链接 print.bc）=="
"$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
  -cce-bitcode-is-aicore -cce-link-aicore-ll-module "$PRINTBC" -c -v 5_gemm_dbg.ll -o 6_gemm_dbg.o
echo "OK: 6_gemm_dbg.o"

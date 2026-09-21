#!/usr/bin/env bash
# 标量中转测试的 stage2/3 管线验证
set -uo pipefail
cd /home/z30086261/tmp/bench_transfer
PY=/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python
OPT=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt

for variant in ub_scalar l1_scalar; do
  echo "########## [$variant] ##########"
  "$PY" scalar_transfer.py $variant 16 256 16 2 bfloat16 > /dev/null 2>&1 \
    || { echo "[FAIL-s1] $variant"; continue; }
  mv 1_scalar_tilelangir.mlir "1_${variant}_tilelangir.mlir"

  # stage2: convert + normalize
  "$OPT" --convert-tilelang-to-npu --npu-normalize \
    "1_${variant}_tilelangir.mlir" -o "2_${variant}_npu.mlir" 2>/tmp/sc_s2.err \
    || { echo "[FAIL-s2] $variant"; head -5 /tmp/sc_s2.err; continue; }

  # stage3: 全 pass 链（照 build_all_bench.sh）
  "$OPT" --npu-expand-ub-to-l1-nd2nz --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline \
    "2_${variant}_npu.mlir" -o "3_${variant}_mix_npu.mlir" 2>/tmp/sc_s3.err
  rc=$?
  if [ $rc -ne 0 ]; then echo "[FAIL-s3] $variant rc=$rc"; head -12 /tmp/sc_s3.err; continue; fi

  echo "[s3 OK] 3_${variant}_mix_npu.mlir"
  echo "-- 标量访问 op 形态 --"
  grep -o "npu.load[^ ]*\|npu.store[^ ]*\|memref.load\|memref.store\|tilelang.load[^,(]*\|tilelang.store[^,(]*" "3_${variant}_mix_npu.mlir" | sort | uniq -c | head
  echo "-- 分核/函数结构 --"
  grep -o "func_core_type = #[a-z.<A-Z_]*\|npu.part_of_mix\|@[a-z_0-9]*_kernel[a-z_0-9]*" "3_${variant}_mix_npu.mlir" | sort | uniq -c
  echo "-- memref 地址空间（shared buffer）--"
  grep -o "memref<[0-9x]*x[a-z0-9]*, [0-9]*>" "3_${variant}_mix_npu.mlir" | sort | uniq -c | head -8
done

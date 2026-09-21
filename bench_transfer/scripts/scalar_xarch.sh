#!/usr/bin/env bash
# 正确 arch 组合重编 + 交叉验证：
#   ub_scalar: vec arch（AIV 标量访问 UB，正确）
#   l1_scalar: cube arch（AIC gemm + L1 标量访问，正确）
#   交叉: ub_scalar+cube（应无效-AIC UB标量no-op）、l1_scalar+vec（应失败-gemm无向量指令）
set -uo pipefail
cd /home/z30086261/tmp/bench_transfer
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec

try() { # $1=ll $2=arch $3=out $4=label
  "$CCEC" --cce-aicore-arch=$2 --cce-aicore-only -O2 -cce-bitcode-is-aicore \
    -c "$1" -o "$3" > /tmp/sc_x.err 2>&1
  rc=$?
  if [ $rc -eq 0 ] && [ -f "$3" ]; then
    echo "[$4] OK ($2) -> $(stat -c%s "$3") bytes"
  else
    echo "[$4] FAIL ($2) rc=$rc: $(head -2 /tmp/sc_x.err)"
  fi
}

echo "== 正确组合 =="
try 5_ub_scalar.ll dav-c310-vec 6_ub_scalar.o "ub_scalar"
try 5_l1_scalar.ll dav-c310-cube 6_l1_scalar.o "l1_scalar"

echo "== 交叉对照 =="
try 5_ub_scalar.ll dav-c310-cube /tmp/x_ub_cube.o "ub_scalar"
try 5_l1_scalar.ll dav-c310-vec /tmp/x_l1_vec.o "l1_scalar"

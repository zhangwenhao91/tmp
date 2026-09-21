#!/usr/bin/env bash
# l1_scalar mix 版编译: stage4/5/6 (-cce-enable-mix)
set -uo pipefail
cd /home/z30086261/tmp/bench_transfer
OPT=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt
TRANS=/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec

variant=l1_scalar
"$OPT" --cce-pipeline="target=dav-351x" "3_${variant}_mix_npu.mlir" \
  -o "4_${variant}_cce.mlir" 2>/tmp/mix_s4.err || { echo "[FAIL-s4]"; head -5 /tmp/mix_s4.err; exit 1; }
grep -qE 'error' /tmp/mix_s4.err && { echo "[ERR-s4]"; head -5 /tmp/mix_s4.err; exit 1; }

"$TRANS" --cce-to-backend -allow-unregistered-dialect "4_${variant}_cce.mlir" \
  -o "5_${variant}.ll" 2>/tmp/mix_s5.err || { echo "[FAIL-s5]"; head -5 /tmp/mix_s5.err; exit 1; }

echo "== .ll 检查 =="
echo "AIC half 标量: $(grep -c 'addrspace(2)' "5_${variant}.ll") 个 L1 标量访存"
echo "target-cpu: $(grep -o 'target-cpu"="[a-z0-9-]*' "5_${variant}.ll" | sort | uniq -c | tr '\n' ' ')"
grep -n '^define' "5_${variant}.ll"

"$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
  -cce-bitcode-is-aicore -c "5_${variant}.ll" -o "6_${variant}.o" 2>/tmp/mix_s6.err \
  || { echo "[FAIL-s6]"; head -8 /tmp/mix_s6.err; exit 1; }
echo "[OK] 6_${variant}.o ($(stat -c%s "6_${variant}.o") bytes)"

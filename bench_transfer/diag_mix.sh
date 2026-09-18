#!/usr/bin/env bash
# 诊断 mix 编码问题：反汇编 .o + 编译选项矩阵
CCEC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/ccec
OD=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/bin/llvm-objdump
cd /home/z30086261/tmp/bench_transfer || exit 1

echo "===== [1] objdump current 6_l1ub_bfloat16_16x256_r16.o ====="
$OD -d --no-show-raw-insn 6_l1ub_bfloat16_16x256_r16.o > /tmp/diag_cur.txt 2>&1
echo "objdump exit=$? lines=$(wc -l < /tmp/diag_cur.txt)"
grep -n "aic\|aiv" /tmp/diag_cur.txt | head -10

echo "===== [2] compile matrix on 5_l1ub_bfloat16_16x256_r16.ll ====="
for combo in \
  "cube_mix:--cce-aicore-arch=dav-c310-cube -cce-enable-mix" \
  "vec_mix:--cce-aicore-arch=dav-c310-vec -cce-enable-mix" \
  "vec_only:--cce-aicore-arch=dav-c310-vec" \
  "cube_only:--cce-aicore-arch=dav-c310-cube"; do
  name="${combo%%:*}"; flags="${combo#*:}"
  out="/tmp/t_${name}.o"
  $CCEC $flags -O2 -cce-bitcode-is-aicore -c 5_l1ub_bfloat16_16x256_r16.ll -o "$out" > "/tmp/t_${name}.log" 2>&1
  rc=$?
  size=$([ -f "$out" ] && stat -c%s "$out" || echo 0)
  echo "[$name] rc=$rc size=${size}B"
  if [ $rc -ne 0 ]; then head -5 "/tmp/t_${name}.log"; fi
done

echo "===== [3] objdump AIV function of vec_mix result (if exists) ====="
if [ -f /tmp/t_vec_mix.o ] && [ -s /tmp/t_vec_mix.o ]; then
  $OD -d --no-show-raw-insn /tmp/t_vec_mix.o > /tmp/diag_vm.txt 2>&1
  echo "objdump exit=$? lines=$(wc -l < /tmp/diag_vm.txt)"
  grep -n "aiv\|aic" /tmp/diag_vm.txt | head -10
fi
echo "===== done ====="

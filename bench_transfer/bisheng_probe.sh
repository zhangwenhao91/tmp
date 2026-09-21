#!/usr/bin/env bash
# bisheng/新ccec 对真机 Ascend950 的 cube arch 探测（NPU 机上跑）。
#
# 事实：真机 SOC=Ascend950（driver 25.7.0 / CANN 9.2.0.B060），OPP 有
# kernel/ascend950/ 官方预编译算子；B060 带 bisheng（Baize clang 15），
# --cce-aicore-arch 识别 Ascend950PR_9589 等设备枚举。
# 假设：正确 arch 下 bisheng 能把 dav-351x 的 hivm cube IR (.ll) 编码成
# 950 可执行的 cube 指令 -> 编译出 .o 就基本算对上；拿 baseline/l1ub
# 关键核去真机跑，PASS 即翻盘。
#
# 输入：仓库内现成 n5 .ll（dav-351x 线产物，含 align256）
#   n5_baseline_bfloat16_16x256_r16_single.ll   (kname=baseline_kernel, 3-ptr)
#   n5_l1ub_bfloat16_16x256_r16_single.ll       (kname=l1ub_kernel, 5-ptr)
# 输出：new_env/arch_probe/bisheng_<arch>_<kernel>.o （编译成功即登记）
# 之后跑 bisheng_probe_run.py。
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

BISHENG="${BISHENG:-/data/pri/Ascend/9.2.0.B060/cann-9.2.0/tools/bisheng_compiler/bin/bisheng}"
CCEC="${CCEC:-/data/pri/Ascend/9.2.0.B060/cann-9.2.0/x86_64-linux/bin/ccec}"
OUT="$HERE/new_env/arch_probe"
mkdir -p "$OUT"
BP_ERR="$OUT/bp2.err"
: > "$BP_ERR"

[ -x "$BISHENG" ] || { echo "[FATAL] bisheng not found: $BISHENG"; exit 1; }
echo "bisheng: $($BISHENG --version 2>&1 | head -1)"
[ -x "$CCEC" ] && echo "ccec: $($CCEC --version 2>&1 | head -1)"

# (arch, 内核ll, kname, 指针数)
TV="Ascend950PR_9589:Ascend950PR_9579:Ascend950PR_959b:Ascend950PR_95A2:ascend950:dav-310-simt:dav-310-simd:dav-m200:dav-m300:dav-510r:dav-516r:dav-920r"
KERNELS="baseline:n5_baseline_bfloat16_16x256_r16_single.ll:baseline_kernel:3
l1ub:n5_l1ub_bfloat16_16x256_r16_single.ll:l1ub_kernel:5"

: > "$OUT/bisheng_probe_cases.txt"
while IFS=: read -r ktag fll kname nptrs; do
  [ -f "$HERE/new_env/$fll" ] || { echo "[SKIP] missing $fll"; continue; }
  # 确保 align256
  grep -q 'align 256' "$HERE/new_env/$fll" || \
    sed -i 's/^\(define dso_local ptc_kernel void @.*(.*)\) #0 {$/\1 align 256 #0 {/' "$HERE/new_env/$fll"
  for A in ${TV//:/ }; do
    for c in bisheng ccec; do
      C=$([ "$c" = bisheng ] && echo "$BISHENG" || echo "$CCEC")
      [ -x "$C" ] || continue
      tag="$c-$A-$ktag"
      if [ "$c" = bisheng ]; then
        out="$OUT/$tag.o"
        "$C" --cce-aicore-arch="$A" --cce-aicore-only -O2 -cce-bitcode-is-aicore \
          -c "$HERE/new_env/$fll" -o "$out" 2>"$BP_ERR" \
          && echo "$tag:$kname:$nptrs" >> "$OUT/bisheng_probe_cases.txt" \
          && { echo "[OK]  $out ($(stat -c%s "$out") B)"; continue; }
        echo "[FAIL-$c-$A] $ktag: $(head -2 "$BP_ERR" | tr '\n' ' ')"
      else
        out="$OUT/$tag.o"
        "$C" --cce-aicore-arch="$A" --cce-aicore-only -O2 -cce-bitcode-is-aicore \
          -c "$HERE/new_env/$fll" -o "$out" 2>"$BP_ERR" \
          && echo "$tag:$kname:$nptrs" >> "$OUT/bisheng_probe_cases.txt" \
          && { echo "[OK]  $out ($(stat -c%s "$out") B)"; continue; }
        echo "[FAIL-$c-$A] $ktag: $(head -2 "$BP_ERR" | tr '\n' ' ')"
      fi
    done
  done
done <<< "$KERNELS"

echo "=============================="
echo "case 清单:"
cat "$OUT/bisheng_probe_cases.txt" 2>/dev/null
ls -la "$OUT"/bisheng_*.o 2>/dev/null || echo "(无成功产物)"
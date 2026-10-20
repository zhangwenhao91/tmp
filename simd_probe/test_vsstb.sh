#!/usr/bin/env bash
# vsstb 注入测试：把 paged 探针 4_cce.mlir 中的一处 cce.intr.vstsx1.bf16
# 替换为 cce.intr.vsstb.bf16（5 参签名: data, basePtr, strideConfig,
# postUpdateEnable, mask），验证 stage4 tile-translate + stage5 ccec 能否吃下。
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE" || exit 1

TRANS=/home/zwh/work/tilelang-toolchain/build/bin/tile-translate
CCEC=/home/zwh/work/cann/9.1.0/toolkit/cann-9.1.0/tools/bisheng_compiler/bin/ccec
SRC=/home/zwh/work/tmp/paged_decode_probe/4_paged_decode_probe_cce.mlir

cp "$SRC" 4b_cce_vsstb.mlir || exit 1

python3 - <<'EOF' || exit 1
p = "4b_cce_vsstb.mlir"
s = open(p).read()
old = ("cce.intr.vstsx1.bf16(%432, %436, %1, %49, %1, %418) : "
       "(vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)")
new = ("cce.intr.vsstb.bf16(%432, %436, %49, %1, %418) : "
       "(vector<128xbf16>, <6>, i32, i32, vector<256xi1>)")
n = s.count(old)
assert n == 1, f"expect exactly 1 occurrence of vstsx1.bf16 line, got {n}"
open(p, "w").write(s.replace(old, new))
print("patched: vstsx1.bf16 -> vsstb.bf16 (1 site)")
EOF

echo "== [4/5] CCE -> LLVM =="
"$TRANS" --cce-to-backend -allow-unregistered-dialect 4b_cce_vsstb.mlir -o 5b_vsstb.ll \
  || { echo "FAIL stage4: tile-translate 不认 cce.intr.vsstb.bf16" >&2; exit 1; }
echo "ll 中 vsstb 痕迹: $(grep -c vsstb 5b_vsstb.ll)"

echo "== [5/5] ccec =="
"$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 \
  -cce-bitcode-is-aicore -c 5b_vsstb.ll -o 6b_vsstb.o \
  || { echo "FAIL stage5: ccec" >&2; exit 1; }

echo "OK: 6b_vsstb.o"

#!/usr/bin/env python3
"""在 4a_gemm_cce_raw.mlir 的 AIC 侧插入 cce.print 调试点。

插入两个打印（均在 cube 核执行，print runtime 支持 UB 直读）：
  1. l0c_acc     —— cce.mad 的 L0C 结果（insert-print-copy 会自动插 L0C->UB 搬运）
  2. ub_fix_out  —— cce.fix.l0c.to.ub 的 UB 输出（FIX 链路结果）
判读：
  - l0c_acc 正确 & ub_fix_out 正确 & GM 错  => AIV 搬运(UB->GM)错
  - l0c_acc 正确 & ub_fix_out 错            => FIX 配置错
  - l0c_acc 错                              => A/B 搬运(ND2NZ/L1->L0)或 MAD 错
"""
import re
import sys

SRC = "4a_gemm_cce_raw.mlir"
DST = "4a_print.mlir"

with open(SRC) as f:
    text = f.read()

# AIC 侧：在 cce.fix.l0c.to.ub(...) 行后插 print。
# print 与 fix 同在 FIX pipe 顺序执行，确保读到的是 FIX 完成后的数据。
fix_pat = re.compile(
    r"(cce\.fix\.l0c\.to\.ub\(%view_2, %6, %c549756864512_i64, %c8796093022224_i64\)"
    r" \{dmaMode = 0 : i32\} : \(memref<16x128xf32, #cce\.address_space<ub>>, "
    r"memref<16x128xf32, #cce\.address_space<cc>>, i64, i64\))\n"
)
insert = (
    r"\1\n"
    r'    cce.print "l0c_acc" %6 : memref<16x128xf32, #cce.address_space<cc>>\n'
    r'    cce.print "ub_fix_out" %view_2 : memref<16x128xf32, #cce.address_space<ub>>\n'
)
text2, n = fix_pat.subn(insert, text)
if n != 1:
    print(f"ERROR: fix.l0c.to.ub pattern matched {n} times (expected 1)", file=sys.stderr)
    sys.exit(1)

with open(DST, "w") as f:
    f.write(text2)
print(f"OK: wrote {DST} (inserted 2 cce.print)")

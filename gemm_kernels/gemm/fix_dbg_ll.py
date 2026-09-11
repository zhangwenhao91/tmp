#!/usr/bin/env python3
"""fix_dbg_ll.py - 修正调试版 .ll 使其可被 Triton KERNEL_PATH loader 正确加载。

translate 输出的带 print 的 .ll 存在三个问题（对照正常可工作的 5_gemm_sb.ll）：
  1. print 适配(addDebugSupportToKernels)给 kernel 加了 .DTData 第 5 参数，
     而 Triton launcher 只按 Triton 侧签名传 4 个参数 -> 参数不匹配。
  2. 同一 pass 重建 kernel 函数导致 LLVM 自动加数字后缀（@gemm_kernel_mix_aic.1），
     loader 按原始符号名查找 -> 找不到 kernel。
  3. addHIVMAnnotations 按原始名查函数找不到（已改名）-> !hivm.annotations 丢失，
     loader 无 kernel 入口元数据。

修复（print 走 cce::printf，不依赖 DTData；print 函数由 print.bc 在 ccec 链接时解析）：
  a. 删除两个 kernel define 的 `.DTData` 参数
  b. 删除 _mlir_ciface_init_debug / _mlir_ciface_finish_debug 调用行和 declare
  c. 函数名去掉数字后缀：@gemm_kernel_mix_aic.1 -> @gemm_kernel_mix_aic
  d. 文件末尾补 !hivm.annotations 元数据（与正常版一致）
"""
import re
import sys

SRC = sys.argv[1] if len(sys.argv) > 1 else "5_gemm_dbg.ll"
DST = sys.argv[2] if len(sys.argv) > 2 else "5_gemm_dbg_fixed.ll"

text = open(SRC).read()

# --- a. 删除 kernel define 中的 DTData 参数 ---
# 签名: ... i32 %3, ptr addrspace(1) %.DTData) #0 {  ->  ... i32 %3) #0 {
n1 = text.count(", ptr addrspace(1) %.DTData)")
text = text.replace(", ptr addrspace(1) %.DTData)", ")")

# --- b. 删除 init/finish_debug 调用 ---
text, n2 = re.subn(r"[ \t]*call void @_mlir_ciface_(init|finish)_debug\(ptr addrspace\(1\) %\.DTData\)\n", "", text)

# --- b2. 删除 init/finish_debug declare（连同前面的 "; Function Attrs" 注释行）---
text = re.sub(r"; Function Attrs: alwaysinline\ndeclare extern_weak dso_local void @_mlir_ciface_(init|finish)_debug\(ptr addrspace\(1\)\) #\d+\n\n?", "", text)

# --- c. kernel 名去数字后缀 ---
text, n3 = re.subn(r"@gemm_kernel_mix_(aic|aiv)\.\d+", r"@gemm_kernel_mix_\1", text)

# --- d. 补 hivm.annotations（照抄正常版结构）---
if "hivm.annotations" not in text:
    # 找到最大的已有 metadata 编号
    nums = [int(m) for m in re.findall(r"^!(\d+) =", text, re.M)]
    n = (max(nums) + 1) if nums else 1
    ann = (
        f"!hivm.annotations = !{{!{n}, !{n + 1}}}\n"
        f"!{n} = !{{ptr @gemm_kernel_mix_aic, !\"kernel\", i32 1}}\n"
        f"!{n + 1} = !{{ptr @gemm_kernel_mix_aiv, !\"kernel\", i32 1}}\n"
    )
    if "!nvvm.annotations" in text:
        text = text.replace("!nvvm.annotations", ann + "!nvvm.annotations", 1)
    else:
        text += "\n" + ann

open(DST, "w").write(text)
print(
    f"OK: wrote {DST} (removed {n1} DTData params, {n2} debug calls, "
    f"{n3} kernel name suffixes)"
)

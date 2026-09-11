#!/usr/bin/env python3
"""fix_dbg_ll.py - 修正调试版 .ll 使其可被 Triton KERNEL_PATH loader 正确加载。

translate 输出的带 print 的 .ll 存在的问题（对照正常可工作的 5_gemm_sb.ll）：
  1. print 适配(addDebugSupportToKernels)给 kernel 加了 .DTData 第 5 参数，
     而 Triton launcher 只按 Triton 侧签名传 4 个参数 -> 参数不匹配。
  2. 同一 pass 重建 kernel 函数导致 LLVM 自动加数字后缀（@gemm_kernel_mix_aic.1），
     loader 按原始符号名查找 -> 找不到 kernel。
  3. addHIVMAnnotations 按原始名查函数找不到（已改名）-> !hivm.annotations 丢失。
  4. print 的 memref 描述符用 alloca(stack) 存储。hivm 启动的 kernel 不保证 SP
     初始化（正常 kernel 无 alloca 也能跑），cube 核 scalar 访问 stack 越界
     -> NPU error 271 "scalar access internal buffer out of bounds"。
     修复：描述符改为 GM global constant（与 prefix 字符串同机制，已验证可行）。

print 走 cce::printf（不依赖 DTData），print 函数由 print.bc 在 ccec 链接时解析。
"""
import re
import sys

SRC = sys.argv[1] if len(sys.argv) > 1 else "5_gemm_dbg.ll"
DST = sys.argv[2] if len(sys.argv) > 2 else "5_gemm_dbg_fixed.ll"

text = open(SRC).read()

# --- 4. 描述符 alloca+store -> GM global constant，call 改用 global ptr ---
# 模式：
#   %13 = alloca { ... }, align 8
#   store { ... } { <literal> }, ptr %13, align 8
#   call void @...print_...d_..._...(ptr @prefix, i64 N, ptr %13, i8 H)
STRUCT_TY = r"\{ ptr addrspace\(6\), ptr addrspace\(6\), i64, \[2 x i64\], \[2 x i64\] \}"
pat = re.compile(
    r"(%\w+) = alloca " + STRUCT_TY + r", align 8\n"
    r"[ \t]*store " + STRUCT_TY + r" (\{[^{}]*\}), ptr \1, align 8\n"
    r"[ \t]*call void (@_mlir_ciface_print_\S+)\((ptr @\S+), (i64 \d+), ptr \1, (i8 \d+)\)"
)
globals_added = []

def repl(m):
    reg, literal, fn, prefix, ln, hexv = m.groups()
    name = f"@_debug_desc_{len(globals_added)}"
    globals_added.append(f"{name} = private constant {STRUCT_TY_RE} {literal}\n")
    return (
        f"call void {fn}({prefix}, {ln}, ptr {name}, {hexv})"
    )

STRUCT_TY_RE = "{ ptr addrspace(6), ptr addrspace(6), i64, [2 x i64], [2 x i64] }"
text, n4 = pat.subn(repl, text)

# 把 global 定义插到 prefix 常量之后（文件头部）
if globals_added:
    anchor = re.search(r'@_debug_prefix_\w+ = private constant[^\n]*\n', text)
    block = "\n" + "".join(globals_added)
    if anchor:
        end = anchor.end()
        text = text[:end] + block + text[end:]
    else:
        # 没有前缀常量就插在第一个 declare 之前
        first_decl = text.find("\ndeclare")
        text = text[:first_decl] + "\n" + block + text[first_decl:]

# --- a. 删除 kernel define 中的 DTData 参数 ---
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
    f"OK: wrote {DST} (desc->global: {n4}, removed {n1} DTData params, "
    f"{n2} debug calls, {n3} kernel name suffixes)"
)

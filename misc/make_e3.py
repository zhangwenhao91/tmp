#!/usr/bin/env python3
"""E3 实验 v3：vadd 静态寻址重写（完整级联重编号）
原循环块 7 个编号值(%35-%41)，新写法 8 个(%35-%42)，后续块/值整体 +1，
并同步更新所有 phi 回边引用和分支目标。
"""
SRC = "/home/z30086261/tmp/elementwise_kernels/vadd/5_vadd.ll"
DST = "/home/z30086261/tmp/elementwise_kernels/vadd/5_vadd_e3.ll"

text = open(SRC).read()

# ---- 1. 重写循环体 block 34：getelementptr 指针寻址（golden 模式）----
old_block = """34:                                               ; preds = %31
  %35 = mul i64 %32, 64
  %36 = trunc i64 %35 to i32
  %37 = mul i32 %36, 4
  %38 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %37, i32 0, i32 0)
  %39 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %37, i32 0, i32 0)
  %40 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %38, <64 x float> %39, <256 x i1> %30)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %40, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i32 %37, i32 2, i32 0, <256 x i1> %30)
  %41 = add i64 %32, 1
  br label %31"""

new_block = """34:                                               ; preds = %31
  %35 = mul i64 %32, 256
  %36 = getelementptr i8, ptr addrspace(6) null, i64 %35
  %37 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %36, i32 0, i32 0, i32 0)
  %38 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %35
  %39 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %38, i32 0, i32 0, i32 0)
  %40 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %37, <64 x float> %39, <256 x i1> %30)
  %41 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %35
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %40, ptr addrspace(6) %41, i32 0, i32 2, i32 0, <256 x i1> %30)
  %42 = add i64 %32, 1
  br label %31"""

assert old_block in text, "loop block not found!"
text = text.replace(old_block, new_block)

# ---- 2. 全部级联更新（块 42→43, 43→44, 44→45(值), 45→46, 值 46-49→47-50）----
repl = [
    # 内层循环 phi 回边：增量 %41 -> %42
    ("%32 = phi i64 [ %41, %34 ], [ 0, %29 ]",
     "%32 = phi i64 [ %42, %34 ], [ 0, %29 ]"),
    # 内层循环退出分支：块 42 -> 43
    ("br i1 %33, label %34, label %42",
     "br i1 %33, label %34, label %43"),
    # 外层循环 phi：值 %44 -> %45，来源块 %43 -> %44
    ("%27 = phi i32 [ %44, %43 ], [ 0, %11 ]",
     "%27 = phi i32 [ %45, %44 ], [ 0, %11 ]"),
    # 外层循环退出分支：块 45 -> 46
    ("br i1 %28, label %29, label %45",
     "br i1 %28, label %29, label %46"),
    # block 42 定义 -> 43，其跳转目标 43 -> 44
    ("42:                                               ; preds = %31\n  br label %43",
     "43:                                               ; preds = %31\n  br label %44"),
    # block 43 定义 -> 44，值 %44 -> %45
    ("43:                                               ; preds = %42\n  %44 = add i32 %27, 1\n  br label %26",
     "44:                                               ; preds = %43\n  %45 = add i32 %27, 1\n  br label %26"),
    # block 45 定义 -> 46
    ("45:                                               ; preds = %26",
     "46:                                               ; preds = %26"),
    # 值 %46-%49 -> %47-%50
    ("  %46 = ptrtoint ptr addrspace(1) %2 to i64\n  %47 = mul i64 %16, 4\n  %48 = add i64 %46, %47\n  %49 = inttoptr i64 %48 to ptr addrspace(1)\n  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %49,",
     "  %47 = ptrtoint ptr addrspace(1) %2 to i64\n  %48 = mul i64 %16, 4\n  %49 = add i64 %47, %48\n  %50 = inttoptr i64 %49 to ptr addrspace(1)\n  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %50,"),
    # preds 注释更新（块 26 与块 25 的来源）
    ("26:                                               ; preds = %43, %11",
     "26:                                               ; preds = %44, %11"),
    ("25:                                               ; preds = %45, %4",
     "25:                                               ; preds = %46, %4"),
]
for old, new in repl:
    assert old in text, f"pattern not found: {old[:60]}..."
    text = text.replace(old, new)

open(DST, "w").write(text)
print(f"E3 v3 written: {DST}")

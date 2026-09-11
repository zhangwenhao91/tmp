; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

; t16: 3 层循环嵌套（外层 i32 metadata + 行 i64 + VL i64）+ 向量体在最内层（模拟 5_mixcv 结构）
define dso_local ptc_kernel void @k_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, i32 %4) #0 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  ret void
}

define dso_local ptc_kernel void @k_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, i32 %4) #1 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET1(i64 %8, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %11 = icmp eq i64 %10, 0
  br i1 %11, label %12, label %42

12:
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 1)
  br label %13

13:
  %14 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %15

15:
  %16 = phi i32 [ %40, %39 ], [ 0, %13 ]
  %17 = icmp sle i32 %16, 0
  br i1 %17, label %18, label %41

18:
  br label %19

19:
  %20 = phi i64 [ %37, %36 ], [ 0, %18 ]
  %21 = icmp slt i64 %20, 16
  br i1 %21, label %22, label %38

22:
  br label %23

23:
  %24 = phi i64 [ %35, %26 ], [ 0, %22 ]
  %25 = icmp slt i64 %24, 2
  br i1 %25, label %26, label %36

26:
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 1)
  %27 = mul i64 %20, 128
  %28 = mul i64 %24, 64
  %29 = add i64 %27, %28
  %30 = mul i64 %29, 4
  %31 = trunc i64 %30 to i32
  %32 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i32 %31, i32 0, i32 0)
  %33 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %31, i32 0, i32 0)
  %34 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %32, <64 x float> %33, <256 x i1> %14)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %34, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %31, i32 2, i32 0, <256 x i1> %14)
  %35 = add i64 %24, 1
  br label %23

36:
  %37 = add i64 %20, 1
  br label %19

38:
  br label %39

39:
  %40 = add i32 %16, 1
  br label %15, !llvm.loop !3

41:
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  br label %42

42:
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

declare i64 @llvm.hivm.GET.CTRL()
declare i64 @llvm.hivm.SBITSET0(i64, i64)
declare void @llvm.hivm.SET.CTRL(i64)
declare i64 @llvm.hivm.SBITSET1(i64, i64)
declare void @llvm.hivm.BARRIER(i64)
declare i64 @llvm.hivm.GET.SUBBLOCKID()
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)
declare <256 x i1> @llvm.hivm.pset.b32(i32)
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1, !2}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @k_mix_aic, !"kernel", i32 1}
!2 = !{ptr @k_mix_aiv, !"kernel", i32 1}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.aivector_scope"}

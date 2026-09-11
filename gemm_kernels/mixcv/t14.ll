; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

; t14: t13 + 循环回边带 aivector_scope metadata（对齐 FA）
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
  br i1 %11, label %12, label %25

12:
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 1)
  br label %13

13:
  %14 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %15

15:
  %16 = phi i64 [ %23, %18 ], [ 0, %13 ]
  %17 = icmp slt i64 %16, 16
  br i1 %17, label %18, label %24

18:
  %19 = mul i64 %16, 4
  %20 = trunc i64 %19 to i32
  %21 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %20, i32 0, i32 0)
  %22 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %21, float 2.000000e+00, <256 x i1> %14)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %22, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %20, i32 2, i32 0, <256 x i1> %14)
  %23 = add i64 %16, 1
  br label %15, !llvm.loop !3

24:
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  br label %25

25:
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
declare <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float>, float, <256 x i1>)
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

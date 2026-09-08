; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @reduce_max_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
  %4 = call i64 @llvm.hivm.GET.CTRL()
  %5 = call i64 @llvm.hivm.SBITSET0(i64 %4, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %5)
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET1(i64 %6, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %18

10:                                               ; preds = %3
  %11 = mul i32 %2, 16
  %12 = sext i32 %11 to i64
  %13 = mul i64 %12, 128
  %14 = ptrtoint ptr addrspace(1) %0 to i64
  %15 = mul i64 %13, 4
  %16 = add i64 %14, %15
  %17 = inttoptr i64 %16 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %17, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %19

18:                                               ; preds = %43, %3
  ret void

19:                                               ; preds = %41, %10
  %20 = phi i32 [ %42, %41 ], [ 0, %10 ]
  %21 = icmp sle i32 %20, 0
  br i1 %21, label %22, label %43

22:                                               ; preds = %19
  %23 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %24 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %25

25:                                               ; preds = %28, %22
  %26 = phi i64 [ %39, %28 ], [ 0, %22 ]
  %27 = icmp slt i64 %26, 16
  br i1 %27, label %28, label %40

28:                                               ; preds = %25
  %29 = trunc i64 %26 to i32
  %30 = mul i32 %29, 128
  %31 = mul i32 %29, 512
  %32 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %31, i32 0, i32 0)
  %33 = add i32 %30, 64
  %34 = mul i32 %33, 4
  %35 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %34, i32 0, i32 0)
  %36 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %32, <64 x float> %35, <256 x i1> %23)
  %37 = call <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float> %36, <256 x i1> %23)
  %38 = mul i32 %29, 4
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %37, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %38, i32 5, i32 0, <256 x i1> %24)
  %39 = add i64 %26, 1
  br label %25

40:                                               ; preds = %25
  br label %41

41:                                               ; preds = %40
  %42 = add i32 %20, 1
  br label %19, !llvm.loop !2

43:                                               ; preds = %19
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %44 = ptrtoint ptr addrspace(1) %1 to i64
  %45 = mul i64 %12, 4
  %46 = add i64 %44, %45
  %47 = inttoptr i64 %46 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %47, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225453600, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %18
}

; Unknown intrinsic
declare i64 @llvm.hivm.GET.CTRL()

; Unknown intrinsic
declare i64 @llvm.hivm.SBITSET0(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.CTRL(i64)

; Unknown intrinsic
declare i64 @llvm.hivm.SBITSET1(i64, i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @reduce_max_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
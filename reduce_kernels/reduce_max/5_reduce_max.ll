; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @reduce_max_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3) #0 {
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET0(i64 %5, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET1(i64 %7, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %11, label %21

11:                                               ; preds = %4
  %12 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %13 = trunc i64 %12 to i32
  %14 = mul i32 %13, 16
  %15 = sext i32 %14 to i64
  %16 = mul i64 %15, 128
  %17 = ptrtoint ptr addrspace(1) %2 to i64
  %18 = mul i64 %16, 4
  %19 = add i64 %17, %18
  %20 = inttoptr i64 %19 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %20, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %22

21:                                               ; preds = %46, %4
  ret void

22:                                               ; preds = %44, %11
  %23 = phi i32 [ %45, %44 ], [ 0, %11 ]
  %24 = icmp sle i32 %23, 0
  br i1 %24, label %25, label %46

25:                                               ; preds = %22
  %26 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %27 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %28

28:                                               ; preds = %31, %25
  %29 = phi i64 [ %42, %31 ], [ 0, %25 ]
  %30 = icmp slt i64 %29, 16
  br i1 %30, label %31, label %43

31:                                               ; preds = %28
  %32 = trunc i64 %29 to i32
  %33 = mul i32 %32, 128
  %34 = mul i32 %32, 512
  %35 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %34, i32 0, i32 0)
  %36 = add i32 %33, 64
  %37 = mul i32 %36, 4
  %38 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %37, i32 0, i32 0)
  %39 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %35, <64 x float> %38, <256 x i1> %26)
  %40 = call <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float> %39, <256 x i1> %26)
  %41 = mul i32 %32, 4
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %40, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %41, i32 5, i32 0, <256 x i1> %27)
  %42 = add i64 %29, 1
  br label %28

43:                                               ; preds = %28
  br label %44

44:                                               ; preds = %43
  %45 = add i32 %23, 1
  br label %22, !llvm.loop !2

46:                                               ; preds = %22
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %47 = ptrtoint ptr addrspace(1) %3 to i64
  %48 = mul i64 %15, 4
  %49 = add i64 %47, %48
  %50 = inttoptr i64 %49 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %50, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225453600, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %21
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
declare i64 @llvm.hivm.GET.BLOCK.IDX()

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
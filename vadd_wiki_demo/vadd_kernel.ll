; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @vadd_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4) #0 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET1(i64 %8, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %11 = icmp eq i64 %10, 0
  br i1 %11, label %12, label %25

12:                                               ; preds = %5
  %13 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %14 = trunc i64 %13 to i32
  %15 = mul i32 %14, 32
  %16 = sext i32 %15 to i64
  %17 = ptrtoint ptr addrspace(1) %2 to i64
  %18 = mul i64 %16, 4
  %19 = add i64 %17, %18
  %20 = inttoptr i64 %19 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %20, i64 288230377225469952, i64 35184372088864)
  %21 = ptrtoint ptr addrspace(1) %3 to i64
  %22 = mul i64 %16, 4
  %23 = add i64 %21, %22
  %24 = inttoptr i64 %23 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), ptr addrspace(1) %24, i64 288230377225469952, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %26

25:                                               ; preds = %49, %5
  ret void

26:                                               ; preds = %47, %12
  %27 = phi i32 [ %48, %47 ], [ 0, %12 ]
  %28 = icmp sle i32 %27, 0
  br i1 %28, label %29, label %49

29:                                               ; preds = %26
  br label %30

30:                                               ; preds = %33, %29
  %31 = phi i64 [ %45, %33 ], [ 0, %29 ]
  %32 = icmp slt i64 %31, 128
  br i1 %32, label %33, label %46

33:                                               ; preds = %30
  %34 = mul i64 %31, 64
  %35 = mul i64 %34, 4
  %36 = getelementptr i8, ptr addrspace(6) null, i64 %35
  %37 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %36, i32 0, i32 0, i32 0)
  %38 = mul i64 %34, 4
  %39 = getelementptr i8, ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i64 %38
  %40 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %39, i32 0, i32 0, i32 0)
  %41 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %42 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %37, <64 x float> %40, <256 x i1> %41)
  %43 = mul i64 %34, 4
  %44 = getelementptr i8, ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i64 %43
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %42, ptr addrspace(6) %44, i32 0, i32 2, i32 0, <256 x i1> %41)
  %45 = add i64 %31, 1
  br label %30

46:                                               ; preds = %30
  br label %47

47:                                               ; preds = %46
  %48 = add i32 %27, 1
  br label %26, !llvm.loop !2

49:                                               ; preds = %26
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %50 = ptrtoint ptr addrspace(1) %4 to i64
  %51 = mul i64 %16, 4
  %52 = add i64 %50, %51
  %53 = inttoptr i64 %52 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %53, ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i64 288230377225469952, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %25
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
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @vadd_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
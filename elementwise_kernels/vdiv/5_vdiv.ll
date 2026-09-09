; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @vdiv_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3) #0 {
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET0(i64 %5, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET1(i64 %7, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %11, label %25

11:                                               ; preds = %4
  %12 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %13 = trunc i64 %12 to i32
  %14 = mul i32 %13, 16
  %15 = sext i32 %14 to i64
  %16 = mul i64 %15, 128
  %17 = ptrtoint ptr addrspace(1) %0 to i64
  %18 = mul i64 %16, 4
  %19 = add i64 %17, %18
  %20 = inttoptr i64 %19 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %20, i64 288230377225457664, i64 35184372088864)
  %21 = ptrtoint ptr addrspace(1) %1 to i64
  %22 = mul i64 %16, 4
  %23 = add i64 %21, %22
  %24 = inttoptr i64 %23 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), ptr addrspace(1) %24, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %26

25:                                               ; preds = %45, %4
  ret void

26:                                               ; preds = %43, %11
  %27 = phi i32 [ %44, %43 ], [ 0, %11 ]
  %28 = icmp sle i32 %27, 0
  br i1 %28, label %29, label %45

29:                                               ; preds = %26
  %30 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %31

31:                                               ; preds = %34, %29
  %32 = phi i64 [ %41, %34 ], [ 0, %29 ]
  %33 = icmp slt i64 %32, 32
  br i1 %33, label %34, label %42

34:                                               ; preds = %31
  %35 = mul i64 %32, 64
  %36 = trunc i64 %35 to i32
  %37 = mul i32 %36, 4
  %38 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %37, i32 0, i32 0)
  %39 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %37, i32 0, i32 0)
  %40 = call <64 x float> @llvm.hivm.vdiv.s.x.v64f32(<64 x float> %38, <64 x float> %39, <256 x i1> %30)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %40, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i32 %37, i32 2, i32 0, <256 x i1> %30)
  %41 = add i64 %32, 1
  br label %31

42:                                               ; preds = %31
  br label %43

43:                                               ; preds = %42
  %44 = add i32 %27, 1
  br label %26, !llvm.loop !2

45:                                               ; preds = %26
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %46 = ptrtoint ptr addrspace(1) %2 to i64
  %47 = mul i64 %16, 4
  %48 = add i64 %46, %47
  %49 = inttoptr i64 %48 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %49, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 288230377225457664, i64 35184372088864)
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
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vdiv.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @vdiv_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
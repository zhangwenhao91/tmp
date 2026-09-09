; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @vmuls_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3) #0 {
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET0(i64 %5, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET1(i64 %7, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %11, label %23

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
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  %21 = ptrtoint ptr addrspace(1) %1 to i64
  %22 = inttoptr i64 %21 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), ptr addrspace(1) %22, i64 288230376285929488, i64 4398046511108)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 0, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 0, i64 0)
  br label %24

23:                                               ; preds = %44, %4
  ret void

24:                                               ; preds = %42, %11
  %25 = phi i32 [ %43, %42 ], [ 0, %11 ]
  %26 = icmp sle i32 %25, 0
  br i1 %26, label %27, label %44

27:                                               ; preds = %24
  %28 = load float, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), align 4
  %29 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %30

30:                                               ; preds = %33, %27
  %31 = phi i64 [ %40, %33 ], [ 0, %27 ]
  %32 = icmp slt i64 %31, 32
  br i1 %32, label %33, label %41

33:                                               ; preds = %30
  %34 = mul i64 %31, 64
  %35 = trunc i64 %34 to i32
  %36 = mul i32 %35, 4
  %37 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %36, i32 0, i32 0)
  %38 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float %28, <256 x i1> %29, i32 0)
  %39 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %37, <64 x float> %38, <256 x i1> %29)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %39, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %36, i32 2, i32 0, <256 x i1> %29)
  %40 = add i64 %31, 1
  br label %30

41:                                               ; preds = %30
  br label %42

42:                                               ; preds = %41
  %43 = add i32 %25, 1
  br label %24, !llvm.loop !2

44:                                               ; preds = %24
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %45 = ptrtoint ptr addrspace(1) %2 to i64
  %46 = mul i64 %16, 4
  %47 = add i64 %45, %46
  %48 = inttoptr i64 %47 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %48, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %23
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
declare <64 x float> @llvm.hivm.vdups.z.v64f32(float, <256 x i1>, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @vmuls_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
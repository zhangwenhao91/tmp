; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @ub2ub_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
  %4 = call i64 @llvm.hivm.GET.CTRL()
  %5 = call i64 @llvm.hivm.SBITSET0(i64 %4, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %5)
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET1(i64 %6, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %20

10:                                               ; preds = %3
  %11 = ptrtoint ptr addrspace(1) %0 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %12, i64 288230377225486336, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %13

13:                                               ; preds = %41, %10
  %14 = phi i64 [ %42, %41 ], [ 0, %10 ]
  %15 = icmp slt i64 %14, 16
  br i1 %15, label %16, label %17

16:                                               ; preds = %13
  br label %21

17:                                               ; preds = %13
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %18 = ptrtoint ptr addrspace(1) %1 to i64
  %19 = inttoptr i64 %18 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %19, ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i64 288230377225486336, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %20

20:                                               ; preds = %17, %3
  ret void

21:                                               ; preds = %39, %16
  %22 = phi i32 [ %40, %39 ], [ 0, %16 ]
  %23 = icmp sle i32 %22, 0
  br i1 %23, label %24, label %41

24:                                               ; preds = %21
  %25 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %26

26:                                               ; preds = %29, %24
  %27 = phi i64 [ %37, %29 ], [ 0, %24 ]
  %28 = icmp slt i64 %27, 256
  br i1 %28, label %29, label %38

29:                                               ; preds = %26
  %30 = trunc i64 %27 to i32
  %31 = mul i32 %30, 256
  %32 = sext i32 %31 to i64
  %33 = getelementptr i8, ptr addrspace(6) null, i64 %32
  %34 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %33, i32 0, i32 0, i32 0)
  %35 = sext i32 %31 to i64
  %36 = getelementptr i8, ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i64 %35
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %34, ptr addrspace(6) %36, i32 0, i32 2, i32 0, <256 x i1> %25)
  %37 = add i64 %27, 1
  br label %26

38:                                               ; preds = %26
  br label %39

39:                                               ; preds = %38
  %40 = add i32 %22, 1
  br label %21, !llvm.loop !2

41:                                               ; preds = %21
  %42 = add i64 %14, 1
  br label %13
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
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @ub2ub_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @reduce_sum_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
  %4 = call i64 @llvm.hivm.GET.CTRL()
  %5 = call i64 @llvm.hivm.SBITSET0(i64 %4, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %5)
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET1(i64 %6, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %13

10:                                               ; preds = %3
  %11 = ptrtoint ptr addrspace(1) %0 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %12, i64 288230377225461760, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %14

13:                                               ; preds = %33, %3
  ret void

14:                                               ; preds = %31, %10
  %15 = phi i32 [ %32, %31 ], [ 0, %10 ]
  %16 = icmp sle i32 %15, 0
  br i1 %16, label %17, label %33

17:                                               ; preds = %14
  br label %18

18:                                               ; preds = %21, %17
  %19 = phi i64 [ %29, %21 ], [ 0, %17 ]
  %20 = icmp slt i64 %19, 32
  br i1 %20, label %21, label %30

21:                                               ; preds = %18
  %22 = mul i64 %19, 128
  %23 = mul i64 %22, 4
  %24 = getelementptr i8, ptr addrspace(6) null, i64 %23
  %25 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %24, i32 0, i32 0, i32 0)
  %26 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  %27 = mul i64 %19, 4
  %28 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %27
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %25, ptr addrspace(6) %28, i32 0, i32 2, i32 0, <256 x i1> %26)
  %29 = add i64 %19, 1
  br label %18

30:                                               ; preds = %18
  br label %31

31:                                               ; preds = %30
  %32 = add i32 %15, 1
  br label %14, !llvm.loop !2

33:                                               ; preds = %14
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %34 = ptrtoint ptr addrspace(1) %1 to i64
  %35 = inttoptr i64 %34 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %35, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 288230377225453632, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
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
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @reduce_sum_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}

; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @reduce_abssum_frag_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
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
  %11 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %12 = trunc i64 %11 to i32
  %13 = mul i32 %12, 16
  %14 = sext i32 %13 to i64
  %15 = mul i64 %14, 128
  %16 = ptrtoint ptr addrspace(1) %0 to i64
  %17 = mul i64 %15, 4
  %18 = add i64 %16, %17
  %19 = inttoptr i64 %18 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %19, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %21

20:                                               ; preds = %55, %3
  ret void

21:                                               ; preds = %53, %10
  %22 = phi i32 [ %54, %53 ], [ 0, %10 ]
  %23 = icmp sle i32 %22, 0
  br i1 %23, label %24, label %55

24:                                               ; preds = %21
  %25 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %26 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %27

27:                                               ; preds = %30, %24
  %28 = phi i64 [ %51, %30 ], [ 0, %24 ]
  %29 = icmp slt i64 %28, 16
  br i1 %29, label %30, label %52

30:                                               ; preds = %27
  %31 = trunc i64 %28 to i32
  %32 = mul i32 %31, 128
  %33 = mul i32 %31, 512
  %34 = sext i32 %33 to i64
  %35 = getelementptr i8, ptr addrspace(6) null, i64 %34
  %36 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %35, i32 0, i32 0, i32 0)
  %37 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %36, float -1.000000e+00, <256 x i1> %25)
  %38 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %36, <64 x float> %37, <256 x i1> %25)
  %39 = add i32 %32, 64
  %40 = mul i32 %39, 4
  %41 = sext i32 %40 to i64
  %42 = getelementptr i8, ptr addrspace(6) null, i64 %41
  %43 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %42, i32 0, i32 0, i32 0)
  %44 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %43, float -1.000000e+00, <256 x i1> %25)
  %45 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %43, <64 x float> %44, <256 x i1> %25)
  %46 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %38, <64 x float> %45, <256 x i1> %25)
  %47 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %46, <256 x i1> %25)
  %48 = mul i32 %31, 4
  %49 = sext i32 %48 to i64
  %50 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %49
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %47, ptr addrspace(6) %50, i32 0, i32 5, i32 0, <256 x i1> %26)
  %51 = add i64 %28, 1
  br label %27

52:                                               ; preds = %27
  br label %53

53:                                               ; preds = %52
  %54 = add i32 %22, 1
  br label %21, !llvm.loop !2

55:                                               ; preds = %21
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  %56 = mul i32 %12, 16
  %57 = sext i32 %56 to i64
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %58 = ptrtoint ptr addrspace(1) %1 to i64
  %59 = mul i64 %57, 4
  %60 = add i64 %58, %59
  %61 = inttoptr i64 %60 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %61, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225453600, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %20
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
declare <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float>, float, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @reduce_abssum_frag_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
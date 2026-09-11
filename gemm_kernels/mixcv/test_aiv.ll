; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @mixCV_kernel_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, i32 %4) #1 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET1(i64 %8, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %11 = icmp eq i64 %10, 0
  br i1 %11, label %12, label %15

12:                                               ; preds = %5
  %13 = ptrtoint ptr addrspace(1) %2 to i64
  %14 = inttoptr i64 %13 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %14, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %16

15:                                               ; preds = %47, %5
  ret void

16:                                               ; preds = %45, %12
  %17 = phi i32 [ %46, %45 ], [ 0, %12 ]
  %18 = icmp sle i32 %17, 0
  br i1 %18, label %19, label %47

19:                                               ; preds = %16
  br label %20

20:                                               ; preds = %42, %19
  %21 = phi i64 [ %43, %42 ], [ 0, %19 ]
  %22 = icmp slt i64 %21, 16
  br i1 %22, label %23, label %44

23:                                               ; preds = %20
  br label %24

24:                                               ; preds = %27, %23
  %25 = phi i64 [ %41, %27 ], [ 0, %23 ]
  %26 = icmp slt i64 %25, 2
  br i1 %26, label %27, label %42

27:                                               ; preds = %24
  %28 = mul i64 %21, 128
  %29 = mul i64 %25, 64
  %30 = add i64 %28, %29
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 1)
  %31 = mul i64 %30, 4
  %32 = trunc i64 %31 to i32
  %33 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i32 %32, i32 0, i32 0)
  %34 = mul i64 %30, 4
  %35 = trunc i64 %34 to i32
  %36 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %35, i32 0, i32 0)
  %37 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %38 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %33, <64 x float> %36, <256 x i1> %37)
  %39 = mul i64 %30, 4
  %40 = trunc i64 %39 to i32
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %38, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %40, i32 2, i32 0, <256 x i1> %37)
  %41 = add i64 %25, 1
  br label %24

42:                                               ; preds = %24
  %43 = add i64 %21, 1
  br label %20

44:                                               ; preds = %20
  br label %45

45:                                               ; preds = %44
  %46 = add i32 %17, 1
  br label %16, !llvm.loop !3

47:                                               ; preds = %16
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %48 = ptrtoint ptr addrspace(1) %3 to i64
  %49 = inttoptr i64 %48 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %49, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %15
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
declare void @llvm.hivm.SET.MTE2.NZ.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.f32(ptr addrspace(3), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.f32(ptr addrspace(4), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MAD.f322f32.c310(ptr addrspace(5), ptr addrspace(3), ptr addrspace(4), i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.LOOP3.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @mixCV_kernel_mix_aiv, !"kernel", i32 1}
!1 = !{ptr @mixCV_kernel_mix_aiv, !"kernel", i32 1}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.aivector_scope"}
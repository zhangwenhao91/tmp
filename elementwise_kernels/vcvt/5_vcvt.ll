; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @vcvt_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
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

20:                                               ; preds = %44, %3
  ret void

21:                                               ; preds = %42, %10
  %22 = phi i32 [ %43, %42 ], [ 0, %10 ]
  %23 = icmp sle i32 %22, 0
  br i1 %23, label %24, label %44

24:                                               ; preds = %21
  %25 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %26

26:                                               ; preds = %29, %24
  %27 = phi i64 [ %40, %29 ], [ 0, %24 ]
  %28 = icmp slt i64 %27, 32
  br i1 %28, label %29, label %41

29:                                               ; preds = %26
  %30 = trunc i64 %27 to i32
  %31 = udiv i32 %30, 32
  %32 = urem i32 %30, 32
  %33 = mul i32 %32, 64
  %34 = mul i32 %31, 2048
  %35 = add i32 %34, %33
  %36 = mul i32 %35, 4
  %37 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %36, i32 0, i32 0)
  %38 = call <128 x half> @llvm.hivm.vcvtff.f322f16.x(<64 x float> %37, <256 x i1> %25, i32 0, i32 0, i32 0)
  %39 = mul i32 %35, 2
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %38, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %39, i32 7, i32 0, <256 x i1> %25)
  %40 = add i64 %27, 1
  br label %26

41:                                               ; preds = %26
  br label %42

42:                                               ; preds = %41
  %43 = add i32 %22, 1
  br label %21, !llvm.loop !2

44:                                               ; preds = %21
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %45 = ptrtoint ptr addrspace(1) %1 to i64
  %46 = mul i64 %15, 2
  %47 = add i64 %45, %46
  %48 = inttoptr i64 %47 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %48, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225455616, i64 35184372088864)
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
declare <128 x half> @llvm.hivm.vcvtff.f322f16.x(<64 x float>, <256 x i1>, i32, i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v128f16(<128 x half>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @vcvt_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
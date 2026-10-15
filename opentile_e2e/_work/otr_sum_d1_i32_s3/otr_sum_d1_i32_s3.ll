; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @otr_sum_d1_i32_s3(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
  %3 = call i64 @llvm.hivm.GET.CTRL()
  %4 = call i64 @llvm.hivm.SBITSET0(i64 %3, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %4)
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET1(i64 %5, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %2
  br label %11

10:                                               ; preds = %56, %2
  ret void

11:                                               ; preds = %28, %9
  %12 = phi i32 [ %29, %28 ], [ 0, %9 ]
  %13 = icmp sle i32 %12, 0
  br i1 %13, label %14, label %30

14:                                               ; preds = %11
  %15 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %16

16:                                               ; preds = %19, %14
  %17 = phi i64 [ %26, %19 ], [ 0, %14 ]
  %18 = icmp slt i64 %17, 32
  br i1 %18, label %19, label %27

19:                                               ; preds = %16
  %20 = mul i64 %17, 64
  %21 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %15, i32 0)
  %22 = trunc i64 %20 to i32
  %23 = mul i32 %22, 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr i8, ptr addrspace(6) null, i64 %24
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %21, ptr addrspace(6) %25, i32 0, i32 2, i32 0, <256 x i1> %15)
  %26 = add i64 %17, 1
  br label %16

27:                                               ; preds = %16
  br label %28

28:                                               ; preds = %27
  %29 = add i32 %12, 1
  br label %11, !llvm.loop !2

30:                                               ; preds = %11
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  %31 = ptrtoint ptr addrspace(1) %0 to i64
  %32 = inttoptr i64 %31 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %32, i64 288230382594163200, i64 281474976710848)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %33

33:                                               ; preds = %54, %30
  %34 = phi i32 [ %55, %54 ], [ 0, %30 ]
  %35 = icmp sle i32 %34, 0
  br i1 %35, label %36, label %56

36:                                               ; preds = %33
  %37 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %38 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %39

39:                                               ; preds = %42, %36
  %40 = phi i64 [ %52, %42 ], [ 0, %36 ]
  %41 = icmp slt i64 %40, 32
  br i1 %41, label %42, label %53

42:                                               ; preds = %39
  %43 = trunc i64 %40 to i32
  %44 = mul i32 %43, 256
  %45 = sext i32 %44 to i64
  %46 = getelementptr i8, ptr addrspace(6) null, i64 %45
  %47 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) %46, i32 0, i32 0, i32 0)
  %48 = call <64 x i32> @llvm.hivm.vcadd.s.x.v64i32(<64 x i32> %47, <256 x i1> %37)
  %49 = mul i32 %43, 4
  %50 = sext i32 %49 to i64
  %51 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %50
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %48, ptr addrspace(6) %51, i32 0, i32 5, i32 0, <256 x i1> %38)
  %52 = add i64 %40, 1
  br label %39

53:                                               ; preds = %39
  br label %54

54:                                               ; preds = %53
  %55 = add i32 %34, 1
  br label %33, !llvm.loop !4

56:                                               ; preds = %33
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %57 = ptrtoint ptr addrspace(1) %1 to i64
  %58 = inttoptr i64 %57 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %58, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225453632, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %10
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
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vcadd.s.x.v64i32(<64 x i32>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64s32(<64 x i32>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vdups.z.v64i32(i32, <256 x i1>, i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @otr_sum_d1_i32_s3, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
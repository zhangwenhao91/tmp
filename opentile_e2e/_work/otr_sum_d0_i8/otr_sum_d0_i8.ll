; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @otr_sum_d0_i8(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
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

10:                                               ; preds = %55, %2
  ret void

11:                                               ; preds = %27, %9
  %12 = phi i32 [ %28, %27 ], [ 0, %9 ]
  %13 = icmp sle i32 %12, 0
  br i1 %13, label %14, label %29

14:                                               ; preds = %11
  %15 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  br label %16

16:                                               ; preds = %19, %14
  %17 = phi i64 [ %25, %19 ], [ 0, %14 ]
  %18 = icmp slt i64 %17, 8
  br i1 %18, label %19, label %26

19:                                               ; preds = %16
  %20 = mul i64 %17, 256
  %21 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %15, i32 0)
  %22 = trunc i64 %20 to i32
  %23 = sext i32 %22 to i64
  %24 = getelementptr i8, ptr addrspace(6) null, i64 %23
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %21, ptr addrspace(6) %24, i32 0, i32 0, i32 0, <256 x i1> %15)
  %25 = add i64 %17, 1
  br label %16

26:                                               ; preds = %16
  br label %27

27:                                               ; preds = %26
  %28 = add i32 %12, 1
  br label %11, !llvm.loop !2

29:                                               ; preds = %11
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  %30 = ptrtoint ptr addrspace(1) %0 to i64
  %31 = inttoptr i64 %30 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.s8.DV(ptr addrspace(6) null, ptr addrspace(1) %31, i64 288230376688583680, i64 35184372088848)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %32

32:                                               ; preds = %53, %29
  %33 = phi i32 [ %54, %53 ], [ 0, %29 ]
  %34 = icmp sle i32 %33, 0
  br i1 %34, label %35, label %55

35:                                               ; preds = %32
  %36 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 32)
  %37 = extractvalue { <256 x i1>, i32 } %36, 0
  %38 = extractvalue { <256 x i1>, i32 } %36, 1
  %39 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %37, i32 0)
  br label %40

40:                                               ; preds = %44, %35
  %41 = phi i64 [ %51, %44 ], [ 0, %35 ]
  %42 = phi <256 x i8> [ %50, %44 ], [ %39, %35 ]
  %43 = icmp slt i64 %41, 64
  br i1 %43, label %44, label %52

44:                                               ; preds = %40
  %45 = trunc i64 %41 to i32
  %46 = mul i32 %45, 32
  %47 = sext i32 %46 to i64
  %48 = getelementptr i8, ptr addrspace(6) null, i64 %47
  %49 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %48, i32 0, i32 0, i32 0)
  %50 = call <256 x i8> @llvm.hivm.vadd.s.x.v256i8(<256 x i8> %42, <256 x i8> %49, <256 x i1> %37)
  %51 = add i64 %41, 1
  br label %40

52:                                               ; preds = %40
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %42, ptr addrspace(6) inttoptr (i64 2048 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %37)
  br label %53

53:                                               ; preds = %52
  %54 = add i32 %33, 1
  br label %32, !llvm.loop !4

55:                                               ; preds = %32
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %56 = ptrtoint ptr addrspace(1) %1 to i64
  %57 = inttoptr i64 %56 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %57, ptr addrspace(6) inttoptr (i64 2048 to ptr addrspace(6)), i64 288230376688582672, i64 17592186044432)
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
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.s8.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vdups.z.v256i8(i8, <256 x i1>, i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v256s8(<256 x i8>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vadd.s.x.v256i8(<256 x i8>, <256 x i8>, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b8(i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @otr_sum_d0_i8, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
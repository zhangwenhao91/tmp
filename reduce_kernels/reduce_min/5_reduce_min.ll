; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @reduce_min_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
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

20:                                               ; preds = %59, %3
  ret void

21:                                               ; preds = %45, %10
  %22 = phi i32 [ %46, %45 ], [ 0, %10 ]
  %23 = icmp sle i32 %22, 0
  br i1 %23, label %24, label %47

24:                                               ; preds = %21
  %25 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %26 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %27

27:                                               ; preds = %30, %24
  %28 = phi i64 [ %43, %30 ], [ 0, %24 ]
  %29 = icmp slt i64 %28, 16
  br i1 %29, label %30, label %44

30:                                               ; preds = %27
  %31 = trunc i64 %28 to i32
  %32 = mul i32 %31, 128
  %33 = mul i32 %31, 512
  %34 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %33, i32 0, i32 0)
  %35 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %34, float -1.000000e+00, <256 x i1> %25)
  %36 = add i32 %32, 64
  %37 = mul i32 %36, 4
  %38 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %37, i32 0, i32 0)
  %39 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %38, float -1.000000e+00, <256 x i1> %25)
  %40 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %35, <64 x float> %39, <256 x i1> %25)
  %41 = call <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float> %40, <256 x i1> %25)
  %42 = mul i32 %31, 4
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %41, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %42, i32 5, i32 0, <256 x i1> %26)
  %43 = add i64 %28, 1
  br label %27

44:                                               ; preds = %27
  br label %45

45:                                               ; preds = %44
  %46 = add i32 %22, 1
  br label %21, !llvm.loop !2

47:                                               ; preds = %21
  br label %48

48:                                               ; preds = %57, %47
  %49 = phi i32 [ %58, %57 ], [ 0, %47 ]
  %50 = icmp sle i32 %49, 0
  br i1 %50, label %51, label %59

51:                                               ; preds = %48
  %52 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %53 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 16)
  %54 = extractvalue { <256 x i1>, i32 } %53, 0
  %55 = extractvalue { <256 x i1>, i32 } %53, 1
  %56 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %52, float -1.000000e+00, <256 x i1> %54)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %56, ptr addrspace(6) inttoptr (i64 8256 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %54)
  br label %57

57:                                               ; preds = %51
  %58 = add i32 %49, 1
  br label %48, !llvm.loop !4

59:                                               ; preds = %48
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %60 = ptrtoint ptr addrspace(1) %1 to i64
  %61 = mul i64 %14, 4
  %62 = add i64 %60, %61
  %63 = inttoptr i64 %62 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %63, ptr addrspace(6) inttoptr (i64 8256 to ptr addrspace(6)), i64 288230377225453600, i64 35184372088864)
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
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float>, float, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float>, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @reduce_min_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @triton_sum_dim1(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
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

10:                                               ; preds = %100, %2
  ret void

11:                                               ; preds = %28, %9
  %12 = phi i32 [ %29, %28 ], [ 0, %9 ]
  %13 = icmp sle i32 %12, 0
  br i1 %13, label %14, label %30

14:                                               ; preds = %11
  %15 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %16

16:                                               ; preds = %19, %14
  %17 = phi i64 [ %26, %19 ], [ 0, %14 ]
  %18 = icmp slt i64 %17, 8
  br i1 %18, label %19, label %27

19:                                               ; preds = %16
  %20 = mul i64 %17, 128
  %21 = call <128 x half> @llvm.hivm.vdups.z.v128f16(half 0xH0000, <256 x i1> %15, i32 0)
  %22 = trunc i64 %20 to i32
  %23 = mul i32 %22, 2
  %24 = sext i32 %23 to i64
  %25 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), i64 %24
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %21, ptr addrspace(6) %25, i32 0, i32 1, i32 0, <256 x i1> %15)
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
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), ptr addrspace(1) %32, i64 288230376353039248, i64 35184372088838)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %33

33:                                               ; preds = %62, %30
  %34 = phi i32 [ %63, %62 ], [ 0, %30 ]
  %35 = icmp sle i32 %34, 0
  br i1 %35, label %36, label %64

36:                                               ; preds = %33
  %37 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  %38 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %39

39:                                               ; preds = %42, %36
  %40 = phi i64 [ %60, %42 ], [ 0, %36 ]
  %41 = icmp slt i64 %40, 8
  br i1 %41, label %42, label %61

42:                                               ; preds = %39
  %43 = trunc i64 %40 to i32
  %44 = mul i32 %43, 256
  %45 = mul i32 %43, 512
  %46 = sext i32 %44 to i64
  %47 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), i64 %46
  %48 = call <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6) %47, i32 0, i32 14, i32 0)
  %49 = call <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half> %48, <256 x i1> %37, i32 0)
  %50 = sext i32 %45 to i64
  %51 = getelementptr i8, ptr addrspace(6) null, i64 %50
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %49, ptr addrspace(6) %51, i32 0, i32 2, i32 0, <256 x i1> %38)
  %52 = add i32 %44, 128
  %53 = add i32 %45, 256
  %54 = sext i32 %52 to i64
  %55 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), i64 %54
  %56 = call <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6) %55, i32 0, i32 14, i32 0)
  %57 = call <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half> %56, <256 x i1> %37, i32 0)
  %58 = sext i32 %53 to i64
  %59 = getelementptr i8, ptr addrspace(6) null, i64 %58
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %57, ptr addrspace(6) %59, i32 0, i32 2, i32 0, <256 x i1> %38)
  %60 = add i64 %40, 1
  br label %39

61:                                               ; preds = %39
  br label %62

62:                                               ; preds = %61
  %63 = add i32 %34, 1
  br label %33, !llvm.loop !4

64:                                               ; preds = %33
  br label %65

65:                                               ; preds = %88, %64
  %66 = phi i32 [ %89, %88 ], [ 0, %64 ]
  %67 = icmp sle i32 %66, 0
  br i1 %67, label %68, label %90

68:                                               ; preds = %65
  %69 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 16)
  %70 = extractvalue { <256 x i1>, i32 } %69, 0
  %71 = extractvalue { <256 x i1>, i32 } %69, 1
  %72 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %73

73:                                               ; preds = %76, %68
  %74 = phi i64 [ %86, %76 ], [ 0, %68 ]
  %75 = icmp slt i64 %74, 64
  br i1 %75, label %76, label %87

76:                                               ; preds = %73
  %77 = trunc i64 %74 to i32
  %78 = mul i32 %77, 64
  %79 = sext i32 %78 to i64
  %80 = getelementptr i8, ptr addrspace(6) null, i64 %79
  %81 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %80, i32 0, i32 0, i32 0)
  %82 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %81, <256 x i1> %70)
  %83 = mul i32 %77, 4
  %84 = sext i32 %83 to i64
  %85 = getelementptr i8, ptr addrspace(6) inttoptr (i64 6144 to ptr addrspace(6)), i64 %84
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %82, ptr addrspace(6) %85, i32 0, i32 5, i32 0, <256 x i1> %72)
  %86 = add i64 %74, 1
  br label %73

87:                                               ; preds = %73
  br label %88

88:                                               ; preds = %87
  %89 = add i32 %66, 1
  br label %65, !llvm.loop !5

90:                                               ; preds = %65
  br label %91

91:                                               ; preds = %98, %90
  %92 = phi i32 [ %99, %98 ], [ 0, %90 ]
  %93 = icmp sle i32 %92, 0
  br i1 %93, label %94, label %100

94:                                               ; preds = %91
  %95 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %96 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 6144 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %97 = call <128 x half> @llvm.hivm.vcvtff.f322f16.x(<64 x float> %96, <256 x i1> %95, i32 0, i32 0, i32 0)
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %97, ptr addrspace(6) inttoptr (i64 6400 to ptr addrspace(6)), i32 0, i32 7, i32 0, <256 x i1> %95)
  br label %98

98:                                               ; preds = %94
  %99 = add i32 %92, 1
  br label %91, !llvm.loop !6

100:                                              ; preds = %91
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %101 = ptrtoint ptr addrspace(1) %1 to i64
  %102 = inttoptr i64 %101 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %102, ptr addrspace(6) inttoptr (i64 6400 to ptr addrspace(6)), i64 288230379976917008, i64 125344325566578)
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
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

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

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b16(i32)

; Unknown intrinsic
declare <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half>, <256 x i1>, i32)

; Unknown intrinsic
declare <128 x half> @llvm.hivm.vdups.z.v128f16(half, <256 x i1>, i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @triton_sum_dim1, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
!5 = distinct !{!5, !3}
!6 = distinct !{!6, !3}
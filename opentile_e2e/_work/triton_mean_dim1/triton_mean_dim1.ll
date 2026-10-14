; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @triton_mean_dim1(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
  %3 = call i64 @llvm.hivm.GET.CTRL()
  %4 = call i64 @llvm.hivm.SBITSET0(i64 %3, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %4)
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET1(i64 %5, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %9, label %23

9:                                                ; preds = %2
  br label %24

10:                                               ; preds = %13, %43
  %11 = phi i64 [ 0, %43 ], [ %21, %13 ]
  %12 = icmp slt i64 %11, 263
  br i1 %12, label %13, label %22

13:                                               ; preds = %10
  %14 = ptrtoint ptr addrspace(1) %0 to i64
  %15 = inttoptr i64 %14 to ptr addrspace(1)
  %16 = getelementptr half, ptr addrspace(1) %15, i64 %11
  %17 = load half, ptr addrspace(1) %16, align 2
  %18 = mul i64 %11, 8
  %19 = mul i64 %18, 2
  %20 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %19
  store half %17, ptr addrspace(6) %20, align 2
  %21 = add i64 %11, 1
  br label %10

22:                                               ; preds = %10
  call void @llvm.hivm.BARRIER(i64 6)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %44

23:                                               ; preds = %129, %2
  ret void

24:                                               ; preds = %41, %9
  %25 = phi i32 [ %42, %41 ], [ 0, %9 ]
  %26 = icmp sle i32 %25, 0
  br i1 %26, label %27, label %43

27:                                               ; preds = %24
  %28 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %29

29:                                               ; preds = %32, %27
  %30 = phi i64 [ %39, %32 ], [ 0, %27 ]
  %31 = icmp slt i64 %30, 32
  br i1 %31, label %32, label %40

32:                                               ; preds = %29
  %33 = mul i64 %30, 128
  %34 = call <128 x half> @llvm.hivm.vdups.z.v128f16(half 0xH0000, <256 x i1> %28, i32 0)
  %35 = trunc i64 %33 to i32
  %36 = mul i32 %35, 2
  %37 = sext i32 %36 to i64
  %38 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %37
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %34, ptr addrspace(6) %38, i32 0, i32 1, i32 0, <256 x i1> %28)
  %39 = add i64 %30, 1
  br label %29

40:                                               ; preds = %29
  br label %41

41:                                               ; preds = %40
  %42 = add i32 %25, 1
  br label %24, !llvm.loop !2

43:                                               ; preds = %24
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %10

44:                                               ; preds = %73, %22
  %45 = phi i32 [ %74, %73 ], [ 0, %22 ]
  %46 = icmp sle i32 %45, 0
  br i1 %46, label %47, label %75

47:                                               ; preds = %44
  %48 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  %49 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %50

50:                                               ; preds = %53, %47
  %51 = phi i64 [ %71, %53 ], [ 0, %47 ]
  %52 = icmp slt i64 %51, 32
  br i1 %52, label %53, label %72

53:                                               ; preds = %50
  %54 = trunc i64 %51 to i32
  %55 = mul i32 %54, 256
  %56 = mul i32 %54, 512
  %57 = sext i32 %55 to i64
  %58 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %57
  %59 = call <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6) %58, i32 0, i32 14, i32 0)
  %60 = call <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half> %59, <256 x i1> %48, i32 0)
  %61 = sext i32 %56 to i64
  %62 = getelementptr i8, ptr addrspace(6) null, i64 %61
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %60, ptr addrspace(6) %62, i32 0, i32 2, i32 0, <256 x i1> %49)
  %63 = add i32 %55, 128
  %64 = add i32 %56, 256
  %65 = sext i32 %63 to i64
  %66 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %65
  %67 = call <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6) %66, i32 0, i32 14, i32 0)
  %68 = call <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half> %67, <256 x i1> %48, i32 0)
  %69 = sext i32 %64 to i64
  %70 = getelementptr i8, ptr addrspace(6) null, i64 %69
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %68, ptr addrspace(6) %70, i32 0, i32 2, i32 0, <256 x i1> %49)
  %71 = add i64 %51, 1
  br label %50

72:                                               ; preds = %50
  br label %73

73:                                               ; preds = %72
  %74 = add i32 %45, 1
  br label %44, !llvm.loop !4

75:                                               ; preds = %44
  br label %76

76:                                               ; preds = %99, %75
  %77 = phi i32 [ %100, %99 ], [ 0, %75 ]
  %78 = icmp sle i32 %77, 0
  br i1 %78, label %79, label %101

79:                                               ; preds = %76
  %80 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 8)
  %81 = extractvalue { <256 x i1>, i32 } %80, 0
  %82 = extractvalue { <256 x i1>, i32 } %80, 1
  %83 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %84

84:                                               ; preds = %87, %79
  %85 = phi i64 [ %97, %87 ], [ 0, %79 ]
  %86 = icmp slt i64 %85, 512
  br i1 %86, label %87, label %98

87:                                               ; preds = %84
  %88 = trunc i64 %85 to i32
  %89 = mul i32 %88, 32
  %90 = sext i32 %89 to i64
  %91 = getelementptr i8, ptr addrspace(6) null, i64 %90
  %92 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %91, i32 0, i32 0, i32 0)
  %93 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %92, <256 x i1> %81)
  %94 = mul i32 %88, 4
  %95 = sext i32 %94 to i64
  %96 = getelementptr i8, ptr addrspace(6) inttoptr (i64 24576 to ptr addrspace(6)), i64 %95
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %93, ptr addrspace(6) %96, i32 0, i32 5, i32 0, <256 x i1> %83)
  %97 = add i64 %85, 1
  br label %84

98:                                               ; preds = %84
  br label %99

99:                                               ; preds = %98
  %100 = add i32 %77, 1
  br label %76, !llvm.loop !5

101:                                              ; preds = %76
  br label %102

102:                                              ; preds = %127, %101
  %103 = phi i32 [ %128, %127 ], [ 0, %101 ]
  %104 = icmp sle i32 %103, 0
  br i1 %104, label %105, label %129

105:                                              ; preds = %102
  %106 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %107

107:                                              ; preds = %110, %105
  %108 = phi i64 [ %125, %110 ], [ 0, %105 ]
  %109 = icmp slt i64 %108, 8
  br i1 %109, label %110, label %126

110:                                              ; preds = %107
  %111 = trunc i64 %108 to i32
  %112 = udiv i32 %111, 8
  %113 = urem i32 %111, 8
  %114 = mul i32 %113, 64
  %115 = mul i32 %112, 512
  %116 = add i32 %115, %114
  %117 = mul i32 %116, 4
  %118 = sext i32 %117 to i64
  %119 = getelementptr i8, ptr addrspace(6) inttoptr (i64 24576 to ptr addrspace(6)), i64 %118
  %120 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %119, i32 0, i32 0, i32 0)
  %121 = call <128 x half> @llvm.hivm.vcvtff.f322f16.x(<64 x float> %120, <256 x i1> %106, i32 0, i32 0, i32 0)
  %122 = mul i32 %116, 2
  %123 = sext i32 %122 to i64
  %124 = getelementptr i8, ptr addrspace(6) inttoptr (i64 26624 to ptr addrspace(6)), i64 %123
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %121, ptr addrspace(6) %124, i32 0, i32 7, i32 0, <256 x i1> %106)
  %125 = add i64 %108, 1
  br label %107

126:                                              ; preds = %107
  br label %127

127:                                              ; preds = %126
  %128 = add i32 %103, 1
  br label %102, !llvm.loop !6

129:                                              ; preds = %102
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %130 = ptrtoint ptr addrspace(1) %1 to i64
  %131 = inttoptr i64 %130 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %131, ptr addrspace(6) inttoptr (i64 26624 to ptr addrspace(6)), i64 288230393801342992, i64 578343116210702)
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
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

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
!1 = !{ptr @triton_mean_dim1, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
!5 = distinct !{!5, !3}
!6 = distinct !{!6, !3}
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

declare void @_mlir_ciface_mma_tile_float_to_float.cube(ptr, ptr, i1, i64, i64, i64, ptr, i64, i64, i64, i64, i64, i64, i64, i8)

define dso_local ptc_kernel void @l1ub_kernel_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5) #0 {
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 0)
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET0(i64 %7, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.CTRL()
  %10 = call i64 @llvm.hivm.SBITSET1(i64 %9, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %10)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 5)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 4)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 1)
  br label %11

11:                                               ; preds = %14, %6
  %12 = phi i64 [ %15, %14 ], [ 0, %6 ]
  %13 = icmp slt i64 %12, 128
  br i1 %13, label %14, label %16

14:                                               ; preds = %11
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 7)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 6)
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) inttoptr (i64 34816 to ptr addrspace(6)), ptr addrspace(2) inttoptr (i64 147456 to ptr addrspace(2)), i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 12)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 0)
  call void @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(ptr addrspace(2) inttoptr (i64 114688 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), i1 true, i64 16, i64 256, i64 16, ptr addrspace(5) null, i64 -1, i64 -1, i64 -1, i64 -1, i64 256, i64 -1, i64 -1, i8 0)
  call void @llvm.hivm.BARRIER(i64 6)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 2)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 9)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 8)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 3)
  call void @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(ptr addrspace(2) inttoptr (i64 65536 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 81920 to ptr addrspace(2)), i1 true, i64 16, i64 256, i64 16, ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), i64 -1, i64 -1, i64 -1, i64 -1, i64 256, i64 -1, i64 -1, i8 0)
  call void @llvm.hivm.BARRIER(i64 6)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 10)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 10)
  %15 = add i64 %12, 1
  br label %11

16:                                               ; preds = %11
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 69632 to ptr addrspace(6)), ptr addrspace(5) null, i64 68720525568, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 13)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 70656 to ptr addrspace(6)), ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), i64 68720525568, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 14)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 11)
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

define dso_local ptc_kernel void @l1ub_kernel_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5) #1 {
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET0(i64 %7, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.CTRL()
  %10 = call i64 @llvm.hivm.SBITSET1(i64 %9, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %10)
  %11 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %13, label %25

13:                                               ; preds = %6
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %14 = ptrtoint ptr addrspace(1) %0 to i64
  %15 = inttoptr i64 %14 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) null, ptr addrspace(1) %15, i64 4503599627386880, i64 256)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 5, i64 0)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %16 = ptrtoint ptr addrspace(1) %1 to i64
  %17 = inttoptr i64 %16 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), ptr addrspace(1) %17, i64 72057594037928960, i64 16)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %18 = ptrtoint ptr addrspace(1) %2 to i64
  %19 = inttoptr i64 %18 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), ptr addrspace(1) %19, i64 72057594037928960, i64 16)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 1)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 65536 to ptr addrspace(2)), ptr addrspace(2) null, i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 2)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 81920 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 3)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 4)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 5)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 5, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 5, i64 1)
  br label %20

20:                                               ; preds = %108, %13
  %21 = phi i64 [ %109, %108 ], [ 0, %13 ]
  %22 = icmp slt i64 %21, 128
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 3, i64 0)
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) inttoptr (i64 51200 to ptr addrspace(6)), ptr addrspace(2) null, i64 33554448)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 1, i64 0)
  br label %26

24:                                               ; preds = %20
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 5, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 5, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 13)
  br label %110

25:                                               ; preds = %153, %6
  ret void

26:                                               ; preds = %54, %23
  %27 = phi i32 [ %55, %54 ], [ 0, %23 ]
  %28 = icmp sle i32 %27, 0
  br i1 %28, label %29, label %56

29:                                               ; preds = %26
  %30 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %31

31:                                               ; preds = %51, %29
  %32 = phi i64 [ %52, %51 ], [ 0, %29 ]
  %33 = icmp slt i64 %32, 4
  br i1 %33, label %34, label %53

34:                                               ; preds = %31
  br label %35

35:                                               ; preds = %38, %34
  %36 = phi i64 [ %50, %38 ], [ 0, %34 ]
  %37 = icmp slt i64 %36, 16
  br i1 %37, label %38, label %51

38:                                               ; preds = %35
  %39 = mul i64 %36, 256
  %40 = mul i64 %32, 64
  %41 = add i64 %39, %40
  %42 = mul i64 %41, 4
  %43 = getelementptr i8, ptr addrspace(6) inttoptr (i64 51200 to ptr addrspace(6)), i64 %42
  %44 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %43, i32 0, i32 0, i32 0)
  %45 = mul i64 %32, 1088
  %46 = mul i64 %36, 8
  %47 = add i64 %45, %46
  %48 = mul i64 %47, 4
  %49 = getelementptr i8, ptr addrspace(6) null, i64 %48
  call void @llvm.hivm.vsstb.v64f32(<64 x float> %44, ptr addrspace(6) %49, i32 1114112, i32 0, <256 x i1> %30)
  %50 = add i64 %36, 1
  br label %35

51:                                               ; preds = %35
  %52 = add i64 %32, 1
  br label %31

53:                                               ; preds = %31
  br label %54

54:                                               ; preds = %53
  %55 = add i32 %27, 1
  br label %26, !llvm.loop !3

56:                                               ; preds = %26
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 5, i64 0)
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) inttoptr (i64 98304 to ptr addrspace(2)), ptr addrspace(6) null, i64 4296016384)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 3, i64 1)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 114688 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 98304 to ptr addrspace(2)), i64 33554448)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 5, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 6)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 7)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 12)
  br label %57

57:                                               ; preds = %75, %56
  %58 = phi i32 [ %76, %75 ], [ 0, %56 ]
  %59 = icmp sle i32 %58, 0
  br i1 %59, label %60, label %77

60:                                               ; preds = %57
  %61 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %62

62:                                               ; preds = %65, %60
  %63 = phi i64 [ %73, %65 ], [ 0, %60 ]
  %64 = icmp slt i64 %63, 64
  br i1 %64, label %65, label %74

65:                                               ; preds = %62
  %66 = trunc i64 %63 to i32
  %67 = mul i32 %66, 256
  %68 = sext i32 %67 to i64
  %69 = getelementptr i8, ptr addrspace(6) inttoptr (i64 34816 to ptr addrspace(6)), i64 %68
  %70 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %69, i32 0, i32 0, i32 0)
  %71 = sext i32 %67 to i64
  %72 = getelementptr i8, ptr addrspace(6) inttoptr (i64 51200 to ptr addrspace(6)), i64 %71
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %70, ptr addrspace(6) %72, i32 0, i32 2, i32 0, <256 x i1> %61)
  %73 = add i64 %63, 1
  br label %62

74:                                               ; preds = %62
  br label %75

75:                                               ; preds = %74
  %76 = add i32 %58, 1
  br label %57, !llvm.loop !5

77:                                               ; preds = %57
  br label %78

78:                                               ; preds = %106, %77
  %79 = phi i32 [ %107, %106 ], [ 0, %77 ]
  %80 = icmp sle i32 %79, 0
  br i1 %80, label %81, label %108

81:                                               ; preds = %78
  %82 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %83

83:                                               ; preds = %103, %81
  %84 = phi i64 [ %104, %103 ], [ 0, %81 ]
  %85 = icmp slt i64 %84, 4
  br i1 %85, label %86, label %105

86:                                               ; preds = %83
  br label %87

87:                                               ; preds = %90, %86
  %88 = phi i64 [ %102, %90 ], [ 0, %86 ]
  %89 = icmp slt i64 %88, 16
  br i1 %89, label %90, label %103

90:                                               ; preds = %87
  %91 = mul i64 %88, 256
  %92 = mul i64 %84, 64
  %93 = add i64 %91, %92
  %94 = mul i64 %93, 4
  %95 = getelementptr i8, ptr addrspace(6) inttoptr (i64 51200 to ptr addrspace(6)), i64 %94
  %96 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %95, i32 0, i32 0, i32 0)
  %97 = mul i64 %84, 1088
  %98 = mul i64 %88, 8
  %99 = add i64 %97, %98
  %100 = mul i64 %99, 4
  %101 = getelementptr i8, ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), i64 %100
  call void @llvm.hivm.vsstb.v64f32(<64 x float> %96, ptr addrspace(6) %101, i32 1114112, i32 0, <256 x i1> %82)
  %102 = add i64 %88, 1
  br label %87

103:                                              ; preds = %87
  %104 = add i64 %84, 1
  br label %83

105:                                              ; preds = %83
  br label %106

106:                                              ; preds = %105
  %107 = add i32 %79, 1
  br label %78, !llvm.loop !6

108:                                              ; preds = %78
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 5, i64 1)
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) null, ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), i64 4296016384)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 3, i64 1)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 131072 to ptr addrspace(2)), ptr addrspace(2) null, i64 33554448)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 5, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 8)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 9)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 10)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 10)
  %109 = add i64 %21, 1
  br label %20

110:                                              ; preds = %128, %24
  %111 = phi i32 [ %129, %128 ], [ 0, %24 ]
  %112 = icmp sle i32 %111, 0
  br i1 %112, label %113, label %130

113:                                              ; preds = %110
  %114 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %115

115:                                              ; preds = %118, %113
  %116 = phi i64 [ %126, %118 ], [ 0, %113 ]
  %117 = icmp slt i64 %116, 4
  br i1 %117, label %118, label %127

118:                                              ; preds = %115
  %119 = trunc i64 %116 to i32
  %120 = mul i32 %119, 256
  %121 = sext i32 %120 to i64
  %122 = getelementptr i8, ptr addrspace(6) inttoptr (i64 69632 to ptr addrspace(6)), i64 %121
  %123 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %122, i32 0, i32 0, i32 0)
  %124 = sext i32 %120 to i64
  %125 = getelementptr i8, ptr addrspace(6) inttoptr (i64 67584 to ptr addrspace(6)), i64 %124
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %123, ptr addrspace(6) %125, i32 0, i32 2, i32 0, <256 x i1> %114)
  %126 = add i64 %116, 1
  br label %115

127:                                              ; preds = %115
  br label %128

128:                                              ; preds = %127
  %129 = add i32 %111, 1
  br label %110, !llvm.loop !7

130:                                              ; preds = %110
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %131 = ptrtoint ptr addrspace(1) %3 to i64
  %132 = inttoptr i64 %131 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %132, ptr addrspace(6) inttoptr (i64 67584 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 14)
  br label %133

133:                                              ; preds = %151, %130
  %134 = phi i32 [ %152, %151 ], [ 0, %130 ]
  %135 = icmp sle i32 %134, 0
  br i1 %135, label %136, label %153

136:                                              ; preds = %133
  %137 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %138

138:                                              ; preds = %141, %136
  %139 = phi i64 [ %149, %141 ], [ 0, %136 ]
  %140 = icmp slt i64 %139, 4
  br i1 %140, label %141, label %150

141:                                              ; preds = %138
  %142 = trunc i64 %139 to i32
  %143 = mul i32 %142, 256
  %144 = sext i32 %143 to i64
  %145 = getelementptr i8, ptr addrspace(6) inttoptr (i64 70656 to ptr addrspace(6)), i64 %144
  %146 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %145, i32 0, i32 0, i32 0)
  %147 = sext i32 %143 to i64
  %148 = getelementptr i8, ptr addrspace(6) inttoptr (i64 68608 to ptr addrspace(6)), i64 %147
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %146, ptr addrspace(6) %148, i32 0, i32 2, i32 0, <256 x i1> %137)
  %149 = add i64 %139, 1
  br label %138

150:                                              ; preds = %138
  br label %151

151:                                              ; preds = %150
  %152 = add i32 %134, 1
  br label %133, !llvm.loop !8

153:                                              ; preds = %133
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %154 = ptrtoint ptr addrspace(1) %4 to i64
  %155 = inttoptr i64 %154 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %155, ptr addrspace(6) inttoptr (i64 68608 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 11)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %25
}

define internal void @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(ptr addrspace(2) %0, ptr addrspace(2) %1, i1 %2, i64 %3, i64 %4, i64 %5, ptr addrspace(5) %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, i8 %14) #2 {
  %16 = ptrtoint ptr addrspace(2) %0 to i64
  %17 = inttoptr i64 %16 to ptr addrspace(2)
  %18 = alloca { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] }, i64 1, align 8
  %19 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } poison, ptr addrspace(2) %17, 0
  %20 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %19, ptr addrspace(2) %17, 1
  %21 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %20, i64 0, 2
  %22 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %21, i64 32, 3, 0
  %23 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %22, i64 128, 4, 0
  %24 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %23, i64 1, 3, 1
  %25 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %24, i64 128, 4, 1
  %26 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %25, i64 16, 3, 2
  %27 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %26, i64 8, 4, 2
  %28 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %27, i64 8, 3, 3
  %29 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %28, i64 1, 4, 3
  store { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %29, ptr %18, align 8
  %30 = ptrtoint ptr addrspace(2) %1 to i64
  %31 = inttoptr i64 %30 to ptr addrspace(2)
  %32 = alloca { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] }, i64 1, align 8
  %33 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } poison, ptr addrspace(2) %31, 0
  %34 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %33, ptr addrspace(2) %31, 1
  %35 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %34, i64 0, 2
  %36 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %35, i64 2, 3, 0
  %37 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %36, i64 2048, 4, 0
  %38 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %37, i64 16, 3, 1
  %39 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %38, i64 128, 4, 1
  %40 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %39, i64 16, 3, 2
  %41 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %40, i64 8, 4, 2
  %42 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %41, i64 8, 3, 3
  %43 = insertvalue { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %42, i64 1, 4, 3
  store { ptr addrspace(2), ptr addrspace(2), i64, [4 x i64], [4 x i64] } %43, ptr %32, align 8
  %44 = ptrtoint ptr addrspace(5) %6 to i64
  %45 = inttoptr i64 %44 to ptr addrspace(5)
  %46 = alloca { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] }, i64 1, align 8
  %47 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } poison, ptr addrspace(5) %45, 0
  %48 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %47, ptr addrspace(5) %45, 1
  %49 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %48, i64 0, 2
  %50 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %49, i64 1, 3, 0
  %51 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %50, i64 256, 4, 0
  %52 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %51, i64 1, 3, 1
  %53 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %52, i64 256, 4, 1
  %54 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %53, i64 16, 3, 2
  %55 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %54, i64 16, 4, 2
  %56 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %55, i64 16, 3, 3
  %57 = insertvalue { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %56, i64 1, 4, 3
  store { ptr addrspace(5), ptr addrspace(5), i64, [4 x i64], [4 x i64] } %57, ptr %46, align 8
  call void @_mlir_ciface_mma_tile_float_to_float.cube(ptr %18, ptr %32, i1 %2, i64 %3, i64 %4, i64 %5, ptr %46, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, i8 %14)
  ret void
}

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.CTRL()

; Unknown intrinsic
declare i64 @llvm.hivm.SBITSET0(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.CTRL(i64)

; Unknown intrinsic
declare i64 @llvm.hivm.SBITSET1(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.LOOP3.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6), ptr addrspace(2), i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.SET.MTE2.NZ.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2), ptr addrspace(2), i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2), ptr addrspace(6), i64)

; Unknown intrinsic
declare void @llvm.hivm.vsstb.v64f32(<64 x float>, ptr addrspace(6), i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }
attributes #2 = { noinline "target-cpu"="dav-c310-cube" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1, !2}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @l1ub_kernel_mix_aic, !"kernel", i32 1}
!2 = !{ptr @l1ub_kernel_mix_aiv, !"kernel", i32 1}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.aivector_scope"}
!5 = distinct !{!5, !4}
!6 = distinct !{!6, !4}
!7 = distinct !{!7, !4}
!8 = distinct !{!8, !4}
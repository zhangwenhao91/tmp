; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @main_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5, i32 %6) #0 {
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET0(i64 %8, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.CTRL()
  %11 = call i64 @llvm.hivm.SBITSET1(i64 %10, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %11)
  %12 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %13 = trunc i64 %12 to i32
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 4, i64 0)
  br label %14

14:                                               ; preds = %31, %7
  %15 = phi i64 [ %32, %31 ], [ 0, %7 ]
  %16 = icmp slt i64 %15, 128
  br i1 %16, label %17, label %33

17:                                               ; preds = %14
  %18 = mul i32 %13, 128
  %19 = sext i32 %18 to i64
  %20 = add i64 %19, %15
  %21 = mul i64 %20, 16384
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 4, i64 0)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 274877972481)
  %22 = ptrtoint ptr addrspace(1) %0 to i64
  %23 = mul i64 %21, 2
  %24 = add i64 %22, %23
  %25 = inttoptr i64 %24 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) null, ptr addrspace(1) %25, i64 18014398509490176, i64 256)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 1)
  br label %26

26:                                               ; preds = %29, %17
  %27 = phi i64 [ %30, %29 ], [ 0, %17 ]
  %28 = icmp slt i64 %27, 8
  br i1 %28, label %29, label %31

29:                                               ; preds = %26
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) null, ptr addrspace(2) null, i64 17609365913600, i64 262148, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) inttoptr (i64 16384 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 17596481011712, i64 65537, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) inttoptr (i64 65536 to ptr addrspace(5)), ptr addrspace(3) null, ptr addrspace(4) inttoptr (i64 16384 to ptr addrspace(4)), i64 -6917529027371597760)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 82432 to ptr addrspace(6)), ptr addrspace(5) inttoptr (i64 65536 to ptr addrspace(5)), i64 68723671296, i64 8796093087808)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 4)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) inttoptr (i64 32768 to ptr addrspace(3)), ptr addrspace(2) inttoptr (i64 40960 to ptr addrspace(2)), i64 1116691496960, i64 262148, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) inttoptr (i64 24576 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 17596481011712, i64 1048577, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 1)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) null, ptr addrspace(3) inttoptr (i64 32768 to ptr addrspace(3)), ptr addrspace(4) inttoptr (i64 24576 to ptr addrspace(4)), i64 -6917529023346048960)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), ptr addrspace(5) null, i64 1099515826176, i64 8796093087808)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 5)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 2)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 2)
  %30 = add i64 %27, 1
  br label %26

31:                                               ; preds = %26
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 4, i64 0)
  %32 = add i64 %15, 1
  br label %14

33:                                               ; preds = %14
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 4, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 3)
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

define dso_local ptc_kernel void @main_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5, i32 %6) #1 {
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET0(i64 %8, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.CTRL()
  %11 = call i64 @llvm.hivm.SBITSET1(i64 %10, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %11)
  %12 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %63

14:                                               ; preds = %7
  %15 = trunc i64 %12 to i32
  %16 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %17 = trunc i64 %16 to i32
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 2)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 1)
  br label %18

18:                                               ; preds = %346, %14
  %19 = phi i64 [ %357, %346 ], [ 0, %14 ]
  %20 = icmp slt i64 %19, 128
  br i1 %20, label %21, label %62

21:                                               ; preds = %18
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 2)
  br label %64

22:                                               ; preds = %25, %91
  %23 = phi i64 [ 0, %91 ], [ %36, %25 ]
  %24 = icmp slt i64 %23, 128
  br i1 %24, label %25, label %37

25:                                               ; preds = %22
  %26 = mul i32 %17, 128
  %27 = sext i32 %26 to i64
  %28 = add i64 %27, %19
  %29 = ptrtoint ptr addrspace(1) %3 to i64
  %30 = inttoptr i64 %29 to ptr addrspace(1)
  %31 = mul i64 %28, 128
  %32 = add i64 %31, %23
  %33 = getelementptr i32, ptr addrspace(1) %30, i64 %32
  %34 = load i32, ptr addrspace(1) %33, align 4
  %35 = getelementptr i32, ptr addrspace(6) inttoptr (i64 85504 to ptr addrspace(6)), i64 %23
  store i32 %34, ptr addrspace(6) %35, align 4
  %36 = add i64 %23, 1
  br label %22

37:                                               ; preds = %22
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 1)
  br label %38

38:                                               ; preds = %307, %37
  %39 = phi i64 [ %308, %307 ], [ 0, %37 ]
  %40 = icmp slt i64 %39, 8
  br i1 %40, label %41, label %61

41:                                               ; preds = %38
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  br label %42

42:                                               ; preds = %45, %41
  %43 = phi i64 [ %59, %45 ], [ 0, %41 ]
  %44 = icmp slt i64 %43, 16
  br i1 %44, label %45, label %60

45:                                               ; preds = %42
  %46 = mul i64 %39, 16
  %47 = add i64 %46, %43
  %48 = getelementptr i32, ptr addrspace(6) inttoptr (i64 85504 to ptr addrspace(6)), i64 %47
  %49 = load i32, ptr addrspace(6) %48, align 4
  %50 = sext i32 %49 to i64
  %51 = mul i64 %50, 256
  %52 = mul i64 %43, 256
  %53 = mul i64 %52, 2
  %54 = getelementptr i8, ptr addrspace(6) inttoptr (i64 74240 to ptr addrspace(6)), i64 %53
  %55 = ptrtoint ptr addrspace(1) %1 to i64
  %56 = mul i64 %51, 2
  %57 = add i64 %55, %56
  %58 = inttoptr i64 %57 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) %54, ptr addrspace(1) %58, i64 288230377225453824, i64 35184372088864)
  %59 = add i64 %43, 1
  br label %42

60:                                               ; preds = %42
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %98

61:                                               ; preds = %38
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  br label %309

62:                                               ; preds = %18
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 2)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 3)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %63

63:                                               ; preds = %62, %7
  ret void

64:                                               ; preds = %89, %21
  %65 = phi i32 [ %90, %89 ], [ 0, %21 ]
  %66 = icmp sle i32 %65, 0
  br i1 %66, label %67, label %91

67:                                               ; preds = %64
  %68 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %69

69:                                               ; preds = %72, %67
  %70 = phi i64 [ %83, %72 ], [ 0, %67 ]
  %71 = icmp slt i64 %70, 128
  br i1 %71, label %72, label %84

72:                                               ; preds = %69
  %73 = trunc i64 %70 to i32
  %74 = udiv i32 %73, 4
  %75 = urem i32 %73, 4
  %76 = mul i32 %75, 64
  %77 = mul i32 %74, 256
  %78 = add i32 %77, %76
  %79 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 0.000000e+00, <256 x i1> %68, i32 0)
  %80 = mul i32 %78, 4
  %81 = sext i32 %80 to i64
  %82 = getelementptr i8, ptr addrspace(6) null, i64 %81
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %79, ptr addrspace(6) %82, i32 0, i32 2, i32 0, <256 x i1> %68)
  %83 = add i64 %70, 1
  br label %69

84:                                               ; preds = %69
  %85 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 1.000000e+00, <256 x i1> %68, i32 0)
  %86 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %87 = extractvalue { <256 x i1>, i32 } %86, 0
  %88 = extractvalue { <256 x i1>, i32 } %86, 1
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %85, ptr addrspace(6) inttoptr (i64 86400 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %87)
  br label %89

89:                                               ; preds = %84
  %90 = add i32 %65, 1
  br label %64, !llvm.loop !3

91:                                               ; preds = %64
  %92 = mul i32 %15, 32
  %93 = sext i32 %92 to i64
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 1)
  %94 = ptrtoint ptr addrspace(1) %2 to i64
  %95 = mul i64 %93, 4
  %96 = add i64 %94, %95
  %97 = inttoptr i64 %96 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), ptr addrspace(1) %97, i64 288230377225453632, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %22

98:                                               ; preds = %126, %60
  %99 = phi i32 [ %127, %126 ], [ 0, %60 ]
  %100 = icmp sle i32 %99, 0
  br i1 %100, label %101, label %128

101:                                              ; preds = %98
  %102 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %103

103:                                              ; preds = %123, %101
  %104 = phi i64 [ %124, %123 ], [ 0, %101 ]
  %105 = icmp slt i64 %104, 2
  br i1 %105, label %106, label %125

106:                                              ; preds = %103
  br label %107

107:                                              ; preds = %110, %106
  %108 = phi i64 [ %122, %110 ], [ 0, %106 ]
  %109 = icmp slt i64 %108, 16
  br i1 %109, label %110, label %123

110:                                              ; preds = %107
  %111 = mul i64 %108, 256
  %112 = mul i64 %104, 128
  %113 = add i64 %111, %112
  %114 = mul i64 %113, 2
  %115 = getelementptr i8, ptr addrspace(6) inttoptr (i64 74240 to ptr addrspace(6)), i64 %114
  %116 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %115, i32 0, i32 0, i32 0)
  %117 = mul i64 %104, 2176
  %118 = mul i64 %108, 16
  %119 = add i64 %117, %118
  %120 = mul i64 %119, 2
  %121 = getelementptr i8, ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i64 %120
  call void @llvm.hivm.vsstb.v128bf16(<128 x bfloat> %116, ptr addrspace(6) %121, i32 1114112, i32 0, <256 x i1> %102)
  %122 = add i64 %108, 1
  br label %107

123:                                              ; preds = %107
  %124 = add i64 %104, 1
  br label %103

125:                                              ; preds = %103
  br label %126

126:                                              ; preds = %125
  %127 = add i32 %99, 1
  br label %98, !llvm.loop !5

128:                                              ; preds = %98
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i64 4296016128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 4)
  br label %129

129:                                              ; preds = %168, %128
  %130 = phi i32 [ %169, %168 ], [ 0, %128 ]
  %131 = icmp sle i32 %130, 0
  br i1 %131, label %132, label %170

132:                                              ; preds = %129
  %133 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %134

134:                                              ; preds = %137, %132
  %135 = phi i64 [ %145, %137 ], [ 0, %132 ]
  %136 = icmp slt i64 %135, 32
  br i1 %136, label %137, label %146

137:                                              ; preds = %134
  %138 = trunc i64 %135 to i32
  %139 = mul i32 %138, 4
  %140 = sext i32 %139 to i64
  %141 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), i64 %140
  %142 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %141, i32 0, i32 3, i32 0)
  %143 = sext i32 %139 to i64
  %144 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86144 to ptr addrspace(6)), i64 %143
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %142, ptr addrspace(6) %144, i32 0, i32 5, i32 0, <256 x i1> %133)
  %145 = add i64 %135, 1
  br label %134

146:                                              ; preds = %134
  %147 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 16)
  %148 = extractvalue { <256 x i1>, i32 } %147, 0
  %149 = extractvalue { <256 x i1>, i32 } %147, 1
  br label %150

150:                                              ; preds = %153, %146
  %151 = phi i64 [ %166, %153 ], [ 0, %146 ]
  %152 = icmp slt i64 %151, 32
  br i1 %152, label %153, label %167

153:                                              ; preds = %150
  %154 = trunc i64 %151 to i32
  %155 = mul i32 %154, 64
  %156 = sext i32 %155 to i64
  %157 = getelementptr i8, ptr addrspace(6) inttoptr (i64 82432 to ptr addrspace(6)), i64 %156
  %158 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %157, i32 0, i32 0, i32 0)
  %159 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %158, float 6.250000e-02, <256 x i1> %148)
  %160 = sext i32 %155 to i64
  %161 = getelementptr i8, ptr addrspace(6) inttoptr (i64 82432 to ptr addrspace(6)), i64 %160
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %159, ptr addrspace(6) %161, i32 0, i32 2, i32 0, <256 x i1> %148)
  %162 = call <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float> %159, <256 x i1> %148)
  %163 = mul i32 %154, 4
  %164 = sext i32 %163 to i64
  %165 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), i64 %164
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %162, ptr addrspace(6) %165, i32 0, i32 5, i32 0, <256 x i1> %133)
  %166 = add i64 %151, 1
  br label %150

167:                                              ; preds = %150
  br label %168

168:                                              ; preds = %167
  %169 = add i32 %130, 1
  br label %129, !llvm.loop !6

170:                                              ; preds = %129
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 1)
  br label %171

171:                                              ; preds = %242, %170
  %172 = phi i32 [ %243, %242 ], [ 0, %170 ]
  %173 = icmp sle i32 %172, 0
  br i1 %173, label %174, label %244

174:                                              ; preds = %171
  %175 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %176 = extractvalue { <256 x i1>, i32 } %175, 0
  %177 = extractvalue { <256 x i1>, i32 } %175, 1
  %178 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %179 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 86144 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %180 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %178, <64 x float> %179, <256 x i1> %176)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %180, ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %176)
  %181 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %182 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 16)
  %183 = extractvalue { <256 x i1>, i32 } %182, 0
  %184 = extractvalue { <256 x i1>, i32 } %182, 1
  br label %185

185:                                              ; preds = %188, %174
  %186 = phi i64 [ %211, %188 ], [ 0, %174 ]
  %187 = icmp slt i64 %186, 32
  br i1 %187, label %188, label %212

188:                                              ; preds = %185
  %189 = trunc i64 %186 to i32
  %190 = mul i32 %189, 16
  %191 = mul i32 %189, 64
  %192 = sext i32 %191 to i64
  %193 = getelementptr i8, ptr addrspace(6) inttoptr (i64 82432 to ptr addrspace(6)), i64 %192
  %194 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %193, i32 0, i32 0, i32 0)
  %195 = udiv i32 %190, 16
  %196 = urem i32 %195, 32
  %197 = mul i32 %196, 4
  %198 = sext i32 %197 to i64
  %199 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), i64 %198
  %200 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %199, i32 0, i32 3, i32 0)
  %201 = sext i32 %197 to i64
  %202 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86144 to ptr addrspace(6)), i64 %201
  %203 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %202, i32 0, i32 3, i32 0)
  %204 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %200, <64 x float> %203, <256 x i1> %181)
  %205 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %194, <64 x float> %204, <256 x i1> %183)
  %206 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %205, <256 x i1> %183)
  %207 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %206, <256 x i1> %183, i32 0, i32 0, i32 0)
  %208 = mul i32 %189, 32
  %209 = sext i32 %208 to i64
  %210 = getelementptr i8, ptr addrspace(6) inttoptr (i64 84480 to ptr addrspace(6)), i64 %209
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %207, ptr addrspace(6) %210, i32 0, i32 7, i32 0, <256 x i1> %183)
  %211 = add i64 %186, 1
  br label %185

212:                                              ; preds = %185
  %213 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %214

214:                                              ; preds = %217, %212
  %215 = phi i64 [ %240, %217 ], [ 0, %212 ]
  %216 = icmp slt i64 %215, 32
  br i1 %216, label %217, label %241

217:                                              ; preds = %214
  %218 = trunc i64 %215 to i32
  %219 = mul i32 %218, 16
  %220 = mul i32 %218, 64
  %221 = sext i32 %220 to i64
  %222 = getelementptr i8, ptr addrspace(6) inttoptr (i64 82432 to ptr addrspace(6)), i64 %221
  %223 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %222, i32 0, i32 0, i32 0)
  %224 = udiv i32 %219, 16
  %225 = urem i32 %224, 32
  %226 = mul i32 %225, 4
  %227 = sext i32 %226 to i64
  %228 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), i64 %227
  %229 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %228, i32 0, i32 3, i32 0)
  %230 = sext i32 %226 to i64
  %231 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86144 to ptr addrspace(6)), i64 %230
  %232 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %231, i32 0, i32 3, i32 0)
  %233 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %229, <64 x float> %232, <256 x i1> %181)
  %234 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %223, <64 x float> %233, <256 x i1> %183)
  %235 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %234, <256 x i1> %183)
  %236 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %235, <256 x i1> %183)
  %237 = mul i32 %218, 4
  %238 = sext i32 %237 to i64
  %239 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86272 to ptr addrspace(6)), i64 %238
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %236, ptr addrspace(6) %239, i32 0, i32 5, i32 0, <256 x i1> %213)
  %240 = add i64 %215, 1
  br label %214

241:                                              ; preds = %214
  br label %242

242:                                              ; preds = %241
  %243 = add i32 %172, 1
  br label %171, !llvm.loop !7

244:                                              ; preds = %171
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  br label %245

245:                                              ; preds = %260, %244
  %246 = phi i32 [ %261, %260 ], [ 0, %244 ]
  %247 = icmp sle i32 %246, 0
  br i1 %247, label %248, label %262

248:                                              ; preds = %245
  %249 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 86144 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %250 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 86016 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %251 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 86400 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %252 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 86272 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %253 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %254 = extractvalue { <256 x i1>, i32 } %253, 0
  %255 = extractvalue { <256 x i1>, i32 } %253, 1
  %256 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %249, <64 x float> %250, <256 x i1> %254)
  %257 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %256, <256 x i1> %254)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %257, ptr addrspace(6) inttoptr (i64 86528 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %254)
  %258 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %251, <64 x float> %257, <256 x i1> %254)
  %259 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %258, <64 x float> %252, <256 x i1> %254)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %259, ptr addrspace(6) inttoptr (i64 86400 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %254)
  br label %260

260:                                              ; preds = %248
  %261 = add i32 %246, 1
  br label %245, !llvm.loop !8

262:                                              ; preds = %245
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %263 = mul i64 %12, 512
  %264 = mul i64 %263, 2
  %265 = getelementptr i8, ptr addrspace(2) inttoptr (i64 40960 to ptr addrspace(2)), i64 %264
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) %265, ptr addrspace(6) inttoptr (i64 84480 to ptr addrspace(6)), i64 66048)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 1)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 5)
  br label %266

266:                                              ; preds = %305, %262
  %267 = phi i32 [ %306, %305 ], [ 0, %262 ]
  %268 = icmp sle i32 %267, 0
  br i1 %268, label %269, label %307

269:                                              ; preds = %266
  %270 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %271

271:                                              ; preds = %302, %269
  %272 = phi i64 [ %303, %302 ], [ 0, %269 ]
  %273 = icmp slt i64 %272, 32
  br i1 %273, label %274, label %304

274:                                              ; preds = %271
  %275 = trunc i64 %272 to i32
  %276 = mul i32 %275, 256
  %277 = udiv i32 %276, 256
  %278 = urem i32 %277, 32
  %279 = mul i32 %278, 4
  %280 = sext i32 %279 to i64
  %281 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86528 to ptr addrspace(6)), i64 %280
  %282 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %281, i32 0, i32 3, i32 0)
  br label %283

283:                                              ; preds = %286, %274
  %284 = phi i64 [ %301, %286 ], [ 0, %274 ]
  %285 = icmp slt i64 %284, 4
  br i1 %285, label %286, label %302

286:                                              ; preds = %283
  %287 = trunc i64 %284 to i32
  %288 = mul i32 %287, 64
  %289 = add i32 %276, %288
  %290 = mul i32 %289, 4
  %291 = sext i32 %290 to i64
  %292 = getelementptr i8, ptr addrspace(6) null, i64 %291
  %293 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %292, i32 0, i32 0, i32 0)
  %294 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %293, <64 x float> %282, <256 x i1> %270)
  %295 = sext i32 %290 to i64
  %296 = getelementptr i8, ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i64 %295
  %297 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %296, i32 0, i32 0, i32 0)
  %298 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %294, <64 x float> %297, <256 x i1> %270)
  %299 = sext i32 %290 to i64
  %300 = getelementptr i8, ptr addrspace(6) null, i64 %299
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %298, ptr addrspace(6) %300, i32 0, i32 2, i32 0, <256 x i1> %270)
  %301 = add i64 %284, 1
  br label %283

302:                                              ; preds = %283
  %303 = add i64 %272, 1
  br label %271

304:                                              ; preds = %271
  br label %305

305:                                              ; preds = %304
  %306 = add i32 %267, 1
  br label %266, !llvm.loop !9

307:                                              ; preds = %266
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 2)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 2)
  %308 = add i64 %39, 1
  br label %38

309:                                              ; preds = %344, %61
  %310 = phi i32 [ %345, %344 ], [ 0, %61 ]
  %311 = icmp sle i32 %310, 0
  br i1 %311, label %312, label %346

312:                                              ; preds = %309
  %313 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %314

314:                                              ; preds = %341, %312
  %315 = phi i64 [ %342, %341 ], [ 0, %312 ]
  %316 = icmp slt i64 %315, 32
  br i1 %316, label %317, label %343

317:                                              ; preds = %314
  %318 = trunc i64 %315 to i32
  %319 = mul i32 %318, 256
  %320 = udiv i32 %319, 256
  %321 = urem i32 %320, 32
  %322 = mul i32 %321, 4
  %323 = sext i32 %322 to i64
  %324 = getelementptr i8, ptr addrspace(6) inttoptr (i64 86400 to ptr addrspace(6)), i64 %323
  %325 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %324, i32 0, i32 3, i32 0)
  br label %326

326:                                              ; preds = %329, %317
  %327 = phi i64 [ %340, %329 ], [ 0, %317 ]
  %328 = icmp slt i64 %327, 4
  br i1 %328, label %329, label %341

329:                                              ; preds = %326
  %330 = trunc i64 %327 to i32
  %331 = mul i32 %330, 64
  %332 = add i32 %319, %331
  %333 = mul i32 %332, 4
  %334 = sext i32 %333 to i64
  %335 = getelementptr i8, ptr addrspace(6) null, i64 %334
  %336 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %335, i32 0, i32 0, i32 0)
  %337 = call <64 x float> @llvm.hivm.vdiv.s.x.v64f32(<64 x float> %336, <64 x float> %325, <256 x i1> %313)
  %338 = sext i32 %333 to i64
  %339 = getelementptr i8, ptr addrspace(6) null, i64 %338
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %337, ptr addrspace(6) %339, i32 0, i32 2, i32 0, <256 x i1> %313)
  %340 = add i64 %327, 1
  br label %326

341:                                              ; preds = %326
  %342 = add i64 %315, 1
  br label %314

343:                                              ; preds = %314
  br label %344

344:                                              ; preds = %343
  %345 = add i32 %310, 1
  br label %309, !llvm.loop !10

346:                                              ; preds = %309
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  %347 = mul i32 %17, 128
  %348 = sext i32 %347 to i64
  %349 = add i64 %348, %19
  %350 = mul i64 %349, 16384
  %351 = mul i64 %93, 256
  %352 = add i64 %350, %351
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %353 = ptrtoint ptr addrspace(1) %4 to i64
  %354 = mul i64 %352, 4
  %355 = add i64 %353, %354
  %356 = inttoptr i64 %355 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %356, ptr addrspace(6) null, i64 288230377225469952, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 2)
  %357 = add i64 %19, 1
  br label %18
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
declare i64 @llvm.hivm.GET.BLOCK.IDX()

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.MTE2.NZ.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5), ptr addrspace(3), ptr addrspace(4), i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.LOOP3.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vdiv.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2), ptr addrspace(6), i64)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float>, <256 x i1>, i32, i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float>, float, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b16(i32)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vsstb.v128bf16(<128 x bfloat>, ptr addrspace(6), i32, i32, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vdups.z.v64f32(float, <256 x i1>, i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1, !2}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @main_mix_aic, !"kernel", i32 1}
!2 = !{ptr @main_mix_aiv, !"kernel", i32 1}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.aivector_scope"}
!5 = distinct !{!5, !4}
!6 = distinct !{!6, !4}
!7 = distinct !{!7, !4}
!8 = distinct !{!8, !4}
!9 = distinct !{!9, !4}
!10 = distinct !{!10, !4}
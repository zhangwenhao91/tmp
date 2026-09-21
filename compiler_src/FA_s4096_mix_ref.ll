; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @main_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, i32 %4) #0 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET1(i64 %8, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %11 = trunc i64 %10 to i32
  %12 = mul i32 %11, 64
  %13 = sext i32 %12 to i64
  %14 = mul i64 %13, 128
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 274877972481)
  %15 = ptrtoint ptr addrspace(1) %0 to i64
  %16 = mul i64 %14, 2
  %17 = add i64 %15, %16
  %18 = inttoptr i64 %17 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) null, ptr addrspace(1) %18, i64 18014398509486080, i64 128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 4, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 4, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 1)
  br label %19

19:                                               ; preds = %22, %5
  %20 = phi i64 [ %32, %22 ], [ 0, %5 ]
  %21 = icmp slt i64 %20, 64
  br i1 %21, label %22, label %33

22:                                               ; preds = %19
  %23 = mul i64 %20, 8192
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 4, i64 0)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 274877972481)
  %24 = ptrtoint ptr addrspace(1) %1 to i64
  %25 = mul i64 %23, 2
  %26 = add i64 %24, %25
  %27 = inttoptr i64 %26 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), ptr addrspace(1) %27, i64 18014398509486080, i64 128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 4, i64 1)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 274877972481)
  %28 = ptrtoint ptr addrspace(1) %2 to i64
  %29 = mul i64 %23, 2
  %30 = add i64 %28, %29
  %31 = inttoptr i64 %30 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), ptr addrspace(1) %31, i64 18014398509486080, i64 128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) inttoptr (i64 16384 to ptr addrspace(3)), ptr addrspace(2) null, i64 8813272891392, i64 262148, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) inttoptr (i64 32768 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), i64 8813272891392, i64 262148, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 4, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) inttoptr (i64 32768 to ptr addrspace(5)), ptr addrspace(3) inttoptr (i64 16384 to ptr addrspace(3)), ptr addrspace(4) inttoptr (i64 32768 to ptr addrspace(4)), i64 -6917529026566815680)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), ptr addrspace(5) inttoptr (i64 32768 to ptr addrspace(5)), i64 274882102272, i64 8796093022272)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 3)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) inttoptr (i64 40960 to ptr addrspace(3)), ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), i64 4415226380288, i64 262148, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) inttoptr (i64 49152 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 8813272891392, i64 524292, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 4, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 1)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) null, ptr addrspace(3) inttoptr (i64 40960 to ptr addrspace(3)), ptr addrspace(4) inttoptr (i64 49152 to ptr addrspace(4)), i64 -6917529025493336000)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), ptr addrspace(5) null, i64 549760010240, i64 8796093022272)
  call void @llvm.hivm.SET.FLAG.IMM(i64 10, i64 2, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 4)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 1)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 1)
  %32 = add i64 %20, 1
  br label %19

33:                                               ; preds = %19
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 4, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 10, i64 2, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 2)
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

define dso_local ptc_kernel void @main_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, i32 %4) #1 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET1(i64 %8, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %11 = icmp eq i64 %10, 0
  br i1 %11, label %12, label %32

12:                                               ; preds = %5
  %13 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %14 = trunc i64 %13 to i32
  br label %33

15:                                               ; preds = %188, %56
  %16 = phi i64 [ %189, %188 ], [ 0, %56 ]
  %17 = icmp slt i64 %16, 64
  br i1 %17, label %18, label %31

18:                                               ; preds = %15
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 3)
  br label %57

19:                                               ; preds = %22, %154
  %20 = phi i64 [ 0, %154 ], [ %29, %22 ]
  %21 = icmp slt i64 %20, 4
  br i1 %21, label %22, label %30

22:                                               ; preds = %19
  %23 = mul i64 %20, 16
  %24 = mul i64 %20, 1024
  %25 = mul i64 %24, 2
  %26 = getelementptr i8, ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), i64 %25
  %27 = mul i64 %23, 2
  %28 = getelementptr i8, ptr addrspace(6) inttoptr (i64 81920 to ptr addrspace(6)), i64 %27
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) %26, ptr addrspace(6) %28, i64 12884968448)
  %29 = add i64 %20, 1
  br label %19

30:                                               ; preds = %19
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 4)
  br label %155

31:                                               ; preds = %15
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %190

32:                                               ; preds = %221, %5
  ret void

33:                                               ; preds = %54, %12
  %34 = phi i32 [ %55, %54 ], [ 0, %12 ]
  %35 = icmp sle i32 %34, 0
  br i1 %35, label %36, label %56

36:                                               ; preds = %33
  %37 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %38

38:                                               ; preds = %41, %36
  %39 = phi i64 [ %50, %41 ], [ 0, %36 ]
  %40 = icmp slt i64 %39, 128
  br i1 %40, label %41, label %51

41:                                               ; preds = %38
  %42 = trunc i64 %39 to i32
  %43 = udiv i32 %42, 2
  %44 = urem i32 %42, 2
  %45 = mul i32 %44, 64
  %46 = mul i32 %43, 128
  %47 = add i32 %46, %45
  %48 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 0.000000e+00, <256 x i1> %37, i32 0)
  %49 = mul i32 %47, 4
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %48, ptr addrspace(6) null, i32 %49, i32 2, i32 0, <256 x i1> %37)
  %50 = add i64 %39, 1
  br label %38

51:                                               ; preds = %38
  %52 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 0.000000e+00, <256 x i1> %37, i32 0)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %52, ptr addrspace(6) inttoptr (i64 90112 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %37)
  %53 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 0xFFF0000000000000, <256 x i1> %37, i32 0)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %53, ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %37)
  br label %54

54:                                               ; preds = %51
  %55 = add i32 %34, 1
  br label %33, !llvm.loop !3

56:                                               ; preds = %33
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %15

57:                                               ; preds = %84, %18
  %58 = phi i32 [ %85, %84 ], [ 0, %18 ]
  %59 = icmp sle i32 %58, 0
  br i1 %59, label %60, label %86

60:                                               ; preds = %57
  %61 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %62

62:                                               ; preds = %65, %60
  %63 = phi i64 [ %69, %65 ], [ 0, %60 ]
  %64 = icmp slt i64 %63, 64
  br i1 %64, label %65, label %70

65:                                               ; preds = %62
  %66 = trunc i64 %63 to i32
  %67 = mul i32 %66, 4
  %68 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 %67, i32 3, i32 0)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %68, ptr addrspace(6) inttoptr (i64 90624 to ptr addrspace(6)), i32 %67, i32 5, i32 0, <256 x i1> %61)
  %69 = add i64 %63, 1
  br label %62

70:                                               ; preds = %62
  %71 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %72

72:                                               ; preds = %75, %70
  %73 = phi i64 [ %82, %75 ], [ 0, %70 ]
  %74 = icmp slt i64 %73, 64
  br i1 %74, label %75, label %83

75:                                               ; preds = %72
  %76 = trunc i64 %73 to i32
  %77 = mul i32 %76, 256
  %78 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i32 %77, i32 0, i32 0)
  %79 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %78, float 0x3FB6A09E60000000, <256 x i1> %71)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %79, ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i32 %77, i32 2, i32 0, <256 x i1> %71)
  %80 = call <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float> %79, <256 x i1> %71)
  %81 = mul i32 %76, 4
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %80, ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 %81, i32 5, i32 0, <256 x i1> %61)
  %82 = add i64 %73, 1
  br label %72

83:                                               ; preds = %72
  br label %84

84:                                               ; preds = %83
  %85 = add i32 %58, 1
  br label %57, !llvm.loop !5

86:                                               ; preds = %57
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %87

87:                                               ; preds = %136, %86
  %88 = phi i32 [ %137, %136 ], [ 0, %86 ]
  %89 = icmp sle i32 %88, 0
  br i1 %89, label %90, label %138

90:                                               ; preds = %87
  %91 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %92 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %93 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90624 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %94 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %92, <64 x float> %93, <256 x i1> %91)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %94, ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %91)
  br label %95

95:                                               ; preds = %98, %90
  %96 = phi i64 [ %113, %98 ], [ 0, %90 ]
  %97 = icmp slt i64 %96, 64
  br i1 %97, label %98, label %114

98:                                               ; preds = %95
  %99 = trunc i64 %96 to i32
  %100 = mul i32 %99, 64
  %101 = mul i32 %99, 256
  %102 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i32 %101, i32 0, i32 0)
  %103 = udiv i32 %100, 64
  %104 = urem i32 %103, 64
  %105 = mul i32 %104, 4
  %106 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 %105, i32 3, i32 0)
  %107 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90624 to ptr addrspace(6)), i32 %105, i32 3, i32 0)
  %108 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %106, <64 x float> %107, <256 x i1> %91)
  %109 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %102, <64 x float> %108, <256 x i1> %91)
  %110 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %109, <256 x i1> %91)
  %111 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %110, <256 x i1> %91, i32 0, i32 0, i32 0)
  %112 = mul i32 %99, 128
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %111, ptr addrspace(6) inttoptr (i64 81920 to ptr addrspace(6)), i32 %112, i32 7, i32 0, <256 x i1> %91)
  %113 = add i64 %96, 1
  br label %95

114:                                              ; preds = %95
  %115 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %116

116:                                              ; preds = %119, %114
  %117 = phi i64 [ %134, %119 ], [ 0, %114 ]
  %118 = icmp slt i64 %117, 64
  br i1 %118, label %119, label %135

119:                                              ; preds = %116
  %120 = trunc i64 %117 to i32
  %121 = mul i32 %120, 64
  %122 = mul i32 %120, 256
  %123 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 65536 to ptr addrspace(6)), i32 %122, i32 0, i32 0)
  %124 = udiv i32 %121, 64
  %125 = urem i32 %124, 64
  %126 = mul i32 %125, 4
  %127 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 %126, i32 3, i32 0)
  %128 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90624 to ptr addrspace(6)), i32 %126, i32 3, i32 0)
  %129 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %127, <64 x float> %128, <256 x i1> %91)
  %130 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %123, <64 x float> %129, <256 x i1> %91)
  %131 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %130, <256 x i1> %91)
  %132 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %131, <256 x i1> %91)
  %133 = mul i32 %120, 4
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %132, ptr addrspace(6) inttoptr (i64 90880 to ptr addrspace(6)), i32 %133, i32 5, i32 0, <256 x i1> %115)
  %134 = add i64 %117, 1
  br label %116

135:                                              ; preds = %116
  br label %136

136:                                              ; preds = %135
  %137 = add i32 %88, 1
  br label %87, !llvm.loop !6

138:                                              ; preds = %87
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  br label %139

139:                                              ; preds = %152, %138
  %140 = phi i32 [ %153, %152 ], [ 0, %138 ]
  %141 = icmp sle i32 %140, 0
  br i1 %141, label %142, label %154

142:                                              ; preds = %139
  %143 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %144 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90624 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %145 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90368 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %146 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90112 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %147 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90880 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %148 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %144, <64 x float> %145, <256 x i1> %143)
  %149 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %148, <256 x i1> %143)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %149, ptr addrspace(6) inttoptr (i64 91136 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %143)
  %150 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %146, <64 x float> %149, <256 x i1> %143)
  %151 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %150, <64 x float> %147, <256 x i1> %143)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %151, ptr addrspace(6) inttoptr (i64 90112 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %143)
  br label %152

152:                                              ; preds = %142
  %153 = add i32 %140, 1
  br label %139, !llvm.loop !7

154:                                              ; preds = %139
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  br label %19

155:                                              ; preds = %186, %30
  %156 = phi i32 [ %187, %186 ], [ 0, %30 ]
  %157 = icmp sle i32 %156, 0
  br i1 %157, label %158, label %188

158:                                              ; preds = %155
  %159 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %160

160:                                              ; preds = %183, %158
  %161 = phi i64 [ %184, %183 ], [ 0, %158 ]
  %162 = icmp slt i64 %161, 64
  br i1 %162, label %163, label %185

163:                                              ; preds = %160
  %164 = trunc i64 %161 to i32
  %165 = mul i32 %164, 128
  %166 = udiv i32 %165, 128
  %167 = urem i32 %166, 64
  %168 = mul i32 %167, 4
  %169 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 91136 to ptr addrspace(6)), i32 %168, i32 3, i32 0)
  br label %170

170:                                              ; preds = %173, %163
  %171 = phi i64 [ %182, %173 ], [ 0, %163 ]
  %172 = icmp slt i64 %171, 2
  br i1 %172, label %173, label %183

173:                                              ; preds = %170
  %174 = trunc i64 %171 to i32
  %175 = mul i32 %174, 64
  %176 = add i32 %165, %175
  %177 = mul i32 %176, 4
  %178 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %177, i32 0, i32 0)
  %179 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %178, <64 x float> %169, <256 x i1> %159)
  %180 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i32 %177, i32 0, i32 0)
  %181 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %179, <64 x float> %180, <256 x i1> %159)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %181, ptr addrspace(6) null, i32 %177, i32 2, i32 0, <256 x i1> %159)
  %182 = add i64 %171, 1
  br label %170

183:                                              ; preds = %170
  %184 = add i64 %161, 1
  br label %160

185:                                              ; preds = %160
  br label %186

186:                                              ; preds = %185
  %187 = add i32 %156, 1
  br label %155, !llvm.loop !8

188:                                              ; preds = %155
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 1)
  %189 = add i64 %16, 1
  br label %15

190:                                              ; preds = %219, %31
  %191 = phi i32 [ %220, %219 ], [ 0, %31 ]
  %192 = icmp sle i32 %191, 0
  br i1 %192, label %193, label %221

193:                                              ; preds = %190
  %194 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %195

195:                                              ; preds = %216, %193
  %196 = phi i64 [ %217, %216 ], [ 0, %193 ]
  %197 = icmp slt i64 %196, 64
  br i1 %197, label %198, label %218

198:                                              ; preds = %195
  %199 = trunc i64 %196 to i32
  %200 = mul i32 %199, 128
  %201 = udiv i32 %200, 128
  %202 = urem i32 %201, 64
  %203 = mul i32 %202, 4
  %204 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 90112 to ptr addrspace(6)), i32 %203, i32 3, i32 0)
  br label %205

205:                                              ; preds = %208, %198
  %206 = phi i64 [ %215, %208 ], [ 0, %198 ]
  %207 = icmp slt i64 %206, 2
  br i1 %207, label %208, label %216

208:                                              ; preds = %205
  %209 = trunc i64 %206 to i32
  %210 = mul i32 %209, 64
  %211 = add i32 %200, %210
  %212 = mul i32 %211, 4
  %213 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %212, i32 0, i32 0)
  %214 = call <64 x float> @llvm.hivm.vdiv.s.x.v64f32(<64 x float> %213, <64 x float> %204, <256 x i1> %194)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %214, ptr addrspace(6) null, i32 %212, i32 2, i32 0, <256 x i1> %194)
  %215 = add i64 %206, 1
  br label %205

216:                                              ; preds = %205
  %217 = add i64 %196, 1
  br label %195

218:                                              ; preds = %195
  br label %219

219:                                              ; preds = %218
  %220 = add i32 %191, 1
  br label %190, !llvm.loop !9

221:                                              ; preds = %190
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  %222 = mul i32 %14, 64
  %223 = sext i32 %222 to i64
  %224 = mul i64 %223, 128
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %225 = ptrtoint ptr addrspace(1) %3 to i64
  %226 = mul i64 %224, 4
  %227 = add i64 %225, %226
  %228 = inttoptr i64 %227 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %228, ptr addrspace(6) null, i64 288230377225469952, i64 35184372088864)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 2)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %32
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
declare void @llvm.hivm.SET.MTE2.NZ.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

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
declare <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2), ptr addrspace(6), i64)

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
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
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 3)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 6)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 2)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 1)
  call void @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 65536 to ptr addrspace(2)), i1 true, i64 16, i64 256, i64 16, ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), i64 -1, i64 -1, i64 -1, i64 -1, i64 256, i64 -1, i64 -1, i8 0)
  call void @llvm.hivm.BARRIER(i64 6)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 35840 to ptr addrspace(6)), ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), i64 68720525568, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 10)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 5)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 0, i64 8)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 7)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 4)
  call void @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(ptr addrspace(2) inttoptr (i64 114688 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 81920 to ptr addrspace(2)), i1 true, i64 16, i64 256, i64 16, ptr addrspace(5) null, i64 -1, i64 -1, i64 -1, i64 -1, i64 256, i64 -1, i64 -1, i8 0)
  call void @llvm.hivm.BARRIER(i64 6)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), ptr addrspace(5) null, i64 68720525568, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 11)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 9)
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
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %16 = ptrtoint ptr addrspace(1) %1 to i64
  %17 = inttoptr i64 %16 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), ptr addrspace(1) %17, i64 72057594037928960, i64 16)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %18 = ptrtoint ptr addrspace(1) %2 to i64
  %19 = inttoptr i64 %18 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), ptr addrspace(1) %19, i64 72057594037928960, i64 16)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), ptr addrspace(2) null, i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 65536 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 2)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 3)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 81920 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 4)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 5)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %20

20:                                               ; preds = %56, %13
  %21 = phi i64 [ %57, %56 ], [ 0, %13 ]
  %22 = icmp slt i64 %21, 128
  br i1 %22, label %23, label %24

23:                                               ; preds = %20
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 3, i64 0)
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), ptr addrspace(2) null, i64 33554448)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %26

24:                                               ; preds = %20
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 3, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 6)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 3, i64 0)
  call void @llvm.hivm.MOV.L1.TO.L1.v310(ptr addrspace(2) inttoptr (i64 114688 to ptr addrspace(2)), ptr addrspace(2) inttoptr (i64 98304 to ptr addrspace(2)), i64 33554448)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 7)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 4, i64 8)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 11)
  br label %58

25:                                               ; preds = %101, %6
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
  %43 = getelementptr i8, ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), i64 %42
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
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) inttoptr (i64 98304 to ptr addrspace(2)), ptr addrspace(6) null, i64 4296016384)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  %57 = add i64 %21, 1
  br label %20

58:                                               ; preds = %76, %24
  %59 = phi i32 [ %77, %76 ], [ 0, %24 ]
  %60 = icmp sle i32 %59, 0
  br i1 %60, label %61, label %78

61:                                               ; preds = %58
  %62 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %63

63:                                               ; preds = %66, %61
  %64 = phi i64 [ %74, %66 ], [ 0, %61 ]
  %65 = icmp slt i64 %64, 4
  br i1 %65, label %66, label %75

66:                                               ; preds = %63
  %67 = trunc i64 %64 to i32
  %68 = mul i32 %67, 256
  %69 = sext i32 %68 to i64
  %70 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %69
  %71 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %70, i32 0, i32 0, i32 0)
  %72 = sext i32 %68 to i64
  %73 = getelementptr i8, ptr addrspace(6) inttoptr (i64 33792 to ptr addrspace(6)), i64 %72
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %71, ptr addrspace(6) %73, i32 0, i32 2, i32 0, <256 x i1> %62)
  %74 = add i64 %64, 1
  br label %63

75:                                               ; preds = %63
  br label %76

76:                                               ; preds = %75
  %77 = add i32 %59, 1
  br label %58, !llvm.loop !5

78:                                               ; preds = %58
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %79 = ptrtoint ptr addrspace(1) %3 to i64
  %80 = inttoptr i64 %79 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %80, ptr addrspace(6) inttoptr (i64 33792 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 10)
  br label %81

81:                                               ; preds = %99, %78
  %82 = phi i32 [ %100, %99 ], [ 0, %78 ]
  %83 = icmp sle i32 %82, 0
  br i1 %83, label %84, label %101

84:                                               ; preds = %81
  %85 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %86

86:                                               ; preds = %89, %84
  %87 = phi i64 [ %97, %89 ], [ 0, %84 ]
  %88 = icmp slt i64 %87, 4
  br i1 %88, label %89, label %98

89:                                               ; preds = %86
  %90 = trunc i64 %87 to i32
  %91 = mul i32 %90, 256
  %92 = sext i32 %91 to i64
  %93 = getelementptr i8, ptr addrspace(6) inttoptr (i64 35840 to ptr addrspace(6)), i64 %92
  %94 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %93, i32 0, i32 0, i32 0)
  %95 = sext i32 %91 to i64
  %96 = getelementptr i8, ptr addrspace(6) inttoptr (i64 34816 to ptr addrspace(6)), i64 %95
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %94, ptr addrspace(6) %96, i32 0, i32 2, i32 0, <256 x i1> %85)
  %97 = add i64 %87, 1
  br label %86

98:                                               ; preds = %86
  br label %99

99:                                               ; preds = %98
  %100 = add i32 %82, 1
  br label %81, !llvm.loop !6

101:                                              ; preds = %81
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %102 = ptrtoint ptr addrspace(1) %4 to i64
  %103 = inttoptr i64 %102 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %103, ptr addrspace(6) inttoptr (i64 34816 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 9)
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
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.LOOP3.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

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
declare void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6), ptr addrspace(2), i64)

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
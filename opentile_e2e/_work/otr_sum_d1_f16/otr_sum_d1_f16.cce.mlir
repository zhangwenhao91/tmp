module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d1_f16(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f16) : f16
    %6 = llvm.mlir.constant(64 : index) : i64
    %7 = llvm.mlir.constant(16 : index) : i64
    %8 = llvm.mlir.constant(0 : index) : i64
    %9 = llvm.mlir.constant(8192 : i64) : i64
    %10 = llvm.mlir.constant(1 : index) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(128 : index) : i64
    %13 = llvm.mlir.constant(4 : i32) : i32
    %14 = llvm.mlir.constant(14 : i32) : i32
    %15 = llvm.mlir.constant(256 : i32) : i32
    %16 = llvm.mlir.constant(512 : i32) : i32
    %17 = llvm.mlir.constant(128 : i32) : i32
    %18 = llvm.mlir.constant(12288 : i64) : i64
    %19 = llvm.mlir.constant(32 : i32) : i32
    %20 = llvm.mlir.constant(5 : i32) : i32
    %21 = llvm.mlir.constant(12544 : i64) : i64
    %22 = llvm.mlir.constant(7 : i32) : i32
    %23 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %24 = llvm.mlir.constant(35184372088864 : i64) : i64
    %25 = llvm.mlir.constant(288230377225454592 : i64) : i64
    %26 = llvm.mlir.constant(70368744177696 : i64) : i64
    %27 = cce.get.ctrl -> i64
    %28 = cce.sbitset0(%27, %3) : (i64, i64) -> i64
    cce.set.ctrl(%28) : i64
    %29 = cce.get.ctrl -> i64
    %30 = cce.sbitset1(%29, %2) : (i64, i64) -> i64
    cce.set.ctrl(%30) : i64
    %31 = cce.get_sub_block_idx -> i64
    %32 = llvm.icmp "eq" %31, %4 : i64
    llvm.cond_br %32, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb27
    llvm.return
  ^bb3(%33: i32):  // 2 preds: ^bb1, ^bb8
    %34 = llvm.icmp "sle" %33, %1 : i32
    llvm.cond_br %34, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %35 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%8 : i64)
  ^bb5(%36: i64):  // 2 preds: ^bb4, ^bb6
    %37 = llvm.icmp "slt" %36, %7 : i64
    llvm.cond_br %37, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %38 = llvm.mul %36, %12 : i64
    %39 = cce.vdups(%5, %35, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %40 = llvm.trunc %38 : i64 to i32
    %41 = llvm.mul %40, %11 : i32
    %42 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %43 = llvm.sext %41 : i32 to i64
    %44 = llvm.getelementptr %42[%43] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%39, %44, %1, %0, %1, %35) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %45 = llvm.add %36, %10 : i64
    llvm.br ^bb5(%45 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %46 = llvm.add %33, %0 : i32
    llvm.br ^bb3(%46 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %47 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %48 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %49 = llvm.inttoptr %48 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%47, %49, %25, %26) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%50: i32):  // 2 preds: ^bb9, ^bb15
    %51 = llvm.icmp "sle" %50, %1 : i32
    llvm.cond_br %51, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %52 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %53 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb12(%8 : i64)
  ^bb12(%54: i64):  // 2 preds: ^bb11, ^bb13
    %55 = llvm.icmp "slt" %54, %7 : i64
    llvm.cond_br %55, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %56 = llvm.trunc %54 : i64 to i32
    %57 = llvm.mul %56, %15 : i32
    %58 = llvm.mul %56, %16 : i32
    %59 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %60 = llvm.sext %57 : i32 to i64
    %61 = llvm.getelementptr %59[%60] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %62 = cce.intr.vldsx1.f16(%61, %1, %14, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %63 = cce.vcvtff.ext(%62, %52, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %64 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %65 = llvm.sext %58 : i32 to i64
    %66 = llvm.getelementptr %64[%65] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%63, %66, %1, %11, %1, %53) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %67 = llvm.add %57, %17 : i32
    %68 = llvm.add %58, %15 : i32
    %69 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %70 = llvm.sext %67 : i32 to i64
    %71 = llvm.getelementptr %69[%70] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %72 = cce.intr.vldsx1.f16(%71, %1, %14, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %73 = cce.vcvtff.ext(%72, %52, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %74 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %75 = llvm.sext %68 : i32 to i64
    %76 = llvm.getelementptr %74[%75] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%73, %76, %1, %11, %1, %53) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %77 = llvm.add %54, %10 : i64
    llvm.br ^bb12(%77 : i64)
  ^bb14:  // pred: ^bb12
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %78 = llvm.add %50, %0 : i32
    llvm.br ^bb10(%78 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    llvm.br ^bb17(%1 : i32)
  ^bb17(%79: i32):  // 2 preds: ^bb16, ^bb22
    %80 = llvm.icmp "sle" %79, %1 : i32
    llvm.cond_br %80, ^bb18, ^bb23
  ^bb18:  // pred: ^bb17
    %dst, %restElem = cce.plt(%19) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %81 = cce.pset(%11) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb19(%8 : i64)
  ^bb19(%82: i64):  // 2 preds: ^bb18, ^bb20
    %83 = llvm.icmp "slt" %82, %6 : i64
    llvm.cond_br %83, ^bb20, ^bb21
  ^bb20:  // pred: ^bb19
    %84 = llvm.trunc %82 : i64 to i32
    %85 = llvm.mul %84, %17 : i32
    %86 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %87 = llvm.sext %85 : i32 to i64
    %88 = llvm.getelementptr %86[%87] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %89 = cce.intr.vldsx1.f32(%88, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %90 = cce.vcadd(%89, %dst) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %91 = llvm.mul %84, %13 : i32
    %92 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %93 = llvm.sext %91 : i32 to i64
    %94 = llvm.getelementptr %92[%93] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%90, %94, %1, %20, %1, %81) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %95 = llvm.add %82, %10 : i64
    llvm.br ^bb19(%95 : i64)
  ^bb21:  // pred: ^bb19
    llvm.br ^bb22
  ^bb22:  // pred: ^bb21
    %96 = llvm.add %79, %0 : i32
    llvm.br ^bb17(%96 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb23:  // pred: ^bb17
    llvm.br ^bb24(%1 : i32)
  ^bb24(%97: i32):  // 2 preds: ^bb23, ^bb26
    %98 = llvm.icmp "sle" %97, %1 : i32
    llvm.cond_br %98, ^bb25, ^bb27
  ^bb25:  // pred: ^bb24
    %99 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %100 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %101 = cce.intr.vldsx1.f32(%100, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %102 = cce.vcvtff.trunc(%101, %99, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %103 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f16(%102, %103, %1, %22, %1, %99) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb26
  ^bb26:  // pred: ^bb25
    %104 = llvm.add %97, %0 : i32
    llvm.br ^bb24(%104 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb27:  // pred: ^bb24
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %105 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %106 = llvm.inttoptr %105 : i64 to !llvm.ptr<1>
    %107 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%106, %107, %23, %24) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


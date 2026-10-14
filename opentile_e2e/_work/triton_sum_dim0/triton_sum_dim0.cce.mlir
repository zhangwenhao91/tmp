module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @triton_sum_dim0(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f16) : f16
    %6 = llvm.mlir.constant(263 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(0 : index) : i64
    %9 = llvm.mlir.constant(16384 : i64) : i64
    %10 = llvm.mlir.constant(8 : index) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(32 : index) : i64
    %13 = llvm.mlir.constant(128 : index) : i64
    %14 = llvm.mlir.constant(4 : i32) : i32
    %15 = llvm.mlir.constant(14 : i32) : i32
    %16 = llvm.mlir.constant(256 : i32) : i32
    %17 = llvm.mlir.constant(512 : i32) : i32
    %18 = llvm.mlir.constant(128 : i32) : i32
    %19 = llvm.mlir.constant(24576 : i64) : i64
    %20 = llvm.mlir.constant(8 : i32) : i32
    %21 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %22 = llvm.mlir.constant(512 : index) : i64
    %23 = llvm.mlir.constant(24608 : i64) : i64
    %24 = llvm.mlir.constant(3 : i32) : i32
    %25 = llvm.mlir.constant(288230376218820624 : i64) : i64
    %26 = llvm.mlir.constant(2199023255554 : i64) : i64
    %27 = llvm.mlir.constant(32 : i32) : i32
    %28 = llvm.mlir.constant(2 : i64) : i64
    %29 = llvm.mlir.constant(8 : i64) : i64
    %30 = cce.get.ctrl -> i64
    %31 = cce.sbitset0(%30, %3) : (i64, i64) -> i64
    cce.set.ctrl(%31) : i64
    %32 = cce.get.ctrl -> i64
    %33 = cce.sbitset1(%32, %2) : (i64, i64) -> i64
    cce.set.ctrl(%33) : i64
    %34 = cce.get_sub_block_idx -> i64
    %35 = llvm.icmp "eq" %34, %4 : i64
    llvm.cond_br %35, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    llvm.br ^bb6(%1 : i32)
  ^bb2(%36: i64):  // 2 preds: ^bb3, ^bb12
    %37 = llvm.icmp "slt" %36, %6 : i64
    llvm.cond_br %37, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    %38 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %39 = llvm.inttoptr %38 : i64 to !llvm.ptr<1>
    %40 = llvm.getelementptr %39[%36] : (!llvm.ptr<1>, i64) -> !llvm.ptr<1>, f16
    %41 = llvm.load %40 : !llvm.ptr<1> -> f16
    %42 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %43 = llvm.mul %36, %29 : i64
    %44 = llvm.mul %43, %28 : i64
    %45 = llvm.getelementptr %42[%44] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %41, %45 : f16, !llvm.ptr<6>
    %46 = llvm.add %36, %7 : i64
    llvm.br ^bb2(%46 : i64)
  ^bb4:  // pred: ^bb2
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb13(%1 : i32)
  ^bb5:  // 2 preds: ^bb0, ^bb33
    llvm.return
  ^bb6(%47: i32):  // 2 preds: ^bb1, ^bb11
    %48 = llvm.icmp "sle" %47, %1 : i32
    llvm.cond_br %48, ^bb7, ^bb12
  ^bb7:  // pred: ^bb6
    %49 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%8 : i64)
  ^bb8(%50: i64):  // 2 preds: ^bb7, ^bb9
    %51 = llvm.icmp "slt" %50, %12 : i64
    llvm.cond_br %51, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %52 = llvm.mul %50, %13 : i64
    %53 = cce.vdups(%5, %49, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %54 = llvm.trunc %52 : i64 to i32
    %55 = llvm.mul %54, %11 : i32
    %56 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %57 = llvm.sext %55 : i32 to i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%53, %58, %1, %0, %1, %49) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %59 = llvm.add %50, %7 : i64
    llvm.br ^bb8(%59 : i64)
  ^bb10:  // pred: ^bb8
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %60 = llvm.add %47, %0 : i32
    llvm.br ^bb6(%60 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2(%8 : i64)
  ^bb13(%61: i32):  // 2 preds: ^bb4, ^bb18
    %62 = llvm.icmp "sle" %61, %1 : i32
    llvm.cond_br %62, ^bb14, ^bb19
  ^bb14:  // pred: ^bb13
    %63 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %64 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb15(%8 : i64)
  ^bb15(%65: i64):  // 2 preds: ^bb14, ^bb16
    %66 = llvm.icmp "slt" %65, %12 : i64
    llvm.cond_br %66, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %67 = llvm.trunc %65 : i64 to i32
    %68 = llvm.mul %67, %16 : i32
    %69 = llvm.mul %67, %17 : i32
    %70 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %71 = llvm.sext %68 : i32 to i64
    %72 = llvm.getelementptr %70[%71] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %73 = cce.intr.vldsx1.f16(%72, %1, %15, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %74 = cce.vcvtff.ext(%73, %63, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %75 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %76 = llvm.sext %69 : i32 to i64
    %77 = llvm.getelementptr %75[%76] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%74, %77, %1, %11, %1, %64) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %78 = llvm.add %68, %18 : i32
    %79 = llvm.add %69, %16 : i32
    %80 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %81 = llvm.sext %78 : i32 to i64
    %82 = llvm.getelementptr %80[%81] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %83 = cce.intr.vldsx1.f16(%82, %1, %15, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %84 = cce.vcvtff.ext(%83, %63, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %85 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %86 = llvm.sext %79 : i32 to i64
    %87 = llvm.getelementptr %85[%86] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%84, %87, %1, %11, %1, %64) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %88 = llvm.add %65, %7 : i64
    llvm.br ^bb15(%88 : i64)
  ^bb17:  // pred: ^bb15
    llvm.br ^bb18
  ^bb18:  // pred: ^bb17
    %89 = llvm.add %61, %0 : i32
    llvm.br ^bb13(%89 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb19:  // pred: ^bb13
    llvm.br ^bb20(%1 : i32)
  ^bb20(%90: i32):  // 2 preds: ^bb19, ^bb25
    %91 = llvm.icmp "sle" %90, %1 : i32
    llvm.cond_br %91, ^bb21, ^bb26
  ^bb21:  // pred: ^bb20
    %dst, %restElem = cce.plt(%20) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %92 = cce.vdups(%21, %dst, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    llvm.br ^bb22(%8, %92 : i64, vector<64xf32>)
  ^bb22(%93: i64, %94: vector<64xf32>):  // 2 preds: ^bb21, ^bb23
    %95 = llvm.icmp "slt" %93, %22 : i64
    llvm.cond_br %95, ^bb23, ^bb24
  ^bb23:  // pred: ^bb22
    %96 = llvm.trunc %93 : i64 to i32
    %97 = llvm.mul %96, %27 : i32
    %98 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %99 = llvm.sext %97 : i32 to i64
    %100 = llvm.getelementptr %98[%99] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %101 = cce.intr.vldsx1.f32(%100, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %102 = cce.vadd(%94, %101, %dst) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %103 = llvm.add %93, %7 : i64
    llvm.br ^bb22(%103, %102 : i64, vector<64xf32>)
  ^bb24:  // pred: ^bb22
    %104 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%94, %104, %1, %11, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %105 = llvm.add %90, %0 : i32
    llvm.br ^bb20(%105 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb20
    llvm.br ^bb27(%1 : i32)
  ^bb27(%106: i32):  // 2 preds: ^bb26, ^bb32
    %107 = llvm.icmp "sle" %106, %1 : i32
    llvm.cond_br %107, ^bb28, ^bb33
  ^bb28:  // pred: ^bb27
    %108 = cce.pset(%11) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %109 = cce.pset(%11) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb29(%8 : i64)
  ^bb29(%110: i64):  // 2 preds: ^bb28, ^bb30
    %111 = llvm.icmp "slt" %110, %10 : i64
    llvm.cond_br %111, ^bb30, ^bb31
  ^bb30:  // pred: ^bb29
    %112 = llvm.trunc %110 : i64 to i32
    %113 = llvm.mul %112, %14 : i32
    %114 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %115 = llvm.sext %113 : i32 to i64
    %116 = llvm.getelementptr %114[%115] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %117 = cce.intr.vldsx1.f32(%116, %1, %24, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %118 = cce.vcvtff.trunc(%117, %108, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %119 = llvm.mul %112, %11 : i32
    %120 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %121 = llvm.sext %119 : i32 to i64
    %122 = llvm.getelementptr %120[%121] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%118, %122, %1, %14, %1, %109) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %123 = llvm.add %110, %7 : i64
    llvm.br ^bb29(%123 : i64)
  ^bb31:  // pred: ^bb29
    llvm.br ^bb32
  ^bb32:  // pred: ^bb31
    %124 = llvm.add %106, %0 : i32
    llvm.br ^bb27(%124 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb33:  // pred: ^bb27
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %125 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %126 = llvm.inttoptr %125 : i64 to !llvm.ptr<1>
    %127 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%126, %127, %25, %26) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  }
}


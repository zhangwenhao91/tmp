module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @triton_sum_dim1(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f16) : f16
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(4096 : i64) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(2 : i32) : i32
    %10 = llvm.mlir.constant(8 : index) : i64
    %11 = llvm.mlir.constant(128 : index) : i64
    %12 = llvm.mlir.constant(4 : i32) : i32
    %13 = llvm.mlir.constant(14 : i32) : i32
    %14 = llvm.mlir.constant(256 : i32) : i32
    %15 = llvm.mlir.constant(512 : i32) : i32
    %16 = llvm.mlir.constant(128 : i32) : i32
    %17 = llvm.mlir.constant(6144 : i64) : i64
    %18 = llvm.mlir.constant(16 : i32) : i32
    %19 = llvm.mlir.constant(5 : i32) : i32
    %20 = llvm.mlir.constant(64 : index) : i64
    %21 = llvm.mlir.constant(6400 : i64) : i64
    %22 = llvm.mlir.constant(7 : i32) : i32
    %23 = llvm.mlir.constant(288230376353039248 : i64) : i64
    %24 = llvm.mlir.constant(35184372088838 : i64) : i64
    %25 = llvm.mlir.constant(288230379976917008 : i64) : i64
    %26 = llvm.mlir.constant(125344325566578 : i64) : i64
    %27 = llvm.mlir.constant(64 : i32) : i32
    %28 = cce.get.ctrl -> i64
    %29 = cce.sbitset0(%28, %3) : (i64, i64) -> i64
    cce.set.ctrl(%29) : i64
    %30 = cce.get.ctrl -> i64
    %31 = cce.sbitset1(%30, %2) : (i64, i64) -> i64
    cce.set.ctrl(%31) : i64
    %32 = cce.get_sub_block_idx -> i64
    %33 = llvm.icmp "eq" %32, %4 : i64
    llvm.cond_br %33, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb27
    llvm.return
  ^bb3(%34: i32):  // 2 preds: ^bb1, ^bb8
    %35 = llvm.icmp "sle" %34, %1 : i32
    llvm.cond_br %35, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %36 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%6 : i64)
  ^bb5(%37: i64):  // 2 preds: ^bb4, ^bb6
    %38 = llvm.icmp "slt" %37, %10 : i64
    llvm.cond_br %38, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %39 = llvm.mul %37, %11 : i64
    %40 = cce.vdups(%5, %36, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %41 = llvm.trunc %39 : i64 to i32
    %42 = llvm.mul %41, %9 : i32
    %43 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %44 = llvm.sext %42 : i32 to i64
    %45 = llvm.getelementptr %43[%44] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%40, %45, %1, %0, %1, %36) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %46 = llvm.add %37, %8 : i64
    llvm.br ^bb5(%46 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %47 = llvm.add %34, %0 : i32
    llvm.br ^bb3(%47 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %48 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %49 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %50 = llvm.inttoptr %49 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%48, %50, %23, %24) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%51: i32):  // 2 preds: ^bb9, ^bb15
    %52 = llvm.icmp "sle" %51, %1 : i32
    llvm.cond_br %52, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %53 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %54 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb12(%6 : i64)
  ^bb12(%55: i64):  // 2 preds: ^bb11, ^bb13
    %56 = llvm.icmp "slt" %55, %10 : i64
    llvm.cond_br %56, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %57 = llvm.trunc %55 : i64 to i32
    %58 = llvm.mul %57, %14 : i32
    %59 = llvm.mul %57, %15 : i32
    %60 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %61 = llvm.sext %58 : i32 to i64
    %62 = llvm.getelementptr %60[%61] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %63 = cce.intr.vldsx1.f16(%62, %1, %13, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %64 = cce.vcvtff.ext(%63, %53, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %65 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %66 = llvm.sext %59 : i32 to i64
    %67 = llvm.getelementptr %65[%66] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%64, %67, %1, %9, %1, %54) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %68 = llvm.add %58, %16 : i32
    %69 = llvm.add %59, %14 : i32
    %70 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %71 = llvm.sext %68 : i32 to i64
    %72 = llvm.getelementptr %70[%71] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %73 = cce.intr.vldsx1.f16(%72, %1, %13, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %74 = cce.vcvtff.ext(%73, %53, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %75 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %76 = llvm.sext %69 : i32 to i64
    %77 = llvm.getelementptr %75[%76] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%74, %77, %1, %9, %1, %54) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %78 = llvm.add %55, %8 : i64
    llvm.br ^bb12(%78 : i64)
  ^bb14:  // pred: ^bb12
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %79 = llvm.add %51, %0 : i32
    llvm.br ^bb10(%79 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    llvm.br ^bb17(%1 : i32)
  ^bb17(%80: i32):  // 2 preds: ^bb16, ^bb22
    %81 = llvm.icmp "sle" %80, %1 : i32
    llvm.cond_br %81, ^bb18, ^bb23
  ^bb18:  // pred: ^bb17
    %dst, %restElem = cce.plt(%18) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %82 = cce.pset(%9) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb19(%6 : i64)
  ^bb19(%83: i64):  // 2 preds: ^bb18, ^bb20
    %84 = llvm.icmp "slt" %83, %20 : i64
    llvm.cond_br %84, ^bb20, ^bb21
  ^bb20:  // pred: ^bb19
    %85 = llvm.trunc %83 : i64 to i32
    %86 = llvm.mul %85, %27 : i32
    %87 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %88 = llvm.sext %86 : i32 to i64
    %89 = llvm.getelementptr %87[%88] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %90 = cce.intr.vldsx1.f32(%89, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %91 = cce.vcadd(%90, %dst) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %92 = llvm.mul %85, %12 : i32
    %93 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %94 = llvm.sext %92 : i32 to i64
    %95 = llvm.getelementptr %93[%94] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%91, %95, %1, %19, %1, %82) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %96 = llvm.add %83, %8 : i64
    llvm.br ^bb19(%96 : i64)
  ^bb21:  // pred: ^bb19
    llvm.br ^bb22
  ^bb22:  // pred: ^bb21
    %97 = llvm.add %80, %0 : i32
    llvm.br ^bb17(%97 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb23:  // pred: ^bb17
    llvm.br ^bb24(%1 : i32)
  ^bb24(%98: i32):  // 2 preds: ^bb23, ^bb26
    %99 = llvm.icmp "sle" %98, %1 : i32
    llvm.cond_br %99, ^bb25, ^bb27
  ^bb25:  // pred: ^bb24
    %100 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %101 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %102 = cce.intr.vldsx1.f32(%101, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %103 = cce.vcvtff.trunc(%102, %100, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %104 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f16(%103, %104, %1, %22, %1, %100) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb26
  ^bb26:  // pred: ^bb25
    %105 = llvm.add %98, %0 : i32
    llvm.br ^bb24(%105 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb27:  // pred: ^bb24
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %106 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %107 = llvm.inttoptr %106 : i64 to !llvm.ptr<1>
    %108 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%107, %108, %25, %26) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


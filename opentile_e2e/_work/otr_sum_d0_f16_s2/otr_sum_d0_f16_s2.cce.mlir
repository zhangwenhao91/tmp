module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d0_f16_s2(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f16) : f16
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(16384 : i64) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(32 : index) : i64
    %10 = llvm.mlir.constant(2 : i32) : i32
    %11 = llvm.mlir.constant(128 : index) : i64
    %12 = llvm.mlir.constant(14 : i32) : i32
    %13 = llvm.mlir.constant(256 : i32) : i32
    %14 = llvm.mlir.constant(512 : i32) : i32
    %15 = llvm.mlir.constant(128 : i32) : i32
    %16 = llvm.mlir.constant(24576 : i64) : i64
    %17 = llvm.mlir.constant(32 : i32) : i32
    %18 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %19 = llvm.mlir.constant(24704 : i64) : i64
    %20 = llvm.mlir.constant(7 : i32) : i32
    %21 = llvm.mlir.constant(288230377493890624 : i64) : i64
    %22 = llvm.mlir.constant(70368744177704 : i64) : i64
    %23 = llvm.mlir.constant(288230377493889040 : i64) : i64
    %24 = llvm.mlir.constant(43980465111080 : i64) : i64
    %25 = cce.get.ctrl -> i64
    %26 = cce.sbitset0(%25, %3) : (i64, i64) -> i64
    cce.set.ctrl(%26) : i64
    %27 = cce.get.ctrl -> i64
    %28 = cce.sbitset1(%27, %2) : (i64, i64) -> i64
    cce.set.ctrl(%28) : i64
    %29 = cce.get_sub_block_idx -> i64
    %30 = llvm.icmp "eq" %29, %4 : i64
    llvm.cond_br %30, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb27
    llvm.return
  ^bb3(%31: i32):  // 2 preds: ^bb1, ^bb8
    %32 = llvm.icmp "sle" %31, %1 : i32
    llvm.cond_br %32, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %33 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%6 : i64)
  ^bb5(%34: i64):  // 2 preds: ^bb4, ^bb6
    %35 = llvm.icmp "slt" %34, %9 : i64
    llvm.cond_br %35, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %36 = llvm.mul %34, %11 : i64
    %37 = cce.vdups(%5, %33, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %38 = llvm.trunc %36 : i64 to i32
    %39 = llvm.mul %38, %10 : i32
    %40 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %41 = llvm.sext %39 : i32 to i64
    %42 = llvm.getelementptr %40[%41] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%37, %42, %1, %0, %1, %33) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %43 = llvm.add %34, %8 : i64
    llvm.br ^bb5(%43 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %44 = llvm.add %31, %0 : i32
    llvm.br ^bb3(%44 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %45 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %46 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %47 = llvm.inttoptr %46 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%45, %47, %21, %22) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%48: i32):  // 2 preds: ^bb9, ^bb15
    %49 = llvm.icmp "sle" %48, %1 : i32
    llvm.cond_br %49, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %50 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %51 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb12(%6 : i64)
  ^bb12(%52: i64):  // 2 preds: ^bb11, ^bb13
    %53 = llvm.icmp "slt" %52, %9 : i64
    llvm.cond_br %53, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %54 = llvm.trunc %52 : i64 to i32
    %55 = llvm.mul %54, %13 : i32
    %56 = llvm.mul %54, %14 : i32
    %57 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %58 = llvm.sext %55 : i32 to i64
    %59 = llvm.getelementptr %57[%58] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %60 = cce.intr.vldsx1.f16(%59, %1, %12, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %61 = cce.vcvtff.ext(%60, %50, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %62 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %63 = llvm.sext %56 : i32 to i64
    %64 = llvm.getelementptr %62[%63] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%61, %64, %1, %10, %1, %51) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %65 = llvm.add %55, %15 : i32
    %66 = llvm.add %56, %13 : i32
    %67 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %68 = llvm.sext %65 : i32 to i64
    %69 = llvm.getelementptr %67[%68] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %70 = cce.intr.vldsx1.f16(%69, %1, %12, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %71 = cce.vcvtff.ext(%70, %50, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %72 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %73 = llvm.sext %66 : i32 to i64
    %74 = llvm.getelementptr %72[%73] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%71, %74, %1, %10, %1, %51) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %75 = llvm.add %52, %8 : i64
    llvm.br ^bb12(%75 : i64)
  ^bb14:  // pred: ^bb12
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %76 = llvm.add %48, %0 : i32
    llvm.br ^bb10(%76 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    llvm.br ^bb17(%1 : i32)
  ^bb17(%77: i32):  // 2 preds: ^bb16, ^bb22
    %78 = llvm.icmp "sle" %77, %1 : i32
    llvm.cond_br %78, ^bb18, ^bb23
  ^bb18:  // pred: ^bb17
    %dst, %restElem = cce.plt(%17) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %79 = cce.vdups(%18, %dst, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    llvm.br ^bb19(%6, %79 : i64, vector<64xf32>)
  ^bb19(%80: i64, %81: vector<64xf32>):  // 2 preds: ^bb18, ^bb20
    %82 = llvm.icmp "slt" %80, %11 : i64
    llvm.cond_br %82, ^bb20, ^bb21
  ^bb20:  // pred: ^bb19
    %83 = llvm.trunc %80 : i64 to i32
    %84 = llvm.mul %83, %15 : i32
    %85 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %86 = llvm.sext %84 : i32 to i64
    %87 = llvm.getelementptr %85[%86] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %88 = cce.intr.vldsx1.f32(%87, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %89 = cce.vadd(%81, %88, %dst) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %90 = llvm.add %80, %8 : i64
    llvm.br ^bb19(%90, %89 : i64, vector<64xf32>)
  ^bb21:  // pred: ^bb19
    %91 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%81, %91, %1, %10, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb22
  ^bb22:  // pred: ^bb21
    %92 = llvm.add %77, %0 : i32
    llvm.br ^bb17(%92 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb23:  // pred: ^bb17
    llvm.br ^bb24(%1 : i32)
  ^bb24(%93: i32):  // 2 preds: ^bb23, ^bb26
    %94 = llvm.icmp "sle" %93, %1 : i32
    llvm.cond_br %94, ^bb25, ^bb27
  ^bb25:  // pred: ^bb24
    %dst_0, %restElem_1 = cce.plt(%17) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %95 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %96 = cce.intr.vldsx1.f32(%95, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %97 = cce.vcvtff.trunc(%96, %dst_0, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %98 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f16(%97, %98, %1, %20, %1, %dst_0) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb26
  ^bb26:  // pred: ^bb25
    %99 = llvm.add %93, %0 : i32
    llvm.br ^bb24(%99 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb27:  // pred: ^bb24
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %100 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %101 = llvm.inttoptr %100 : i64 to !llvm.ptr<1>
    %102 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%101, %102, %23, %24) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


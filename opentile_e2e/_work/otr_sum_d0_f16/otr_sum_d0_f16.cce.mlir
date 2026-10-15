module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d0_f16(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
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
    %13 = llvm.mlir.constant(14 : i32) : i32
    %14 = llvm.mlir.constant(256 : i32) : i32
    %15 = llvm.mlir.constant(512 : i32) : i32
    %16 = llvm.mlir.constant(128 : i32) : i32
    %17 = llvm.mlir.constant(12288 : i64) : i64
    %18 = llvm.mlir.constant(32 : i32) : i32
    %19 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %20 = llvm.mlir.constant(12416 : i64) : i64
    %21 = llvm.mlir.constant(7 : i32) : i32
    %22 = llvm.mlir.constant(288230377225454592 : i64) : i64
    %23 = llvm.mlir.constant(70368744177696 : i64) : i64
    %24 = llvm.mlir.constant(288230377225453584 : i64) : i64
    %25 = llvm.mlir.constant(35184372088864 : i64) : i64
    %26 = cce.get.ctrl -> i64
    %27 = cce.sbitset0(%26, %3) : (i64, i64) -> i64
    cce.set.ctrl(%27) : i64
    %28 = cce.get.ctrl -> i64
    %29 = cce.sbitset1(%28, %2) : (i64, i64) -> i64
    cce.set.ctrl(%29) : i64
    %30 = cce.get_sub_block_idx -> i64
    %31 = llvm.icmp "eq" %30, %4 : i64
    llvm.cond_br %31, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb27
    llvm.return
  ^bb3(%32: i32):  // 2 preds: ^bb1, ^bb8
    %33 = llvm.icmp "sle" %32, %1 : i32
    llvm.cond_br %33, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %34 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%8 : i64)
  ^bb5(%35: i64):  // 2 preds: ^bb4, ^bb6
    %36 = llvm.icmp "slt" %35, %7 : i64
    llvm.cond_br %36, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %37 = llvm.mul %35, %12 : i64
    %38 = cce.vdups(%5, %34, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %39 = llvm.trunc %37 : i64 to i32
    %40 = llvm.mul %39, %11 : i32
    %41 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %42 = llvm.sext %40 : i32 to i64
    %43 = llvm.getelementptr %41[%42] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%38, %43, %1, %0, %1, %34) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %44 = llvm.add %35, %10 : i64
    llvm.br ^bb5(%44 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %45 = llvm.add %32, %0 : i32
    llvm.br ^bb3(%45 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %46 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %47 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %48 = llvm.inttoptr %47 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%46, %48, %22, %23) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%49: i32):  // 2 preds: ^bb9, ^bb15
    %50 = llvm.icmp "sle" %49, %1 : i32
    llvm.cond_br %50, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %51 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %52 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb12(%8 : i64)
  ^bb12(%53: i64):  // 2 preds: ^bb11, ^bb13
    %54 = llvm.icmp "slt" %53, %7 : i64
    llvm.cond_br %54, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %55 = llvm.trunc %53 : i64 to i32
    %56 = llvm.mul %55, %14 : i32
    %57 = llvm.mul %55, %15 : i32
    %58 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %59 = llvm.sext %56 : i32 to i64
    %60 = llvm.getelementptr %58[%59] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %61 = cce.intr.vldsx1.f16(%60, %1, %13, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %62 = cce.vcvtff.ext(%61, %51, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %63 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %64 = llvm.sext %57 : i32 to i64
    %65 = llvm.getelementptr %63[%64] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%62, %65, %1, %11, %1, %52) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %66 = llvm.add %56, %16 : i32
    %67 = llvm.add %57, %14 : i32
    %68 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %69 = llvm.sext %66 : i32 to i64
    %70 = llvm.getelementptr %68[%69] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %71 = cce.intr.vldsx1.f16(%70, %1, %13, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %72 = cce.vcvtff.ext(%71, %51, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %73 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %74 = llvm.sext %67 : i32 to i64
    %75 = llvm.getelementptr %73[%74] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%72, %75, %1, %11, %1, %52) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %76 = llvm.add %53, %10 : i64
    llvm.br ^bb12(%76 : i64)
  ^bb14:  // pred: ^bb12
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %77 = llvm.add %49, %0 : i32
    llvm.br ^bb10(%77 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    llvm.br ^bb17(%1 : i32)
  ^bb17(%78: i32):  // 2 preds: ^bb16, ^bb22
    %79 = llvm.icmp "sle" %78, %1 : i32
    llvm.cond_br %79, ^bb18, ^bb23
  ^bb18:  // pred: ^bb17
    %dst, %restElem = cce.plt(%18) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %80 = cce.vdups(%19, %dst, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    llvm.br ^bb19(%8, %80 : i64, vector<64xf32>)
  ^bb19(%81: i64, %82: vector<64xf32>):  // 2 preds: ^bb18, ^bb20
    %83 = llvm.icmp "slt" %81, %6 : i64
    llvm.cond_br %83, ^bb20, ^bb21
  ^bb20:  // pred: ^bb19
    %84 = llvm.trunc %81 : i64 to i32
    %85 = llvm.mul %84, %16 : i32
    %86 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %87 = llvm.sext %85 : i32 to i64
    %88 = llvm.getelementptr %86[%87] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %89 = cce.intr.vldsx1.f32(%88, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %90 = cce.vadd(%82, %89, %dst) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %91 = llvm.add %81, %10 : i64
    llvm.br ^bb19(%91, %90 : i64, vector<64xf32>)
  ^bb21:  // pred: ^bb19
    %92 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%82, %92, %1, %11, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb22
  ^bb22:  // pred: ^bb21
    %93 = llvm.add %78, %0 : i32
    llvm.br ^bb17(%93 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb23:  // pred: ^bb17
    llvm.br ^bb24(%1 : i32)
  ^bb24(%94: i32):  // 2 preds: ^bb23, ^bb26
    %95 = llvm.icmp "sle" %94, %1 : i32
    llvm.cond_br %95, ^bb25, ^bb27
  ^bb25:  // pred: ^bb24
    %dst_0, %restElem_1 = cce.plt(%18) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %96 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %97 = cce.intr.vldsx1.f32(%96, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %98 = cce.vcvtff.trunc(%97, %dst_0, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %99 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f16(%98, %99, %1, %21, %1, %dst_0) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb26
  ^bb26:  // pred: ^bb25
    %100 = llvm.add %94, %0 : i32
    llvm.br ^bb24(%100 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb27:  // pred: ^bb24
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %101 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %102 = llvm.inttoptr %101 : i64 to !llvm.ptr<1>
    %103 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%102, %103, %24, %25) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


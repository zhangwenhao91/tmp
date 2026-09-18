module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub2ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(128 : index) : i64
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(16384 : i64) : i64
    %9 = llvm.mlir.constant(288230377225461760 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(64 : index) : i64
    %13 = llvm.mlir.constant(256 : i32) : i32
    %14 = cce.get.ctrl -> i64
    %15 = cce.sbitset0(%14, %3) : (i64, i64) -> i64
    cce.set.ctrl(%15) : i64
    %16 = cce.get.ctrl -> i64
    %17 = cce.sbitset1(%16, %2) : (i64, i64) -> i64
    cce.set.ctrl(%17) : i64
    %18 = cce.get_sub_block_idx -> i64
    %19 = llvm.icmp "eq" %18, %4 : i64
    llvm.cond_br %19, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    %20 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %21 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %22 = llvm.inttoptr %21 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%20, %22, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%23: i64):  // 2 preds: ^bb1, ^bb12
    %24 = llvm.icmp "slt" %23, %5 : i64
    llvm.cond_br %24, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %25 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %26 = llvm.inttoptr %25 : i64 to !llvm.ptr<1>
    %27 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%26, %27, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%28: i32):  // 2 preds: ^bb3, ^bb11
    %29 = llvm.icmp "sle" %28, %1 : i32
    llvm.cond_br %29, ^bb7, ^bb12
  ^bb7:  // pred: ^bb6
    %30 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%31: i64):  // 2 preds: ^bb7, ^bb9
    %32 = llvm.icmp "slt" %31, %12 : i64
    llvm.cond_br %32, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %33 = llvm.trunc %31 : i64 to i32
    %34 = llvm.mul %33, %13 : i32
    %35 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %36 = llvm.sext %34 : i32 to i64
    %37 = llvm.getelementptr %35[%36] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %38 = cce.intr.vldsx1.f32(%37, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %39 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %40 = llvm.sext %34 : i32 to i64
    %41 = llvm.getelementptr %39[%40] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%38, %41, %1, %11, %1, %30) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %42 = llvm.add %31, %7 : i64
    llvm.br ^bb8(%42 : i64)
  ^bb10:  // pred: ^bb8
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %43 = llvm.add %28, %0 : i32
    llvm.br ^bb6(%43 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb6
    %44 = llvm.add %23, %7 : i64
    llvm.br ^bb2(%44 : i64)
  }
}


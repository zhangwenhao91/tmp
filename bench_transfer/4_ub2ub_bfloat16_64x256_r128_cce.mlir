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
    %8 = llvm.mlir.constant(32768 : i64) : i64
    %9 = llvm.mlir.constant(288230377225469952 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(256 : i32) : i32
    %12 = cce.get.ctrl -> i64
    %13 = cce.sbitset0(%12, %3) : (i64, i64) -> i64
    cce.set.ctrl(%13) : i64
    %14 = cce.get.ctrl -> i64
    %15 = cce.sbitset1(%14, %2) : (i64, i64) -> i64
    cce.set.ctrl(%15) : i64
    %16 = cce.get_sub_block_idx -> i64
    %17 = llvm.icmp "eq" %16, %4 : i64
    llvm.cond_br %17, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    %18 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %19 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %20 = llvm.inttoptr %19 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%18, %20, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%21: i64):  // 2 preds: ^bb1, ^bb12
    %22 = llvm.icmp "slt" %21, %5 : i64
    llvm.cond_br %22, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %23 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %24 = llvm.inttoptr %23 : i64 to !llvm.ptr<1>
    %25 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%24, %25, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%26: i32):  // 2 preds: ^bb3, ^bb11
    %27 = llvm.icmp "sle" %26, %1 : i32
    llvm.cond_br %27, ^bb7, ^bb12
  ^bb7:  // pred: ^bb6
    %28 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%29: i64):  // 2 preds: ^bb7, ^bb9
    %30 = llvm.icmp "slt" %29, %5 : i64
    llvm.cond_br %30, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %31 = llvm.trunc %29 : i64 to i32
    %32 = llvm.mul %31, %11 : i32
    %33 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %34 = llvm.sext %32 : i32 to i64
    %35 = llvm.getelementptr %33[%34] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %36 = cce.intr.vldsx1.bf16(%35, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %37 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %38 = llvm.sext %32 : i32 to i64
    %39 = llvm.getelementptr %37[%38] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%36, %39, %1, %0, %1, %28) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %40 = llvm.add %29, %7 : i64
    llvm.br ^bb8(%40 : i64)
  ^bb10:  // pred: ^bb8
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %41 = llvm.add %26, %0 : i32
    llvm.br ^bb6(%41 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb6
    %42 = llvm.add %21, %7 : i64
    llvm.br ^bb2(%42 : i64)
  }
}


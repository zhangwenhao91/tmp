module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub_scalar_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(256 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %4 = llvm.mlir.constant(16 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %5 = llvm.mlir.constant(0 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %6 = llvm.mlir.constant(1 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %7 = llvm.mlir.constant(8192 : i64) : i64
    %8 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %9 = llvm.mlir.constant(35184372088864 : i64) : i64
    %10 = llvm.mlir.constant(256 : i64) : i64
    %11 = cce.get.ctrl -> i64
    %12 = cce.sbitset0(%11, %1) : (i64, i64) -> i64
    cce.set.ctrl(%12) : i64
    %13 = cce.get.ctrl -> i64
    %14 = cce.sbitset1(%13, %0) : (i64, i64) -> i64
    cce.set.ctrl(%14) : i64
    %15 = cce.get_sub_block_idx -> i64
    %16 = llvm.icmp "eq" %15, %2 : i64
    llvm.cond_br %16, ^bb1, ^bb11
  ^bb1:  // pred: ^bb0
    %17 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %18 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %19 = llvm.inttoptr %18 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%17, %19, %8, %9) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%5 : i64)
  ^bb2(%20: i64):  // 2 preds: ^bb1, ^bb9
    %21 = llvm.icmp "slt" %20, %4 : i64
    llvm.cond_br %21, ^bb3, ^bb10
  ^bb3:  // pred: ^bb2
    llvm.br ^bb4(%5 : i64)
  ^bb4(%22: i64):  // 2 preds: ^bb3, ^bb8
    %23 = llvm.icmp "slt" %22, %4 : i64
    llvm.cond_br %23, ^bb5, ^bb9
  ^bb5:  // pred: ^bb4
    llvm.br ^bb6(%5 : i64)
  ^bb6(%24: i64):  // 2 preds: ^bb5, ^bb7
    %25 = llvm.icmp "slt" %24, %3 : i64
    llvm.cond_br %25, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %26 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %27 = llvm.mul %22, %10 : i64
    %28 = llvm.add %27, %24 : i64
    %29 = llvm.getelementptr %26[%28] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, bf16
    %30 = llvm.load %29 : !llvm.ptr<6> -> bf16
    %31 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %32 = llvm.mul %22, %10 : i64
    %33 = llvm.add %32, %24 : i64
    %34 = llvm.getelementptr %31[%33] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, bf16
    llvm.store %30, %34 : bf16, !llvm.ptr<6>
    %35 = llvm.add %24, %6 : i64
    llvm.br ^bb6(%35 : i64)
  ^bb8:  // pred: ^bb6
    %36 = llvm.add %22, %6 : i64
    llvm.br ^bb4(%36 : i64)
  ^bb9:  // pred: ^bb4
    %37 = llvm.add %20, %6 : i64
    llvm.br ^bb2(%37 : i64)
  ^bb10:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %38 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %39 = llvm.inttoptr %38 : i64 to !llvm.ptr<1>
    %40 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%39, %40, %8, %9) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb11
  ^bb11:  // 2 preds: ^bb0, ^bb10
    llvm.return
  }
}


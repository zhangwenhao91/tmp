module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub_scalar_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(8 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %4 = llvm.mlir.constant(128 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %5 = llvm.mlir.constant(0 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %6 = llvm.mlir.constant(1 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %7 = llvm.mlir.constant(32 : i64) : i64
    %8 = llvm.mlir.constant(288230376688582672 : i64) : i64
    %9 = llvm.mlir.constant(17592186044432 : i64) : i64
    %10 = cce.get.ctrl -> i64
    %11 = cce.sbitset0(%10, %1) : (i64, i64) -> i64
    cce.set.ctrl(%11) : i64
    %12 = cce.get.ctrl -> i64
    %13 = cce.sbitset1(%12, %0) : (i64, i64) -> i64
    cce.set.ctrl(%13) : i64
    %14 = cce.get_sub_block_idx -> i64
    %15 = llvm.icmp "eq" %14, %2 : i64
    llvm.cond_br %15, ^bb1, ^bb8
  ^bb1:  // pred: ^bb0
    %16 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %17 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %18 = llvm.inttoptr %17 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%16, %18, %8, %9) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%5 : i64)
  ^bb2(%19: i64):  // 2 preds: ^bb1, ^bb6
    %20 = llvm.icmp "slt" %19, %4 : i64
    llvm.cond_br %20, ^bb3, ^bb7
  ^bb3:  // pred: ^bb2
    llvm.br ^bb4(%5 : i64)
  ^bb4(%21: i64):  // 2 preds: ^bb3, ^bb5
    %22 = llvm.icmp "slt" %21, %3 : i64
    llvm.cond_br %22, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %23 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %24 = llvm.getelementptr %23[%21] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, bf16
    %25 = llvm.load %24 : !llvm.ptr<6> -> bf16
    %26 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %27 = llvm.getelementptr %26[%21] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, bf16
    llvm.store %25, %27 : bf16, !llvm.ptr<6>
    %28 = llvm.add %21, %6 : i64
    llvm.br ^bb4(%28 : i64)
  ^bb6:  // pred: ^bb4
    %29 = llvm.add %19, %6 : i64
    llvm.br ^bb2(%29 : i64)
  ^bb7:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %30 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %31 = llvm.inttoptr %30 : i64 to !llvm.ptr<1>
    %32 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%31, %32, %8, %9) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb8
  ^bb8:  // 2 preds: ^bb0, ^bb7
    llvm.return
  }
}


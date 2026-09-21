module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub_scalar_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(16 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %4 = llvm.mlir.constant(0 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %5 = llvm.mlir.constant(1 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %6 = llvm.mlir.constant(1024 : i64) : i64
    %7 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %8 = llvm.mlir.constant(35184372088864 : i64) : i64
    %9 = llvm.mlir.constant(16 : i64) : i64
    %10 = cce.get.ctrl -> i64
    %11 = cce.sbitset0(%10, %1) : (i64, i64) -> i64
    cce.set.ctrl(%11) : i64
    %12 = cce.get.ctrl -> i64
    %13 = cce.sbitset1(%12, %0) : (i64, i64) -> i64
    cce.set.ctrl(%13) : i64
    %14 = cce.get_sub_block_idx -> i64
    %15 = llvm.icmp "eq" %14, %2 : i64
    llvm.cond_br %15, ^bb1, ^bb11
  ^bb1:  // pred: ^bb0
    %16 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %17 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %18 = llvm.inttoptr %17 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%16, %18, %7, %8) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%4 : i64)
  ^bb2(%19: i64):  // 2 preds: ^bb1, ^bb9
    %20 = llvm.icmp "slt" %19, %3 : i64
    llvm.cond_br %20, ^bb3, ^bb10
  ^bb3:  // pred: ^bb2
    llvm.br ^bb4(%4 : i64)
  ^bb4(%21: i64):  // 2 preds: ^bb3, ^bb8
    %22 = llvm.icmp "slt" %21, %3 : i64
    llvm.cond_br %22, ^bb5, ^bb9
  ^bb5:  // pred: ^bb4
    llvm.br ^bb6(%4 : i64)
  ^bb6(%23: i64):  // 2 preds: ^bb5, ^bb7
    %24 = llvm.icmp "slt" %23, %3 : i64
    llvm.cond_br %24, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %25 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %26 = llvm.mul %21, %9 : i64
    %27 = llvm.add %26, %23 : i64
    %28 = llvm.getelementptr %25[%27] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, f32
    %29 = llvm.load %28 : !llvm.ptr<6> -> f32
    %30 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %31 = llvm.mul %21, %9 : i64
    %32 = llvm.add %31, %23 : i64
    %33 = llvm.getelementptr %30[%32] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, f32
    llvm.store %29, %33 : f32, !llvm.ptr<6>
    %34 = llvm.add %23, %5 : i64
    llvm.br ^bb6(%34 : i64)
  ^bb8:  // pred: ^bb6
    %35 = llvm.add %21, %5 : i64
    llvm.br ^bb4(%35 : i64)
  ^bb9:  // pred: ^bb4
    %36 = llvm.add %19, %5 : i64
    llvm.br ^bb2(%36 : i64)
  ^bb10:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %37 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %38 = llvm.inttoptr %37 : i64 to !llvm.ptr<1>
    %39 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%38, %39, %7, %8) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb11
  ^bb11:  // 2 preds: ^bb0, ^bb10
    llvm.return
  }
}


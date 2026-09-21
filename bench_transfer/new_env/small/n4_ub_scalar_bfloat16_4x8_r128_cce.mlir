module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub_scalar_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(8 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %4 = llvm.mlir.constant(4 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %5 = llvm.mlir.constant(128 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %6 = llvm.mlir.constant(0 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %7 = llvm.mlir.constant(1 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %8 = llvm.mlir.constant(64 : i64) : i64
    %9 = llvm.mlir.constant(288230377225453600 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(8 : i64) : i64
    %12 = cce.get.ctrl -> i64
    %13 = cce.sbitset0(%12, %1) : (i64, i64) -> i64
    cce.set.ctrl(%13) : i64
    %14 = cce.get.ctrl -> i64
    %15 = cce.sbitset1(%14, %0) : (i64, i64) -> i64
    cce.set.ctrl(%15) : i64
    %16 = cce.get_sub_block_idx -> i64
    %17 = llvm.icmp "eq" %16, %2 : i64
    llvm.cond_br %17, ^bb1, ^bb11
  ^bb1:  // pred: ^bb0
    %18 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %19 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %20 = llvm.inttoptr %19 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%18, %20, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%21: i64):  // 2 preds: ^bb1, ^bb9
    %22 = llvm.icmp "slt" %21, %5 : i64
    llvm.cond_br %22, ^bb3, ^bb10
  ^bb3:  // pred: ^bb2
    llvm.br ^bb4(%6 : i64)
  ^bb4(%23: i64):  // 2 preds: ^bb3, ^bb8
    %24 = llvm.icmp "slt" %23, %4 : i64
    llvm.cond_br %24, ^bb5, ^bb9
  ^bb5:  // pred: ^bb4
    llvm.br ^bb6(%6 : i64)
  ^bb6(%25: i64):  // 2 preds: ^bb5, ^bb7
    %26 = llvm.icmp "slt" %25, %3 : i64
    llvm.cond_br %26, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %27 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %28 = llvm.mul %23, %11 : i64
    %29 = llvm.add %28, %25 : i64
    %30 = llvm.getelementptr %27[%29] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, bf16
    %31 = llvm.load %30 : !llvm.ptr<6> -> bf16
    %32 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %33 = llvm.mul %23, %11 : i64
    %34 = llvm.add %33, %25 : i64
    %35 = llvm.getelementptr %32[%34] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, bf16
    llvm.store %31, %35 : bf16, !llvm.ptr<6>
    %36 = llvm.add %25, %7 : i64
    llvm.br ^bb6(%36 : i64)
  ^bb8:  // pred: ^bb6
    %37 = llvm.add %23, %7 : i64
    llvm.br ^bb4(%37 : i64)
  ^bb9:  // pred: ^bb4
    %38 = llvm.add %21, %7 : i64
    llvm.br ^bb2(%38 : i64)
  ^bb10:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %39 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    %41 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%40, %41, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb11
  ^bb11:  // 2 preds: ^bb0, ^bb10
    llvm.return
  }
}


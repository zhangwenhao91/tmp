module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub2ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(16 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %6 = llvm.mlir.constant(0 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %7 = llvm.mlir.constant(1 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %8 = llvm.mlir.constant(256 : i64) : i64
    %9 = llvm.mlir.constant(288230377225453696 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = cce.get.ctrl -> i64
    %12 = cce.sbitset0(%11, %3) : (i64, i64) -> i64
    cce.set.ctrl(%12) : i64
    %13 = cce.get.ctrl -> i64
    %14 = cce.sbitset1(%13, %2) : (i64, i64) -> i64
    cce.set.ctrl(%14) : i64
    %15 = cce.get_sub_block_idx -> i64
    %16 = llvm.icmp "eq" %15, %4 : i64
    llvm.cond_br %16, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    %17 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %18 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %19 = llvm.inttoptr %18 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%17, %19, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%20: i64):  // 2 preds: ^bb1, ^bb9
    %21 = llvm.icmp "slt" %20, %5 : i64
    llvm.cond_br %21, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %22 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %23 = llvm.inttoptr %22 : i64 to !llvm.ptr<1>
    %24 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%23, %24, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%25: i32):  // 2 preds: ^bb3, ^bb8
    %26 = llvm.icmp "sle" %25, %1 : i32
    llvm.cond_br %26, ^bb7, ^bb9
  ^bb7:  // pred: ^bb6
    %27 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %28 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %29 = cce.intr.vldsx1.bf16(%28, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %30 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.bf16(%29, %30, %1, %0, %1, %27) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %31 = llvm.add %25, %0 : i32
    llvm.br ^bb6(%31 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb6
    %32 = llvm.add %20, %7 : i64
    llvm.br ^bb2(%32 : i64)
  }
}


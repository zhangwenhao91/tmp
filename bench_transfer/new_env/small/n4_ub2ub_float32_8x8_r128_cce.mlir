module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub2ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(128 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %6 = llvm.mlir.constant(0 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %7 = llvm.mlir.constant(1 : index) {block_id = 2 : i32, core_type = "VECTOR"} : i64
    %8 = llvm.mlir.constant(256 : i64) : i64
    %9 = llvm.mlir.constant(288230377225453696 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
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
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%18, %20, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%21: i64):  // 2 preds: ^bb1, ^bb9
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
  ^bb6(%26: i32):  // 2 preds: ^bb3, ^bb8
    %27 = llvm.icmp "sle" %26, %1 : i32
    llvm.cond_br %27, ^bb7, ^bb9
  ^bb7:  // pred: ^bb6
    %28 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %29 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %30 = cce.intr.vldsx1.f32(%29, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %31 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%30, %31, %1, %11, %1, %28) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %32 = llvm.add %26, %0 : i32
    llvm.br ^bb6(%32 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb6
    %33 = llvm.add %21, %7 : i64
    llvm.br ^bb2(%33 : i64)
  }
}


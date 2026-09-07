module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_abs_max_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %6 = llvm.mlir.constant(16384 : i64) : i64
    %7 = llvm.mlir.constant(288230377225461760 : i64) : i64
    %8 = llvm.mlir.constant(35184372088864 : i64) : i64
    %9 = llvm.mlir.constant(32 : i32) : i32
    %10 = llvm.mlir.constant(2 : i32) : i32
    %11 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %12 = cce.get.ctrl -> i64
    %13 = cce.sbitset0(%12, %3) : (i64, i64) -> i64
    cce.set.ctrl(%13) : i64
    %14 = cce.get.ctrl -> i64
    %15 = cce.sbitset1(%14, %2) : (i64, i64) -> i64
    cce.set.ctrl(%15) : i64
    %16 = cce.get_sub_block_idx -> i64
    %17 = llvm.icmp "eq" %16, %4 : i64
    llvm.cond_br %17, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %18 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %19 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %20 = llvm.inttoptr %19 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%18, %20, %7, %8) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb6
    llvm.return
  ^bb3(%21: i32):  // 2 preds: ^bb1, ^bb5
    %22 = llvm.icmp "sle" %21, %1 : i32
    llvm.cond_br %22, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %23 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %24 = cce.vdups(%5, %23, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %dst, %restElem = cce.plt(%9) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %25 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%24, %25, %1, %10, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %26 = llvm.add %21, %0 : i32
    llvm.br ^bb3(%26 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %27 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %28 = llvm.inttoptr %27 : i64 to !llvm.ptr<1>
    %29 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%28, %29, %11, %8) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


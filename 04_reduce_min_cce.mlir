module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_min_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(-1.000000e+30 : f32) : f32
    %6 = llvm.mlir.constant(-1.000000e+00 : f32) : f32
    %7 = llvm.mlir.constant(16384 : i64) : i64
    %8 = llvm.mlir.constant(288230377225461760 : i64) : i64
    %9 = llvm.mlir.constant(35184372088864 : i64) : i64
    %10 = llvm.mlir.constant(32 : i32) : i32
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %13 = cce.get.ctrl -> i64
    %14 = cce.sbitset0(%13, %3) : (i64, i64) -> i64
    cce.set.ctrl(%14) : i64
    %15 = cce.get.ctrl -> i64
    %16 = cce.sbitset1(%15, %2) : (i64, i64) -> i64
    cce.set.ctrl(%16) : i64
    %17 = cce.get_sub_block_idx -> i64
    %18 = llvm.icmp "eq" %17, %4 : i64
    llvm.cond_br %18, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %19 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %20 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %21 = llvm.inttoptr %20 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%19, %21, %8, %9) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb6
    llvm.return
  ^bb3(%22: i32):  // 2 preds: ^bb1, ^bb5
    %23 = llvm.icmp "sle" %22, %1 : i32
    llvm.cond_br %23, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %24 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %25 = cce.vdups(%5, %24, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %dst, %restElem = cce.plt(%10) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %26 = cce.vmuls(%25, %6, %dst) : (vector<64xf32>, f32, vector<256xi1>) -> vector<64xf32>
    %27 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%26, %27, %1, %11, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %28 = llvm.add %22, %0 : i32
    llvm.br ^bb3(%28 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %29 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %30 = llvm.inttoptr %29 : i64 to !llvm.ptr<1>
    %31 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%30, %31, %12, %9) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


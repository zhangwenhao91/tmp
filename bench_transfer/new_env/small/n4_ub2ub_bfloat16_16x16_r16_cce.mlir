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
    %8 = llvm.mlir.constant(512 : i64) : i64
    %9 = llvm.mlir.constant(288230377225453824 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(2 : index) : i64
    %12 = llvm.mlir.constant(256 : i32) : i32
    %13 = cce.get.ctrl -> i64
    %14 = cce.sbitset0(%13, %3) : (i64, i64) -> i64
    cce.set.ctrl(%14) : i64
    %15 = cce.get.ctrl -> i64
    %16 = cce.sbitset1(%15, %2) : (i64, i64) -> i64
    cce.set.ctrl(%16) : i64
    %17 = cce.get_sub_block_idx -> i64
    %18 = llvm.icmp "eq" %17, %4 : i64
    llvm.cond_br %18, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    %19 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %20 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %21 = llvm.inttoptr %20 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%19, %21, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%22: i64):  // 2 preds: ^bb1, ^bb12
    %23 = llvm.icmp "slt" %22, %5 : i64
    llvm.cond_br %23, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %24 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %25 = llvm.inttoptr %24 : i64 to !llvm.ptr<1>
    %26 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%25, %26, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%27: i32):  // 2 preds: ^bb3, ^bb11
    %28 = llvm.icmp "sle" %27, %1 : i32
    llvm.cond_br %28, ^bb7, ^bb12
  ^bb7:  // pred: ^bb6
    %29 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%30: i64):  // 2 preds: ^bb7, ^bb9
    %31 = llvm.icmp "slt" %30, %11 : i64
    llvm.cond_br %31, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %32 = llvm.trunc %30 : i64 to i32
    %33 = llvm.mul %32, %12 : i32
    %34 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %35 = llvm.sext %33 : i32 to i64
    %36 = llvm.getelementptr %34[%35] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %37 = cce.intr.vldsx1.bf16(%36, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %38 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %39 = llvm.sext %33 : i32 to i64
    %40 = llvm.getelementptr %38[%39] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%37, %40, %1, %0, %1, %29) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %41 = llvm.add %30, %7 : i64
    llvm.br ^bb8(%41 : i64)
  ^bb10:  // pred: ^bb8
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %42 = llvm.add %27, %0 : i32
    llvm.br ^bb6(%42 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb6
    %43 = llvm.add %22, %7 : i64
    llvm.br ^bb2(%43 : i64)
  }
}


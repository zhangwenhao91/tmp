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
    %8 = llvm.mlir.constant(64 : i64) : i64
    %9 = llvm.mlir.constant(288230377225453600 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(3 : i32) : i32
    %13 = llvm.mlir.constant(5 : i32) : i32
    %14 = llvm.mlir.constant(4 : i32) : i32
    %15 = cce.get.ctrl -> i64
    %16 = cce.sbitset0(%15, %3) : (i64, i64) -> i64
    cce.set.ctrl(%16) : i64
    %17 = cce.get.ctrl -> i64
    %18 = cce.sbitset1(%17, %2) : (i64, i64) -> i64
    cce.set.ctrl(%18) : i64
    %19 = cce.get_sub_block_idx -> i64
    %20 = llvm.icmp "eq" %19, %4 : i64
    llvm.cond_br %20, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    %21 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %22 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %23 = llvm.inttoptr %22 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%21, %23, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%24: i64):  // 2 preds: ^bb1, ^bb12
    %25 = llvm.icmp "slt" %24, %5 : i64
    llvm.cond_br %25, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %26 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %27 = llvm.inttoptr %26 : i64 to !llvm.ptr<1>
    %28 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%27, %28, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%29: i32):  // 2 preds: ^bb3, ^bb11
    %30 = llvm.icmp "sle" %29, %1 : i32
    llvm.cond_br %30, ^bb7, ^bb12
  ^bb7:  // pred: ^bb6
    %31 = cce.pset(%11) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%32: i64):  // 2 preds: ^bb7, ^bb9
    %33 = llvm.icmp "slt" %32, %5 : i64
    llvm.cond_br %33, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %34 = llvm.trunc %32 : i64 to i32
    %35 = llvm.mul %34, %14 : i32
    %36 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %37 = llvm.sext %35 : i32 to i64
    %38 = llvm.getelementptr %36[%37] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %39 = cce.intr.vldsx1.f32(%38, %1, %12, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %40 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %41 = llvm.sext %35 : i32 to i64
    %42 = llvm.getelementptr %40[%41] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%39, %42, %1, %13, %1, %31) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %43 = llvm.add %32, %7 : i64
    llvm.br ^bb8(%43 : i64)
  ^bb10:  // pred: ^bb8
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %44 = llvm.add %29, %0 : i32
    llvm.br ^bb6(%44 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb6
    %45 = llvm.add %24, %7 : i64
    llvm.br ^bb2(%45 : i64)
  }
}


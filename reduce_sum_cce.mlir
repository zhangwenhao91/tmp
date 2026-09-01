module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_sum_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(32 : index) : i64
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(128 : index) : i64
    %9 = llvm.mlir.constant(16384 : i64) : i64
    %10 = llvm.mlir.constant(288230377225461760 : i64) : i64
    %11 = llvm.mlir.constant(35184372088864 : i64) : i64
    %12 = llvm.mlir.constant(2 : i32) : i32
    %13 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %14 = llvm.mlir.constant(4 : i64) : i64
    %15 = cce.get.ctrl -> i64
    %16 = cce.sbitset0(%15, %3) : (i64, i64) -> i64
    cce.set.ctrl(%16) : i64
    %17 = cce.get.ctrl -> i64
    %18 = cce.sbitset1(%17, %2) : (i64, i64) -> i64
    cce.set.ctrl(%18) : i64
    %19 = cce.get_sub_block_idx -> i64
    %20 = llvm.icmp "eq" %19, %4 : i64
    llvm.cond_br %20, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %21 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %22 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %23 = llvm.inttoptr %22 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%21, %23, %10, %11) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = PIPE_MTE2 tpipe = PIPE_V pipeID = EVENT_ID0
    cce.wait_flag pipe = PIPE_MTE2 tpipe = PIPE_V pipeID = EVENT_ID0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%24: i32):  // 2 preds: ^bb1, ^bb8
    %25 = llvm.icmp "sle" %24, %1 : i32
    llvm.cond_br %25, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%6 : i64)
  ^bb5(%26: i64):  // 2 preds: ^bb4, ^bb6
    %27 = llvm.icmp "slt" %26, %5 : i64
    llvm.cond_br %27, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %28 = llvm.mul %26, %8 : i64
    %29 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %30 = llvm.mul %28, %14 : i64
    %31 = llvm.getelementptr %29[%30] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %32 = cce.intr.vldsx1.f32(%31, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %33 = cce.pset(%12) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %34 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %35 = llvm.mul %26, %14 : i64
    %36 = llvm.getelementptr %34[%35] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%32, %36, %1, %12, %1, %33) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %37 = llvm.add %26, %7 : i64
    llvm.br ^bb5(%37 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %38 = llvm.add %24, %0 : i32
    llvm.br ^bb3(%38 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = PIPE_V tpipe = PIPE_MTE3 pipeID = EVENT_ID0
    cce.wait_flag pipe = PIPE_V tpipe = PIPE_MTE3 pipeID = EVENT_ID0
    %39 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    %41 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%40, %41, %13, %11) : (<1>, <6>, i64, i64)
    cce.barrier pipe = PIPE_ALL
    llvm.br ^bb2
  }
}

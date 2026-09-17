module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @ub2ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(16 : index) : i64
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(16384 : i64) : i64
    %9 = llvm.mlir.constant(288230377225461760 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(3 : i32) : i32
    %13 = llvm.mlir.constant(5 : i32) : i32
    %14 = llvm.mlir.constant(4096 : index) : i64
    %15 = llvm.mlir.constant(4 : i32) : i32
    %16 = cce.get.ctrl -> i64
    %17 = cce.sbitset0(%16, %3) : (i64, i64) -> i64
    cce.set.ctrl(%17) : i64
    %18 = cce.get.ctrl -> i64
    %19 = cce.sbitset1(%18, %2) : (i64, i64) -> i64
    cce.set.ctrl(%19) : i64
    %20 = cce.get_sub_block_idx -> i64
    %21 = llvm.icmp "eq" %20, %4 : i64
    llvm.cond_br %21, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    %22 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %23 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %24 = llvm.inttoptr %23 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%22, %24, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%25: i64):  // 2 preds: ^bb1, ^bb12
    %26 = llvm.icmp "slt" %25, %5 : i64
    llvm.cond_br %26, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %27 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %28 = llvm.inttoptr %27 : i64 to !llvm.ptr<1>
    %29 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%28, %29, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%30: i32):  // 2 preds: ^bb3, ^bb11
    %31 = llvm.icmp "sle" %30, %1 : i32
    llvm.cond_br %31, ^bb7, ^bb12
  ^bb7:  // pred: ^bb6
    %32 = cce.pset(%11) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%33: i64):  // 2 preds: ^bb7, ^bb9
    %34 = llvm.icmp "slt" %33, %14 : i64
    llvm.cond_br %34, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %35 = llvm.trunc %33 : i64 to i32
    %36 = llvm.mul %35, %15 : i32
    %37 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %38 = llvm.sext %36 : i32 to i64
    %39 = llvm.getelementptr %37[%38] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %40 = cce.intr.vldsx1.f32(%39, %1, %12, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %41 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %42 = llvm.sext %36 : i32 to i64
    %43 = llvm.getelementptr %41[%42] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%40, %43, %1, %13, %1, %32) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %44 = llvm.add %33, %7 : i64
    llvm.br ^bb8(%44 : i64)
  ^bb10:  // pred: ^bb8
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %45 = llvm.add %30, %0 : i32
    llvm.br ^bb6(%45 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb6
    %46 = llvm.add %25, %7 : i64
    llvm.br ^bb2(%46 : i64)
  }
}


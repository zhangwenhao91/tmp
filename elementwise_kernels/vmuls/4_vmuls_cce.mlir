module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @vmuls_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(16384 : i64) : i64
    %6 = llvm.mlir.constant(8192 : i64) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(16 : i32) : i32
    %9 = llvm.mlir.constant(128 : index) : i64
    %10 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %11 = llvm.mlir.constant(35184372088864 : i64) : i64
    %12 = llvm.mlir.constant(288230376285929488 : i64) : i64
    %13 = llvm.mlir.constant(4398046511108 : i64) : i64
    %14 = llvm.mlir.constant(1 : index) : i64
    %15 = llvm.mlir.constant(4 : i32) : i32
    %16 = llvm.mlir.constant(32 : index) : i64
    %17 = llvm.mlir.constant(64 : index) : i64
    %18 = llvm.mlir.constant(2 : i32) : i32
    %19 = llvm.mlir.constant(4 : i64) : i64
    %20 = cce.get.ctrl -> i64
    %21 = cce.sbitset0(%20, %3) : (i64, i64) -> i64
    cce.set.ctrl(%21) : i64
    %22 = cce.get.ctrl -> i64
    %23 = cce.sbitset1(%22, %2) : (i64, i64) -> i64
    cce.set.ctrl(%23) : i64
    %24 = cce.get_sub_block_idx -> i64
    %25 = llvm.icmp "eq" %24, %4 : i64
    llvm.cond_br %25, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %26 = cce.get_block_idx -> i64
    %27 = llvm.trunc %26 : i64 to i32
    %28 = llvm.mul %27, %8 : i32
    %29 = llvm.sext %28 : i32 to i64
    %30 = llvm.mul %29, %9 : i64
    %31 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %32 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %33 = llvm.mul %30, %19 : i64
    %34 = llvm.add %32, %33 : i64
    %35 = llvm.inttoptr %34 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%31, %35, %10, %11) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    %36 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %37 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %38 = llvm.inttoptr %37 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%36, %38, %12, %13) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%39: i32):  // 2 preds: ^bb1, ^bb8
    %40 = llvm.icmp "sle" %39, %1 : i32
    llvm.cond_br %40, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %41 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %42 = llvm.load %41 : !llvm.ptr<6> -> f32
    %43 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%7 : i64)
  ^bb5(%44: i64):  // 2 preds: ^bb4, ^bb6
    %45 = llvm.icmp "slt" %44, %16 : i64
    llvm.cond_br %45, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %46 = llvm.mul %44, %17 : i64
    %47 = llvm.trunc %46 : i64 to i32
    %48 = llvm.mul %47, %15 : i32
    %49 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %50 = cce.intr.vldsx1.f32(%49, %48, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %51 = cce.vdups(%42, %43, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %52 = cce.vmul(%50, %51, %43) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %53 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%52, %53, %48, %18, %1, %43) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %54 = llvm.add %44, %14 : i64
    llvm.br ^bb5(%54 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %55 = llvm.add %39, %0 : i32
    llvm.br ^bb3(%55 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %56 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %57 = llvm.mul %30, %19 : i64
    %58 = llvm.add %56, %57 : i64
    %59 = llvm.inttoptr %58 : i64 to !llvm.ptr<1>
    %60 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%59, %60, %10, %11) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


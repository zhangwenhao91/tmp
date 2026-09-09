module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @vexp_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(16 : i32) : i32
    %7 = llvm.mlir.constant(128 : index) : i64
    %8 = llvm.mlir.constant(8192 : i64) : i64
    %9 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(4 : i32) : i32
    %13 = llvm.mlir.constant(32 : index) : i64
    %14 = llvm.mlir.constant(64 : index) : i64
    %15 = llvm.mlir.constant(2 : i32) : i32
    %16 = llvm.mlir.constant(4 : i64) : i64
    %17 = cce.get.ctrl -> i64
    %18 = cce.sbitset0(%17, %3) : (i64, i64) -> i64
    cce.set.ctrl(%18) : i64
    %19 = cce.get.ctrl -> i64
    %20 = cce.sbitset1(%19, %2) : (i64, i64) -> i64
    cce.set.ctrl(%20) : i64
    %21 = cce.get_sub_block_idx -> i64
    %22 = llvm.icmp "eq" %21, %4 : i64
    llvm.cond_br %22, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %23 = cce.get_block_idx -> i64
    %24 = llvm.trunc %23 : i64 to i32
    %25 = llvm.mul %24, %6 : i32
    %26 = llvm.sext %25 : i32 to i64
    %27 = llvm.mul %26, %7 : i64
    %28 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %29 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %30 = llvm.mul %27, %16 : i64
    %31 = llvm.add %29, %30 : i64
    %32 = llvm.inttoptr %31 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%28, %32, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%33: i32):  // 2 preds: ^bb1, ^bb8
    %34 = llvm.icmp "sle" %33, %1 : i32
    llvm.cond_br %34, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %35 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%5 : i64)
  ^bb5(%36: i64):  // 2 preds: ^bb4, ^bb6
    %37 = llvm.icmp "slt" %36, %13 : i64
    llvm.cond_br %37, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %38 = llvm.mul %36, %14 : i64
    %39 = llvm.trunc %38 : i64 to i32
    %40 = llvm.mul %39, %12 : i32
    %41 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %42 = cce.intr.vldsx1.f32(%41, %40, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %43 = cce.vexp(%42, %35) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %44 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%43, %44, %40, %15, %1, %35) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %45 = llvm.add %36, %11 : i64
    llvm.br ^bb5(%45 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %46 = llvm.add %33, %0 : i32
    llvm.br ^bb3(%46 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %47 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %48 = llvm.mul %27, %16 : i64
    %49 = llvm.add %47, %48 : i64
    %50 = llvm.inttoptr %49 : i64 to !llvm.ptr<1>
    %51 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%50, %51, %9, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_max_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(16384 : i64) : i64
    %7 = llvm.mlir.constant(288230377225461760 : i64) : i64
    %8 = llvm.mlir.constant(35184372088864 : i64) : i64
    %9 = llvm.mlir.constant(2 : i32) : i32
    %10 = llvm.mlir.constant(5 : i32) : i32
    %11 = llvm.mlir.constant(4 : i32) : i32
    %12 = llvm.mlir.constant(32 : index) : i64
    %13 = llvm.mlir.constant(1 : index) : i64
    %14 = llvm.mlir.constant(128 : i32) : i32
    %15 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %16 = llvm.mlir.constant(512 : i32) : i32
    %17 = llvm.mlir.constant(64 : i32) : i32
    %18 = cce.get.ctrl -> i64
    %19 = cce.sbitset0(%18, %3) : (i64, i64) -> i64
    cce.set.ctrl(%19) : i64
    %20 = cce.get.ctrl -> i64
    %21 = cce.sbitset1(%20, %2) : (i64, i64) -> i64
    cce.set.ctrl(%21) : i64
    %22 = cce.get_sub_block_idx -> i64
    %23 = llvm.icmp "eq" %22, %4 : i64
    llvm.cond_br %23, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %24 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %25 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %26 = llvm.inttoptr %25 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%24, %26, %7, %8) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%27: i32):  // 2 preds: ^bb1, ^bb8
    %28 = llvm.icmp "sle" %27, %1 : i32
    llvm.cond_br %28, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %29 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %30 = cce.pset(%9) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%5 : i64)
  ^bb5(%31: i64):  // 2 preds: ^bb4, ^bb6
    %32 = llvm.icmp "slt" %31, %12 : i64
    llvm.cond_br %32, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %33 = llvm.trunc %31 : i64 to i32
    %34 = llvm.mul %33, %14 : i32
    %35 = llvm.mul %33, %16 : i32
    %36 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %37 = cce.intr.vldsx1.f32(%36, %35, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %38 = llvm.add %34, %17 : i32
    %39 = llvm.mul %38, %11 : i32
    %40 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %41 = cce.intr.vldsx1.f32(%40, %39, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %42 = cce.vmax(%37, %41, %29) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %43 = cce.vcmax(%42, %29) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %44 = llvm.mul %33, %11 : i32
    %45 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%43, %45, %44, %10, %1, %30) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %46 = llvm.add %31, %13 : i64
    llvm.br ^bb5(%46 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %47 = llvm.add %27, %0 : i32
    llvm.br ^bb3(%47 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %48 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %49 = llvm.inttoptr %48 : i64 to !llvm.ptr<1>
    %50 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%49, %50, %15, %8) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


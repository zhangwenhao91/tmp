module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @vmax_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(16 : i32) : i32
    %7 = llvm.mlir.constant(128 : index) : i64
    %8 = llvm.mlir.constant(8192 : i64) : i64
    %9 = llvm.mlir.constant(16384 : i64) : i64
    %10 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %11 = llvm.mlir.constant(35184372088864 : i64) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(4 : i32) : i32
    %14 = llvm.mlir.constant(32 : index) : i64
    %15 = llvm.mlir.constant(64 : index) : i64
    %16 = llvm.mlir.constant(2 : i32) : i32
    %17 = llvm.mlir.constant(4 : i64) : i64
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
    %24 = cce.get_block_idx -> i64
    %25 = llvm.trunc %24 : i64 to i32
    %26 = llvm.mul %25, %6 : i32
    %27 = llvm.sext %26 : i32 to i64
    %28 = llvm.mul %27, %7 : i64
    %29 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %30 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %31 = llvm.mul %28, %17 : i64
    %32 = llvm.add %30, %31 : i64
    %33 = llvm.inttoptr %32 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%29, %33, %10, %11) : (<6>, <1>, i64, i64)
    %34 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %35 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %36 = llvm.mul %28, %17 : i64
    %37 = llvm.add %35, %36 : i64
    %38 = llvm.inttoptr %37 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%34, %38, %10, %11) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%39: i32):  // 2 preds: ^bb1, ^bb8
    %40 = llvm.icmp "sle" %39, %1 : i32
    llvm.cond_br %40, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %41 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%5 : i64)
  ^bb5(%42: i64):  // 2 preds: ^bb4, ^bb6
    %43 = llvm.icmp "slt" %42, %14 : i64
    llvm.cond_br %43, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %44 = llvm.mul %42, %15 : i64
    %45 = llvm.trunc %44 : i64 to i32
    %46 = llvm.mul %45, %13 : i32
    %47 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %48 = cce.intr.vldsx1.f32(%47, %46, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %49 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %50 = cce.intr.vldsx1.f32(%49, %46, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %51 = cce.vmax(%48, %50, %41) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %52 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%51, %52, %46, %16, %1, %41) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %53 = llvm.add %42, %12 : i64
    llvm.br ^bb5(%53 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %54 = llvm.add %39, %0 : i32
    llvm.br ^bb3(%54 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %55 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %56 = llvm.mul %28, %17 : i64
    %57 = llvm.add %55, %56 : i64
    %58 = llvm.inttoptr %57 : i64 to !llvm.ptr<1>
    %59 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%58, %59, %10, %11) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @vadd_kernel(%arg0: !llvm.ptr<1> {hacc.arg_type = #hacc.arg_type<sync_block_lock>}, %arg1: !llvm.ptr<1> {hacc.arg_type = #hacc.arg_type<workspace>}, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>) attributes {SyncBlockLockArgIdx = 0 : i64, WorkspaceArgIdx = 1 : i64, cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, global_kernel = "local", hivm.part_of_mix, mix_mode = "mix", parallel_mode = "simd"} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(128 : index) : i64
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(64 : index) : i64
    %9 = llvm.mlir.constant(32 : i32) : i32
    %10 = llvm.mlir.constant(32768 : i64) : i64
    %11 = llvm.mlir.constant(65536 : i64) : i64
    %12 = llvm.mlir.constant(288230377225469952 : i64) : i64
    %13 = llvm.mlir.constant(35184372088864 : i64) : i64
    %14 = llvm.mlir.constant(2 : i32) : i32
    %15 = llvm.mlir.constant(4 : i64) : i64
    %16 = cce.get.ctrl -> i64
    %17 = cce.sbitset0(%16, %3) : (i64, i64) -> i64
    cce.set.ctrl(%17) : i64
    %18 = cce.get.ctrl -> i64
    %19 = cce.sbitset1(%18, %2) : (i64, i64) -> i64
    cce.set.ctrl(%19) : i64
    %20 = cce.get_sub_block_idx -> i64
    %21 = llvm.icmp "eq" %20, %4 : i64
    llvm.cond_br %21, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %22 = cce.get_block_idx -> i64
    %23 = llvm.trunc %22 : i64 to i32
    %24 = llvm.mul %23, %9 : i32
    %25 = llvm.sext %24 : i32 to i64
    %26 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %27 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %28 = llvm.mul %25, %15 : i64
    %29 = llvm.add %27, %28 : i64
    %30 = llvm.inttoptr %29 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%26, %30, %12, %13) : (<6>, <1>, i64, i64)
    %31 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %32 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %33 = llvm.mul %25, %15 : i64
    %34 = llvm.add %32, %33 : i64
    %35 = llvm.inttoptr %34 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%31, %35, %12, %13) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%36: i32):  // 2 preds: ^bb1, ^bb8
    %37 = llvm.icmp "sle" %36, %1 : i32
    llvm.cond_br %37, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%7 : i64)
  ^bb5(%38: i64):  // 2 preds: ^bb4, ^bb6
    %39 = llvm.icmp "slt" %38, %5 : i64
    llvm.cond_br %39, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %40 = llvm.mul %38, %8 : i64
    %41 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %42 = llvm.mul %40, %15 : i64
    %43 = llvm.getelementptr %41[%42] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %44 = cce.intr.vldsx1.f32(%43, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %45 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %46 = llvm.mul %40, %15 : i64
    %47 = llvm.getelementptr %45[%46] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %48 = cce.intr.vldsx1.f32(%47, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %49 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %50 = cce.vadd(%44, %48, %49) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %51 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %52 = llvm.mul %40, %15 : i64
    %53 = llvm.getelementptr %51[%52] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%50, %53, %1, %14, %1, %49) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %54 = llvm.add %38, %6 : i64
    llvm.br ^bb5(%54 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %55 = llvm.add %36, %0 : i32
    llvm.br ^bb3(%55 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %56 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %57 = llvm.mul %25, %15 : i64
    %58 = llvm.add %56, %57 : i64
    %59 = llvm.inttoptr %58 : i64 to !llvm.ptr<1>
    %60 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%59, %60, %12, %13) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


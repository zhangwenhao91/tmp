module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_max_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {SyncBlockLockArgIdx = 0 : i64, WorkspaceArgIdx = 1 : i64, cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, global_kernel = "local", hivm.part_of_mix, mix_mode = "mix", parallel_mode = "simd"} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(128 : index) : i64
    %6 = llvm.mlir.constant(16 : i32) : i32
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(8192 : i64) : i64
    %9 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %10 = llvm.mlir.constant(35184372088864 : i64) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(5 : i32) : i32
    %13 = llvm.mlir.constant(4 : i32) : i32
    %14 = llvm.mlir.constant(16 : index) : i64
    %15 = llvm.mlir.constant(1 : index) : i64
    %16 = llvm.mlir.constant(128 : i32) : i32
    %17 = llvm.mlir.constant(288230377225453600 : i64) : i64
    %18 = llvm.mlir.constant(512 : i32) : i32
    %19 = llvm.mlir.constant(64 : i32) : i32
    %20 = llvm.mlir.constant(4 : i64) : i64
    %21 = cce.get.ctrl -> i64
    %22 = cce.sbitset0(%21, %3) : (i64, i64) -> i64
    cce.set.ctrl(%22) : i64
    %23 = cce.get.ctrl -> i64
    %24 = cce.sbitset1(%23, %2) : (i64, i64) -> i64
    cce.set.ctrl(%24) : i64
    %25 = cce.get_sub_block_idx -> i64
    %26 = llvm.icmp "eq" %25, %4 : i64
    llvm.cond_br %26, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %27 = llvm.mul %arg2, %6 : i32
    %28 = llvm.sext %27 : i32 to i64
    %29 = llvm.mul %28, %5 : i64
    %30 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %31 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %32 = llvm.mul %29, %20 : i64
    %33 = llvm.add %31, %32 : i64
    %34 = llvm.inttoptr %33 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%30, %34, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%35: i32):  // 2 preds: ^bb1, ^bb8
    %36 = llvm.icmp "sle" %35, %1 : i32
    llvm.cond_br %36, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %37 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %38 = cce.pset(%11) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%7 : i64)
  ^bb5(%39: i64):  // 2 preds: ^bb4, ^bb6
    %40 = llvm.icmp "slt" %39, %14 : i64
    llvm.cond_br %40, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %41 = llvm.trunc %39 : i64 to i32
    %42 = llvm.mul %41, %16 : i32
    %43 = llvm.mul %41, %18 : i32
    %44 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %45 = cce.intr.vldsx1.f32(%44, %43, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %46 = llvm.add %42, %19 : i32
    %47 = llvm.mul %46, %13 : i32
    %48 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %49 = cce.intr.vldsx1.f32(%48, %47, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %50 = cce.vmax(%45, %49, %37) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %51 = cce.vcmax(%50, %37) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %52 = llvm.mul %41, %13 : i32
    %53 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%51, %53, %52, %12, %1, %38) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %54 = llvm.add %39, %15 : i64
    llvm.br ^bb5(%54 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %55 = llvm.add %35, %0 : i32
    llvm.br ^bb3(%55 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %56 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %57 = llvm.mul %28, %20 : i64
    %58 = llvm.add %56, %57 : i64
    %59 = llvm.inttoptr %58 : i64 to !llvm.ptr<1>
    %60 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%59, %60, %17, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


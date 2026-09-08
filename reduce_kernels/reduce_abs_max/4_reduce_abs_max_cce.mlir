module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_abs_max_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(16 : i32) : i32
    %7 = llvm.mlir.constant(128 : index) : i64
    %8 = llvm.mlir.constant(-1.000000e+00 : f32) : f32
    %9 = llvm.mlir.constant(8192 : i64) : i64
    %10 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %11 = llvm.mlir.constant(35184372088864 : i64) : i64
    %12 = llvm.mlir.constant(2 : i32) : i32
    %13 = llvm.mlir.constant(5 : i32) : i32
    %14 = llvm.mlir.constant(4 : i32) : i32
    %15 = llvm.mlir.constant(16 : index) : i64
    %16 = llvm.mlir.constant(1 : index) : i64
    %17 = llvm.mlir.constant(128 : i32) : i32
    %18 = llvm.mlir.constant(288230377225453600 : i64) : i64
    %19 = llvm.mlir.constant(512 : i32) : i32
    %20 = llvm.mlir.constant(64 : i32) : i32
    %21 = llvm.mlir.constant(4 : i64) : i64
    %22 = cce.get.ctrl -> i64
    %23 = cce.sbitset0(%22, %3) : (i64, i64) -> i64
    cce.set.ctrl(%23) : i64
    %24 = cce.get.ctrl -> i64
    %25 = cce.sbitset1(%24, %2) : (i64, i64) -> i64
    cce.set.ctrl(%25) : i64
    %26 = cce.get_sub_block_idx -> i64
    %27 = llvm.icmp "eq" %26, %4 : i64
    llvm.cond_br %27, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %28 = cce.get_block_idx -> i64
    %29 = llvm.trunc %28 : i64 to i32
    %30 = llvm.mul %29, %6 : i32
    %31 = llvm.sext %30 : i32 to i64
    %32 = llvm.mul %31, %7 : i64
    %33 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %34 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %35 = llvm.mul %32, %21 : i64
    %36 = llvm.add %34, %35 : i64
    %37 = llvm.inttoptr %36 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%33, %37, %10, %11) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%38: i32):  // 2 preds: ^bb1, ^bb8
    %39 = llvm.icmp "sle" %38, %1 : i32
    llvm.cond_br %39, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %40 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %41 = cce.pset(%12) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%5 : i64)
  ^bb5(%42: i64):  // 2 preds: ^bb4, ^bb6
    %43 = llvm.icmp "slt" %42, %15 : i64
    llvm.cond_br %43, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %44 = llvm.trunc %42 : i64 to i32
    %45 = llvm.mul %44, %17 : i32
    %46 = llvm.mul %44, %19 : i32
    %47 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %48 = cce.intr.vldsx1.f32(%47, %46, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %49 = cce.vmuls(%48, %8, %40) : (vector<64xf32>, f32, vector<256xi1>) -> vector<64xf32>
    %50 = cce.vmax(%48, %49, %40) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %51 = llvm.add %45, %20 : i32
    %52 = llvm.mul %51, %14 : i32
    %53 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %54 = cce.intr.vldsx1.f32(%53, %52, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %55 = cce.vmuls(%54, %8, %40) : (vector<64xf32>, f32, vector<256xi1>) -> vector<64xf32>
    %56 = cce.vmax(%54, %55, %40) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %57 = cce.vmax(%50, %56, %40) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %58 = cce.vcmax(%57, %40) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %59 = llvm.mul %44, %14 : i32
    %60 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%58, %60, %59, %13, %1, %41) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %61 = llvm.add %42, %16 : i64
    llvm.br ^bb5(%61 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %62 = llvm.add %38, %0 : i32
    llvm.br ^bb3(%62 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %63 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %64 = llvm.mul %31, %21 : i64
    %65 = llvm.add %63, %64 : i64
    %66 = llvm.inttoptr %65 : i64 to !llvm.ptr<1>
    %67 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%66, %67, %18, %11) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


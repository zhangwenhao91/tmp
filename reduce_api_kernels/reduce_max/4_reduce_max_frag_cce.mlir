module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_max_frag_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
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
    %27 = cce.get_block_idx -> i64
    %28 = llvm.trunc %27 : i64 to i32
    %29 = llvm.mul %28, %6 : i32
    %30 = llvm.sext %29 : i32 to i64
    %31 = llvm.mul %30, %7 : i64
    %32 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %33 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %34 = llvm.mul %31, %20 : i64
    %35 = llvm.add %33, %34 : i64
    %36 = llvm.inttoptr %35 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%32, %36, %9, %10) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb9
    llvm.return
  ^bb3(%37: i32):  // 2 preds: ^bb1, ^bb8
    %38 = llvm.icmp "sle" %37, %1 : i32
    llvm.cond_br %38, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %39 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %40 = cce.pset(%11) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%5 : i64)
  ^bb5(%41: i64):  // 2 preds: ^bb4, ^bb6
    %42 = llvm.icmp "slt" %41, %14 : i64
    llvm.cond_br %42, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %43 = llvm.trunc %41 : i64 to i32
    %44 = llvm.mul %43, %16 : i32
    %45 = llvm.mul %43, %18 : i32
    %46 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %47 = llvm.sext %45 : i32 to i64
    %48 = llvm.getelementptr %46[%47] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %49 = cce.intr.vldsx1.f32(%48, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %50 = llvm.add %44, %19 : i32
    %51 = llvm.mul %50, %13 : i32
    %52 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %53 = llvm.sext %51 : i32 to i64
    %54 = llvm.getelementptr %52[%53] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %55 = cce.intr.vldsx1.f32(%54, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %56 = cce.vmax(%49, %55, %39) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %57 = cce.vcmax(%56, %39) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %58 = llvm.mul %43, %13 : i32
    %59 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %60 = llvm.sext %58 : i32 to i64
    %61 = llvm.getelementptr %59[%60] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%57, %61, %1, %12, %1, %40) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %62 = llvm.add %41, %15 : i64
    llvm.br ^bb5(%62 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %63 = llvm.add %37, %0 : i32
    llvm.br ^bb3(%63 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %64 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %65 = llvm.mul %30, %20 : i64
    %66 = llvm.add %64, %65 : i64
    %67 = llvm.inttoptr %66 : i64 to !llvm.ptr<1>
    %68 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%67, %68, %17, %10) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


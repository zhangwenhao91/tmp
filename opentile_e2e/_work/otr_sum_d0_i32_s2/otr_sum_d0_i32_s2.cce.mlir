module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d0_i32_s2(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.mlir.constant(4 : i32) : i32
    %8 = llvm.mlir.constant(64 : index) : i64
    %9 = llvm.mlir.constant(2 : i32) : i32
    %10 = llvm.mlir.constant(16384 : i64) : i64
    %11 = llvm.mlir.constant(32 : i32) : i32
    %12 = llvm.mlir.constant(128 : index) : i64
    %13 = llvm.mlir.constant(288230378836067904 : i64) : i64
    %14 = llvm.mlir.constant(140737488355408 : i64) : i64
    %15 = llvm.mlir.constant(288230378836066320 : i64) : i64
    %16 = llvm.mlir.constant(87960930222160 : i64) : i64
    %17 = llvm.mlir.constant(128 : i32) : i32
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
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb16
    llvm.return
  ^bb3(%24: i32):  // 2 preds: ^bb1, ^bb8
    %25 = llvm.icmp "sle" %24, %1 : i32
    llvm.cond_br %25, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %26 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%5 : i64)
  ^bb5(%27: i64):  // 2 preds: ^bb4, ^bb6
    %28 = llvm.icmp "slt" %27, %8 : i64
    llvm.cond_br %28, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %29 = llvm.mul %27, %8 : i64
    %30 = cce.vdups(%1, %26, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %31 = llvm.trunc %29 : i64 to i32
    %32 = llvm.mul %31, %7 : i32
    %33 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %34 = llvm.sext %32 : i32 to i64
    %35 = llvm.getelementptr %33[%34] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%30, %35, %1, %9, %1, %26) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %36 = llvm.add %27, %6 : i64
    llvm.br ^bb5(%36 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %37 = llvm.add %24, %0 : i32
    llvm.br ^bb3(%37 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %38 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %39 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%38, %40, %13, %14) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%41: i32):  // 2 preds: ^bb9, ^bb15
    %42 = llvm.icmp "sle" %41, %1 : i32
    llvm.cond_br %42, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %dst, %restElem = cce.plt(%11) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %43 = cce.vdups(%1, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    llvm.br ^bb12(%5, %43 : i64, vector<64xi32>)
  ^bb12(%44: i64, %45: vector<64xi32>):  // 2 preds: ^bb11, ^bb13
    %46 = llvm.icmp "slt" %44, %12 : i64
    llvm.cond_br %46, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %47 = llvm.trunc %44 : i64 to i32
    %48 = llvm.mul %47, %17 : i32
    %49 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %50 = llvm.sext %48 : i32 to i64
    %51 = llvm.getelementptr %49[%50] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %52 = cce.intr.vldsx1.i32(%51, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %53 = cce.vadd(%45, %52, %dst) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %54 = llvm.add %44, %6 : i64
    llvm.br ^bb12(%54, %53 : i64, vector<64xi32>)
  ^bb14:  // pred: ^bb12
    %55 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%45, %55, %1, %9, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %56 = llvm.add %41, %0 : i32
    llvm.br ^bb10(%56 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %57 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %58 = llvm.inttoptr %57 : i64 to !llvm.ptr<1>
    %59 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%58, %59, %15, %16) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


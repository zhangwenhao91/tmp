module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d1_f32_s2(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(4 : i32) : i32
    %9 = llvm.mlir.constant(64 : index) : i64
    %10 = llvm.mlir.constant(2 : i32) : i32
    %11 = llvm.mlir.constant(16384 : i64) : i64
    %12 = llvm.mlir.constant(32 : i32) : i32
    %13 = llvm.mlir.constant(5 : i32) : i32
    %14 = llvm.mlir.constant(128 : index) : i64
    %15 = llvm.mlir.constant(288230378836067904 : i64) : i64
    %16 = llvm.mlir.constant(140737488355408 : i64) : i64
    %17 = llvm.mlir.constant(288230389573484560 : i64) : i64
    %18 = llvm.mlir.constant(439804651110800 : i64) : i64
    %19 = llvm.mlir.constant(128 : i32) : i32
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
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb16
    llvm.return
  ^bb3(%26: i32):  // 2 preds: ^bb1, ^bb8
    %27 = llvm.icmp "sle" %26, %1 : i32
    llvm.cond_br %27, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %28 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%6 : i64)
  ^bb5(%29: i64):  // 2 preds: ^bb4, ^bb6
    %30 = llvm.icmp "slt" %29, %9 : i64
    llvm.cond_br %30, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %31 = llvm.mul %29, %9 : i64
    %32 = cce.vdups(%5, %28, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %33 = llvm.trunc %31 : i64 to i32
    %34 = llvm.mul %33, %8 : i32
    %35 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %36 = llvm.sext %34 : i32 to i64
    %37 = llvm.getelementptr %35[%36] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%32, %37, %1, %10, %1, %28) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %38 = llvm.add %29, %7 : i64
    llvm.br ^bb5(%38 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %39 = llvm.add %26, %0 : i32
    llvm.br ^bb3(%39 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %40 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %41 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %42 = llvm.inttoptr %41 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%40, %42, %15, %16) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%43: i32):  // 2 preds: ^bb9, ^bb15
    %44 = llvm.icmp "sle" %43, %1 : i32
    llvm.cond_br %44, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %dst, %restElem = cce.plt(%12) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %45 = cce.pset(%10) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb12(%6 : i64)
  ^bb12(%46: i64):  // 2 preds: ^bb11, ^bb13
    %47 = llvm.icmp "slt" %46, %14 : i64
    llvm.cond_br %47, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %48 = llvm.trunc %46 : i64 to i32
    %49 = llvm.mul %48, %19 : i32
    %50 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %51 = llvm.sext %49 : i32 to i64
    %52 = llvm.getelementptr %50[%51] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %53 = cce.intr.vldsx1.f32(%52, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %54 = cce.vcadd(%53, %dst) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %55 = llvm.mul %48, %8 : i32
    %56 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %57 = llvm.sext %55 : i32 to i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%54, %58, %1, %13, %1, %45) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %59 = llvm.add %46, %7 : i64
    llvm.br ^bb12(%59 : i64)
  ^bb14:  // pred: ^bb12
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %60 = llvm.add %43, %0 : i32
    llvm.br ^bb10(%60 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %61 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %62 = llvm.inttoptr %61 : i64 to !llvm.ptr<1>
    %63 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%62, %63, %17, %18) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


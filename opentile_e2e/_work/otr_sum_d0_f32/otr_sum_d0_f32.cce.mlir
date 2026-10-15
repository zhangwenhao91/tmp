module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d0_f32(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %6 = llvm.mlir.constant(64 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(32 : index) : i64
    %10 = llvm.mlir.constant(4 : i32) : i32
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(8192 : i64) : i64
    %13 = llvm.mlir.constant(32 : i32) : i32
    %14 = llvm.mlir.constant(288230378299196416 : i64) : i64
    %15 = llvm.mlir.constant(140737488355392 : i64) : i64
    %16 = llvm.mlir.constant(288230378299195408 : i64) : i64
    %17 = llvm.mlir.constant(70368744177728 : i64) : i64
    %18 = llvm.mlir.constant(128 : i32) : i32
    %19 = cce.get.ctrl -> i64
    %20 = cce.sbitset0(%19, %3) : (i64, i64) -> i64
    cce.set.ctrl(%20) : i64
    %21 = cce.get.ctrl -> i64
    %22 = cce.sbitset1(%21, %2) : (i64, i64) -> i64
    cce.set.ctrl(%22) : i64
    %23 = cce.get_sub_block_idx -> i64
    %24 = llvm.icmp "eq" %23, %4 : i64
    llvm.cond_br %24, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb16
    llvm.return
  ^bb3(%25: i32):  // 2 preds: ^bb1, ^bb8
    %26 = llvm.icmp "sle" %25, %1 : i32
    llvm.cond_br %26, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %27 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%7 : i64)
  ^bb5(%28: i64):  // 2 preds: ^bb4, ^bb6
    %29 = llvm.icmp "slt" %28, %9 : i64
    llvm.cond_br %29, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %30 = llvm.mul %28, %6 : i64
    %31 = cce.vdups(%5, %27, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %32 = llvm.trunc %30 : i64 to i32
    %33 = llvm.mul %32, %10 : i32
    %34 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %35 = llvm.sext %33 : i32 to i64
    %36 = llvm.getelementptr %34[%35] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%31, %36, %1, %11, %1, %27) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %37 = llvm.add %28, %8 : i64
    llvm.br ^bb5(%37 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %38 = llvm.add %25, %0 : i32
    llvm.br ^bb3(%38 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %39 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %40 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %41 = llvm.inttoptr %40 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%39, %41, %14, %15) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%42: i32):  // 2 preds: ^bb9, ^bb15
    %43 = llvm.icmp "sle" %42, %1 : i32
    llvm.cond_br %43, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %dst, %restElem = cce.plt(%13) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %44 = cce.vdups(%5, %dst, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    llvm.br ^bb12(%7, %44 : i64, vector<64xf32>)
  ^bb12(%45: i64, %46: vector<64xf32>):  // 2 preds: ^bb11, ^bb13
    %47 = llvm.icmp "slt" %45, %6 : i64
    llvm.cond_br %47, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %48 = llvm.trunc %45 : i64 to i32
    %49 = llvm.mul %48, %18 : i32
    %50 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %51 = llvm.sext %49 : i32 to i64
    %52 = llvm.getelementptr %50[%51] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %53 = cce.intr.vldsx1.f32(%52, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %54 = cce.vadd(%46, %53, %dst) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %55 = llvm.add %45, %8 : i64
    llvm.br ^bb12(%55, %54 : i64, vector<64xf32>)
  ^bb14:  // pred: ^bb12
    %56 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%46, %56, %1, %11, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %57 = llvm.add %42, %0 : i32
    llvm.br ^bb10(%57 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %58 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %59 = llvm.inttoptr %58 : i64 to !llvm.ptr<1>
    %60 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%59, %60, %16, %17) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


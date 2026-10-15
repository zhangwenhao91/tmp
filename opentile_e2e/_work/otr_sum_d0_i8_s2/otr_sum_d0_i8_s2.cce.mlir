module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d0_i8_s2(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : i8) : i8
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(16 : index) : i64
    %9 = llvm.mlir.constant(256 : index) : i64
    %10 = llvm.mlir.constant(4096 : i64) : i64
    %11 = llvm.mlir.constant(32 : i32) : i32
    %12 = llvm.mlir.constant(128 : index) : i64
    %13 = llvm.mlir.constant(288230376822801984 : i64) : i64
    %14 = llvm.mlir.constant(35184372088852 : i64) : i64
    %15 = llvm.mlir.constant(288230376822800400 : i64) : i64
    %16 = llvm.mlir.constant(21990232555540 : i64) : i64
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
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb16
    llvm.return
  ^bb3(%23: i32):  // 2 preds: ^bb1, ^bb8
    %24 = llvm.icmp "sle" %23, %1 : i32
    llvm.cond_br %24, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %25 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%6 : i64)
  ^bb5(%26: i64):  // 2 preds: ^bb4, ^bb6
    %27 = llvm.icmp "slt" %26, %8 : i64
    llvm.cond_br %27, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %28 = llvm.mul %26, %9 : i64
    %29 = cce.vdups(%5, %25, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %30 = llvm.trunc %28 : i64 to i32
    %31 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %32 = llvm.sext %30 : i32 to i64
    %33 = llvm.getelementptr %31[%32] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%29, %33, %1, %1, %1, %25) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %34 = llvm.add %26, %7 : i64
    llvm.br ^bb5(%34 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %35 = llvm.add %23, %0 : i32
    llvm.br ^bb3(%35 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %36 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %37 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %38 = llvm.inttoptr %37 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.s8.dv(%36, %38, %13, %14) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%39: i32):  // 2 preds: ^bb9, ^bb15
    %40 = llvm.icmp "sle" %39, %1 : i32
    llvm.cond_br %40, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %dst, %restElem = cce.plt(%11) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %41 = cce.vdups(%5, %dst, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb12(%6, %41 : i64, vector<256xi8>)
  ^bb12(%42: i64, %43: vector<256xi8>):  // 2 preds: ^bb11, ^bb13
    %44 = llvm.icmp "slt" %42, %12 : i64
    llvm.cond_br %44, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %45 = llvm.trunc %42 : i64 to i32
    %46 = llvm.mul %45, %11 : i32
    %47 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %48 = llvm.sext %46 : i32 to i64
    %49 = llvm.getelementptr %47[%48] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %50 = cce.intr.vldsx1.i8(%49, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %51 = cce.vadd(%43, %50, %dst) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %52 = llvm.add %42, %7 : i64
    llvm.br ^bb12(%52, %51 : i64, vector<256xi8>)
  ^bb14:  // pred: ^bb12
    %53 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%43, %53, %1, %1, %1, %dst) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %54 = llvm.add %39, %0 : i32
    llvm.br ^bb10(%54 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %55 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %56 = llvm.inttoptr %55 : i64 to !llvm.ptr<1>
    %57 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%56, %57, %15, %16) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


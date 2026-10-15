module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d0_i32_s3(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(32 : index) : i64
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(64 : index) : i64
    %9 = llvm.mlir.constant(4 : i32) : i32
    %10 = llvm.mlir.constant(2 : i32) : i32
    %11 = llvm.mlir.constant(8192 : i64) : i64
    %12 = llvm.mlir.constant(288230382594163200 : i64) : i64
    %13 = llvm.mlir.constant(281474976710848 : i64) : i64
    %14 = llvm.mlir.constant(288230382594162704 : i64) : i64
    %15 = llvm.mlir.constant(211106232533184 : i64) : i64
    %16 = llvm.mlir.constant(256 : i32) : i32
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
    %25 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%6 : i64)
  ^bb5(%26: i64):  // 2 preds: ^bb4, ^bb6
    %27 = llvm.icmp "slt" %26, %5 : i64
    llvm.cond_br %27, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %28 = llvm.mul %26, %8 : i64
    %29 = cce.vdups(%1, %25, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %30 = llvm.trunc %28 : i64 to i32
    %31 = llvm.mul %30, %9 : i32
    %32 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %33 = llvm.sext %31 : i32 to i64
    %34 = llvm.getelementptr %32[%33] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%29, %34, %1, %10, %1, %25) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %35 = llvm.add %26, %7 : i64
    llvm.br ^bb5(%35 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %36 = llvm.add %23, %0 : i32
    llvm.br ^bb3(%36 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %37 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %38 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %39 = llvm.inttoptr %38 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%37, %39, %12, %13) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%40: i32):  // 2 preds: ^bb9, ^bb15
    %41 = llvm.icmp "sle" %40, %1 : i32
    llvm.cond_br %41, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %42 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %43 = cce.vdups(%1, %42, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    llvm.br ^bb12(%6, %43 : i64, vector<64xi32>)
  ^bb12(%44: i64, %45: vector<64xi32>):  // 2 preds: ^bb11, ^bb13
    %46 = llvm.icmp "slt" %44, %5 : i64
    llvm.cond_br %46, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %47 = llvm.trunc %44 : i64 to i32
    %48 = llvm.mul %47, %16 : i32
    %49 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %50 = llvm.sext %48 : i32 to i64
    %51 = llvm.getelementptr %49[%50] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %52 = cce.intr.vldsx1.i32(%51, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %53 = cce.vadd(%45, %52, %42) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %54 = llvm.add %44, %7 : i64
    llvm.br ^bb12(%54, %53 : i64, vector<64xi32>)
  ^bb14:  // pred: ^bb12
    %55 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%45, %55, %1, %10, %1, %42) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %56 = llvm.add %40, %0 : i32
    llvm.br ^bb10(%56 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %57 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %58 = llvm.inttoptr %57 : i64 to !llvm.ptr<1>
    %59 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%58, %59, %14, %15) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


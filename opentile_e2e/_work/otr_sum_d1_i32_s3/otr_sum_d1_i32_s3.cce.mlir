module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_sum_d1_i32_s3(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
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
    %12 = llvm.mlir.constant(5 : i32) : i32
    %13 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %14 = llvm.mlir.constant(35184372088864 : i64) : i64
    %15 = llvm.mlir.constant(288230382594163200 : i64) : i64
    %16 = llvm.mlir.constant(281474976710848 : i64) : i64
    %17 = llvm.mlir.constant(256 : i32) : i32
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
    llvm.br ^bb5(%6 : i64)
  ^bb5(%27: i64):  // 2 preds: ^bb4, ^bb6
    %28 = llvm.icmp "slt" %27, %5 : i64
    llvm.cond_br %28, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %29 = llvm.mul %27, %8 : i64
    %30 = cce.vdups(%1, %26, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %31 = llvm.trunc %29 : i64 to i32
    %32 = llvm.mul %31, %9 : i32
    %33 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %34 = llvm.sext %32 : i32 to i64
    %35 = llvm.getelementptr %33[%34] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%30, %35, %1, %10, %1, %26) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %36 = llvm.add %27, %7 : i64
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
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%38, %40, %15, %16) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%41: i32):  // 2 preds: ^bb9, ^bb15
    %42 = llvm.icmp "sle" %41, %1 : i32
    llvm.cond_br %42, ^bb11, ^bb16
  ^bb11:  // pred: ^bb10
    %43 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %44 = cce.pset(%10) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb12(%6 : i64)
  ^bb12(%45: i64):  // 2 preds: ^bb11, ^bb13
    %46 = llvm.icmp "slt" %45, %5 : i64
    llvm.cond_br %46, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %47 = llvm.trunc %45 : i64 to i32
    %48 = llvm.mul %47, %17 : i32
    %49 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %50 = llvm.sext %48 : i32 to i64
    %51 = llvm.getelementptr %49[%50] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %52 = cce.intr.vldsx1.i32(%51, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %53 = cce.vcadd(%52, %43) : (vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %54 = llvm.mul %47, %9 : i32
    %55 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %56 = llvm.sext %54 : i32 to i64
    %57 = llvm.getelementptr %55[%56] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%53, %57, %1, %12, %1, %44) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %58 = llvm.add %45, %7 : i64
    llvm.br ^bb12(%58 : i64)
  ^bb14:  // pred: ^bb12
    llvm.br ^bb15
  ^bb15:  // pred: ^bb14
    %59 = llvm.add %41, %0 : i32
    llvm.br ^bb10(%59 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb16:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %60 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %61 = llvm.inttoptr %60 : i64 to !llvm.ptr<1>
    %62 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%61, %62, %13, %14) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


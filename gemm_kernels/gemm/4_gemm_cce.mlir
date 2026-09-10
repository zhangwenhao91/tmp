module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @gemm_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(128 : index) : i64
    %1 = llvm.mlir.constant(16 : i32) : i32
    %2 = llvm.mlir.constant(60 : i64) : i64
    %3 = llvm.mlir.constant(48 : i64) : i64
    %4 = llvm.mlir.constant(32768 : i64) : i64
    %5 = llvm.mlir.constant(0 : i64) : i64
    %6 = llvm.mlir.constant(68719542273 : i64) : i64
    %7 = llvm.mlir.constant(549755879425 : i64) : i64
    %8 = llvm.mlir.constant(8800387989504 : i64) : i64
    %9 = llvm.mlir.constant(65537 : i64) : i64
    %10 = llvm.mlir.constant(8830452760576 : i64) : i64
    %11 = llvm.mlir.constant(524296 : i64) : i64
    %12 = llvm.mlir.constant(1 : i64) : i64
    %13 = llvm.mlir.constant(-6917529025493073904 : i64) : i64
    %14 = llvm.mlir.constant(549756864512 : i64) : i64
    %15 = llvm.mlir.constant(8796093022224 : i64) : i64
    %16 = llvm.mlir.constant(4503599627374592 : i64) : i64
    %17 = llvm.mlir.constant(128 : i64) : i64
    %18 = llvm.mlir.constant(36028797018968064 : i64) : i64
    %19 = llvm.mlir.constant(2 : i64) : i64
    %20 = cce.get_block_idx -> i64
    %21 = llvm.trunc %20 : i64 to i32
    %22 = cce.get.ctrl -> i64
    %23 = cce.sbitset0(%22, %2) : (i64, i64) -> i64
    cce.set.ctrl(%23) : i64
    %24 = cce.get.ctrl -> i64
    %25 = cce.sbitset1(%24, %3) : (i64, i64) -> i64
    cce.set.ctrl(%25) : i64
    %26 = llvm.mul %21, %1 : i32
    %27 = llvm.sext %26 : i32 to i64
    %28 = llvm.mul %27, %0 : i64
    cce.set.mte2.nz.para(%6) : i64
    %29 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %30 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %31 = llvm.mul %28, %19 : i64
    %32 = llvm.add %30, %31 : i64
    %33 = llvm.inttoptr %32 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%29, %33, %16, %17) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%7) : i64
    %34 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %35 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %36 = llvm.inttoptr %35 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%34, %36, %18, %17) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %37 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %38 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%37, %38, %8, %9, %5) : (<3>, <2>, i64, i64, i64)
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %39 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %40 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%39, %40, %10, %11, %12) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %41 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %42 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %43 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%41, %42, %43, %13) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%12) : i64
    %44 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %45 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%44, %45, %14, %15) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %5
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %12
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @gemm_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(16 : i32) : i32
    %4 = llvm.mlir.constant(128 : index) : i64
    %5 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %6 = llvm.mlir.constant(35184372088864 : i64) : i64
    %7 = llvm.mlir.constant(1 : i64) : i64
    %8 = llvm.mlir.constant(4 : i64) : i64
    %9 = cce.get.ctrl -> i64
    %10 = cce.sbitset0(%9, %1) : (i64, i64) -> i64
    cce.set.ctrl(%10) : i64
    %11 = cce.get.ctrl -> i64
    %12 = cce.sbitset1(%11, %0) : (i64, i64) -> i64
    cce.set.ctrl(%12) : i64
    %13 = cce.get_sub_block_idx -> i64
    %14 = llvm.icmp "eq" %13, %2 : i64
    llvm.cond_br %14, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %15 = cce.get_block_idx -> i64
    %16 = llvm.trunc %15 : i64 to i32
    %17 = llvm.mul %16, %3 : i32
    %18 = llvm.sext %17 : i32 to i64
    %19 = llvm.mul %18, %4 : i64
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %2
    %20 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %21 = llvm.mul %19, %8 : i64
    %22 = llvm.add %20, %21 : i64
    %23 = llvm.inttoptr %22 : i64 to !llvm.ptr<1>
    %24 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%23, %24, %5, %6) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %7
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  ^bb2:  // 2 preds: ^bb0, ^bb1
    llvm.return
  }
}


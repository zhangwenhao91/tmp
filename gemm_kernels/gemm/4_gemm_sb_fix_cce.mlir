module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @gemm_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(60 : i64) : i64
    %1 = llvm.mlir.constant(48 : i64) : i64
    %2 = llvm.mlir.constant(32768 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(68719542273 : i64) : i64
    %5 = llvm.mlir.constant(549755879425 : i64) : i64
    %6 = llvm.mlir.constant(8800387989504 : i64) : i64
    %7 = llvm.mlir.constant(65537 : i64) : i64
    %8 = llvm.mlir.constant(8830452760576 : i64) : i64
    %9 = llvm.mlir.constant(524296 : i64) : i64
    %10 = llvm.mlir.constant(1 : i64) : i64
    %11 = llvm.mlir.constant(-6917529025493073904 : i64) : i64
    %12 = llvm.mlir.constant(549756864512 : i64) : i64
    %13 = llvm.mlir.constant(8796093022224 : i64) : i64
    %14 = llvm.mlir.constant(4503599627374592 : i64) : i64
    %15 = llvm.mlir.constant(128 : i64) : i64
    %16 = llvm.mlir.constant(36028797018968064 : i64) : i64
    %17 = cce.get.ctrl -> i64
    %18 = cce.sbitset0(%17, %0) : (i64, i64) -> i64
    cce.set.ctrl(%18) : i64
    %19 = cce.get.ctrl -> i64
    %20 = cce.sbitset1(%19, %1) : (i64, i64) -> i64
    cce.set.ctrl(%20) : i64
    cce.set.mte2.nz.para(%4) : i64
    %21 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %22 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %23 = llvm.inttoptr %22 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%21, %23, %14, %15) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%5) : i64
    %24 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    %25 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %26 = llvm.inttoptr %25 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%24, %26, %16, %15) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %27 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %28 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%27, %28, %6, %7, %3) : (<3>, <2>, i64, i64, i64)
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %29 = llvm.inttoptr %3 : i64 to !llvm.ptr<4>
    %30 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%29, %30, %8, %9, %10) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %31 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %32 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %33 = llvm.inttoptr %3 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%31, %32, %33, %11) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%10) : i64
    %34 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    %35 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%34, %35, %12, %13) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %3
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %10
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @gemm_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(60 : i64) : i64
    %1 = llvm.mlir.constant(48 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %4 = llvm.mlir.constant(35184372088864 : i64) : i64
    %5 = llvm.mlir.constant(1 : i64) : i64
    %6 = cce.get.ctrl -> i64
    %7 = cce.sbitset0(%6, %0) : (i64, i64) -> i64
    cce.set.ctrl(%7) : i64
    %8 = cce.get.ctrl -> i64
    %9 = cce.sbitset1(%8, %1) : (i64, i64) -> i64
    cce.set.ctrl(%9) : i64
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %2
    %10 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %11 = llvm.inttoptr %10 : i64 to !llvm.ptr<1>
    %12 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%11, %12, %3, %4) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %5
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
}


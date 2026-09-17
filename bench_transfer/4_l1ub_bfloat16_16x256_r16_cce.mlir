module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(8192 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(16384 : i64) : i64
    %5 = llvm.mlir.constant(24576 : i64) : i64
    %6 = llvm.mlir.constant(1024 : i64) : i64
    %7 = llvm.mlir.constant(9216 : i64) : i64
    %8 = llvm.mlir.constant(16 : index) : i64
    %9 = llvm.mlir.constant(0 : index) : i64
    %10 = llvm.mlir.constant(1 : index) : i64
    %11 = llvm.mlir.constant(68719542273 : i64) : i64
    %12 = llvm.mlir.constant(5 : i64) : i64
    %13 = llvm.mlir.constant(1099511693313 : i64) : i64
    %14 = llvm.mlir.constant(16777232 : i64) : i64
    %15 = llvm.mlir.constant(6 : i64) : i64
    %16 = llvm.mlir.constant(7 : i64) : i64
    %17 = llvm.mlir.constant(1 : i64) : i64
    %18 = llvm.mlir.constant(17596481011712 : i64) : i64
    %19 = llvm.mlir.constant(65537 : i64) : i64
    %20 = llvm.mlir.constant(1168231104512 : i64) : i64
    %21 = llvm.mlir.constant(65552 : i64) : i64
    %22 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %23 = llvm.mlir.constant(8 : i64) : i64
    %24 = llvm.mlir.constant(2 : i64) : i64
    %25 = llvm.mlir.constant(3 : i64) : i64
    %26 = llvm.mlir.constant(68720525568 : i64) : i64
    %27 = llvm.mlir.constant(8796093022224 : i64) : i64
    %28 = llvm.mlir.constant(9 : i64) : i64
    %29 = llvm.mlir.constant(10 : i64) : i64
    %30 = llvm.mlir.constant(4 : i64) : i64
    %31 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %32 = llvm.mlir.constant(256 : i64) : i64
    %33 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %34 = llvm.mlir.constant(16 : i64) : i64
    %35 = cce.get.ctrl -> i64
    %36 = cce.sbitset0(%35, %1) : (i64, i64) -> i64
    cce.set.ctrl(%36) : i64
    %37 = cce.get.ctrl -> i64
    %38 = cce.sbitset1(%37, %0) : (i64, i64) -> i64
    cce.set.ctrl(%38) : i64
    cce.set.mte2.nz.para(%11) : i64
    %39 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %40 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %41 = llvm.inttoptr %40 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%39, %41, %31, %32) : (<2>, <1>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %12
    cce.set.mte2.nz.para(%13) : i64
    %42 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %43 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %44 = llvm.inttoptr %43 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%42, %44, %33, %34) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %45 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %46 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %47 = llvm.inttoptr %46 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%45, %47, %33, %34) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%9 : i64)
  ^bb1(%48: i64):  // 2 preds: ^bb0, ^bb2
    %49 = llvm.icmp "slt" %48, %8 : i64
    llvm.cond_br %49, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %50 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    %51 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%50, %51, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %15
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %16
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %17
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %52 = llvm.inttoptr %4 : i64 to !llvm.ptr<3>
    %53 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%52, %53, %18, %19, %3) : (<3>, <2>, i64, i64, i64)
    %54 = llvm.inttoptr %4 : i64 to !llvm.ptr<4>
    %55 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%54, %55, %20, %21, %17) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %56 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %57 = llvm.inttoptr %4 : i64 to !llvm.ptr<3>
    %58 = llvm.inttoptr %4 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%56, %57, %58, %22) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %3
    %59 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    %60 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%59, %60, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %23
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %24
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %61 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %62 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%61, %62, %18, %19, %3) : (<3>, <2>, i64, i64, i64)
    %63 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %64 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%63, %64, %20, %21, %17) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %65 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    %66 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %67 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%65, %66, %67, %22) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %25
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %25
    %68 = llvm.add %48, %10 : i64
    llvm.br ^bb1(%68 : i64)
  ^bb3:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%17) : i64
    %69 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %70 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%69, %70, %26, %27) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %28
    cce.set.loop3.para(%17) : i64
    %71 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %72 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%71, %72, %26, %27) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %29
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %30
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1ub_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(8192 : i64) : i64
    %4 = llvm.mlir.constant(9216 : i64) : i64
    %5 = llvm.mlir.constant(16 : index) : i64
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(7 : i64) : i64
    %9 = llvm.mlir.constant(64424575232 : i64) : i64
    %10 = llvm.mlir.constant(1 : i64) : i64
    %11 = llvm.mlir.constant(8 : i64) : i64
    %12 = llvm.mlir.constant(5 : i64) : i64
    %13 = llvm.mlir.constant(6 : i64) : i64
    %14 = llvm.mlir.constant(2 : i64) : i64
    %15 = llvm.mlir.constant(3 : i64) : i64
    %16 = llvm.mlir.constant(9 : i64) : i64
    %17 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %18 = llvm.mlir.constant(35184372088864 : i64) : i64
    %19 = llvm.mlir.constant(10 : i64) : i64
    %20 = llvm.mlir.constant(4 : i64) : i64
    %21 = llvm.mlir.constant(256 : index) : i64
    %22 = cce.get.ctrl -> i64
    %23 = cce.sbitset0(%22, %1) : (i64, i64) -> i64
    cce.set.ctrl(%23) : i64
    %24 = cce.get.ctrl -> i64
    %25 = cce.sbitset1(%24, %0) : (i64, i64) -> i64
    cce.set.ctrl(%25) : i64
    %26 = cce.get_sub_block_idx -> i64
    %27 = llvm.icmp "eq" %26, %2 : i64
    llvm.cond_br %27, ^bb1, ^bb11
  ^bb1:  // pred: ^bb0
    llvm.br ^bb2(%6 : i64)
  ^bb2(%28: i64):  // 2 preds: ^bb1, ^bb9
    %29 = llvm.icmp "slt" %28, %5 : i64
    llvm.cond_br %29, ^bb3, ^bb10
  ^bb3:  // pred: ^bb2
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %8
    llvm.br ^bb4(%6 : i64)
  ^bb4(%30: i64):  // 2 preds: ^bb3, ^bb5
    %31 = llvm.icmp "slt" %30, %5 : i64
    llvm.cond_br %31, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %32 = llvm.mul %30, %5 : i64
    %33 = llvm.mul %30, %21 : i64
    %34 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %35 = llvm.mul %33, %14 : i64
    %36 = llvm.getelementptr %34[%35] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %37 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %38 = llvm.mul %32, %14 : i64
    %39 = llvm.getelementptr %37[%38] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%36, %39, %9) : (<2>, <6>, i64)
    %40 = llvm.add %30, %7 : i64
    llvm.br ^bb4(%40 : i64)
  ^bb6:  // pred: ^bb4
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %2
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %10
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %11
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %12
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %13
    llvm.br ^bb7(%6 : i64)
  ^bb7(%41: i64):  // 2 preds: ^bb6, ^bb8
    %42 = llvm.icmp "slt" %41, %5 : i64
    llvm.cond_br %42, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %43 = llvm.mul %41, %5 : i64
    %44 = llvm.mul %41, %21 : i64
    %45 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    %46 = llvm.mul %44, %14 : i64
    %47 = llvm.getelementptr %45[%46] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %48 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %49 = llvm.mul %43, %14 : i64
    %50 = llvm.getelementptr %48[%49] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%47, %50, %9) : (<2>, <6>, i64)
    %51 = llvm.add %41, %7 : i64
    llvm.br ^bb7(%51 : i64)
  ^bb9:  // pred: ^bb7
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %14
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %15
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %15
    %52 = llvm.add %28, %7 : i64
    llvm.br ^bb2(%52 : i64)
  ^bb10:  // pred: ^bb2
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %16
    %53 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %54 = llvm.inttoptr %53 : i64 to !llvm.ptr<1>
    %55 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%54, %55, %17, %18) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %19
    %56 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %57 = llvm.inttoptr %56 : i64 to !llvm.ptr<1>
    %58 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%57, %58, %17, %18) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %20
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb11
  ^bb11:  // 2 preds: ^bb0, ^bb10
    llvm.return
  }
}


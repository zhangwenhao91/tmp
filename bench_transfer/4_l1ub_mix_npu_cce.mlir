module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(32768 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(65536 : i64) : i64
    %5 = llvm.mlir.constant(73728 : i64) : i64
    %6 = llvm.mlir.constant(4096 : i64) : i64
    %7 = llvm.mlir.constant(36864 : i64) : i64
    %8 = llvm.mlir.constant(16384 : i64) : i64
    %9 = llvm.mlir.constant(24576 : i64) : i64
    %10 = llvm.mlir.constant(64 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(274877972481 : i64) : i64
    %14 = llvm.mlir.constant(5 : i64) : i64
    %15 = llvm.mlir.constant(1099511693313 : i64) : i64
    %16 = llvm.mlir.constant(67108880 : i64) : i64
    %17 = llvm.mlir.constant(6 : i64) : i64
    %18 = llvm.mlir.constant(7 : i64) : i64
    %19 = llvm.mlir.constant(1 : i64) : i64
    %20 = llvm.mlir.constant(17609365913600 : i64) : i64
    %21 = llvm.mlir.constant(262148 : i64) : i64
    %22 = llvm.mlir.constant(1168231104512 : i64) : i64
    %23 = llvm.mlir.constant(65552 : i64) : i64
    %24 = llvm.mlir.constant(-6917529027371597760 : i64) : i64
    %25 = llvm.mlir.constant(8 : i64) : i64
    %26 = llvm.mlir.constant(2 : i64) : i64
    %27 = llvm.mlir.constant(3 : i64) : i64
    %28 = llvm.mlir.constant(68723671296 : i64) : i64
    %29 = llvm.mlir.constant(8796093022272 : i64) : i64
    %30 = llvm.mlir.constant(9 : i64) : i64
    %31 = llvm.mlir.constant(10 : i64) : i64
    %32 = llvm.mlir.constant(4 : i64) : i64
    %33 = llvm.mlir.constant(18014398509490176 : i64) : i64
    %34 = llvm.mlir.constant(256 : i64) : i64
    %35 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %36 = llvm.mlir.constant(16 : i64) : i64
    %37 = cce.get.ctrl -> i64
    %38 = cce.sbitset0(%37, %1) : (i64, i64) -> i64
    cce.set.ctrl(%38) : i64
    %39 = cce.get.ctrl -> i64
    %40 = cce.sbitset1(%39, %0) : (i64, i64) -> i64
    cce.set.ctrl(%40) : i64
    cce.set.mte2.nz.para(%13) : i64
    %41 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %42 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %43 = llvm.inttoptr %42 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%41, %43, %33, %34) : (<2>, <1>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %14
    cce.set.mte2.nz.para(%15) : i64
    %44 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %45 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %46 = llvm.inttoptr %45 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%44, %46, %35, %36) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%15) : i64
    %47 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %48 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %49 = llvm.inttoptr %48 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%47, %49, %35, %36) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%11 : i64)
  ^bb1(%50: i64):  // 2 preds: ^bb0, ^bb2
    %51 = llvm.icmp "slt" %50, %10 : i64
    llvm.cond_br %51, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %52 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    %53 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%52, %53, %16) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %17
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %18
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %19
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %54 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %55 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%54, %55, %20, %21, %3) : (<3>, <2>, i64, i64, i64)
    %56 = llvm.inttoptr %8 : i64 to !llvm.ptr<4>
    %57 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%56, %57, %22, %23, %19) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %58 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %59 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %60 = llvm.inttoptr %8 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%58, %59, %60, %24) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %3
    %61 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    %62 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%61, %62, %16) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %25
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %26
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %63 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %64 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%63, %64, %20, %21, %3) : (<3>, <2>, i64, i64, i64)
    %65 = llvm.inttoptr %9 : i64 to !llvm.ptr<4>
    %66 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%65, %66, %22, %23, %19) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %67 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    %68 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %69 = llvm.inttoptr %9 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%67, %68, %69, %24) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %27
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %27
    %70 = llvm.add %50, %12 : i64
    llvm.br ^bb1(%70 : i64)
  ^bb3:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%19) : i64
    %71 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %72 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%71, %72, %28, %29) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %30
    cce.set.loop3.para(%19) : i64
    %73 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %74 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%73, %74, %28, %29) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %31
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %32
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1ub_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(32768 : i64) : i64
    %4 = llvm.mlir.constant(36864 : i64) : i64
    %5 = llvm.mlir.constant(64 : index) : i64
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(7 : i64) : i64
    %9 = llvm.mlir.constant(64424576000 : i64) : i64
    %10 = llvm.mlir.constant(16 : index) : i64
    %11 = llvm.mlir.constant(1 : i64) : i64
    %12 = llvm.mlir.constant(8 : i64) : i64
    %13 = llvm.mlir.constant(5 : i64) : i64
    %14 = llvm.mlir.constant(6 : i64) : i64
    %15 = llvm.mlir.constant(2 : i64) : i64
    %16 = llvm.mlir.constant(3 : i64) : i64
    %17 = llvm.mlir.constant(9 : i64) : i64
    %18 = llvm.mlir.constant(288230377225455616 : i64) : i64
    %19 = llvm.mlir.constant(35184372088864 : i64) : i64
    %20 = llvm.mlir.constant(10 : i64) : i64
    %21 = llvm.mlir.constant(4 : i64) : i64
    %22 = llvm.mlir.constant(1024 : index) : i64
    %23 = cce.get.ctrl -> i64
    %24 = cce.sbitset0(%23, %1) : (i64, i64) -> i64
    cce.set.ctrl(%24) : i64
    %25 = cce.get.ctrl -> i64
    %26 = cce.sbitset1(%25, %0) : (i64, i64) -> i64
    cce.set.ctrl(%26) : i64
    %27 = cce.get_sub_block_idx -> i64
    %28 = llvm.icmp "eq" %27, %2 : i64
    llvm.cond_br %28, ^bb1, ^bb11
  ^bb1:  // pred: ^bb0
    llvm.br ^bb2(%6 : i64)
  ^bb2(%29: i64):  // 2 preds: ^bb1, ^bb9
    %30 = llvm.icmp "slt" %29, %5 : i64
    llvm.cond_br %30, ^bb3, ^bb10
  ^bb3:  // pred: ^bb2
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %8
    llvm.br ^bb4(%6 : i64)
  ^bb4(%31: i64):  // 2 preds: ^bb3, ^bb5
    %32 = llvm.icmp "slt" %31, %10 : i64
    llvm.cond_br %32, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %33 = llvm.mul %31, %10 : i64
    %34 = llvm.mul %31, %22 : i64
    %35 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %36 = llvm.mul %34, %15 : i64
    %37 = llvm.getelementptr %35[%36] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %38 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %39 = llvm.mul %33, %15 : i64
    %40 = llvm.getelementptr %38[%39] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%37, %40, %9) : (<2>, <6>, i64)
    %41 = llvm.add %31, %7 : i64
    llvm.br ^bb4(%41 : i64)
  ^bb6:  // pred: ^bb4
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %2
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %11
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %12
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %13
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %14
    llvm.br ^bb7(%6 : i64)
  ^bb7(%42: i64):  // 2 preds: ^bb6, ^bb8
    %43 = llvm.icmp "slt" %42, %10 : i64
    llvm.cond_br %43, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %44 = llvm.mul %42, %10 : i64
    %45 = llvm.mul %42, %22 : i64
    %46 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    %47 = llvm.mul %45, %15 : i64
    %48 = llvm.getelementptr %46[%47] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %49 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %50 = llvm.mul %44, %15 : i64
    %51 = llvm.getelementptr %49[%50] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%48, %51, %9) : (<2>, <6>, i64)
    %52 = llvm.add %42, %7 : i64
    llvm.br ^bb7(%52 : i64)
  ^bb9:  // pred: ^bb7
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %15
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %16
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %16
    %53 = llvm.add %29, %7 : i64
    llvm.br ^bb2(%53 : i64)
  ^bb10:  // pred: ^bb2
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %17
    %54 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %55 = llvm.inttoptr %54 : i64 to !llvm.ptr<1>
    %56 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%55, %56, %18, %19) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %20
    %57 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %58 = llvm.inttoptr %57 : i64 to !llvm.ptr<1>
    %59 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%58, %59, %18, %19) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %21
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb11
  ^bb11:  // 2 preds: ^bb0, ^bb10
    llvm.return
  }
}


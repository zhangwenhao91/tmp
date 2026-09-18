module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(32768 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(66560 : i64) : i64
    %5 = llvm.mlir.constant(65536 : i64) : i64
    %6 = llvm.mlir.constant(73728 : i64) : i64
    %7 = llvm.mlir.constant(4096 : i64) : i64
    %8 = llvm.mlir.constant(99328 : i64) : i64
    %9 = llvm.mlir.constant(103424 : i64) : i64
    %10 = llvm.mlir.constant(16384 : i64) : i64
    %11 = llvm.mlir.constant(24576 : i64) : i64
    %12 = llvm.mlir.constant(128 : index) : i64
    %13 = llvm.mlir.constant(0 : index) : i64
    %14 = llvm.mlir.constant(1 : index) : i64
    %15 = llvm.mlir.constant(274877972481 : i64) : i64
    %16 = llvm.mlir.constant(5 : i64) : i64
    %17 = llvm.mlir.constant(1099511693313 : i64) : i64
    %18 = llvm.mlir.constant(67108880 : i64) : i64
    %19 = llvm.mlir.constant(6 : i64) : i64
    %20 = llvm.mlir.constant(7 : i64) : i64
    %21 = llvm.mlir.constant(1 : i64) : i64
    %22 = llvm.mlir.constant(17609365913600 : i64) : i64
    %23 = llvm.mlir.constant(262148 : i64) : i64
    %24 = llvm.mlir.constant(1168231104512 : i64) : i64
    %25 = llvm.mlir.constant(65552 : i64) : i64
    %26 = llvm.mlir.constant(-6917529027371597760 : i64) : i64
    %27 = llvm.mlir.constant(8 : i64) : i64
    %28 = llvm.mlir.constant(2 : i64) : i64
    %29 = llvm.mlir.constant(3 : i64) : i64
    %30 = llvm.mlir.constant(68723671296 : i64) : i64
    %31 = llvm.mlir.constant(8796093022272 : i64) : i64
    %32 = llvm.mlir.constant(9 : i64) : i64
    %33 = llvm.mlir.constant(10 : i64) : i64
    %34 = llvm.mlir.constant(4 : i64) : i64
    %35 = llvm.mlir.constant(18014398509490176 : i64) : i64
    %36 = llvm.mlir.constant(256 : i64) : i64
    %37 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %38 = llvm.mlir.constant(16 : i64) : i64
    %39 = cce.get.ctrl -> i64
    %40 = cce.sbitset0(%39, %1) : (i64, i64) -> i64
    cce.set.ctrl(%40) : i64
    %41 = cce.get.ctrl -> i64
    %42 = cce.sbitset1(%41, %0) : (i64, i64) -> i64
    cce.set.ctrl(%42) : i64
    cce.set.mte2.nz.para(%15) : i64
    %43 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %44 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %45 = llvm.inttoptr %44 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%43, %45, %35, %36) : (<2>, <1>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %16
    cce.set.mte2.nz.para(%17) : i64
    %46 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %47 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %48 = llvm.inttoptr %47 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%46, %48, %37, %38) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%17) : i64
    %49 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %50 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %51 = llvm.inttoptr %50 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%49, %51, %37, %38) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%13 : i64)
  ^bb1(%52: i64):  // 2 preds: ^bb0, ^bb2
    %53 = llvm.icmp "slt" %52, %12 : i64
    llvm.cond_br %53, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %54 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %55 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%54, %55, %18) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %19
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %20
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %21
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %56 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %57 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%56, %57, %22, %23, %3) : (<3>, <2>, i64, i64, i64)
    %58 = llvm.inttoptr %10 : i64 to !llvm.ptr<4>
    %59 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%58, %59, %24, %25, %21) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %60 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %61 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %62 = llvm.inttoptr %10 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%60, %61, %62, %26) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %3
    %63 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %64 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%63, %64, %18) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %27
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %28
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %65 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %66 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%65, %66, %22, %23, %3) : (<3>, <2>, i64, i64, i64)
    %67 = llvm.inttoptr %11 : i64 to !llvm.ptr<4>
    %68 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%67, %68, %24, %25, %21) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %69 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    %70 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %71 = llvm.inttoptr %11 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%69, %70, %71, %26) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %29
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %29
    %72 = llvm.add %52, %14 : i64
    llvm.br ^bb1(%72 : i64)
  ^bb3:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%21) : i64
    %73 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %74 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%73, %74, %30, %31) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %32
    cce.set.loop3.para(%21) : i64
    %75 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %76 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%75, %76, %30, %31) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %33
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %34
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1ub_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(32768 : i64) : i64
    %6 = llvm.mlir.constant(66560 : i64) : i64
    %7 = llvm.mlir.constant(99328 : i64) : i64
    %8 = llvm.mlir.constant(103424 : i64) : i64
    %9 = llvm.mlir.constant(33280 : i64) : i64
    %10 = llvm.mlir.constant(128 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(5 : i64) : i64
    %14 = llvm.mlir.constant(7 : i64) : i64
    %15 = llvm.mlir.constant(4259840 : i32) : i32
    %16 = llvm.mlir.constant(2 : index) : i64
    %17 = llvm.mlir.constant(64 : index) : i64
    %18 = llvm.mlir.constant(256 : index) : i64
    %19 = llvm.mlir.constant(8320 : index) : i64
    %20 = llvm.mlir.constant(16 : index) : i64
    %21 = llvm.mlir.constant(4299161856 : i64) : i64
    %22 = llvm.mlir.constant(1 : i64) : i64
    %23 = llvm.mlir.constant(8 : i64) : i64
    %24 = llvm.mlir.constant(6 : i64) : i64
    %25 = llvm.mlir.constant(2 : i64) : i64
    %26 = llvm.mlir.constant(3 : i64) : i64
    %27 = llvm.mlir.constant(9 : i64) : i64
    %28 = llvm.mlir.constant(288230377225455616 : i64) : i64
    %29 = llvm.mlir.constant(35184372088864 : i64) : i64
    %30 = llvm.mlir.constant(10 : i64) : i64
    %31 = llvm.mlir.constant(4 : i64) : i64
    %32 = cce.get.ctrl -> i64
    %33 = cce.sbitset0(%32, %3) : (i64, i64) -> i64
    cce.set.ctrl(%33) : i64
    %34 = cce.get.ctrl -> i64
    %35 = cce.sbitset1(%34, %2) : (i64, i64) -> i64
    cce.set.ctrl(%35) : i64
    %36 = cce.get_sub_block_idx -> i64
    %37 = llvm.icmp "eq" %36, %4 : i64
    llvm.cond_br %37, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %13
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb2(%11 : i64)
  ^bb2(%38: i64):  // 2 preds: ^bb1, ^bb25
    %39 = llvm.icmp "slt" %38, %10 : i64
    llvm.cond_br %39, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %14
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %27
    %40 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %41 = llvm.inttoptr %40 : i64 to !llvm.ptr<1>
    %42 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%41, %42, %28, %29) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %30
    %43 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %44 = llvm.inttoptr %43 : i64 to !llvm.ptr<1>
    %45 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%44, %45, %28, %29) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %31
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%46: i32):  // 2 preds: ^bb3, ^bb14
    %47 = llvm.icmp "sle" %46, %1 : i32
    llvm.cond_br %47, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %48 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%11 : i64)
  ^bb8(%49: i64):  // 2 preds: ^bb7, ^bb12
    %50 = llvm.icmp "slt" %49, %16 : i64
    llvm.cond_br %50, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%11 : i64)
  ^bb10(%51: i64):  // 2 preds: ^bb9, ^bb11
    %52 = llvm.icmp "slt" %51, %17 : i64
    llvm.cond_br %52, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %53 = llvm.mul %51, %18 : i64
    %54 = llvm.mul %49, %10 : i64
    %55 = llvm.add %53, %54 : i64
    %56 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %57 = llvm.mul %55, %25 : i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %59 = cce.intr.vldsx1.bf16(%58, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %60 = llvm.mul %49, %19 : i64
    %61 = llvm.mul %51, %20 : i64
    %62 = llvm.add %60, %61 : i64
    %63 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %64 = llvm.mul %62, %25 : i64
    %65 = llvm.getelementptr %63[%64] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%59, %65, %15, %1, %48) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %66 = llvm.add %51, %12 : i64
    llvm.br ^bb10(%66 : i64)
  ^bb12:  // pred: ^bb10
    %67 = llvm.add %49, %12 : i64
    llvm.br ^bb8(%67 : i64)
  ^bb13:  // pred: ^bb8
    llvm.br ^bb14
  ^bb14:  // pred: ^bb13
    %68 = llvm.add %46, %0 : i32
    llvm.br ^bb6(%68 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb15:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %69 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %70 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%69, %70, %21) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %22
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %23
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb16(%1 : i32)
  ^bb16(%71: i32):  // 2 preds: ^bb15, ^bb24
    %72 = llvm.icmp "sle" %71, %1 : i32
    llvm.cond_br %72, ^bb17, ^bb25
  ^bb17:  // pred: ^bb16
    %73 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%11 : i64)
  ^bb18(%74: i64):  // 2 preds: ^bb17, ^bb22
    %75 = llvm.icmp "slt" %74, %16 : i64
    llvm.cond_br %75, ^bb19, ^bb23
  ^bb19:  // pred: ^bb18
    llvm.br ^bb20(%11 : i64)
  ^bb20(%76: i64):  // 2 preds: ^bb19, ^bb21
    %77 = llvm.icmp "slt" %76, %17 : i64
    llvm.cond_br %77, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %78 = llvm.mul %76, %18 : i64
    %79 = llvm.mul %74, %10 : i64
    %80 = llvm.add %78, %79 : i64
    %81 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %82 = llvm.mul %80, %25 : i64
    %83 = llvm.getelementptr %81[%82] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %84 = cce.intr.vldsx1.bf16(%83, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %85 = llvm.mul %74, %19 : i64
    %86 = llvm.mul %76, %20 : i64
    %87 = llvm.add %85, %86 : i64
    %88 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %89 = llvm.mul %87, %25 : i64
    %90 = llvm.getelementptr %88[%89] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%84, %90, %15, %1, %73) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %91 = llvm.add %76, %12 : i64
    llvm.br ^bb20(%91 : i64)
  ^bb22:  // pred: ^bb20
    %92 = llvm.add %74, %12 : i64
    llvm.br ^bb18(%92 : i64)
  ^bb23:  // pred: ^bb18
    llvm.br ^bb24
  ^bb24:  // pred: ^bb23
    %93 = llvm.add %71, %0 : i32
    llvm.br ^bb16(%93 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb25:  // pred: ^bb16
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %24
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %94 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %95 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%94, %95, %21) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %25
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %26
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %26
    %96 = llvm.add %38, %12 : i64
    llvm.br ^bb2(%96 : i64)
  }
}


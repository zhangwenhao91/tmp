module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(16384 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(34816 : i64) : i64
    %5 = llvm.mlir.constant(32768 : i64) : i64
    %6 = llvm.mlir.constant(49152 : i64) : i64
    %7 = llvm.mlir.constant(1024 : i64) : i64
    %8 = llvm.mlir.constant(51200 : i64) : i64
    %9 = llvm.mlir.constant(52224 : i64) : i64
    %10 = llvm.mlir.constant(16 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(68719542273 : i64) : i64
    %14 = llvm.mlir.constant(5 : i64) : i64
    %15 = llvm.mlir.constant(1099511693313 : i64) : i64
    %16 = llvm.mlir.constant(33554448 : i64) : i64
    %17 = llvm.mlir.constant(6 : i64) : i64
    %18 = llvm.mlir.constant(7 : i64) : i64
    %19 = llvm.mlir.constant(1 : i64) : i64
    %20 = llvm.mlir.constant(35188667056128 : i64) : i64
    %21 = llvm.mlir.constant(65537 : i64) : i64
    %22 = llvm.mlir.constant(2267742732288 : i64) : i64
    %23 = llvm.mlir.constant(65552 : i64) : i64
    %24 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %25 = llvm.mlir.constant(8 : i64) : i64
    %26 = llvm.mlir.constant(2 : i64) : i64
    %27 = llvm.mlir.constant(3 : i64) : i64
    %28 = llvm.mlir.constant(68720525568 : i64) : i64
    %29 = llvm.mlir.constant(8796093022224 : i64) : i64
    %30 = llvm.mlir.constant(9 : i64) : i64
    %31 = llvm.mlir.constant(10 : i64) : i64
    %32 = llvm.mlir.constant(4 : i64) : i64
    %33 = llvm.mlir.constant(4503599627386880 : i64) : i64
    %34 = llvm.mlir.constant(256 : i64) : i64
    %35 = llvm.mlir.constant(72057594037928960 : i64) : i64
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
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%41, %43, %33, %34) : (<2>, <1>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %14
    cce.set.mte2.nz.para(%15) : i64
    %44 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %45 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %46 = llvm.inttoptr %45 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%44, %46, %35, %36) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%15) : i64
    %47 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %48 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %49 = llvm.inttoptr %48 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%47, %49, %35, %36) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%11 : i64)
  ^bb1(%50: i64):  // 2 preds: ^bb0, ^bb2
    %51 = llvm.icmp "slt" %50, %10 : i64
    llvm.cond_br %51, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %52 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %53 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%52, %53, %16) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %17
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %18
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %19
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %54 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %55 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.f32(%54, %55, %20, %21, %3) : (<3>, <2>, i64, i64, i64)
    %56 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %57 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.f32(%56, %57, %22, %23, %19) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %58 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %59 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %60 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.f322f32(%58, %59, %60, %24) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %3
    %61 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %62 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%61, %62, %16) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %25
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %26
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %63 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %64 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.f32(%63, %64, %20, %21, %3) : (<3>, <2>, i64, i64, i64)
    %65 = llvm.inttoptr %6 : i64 to !llvm.ptr<4>
    %66 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.f32(%65, %66, %22, %23, %19) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %67 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    %68 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %69 = llvm.inttoptr %6 : i64 to !llvm.ptr<4>
    cce.intr.mad.f322f32(%67, %68, %69, %24) : (<5>, <3>, <4>, i64)
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
    %71 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %72 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%71, %72, %28, %29) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %30
    cce.set.loop3.para(%19) : i64
    %73 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %74 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%73, %74, %28, %29) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %31
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %32
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1ub_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(16384 : i64) : i64
    %6 = llvm.mlir.constant(34816 : i64) : i64
    %7 = llvm.mlir.constant(51200 : i64) : i64
    %8 = llvm.mlir.constant(52224 : i64) : i64
    %9 = llvm.mlir.constant(17408 : i64) : i64
    %10 = llvm.mlir.constant(16 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(5 : i64) : i64
    %14 = llvm.mlir.constant(7 : i64) : i64
    %15 = llvm.mlir.constant(1114112 : i32) : i32
    %16 = llvm.mlir.constant(4 : index) : i64
    %17 = llvm.mlir.constant(256 : index) : i64
    %18 = llvm.mlir.constant(64 : index) : i64
    %19 = llvm.mlir.constant(1088 : index) : i64
    %20 = llvm.mlir.constant(8 : index) : i64
    %21 = llvm.mlir.constant(4296016384 : i64) : i64
    %22 = llvm.mlir.constant(1 : i64) : i64
    %23 = llvm.mlir.constant(8 : i64) : i64
    %24 = llvm.mlir.constant(6 : i64) : i64
    %25 = llvm.mlir.constant(2 : i64) : i64
    %26 = llvm.mlir.constant(3 : i64) : i64
    %27 = llvm.mlir.constant(9 : i64) : i64
    %28 = llvm.mlir.constant(288230377225454080 : i64) : i64
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
    %48 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%11 : i64)
  ^bb8(%49: i64):  // 2 preds: ^bb7, ^bb12
    %50 = llvm.icmp "slt" %49, %16 : i64
    llvm.cond_br %50, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%11 : i64)
  ^bb10(%51: i64):  // 2 preds: ^bb9, ^bb11
    %52 = llvm.icmp "slt" %51, %10 : i64
    llvm.cond_br %52, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %53 = llvm.mul %51, %17 : i64
    %54 = llvm.mul %49, %18 : i64
    %55 = llvm.add %53, %54 : i64
    %56 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %57 = llvm.mul %55, %31 : i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %59 = cce.intr.vldsx1.f32(%58, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %60 = llvm.mul %49, %19 : i64
    %61 = llvm.mul %51, %20 : i64
    %62 = llvm.add %60, %61 : i64
    %63 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %64 = llvm.mul %62, %31 : i64
    %65 = llvm.getelementptr %63[%64] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%59, %65, %15, %1, %48) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
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
    %73 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%11 : i64)
  ^bb18(%74: i64):  // 2 preds: ^bb17, ^bb22
    %75 = llvm.icmp "slt" %74, %16 : i64
    llvm.cond_br %75, ^bb19, ^bb23
  ^bb19:  // pred: ^bb18
    llvm.br ^bb20(%11 : i64)
  ^bb20(%76: i64):  // 2 preds: ^bb19, ^bb21
    %77 = llvm.icmp "slt" %76, %10 : i64
    llvm.cond_br %77, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %78 = llvm.mul %76, %17 : i64
    %79 = llvm.mul %74, %18 : i64
    %80 = llvm.add %78, %79 : i64
    %81 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %82 = llvm.mul %80, %31 : i64
    %83 = llvm.getelementptr %81[%82] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %84 = cce.intr.vldsx1.f32(%83, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %85 = llvm.mul %74, %19 : i64
    %86 = llvm.mul %76, %20 : i64
    %87 = llvm.add %85, %86 : i64
    %88 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %89 = llvm.mul %87, %31 : i64
    %90 = llvm.getelementptr %88[%89] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%84, %90, %15, %1, %73) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
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


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(8192 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(16384 : i64) : i64
    %5 = llvm.mlir.constant(24576 : i64) : i64
    %6 = llvm.mlir.constant(1024 : i64) : i64
    %7 = llvm.mlir.constant(25600 : i64) : i64
    %8 = llvm.mlir.constant(26624 : i64) : i64
    %9 = llvm.mlir.constant(16 : index) : i64
    %10 = llvm.mlir.constant(0 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(68719542273 : i64) : i64
    %13 = llvm.mlir.constant(1099511693313 : i64) : i64
    %14 = llvm.mlir.constant(7 : i64) : i64
    %15 = llvm.mlir.constant(6 : i64) : i64
    %16 = llvm.mlir.constant(3 : i64) : i64
    %17 = llvm.mlir.constant(1 : i64) : i64
    %18 = llvm.mlir.constant(17596481011712 : i64) : i64
    %19 = llvm.mlir.constant(65537 : i64) : i64
    %20 = llvm.mlir.constant(1168231104512 : i64) : i64
    %21 = llvm.mlir.constant(65552 : i64) : i64
    %22 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %23 = llvm.mlir.constant(2 : i64) : i64
    %24 = llvm.mlir.constant(68720525568 : i64) : i64
    %25 = llvm.mlir.constant(8796093022224 : i64) : i64
    %26 = llvm.mlir.constant(9 : i64) : i64
    %27 = llvm.mlir.constant(10 : i64) : i64
    %28 = llvm.mlir.constant(4 : i64) : i64
    %29 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %30 = llvm.mlir.constant(256 : i64) : i64
    %31 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %32 = llvm.mlir.constant(16 : i64) : i64
    %33 = cce.get.ctrl -> i64
    %34 = cce.sbitset0(%33, %1) : (i64, i64) -> i64
    cce.set.ctrl(%34) : i64
    %35 = cce.get.ctrl -> i64
    %36 = cce.sbitset1(%35, %0) : (i64, i64) -> i64
    cce.set.ctrl(%36) : i64
    cce.set.mte2.nz.para(%12) : i64
    %37 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %38 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %39 = llvm.inttoptr %38 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%37, %39, %29, %30) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %40 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %41 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %42 = llvm.inttoptr %41 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%40, %42, %31, %32) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %43 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %44 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %45 = llvm.inttoptr %44 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%43, %45, %31, %32) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %14
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %15
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %16
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%10 : i64)
  ^bb1(%46: i64):  // 2 preds: ^bb0, ^bb2
    %47 = llvm.icmp "slt" %46, %9 : i64
    llvm.cond_br %47, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %17
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %48 = llvm.inttoptr %4 : i64 to !llvm.ptr<3>
    %49 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%48, %49, %18, %19, %3) : (<3>, <2>, i64, i64, i64)
    %50 = llvm.inttoptr %4 : i64 to !llvm.ptr<4>
    %51 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%50, %51, %20, %21, %17) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %52 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %53 = llvm.inttoptr %4 : i64 to !llvm.ptr<3>
    %54 = llvm.inttoptr %4 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%52, %53, %54, %22) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %15
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %23
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %55 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %56 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%55, %56, %18, %19, %3) : (<3>, <2>, i64, i64, i64)
    %57 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %58 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%57, %58, %20, %21, %17) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %59 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    %60 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %61 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%59, %60, %61, %22) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %16
    %62 = llvm.add %46, %11 : i64
    llvm.br ^bb1(%62 : i64)
  ^bb3:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%17) : i64
    %63 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %64 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%63, %64, %24, %25) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %26
    cce.set.loop3.para(%17) : i64
    %65 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %66 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%65, %66, %24, %25) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %27
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %28
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1ub_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(8192 : i64) : i64
    %6 = llvm.mlir.constant(17408 : i64) : i64
    %7 = llvm.mlir.constant(25600 : i64) : i64
    %8 = llvm.mlir.constant(26624 : i64) : i64
    %9 = llvm.mlir.constant(8704 : i64) : i64
    %10 = llvm.mlir.constant(16 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(7 : i64) : i64
    %14 = llvm.mlir.constant(6 : i64) : i64
    %15 = llvm.mlir.constant(16777232 : i64) : i64
    %16 = llvm.mlir.constant(1114112 : i32) : i32
    %17 = llvm.mlir.constant(2 : index) : i64
    %18 = llvm.mlir.constant(256 : index) : i64
    %19 = llvm.mlir.constant(128 : index) : i64
    %20 = llvm.mlir.constant(2176 : index) : i64
    %21 = llvm.mlir.constant(4296016128 : i64) : i64
    %22 = llvm.mlir.constant(1 : i64) : i64
    %23 = llvm.mlir.constant(3 : i64) : i64
    %24 = llvm.mlir.constant(2 : i64) : i64
    %25 = llvm.mlir.constant(9 : i64) : i64
    %26 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %27 = llvm.mlir.constant(35184372088864 : i64) : i64
    %28 = llvm.mlir.constant(10 : i64) : i64
    %29 = llvm.mlir.constant(4 : i64) : i64
    %30 = cce.get.ctrl -> i64
    %31 = cce.sbitset0(%30, %3) : (i64, i64) -> i64
    cce.set.ctrl(%31) : i64
    %32 = cce.get.ctrl -> i64
    %33 = cce.sbitset1(%32, %2) : (i64, i64) -> i64
    cce.set.ctrl(%33) : i64
    %34 = cce.get_sub_block_idx -> i64
    %35 = llvm.icmp "eq" %34, %4 : i64
    llvm.cond_br %35, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %13
    llvm.br ^bb2(%11 : i64)
  ^bb2(%36: i64):  // 2 preds: ^bb1, ^bb25
    %37 = llvm.icmp "slt" %36, %10 : i64
    llvm.cond_br %37, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %14
    %38 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %39 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%38, %39, %15) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %25
    %40 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %41 = llvm.inttoptr %40 : i64 to !llvm.ptr<1>
    %42 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%41, %42, %26, %27) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %28
    %43 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %44 = llvm.inttoptr %43 : i64 to !llvm.ptr<1>
    %45 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%44, %45, %26, %27) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %29
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
    %50 = llvm.icmp "slt" %49, %17 : i64
    llvm.cond_br %50, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%11 : i64)
  ^bb10(%51: i64):  // 2 preds: ^bb9, ^bb11
    %52 = llvm.icmp "slt" %51, %10 : i64
    llvm.cond_br %52, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %53 = llvm.mul %51, %18 : i64
    %54 = llvm.mul %49, %19 : i64
    %55 = llvm.add %53, %54 : i64
    %56 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %57 = llvm.mul %55, %24 : i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %59 = cce.intr.vldsx1.bf16(%58, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %60 = llvm.mul %49, %20 : i64
    %61 = llvm.mul %51, %10 : i64
    %62 = llvm.add %60, %61 : i64
    %63 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %64 = llvm.mul %62, %24 : i64
    %65 = llvm.getelementptr %63[%64] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%59, %65, %16, %1, %48) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
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
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    %69 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %70 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%69, %70, %21) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %22
    %71 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %72 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%71, %72, %15) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    llvm.br ^bb16(%1 : i32)
  ^bb16(%73: i32):  // 2 preds: ^bb15, ^bb24
    %74 = llvm.icmp "sle" %73, %1 : i32
    llvm.cond_br %74, ^bb17, ^bb25
  ^bb17:  // pred: ^bb16
    %75 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%11 : i64)
  ^bb18(%76: i64):  // 2 preds: ^bb17, ^bb22
    %77 = llvm.icmp "slt" %76, %17 : i64
    llvm.cond_br %77, ^bb19, ^bb23
  ^bb19:  // pred: ^bb18
    llvm.br ^bb20(%11 : i64)
  ^bb20(%78: i64):  // 2 preds: ^bb19, ^bb21
    %79 = llvm.icmp "slt" %78, %10 : i64
    llvm.cond_br %79, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %80 = llvm.mul %78, %18 : i64
    %81 = llvm.mul %76, %19 : i64
    %82 = llvm.add %80, %81 : i64
    %83 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %84 = llvm.mul %82, %24 : i64
    %85 = llvm.getelementptr %83[%84] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %86 = cce.intr.vldsx1.bf16(%85, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %87 = llvm.mul %76, %20 : i64
    %88 = llvm.mul %78, %10 : i64
    %89 = llvm.add %87, %88 : i64
    %90 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %91 = llvm.mul %89, %24 : i64
    %92 = llvm.getelementptr %90[%91] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%86, %92, %16, %1, %75) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %93 = llvm.add %78, %12 : i64
    llvm.br ^bb20(%93 : i64)
  ^bb22:  // pred: ^bb20
    %94 = llvm.add %76, %12 : i64
    llvm.br ^bb18(%94 : i64)
  ^bb23:  // pred: ^bb18
    llvm.br ^bb24
  ^bb24:  // pred: ^bb23
    %95 = llvm.add %73, %0 : i32
    llvm.br ^bb16(%95 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb25:  // pred: ^bb16
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %23
    %96 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %97 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%96, %97, %21) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %24
    %98 = llvm.add %36, %12 : i64
    llvm.br ^bb2(%98 : i64)
  }
}


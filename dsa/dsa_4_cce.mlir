module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @main_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32, %arg6: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(32768 : i64) : i64
    %4 = llvm.mlir.constant(40960 : i64) : i64
    %5 = llvm.mlir.constant(65536 : i64) : i64
    %6 = llvm.mlir.constant(82432 : i64) : i64
    %7 = llvm.mlir.constant(16384 : i64) : i64
    %8 = llvm.mlir.constant(24576 : i64) : i64
    %9 = llvm.mlir.constant(8 : index) : i64
    %10 = llvm.mlir.constant(128 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(128 : i32) : i32
    %13 = llvm.mlir.constant(1 : index) : i64
    %14 = llvm.mlir.constant(16384 : index) : i64
    %15 = llvm.mlir.constant(274877972481 : i64) : i64
    %16 = llvm.mlir.constant(17609365913600 : i64) : i64
    %17 = llvm.mlir.constant(262148 : i64) : i64
    %18 = llvm.mlir.constant(17596481011712 : i64) : i64
    %19 = llvm.mlir.constant(65537 : i64) : i64
    %20 = llvm.mlir.constant(-6917529027371597760 : i64) : i64
    %21 = llvm.mlir.constant(68723671296 : i64) : i64
    %22 = llvm.mlir.constant(8796093087808 : i64) : i64
    %23 = llvm.mlir.constant(1 : i64) : i64
    %24 = llvm.mlir.constant(4 : i64) : i64
    %25 = llvm.mlir.constant(1116691496960 : i64) : i64
    %26 = llvm.mlir.constant(1048577 : i64) : i64
    %27 = llvm.mlir.constant(-6917529023346048960 : i64) : i64
    %28 = llvm.mlir.constant(1099515826176 : i64) : i64
    %29 = llvm.mlir.constant(5 : i64) : i64
    %30 = llvm.mlir.constant(2 : i64) : i64
    %31 = llvm.mlir.constant(3 : i64) : i64
    %32 = llvm.mlir.constant(18014398509490176 : i64) : i64
    %33 = llvm.mlir.constant(256 : i64) : i64
    %34 = cce.get.ctrl -> i64
    %35 = cce.sbitset0(%34, %1) : (i64, i64) -> i64
    cce.set.ctrl(%35) : i64
    %36 = cce.get.ctrl -> i64
    %37 = cce.sbitset1(%36, %0) : (i64, i64) -> i64
    cce.set.ctrl(%37) : i64
    %38 = cce.get_block_idx -> i64
    %39 = llvm.trunc %38 : i64 to i32
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    llvm.br ^bb1(%11 : i64)
  ^bb1(%40: i64):  // 2 preds: ^bb0, ^bb5
    %41 = llvm.icmp "slt" %40, %10 : i64
    llvm.cond_br %41, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    %42 = llvm.mul %39, %12 : i32
    %43 = llvm.sext %42 : i32 to i64
    %44 = llvm.add %43, %40 : i64
    %45 = llvm.mul %44, %14 : i64
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%15) : i64
    %46 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %47 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %48 = llvm.mul %45, %30 : i64
    %49 = llvm.add %47, %48 : i64
    %50 = llvm.inttoptr %49 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%46, %50, %32, %33) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID1>
    llvm.br ^bb3(%11 : i64)
  ^bb3(%51: i64):  // 2 preds: ^bb2, ^bb4
    %52 = llvm.icmp "slt" %51, %9 : i64
    llvm.cond_br %52, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %53 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %54 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%53, %54, %16, %17, %2) : (<3>, <2>, i64, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %2
    %55 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    %56 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%55, %56, %18, %19, %2) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %57 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %58 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %59 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%57, %58, %59, %20) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%23) : i64
    %60 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %61 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%60, %61, %21, %22) : (<6>, <5>, i64, i64)
    cce.set_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %24
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %23
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %62 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %63 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%62, %63, %25, %17, %2) : (<3>, <2>, i64, i64, i64)
    %64 = llvm.inttoptr %8 : i64 to !llvm.ptr<4>
    %65 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%64, %65, %18, %26, %23) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID1>
    %66 = llvm.inttoptr %2 : i64 to !llvm.ptr<5>
    %67 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %68 = llvm.inttoptr %8 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%66, %67, %68, %27) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%23) : i64
    %69 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    %70 = llvm.inttoptr %2 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%69, %70, %28, %22) : (<6>, <5>, i64, i64)
    cce.set_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %29
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %30
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %30
    %71 = llvm.add %51, %13 : i64
    llvm.br ^bb3(%71 : i64)
  ^bb5:  // pred: ^bb3
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %72 = llvm.add %40, %13 : i64
    llvm.br ^bb1(%72 : i64)
  ^bb6:  // pred: ^bb1
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %31
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @main_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32, %arg6: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(32768 : i64) : i64
    %6 = llvm.mlir.constant(40960 : i64) : i64
    %7 = llvm.mlir.constant(85504 : i64) : i64
    %8 = llvm.mlir.constant(74240 : i64) : i64
    %9 = llvm.mlir.constant(65536 : i64) : i64
    %10 = llvm.mlir.constant(82432 : i64) : i64
    %11 = llvm.mlir.constant(84480 : i64) : i64
    %12 = llvm.mlir.constant(86016 : i64) : i64
    %13 = llvm.mlir.constant(86144 : i64) : i64
    %14 = llvm.mlir.constant(86272 : i64) : i64
    %15 = llvm.mlir.constant(86400 : i64) : i64
    %16 = llvm.mlir.constant(86528 : i64) : i64
    %17 = llvm.mlir.constant(1 : i64) : i64
    %18 = llvm.mlir.constant(16 : index) : i64
    %19 = llvm.mlir.constant(8 : index) : i64
    %20 = llvm.mlir.constant(128 : index) : i64
    %21 = llvm.mlir.constant(0 : index) : i64
    %22 = llvm.mlir.constant(128 : i32) : i32
    %23 = llvm.mlir.constant(1 : index) : i64
    %24 = llvm.mlir.constant(16384 : index) : i64
    %25 = llvm.mlir.constant(256 : index) : i64
    %26 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %27 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %28 = llvm.mlir.constant(32 : i32) : i32
    %29 = llvm.mlir.constant(6.250000e-02 : f32) : f32
    %30 = llvm.mlir.constant(4 : i32) : i32
    %31 = llvm.mlir.constant(64 : i32) : i32
    %32 = llvm.mlir.constant(256 : i32) : i32
    %33 = llvm.mlir.constant(2 : i32) : i32
    %34 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %35 = llvm.mlir.constant(35184372088864 : i64) : i64
    %36 = llvm.mlir.constant(288230377225453824 : i64) : i64
    %37 = llvm.mlir.constant(1114112 : i32) : i32
    %38 = llvm.mlir.constant(2 : index) : i64
    %39 = llvm.mlir.constant(2176 : index) : i64
    %40 = llvm.mlir.constant(4296016128 : i64) : i64
    %41 = llvm.mlir.constant(4 : i64) : i64
    %42 = llvm.mlir.constant(3 : i32) : i32
    %43 = llvm.mlir.constant(5 : i32) : i32
    %44 = llvm.mlir.constant(32 : index) : i64
    %45 = llvm.mlir.constant(16 : i32) : i32
    %46 = llvm.mlir.constant(7 : i32) : i32
    %47 = llvm.mlir.constant(66048 : i64) : i64
    %48 = llvm.mlir.constant(5 : i64) : i64
    %49 = llvm.mlir.constant(4 : index) : i64
    %50 = llvm.mlir.constant(2 : i64) : i64
    %51 = llvm.mlir.constant(288230377225469952 : i64) : i64
    %52 = llvm.mlir.constant(3 : i64) : i64
    %53 = llvm.mlir.constant(512 : index) : i64
    %54 = llvm.mlir.constant(128 : i64) : i64
    %55 = cce.get.ctrl -> i64
    %56 = cce.sbitset0(%55, %3) : (i64, i64) -> i64
    cce.set.ctrl(%56) : i64
    %57 = cce.get.ctrl -> i64
    %58 = cce.sbitset1(%57, %2) : (i64, i64) -> i64
    cce.set.ctrl(%58) : i64
    %59 = cce.get_sub_block_idx -> i64
    %60 = llvm.icmp "eq" %59, %4 : i64
    llvm.cond_br %60, ^bb1, ^bb14
  ^bb1:  // pred: ^bb0
    %61 = llvm.trunc %59 : i64 to i32
    %62 = cce.get_block_idx -> i64
    %63 = llvm.trunc %62 : i64 to i32
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID2>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID1>
    llvm.br ^bb2(%21 : i64)
  ^bb2(%64: i64):  // 2 preds: ^bb1, ^bb75
    %65 = llvm.icmp "slt" %64, %20 : i64
    llvm.cond_br %65, ^bb3, ^bb13
  ^bb3:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID2>
    llvm.br ^bb15(%1 : i32)
  ^bb4(%66: i64):  // 2 preds: ^bb5, ^bb21
    %67 = llvm.icmp "slt" %66, %20 : i64
    llvm.cond_br %67, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %68 = llvm.mul %63, %22 : i32
    %69 = llvm.sext %68 : i32 to i64
    %70 = llvm.add %69, %64 : i64
    %71 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %72 = llvm.inttoptr %71 : i64 to !llvm.ptr<1>
    %73 = llvm.mul %70, %54 : i64
    %74 = llvm.add %73, %66 : i64
    %75 = llvm.getelementptr %72[%74] : (!llvm.ptr<1>, i64) -> !llvm.ptr<1>, i32
    %76 = llvm.load %75 : !llvm.ptr<1> -> i32
    %77 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %78 = llvm.getelementptr %77[%66] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i32
    llvm.store %76, %78 : i32, !llvm.ptr<6>
    %79 = llvm.add %66, %23 : i64
    llvm.br ^bb4(%79 : i64)
  ^bb6:  // pred: ^bb4
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb7(%21 : i64)
  ^bb7(%80: i64):  // 2 preds: ^bb6, ^bb65
    %81 = llvm.icmp "slt" %80, %19 : i64
    llvm.cond_br %81, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    llvm.br ^bb9(%21 : i64)
  ^bb9(%82: i64):  // 2 preds: ^bb8, ^bb10
    %83 = llvm.icmp "slt" %82, %18 : i64
    llvm.cond_br %83, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %84 = llvm.mul %80, %18 : i64
    %85 = llvm.add %84, %82 : i64
    %86 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %87 = llvm.getelementptr %86[%85] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i32
    %88 = llvm.load %87 : !llvm.ptr<6> -> i32
    %89 = llvm.sext %88 : i32 to i64
    %90 = llvm.mul %89, %25 : i64
    %91 = llvm.mul %82, %25 : i64
    %92 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %93 = llvm.mul %91, %50 : i64
    %94 = llvm.getelementptr %92[%93] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %95 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %96 = llvm.mul %90, %50 : i64
    %97 = llvm.add %95, %96 : i64
    %98 = llvm.inttoptr %97 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%94, %98, %36, %35) : (<6>, <1>, i64, i64)
    %99 = llvm.add %82, %23 : i64
    llvm.br ^bb9(%99 : i64)
  ^bb11:  // pred: ^bb9
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb22(%1 : i32)
  ^bb12:  // pred: ^bb7
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    llvm.br ^bb66(%1 : i32)
  ^bb13:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID2>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %52
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb14
  ^bb14:  // 2 preds: ^bb0, ^bb13
    llvm.return
  ^bb15(%100: i32):  // 2 preds: ^bb3, ^bb20
    %101 = llvm.icmp "sle" %100, %1 : i32
    llvm.cond_br %101, ^bb16, ^bb21
  ^bb16:  // pred: ^bb15
    %102 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb17(%21 : i64)
  ^bb17(%103: i64):  // 2 preds: ^bb16, ^bb18
    %104 = llvm.icmp "slt" %103, %20 : i64
    llvm.cond_br %104, ^bb18, ^bb19
  ^bb18:  // pred: ^bb17
    %105 = llvm.trunc %103 : i64 to i32
    %106 = llvm.udiv %105, %30 : i32
    %107 = llvm.urem %105, %30 : i32
    %108 = llvm.mul %107, %31 : i32
    %109 = llvm.mul %106, %32 : i32
    %110 = llvm.add %109, %108 : i32
    %111 = cce.vdups(%26, %102, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %112 = llvm.mul %110, %30 : i32
    %113 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %114 = llvm.sext %112 : i32 to i64
    %115 = llvm.getelementptr %113[%114] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%111, %115, %1, %33, %1, %102) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %116 = llvm.add %103, %23 : i64
    llvm.br ^bb17(%116 : i64)
  ^bb19:  // pred: ^bb17
    %117 = cce.vdups(%27, %102, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %dst, %restElem = cce.plt(%28) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %118 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%117, %118, %1, %33, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb20
  ^bb20:  // pred: ^bb19
    %119 = llvm.add %100, %0 : i32
    llvm.br ^bb15(%119 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb21:  // pred: ^bb15
    %120 = llvm.mul %61, %28 : i32
    %121 = llvm.sext %120 : i32 to i64
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID1>
    %122 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %123 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %124 = llvm.mul %121, %41 : i64
    %125 = llvm.add %123, %124 : i64
    %126 = llvm.inttoptr %125 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%122, %126, %34, %35) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb4(%21 : i64)
  ^bb22(%127: i32):  // 2 preds: ^bb11, ^bb30
    %128 = llvm.icmp "sle" %127, %1 : i32
    llvm.cond_br %128, ^bb23, ^bb31
  ^bb23:  // pred: ^bb22
    %129 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb24(%21 : i64)
  ^bb24(%130: i64):  // 2 preds: ^bb23, ^bb28
    %131 = llvm.icmp "slt" %130, %38 : i64
    llvm.cond_br %131, ^bb25, ^bb29
  ^bb25:  // pred: ^bb24
    llvm.br ^bb26(%21 : i64)
  ^bb26(%132: i64):  // 2 preds: ^bb25, ^bb27
    %133 = llvm.icmp "slt" %132, %18 : i64
    llvm.cond_br %133, ^bb27, ^bb28
  ^bb27:  // pred: ^bb26
    %134 = llvm.mul %132, %25 : i64
    %135 = llvm.mul %130, %20 : i64
    %136 = llvm.add %134, %135 : i64
    %137 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %138 = llvm.mul %136, %50 : i64
    %139 = llvm.getelementptr %137[%138] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %140 = cce.intr.vldsx1.bf16(%139, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %141 = llvm.mul %130, %39 : i64
    %142 = llvm.mul %132, %18 : i64
    %143 = llvm.add %141, %142 : i64
    %144 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %145 = llvm.mul %143, %50 : i64
    %146 = llvm.getelementptr %144[%145] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%140, %146, %37, %1, %129) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %147 = llvm.add %132, %23 : i64
    llvm.br ^bb26(%147 : i64)
  ^bb28:  // pred: ^bb26
    %148 = llvm.add %130, %23 : i64
    llvm.br ^bb24(%148 : i64)
  ^bb29:  // pred: ^bb24
    llvm.br ^bb30
  ^bb30:  // pred: ^bb29
    %149 = llvm.add %127, %0 : i32
    llvm.br ^bb22(%149 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb31:  // pred: ^bb22
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %150 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %151 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%150, %151, %40) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %41
    llvm.br ^bb32(%1 : i32)
  ^bb32(%152: i32):  // 2 preds: ^bb31, ^bb40
    %153 = llvm.icmp "sle" %152, %1 : i32
    llvm.cond_br %153, ^bb33, ^bb41
  ^bb33:  // pred: ^bb32
    %154 = cce.pset(%33) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb34(%21 : i64)
  ^bb34(%155: i64):  // 2 preds: ^bb33, ^bb35
    %156 = llvm.icmp "slt" %155, %44 : i64
    llvm.cond_br %156, ^bb35, ^bb36
  ^bb35:  // pred: ^bb34
    %157 = llvm.trunc %155 : i64 to i32
    %158 = llvm.mul %157, %30 : i32
    %159 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %160 = llvm.sext %158 : i32 to i64
    %161 = llvm.getelementptr %159[%160] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %162 = cce.intr.vldsx1.f32(%161, %1, %42, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %163 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %164 = llvm.sext %158 : i32 to i64
    %165 = llvm.getelementptr %163[%164] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%162, %165, %1, %43, %1, %154) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %166 = llvm.add %155, %23 : i64
    llvm.br ^bb34(%166 : i64)
  ^bb36:  // pred: ^bb34
    %dst_0, %restElem_1 = cce.plt(%45) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb37(%21 : i64)
  ^bb37(%167: i64):  // 2 preds: ^bb36, ^bb38
    %168 = llvm.icmp "slt" %167, %44 : i64
    llvm.cond_br %168, ^bb38, ^bb39
  ^bb38:  // pred: ^bb37
    %169 = llvm.trunc %167 : i64 to i32
    %170 = llvm.mul %169, %31 : i32
    %171 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %172 = llvm.sext %170 : i32 to i64
    %173 = llvm.getelementptr %171[%172] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %174 = cce.intr.vldsx1.f32(%173, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %175 = cce.vmuls(%174, %29, %dst_0) : (vector<64xf32>, f32, vector<256xi1>) -> vector<64xf32>
    %176 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %177 = llvm.sext %170 : i32 to i64
    %178 = llvm.getelementptr %176[%177] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%175, %178, %1, %33, %1, %dst_0) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %179 = cce.vcmax(%175, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %180 = llvm.mul %169, %30 : i32
    %181 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %182 = llvm.sext %180 : i32 to i64
    %183 = llvm.getelementptr %181[%182] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%179, %183, %1, %43, %1, %154) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %184 = llvm.add %167, %23 : i64
    llvm.br ^bb37(%184 : i64)
  ^bb39:  // pred: ^bb37
    llvm.br ^bb40
  ^bb40:  // pred: ^bb39
    %185 = llvm.add %152, %0 : i32
    llvm.br ^bb32(%185 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb41:  // pred: ^bb32
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb42(%1 : i32)
  ^bb42(%186: i32):  // 2 preds: ^bb41, ^bb50
    %187 = llvm.icmp "sle" %186, %1 : i32
    llvm.cond_br %187, ^bb43, ^bb51
  ^bb43:  // pred: ^bb42
    %dst_2, %restElem_3 = cce.plt(%28) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %188 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %189 = cce.intr.vldsx1.f32(%188, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %190 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %191 = cce.intr.vldsx1.f32(%190, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %192 = cce.vmax(%189, %191, %dst_2) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %193 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%192, %193, %1, %33, %1, %dst_2) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %194 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%45) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb44(%21 : i64)
  ^bb44(%195: i64):  // 2 preds: ^bb43, ^bb45
    %196 = llvm.icmp "slt" %195, %44 : i64
    llvm.cond_br %196, ^bb45, ^bb46
  ^bb45:  // pred: ^bb44
    %197 = llvm.trunc %195 : i64 to i32
    %198 = llvm.mul %197, %45 : i32
    %199 = llvm.mul %197, %31 : i32
    %200 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %201 = llvm.sext %199 : i32 to i64
    %202 = llvm.getelementptr %200[%201] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %203 = cce.intr.vldsx1.f32(%202, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %204 = llvm.udiv %198, %45 : i32
    %205 = llvm.urem %204, %28 : i32
    %206 = llvm.mul %205, %30 : i32
    %207 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %208 = llvm.sext %206 : i32 to i64
    %209 = llvm.getelementptr %207[%208] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %210 = cce.intr.vldsx1.f32(%209, %1, %42, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %211 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %212 = llvm.sext %206 : i32 to i64
    %213 = llvm.getelementptr %211[%212] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %214 = cce.intr.vldsx1.f32(%213, %1, %42, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %215 = cce.vmax(%210, %214, %194) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %216 = cce.vsub(%203, %215, %dst_4) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %217 = cce.vexp(%216, %dst_4) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %218 = cce.vcvtff.trunc(%217, %dst_4, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %219 = llvm.mul %197, %28 : i32
    %220 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %221 = llvm.sext %219 : i32 to i64
    %222 = llvm.getelementptr %220[%221] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%218, %222, %1, %46, %1, %dst_4) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %223 = llvm.add %195, %23 : i64
    llvm.br ^bb44(%223 : i64)
  ^bb46:  // pred: ^bb44
    %224 = cce.pset(%33) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb47(%21 : i64)
  ^bb47(%225: i64):  // 2 preds: ^bb46, ^bb48
    %226 = llvm.icmp "slt" %225, %44 : i64
    llvm.cond_br %226, ^bb48, ^bb49
  ^bb48:  // pred: ^bb47
    %227 = llvm.trunc %225 : i64 to i32
    %228 = llvm.mul %227, %45 : i32
    %229 = llvm.mul %227, %31 : i32
    %230 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %231 = llvm.sext %229 : i32 to i64
    %232 = llvm.getelementptr %230[%231] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %233 = cce.intr.vldsx1.f32(%232, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %234 = llvm.udiv %228, %45 : i32
    %235 = llvm.urem %234, %28 : i32
    %236 = llvm.mul %235, %30 : i32
    %237 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %238 = llvm.sext %236 : i32 to i64
    %239 = llvm.getelementptr %237[%238] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %240 = cce.intr.vldsx1.f32(%239, %1, %42, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %241 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %242 = llvm.sext %236 : i32 to i64
    %243 = llvm.getelementptr %241[%242] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %244 = cce.intr.vldsx1.f32(%243, %1, %42, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %245 = cce.vmax(%240, %244, %194) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %246 = cce.vsub(%233, %245, %dst_4) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %247 = cce.vexp(%246, %dst_4) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %248 = cce.vcadd(%247, %dst_4) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %249 = llvm.mul %227, %30 : i32
    %250 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    %251 = llvm.sext %249 : i32 to i64
    %252 = llvm.getelementptr %250[%251] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%248, %252, %1, %43, %1, %224) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %253 = llvm.add %225, %23 : i64
    llvm.br ^bb47(%253 : i64)
  ^bb49:  // pred: ^bb47
    llvm.br ^bb50
  ^bb50:  // pred: ^bb49
    %254 = llvm.add %186, %0 : i32
    llvm.br ^bb42(%254 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb51:  // pred: ^bb42
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    llvm.br ^bb52(%1 : i32)
  ^bb52(%255: i32):  // 2 preds: ^bb51, ^bb54
    %256 = llvm.icmp "sle" %255, %1 : i32
    llvm.cond_br %256, ^bb53, ^bb55
  ^bb53:  // pred: ^bb52
    %257 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %258 = cce.intr.vldsx1.f32(%257, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %259 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %260 = cce.intr.vldsx1.f32(%259, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %261 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %262 = cce.intr.vldsx1.f32(%261, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %263 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    %264 = cce.intr.vldsx1.f32(%263, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %dst_6, %restElem_7 = cce.plt(%28) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %265 = cce.vsub(%258, %260, %dst_6) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %266 = cce.vexp(%265, %dst_6) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %267 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%266, %267, %1, %33, %1, %dst_6) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %268 = cce.vmul(%262, %266, %dst_6) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %269 = cce.vadd(%268, %264, %dst_6) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %270 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%269, %270, %1, %33, %1, %dst_6) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb54
  ^bb54:  // pred: ^bb53
    %271 = llvm.add %255, %0 : i32
    llvm.br ^bb52(%271 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb55:  // pred: ^bb52
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %272 = llvm.mul %59, %53 : i64
    %273 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %274 = llvm.mul %272, %50 : i64
    %275 = llvm.getelementptr %273[%274] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %276 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%275, %276, %47) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %17
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %48
    llvm.br ^bb56(%1 : i32)
  ^bb56(%277: i32):  // 2 preds: ^bb55, ^bb64
    %278 = llvm.icmp "sle" %277, %1 : i32
    llvm.cond_br %278, ^bb57, ^bb65
  ^bb57:  // pred: ^bb56
    %279 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb58(%21 : i64)
  ^bb58(%280: i64):  // 2 preds: ^bb57, ^bb62
    %281 = llvm.icmp "slt" %280, %44 : i64
    llvm.cond_br %281, ^bb59, ^bb63
  ^bb59:  // pred: ^bb58
    %282 = llvm.trunc %280 : i64 to i32
    %283 = llvm.mul %282, %32 : i32
    %284 = llvm.udiv %283, %32 : i32
    %285 = llvm.urem %284, %28 : i32
    %286 = llvm.mul %285, %30 : i32
    %287 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %288 = llvm.sext %286 : i32 to i64
    %289 = llvm.getelementptr %287[%288] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %290 = cce.intr.vldsx1.f32(%289, %1, %42, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    llvm.br ^bb60(%21 : i64)
  ^bb60(%291: i64):  // 2 preds: ^bb59, ^bb61
    %292 = llvm.icmp "slt" %291, %49 : i64
    llvm.cond_br %292, ^bb61, ^bb62
  ^bb61:  // pred: ^bb60
    %293 = llvm.trunc %291 : i64 to i32
    %294 = llvm.mul %293, %31 : i32
    %295 = llvm.add %283, %294 : i32
    %296 = llvm.mul %295, %30 : i32
    %297 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %298 = llvm.sext %296 : i32 to i64
    %299 = llvm.getelementptr %297[%298] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %300 = cce.intr.vldsx1.f32(%299, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %301 = cce.vmul(%300, %290, %279) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %302 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %303 = llvm.sext %296 : i32 to i64
    %304 = llvm.getelementptr %302[%303] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %305 = cce.intr.vldsx1.f32(%304, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %306 = cce.vadd(%301, %305, %279) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %307 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %308 = llvm.sext %296 : i32 to i64
    %309 = llvm.getelementptr %307[%308] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%306, %309, %1, %33, %1, %279) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %310 = llvm.add %291, %23 : i64
    llvm.br ^bb60(%310 : i64)
  ^bb62:  // pred: ^bb60
    %311 = llvm.add %280, %23 : i64
    llvm.br ^bb58(%311 : i64)
  ^bb63:  // pred: ^bb58
    llvm.br ^bb64
  ^bb64:  // pred: ^bb63
    %312 = llvm.add %277, %0 : i32
    llvm.br ^bb56(%312 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb65:  // pred: ^bb56
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %50
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %50
    %313 = llvm.add %80, %23 : i64
    llvm.br ^bb7(%313 : i64)
  ^bb66(%314: i32):  // 2 preds: ^bb12, ^bb74
    %315 = llvm.icmp "sle" %314, %1 : i32
    llvm.cond_br %315, ^bb67, ^bb75
  ^bb67:  // pred: ^bb66
    %316 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb68(%21 : i64)
  ^bb68(%317: i64):  // 2 preds: ^bb67, ^bb72
    %318 = llvm.icmp "slt" %317, %44 : i64
    llvm.cond_br %318, ^bb69, ^bb73
  ^bb69:  // pred: ^bb68
    %319 = llvm.trunc %317 : i64 to i32
    %320 = llvm.mul %319, %32 : i32
    %321 = llvm.udiv %320, %32 : i32
    %322 = llvm.urem %321, %28 : i32
    %323 = llvm.mul %322, %30 : i32
    %324 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %325 = llvm.sext %323 : i32 to i64
    %326 = llvm.getelementptr %324[%325] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %327 = cce.intr.vldsx1.f32(%326, %1, %42, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    llvm.br ^bb70(%21 : i64)
  ^bb70(%328: i64):  // 2 preds: ^bb69, ^bb71
    %329 = llvm.icmp "slt" %328, %49 : i64
    llvm.cond_br %329, ^bb71, ^bb72
  ^bb71:  // pred: ^bb70
    %330 = llvm.trunc %328 : i64 to i32
    %331 = llvm.mul %330, %31 : i32
    %332 = llvm.add %320, %331 : i32
    %333 = llvm.mul %332, %30 : i32
    %334 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %335 = llvm.sext %333 : i32 to i64
    %336 = llvm.getelementptr %334[%335] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %337 = cce.intr.vldsx1.f32(%336, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %338 = cce.vdiv(%337, %327, %316) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %339 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %340 = llvm.sext %333 : i32 to i64
    %341 = llvm.getelementptr %339[%340] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%338, %341, %1, %33, %1, %316) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %342 = llvm.add %328, %23 : i64
    llvm.br ^bb70(%342 : i64)
  ^bb72:  // pred: ^bb70
    %343 = llvm.add %317, %23 : i64
    llvm.br ^bb68(%343 : i64)
  ^bb73:  // pred: ^bb68
    llvm.br ^bb74
  ^bb74:  // pred: ^bb73
    %344 = llvm.add %314, %0 : i32
    llvm.br ^bb66(%344 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb75:  // pred: ^bb66
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %345 = llvm.mul %63, %22 : i32
    %346 = llvm.sext %345 : i32 to i64
    %347 = llvm.add %346, %64 : i64
    %348 = llvm.mul %347, %24 : i64
    %349 = llvm.mul %121, %25 : i64
    %350 = llvm.add %348, %349 : i64
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %351 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %352 = llvm.mul %350, %41 : i64
    %353 = llvm.add %351, %352 : i64
    %354 = llvm.inttoptr %353 : i64 to !llvm.ptr<1>
    %355 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%354, %355, %51, %35) : (<1>, <6>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID2>
    %356 = llvm.add %64, %23 : i64
    llvm.br ^bb2(%356 : i64)
  }
}


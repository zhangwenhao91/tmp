module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  llvm.func @_mlir_ciface_mma_tile_float_to_float.cube(!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) attributes {sym_visibility = "private"}
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(9 : i64) : i64
    %1 = llvm.mlir.constant(11 : i64) : i64
    %2 = llvm.mlir.constant(3 : i64) : i64
    %3 = llvm.mlir.constant(2 : i64) : i64
    %4 = llvm.mlir.constant(4 : i64) : i64
    %5 = llvm.mlir.constant(6 : i64) : i64
    %6 = llvm.mlir.constant(5 : i64) : i64
    %7 = llvm.mlir.constant(10 : i64) : i64
    %8 = llvm.mlir.constant(8796093022272 : i64) : i64
    %9 = llvm.mlir.constant(68723671296 : i64) : i64
    %10 = llvm.mlir.constant(7 : i64) : i64
    %11 = llvm.mlir.constant(8 : i64) : i64
    %12 = llvm.mlir.constant(1 : i64) : i64
    %13 = llvm.mlir.constant(4096 : i64) : i64
    %14 = llvm.mlir.constant(0 : i64) : i64
    %15 = llvm.mlir.constant(196608 : i64) : i64
    %16 = llvm.mlir.constant(294912 : i64) : i64
    %17 = llvm.mlir.constant(65536 : i64) : i64
    %18 = llvm.mlir.constant(311296 : i64) : i64
    %19 = llvm.mlir.constant(140288 : i64) : i64
    %20 = llvm.mlir.constant(144384 : i64) : i64
    %21 = llvm.mlir.constant(60 : i64) : i64
    %22 = llvm.mlir.constant(48 : i64) : i64
    %23 = llvm.mlir.constant(true) : i1
    %24 = llvm.mlir.constant(64 : i64) : i64
    %25 = llvm.mlir.constant(256 : i64) : i64
    %26 = llvm.mlir.constant(16 : i64) : i64
    %27 = llvm.mlir.constant(0 : i8) : i8
    %28 = llvm.mlir.constant(-1 : i64) : i64
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %29 = cce.get.ctrl -> i64
    %30 = cce.sbitset0(%29, %21) : (i64, i64) -> i64
    cce.set.ctrl(%30) : i64
    %31 = cce.get.ctrl -> i64
    %32 = cce.sbitset1(%31, %22) : (i64, i64) -> i64
    cce.set.ctrl(%32) : i64
    %33 = llvm.inttoptr %18 : i64 to !llvm.ptr<2>
    %34 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    %35 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    %36 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    %37 = llvm.inttoptr %14 : i64 to !llvm.ptr<5>
    %38 = llvm.inttoptr %13 : i64 to !llvm.ptr<5>
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %12
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %11
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %10
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %14
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%36, %35, %23, %24, %25, %26, %38, %28, %28, %28, %28, %25, %28, %28, %27) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%12) : i64
    %39 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %40 = llvm.inttoptr %13 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%39, %40, %9, %8) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %7
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %6
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %5
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %4
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %3
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %2
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%34, %33, %23, %24, %25, %26, %37, %28, %28, %28, %28, %25, %28, %28, %27) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%12) : i64
    %41 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %42 = llvm.inttoptr %14 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%41, %42, %9, %8) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %1
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %0
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1ub_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(1 : index) {block_id = 4 : i32} : i64
    %6 = llvm.mlir.constant(0 : index) {block_id = 4 : i32} : i64
    %7 = llvm.mlir.constant(128 : index) {block_id = 4 : i32} : i64
    %8 = llvm.mlir.constant(144384 : i64) : i64
    %9 = llvm.mlir.constant(140288 : i64) : i64
    %10 = llvm.mlir.constant(311296 : i64) : i64
    %11 = llvm.mlir.constant(65536 : i64) : i64
    %12 = llvm.mlir.constant(294912 : i64) : i64
    %13 = llvm.mlir.constant(196608 : i64) : i64
    %14 = llvm.mlir.constant(278528 : i64) : i64
    %15 = llvm.mlir.constant(262144 : i64) : i64
    %16 = llvm.mlir.constant(66560 : i64) : i64
    %17 = llvm.mlir.constant(132096 : i64) : i64
    %18 = llvm.mlir.constant(136192 : i64) : i64
    %19 = llvm.mlir.constant(274877972481 : i64) : i64
    %20 = llvm.mlir.constant(1099511693313 : i64) : i64
    %21 = llvm.mlir.constant(33554448 : i64) : i64
    %22 = llvm.mlir.constant(1 : i64) : i64
    %23 = llvm.mlir.constant(134217744 : i64) : i64
    %24 = llvm.mlir.constant(2 : i64) : i64
    %25 = llvm.mlir.constant(3 : i64) : i64
    %26 = llvm.mlir.constant(4 : i64) : i64
    %27 = llvm.mlir.constant(5 : i64) : i64
    %28 = llvm.mlir.constant(6 : i64) : i64
    %29 = llvm.mlir.constant(131072 : i64) : i64
    %30 = llvm.mlir.constant(4259840 : i32) : i32
    %31 = llvm.mlir.constant(4 : index) : i64
    %32 = llvm.mlir.constant(64 : index) : i64
    %33 = llvm.mlir.constant(256 : index) : i64
    %34 = llvm.mlir.constant(4160 : index) : i64
    %35 = llvm.mlir.constant(8 : index) : i64
    %36 = llvm.mlir.constant(4299162112 : i64) : i64
    %37 = llvm.mlir.constant(7 : i64) : i64
    %38 = llvm.mlir.constant(8 : i64) : i64
    %39 = llvm.mlir.constant(10 : i64) : i64
    %40 = llvm.mlir.constant(2 : i32) : i32
    %41 = llvm.mlir.constant(16 : index) : i64
    %42 = llvm.mlir.constant(256 : i32) : i32
    %43 = llvm.mlir.constant(288230377225455616 : i64) : i64
    %44 = llvm.mlir.constant(35184372088864 : i64) : i64
    %45 = llvm.mlir.constant(11 : i64) : i64
    %46 = llvm.mlir.constant(9 : i64) : i64
    %47 = llvm.mlir.constant(18014398509498368 : i64) : i64
    %48 = llvm.mlir.constant(256 : i64) : i64
    %49 = llvm.mlir.constant(72057594037928960 : i64) : i64
    %50 = llvm.mlir.constant(16 : i64) : i64
    %51 = cce.get.ctrl -> i64
    %52 = cce.sbitset0(%51, %3) : (i64, i64) -> i64
    cce.set.ctrl(%52) : i64
    %53 = cce.get.ctrl -> i64
    %54 = cce.sbitset1(%53, %2) : (i64, i64) -> i64
    cce.set.ctrl(%54) : i64
    %55 = cce.get_sub_block_idx -> i64
    %56 = llvm.icmp "eq" %55, %4 : i64
    llvm.cond_br %56, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.set.mte2.nz.para(%19) : i64
    %57 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %58 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %59 = llvm.inttoptr %58 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%57, %59, %47, %48) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%20) : i64
    %60 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    %61 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %62 = llvm.inttoptr %61 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%60, %62, %49, %50) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.mte2.nz.para(%20) : i64
    %63 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    %64 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %65 = llvm.inttoptr %64 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%63, %65, %49, %50) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %66 = llvm.inttoptr %12 : i64 to !llvm.ptr<2>
    %67 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%66, %67, %21) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %22
    %68 = llvm.inttoptr %11 : i64 to !llvm.ptr<2>
    %69 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%68, %69, %23) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %24
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %70 = llvm.inttoptr %10 : i64 to !llvm.ptr<2>
    %71 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%70, %71, %21) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %25
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %26
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %27
    llvm.br ^bb2(%6 : i64)
  ^bb2(%72: i64):  // 2 preds: ^bb1, ^bb3
    %73 = llvm.icmp "slt" %72, %7 : i64
    llvm.cond_br %73, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    %74 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %75 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%74, %75, %23) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    %76 = llvm.add %72, %5 : i64
    llvm.br ^bb2(%76 : i64)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %28
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb5:  // 2 preds: ^bb0, ^bb29
    llvm.return
  ^bb6(%77: i32):  // 2 preds: ^bb4, ^bb14
    %78 = llvm.icmp "sle" %77, %1 : i32
    llvm.cond_br %78, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %79 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%80: i64):  // 2 preds: ^bb7, ^bb12
    %81 = llvm.icmp "slt" %80, %31 : i64
    llvm.cond_br %81, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%6 : i64)
  ^bb10(%82: i64):  // 2 preds: ^bb9, ^bb11
    %83 = llvm.icmp "slt" %82, %32 : i64
    llvm.cond_br %83, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %84 = llvm.mul %82, %33 : i64
    %85 = llvm.mul %80, %32 : i64
    %86 = llvm.add %84, %85 : i64
    %87 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %88 = llvm.mul %86, %26 : i64
    %89 = llvm.getelementptr %87[%88] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %90 = cce.intr.vldsx1.f32(%89, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %91 = llvm.mul %80, %34 : i64
    %92 = llvm.mul %82, %35 : i64
    %93 = llvm.add %91, %92 : i64
    %94 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %95 = llvm.mul %93, %26 : i64
    %96 = llvm.getelementptr %94[%95] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%90, %96, %30, %1, %79) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
    %97 = llvm.add %82, %5 : i64
    llvm.br ^bb10(%97 : i64)
  ^bb12:  // pred: ^bb10
    %98 = llvm.add %80, %5 : i64
    llvm.br ^bb8(%98 : i64)
  ^bb13:  // pred: ^bb8
    llvm.br ^bb14
  ^bb14:  // pred: ^bb13
    %99 = llvm.add %77, %0 : i32
    llvm.br ^bb6(%99 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb15:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %100 = llvm.inttoptr %29 : i64 to !llvm.ptr<2>
    %101 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%100, %101, %36) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %102 = llvm.inttoptr %13 : i64 to !llvm.ptr<2>
    %103 = llvm.inttoptr %29 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%102, %103, %23) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %37
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %38
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %39
    llvm.br ^bb16(%1 : i32)
  ^bb16(%104: i32):  // 2 preds: ^bb15, ^bb21
    %105 = llvm.icmp "sle" %104, %1 : i32
    llvm.cond_br %105, ^bb17, ^bb22
  ^bb17:  // pred: ^bb16
    %106 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%6 : i64)
  ^bb18(%107: i64):  // 2 preds: ^bb17, ^bb19
    %108 = llvm.icmp "slt" %107, %41 : i64
    llvm.cond_br %108, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %109 = llvm.trunc %107 : i64 to i32
    %110 = llvm.mul %109, %42 : i32
    %111 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %112 = llvm.sext %110 : i32 to i64
    %113 = llvm.getelementptr %111[%112] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %114 = cce.intr.vldsx1.f32(%113, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %115 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %116 = llvm.sext %110 : i32 to i64
    %117 = llvm.getelementptr %115[%116] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%114, %117, %1, %40, %1, %106) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %118 = llvm.add %107, %5 : i64
    llvm.br ^bb18(%118 : i64)
  ^bb20:  // pred: ^bb18
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %119 = llvm.add %104, %0 : i32
    llvm.br ^bb16(%119 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb16
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %120 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %121 = llvm.inttoptr %120 : i64 to !llvm.ptr<1>
    %122 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%121, %122, %43, %44) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %45
    llvm.br ^bb23(%1 : i32)
  ^bb23(%123: i32):  // 2 preds: ^bb22, ^bb28
    %124 = llvm.icmp "sle" %123, %1 : i32
    llvm.cond_br %124, ^bb24, ^bb29
  ^bb24:  // pred: ^bb23
    %125 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb25(%6 : i64)
  ^bb25(%126: i64):  // 2 preds: ^bb24, ^bb26
    %127 = llvm.icmp "slt" %126, %41 : i64
    llvm.cond_br %127, ^bb26, ^bb27
  ^bb26:  // pred: ^bb25
    %128 = llvm.trunc %126 : i64 to i32
    %129 = llvm.mul %128, %42 : i32
    %130 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %131 = llvm.sext %129 : i32 to i64
    %132 = llvm.getelementptr %130[%131] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %133 = cce.intr.vldsx1.f32(%132, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %134 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %135 = llvm.sext %129 : i32 to i64
    %136 = llvm.getelementptr %134[%135] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%133, %136, %1, %40, %1, %125) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %137 = llvm.add %126, %5 : i64
    llvm.br ^bb25(%137 : i64)
  ^bb27:  // pred: ^bb25
    llvm.br ^bb28
  ^bb28:  // pred: ^bb27
    %138 = llvm.add %123, %0 : i32
    llvm.br ^bb23(%138 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb29:  // pred: ^bb23
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %139 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %140 = llvm.inttoptr %139 : i64 to !llvm.ptr<1>
    %141 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%140, %141, %43, %44) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %46
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  }
  llvm.func @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%arg0: !llvm.ptr<2>, %arg1: !llvm.ptr<2>, %arg2: i1, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: !llvm.ptr<5>, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: i8) attributes {cce.mma_tile_wrapper, llvm.bareptr, sym_visibility = "private"} {
    %0 = llvm.mlir.constant(1 : i64) : i64
    %1 = llvm.mlir.poison : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(32 : i64) : i64
    %4 = llvm.mlir.constant(512 : i64) : i64
    %5 = llvm.mlir.constant(4 : i64) : i64
    %6 = llvm.mlir.constant(128 : i64) : i64
    %7 = llvm.mlir.constant(16 : i64) : i64
    %8 = llvm.mlir.constant(8 : i64) : i64
    %9 = llvm.mlir.constant(2 : i64) : i64
    %10 = llvm.mlir.constant(2048 : i64) : i64
    %11 = llvm.mlir.poison : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>
    %12 = llvm.mlir.constant(1024 : i64) : i64
    %13 = llvm.mlir.constant(256 : i64) : i64
    %14 = llvm.ptrtoint %arg0 : !llvm.ptr<2> to i64
    %15 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    %16 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %17 = llvm.insertvalue %15, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %18 = llvm.insertvalue %15, %17[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %19 = llvm.insertvalue %2, %18[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %20 = llvm.insertvalue %3, %19[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %21 = llvm.insertvalue %4, %20[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %22 = llvm.insertvalue %5, %21[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %23 = llvm.insertvalue %6, %22[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %24 = llvm.insertvalue %7, %23[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %25 = llvm.insertvalue %8, %24[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %26 = llvm.insertvalue %8, %25[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %27 = llvm.insertvalue %0, %26[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %27, %16 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %28 = llvm.ptrtoint %arg1 : !llvm.ptr<2> to i64
    %29 = llvm.inttoptr %28 : i64 to !llvm.ptr<2>
    %30 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %31 = llvm.insertvalue %29, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %32 = llvm.insertvalue %29, %31[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %33 = llvm.insertvalue %2, %32[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %34 = llvm.insertvalue %9, %33[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %35 = llvm.insertvalue %10, %34[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %36 = llvm.insertvalue %7, %35[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %37 = llvm.insertvalue %6, %36[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %38 = llvm.insertvalue %7, %37[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %39 = llvm.insertvalue %8, %38[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %40 = llvm.insertvalue %8, %39[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %41 = llvm.insertvalue %0, %40[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %41, %30 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %42 = llvm.ptrtoint %arg6 : !llvm.ptr<5> to i64
    %43 = llvm.inttoptr %42 : i64 to !llvm.ptr<5>
    %44 = llvm.alloca %0 x !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %45 = llvm.insertvalue %43, %11[0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %46 = llvm.insertvalue %43, %45[1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %47 = llvm.insertvalue %2, %46[2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %48 = llvm.insertvalue %0, %47[3, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %49 = llvm.insertvalue %12, %48[4, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %50 = llvm.insertvalue %5, %49[3, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %51 = llvm.insertvalue %13, %50[4, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %52 = llvm.insertvalue %7, %51[3, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %53 = llvm.insertvalue %7, %52[4, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %54 = llvm.insertvalue %7, %53[3, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %55 = llvm.insertvalue %0, %54[4, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %55, %44 {alignment = 8 : i64} : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    llvm.call @_mlir_ciface_mma_tile_float_to_float.cube(%16, %30, %arg2, %arg3, %arg4, %arg5, %44, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14) : (!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    llvm.return
  }
}


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  llvm.func @_mlir_ciface_mma_tile_bfloat16_t_to_float.cube(!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) attributes {sym_visibility = "private"}
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
    %15 = llvm.mlir.constant(98304 : i64) : i64
    %16 = llvm.mlir.constant(147456 : i64) : i64
    %17 = llvm.mlir.constant(32768 : i64) : i64
    %18 = llvm.mlir.constant(155648 : i64) : i64
    %19 = llvm.mlir.constant(74240 : i64) : i64
    %20 = llvm.mlir.constant(78336 : i64) : i64
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
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%36, %35, %23, %24, %25, %26, %38, %28, %28, %28, %28, %25, %28, %28, %27) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
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
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%34, %33, %23, %24, %25, %26, %37, %28, %28, %28, %28, %25, %28, %28, %27) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
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
    %7 = llvm.mlir.constant(16 : index) {block_id = 4 : i32} : i64
    %8 = llvm.mlir.constant(78336 : i64) : i64
    %9 = llvm.mlir.constant(74240 : i64) : i64
    %10 = llvm.mlir.constant(155648 : i64) : i64
    %11 = llvm.mlir.constant(32768 : i64) : i64
    %12 = llvm.mlir.constant(147456 : i64) : i64
    %13 = llvm.mlir.constant(98304 : i64) : i64
    %14 = llvm.mlir.constant(139264 : i64) : i64
    %15 = llvm.mlir.constant(131072 : i64) : i64
    %16 = llvm.mlir.constant(33280 : i64) : i64
    %17 = llvm.mlir.constant(66048 : i64) : i64
    %18 = llvm.mlir.constant(70144 : i64) : i64
    %19 = llvm.mlir.constant(274877972481 : i64) : i64
    %20 = llvm.mlir.constant(1099511693313 : i64) : i64
    %21 = llvm.mlir.constant(16777232 : i64) : i64
    %22 = llvm.mlir.constant(1 : i64) : i64
    %23 = llvm.mlir.constant(67108880 : i64) : i64
    %24 = llvm.mlir.constant(2 : i64) : i64
    %25 = llvm.mlir.constant(3 : i64) : i64
    %26 = llvm.mlir.constant(4 : i64) : i64
    %27 = llvm.mlir.constant(5 : i64) : i64
    %28 = llvm.mlir.constant(6 : i64) : i64
    %29 = llvm.mlir.constant(65536 : i64) : i64
    %30 = llvm.mlir.constant(4259840 : i32) : i32
    %31 = llvm.mlir.constant(2 : index) : i64
    %32 = llvm.mlir.constant(64 : index) : i64
    %33 = llvm.mlir.constant(256 : index) : i64
    %34 = llvm.mlir.constant(128 : index) : i64
    %35 = llvm.mlir.constant(8320 : index) : i64
    %36 = llvm.mlir.constant(4299161856 : i64) : i64
    %37 = llvm.mlir.constant(7 : i64) : i64
    %38 = llvm.mlir.constant(8 : i64) : i64
    %39 = llvm.mlir.constant(10 : i64) : i64
    %40 = llvm.mlir.constant(2 : i32) : i32
    %41 = llvm.mlir.constant(256 : i32) : i32
    %42 = llvm.mlir.constant(288230377225455616 : i64) : i64
    %43 = llvm.mlir.constant(35184372088864 : i64) : i64
    %44 = llvm.mlir.constant(11 : i64) : i64
    %45 = llvm.mlir.constant(9 : i64) : i64
    %46 = llvm.mlir.constant(18014398509490176 : i64) : i64
    %47 = llvm.mlir.constant(256 : i64) : i64
    %48 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %49 = llvm.mlir.constant(16 : i64) : i64
    %50 = cce.get.ctrl -> i64
    %51 = cce.sbitset0(%50, %3) : (i64, i64) -> i64
    cce.set.ctrl(%51) : i64
    %52 = cce.get.ctrl -> i64
    %53 = cce.sbitset1(%52, %2) : (i64, i64) -> i64
    cce.set.ctrl(%53) : i64
    %54 = cce.get_sub_block_idx -> i64
    %55 = llvm.icmp "eq" %54, %4 : i64
    llvm.cond_br %55, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.set.mte2.nz.para(%19) : i64
    %56 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %57 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %58 = llvm.inttoptr %57 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%56, %58, %46, %47) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%20) : i64
    %59 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    %60 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %61 = llvm.inttoptr %60 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%59, %61, %48, %49) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.mte2.nz.para(%20) : i64
    %62 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    %63 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %64 = llvm.inttoptr %63 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%62, %64, %48, %49) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %65 = llvm.inttoptr %12 : i64 to !llvm.ptr<2>
    %66 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%65, %66, %21) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %22
    %67 = llvm.inttoptr %11 : i64 to !llvm.ptr<2>
    %68 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%67, %68, %23) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %24
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %69 = llvm.inttoptr %10 : i64 to !llvm.ptr<2>
    %70 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%69, %70, %21) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %25
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %26
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %27
    llvm.br ^bb2(%6 : i64)
  ^bb2(%71: i64):  // 2 preds: ^bb1, ^bb3
    %72 = llvm.icmp "slt" %71, %7 : i64
    llvm.cond_br %72, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    %73 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %74 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%73, %74, %23) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    %75 = llvm.add %71, %5 : i64
    llvm.br ^bb2(%75 : i64)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %28
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb5:  // 2 preds: ^bb0, ^bb29
    llvm.return
  ^bb6(%76: i32):  // 2 preds: ^bb4, ^bb14
    %77 = llvm.icmp "sle" %76, %1 : i32
    llvm.cond_br %77, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %78 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%79: i64):  // 2 preds: ^bb7, ^bb12
    %80 = llvm.icmp "slt" %79, %31 : i64
    llvm.cond_br %80, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%6 : i64)
  ^bb10(%81: i64):  // 2 preds: ^bb9, ^bb11
    %82 = llvm.icmp "slt" %81, %32 : i64
    llvm.cond_br %82, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %83 = llvm.mul %81, %33 : i64
    %84 = llvm.mul %79, %34 : i64
    %85 = llvm.add %83, %84 : i64
    %86 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %87 = llvm.mul %85, %24 : i64
    %88 = llvm.getelementptr %86[%87] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %89 = cce.intr.vldsx1.bf16(%88, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %90 = llvm.mul %79, %35 : i64
    %91 = llvm.mul %81, %7 : i64
    %92 = llvm.add %90, %91 : i64
    %93 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %94 = llvm.mul %92, %24 : i64
    %95 = llvm.getelementptr %93[%94] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%89, %95, %30, %1, %78) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %96 = llvm.add %81, %5 : i64
    llvm.br ^bb10(%96 : i64)
  ^bb12:  // pred: ^bb10
    %97 = llvm.add %79, %5 : i64
    llvm.br ^bb8(%97 : i64)
  ^bb13:  // pred: ^bb8
    llvm.br ^bb14
  ^bb14:  // pred: ^bb13
    %98 = llvm.add %76, %0 : i32
    llvm.br ^bb6(%98 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb15:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %99 = llvm.inttoptr %29 : i64 to !llvm.ptr<2>
    %100 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%99, %100, %36) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %101 = llvm.inttoptr %13 : i64 to !llvm.ptr<2>
    %102 = llvm.inttoptr %29 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%101, %102, %23) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %37
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %38
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %39
    llvm.br ^bb16(%1 : i32)
  ^bb16(%103: i32):  // 2 preds: ^bb15, ^bb21
    %104 = llvm.icmp "sle" %103, %1 : i32
    llvm.cond_br %104, ^bb17, ^bb22
  ^bb17:  // pred: ^bb16
    %105 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%6 : i64)
  ^bb18(%106: i64):  // 2 preds: ^bb17, ^bb19
    %107 = llvm.icmp "slt" %106, %7 : i64
    llvm.cond_br %107, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %108 = llvm.trunc %106 : i64 to i32
    %109 = llvm.mul %108, %41 : i32
    %110 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %111 = llvm.sext %109 : i32 to i64
    %112 = llvm.getelementptr %110[%111] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %113 = cce.intr.vldsx1.f32(%112, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %114 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %115 = llvm.sext %109 : i32 to i64
    %116 = llvm.getelementptr %114[%115] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%113, %116, %1, %40, %1, %105) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %117 = llvm.add %106, %5 : i64
    llvm.br ^bb18(%117 : i64)
  ^bb20:  // pred: ^bb18
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %118 = llvm.add %103, %0 : i32
    llvm.br ^bb16(%118 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb16
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %119 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %120 = llvm.inttoptr %119 : i64 to !llvm.ptr<1>
    %121 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%120, %121, %42, %43) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %44
    llvm.br ^bb23(%1 : i32)
  ^bb23(%122: i32):  // 2 preds: ^bb22, ^bb28
    %123 = llvm.icmp "sle" %122, %1 : i32
    llvm.cond_br %123, ^bb24, ^bb29
  ^bb24:  // pred: ^bb23
    %124 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb25(%6 : i64)
  ^bb25(%125: i64):  // 2 preds: ^bb24, ^bb26
    %126 = llvm.icmp "slt" %125, %7 : i64
    llvm.cond_br %126, ^bb26, ^bb27
  ^bb26:  // pred: ^bb25
    %127 = llvm.trunc %125 : i64 to i32
    %128 = llvm.mul %127, %41 : i32
    %129 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %130 = llvm.sext %128 : i32 to i64
    %131 = llvm.getelementptr %129[%130] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %132 = cce.intr.vldsx1.f32(%131, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %133 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %134 = llvm.sext %128 : i32 to i64
    %135 = llvm.getelementptr %133[%134] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%132, %135, %1, %40, %1, %124) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %136 = llvm.add %125, %5 : i64
    llvm.br ^bb25(%136 : i64)
  ^bb27:  // pred: ^bb25
    llvm.br ^bb28
  ^bb28:  // pred: ^bb27
    %137 = llvm.add %122, %0 : i32
    llvm.br ^bb23(%137 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb29:  // pred: ^bb23
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %138 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %139 = llvm.inttoptr %138 : i64 to !llvm.ptr<1>
    %140 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%139, %140, %42, %43) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %45
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  }
  llvm.func @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%arg0: !llvm.ptr<2>, %arg1: !llvm.ptr<2>, %arg2: i1, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: !llvm.ptr<5>, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: i8) attributes {cce.mma_tile_wrapper, llvm.bareptr, sym_visibility = "private"} {
    %0 = llvm.mlir.constant(1 : i64) : i64
    %1 = llvm.mlir.poison : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(16 : i64) : i64
    %4 = llvm.mlir.constant(1024 : i64) : i64
    %5 = llvm.mlir.constant(4 : i64) : i64
    %6 = llvm.mlir.constant(256 : i64) : i64
    %7 = llvm.mlir.constant(4096 : i64) : i64
    %8 = llvm.mlir.poison : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>
    %9 = llvm.ptrtoint %arg0 : !llvm.ptr<2> to i64
    %10 = llvm.inttoptr %9 : i64 to !llvm.ptr<2>
    %11 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %12 = llvm.insertvalue %10, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %13 = llvm.insertvalue %10, %12[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %14 = llvm.insertvalue %2, %13[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %15 = llvm.insertvalue %3, %14[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %16 = llvm.insertvalue %4, %15[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %17 = llvm.insertvalue %5, %16[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %18 = llvm.insertvalue %6, %17[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %19 = llvm.insertvalue %3, %18[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %20 = llvm.insertvalue %3, %19[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %21 = llvm.insertvalue %3, %20[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %22 = llvm.insertvalue %0, %21[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %22, %11 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %23 = llvm.ptrtoint %arg1 : !llvm.ptr<2> to i64
    %24 = llvm.inttoptr %23 : i64 to !llvm.ptr<2>
    %25 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %26 = llvm.insertvalue %24, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %27 = llvm.insertvalue %24, %26[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %28 = llvm.insertvalue %2, %27[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %29 = llvm.insertvalue %0, %28[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %30 = llvm.insertvalue %7, %29[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %31 = llvm.insertvalue %3, %30[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %32 = llvm.insertvalue %6, %31[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %33 = llvm.insertvalue %3, %32[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %34 = llvm.insertvalue %3, %33[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %35 = llvm.insertvalue %3, %34[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %36 = llvm.insertvalue %0, %35[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %36, %25 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %37 = llvm.ptrtoint %arg6 : !llvm.ptr<5> to i64
    %38 = llvm.inttoptr %37 : i64 to !llvm.ptr<5>
    %39 = llvm.alloca %0 x !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %40 = llvm.insertvalue %38, %8[0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %41 = llvm.insertvalue %38, %40[1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %42 = llvm.insertvalue %2, %41[2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %43 = llvm.insertvalue %0, %42[3, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %44 = llvm.insertvalue %4, %43[4, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %45 = llvm.insertvalue %5, %44[3, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %46 = llvm.insertvalue %6, %45[4, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %47 = llvm.insertvalue %3, %46[3, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %48 = llvm.insertvalue %3, %47[4, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %49 = llvm.insertvalue %3, %48[3, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %50 = llvm.insertvalue %0, %49[4, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %50, %39 {alignment = 8 : i64} : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    llvm.call @_mlir_ciface_mma_tile_bfloat16_t_to_float.cube(%11, %25, %arg2, %arg3, %arg4, %arg5, %39, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14) : (!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    llvm.return
  }
}


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  llvm.func @_mlir_ciface_mma_tile_float_to_float.cube(!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) attributes {sym_visibility = "private"}
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(9 : i64) : i64
    %1 = llvm.mlir.constant(11 : i64) : i64
    %2 = llvm.mlir.constant(3 : i64) : i64
    %3 = llvm.mlir.constant(2 : i64) : i64
    %4 = llvm.mlir.constant(4 : i64) : i64
    %5 = llvm.mlir.constant(5 : i64) : i64
    %6 = llvm.mlir.constant(6 : i64) : i64
    %7 = llvm.mlir.constant(10 : i64) : i64
    %8 = llvm.mlir.constant(8796093022224 : i64) : i64
    %9 = llvm.mlir.constant(68720525568 : i64) : i64
    %10 = llvm.mlir.constant(7 : i64) : i64
    %11 = llvm.mlir.constant(8 : i64) : i64
    %12 = llvm.mlir.constant(1 : i64) : i64
    %13 = llvm.mlir.constant(1024 : i64) : i64
    %14 = llvm.mlir.constant(0 : i64) : i64
    %15 = llvm.mlir.constant(114688 : i64) : i64
    %16 = llvm.mlir.constant(49152 : i64) : i64
    %17 = llvm.mlir.constant(65536 : i64) : i64
    %18 = llvm.mlir.constant(81920 : i64) : i64
    %19 = llvm.mlir.constant(36864 : i64) : i64
    %20 = llvm.mlir.constant(35840 : i64) : i64
    %21 = llvm.mlir.constant(60 : i64) : i64
    %22 = llvm.mlir.constant(48 : i64) : i64
    %23 = llvm.mlir.constant(true) : i1
    %24 = llvm.mlir.constant(16 : i64) : i64
    %25 = llvm.mlir.constant(256 : i64) : i64
    %26 = llvm.mlir.constant(0 : i8) : i8
    %27 = llvm.mlir.constant(-1 : i64) : i64
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %28 = cce.get.ctrl -> i64
    %29 = cce.sbitset0(%28, %21) : (i64, i64) -> i64
    cce.set.ctrl(%29) : i64
    %30 = cce.get.ctrl -> i64
    %31 = cce.sbitset1(%30, %22) : (i64, i64) -> i64
    cce.set.ctrl(%31) : i64
    %32 = llvm.inttoptr %18 : i64 to !llvm.ptr<2>
    %33 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    %34 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    %35 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    %36 = llvm.inttoptr %14 : i64 to !llvm.ptr<5>
    %37 = llvm.inttoptr %13 : i64 to !llvm.ptr<5>
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %12
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %11
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %10
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %14
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%35, %34, %23, %24, %25, %24, %37, %27, %27, %27, %27, %25, %27, %27, %26) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%12) : i64
    %38 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %39 = llvm.inttoptr %13 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%38, %39, %9, %8) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %7
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %6
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %5
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %4
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %3
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %2
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%33, %32, %23, %24, %25, %24, %36, %27, %27, %27, %27, %25, %27, %27, %26) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%12) : i64
    %40 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %41 = llvm.inttoptr %14 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%40, %41, %9, %8) : (<6>, <5>, i64, i64)
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
    %8 = llvm.mlir.constant(35840 : i64) : i64
    %9 = llvm.mlir.constant(36864 : i64) : i64
    %10 = llvm.mlir.constant(81920 : i64) : i64
    %11 = llvm.mlir.constant(65536 : i64) : i64
    %12 = llvm.mlir.constant(49152 : i64) : i64
    %13 = llvm.mlir.constant(114688 : i64) : i64
    %14 = llvm.mlir.constant(16384 : i64) : i64
    %15 = llvm.mlir.constant(17408 : i64) : i64
    %16 = llvm.mlir.constant(98304 : i64) : i64
    %17 = llvm.mlir.constant(32768 : i64) : i64
    %18 = llvm.mlir.constant(33792 : i64) : i64
    %19 = llvm.mlir.constant(34816 : i64) : i64
    %20 = llvm.mlir.constant(68719542273 : i64) : i64
    %21 = llvm.mlir.constant(1099511693313 : i64) : i64
    %22 = llvm.mlir.constant(33554448 : i64) : i64
    %23 = llvm.mlir.constant(1 : i64) : i64
    %24 = llvm.mlir.constant(2 : i64) : i64
    %25 = llvm.mlir.constant(3 : i64) : i64
    %26 = llvm.mlir.constant(4 : i64) : i64
    %27 = llvm.mlir.constant(5 : i64) : i64
    %28 = llvm.mlir.constant(6 : i64) : i64
    %29 = llvm.mlir.constant(1114112 : i32) : i32
    %30 = llvm.mlir.constant(4 : index) : i64
    %31 = llvm.mlir.constant(16 : index) : i64
    %32 = llvm.mlir.constant(256 : index) : i64
    %33 = llvm.mlir.constant(64 : index) : i64
    %34 = llvm.mlir.constant(1088 : index) : i64
    %35 = llvm.mlir.constant(8 : index) : i64
    %36 = llvm.mlir.constant(4296016384 : i64) : i64
    %37 = llvm.mlir.constant(7 : i64) : i64
    %38 = llvm.mlir.constant(8 : i64) : i64
    %39 = llvm.mlir.constant(11 : i64) : i64
    %40 = llvm.mlir.constant(2 : i32) : i32
    %41 = llvm.mlir.constant(256 : i32) : i32
    %42 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %43 = llvm.mlir.constant(35184372088864 : i64) : i64
    %44 = llvm.mlir.constant(10 : i64) : i64
    %45 = llvm.mlir.constant(9 : i64) : i64
    %46 = llvm.mlir.constant(4503599627386880 : i64) : i64
    %47 = llvm.mlir.constant(256 : i64) : i64
    %48 = llvm.mlir.constant(72057594037928960 : i64) : i64
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
    cce.set.mte2.nz.para(%20) : i64
    %56 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %57 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %58 = llvm.inttoptr %57 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%56, %58, %46, %47) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%21) : i64
    %59 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    %60 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %61 = llvm.inttoptr %60 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%59, %61, %48, %49) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%21) : i64
    %62 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    %63 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %64 = llvm.inttoptr %63 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%62, %64, %48, %49) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %65 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %66 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%65, %66, %22) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %67 = llvm.inttoptr %12 : i64 to !llvm.ptr<2>
    %68 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%67, %68, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %23
    %69 = llvm.inttoptr %11 : i64 to !llvm.ptr<2>
    %70 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%69, %70, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %24
    %71 = llvm.inttoptr %10 : i64 to !llvm.ptr<2>
    %72 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%71, %72, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %25
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %26
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %27
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %28
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%73: i64):  // 2 preds: ^bb1, ^bb15
    %74 = llvm.icmp "slt" %73, %7 : i64
    llvm.cond_br %74, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %75 = llvm.inttoptr %13 : i64 to !llvm.ptr<2>
    %76 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%75, %76, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %37
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %38
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %39
    llvm.br ^bb16(%1 : i32)
  ^bb5:  // 2 preds: ^bb0, ^bb29
    llvm.return
  ^bb6(%77: i32):  // 2 preds: ^bb3, ^bb14
    %78 = llvm.icmp "sle" %77, %1 : i32
    llvm.cond_br %78, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %79 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%80: i64):  // 2 preds: ^bb7, ^bb12
    %81 = llvm.icmp "slt" %80, %30 : i64
    llvm.cond_br %81, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%6 : i64)
  ^bb10(%82: i64):  // 2 preds: ^bb9, ^bb11
    %83 = llvm.icmp "slt" %82, %31 : i64
    llvm.cond_br %83, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %84 = llvm.mul %82, %32 : i64
    %85 = llvm.mul %80, %33 : i64
    %86 = llvm.add %84, %85 : i64
    %87 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %88 = llvm.mul %86, %26 : i64
    %89 = llvm.getelementptr %87[%88] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %90 = cce.intr.vldsx1.f32(%89, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %91 = llvm.mul %80, %34 : i64
    %92 = llvm.mul %82, %35 : i64
    %93 = llvm.add %91, %92 : i64
    %94 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %95 = llvm.mul %93, %26 : i64
    %96 = llvm.getelementptr %94[%95] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%90, %96, %29, %1, %79) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
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
    %100 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    %101 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%100, %101, %36) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    %102 = llvm.add %73, %5 : i64
    llvm.br ^bb2(%102 : i64)
  ^bb16(%103: i32):  // 2 preds: ^bb4, ^bb21
    %104 = llvm.icmp "sle" %103, %1 : i32
    llvm.cond_br %104, ^bb17, ^bb22
  ^bb17:  // pred: ^bb16
    %105 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%6 : i64)
  ^bb18(%106: i64):  // 2 preds: ^bb17, ^bb19
    %107 = llvm.icmp "slt" %106, %30 : i64
    llvm.cond_br %107, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %108 = llvm.trunc %106 : i64 to i32
    %109 = llvm.mul %108, %41 : i32
    %110 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %111 = llvm.sext %109 : i32 to i64
    %112 = llvm.getelementptr %110[%111] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %113 = cce.intr.vldsx1.f32(%112, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %114 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
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
    %121 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
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
    %126 = llvm.icmp "slt" %125, %30 : i64
    llvm.cond_br %126, ^bb26, ^bb27
  ^bb26:  // pred: ^bb25
    %127 = llvm.trunc %125 : i64 to i32
    %128 = llvm.mul %127, %41 : i32
    %129 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %130 = llvm.sext %128 : i32 to i64
    %131 = llvm.getelementptr %129[%130] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %132 = cce.intr.vldsx1.f32(%131, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %133 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
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
    %140 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%139, %140, %42, %43) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %45
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  }
  llvm.func @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%arg0: !llvm.ptr<2>, %arg1: !llvm.ptr<2>, %arg2: i1, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: !llvm.ptr<5>, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: i8) attributes {cce.mma_tile_wrapper, llvm.bareptr, sym_visibility = "private"} {
    %0 = llvm.mlir.constant(1 : i64) : i64
    %1 = llvm.mlir.poison : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(32 : i64) : i64
    %4 = llvm.mlir.constant(128 : i64) : i64
    %5 = llvm.mlir.constant(16 : i64) : i64
    %6 = llvm.mlir.constant(8 : i64) : i64
    %7 = llvm.mlir.constant(2 : i64) : i64
    %8 = llvm.mlir.constant(2048 : i64) : i64
    %9 = llvm.mlir.poison : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>
    %10 = llvm.mlir.constant(256 : i64) : i64
    %11 = llvm.ptrtoint %arg0 : !llvm.ptr<2> to i64
    %12 = llvm.inttoptr %11 : i64 to !llvm.ptr<2>
    %13 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %14 = llvm.insertvalue %12, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %15 = llvm.insertvalue %12, %14[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %16 = llvm.insertvalue %2, %15[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %17 = llvm.insertvalue %3, %16[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %18 = llvm.insertvalue %4, %17[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %19 = llvm.insertvalue %0, %18[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %20 = llvm.insertvalue %4, %19[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %21 = llvm.insertvalue %5, %20[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %22 = llvm.insertvalue %6, %21[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %23 = llvm.insertvalue %6, %22[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %24 = llvm.insertvalue %0, %23[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %24, %13 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %25 = llvm.ptrtoint %arg1 : !llvm.ptr<2> to i64
    %26 = llvm.inttoptr %25 : i64 to !llvm.ptr<2>
    %27 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %28 = llvm.insertvalue %26, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %29 = llvm.insertvalue %26, %28[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %30 = llvm.insertvalue %2, %29[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %31 = llvm.insertvalue %7, %30[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %32 = llvm.insertvalue %8, %31[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %33 = llvm.insertvalue %5, %32[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %34 = llvm.insertvalue %4, %33[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %35 = llvm.insertvalue %5, %34[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %36 = llvm.insertvalue %6, %35[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %37 = llvm.insertvalue %6, %36[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %38 = llvm.insertvalue %0, %37[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %38, %27 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %39 = llvm.ptrtoint %arg6 : !llvm.ptr<5> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<5>
    %41 = llvm.alloca %0 x !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %42 = llvm.insertvalue %40, %9[0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %43 = llvm.insertvalue %40, %42[1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %44 = llvm.insertvalue %2, %43[2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %45 = llvm.insertvalue %0, %44[3, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %46 = llvm.insertvalue %10, %45[4, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %47 = llvm.insertvalue %0, %46[3, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %48 = llvm.insertvalue %10, %47[4, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %49 = llvm.insertvalue %5, %48[3, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %50 = llvm.insertvalue %5, %49[4, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %51 = llvm.insertvalue %5, %50[3, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %52 = llvm.insertvalue %0, %51[4, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %52, %41 {alignment = 8 : i64} : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    llvm.call @_mlir_ciface_mma_tile_float_to_float.cube(%13, %27, %arg2, %arg3, %arg4, %arg5, %41, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14) : (!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    llvm.return
  }
}


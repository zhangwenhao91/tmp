module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  llvm.func @_mlir_ciface_mma_tile_bfloat16_t_to_float.cube(!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) attributes {sym_visibility = "private"}
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(9 : i64) : i64
    %1 = llvm.mlir.constant(11 : i64) : i64
    %2 = llvm.mlir.constant(4 : i64) : i64
    %3 = llvm.mlir.constant(7 : i64) : i64
    %4 = llvm.mlir.constant(8 : i64) : i64
    %5 = llvm.mlir.constant(5 : i64) : i64
    %6 = llvm.mlir.constant(10 : i64) : i64
    %7 = llvm.mlir.constant(8796093022224 : i64) : i64
    %8 = llvm.mlir.constant(68720525568 : i64) : i64
    %9 = llvm.mlir.constant(1 : i64) : i64
    %10 = llvm.mlir.constant(2 : i64) : i64
    %11 = llvm.mlir.constant(6 : i64) : i64
    %12 = llvm.mlir.constant(3 : i64) : i64
    %13 = llvm.mlir.constant(1024 : i64) : i64
    %14 = llvm.mlir.constant(0 : i64) : i64
    %15 = llvm.mlir.constant(24576 : i64) : i64
    %16 = llvm.mlir.constant(32768 : i64) : i64
    %17 = llvm.mlir.constant(57344 : i64) : i64
    %18 = llvm.mlir.constant(40960 : i64) : i64
    %19 = llvm.mlir.constant(19968 : i64) : i64
    %20 = llvm.mlir.constant(18944 : i64) : i64
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
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %10
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %14
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %9
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%35, %34, %23, %24, %25, %24, %37, %27, %27, %27, %27, %25, %27, %27, %26) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%9) : i64
    %38 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %39 = llvm.inttoptr %13 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%38, %39, %8, %7) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %6
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %5
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %4
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %3
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %2
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%33, %32, %23, %24, %25, %24, %36, %27, %27, %27, %27, %25, %27, %27, %26) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%9) : i64
    %40 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %41 = llvm.inttoptr %14 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%40, %41, %8, %7) : (<6>, <5>, i64, i64)
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
    %8 = llvm.mlir.constant(18944 : i64) : i64
    %9 = llvm.mlir.constant(19968 : i64) : i64
    %10 = llvm.mlir.constant(40960 : i64) : i64
    %11 = llvm.mlir.constant(57344 : i64) : i64
    %12 = llvm.mlir.constant(32768 : i64) : i64
    %13 = llvm.mlir.constant(24576 : i64) : i64
    %14 = llvm.mlir.constant(49152 : i64) : i64
    %15 = llvm.mlir.constant(8192 : i64) : i64
    %16 = llvm.mlir.constant(8704 : i64) : i64
    %17 = llvm.mlir.constant(16384 : i64) : i64
    %18 = llvm.mlir.constant(16896 : i64) : i64
    %19 = llvm.mlir.constant(17920 : i64) : i64
    %20 = llvm.mlir.constant(68719542273 : i64) : i64
    %21 = llvm.mlir.constant(1099511693313 : i64) : i64
    %22 = llvm.mlir.constant(16777232 : i64) : i64
    %23 = llvm.mlir.constant(1 : i64) : i64
    %24 = llvm.mlir.constant(2 : i64) : i64
    %25 = llvm.mlir.constant(3 : i64) : i64
    %26 = llvm.mlir.constant(4 : i64) : i64
    %27 = llvm.mlir.constant(5 : i64) : i64
    %28 = llvm.mlir.constant(1114112 : i32) : i32
    %29 = llvm.mlir.constant(2 : index) : i64
    %30 = llvm.mlir.constant(256 : index) : i64
    %31 = llvm.mlir.constant(128 : index) : i64
    %32 = llvm.mlir.constant(2176 : index) : i64
    %33 = llvm.mlir.constant(4296016128 : i64) : i64
    %34 = llvm.mlir.constant(6 : i64) : i64
    %35 = llvm.mlir.constant(7 : i64) : i64
    %36 = llvm.mlir.constant(8 : i64) : i64
    %37 = llvm.mlir.constant(11 : i64) : i64
    %38 = llvm.mlir.constant(2 : i32) : i32
    %39 = llvm.mlir.constant(4 : index) : i64
    %40 = llvm.mlir.constant(256 : i32) : i32
    %41 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %42 = llvm.mlir.constant(35184372088864 : i64) : i64
    %43 = llvm.mlir.constant(10 : i64) : i64
    %44 = llvm.mlir.constant(9 : i64) : i64
    %45 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %46 = llvm.mlir.constant(256 : i64) : i64
    %47 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %48 = llvm.mlir.constant(16 : i64) : i64
    %49 = cce.get.ctrl -> i64
    %50 = cce.sbitset0(%49, %3) : (i64, i64) -> i64
    cce.set.ctrl(%50) : i64
    %51 = cce.get.ctrl -> i64
    %52 = cce.sbitset1(%51, %2) : (i64, i64) -> i64
    cce.set.ctrl(%52) : i64
    %53 = cce.get_sub_block_idx -> i64
    %54 = llvm.icmp "eq" %53, %4 : i64
    llvm.cond_br %54, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.set.mte2.nz.para(%20) : i64
    %55 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %56 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %57 = llvm.inttoptr %56 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%55, %57, %45, %46) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%21) : i64
    %58 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    %59 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %60 = llvm.inttoptr %59 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%58, %60, %47, %48) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%21) : i64
    %61 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    %62 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %63 = llvm.inttoptr %62 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%61, %63, %47, %48) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %64 = llvm.inttoptr %13 : i64 to !llvm.ptr<2>
    %65 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%64, %65, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %66 = llvm.inttoptr %12 : i64 to !llvm.ptr<2>
    %67 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%66, %67, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %23
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %24
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %25
    %68 = llvm.inttoptr %10 : i64 to !llvm.ptr<2>
    %69 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%68, %69, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %26
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %27
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%70: i64):  // 2 preds: ^bb1, ^bb15
    %71 = llvm.icmp "slt" %70, %7 : i64
    llvm.cond_br %71, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %72 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %73 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%72, %73, %22) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %34
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %74 = llvm.inttoptr %11 : i64 to !llvm.ptr<2>
    %75 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%74, %75, %22) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %35
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %36
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %37
    llvm.br ^bb16(%1 : i32)
  ^bb5:  // 2 preds: ^bb0, ^bb29
    llvm.return
  ^bb6(%76: i32):  // 2 preds: ^bb3, ^bb14
    %77 = llvm.icmp "sle" %76, %1 : i32
    llvm.cond_br %77, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %78 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%79: i64):  // 2 preds: ^bb7, ^bb12
    %80 = llvm.icmp "slt" %79, %29 : i64
    llvm.cond_br %80, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%6 : i64)
  ^bb10(%81: i64):  // 2 preds: ^bb9, ^bb11
    %82 = llvm.icmp "slt" %81, %7 : i64
    llvm.cond_br %82, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %83 = llvm.mul %81, %30 : i64
    %84 = llvm.mul %79, %31 : i64
    %85 = llvm.add %83, %84 : i64
    %86 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %87 = llvm.mul %85, %24 : i64
    %88 = llvm.getelementptr %86[%87] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %89 = cce.intr.vldsx1.bf16(%88, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %90 = llvm.mul %79, %32 : i64
    %91 = llvm.mul %81, %7 : i64
    %92 = llvm.add %90, %91 : i64
    %93 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %94 = llvm.mul %92, %24 : i64
    %95 = llvm.getelementptr %93[%94] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%89, %95, %28, %1, %78) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
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
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %99 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    %100 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%99, %100, %33) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    %101 = llvm.add %70, %5 : i64
    llvm.br ^bb2(%101 : i64)
  ^bb16(%102: i32):  // 2 preds: ^bb4, ^bb21
    %103 = llvm.icmp "sle" %102, %1 : i32
    llvm.cond_br %103, ^bb17, ^bb22
  ^bb17:  // pred: ^bb16
    %104 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%6 : i64)
  ^bb18(%105: i64):  // 2 preds: ^bb17, ^bb19
    %106 = llvm.icmp "slt" %105, %39 : i64
    llvm.cond_br %106, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %107 = llvm.trunc %105 : i64 to i32
    %108 = llvm.mul %107, %40 : i32
    %109 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %110 = llvm.sext %108 : i32 to i64
    %111 = llvm.getelementptr %109[%110] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %112 = cce.intr.vldsx1.f32(%111, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %113 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %114 = llvm.sext %108 : i32 to i64
    %115 = llvm.getelementptr %113[%114] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%112, %115, %1, %38, %1, %104) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %116 = llvm.add %105, %5 : i64
    llvm.br ^bb18(%116 : i64)
  ^bb20:  // pred: ^bb18
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %117 = llvm.add %102, %0 : i32
    llvm.br ^bb16(%117 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb16
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %118 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %119 = llvm.inttoptr %118 : i64 to !llvm.ptr<1>
    %120 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%119, %120, %41, %42) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %43
    llvm.br ^bb23(%1 : i32)
  ^bb23(%121: i32):  // 2 preds: ^bb22, ^bb28
    %122 = llvm.icmp "sle" %121, %1 : i32
    llvm.cond_br %122, ^bb24, ^bb29
  ^bb24:  // pred: ^bb23
    %123 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb25(%6 : i64)
  ^bb25(%124: i64):  // 2 preds: ^bb24, ^bb26
    %125 = llvm.icmp "slt" %124, %39 : i64
    llvm.cond_br %125, ^bb26, ^bb27
  ^bb26:  // pred: ^bb25
    %126 = llvm.trunc %124 : i64 to i32
    %127 = llvm.mul %126, %40 : i32
    %128 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %129 = llvm.sext %127 : i32 to i64
    %130 = llvm.getelementptr %128[%129] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %131 = cce.intr.vldsx1.f32(%130, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %132 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %133 = llvm.sext %127 : i32 to i64
    %134 = llvm.getelementptr %132[%133] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%131, %134, %1, %38, %1, %123) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %135 = llvm.add %124, %5 : i64
    llvm.br ^bb25(%135 : i64)
  ^bb27:  // pred: ^bb25
    llvm.br ^bb28
  ^bb28:  // pred: ^bb27
    %136 = llvm.add %121, %0 : i32
    llvm.br ^bb23(%136 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb29:  // pred: ^bb23
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %137 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %138 = llvm.inttoptr %137 : i64 to !llvm.ptr<1>
    %139 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%138, %139, %41, %42) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %44
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  }
  llvm.func @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%arg0: !llvm.ptr<2>, %arg1: !llvm.ptr<2>, %arg2: i1, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: !llvm.ptr<5>, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: i8) attributes {cce.mma_tile_wrapper, llvm.bareptr, sym_visibility = "private"} {
    %0 = llvm.mlir.constant(1 : i64) : i64
    %1 = llvm.mlir.poison : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(16 : i64) : i64
    %4 = llvm.mlir.constant(256 : i64) : i64
    %5 = llvm.mlir.constant(4096 : i64) : i64
    %6 = llvm.mlir.poison : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>
    %7 = llvm.ptrtoint %arg0 : !llvm.ptr<2> to i64
    %8 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %9 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %10 = llvm.insertvalue %8, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %11 = llvm.insertvalue %8, %10[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %12 = llvm.insertvalue %2, %11[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %13 = llvm.insertvalue %3, %12[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %14 = llvm.insertvalue %4, %13[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %15 = llvm.insertvalue %0, %14[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %16 = llvm.insertvalue %4, %15[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %17 = llvm.insertvalue %3, %16[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %18 = llvm.insertvalue %3, %17[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %19 = llvm.insertvalue %3, %18[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %20 = llvm.insertvalue %0, %19[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %20, %9 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %21 = llvm.ptrtoint %arg1 : !llvm.ptr<2> to i64
    %22 = llvm.inttoptr %21 : i64 to !llvm.ptr<2>
    %23 = llvm.alloca %0 x !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %24 = llvm.insertvalue %22, %1[0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %25 = llvm.insertvalue %22, %24[1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %26 = llvm.insertvalue %2, %25[2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %27 = llvm.insertvalue %0, %26[3, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %28 = llvm.insertvalue %5, %27[4, 0] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %29 = llvm.insertvalue %3, %28[3, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %30 = llvm.insertvalue %4, %29[4, 1] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %31 = llvm.insertvalue %3, %30[3, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %32 = llvm.insertvalue %3, %31[4, 2] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %33 = llvm.insertvalue %3, %32[3, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    %34 = llvm.insertvalue %0, %33[4, 3] : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %34, %23 {alignment = 8 : i64} : !llvm.struct<(ptr<2>, ptr<2>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    %35 = llvm.ptrtoint %arg6 : !llvm.ptr<5> to i64
    %36 = llvm.inttoptr %35 : i64 to !llvm.ptr<5>
    %37 = llvm.alloca %0 x !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> {alignment = 8 : i64} : (i64) -> !llvm.ptr
    %38 = llvm.insertvalue %36, %6[0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %39 = llvm.insertvalue %36, %38[1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %40 = llvm.insertvalue %2, %39[2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %41 = llvm.insertvalue %0, %40[3, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %42 = llvm.insertvalue %4, %41[4, 0] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %43 = llvm.insertvalue %0, %42[3, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %44 = llvm.insertvalue %4, %43[4, 1] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %45 = llvm.insertvalue %3, %44[3, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %46 = llvm.insertvalue %3, %45[4, 2] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %47 = llvm.insertvalue %3, %46[3, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    %48 = llvm.insertvalue %0, %47[4, 3] : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)> 
    llvm.store %48, %37 {alignment = 8 : i64} : !llvm.struct<(ptr<5>, ptr<5>, i64, array<4 x i64>, array<4 x i64>)>, !llvm.ptr
    llvm.call @_mlir_ciface_mma_tile_bfloat16_t_to_float.cube(%9, %23, %arg2, %arg3, %arg4, %arg5, %37, %arg7, %arg8, %arg9, %arg10, %arg11, %arg12, %arg13, %arg14) : (!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    llvm.return
  }
}


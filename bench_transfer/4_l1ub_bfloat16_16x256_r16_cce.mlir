module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  llvm.func @_mlir_ciface_mma_tile_bfloat16_t_to_float.cube(!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) attributes {sym_visibility = "private"}
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(16 : index) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = llvm.mlir.constant(11 : i64) : i64
    %4 = llvm.mlir.constant(14 : i64) : i64
    %5 = llvm.mlir.constant(13 : i64) : i64
    %6 = llvm.mlir.constant(8796093022224 : i64) : i64
    %7 = llvm.mlir.constant(68720525568 : i64) : i64
    %8 = llvm.mlir.constant(10 : i64) : i64
    %9 = llvm.mlir.constant(3 : i64) : i64
    %10 = llvm.mlir.constant(8 : i64) : i64
    %11 = llvm.mlir.constant(9 : i64) : i64
    %12 = llvm.mlir.constant(2 : i64) : i64
    %13 = llvm.mlir.constant(12 : i64) : i64
    %14 = llvm.mlir.constant(16777232 : i64) : i64
    %15 = llvm.mlir.constant(6 : i64) : i64
    %16 = llvm.mlir.constant(7 : i64) : i64
    %17 = llvm.mlir.constant(1 : i64) : i64
    %18 = llvm.mlir.constant(4 : i64) : i64
    %19 = llvm.mlir.constant(5 : i64) : i64
    %20 = llvm.mlir.constant(1024 : i64) : i64
    %21 = llvm.mlir.constant(0 : i64) : i64
    %22 = llvm.mlir.constant(73728 : i64) : i64
    %23 = llvm.mlir.constant(57344 : i64) : i64
    %24 = llvm.mlir.constant(24576 : i64) : i64
    %25 = llvm.mlir.constant(32768 : i64) : i64
    %26 = llvm.mlir.constant(40960 : i64) : i64
    %27 = llvm.mlir.constant(17408 : i64) : i64
    %28 = llvm.mlir.constant(35840 : i64) : i64
    %29 = llvm.mlir.constant(36864 : i64) : i64
    %30 = llvm.mlir.constant(60 : i64) : i64
    %31 = llvm.mlir.constant(48 : i64) : i64
    %32 = llvm.mlir.constant(true) : i1
    %33 = llvm.mlir.constant(16 : i64) : i64
    %34 = llvm.mlir.constant(256 : i64) : i64
    %35 = llvm.mlir.constant(0 : i8) : i8
    %36 = llvm.mlir.constant(-1 : i64) : i64
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %37 = cce.get.ctrl -> i64
    %38 = cce.sbitset0(%37, %30) : (i64, i64) -> i64
    cce.set.ctrl(%38) : i64
    %39 = cce.get.ctrl -> i64
    %40 = cce.sbitset1(%39, %31) : (i64, i64) -> i64
    cce.set.ctrl(%40) : i64
    %41 = llvm.inttoptr %26 : i64 to !llvm.ptr<2>
    %42 = llvm.inttoptr %25 : i64 to !llvm.ptr<2>
    %43 = llvm.inttoptr %24 : i64 to !llvm.ptr<2>
    %44 = llvm.inttoptr %23 : i64 to !llvm.ptr<2>
    %45 = llvm.inttoptr %21 : i64 to !llvm.ptr<5>
    %46 = llvm.inttoptr %20 : i64 to !llvm.ptr<5>
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %19
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %18
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %17
    llvm.br ^bb1(%2 : i64)
  ^bb1(%47: i64):  // 2 preds: ^bb0, ^bb2
    %48 = llvm.icmp "slt" %47, %1 : i64
    llvm.cond_br %48, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %16
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %15
    %49 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %50 = llvm.inttoptr %22 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%49, %50, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %13
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %21
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%44, %43, %32, %33, %34, %33, %45, %36, %36, %36, %36, %34, %36, %36, %35) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %12
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %11
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %10
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %9
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_bfloat16_t_to_float.cube_wrapper(%42, %41, %32, %33, %34, %33, %46, %36, %36, %36, %36, %34, %36, %36, %35) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %8
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %8
    %51 = llvm.add %47, %0 : i64
    llvm.br ^bb1(%51 : i64)
  ^bb3:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%17) : i64
    %52 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %53 = llvm.inttoptr %21 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%52, %53, %7, %6) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %5
    cce.set.loop3.para(%17) : i64
    %54 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %55 = llvm.inttoptr %20 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%54, %55, %7, %6) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %4
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %3
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
    %8 = llvm.mlir.constant(36864 : i64) : i64
    %9 = llvm.mlir.constant(35840 : i64) : i64
    %10 = llvm.mlir.constant(17408 : i64) : i64
    %11 = llvm.mlir.constant(40960 : i64) : i64
    %12 = llvm.mlir.constant(65536 : i64) : i64
    %13 = llvm.mlir.constant(32768 : i64) : i64
    %14 = llvm.mlir.constant(24576 : i64) : i64
    %15 = llvm.mlir.constant(57344 : i64) : i64
    %16 = llvm.mlir.constant(49152 : i64) : i64
    %17 = llvm.mlir.constant(8192 : i64) : i64
    %18 = llvm.mlir.constant(25600 : i64) : i64
    %19 = llvm.mlir.constant(16384 : i64) : i64
    %20 = llvm.mlir.constant(33792 : i64) : i64
    %21 = llvm.mlir.constant(34816 : i64) : i64
    %22 = llvm.mlir.constant(68719542273 : i64) : i64
    %23 = llvm.mlir.constant(1099511693313 : i64) : i64
    %24 = llvm.mlir.constant(16777232 : i64) : i64
    %25 = llvm.mlir.constant(1 : i64) : i64
    %26 = llvm.mlir.constant(2 : i64) : i64
    %27 = llvm.mlir.constant(3 : i64) : i64
    %28 = llvm.mlir.constant(4 : i64) : i64
    %29 = llvm.mlir.constant(5 : i64) : i64
    %30 = llvm.mlir.constant(1114112 : i32) : i32
    %31 = llvm.mlir.constant(2 : index) : i64
    %32 = llvm.mlir.constant(256 : index) : i64
    %33 = llvm.mlir.constant(128 : index) : i64
    %34 = llvm.mlir.constant(2176 : index) : i64
    %35 = llvm.mlir.constant(4296016128 : i64) : i64
    %36 = llvm.mlir.constant(6 : i64) : i64
    %37 = llvm.mlir.constant(7 : i64) : i64
    %38 = llvm.mlir.constant(12 : i64) : i64
    %39 = llvm.mlir.constant(2 : i32) : i32
    %40 = llvm.mlir.constant(32 : index) : i64
    %41 = llvm.mlir.constant(256 : i32) : i32
    %42 = llvm.mlir.constant(8704 : i64) : i64
    %43 = llvm.mlir.constant(8 : i64) : i64
    %44 = llvm.mlir.constant(9 : i64) : i64
    %45 = llvm.mlir.constant(10 : i64) : i64
    %46 = llvm.mlir.constant(13 : i64) : i64
    %47 = llvm.mlir.constant(4 : index) : i64
    %48 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %49 = llvm.mlir.constant(35184372088864 : i64) : i64
    %50 = llvm.mlir.constant(14 : i64) : i64
    %51 = llvm.mlir.constant(11 : i64) : i64
    %52 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %53 = llvm.mlir.constant(256 : i64) : i64
    %54 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %55 = llvm.mlir.constant(16 : i64) : i64
    %56 = cce.get.ctrl -> i64
    %57 = cce.sbitset0(%56, %3) : (i64, i64) -> i64
    cce.set.ctrl(%57) : i64
    %58 = cce.get.ctrl -> i64
    %59 = cce.sbitset1(%58, %2) : (i64, i64) -> i64
    cce.set.ctrl(%59) : i64
    %60 = cce.get_sub_block_idx -> i64
    %61 = llvm.icmp "eq" %60, %4 : i64
    llvm.cond_br %61, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.set.mte2.nz.para(%22) : i64
    %62 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %63 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %64 = llvm.inttoptr %63 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%62, %64, %52, %53) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%23) : i64
    %65 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    %66 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %67 = llvm.inttoptr %66 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%65, %67, %54, %55) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.mte2.nz.para(%23) : i64
    %68 = llvm.inttoptr %19 : i64 to !llvm.ptr<2>
    %69 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %70 = llvm.inttoptr %69 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%68, %70, %54, %55) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %71 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    %72 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%71, %72, %24) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %25
    %73 = llvm.inttoptr %13 : i64 to !llvm.ptr<2>
    %74 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%73, %74, %24) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %26
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %75 = llvm.inttoptr %11 : i64 to !llvm.ptr<2>
    %76 = llvm.inttoptr %19 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%75, %76, %24) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %27
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %28
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %29
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%77: i64):  // 2 preds: ^bb1, ^bb32
    %78 = llvm.icmp "slt" %77, %7 : i64
    llvm.cond_br %78, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %79 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %80 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%79, %80, %24) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %46
    llvm.br ^bb33(%1 : i32)
  ^bb5:  // 2 preds: ^bb0, ^bb46
    llvm.return
  ^bb6(%81: i32):  // 2 preds: ^bb3, ^bb14
    %82 = llvm.icmp "sle" %81, %1 : i32
    llvm.cond_br %82, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %83 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%84: i64):  // 2 preds: ^bb7, ^bb12
    %85 = llvm.icmp "slt" %84, %31 : i64
    llvm.cond_br %85, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%6 : i64)
  ^bb10(%86: i64):  // 2 preds: ^bb9, ^bb11
    %87 = llvm.icmp "slt" %86, %7 : i64
    llvm.cond_br %87, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %88 = llvm.mul %86, %32 : i64
    %89 = llvm.mul %84, %33 : i64
    %90 = llvm.add %88, %89 : i64
    %91 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %92 = llvm.mul %90, %26 : i64
    %93 = llvm.getelementptr %91[%92] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %94 = cce.intr.vldsx1.bf16(%93, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %95 = llvm.mul %84, %34 : i64
    %96 = llvm.mul %86, %7 : i64
    %97 = llvm.add %95, %96 : i64
    %98 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %99 = llvm.mul %97, %26 : i64
    %100 = llvm.getelementptr %98[%99] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%94, %100, %30, %1, %83) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %101 = llvm.add %86, %5 : i64
    llvm.br ^bb10(%101 : i64)
  ^bb12:  // pred: ^bb10
    %102 = llvm.add %84, %5 : i64
    llvm.br ^bb8(%102 : i64)
  ^bb13:  // pred: ^bb8
    llvm.br ^bb14
  ^bb14:  // pred: ^bb13
    %103 = llvm.add %81, %0 : i32
    llvm.br ^bb6(%103 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb15:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %104 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    %105 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%104, %105, %35) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %106 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    %107 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%106, %107, %24) : (<2>, <2>, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %36
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %37
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %38
    llvm.br ^bb16(%1 : i32)
  ^bb16(%108: i32):  // 2 preds: ^bb15, ^bb21
    %109 = llvm.icmp "sle" %108, %1 : i32
    llvm.cond_br %109, ^bb17, ^bb22
  ^bb17:  // pred: ^bb16
    %110 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%6 : i64)
  ^bb18(%111: i64):  // 2 preds: ^bb17, ^bb19
    %112 = llvm.icmp "slt" %111, %40 : i64
    llvm.cond_br %112, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %113 = llvm.trunc %111 : i64 to i32
    %114 = llvm.mul %113, %41 : i32
    %115 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %116 = llvm.sext %114 : i32 to i64
    %117 = llvm.getelementptr %115[%116] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %118 = cce.intr.vldsx1.bf16(%117, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %119 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %120 = llvm.sext %114 : i32 to i64
    %121 = llvm.getelementptr %119[%120] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%118, %121, %1, %0, %1, %110) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %122 = llvm.add %111, %5 : i64
    llvm.br ^bb18(%122 : i64)
  ^bb20:  // pred: ^bb18
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %123 = llvm.add %108, %0 : i32
    llvm.br ^bb16(%123 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb16
    llvm.br ^bb23(%1 : i32)
  ^bb23(%124: i32):  // 2 preds: ^bb22, ^bb31
    %125 = llvm.icmp "sle" %124, %1 : i32
    llvm.cond_br %125, ^bb24, ^bb32
  ^bb24:  // pred: ^bb23
    %126 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb25(%6 : i64)
  ^bb25(%127: i64):  // 2 preds: ^bb24, ^bb29
    %128 = llvm.icmp "slt" %127, %31 : i64
    llvm.cond_br %128, ^bb26, ^bb30
  ^bb26:  // pred: ^bb25
    llvm.br ^bb27(%6 : i64)
  ^bb27(%129: i64):  // 2 preds: ^bb26, ^bb28
    %130 = llvm.icmp "slt" %129, %7 : i64
    llvm.cond_br %130, ^bb28, ^bb29
  ^bb28:  // pred: ^bb27
    %131 = llvm.mul %129, %32 : i64
    %132 = llvm.mul %127, %33 : i64
    %133 = llvm.add %131, %132 : i64
    %134 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %135 = llvm.mul %133, %26 : i64
    %136 = llvm.getelementptr %134[%135] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %137 = cce.intr.vldsx1.bf16(%136, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %138 = llvm.mul %127, %34 : i64
    %139 = llvm.mul %129, %7 : i64
    %140 = llvm.add %138, %139 : i64
    %141 = llvm.inttoptr %42 : i64 to !llvm.ptr<6>
    %142 = llvm.mul %140, %26 : i64
    %143 = llvm.getelementptr %141[%142] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%137, %143, %30, %1, %126) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %144 = llvm.add %129, %5 : i64
    llvm.br ^bb27(%144 : i64)
  ^bb29:  // pred: ^bb27
    %145 = llvm.add %127, %5 : i64
    llvm.br ^bb25(%145 : i64)
  ^bb30:  // pred: ^bb25
    llvm.br ^bb31
  ^bb31:  // pred: ^bb30
    %146 = llvm.add %124, %0 : i32
    llvm.br ^bb23(%146 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb32:  // pred: ^bb23
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    %147 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %148 = llvm.inttoptr %42 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%147, %148, %35) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %149 = llvm.inttoptr %12 : i64 to !llvm.ptr<2>
    %150 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%149, %150, %24) : (<2>, <2>, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %43
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %44
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %45
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %45
    %151 = llvm.add %77, %5 : i64
    llvm.br ^bb2(%151 : i64)
  ^bb33(%152: i32):  // 2 preds: ^bb4, ^bb38
    %153 = llvm.icmp "sle" %152, %1 : i32
    llvm.cond_br %153, ^bb34, ^bb39
  ^bb34:  // pred: ^bb33
    %154 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb35(%6 : i64)
  ^bb35(%155: i64):  // 2 preds: ^bb34, ^bb36
    %156 = llvm.icmp "slt" %155, %47 : i64
    llvm.cond_br %156, ^bb36, ^bb37
  ^bb36:  // pred: ^bb35
    %157 = llvm.trunc %155 : i64 to i32
    %158 = llvm.mul %157, %41 : i32
    %159 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %160 = llvm.sext %158 : i32 to i64
    %161 = llvm.getelementptr %159[%160] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %162 = cce.intr.vldsx1.f32(%161, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %163 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %164 = llvm.sext %158 : i32 to i64
    %165 = llvm.getelementptr %163[%164] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%162, %165, %1, %39, %1, %154) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %166 = llvm.add %155, %5 : i64
    llvm.br ^bb35(%166 : i64)
  ^bb37:  // pred: ^bb35
    llvm.br ^bb38
  ^bb38:  // pred: ^bb37
    %167 = llvm.add %152, %0 : i32
    llvm.br ^bb33(%167 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb39:  // pred: ^bb33
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %168 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %169 = llvm.inttoptr %168 : i64 to !llvm.ptr<1>
    %170 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%169, %170, %48, %49) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %50
    llvm.br ^bb40(%1 : i32)
  ^bb40(%171: i32):  // 2 preds: ^bb39, ^bb45
    %172 = llvm.icmp "sle" %171, %1 : i32
    llvm.cond_br %172, ^bb41, ^bb46
  ^bb41:  // pred: ^bb40
    %173 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb42(%6 : i64)
  ^bb42(%174: i64):  // 2 preds: ^bb41, ^bb43
    %175 = llvm.icmp "slt" %174, %47 : i64
    llvm.cond_br %175, ^bb43, ^bb44
  ^bb43:  // pred: ^bb42
    %176 = llvm.trunc %174 : i64 to i32
    %177 = llvm.mul %176, %41 : i32
    %178 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %179 = llvm.sext %177 : i32 to i64
    %180 = llvm.getelementptr %178[%179] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %181 = cce.intr.vldsx1.f32(%180, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %182 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %183 = llvm.sext %177 : i32 to i64
    %184 = llvm.getelementptr %182[%183] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%181, %184, %1, %39, %1, %173) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %185 = llvm.add %174, %5 : i64
    llvm.br ^bb42(%185 : i64)
  ^bb44:  // pred: ^bb42
    llvm.br ^bb45
  ^bb45:  // pred: ^bb44
    %186 = llvm.add %171, %0 : i32
    llvm.br ^bb40(%186 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb46:  // pred: ^bb40
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %187 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %188 = llvm.inttoptr %187 : i64 to !llvm.ptr<1>
    %189 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%188, %189, %48, %49) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %51
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


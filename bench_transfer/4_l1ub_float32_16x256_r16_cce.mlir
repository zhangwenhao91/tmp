module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  llvm.func @_mlir_ciface_mma_tile_float_to_float.cube(!llvm.ptr, !llvm.ptr, i1, i64, i64, i64, !llvm.ptr, i64, i64, i64, i64, i64, i64, i64, i8) attributes {sym_visibility = "private"}
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
    %14 = llvm.mlir.constant(33554448 : i64) : i64
    %15 = llvm.mlir.constant(6 : i64) : i64
    %16 = llvm.mlir.constant(7 : i64) : i64
    %17 = llvm.mlir.constant(1 : i64) : i64
    %18 = llvm.mlir.constant(4 : i64) : i64
    %19 = llvm.mlir.constant(5 : i64) : i64
    %20 = llvm.mlir.constant(1024 : i64) : i64
    %21 = llvm.mlir.constant(0 : i64) : i64
    %22 = llvm.mlir.constant(147456 : i64) : i64
    %23 = llvm.mlir.constant(114688 : i64) : i64
    %24 = llvm.mlir.constant(49152 : i64) : i64
    %25 = llvm.mlir.constant(65536 : i64) : i64
    %26 = llvm.mlir.constant(81920 : i64) : i64
    %27 = llvm.mlir.constant(34816 : i64) : i64
    %28 = llvm.mlir.constant(69632 : i64) : i64
    %29 = llvm.mlir.constant(70656 : i64) : i64
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
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%44, %43, %32, %33, %34, %33, %45, %36, %36, %36, %36, %34, %36, %36, %35) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
    cce.barrier pipe = <PIPE_ALL>
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %12
    cce.wait.intra.blocki.mode pipe = <PIPE_S> syncid = %11
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %10
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %9
    llvm.call @__cce_catlass__mlir_ciface_mma_tile_float_to_float.cube_wrapper(%42, %41, %32, %33, %34, %33, %46, %36, %36, %36, %36, %34, %36, %36, %35) : (!llvm.ptr<2>, !llvm.ptr<2>, i1, i64, i64, i64, !llvm.ptr<5>, i64, i64, i64, i64, i64, i64, i64, i8) -> ()
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
    %8 = llvm.mlir.constant(70656 : i64) : i64
    %9 = llvm.mlir.constant(69632 : i64) : i64
    %10 = llvm.mlir.constant(34816 : i64) : i64
    %11 = llvm.mlir.constant(81920 : i64) : i64
    %12 = llvm.mlir.constant(131072 : i64) : i64
    %13 = llvm.mlir.constant(65536 : i64) : i64
    %14 = llvm.mlir.constant(49152 : i64) : i64
    %15 = llvm.mlir.constant(114688 : i64) : i64
    %16 = llvm.mlir.constant(98304 : i64) : i64
    %17 = llvm.mlir.constant(16384 : i64) : i64
    %18 = llvm.mlir.constant(51200 : i64) : i64
    %19 = llvm.mlir.constant(32768 : i64) : i64
    %20 = llvm.mlir.constant(67584 : i64) : i64
    %21 = llvm.mlir.constant(68608 : i64) : i64
    %22 = llvm.mlir.constant(68719542273 : i64) : i64
    %23 = llvm.mlir.constant(1099511693313 : i64) : i64
    %24 = llvm.mlir.constant(33554448 : i64) : i64
    %25 = llvm.mlir.constant(1 : i64) : i64
    %26 = llvm.mlir.constant(2 : i64) : i64
    %27 = llvm.mlir.constant(3 : i64) : i64
    %28 = llvm.mlir.constant(4 : i64) : i64
    %29 = llvm.mlir.constant(5 : i64) : i64
    %30 = llvm.mlir.constant(1114112 : i32) : i32
    %31 = llvm.mlir.constant(4 : index) : i64
    %32 = llvm.mlir.constant(256 : index) : i64
    %33 = llvm.mlir.constant(64 : index) : i64
    %34 = llvm.mlir.constant(1088 : index) : i64
    %35 = llvm.mlir.constant(8 : index) : i64
    %36 = llvm.mlir.constant(4296016384 : i64) : i64
    %37 = llvm.mlir.constant(6 : i64) : i64
    %38 = llvm.mlir.constant(7 : i64) : i64
    %39 = llvm.mlir.constant(12 : i64) : i64
    %40 = llvm.mlir.constant(2 : i32) : i32
    %41 = llvm.mlir.constant(256 : i32) : i32
    %42 = llvm.mlir.constant(17408 : i64) : i64
    %43 = llvm.mlir.constant(8 : i64) : i64
    %44 = llvm.mlir.constant(9 : i64) : i64
    %45 = llvm.mlir.constant(10 : i64) : i64
    %46 = llvm.mlir.constant(13 : i64) : i64
    %47 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %48 = llvm.mlir.constant(35184372088864 : i64) : i64
    %49 = llvm.mlir.constant(14 : i64) : i64
    %50 = llvm.mlir.constant(11 : i64) : i64
    %51 = llvm.mlir.constant(4503599627386880 : i64) : i64
    %52 = llvm.mlir.constant(256 : i64) : i64
    %53 = llvm.mlir.constant(72057594037928960 : i64) : i64
    %54 = llvm.mlir.constant(16 : i64) : i64
    %55 = cce.get.ctrl -> i64
    %56 = cce.sbitset0(%55, %3) : (i64, i64) -> i64
    cce.set.ctrl(%56) : i64
    %57 = cce.get.ctrl -> i64
    %58 = cce.sbitset1(%57, %2) : (i64, i64) -> i64
    cce.set.ctrl(%58) : i64
    %59 = cce.get_sub_block_idx -> i64
    %60 = llvm.icmp "eq" %59, %4 : i64
    llvm.cond_br %60, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.set.mte2.nz.para(%22) : i64
    %61 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %62 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %63 = llvm.inttoptr %62 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%61, %63, %51, %52) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%23) : i64
    %64 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    %65 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %66 = llvm.inttoptr %65 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%64, %66, %53, %54) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.mte2.nz.para(%23) : i64
    %67 = llvm.inttoptr %19 : i64 to !llvm.ptr<2>
    %68 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %69 = llvm.inttoptr %68 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%67, %69, %53, %54) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %70 = llvm.inttoptr %14 : i64 to !llvm.ptr<2>
    %71 = llvm.inttoptr %17 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%70, %71, %24) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %25
    %72 = llvm.inttoptr %13 : i64 to !llvm.ptr<2>
    %73 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%72, %73, %24) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %26
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %74 = llvm.inttoptr %11 : i64 to !llvm.ptr<2>
    %75 = llvm.inttoptr %19 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%74, %75, %24) : (<2>, <2>, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %27
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %28
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %29
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    llvm.br ^bb2(%6 : i64)
  ^bb2(%76: i64):  // 2 preds: ^bb1, ^bb32
    %77 = llvm.icmp "slt" %76, %7 : i64
    llvm.cond_br %77, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %78 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %79 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%78, %79, %24) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
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
  ^bb6(%80: i32):  // 2 preds: ^bb3, ^bb14
    %81 = llvm.icmp "sle" %80, %1 : i32
    llvm.cond_br %81, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %82 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%6 : i64)
  ^bb8(%83: i64):  // 2 preds: ^bb7, ^bb12
    %84 = llvm.icmp "slt" %83, %31 : i64
    llvm.cond_br %84, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%6 : i64)
  ^bb10(%85: i64):  // 2 preds: ^bb9, ^bb11
    %86 = llvm.icmp "slt" %85, %7 : i64
    llvm.cond_br %86, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %87 = llvm.mul %85, %32 : i64
    %88 = llvm.mul %83, %33 : i64
    %89 = llvm.add %87, %88 : i64
    %90 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %91 = llvm.mul %89, %28 : i64
    %92 = llvm.getelementptr %90[%91] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %93 = cce.intr.vldsx1.f32(%92, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %94 = llvm.mul %83, %34 : i64
    %95 = llvm.mul %85, %35 : i64
    %96 = llvm.add %94, %95 : i64
    %97 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %98 = llvm.mul %96, %28 : i64
    %99 = llvm.getelementptr %97[%98] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%93, %99, %30, %1, %82) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
    %100 = llvm.add %85, %5 : i64
    llvm.br ^bb10(%100 : i64)
  ^bb12:  // pred: ^bb10
    %101 = llvm.add %83, %5 : i64
    llvm.br ^bb8(%101 : i64)
  ^bb13:  // pred: ^bb8
    llvm.br ^bb14
  ^bb14:  // pred: ^bb13
    %102 = llvm.add %80, %0 : i32
    llvm.br ^bb6(%102 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb15:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %103 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    %104 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%103, %104, %36) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %105 = llvm.inttoptr %15 : i64 to !llvm.ptr<2>
    %106 = llvm.inttoptr %16 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%105, %106, %24) : (<2>, <2>, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %37
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %38
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %39
    llvm.br ^bb16(%1 : i32)
  ^bb16(%107: i32):  // 2 preds: ^bb15, ^bb21
    %108 = llvm.icmp "sle" %107, %1 : i32
    llvm.cond_br %108, ^bb17, ^bb22
  ^bb17:  // pred: ^bb16
    %109 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%6 : i64)
  ^bb18(%110: i64):  // 2 preds: ^bb17, ^bb19
    %111 = llvm.icmp "slt" %110, %33 : i64
    llvm.cond_br %111, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %112 = llvm.trunc %110 : i64 to i32
    %113 = llvm.mul %112, %41 : i32
    %114 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %115 = llvm.sext %113 : i32 to i64
    %116 = llvm.getelementptr %114[%115] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %117 = cce.intr.vldsx1.f32(%116, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %118 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %119 = llvm.sext %113 : i32 to i64
    %120 = llvm.getelementptr %118[%119] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%117, %120, %1, %40, %1, %109) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %121 = llvm.add %110, %5 : i64
    llvm.br ^bb18(%121 : i64)
  ^bb20:  // pred: ^bb18
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %122 = llvm.add %107, %0 : i32
    llvm.br ^bb16(%122 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb16
    llvm.br ^bb23(%1 : i32)
  ^bb23(%123: i32):  // 2 preds: ^bb22, ^bb31
    %124 = llvm.icmp "sle" %123, %1 : i32
    llvm.cond_br %124, ^bb24, ^bb32
  ^bb24:  // pred: ^bb23
    %125 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb25(%6 : i64)
  ^bb25(%126: i64):  // 2 preds: ^bb24, ^bb29
    %127 = llvm.icmp "slt" %126, %31 : i64
    llvm.cond_br %127, ^bb26, ^bb30
  ^bb26:  // pred: ^bb25
    llvm.br ^bb27(%6 : i64)
  ^bb27(%128: i64):  // 2 preds: ^bb26, ^bb28
    %129 = llvm.icmp "slt" %128, %7 : i64
    llvm.cond_br %129, ^bb28, ^bb29
  ^bb28:  // pred: ^bb27
    %130 = llvm.mul %128, %32 : i64
    %131 = llvm.mul %126, %33 : i64
    %132 = llvm.add %130, %131 : i64
    %133 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %134 = llvm.mul %132, %28 : i64
    %135 = llvm.getelementptr %133[%134] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %136 = cce.intr.vldsx1.f32(%135, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %137 = llvm.mul %126, %34 : i64
    %138 = llvm.mul %128, %35 : i64
    %139 = llvm.add %137, %138 : i64
    %140 = llvm.inttoptr %42 : i64 to !llvm.ptr<6>
    %141 = llvm.mul %139, %28 : i64
    %142 = llvm.getelementptr %140[%141] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%136, %142, %30, %1, %125) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
    %143 = llvm.add %128, %5 : i64
    llvm.br ^bb27(%143 : i64)
  ^bb29:  // pred: ^bb27
    %144 = llvm.add %126, %5 : i64
    llvm.br ^bb25(%144 : i64)
  ^bb30:  // pred: ^bb25
    llvm.br ^bb31
  ^bb31:  // pred: ^bb30
    %145 = llvm.add %123, %0 : i32
    llvm.br ^bb23(%145 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb32:  // pred: ^bb23
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    %146 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %147 = llvm.inttoptr %42 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%146, %147, %36) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %148 = llvm.inttoptr %12 : i64 to !llvm.ptr<2>
    %149 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.l1.v310(%148, %149, %24) : (<2>, <2>, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %43
    cce.set.intra.blocki.mode pipe = <PIPE_MTE2> syncid = %44
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %45
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %45
    %150 = llvm.add %76, %5 : i64
    llvm.br ^bb2(%150 : i64)
  ^bb33(%151: i32):  // 2 preds: ^bb4, ^bb38
    %152 = llvm.icmp "sle" %151, %1 : i32
    llvm.cond_br %152, ^bb34, ^bb39
  ^bb34:  // pred: ^bb33
    %153 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb35(%6 : i64)
  ^bb35(%154: i64):  // 2 preds: ^bb34, ^bb36
    %155 = llvm.icmp "slt" %154, %31 : i64
    llvm.cond_br %155, ^bb36, ^bb37
  ^bb36:  // pred: ^bb35
    %156 = llvm.trunc %154 : i64 to i32
    %157 = llvm.mul %156, %41 : i32
    %158 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %159 = llvm.sext %157 : i32 to i64
    %160 = llvm.getelementptr %158[%159] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %161 = cce.intr.vldsx1.f32(%160, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %162 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %163 = llvm.sext %157 : i32 to i64
    %164 = llvm.getelementptr %162[%163] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%161, %164, %1, %40, %1, %153) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %165 = llvm.add %154, %5 : i64
    llvm.br ^bb35(%165 : i64)
  ^bb37:  // pred: ^bb35
    llvm.br ^bb38
  ^bb38:  // pred: ^bb37
    %166 = llvm.add %151, %0 : i32
    llvm.br ^bb33(%166 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb39:  // pred: ^bb33
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %167 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %168 = llvm.inttoptr %167 : i64 to !llvm.ptr<1>
    %169 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%168, %169, %47, %48) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %49
    llvm.br ^bb40(%1 : i32)
  ^bb40(%170: i32):  // 2 preds: ^bb39, ^bb45
    %171 = llvm.icmp "sle" %170, %1 : i32
    llvm.cond_br %171, ^bb41, ^bb46
  ^bb41:  // pred: ^bb40
    %172 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb42(%6 : i64)
  ^bb42(%173: i64):  // 2 preds: ^bb41, ^bb43
    %174 = llvm.icmp "slt" %173, %31 : i64
    llvm.cond_br %174, ^bb43, ^bb44
  ^bb43:  // pred: ^bb42
    %175 = llvm.trunc %173 : i64 to i32
    %176 = llvm.mul %175, %41 : i32
    %177 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %178 = llvm.sext %176 : i32 to i64
    %179 = llvm.getelementptr %177[%178] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %180 = cce.intr.vldsx1.f32(%179, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %181 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %182 = llvm.sext %176 : i32 to i64
    %183 = llvm.getelementptr %181[%182] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%180, %183, %1, %40, %1, %172) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %184 = llvm.add %173, %5 : i64
    llvm.br ^bb42(%184 : i64)
  ^bb44:  // pred: ^bb42
    llvm.br ^bb45
  ^bb45:  // pred: ^bb44
    %185 = llvm.add %170, %0 : i32
    llvm.br ^bb40(%185 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb46:  // pred: ^bb40
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %186 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %187 = llvm.inttoptr %186 : i64 to !llvm.ptr<1>
    %188 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%187, %188, %47, %48) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %50
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


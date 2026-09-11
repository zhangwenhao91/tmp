module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @mixCV_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(65536 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(16384 : i64) : i64
    %5 = llvm.mlir.constant(68719542273 : i64) : i64
    %6 = llvm.mlir.constant(549755879425 : i64) : i64
    %7 = llvm.mlir.constant(17596481011712 : i64) : i64
    %8 = llvm.mlir.constant(65537 : i64) : i64
    %9 = llvm.mlir.constant(17626545782784 : i64) : i64
    %10 = llvm.mlir.constant(524296 : i64) : i64
    %11 = llvm.mlir.constant(1 : i64) : i64
    %12 = llvm.mlir.constant(2305843011361701904 : i64) : i64
    %13 = llvm.mlir.constant(549756864512 : i64) : i64
    %14 = llvm.mlir.constant(8796093022224 : i64) : i64
    %15 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %16 = llvm.mlir.constant(128 : i64) : i64
    %17 = llvm.mlir.constant(36028797018972160 : i64) : i64
    %18 = cce.get.ctrl -> i64
    %19 = cce.sbitset0(%18, %1) : (i64, i64) -> i64
    cce.set.ctrl(%19) : i64
    %20 = cce.get.ctrl -> i64
    %21 = cce.sbitset1(%20, %0) : (i64, i64) -> i64
    cce.set.ctrl(%21) : i64
    cce.set.mte2.nz.para(%5) : i64
    %22 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %23 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %24 = llvm.inttoptr %23 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%22, %24, %15, %16) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%6) : i64
    %25 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    %26 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %27 = llvm.inttoptr %26 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%25, %27, %17, %16) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %28 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %29 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.f32(%28, %29, %7, %8, %3) : (<3>, <2>, i64, i64, i64)
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %30 = llvm.inttoptr %3 : i64 to !llvm.ptr<4>
    %31 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.f32(%30, %31, %9, %10, %11) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %32 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %33 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %34 = llvm.inttoptr %3 : i64 to !llvm.ptr<4>
    cce.intr.mad.f322f32(%32, %33, %34, %12) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%11) : i64
    %35 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %36 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%35, %36, %13, %14) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %11
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %3
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @mixCV_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(8192 : i64) : i64
    %6 = llvm.mlir.constant(16384 : i64) : i64
    %7 = llvm.mlir.constant(64 : index) : i64
    %8 = llvm.mlir.constant(2 : index) : i64
    %9 = llvm.mlir.constant(16 : index) : i64
    %10 = llvm.mlir.constant(0 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(128 : index) : i64
    %13 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %14 = llvm.mlir.constant(35184372088864 : i64) : i64
    %15 = llvm.mlir.constant(1 : i64) : i64
    %16 = llvm.mlir.constant(2 : i32) : i32
    %17 = llvm.mlir.constant(4 : i64) : i64
    %18 = cce.get.ctrl -> i64
    %19 = cce.sbitset0(%18, %3) : (i64, i64) -> i64
    cce.set.ctrl(%19) : i64
    %20 = cce.get.ctrl -> i64
    %21 = cce.sbitset1(%20, %2) : (i64, i64) -> i64
    cce.set.ctrl(%21) : i64
    %22 = cce.get_sub_block_idx -> i64
    %23 = llvm.icmp "eq" %22, %4 : i64
    llvm.cond_br %23, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %24 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %25 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %26 = llvm.inttoptr %25 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%24, %26, %13, %14) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb12
    llvm.return
  ^bb3(%27: i32):  // 2 preds: ^bb1, ^bb11
    %28 = llvm.icmp "sle" %27, %1 : i32
    llvm.cond_br %28, ^bb4, ^bb12
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%10 : i64)
  ^bb5(%29: i64):  // 2 preds: ^bb4, ^bb9
    %30 = llvm.icmp "slt" %29, %9 : i64
    llvm.cond_br %30, ^bb6, ^bb10
  ^bb6:  // pred: ^bb5
    llvm.br ^bb7(%10 : i64)
  ^bb7(%31: i64):  // 2 preds: ^bb6, ^bb8
    %32 = llvm.icmp "slt" %31, %8 : i64
    llvm.cond_br %32, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %33 = llvm.mul %29, %12 : i64
    %34 = llvm.mul %31, %7 : i64
    %35 = llvm.add %33, %34 : i64
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %15
    %36 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %37 = llvm.mul %35, %17 : i64
    %38 = llvm.getelementptr %36[%37] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %39 = cce.intr.vldsx1.f32(%38, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %40 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %41 = llvm.mul %35, %17 : i64
    %42 = llvm.getelementptr %40[%41] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %43 = cce.intr.vldsx1.f32(%42, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %44 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %45 = cce.vadd(%39, %43, %44) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %46 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %47 = llvm.mul %35, %17 : i64
    %48 = llvm.getelementptr %46[%47] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%45, %48, %1, %16, %1, %44) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %49 = llvm.add %31, %11 : i64
    llvm.br ^bb7(%49 : i64)
  ^bb9:  // pred: ^bb7
    %50 = llvm.add %29, %11 : i64
    llvm.br ^bb5(%50 : i64)
  ^bb10:  // pred: ^bb5
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %51 = llvm.add %27, %0 : i32
    llvm.br ^bb3(%51 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %52 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %53 = llvm.inttoptr %52 : i64 to !llvm.ptr<1>
    %54 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%53, %54, %13, %14) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


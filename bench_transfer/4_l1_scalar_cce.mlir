module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @l1_scalar_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(24576 : i64) : i64
    %4 = llvm.mlir.constant(8192 : i64) : i64
    %5 = llvm.mlir.constant(16384 : i64) : i64
    %6 = llvm.mlir.constant(1024 : i64) : i64
    %7 = llvm.mlir.constant(256 : index) : i64
    %8 = llvm.mlir.constant(16 : index) : i64
    %9 = llvm.mlir.constant(2 : index) : i64
    %10 = llvm.mlir.constant(0 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(68719542273 : i64) : i64
    %13 = llvm.mlir.constant(1099511693313 : i64) : i64
    %14 = llvm.mlir.constant(17596481011712 : i64) : i64
    %15 = llvm.mlir.constant(65537 : i64) : i64
    %16 = llvm.mlir.constant(1168231104512 : i64) : i64
    %17 = llvm.mlir.constant(65552 : i64) : i64
    %18 = llvm.mlir.constant(1 : i64) : i64
    %19 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %20 = llvm.mlir.constant(68720525568 : i64) : i64
    %21 = llvm.mlir.constant(8796093022224 : i64) : i64
    %22 = llvm.mlir.constant(2 : i64) : i64
    %23 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %24 = llvm.mlir.constant(256 : i64) : i64
    %25 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %26 = llvm.mlir.constant(16 : i64) : i64
    %27 = cce.get.ctrl -> i64
    %28 = cce.sbitset0(%27, %1) : (i64, i64) -> i64
    cce.set.ctrl(%28) : i64
    %29 = cce.get.ctrl -> i64
    %30 = cce.sbitset1(%29, %0) : (i64, i64) -> i64
    cce.set.ctrl(%30) : i64
    cce.set.mte2.nz.para(%12) : i64
    %31 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %32 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %33 = llvm.inttoptr %32 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%31, %33, %23, %24) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%13) : i64
    %34 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %35 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %36 = llvm.inttoptr %35 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%34, %36, %25, %26) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %37 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %38 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %39 = llvm.inttoptr %38 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%37, %39, %25, %26) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%10 : i64)
  ^bb1(%40: i64):  // 2 preds: ^bb0, ^bb14
    %41 = llvm.icmp "slt" %40, %9 : i64
    llvm.cond_br %41, ^bb2, ^bb15
  ^bb2:  // pred: ^bb1
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%10 : i64)
  ^bb3(%42: i64):  // 2 preds: ^bb2, ^bb7
    %43 = llvm.icmp "slt" %42, %8 : i64
    llvm.cond_br %43, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%10 : i64)
  ^bb5(%44: i64):  // 2 preds: ^bb4, ^bb6
    %45 = llvm.icmp "slt" %44, %7 : i64
    llvm.cond_br %45, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %46 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %47 = llvm.mul %42, %24 : i64
    %48 = llvm.add %47, %44 : i64
    %49 = llvm.getelementptr %46[%48] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    %50 = llvm.load %49 : !llvm.ptr<2> -> bf16
    %51 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    %52 = llvm.mul %42, %24 : i64
    %53 = llvm.add %52, %44 : i64
    %54 = llvm.getelementptr %51[%53] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    llvm.store %50, %54 : bf16, !llvm.ptr<2>
    %55 = llvm.add %44, %11 : i64
    llvm.br ^bb5(%55 : i64)
  ^bb7:  // pred: ^bb5
    %56 = llvm.add %42, %11 : i64
    llvm.br ^bb3(%56 : i64)
  ^bb8:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %57 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %58 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%57, %58, %14, %15, %2) : (<3>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    %59 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %60 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%59, %60, %16, %17, %18) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %61 = llvm.inttoptr %2 : i64 to !llvm.ptr<5>
    %62 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %63 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%61, %62, %63, %19) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    llvm.br ^bb9(%10 : i64)
  ^bb9(%64: i64):  // 2 preds: ^bb8, ^bb13
    %65 = llvm.icmp "slt" %64, %8 : i64
    llvm.cond_br %65, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%10 : i64)
  ^bb11(%66: i64):  // 2 preds: ^bb10, ^bb12
    %67 = llvm.icmp "slt" %66, %7 : i64
    llvm.cond_br %67, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %68 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    %69 = llvm.mul %64, %24 : i64
    %70 = llvm.add %69, %66 : i64
    %71 = llvm.getelementptr %68[%70] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    %72 = llvm.load %71 : !llvm.ptr<2> -> bf16
    %73 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %74 = llvm.mul %64, %24 : i64
    %75 = llvm.add %74, %66 : i64
    %76 = llvm.getelementptr %73[%75] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    llvm.store %72, %76 : bf16, !llvm.ptr<2>
    %77 = llvm.add %66, %11 : i64
    llvm.br ^bb11(%77 : i64)
  ^bb13:  // pred: ^bb11
    %78 = llvm.add %64, %11 : i64
    llvm.br ^bb9(%78 : i64)
  ^bb14:  // pred: ^bb9
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %79 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %80 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%79, %80, %14, %15, %2) : (<3>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    %81 = llvm.inttoptr %3 : i64 to !llvm.ptr<4>
    %82 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%81, %82, %16, %17, %18) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %83 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    %84 = llvm.inttoptr %3 : i64 to !llvm.ptr<3>
    %85 = llvm.inttoptr %3 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%83, %84, %85, %19) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %86 = llvm.add %40, %11 : i64
    llvm.br ^bb1(%86 : i64)
  ^bb15:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%18) : i64
    %87 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %88 = llvm.inttoptr %2 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%87, %88, %20, %21) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %18
    cce.set.loop3.para(%18) : i64
    %89 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %90 = llvm.inttoptr %6 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%89, %90, %20, %21) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %22
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %2
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1_scalar_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(1024 : i64) : i64
    %4 = llvm.mlir.constant(1 : i64) : i64
    %5 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %6 = llvm.mlir.constant(35184372088864 : i64) : i64
    %7 = llvm.mlir.constant(2 : i64) : i64
    %8 = cce.get.ctrl -> i64
    %9 = cce.sbitset0(%8, %1) : (i64, i64) -> i64
    cce.set.ctrl(%9) : i64
    %10 = cce.get.ctrl -> i64
    %11 = cce.sbitset1(%10, %0) : (i64, i64) -> i64
    cce.set.ctrl(%11) : i64
    %12 = cce.get_sub_block_idx -> i64
    %13 = llvm.icmp "eq" %12, %2 : i64
    llvm.cond_br %13, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %4
    %14 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %15 = llvm.inttoptr %14 : i64 to !llvm.ptr<1>
    %16 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%15, %16, %5, %6) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %7
    %17 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %18 = llvm.inttoptr %17 : i64 to !llvm.ptr<1>
    %19 = llvm.inttoptr %3 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%18, %19, %5, %6) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %2
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  ^bb2:  // 2 preds: ^bb0, ^bb1
    llvm.return
  }
}


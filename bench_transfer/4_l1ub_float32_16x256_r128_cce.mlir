module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @l1ub_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(16384 : i64) : i64
    %3 = llvm.mlir.constant(0 : i64) : i64
    %4 = llvm.mlir.constant(34816 : i64) : i64
    %5 = llvm.mlir.constant(32768 : i64) : i64
    %6 = llvm.mlir.constant(49152 : i64) : i64
    %7 = llvm.mlir.constant(1024 : i64) : i64
    %8 = llvm.mlir.constant(51200 : i64) : i64
    %9 = llvm.mlir.constant(52224 : i64) : i64
    %10 = llvm.mlir.constant(128 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(68719542273 : i64) : i64
    %14 = llvm.mlir.constant(1099511693313 : i64) : i64
    %15 = llvm.mlir.constant(33554448 : i64) : i64
    %16 = llvm.mlir.constant(6 : i64) : i64
    %17 = llvm.mlir.constant(5 : i64) : i64
    %18 = llvm.mlir.constant(7 : i64) : i64
    %19 = llvm.mlir.constant(1 : i64) : i64
    %20 = llvm.mlir.constant(35188667056128 : i64) : i64
    %21 = llvm.mlir.constant(65537 : i64) : i64
    %22 = llvm.mlir.constant(2267742732288 : i64) : i64
    %23 = llvm.mlir.constant(65552 : i64) : i64
    %24 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %25 = llvm.mlir.constant(8 : i64) : i64
    %26 = llvm.mlir.constant(2 : i64) : i64
    %27 = llvm.mlir.constant(3 : i64) : i64
    %28 = llvm.mlir.constant(11 : i64) : i64
    %29 = llvm.mlir.constant(68720525568 : i64) : i64
    %30 = llvm.mlir.constant(8796093022224 : i64) : i64
    %31 = llvm.mlir.constant(9 : i64) : i64
    %32 = llvm.mlir.constant(10 : i64) : i64
    %33 = llvm.mlir.constant(4 : i64) : i64
    %34 = llvm.mlir.constant(4503599627386880 : i64) : i64
    %35 = llvm.mlir.constant(256 : i64) : i64
    %36 = llvm.mlir.constant(72057594037928960 : i64) : i64
    %37 = llvm.mlir.constant(16 : i64) : i64
    %38 = cce.get.ctrl -> i64
    %39 = cce.sbitset0(%38, %1) : (i64, i64) -> i64
    cce.set.ctrl(%39) : i64
    %40 = cce.get.ctrl -> i64
    %41 = cce.sbitset1(%40, %0) : (i64, i64) -> i64
    cce.set.ctrl(%41) : i64
    cce.set.mte2.nz.para(%13) : i64
    %42 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %43 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %44 = llvm.inttoptr %43 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%42, %44, %34, %35) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%14) : i64
    %45 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %46 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %47 = llvm.inttoptr %46 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%45, %47, %36, %37) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%14) : i64
    %48 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %49 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %50 = llvm.inttoptr %49 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%48, %50, %36, %37) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%11 : i64)
  ^bb1(%51: i64):  // 2 preds: ^bb0, ^bb2
    %52 = llvm.icmp "slt" %51, %10 : i64
    llvm.cond_br %52, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %53 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %54 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%53, %54, %15) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %16
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %17
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %18
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %19
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %55 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %56 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.f32(%55, %56, %20, %21, %3) : (<3>, <2>, i64, i64, i64)
    %57 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %58 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.f32(%57, %58, %22, %23, %19) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %59 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    %60 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %61 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.f322f32(%59, %60, %61, %24) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %3
    %62 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %63 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%62, %63, %15) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %25
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %26
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %64 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %65 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.f32(%64, %65, %20, %21, %3) : (<3>, <2>, i64, i64, i64)
    %66 = llvm.inttoptr %6 : i64 to !llvm.ptr<4>
    %67 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.f32(%66, %67, %22, %23, %19) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %68 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    %69 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %70 = llvm.inttoptr %6 : i64 to !llvm.ptr<4>
    cce.intr.mad.f322f32(%68, %69, %70, %24) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %27
    cce.wait.intra.blocki.mode pipe = <PIPE_MTE1> syncid = %28
    %71 = llvm.add %51, %12 : i64
    llvm.br ^bb1(%71 : i64)
  ^bb3:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%19) : i64
    %72 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %73 = llvm.inttoptr %3 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%72, %73, %29, %30) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %31
    cce.set.loop3.para(%19) : i64
    %74 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %75 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%74, %75, %29, %30) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %32
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %33
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @l1ub_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(16384 : i64) : i64
    %6 = llvm.mlir.constant(34816 : i64) : i64
    %7 = llvm.mlir.constant(51200 : i64) : i64
    %8 = llvm.mlir.constant(52224 : i64) : i64
    %9 = llvm.mlir.constant(17408 : i64) : i64
    %10 = llvm.mlir.constant(128 : index) : i64
    %11 = llvm.mlir.constant(0 : index) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(7 : i64) : i64
    %14 = llvm.mlir.constant(1114112 : i32) : i32
    %15 = llvm.mlir.constant(4 : index) : i64
    %16 = llvm.mlir.constant(16 : index) : i64
    %17 = llvm.mlir.constant(256 : index) : i64
    %18 = llvm.mlir.constant(64 : index) : i64
    %19 = llvm.mlir.constant(1088 : index) : i64
    %20 = llvm.mlir.constant(8 : index) : i64
    %21 = llvm.mlir.constant(4296016384 : i64) : i64
    %22 = llvm.mlir.constant(1 : i64) : i64
    %23 = llvm.mlir.constant(8 : i64) : i64
    %24 = llvm.mlir.constant(5 : i64) : i64
    %25 = llvm.mlir.constant(6 : i64) : i64
    %26 = llvm.mlir.constant(2 : i64) : i64
    %27 = llvm.mlir.constant(3 : i64) : i64
    %28 = llvm.mlir.constant(11 : i64) : i64
    %29 = llvm.mlir.constant(9 : i64) : i64
    %30 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %31 = llvm.mlir.constant(35184372088864 : i64) : i64
    %32 = llvm.mlir.constant(10 : i64) : i64
    %33 = llvm.mlir.constant(4 : i64) : i64
    %34 = cce.get.ctrl -> i64
    %35 = cce.sbitset0(%34, %3) : (i64, i64) -> i64
    cce.set.ctrl(%35) : i64
    %36 = cce.get.ctrl -> i64
    %37 = cce.sbitset1(%36, %2) : (i64, i64) -> i64
    cce.set.ctrl(%37) : i64
    %38 = cce.get_sub_block_idx -> i64
    %39 = llvm.icmp "eq" %38, %4 : i64
    llvm.cond_br %39, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb2(%11 : i64)
  ^bb2(%40: i64):  // 2 preds: ^bb1, ^bb25
    %41 = llvm.icmp "slt" %40, %10 : i64
    llvm.cond_br %41, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %13
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb6(%1 : i32)
  ^bb4:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %29
    %42 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %43 = llvm.inttoptr %42 : i64 to !llvm.ptr<1>
    %44 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%43, %44, %30, %31) : (<1>, <6>, i64, i64)
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %32
    %45 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %46 = llvm.inttoptr %45 : i64 to !llvm.ptr<1>
    %47 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%46, %47, %30, %31) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %33
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  ^bb5:  // 2 preds: ^bb0, ^bb4
    llvm.return
  ^bb6(%48: i32):  // 2 preds: ^bb3, ^bb14
    %49 = llvm.icmp "sle" %48, %1 : i32
    llvm.cond_br %49, ^bb7, ^bb15
  ^bb7:  // pred: ^bb6
    %50 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%11 : i64)
  ^bb8(%51: i64):  // 2 preds: ^bb7, ^bb12
    %52 = llvm.icmp "slt" %51, %15 : i64
    llvm.cond_br %52, ^bb9, ^bb13
  ^bb9:  // pred: ^bb8
    llvm.br ^bb10(%11 : i64)
  ^bb10(%53: i64):  // 2 preds: ^bb9, ^bb11
    %54 = llvm.icmp "slt" %53, %16 : i64
    llvm.cond_br %54, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %55 = llvm.mul %53, %17 : i64
    %56 = llvm.mul %51, %18 : i64
    %57 = llvm.add %55, %56 : i64
    %58 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %59 = llvm.mul %57, %33 : i64
    %60 = llvm.getelementptr %58[%59] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %61 = cce.intr.vldsx1.f32(%60, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %62 = llvm.mul %51, %19 : i64
    %63 = llvm.mul %53, %20 : i64
    %64 = llvm.add %62, %63 : i64
    %65 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %66 = llvm.mul %64, %33 : i64
    %67 = llvm.getelementptr %65[%66] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%61, %67, %14, %1, %50) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
    %68 = llvm.add %53, %12 : i64
    llvm.br ^bb10(%68 : i64)
  ^bb12:  // pred: ^bb10
    %69 = llvm.add %51, %12 : i64
    llvm.br ^bb8(%69 : i64)
  ^bb13:  // pred: ^bb8
    llvm.br ^bb14
  ^bb14:  // pred: ^bb13
    %70 = llvm.add %48, %0 : i32
    llvm.br ^bb6(%70 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb15:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %71 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %72 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%71, %72, %21) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %22
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %23
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb16(%1 : i32)
  ^bb16(%73: i32):  // 2 preds: ^bb15, ^bb24
    %74 = llvm.icmp "sle" %73, %1 : i32
    llvm.cond_br %74, ^bb17, ^bb25
  ^bb17:  // pred: ^bb16
    %75 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%11 : i64)
  ^bb18(%76: i64):  // 2 preds: ^bb17, ^bb22
    %77 = llvm.icmp "slt" %76, %15 : i64
    llvm.cond_br %77, ^bb19, ^bb23
  ^bb19:  // pred: ^bb18
    llvm.br ^bb20(%11 : i64)
  ^bb20(%78: i64):  // 2 preds: ^bb19, ^bb21
    %79 = llvm.icmp "slt" %78, %16 : i64
    llvm.cond_br %79, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %80 = llvm.mul %78, %17 : i64
    %81 = llvm.mul %76, %18 : i64
    %82 = llvm.add %80, %81 : i64
    %83 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %84 = llvm.mul %82, %33 : i64
    %85 = llvm.getelementptr %83[%84] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %86 = cce.intr.vldsx1.f32(%85, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %87 = llvm.mul %76, %19 : i64
    %88 = llvm.mul %78, %20 : i64
    %89 = llvm.add %87, %88 : i64
    %90 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %91 = llvm.mul %89, %33 : i64
    %92 = llvm.getelementptr %90[%91] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.f32(%86, %92, %14, %1, %75) : (vector<64xf32>, <6>, i32, i32, vector<256xi1>)
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
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %24
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %25
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %96 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %97 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.l1.v310(%96, %97, %21) : (<2>, <6>, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %26
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %27
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %28
    %98 = llvm.add %40, %12 : i64
    llvm.br ^bb2(%98 : i64)
  }
}


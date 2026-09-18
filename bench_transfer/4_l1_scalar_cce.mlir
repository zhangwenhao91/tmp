module attributes {cce.target = "dav-351x"} {
  llvm.func @l1_scalar_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(2 : index) : i64
    %3 = llvm.mlir.constant(16 : index) : i64
    %4 = llvm.mlir.constant(256 : index) : i64
    %5 = llvm.mlir.constant(60 : i64) : i64
    %6 = llvm.mlir.constant(48 : i64) : i64
    %7 = llvm.mlir.constant(0 : i64) : i64
    %8 = llvm.mlir.constant(24576 : i64) : i64
    %9 = llvm.mlir.constant(8192 : i64) : i64
    %10 = llvm.mlir.constant(16384 : i64) : i64
    %11 = llvm.mlir.constant(1024 : i64) : i64
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
    %22 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %23 = llvm.mlir.constant(35184372088864 : i64) : i64
    %24 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %25 = llvm.mlir.constant(256 : i64) : i64
    %26 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %27 = llvm.mlir.constant(16 : i64) : i64
    %28 = cce.get.ctrl -> i64
    %29 = cce.sbitset0(%28, %5) : (i64, i64) -> i64
    cce.set.ctrl(%29) : i64
    %30 = cce.get.ctrl -> i64
    %31 = cce.sbitset1(%30, %6) : (i64, i64) -> i64
    cce.set.ctrl(%31) : i64
    cce.set.mte2.nz.para(%12) : i64
    %32 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %33 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %34 = llvm.inttoptr %33 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%32, %34, %24, %25) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%13) : i64
    %35 = llvm.inttoptr %9 : i64 to !llvm.ptr<2>
    %36 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %37 = llvm.inttoptr %36 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%35, %37, %26, %27) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %38 = llvm.inttoptr %10 : i64 to !llvm.ptr<2>
    %39 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%38, %40, %26, %27) : (<2>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    llvm.br ^bb1(%1 : i64)
  ^bb1(%41: i64):  // 2 preds: ^bb0, ^bb14
    %42 = llvm.icmp "slt" %41, %2 : i64
    llvm.cond_br %42, ^bb2, ^bb15
  ^bb2:  // pred: ^bb1
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i64)
  ^bb3(%43: i64):  // 2 preds: ^bb2, ^bb7
    %44 = llvm.icmp "slt" %43, %3 : i64
    llvm.cond_br %44, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%1 : i64)
  ^bb5(%45: i64):  // 2 preds: ^bb4, ^bb6
    %46 = llvm.icmp "slt" %45, %4 : i64
    llvm.cond_br %46, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %47 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %48 = llvm.mul %43, %25 : i64
    %49 = llvm.add %48, %45 : i64
    %50 = llvm.getelementptr %47[%49] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    %51 = llvm.load %50 : !llvm.ptr<2> -> bf16
    %52 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    %53 = llvm.mul %43, %25 : i64
    %54 = llvm.add %53, %45 : i64
    %55 = llvm.getelementptr %52[%54] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    llvm.store %51, %55 : bf16, !llvm.ptr<2>
    %56 = llvm.add %45, %0 : i64
    llvm.br ^bb5(%56 : i64)
  ^bb7:  // pred: ^bb5
    %57 = llvm.add %43, %0 : i64
    llvm.br ^bb3(%57 : i64)
  ^bb8:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    %58 = llvm.inttoptr %7 : i64 to !llvm.ptr<3>
    %59 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%58, %59, %14, %15, %7) : (<3>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    %60 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    %61 = llvm.inttoptr %9 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%60, %61, %16, %17, %18) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %62 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    %63 = llvm.inttoptr %7 : i64 to !llvm.ptr<3>
    %64 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%62, %63, %64, %19) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    llvm.br ^bb9(%1 : i64)
  ^bb9(%65: i64):  // 2 preds: ^bb8, ^bb13
    %66 = llvm.icmp "slt" %65, %3 : i64
    llvm.cond_br %66, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%1 : i64)
  ^bb11(%67: i64):  // 2 preds: ^bb10, ^bb12
    %68 = llvm.icmp "slt" %67, %4 : i64
    llvm.cond_br %68, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %69 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    %70 = llvm.mul %65, %25 : i64
    %71 = llvm.add %70, %67 : i64
    %72 = llvm.getelementptr %69[%71] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    %73 = llvm.load %72 : !llvm.ptr<2> -> bf16
    %74 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %75 = llvm.mul %65, %25 : i64
    %76 = llvm.add %75, %67 : i64
    %77 = llvm.getelementptr %74[%76] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, bf16
    llvm.store %73, %77 : bf16, !llvm.ptr<2>
    %78 = llvm.add %67, %0 : i64
    llvm.br ^bb11(%78 : i64)
  ^bb13:  // pred: ^bb11
    %79 = llvm.add %65, %0 : i64
    llvm.br ^bb9(%79 : i64)
  ^bb14:  // pred: ^bb9
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %80 = llvm.inttoptr %9 : i64 to !llvm.ptr<3>
    %81 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%80, %81, %14, %15, %7) : (<3>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    %82 = llvm.inttoptr %9 : i64 to !llvm.ptr<4>
    %83 = llvm.inttoptr %10 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%82, %83, %16, %17, %18) : (<4>, <2>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    %84 = llvm.inttoptr %11 : i64 to !llvm.ptr<5>
    %85 = llvm.inttoptr %9 : i64 to !llvm.ptr<3>
    %86 = llvm.inttoptr %9 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%84, %85, %86, %19) : (<5>, <3>, <4>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    %87 = llvm.add %41, %0 : i64
    llvm.br ^bb1(%87 : i64)
  ^bb15:  // pred: ^bb1
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%18) : i64
    %88 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %89 = llvm.inttoptr %7 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%88, %89, %20, %21) : (<6>, <5>, i64, i64)
    cce.set_flag pipe = <PIPE_FIX> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %90 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %91 = llvm.inttoptr %90 : i64 to !llvm.ptr<1>
    %92 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%91, %92, %22, %23) : (<1>, <6>, i64, i64)
    cce.set.loop3.para(%18) : i64
    %93 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %94 = llvm.inttoptr %11 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%93, %94, %20, %21) : (<6>, <5>, i64, i64)
    cce.set_flag pipe = <PIPE_FIX> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_FIX> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %95 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %96 = llvm.inttoptr %95 : i64 to !llvm.ptr<1>
    %97 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%96, %97, %22, %23) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
}


module attributes {cce.target = "dav-351x"} {
  llvm.func @l1ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(16 : index) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(48 : i64) : i64
    %5 = llvm.mlir.constant(0 : i64) : i64
    %6 = llvm.mlir.constant(32768 : i64) : i64
    %7 = llvm.mlir.constant(65536 : i64) : i64
    %8 = llvm.mlir.constant(73728 : i64) : i64
    %9 = llvm.mlir.constant(4096 : i64) : i64
    %10 = llvm.mlir.constant(36864 : i64) : i64
    %11 = llvm.mlir.constant(274877972481 : i64) : i64
    %12 = llvm.mlir.constant(8192 : i64) : i64
    %13 = llvm.mlir.constant(1099511693313 : i64) : i64
    %14 = llvm.mlir.constant(67108880 : i64) : i64
    %15 = llvm.mlir.constant(64424576000 : i64) : i64
    %16 = llvm.mlir.constant(17609365913600 : i64) : i64
    %17 = llvm.mlir.constant(262148 : i64) : i64
    %18 = llvm.mlir.constant(1168231104512 : i64) : i64
    %19 = llvm.mlir.constant(65552 : i64) : i64
    %20 = llvm.mlir.constant(1 : i64) : i64
    %21 = llvm.mlir.constant(-6917529027371597760 : i64) : i64
    %22 = llvm.mlir.constant(68723671296 : i64) : i64
    %23 = llvm.mlir.constant(8796093022272 : i64) : i64
    %24 = llvm.mlir.constant(288230377225455616 : i64) : i64
    %25 = llvm.mlir.constant(35184372088864 : i64) : i64
    %26 = llvm.mlir.constant(18014398509490176 : i64) : i64
    %27 = llvm.mlir.constant(256 : i64) : i64
    %28 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %29 = llvm.mlir.constant(16 : i64) : i64
    %30 = llvm.mlir.constant(1024 : index) : i64
    %31 = llvm.mlir.constant(2 : i64) : i64
    %32 = cce.get.ctrl -> i64
    %33 = cce.sbitset0(%32, %3) : (i64, i64) -> i64
    cce.set.ctrl(%33) : i64
    %34 = cce.get.ctrl -> i64
    %35 = cce.sbitset1(%34, %4) : (i64, i64) -> i64
    cce.set.ctrl(%35) : i64
    cce.set.mte2.nz.para(%11) : i64
    %36 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %37 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %38 = llvm.inttoptr %37 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%36, %38, %26, %27) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %39 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %40 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %41 = llvm.inttoptr %40 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%39, %41, %28, %29) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %42 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    %43 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %44 = llvm.inttoptr %43 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%42, %44, %28, %29) : (<2>, <1>, i64, i64)
    llvm.br ^bb1(%1 : i64)
  ^bb1(%45: i64):  // 2 preds: ^bb0, ^bb8
    %46 = llvm.icmp "slt" %45, %2 : i64
    llvm.cond_br %46, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    %47 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %48 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%47, %48, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    llvm.br ^bb3(%1 : i64)
  ^bb3(%49: i64):  // 2 preds: ^bb2, ^bb4
    %50 = llvm.icmp "slt" %49, %2 : i64
    llvm.cond_br %50, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %51 = llvm.mul %49, %2 : i64
    %52 = llvm.mul %49, %30 : i64
    %53 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %54 = llvm.mul %52, %31 : i64
    %55 = llvm.getelementptr %53[%54] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %56 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %57 = llvm.mul %51, %31 : i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%55, %58, %15) : (<2>, <6>, i64)
    %59 = llvm.add %49, %0 : i64
    llvm.br ^bb3(%59 : i64)
  ^bb5:  // pred: ^bb3
    %60 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %61 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%60, %61, %16, %17, %5) : (<3>, <2>, i64, i64, i64)
    %62 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %63 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%62, %63, %18, %19, %20) : (<4>, <2>, i64, i64, i64)
    %64 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %65 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %66 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%64, %65, %66, %21) : (<5>, <3>, <4>, i64)
    %67 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %68 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%67, %68, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    llvm.br ^bb6(%1 : i64)
  ^bb6(%69: i64):  // 2 preds: ^bb5, ^bb7
    %70 = llvm.icmp "slt" %69, %2 : i64
    llvm.cond_br %70, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %71 = llvm.mul %69, %2 : i64
    %72 = llvm.mul %69, %30 : i64
    %73 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %74 = llvm.mul %72, %31 : i64
    %75 = llvm.getelementptr %73[%74] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %76 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %77 = llvm.mul %71, %31 : i64
    %78 = llvm.getelementptr %76[%77] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%75, %78, %15) : (<2>, <6>, i64)
    %79 = llvm.add %69, %0 : i64
    llvm.br ^bb6(%79 : i64)
  ^bb8:  // pred: ^bb6
    %80 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %81 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%80, %81, %16, %17, %5) : (<3>, <2>, i64, i64, i64)
    %82 = llvm.inttoptr %12 : i64 to !llvm.ptr<4>
    %83 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%82, %83, %18, %19, %20) : (<4>, <2>, i64, i64, i64)
    %84 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    %85 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %86 = llvm.inttoptr %12 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%84, %85, %86, %21) : (<5>, <3>, <4>, i64)
    %87 = llvm.add %45, %0 : i64
    llvm.br ^bb1(%87 : i64)
  ^bb9:  // pred: ^bb1
    cce.set.loop3.para(%20) : i64
    %88 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %89 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%88, %89, %22, %23) : (<6>, <5>, i64, i64)
    %90 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %91 = llvm.inttoptr %90 : i64 to !llvm.ptr<1>
    %92 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%91, %92, %24, %25) : (<1>, <6>, i64, i64)
    cce.set.loop3.para(%20) : i64
    %93 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %94 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%93, %94, %22, %23) : (<6>, <5>, i64, i64)
    %95 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %96 = llvm.inttoptr %95 : i64 to !llvm.ptr<1>
    %97 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%96, %97, %24, %25) : (<1>, <6>, i64, i64)
    llvm.return
  }
}


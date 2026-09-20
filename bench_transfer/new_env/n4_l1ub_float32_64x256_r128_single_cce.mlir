module attributes {cce.target = "dav-351x"} {
  llvm.func @l1ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(128 : index) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(48 : i64) : i64
    %5 = llvm.mlir.constant(0 : i64) : i64
    %6 = llvm.mlir.constant(65536 : i64) : i64
    %7 = llvm.mlir.constant(131072 : i64) : i64
    %8 = llvm.mlir.constant(147456 : i64) : i64
    %9 = llvm.mlir.constant(4096 : i64) : i64
    %10 = llvm.mlir.constant(69632 : i64) : i64
    %11 = llvm.mlir.constant(274877972481 : i64) : i64
    %12 = llvm.mlir.constant(16384 : i64) : i64
    %13 = llvm.mlir.constant(1099511693313 : i64) : i64
    %14 = llvm.mlir.constant(134217744 : i64) : i64
    %15 = llvm.mlir.constant(133144052736 : i64) : i64
    %16 = llvm.mlir.constant(32 : index) : i64
    %17 = llvm.mlir.constant(8 : index) : i64
    %18 = llvm.mlir.constant(35201551958016 : i64) : i64
    %19 = llvm.mlir.constant(262148 : i64) : i64
    %20 = llvm.mlir.constant(2267742732288 : i64) : i64
    %21 = llvm.mlir.constant(65552 : i64) : i64
    %22 = llvm.mlir.constant(1 : i64) : i64
    %23 = llvm.mlir.constant(-6917529027371597760 : i64) : i64
    %24 = llvm.mlir.constant(68723671296 : i64) : i64
    %25 = llvm.mlir.constant(8796093022272 : i64) : i64
    %26 = llvm.mlir.constant(288230377225455616 : i64) : i64
    %27 = llvm.mlir.constant(35184372088864 : i64) : i64
    %28 = llvm.mlir.constant(18014398509498368 : i64) : i64
    %29 = llvm.mlir.constant(256 : i64) : i64
    %30 = llvm.mlir.constant(72057594037928960 : i64) : i64
    %31 = llvm.mlir.constant(16 : i64) : i64
    %32 = llvm.mlir.constant(512 : index) : i64
    %33 = llvm.mlir.constant(4 : i64) : i64
    %34 = cce.get.ctrl -> i64
    %35 = cce.sbitset0(%34, %3) : (i64, i64) -> i64
    cce.set.ctrl(%35) : i64
    %36 = cce.get.ctrl -> i64
    %37 = cce.sbitset1(%36, %4) : (i64, i64) -> i64
    cce.set.ctrl(%37) : i64
    cce.set.mte2.nz.para(%11) : i64
    %38 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %39 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%38, %40, %28, %29) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %41 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %42 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %43 = llvm.inttoptr %42 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%41, %43, %30, %31) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %44 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    %45 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %46 = llvm.inttoptr %45 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.f32.v310(%44, %46, %30, %31) : (<2>, <1>, i64, i64)
    llvm.br ^bb1(%1 : i64)
  ^bb1(%47: i64):  // 2 preds: ^bb0, ^bb8
    %48 = llvm.icmp "slt" %47, %2 : i64
    llvm.cond_br %48, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    %49 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %50 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%49, %50, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    llvm.br ^bb3(%1 : i64)
  ^bb3(%51: i64):  // 2 preds: ^bb2, ^bb4
    %52 = llvm.icmp "slt" %51, %16 : i64
    llvm.cond_br %52, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %53 = llvm.mul %51, %17 : i64
    %54 = llvm.mul %51, %32 : i64
    %55 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %56 = llvm.mul %54, %33 : i64
    %57 = llvm.getelementptr %55[%56] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %58 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %59 = llvm.mul %53, %33 : i64
    %60 = llvm.getelementptr %58[%59] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%57, %60, %15) : (<2>, <6>, i64)
    %61 = llvm.add %51, %0 : i64
    llvm.br ^bb3(%61 : i64)
  ^bb5:  // pred: ^bb3
    %62 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %63 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.f32(%62, %63, %18, %19, %5) : (<3>, <2>, i64, i64, i64)
    %64 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %65 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.f32(%64, %65, %20, %21, %22) : (<4>, <2>, i64, i64, i64)
    %66 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %67 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %68 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.f322f32(%66, %67, %68, %23) : (<5>, <3>, <4>, i64)
    %69 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %70 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%69, %70, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    llvm.br ^bb6(%1 : i64)
  ^bb6(%71: i64):  // 2 preds: ^bb5, ^bb7
    %72 = llvm.icmp "slt" %71, %16 : i64
    llvm.cond_br %72, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %73 = llvm.mul %71, %17 : i64
    %74 = llvm.mul %71, %32 : i64
    %75 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %76 = llvm.mul %74, %33 : i64
    %77 = llvm.getelementptr %75[%76] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %78 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %79 = llvm.mul %73, %33 : i64
    %80 = llvm.getelementptr %78[%79] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%77, %80, %15) : (<2>, <6>, i64)
    %81 = llvm.add %71, %0 : i64
    llvm.br ^bb6(%81 : i64)
  ^bb8:  // pred: ^bb6
    %82 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %83 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.f32(%82, %83, %18, %19, %5) : (<3>, <2>, i64, i64, i64)
    %84 = llvm.inttoptr %12 : i64 to !llvm.ptr<4>
    %85 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.f32(%84, %85, %20, %21, %22) : (<4>, <2>, i64, i64, i64)
    %86 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    %87 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %88 = llvm.inttoptr %12 : i64 to !llvm.ptr<4>
    cce.intr.mad.f322f32(%86, %87, %88, %23) : (<5>, <3>, <4>, i64)
    %89 = llvm.add %47, %0 : i64
    llvm.br ^bb1(%89 : i64)
  ^bb9:  // pred: ^bb1
    cce.set.loop3.para(%22) : i64
    %90 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %91 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%90, %91, %24, %25) : (<6>, <5>, i64, i64)
    %92 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %93 = llvm.inttoptr %92 : i64 to !llvm.ptr<1>
    %94 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%93, %94, %26, %27) : (<1>, <6>, i64, i64)
    cce.set.loop3.para(%22) : i64
    %95 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %96 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%95, %96, %24, %25) : (<6>, <5>, i64, i64)
    %97 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %98 = llvm.inttoptr %97 : i64 to !llvm.ptr<1>
    %99 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%98, %99, %26, %27) : (<1>, <6>, i64, i64)
    llvm.return
  }
}


module attributes {cce.target = "dav-351x"} {
  llvm.func @l1ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(128 : index) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(48 : i64) : i64
    %5 = llvm.mlir.constant(0 : i64) : i64
    %6 = llvm.mlir.constant(24576 : i64) : i64
    %7 = llvm.mlir.constant(8192 : i64) : i64
    %8 = llvm.mlir.constant(16384 : i64) : i64
    %9 = llvm.mlir.constant(1024 : i64) : i64
    %10 = llvm.mlir.constant(9216 : i64) : i64
    %11 = llvm.mlir.constant(68719542273 : i64) : i64
    %12 = llvm.mlir.constant(1099511693313 : i64) : i64
    %13 = llvm.mlir.constant(16777232 : i64) : i64
    %14 = llvm.mlir.constant(64424575232 : i64) : i64
    %15 = llvm.mlir.constant(16 : index) : i64
    %16 = llvm.mlir.constant(17596481011712 : i64) : i64
    %17 = llvm.mlir.constant(65537 : i64) : i64
    %18 = llvm.mlir.constant(1168231104512 : i64) : i64
    %19 = llvm.mlir.constant(65552 : i64) : i64
    %20 = llvm.mlir.constant(1 : i64) : i64
    %21 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %22 = llvm.mlir.constant(68720525568 : i64) : i64
    %23 = llvm.mlir.constant(8796093022224 : i64) : i64
    %24 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %25 = llvm.mlir.constant(35184372088864 : i64) : i64
    %26 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %27 = llvm.mlir.constant(256 : i64) : i64
    %28 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %29 = llvm.mlir.constant(16 : i64) : i64
    %30 = llvm.mlir.constant(256 : index) : i64
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
    cce.set.mte2.nz.para(%12) : i64
    %39 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %40 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %41 = llvm.inttoptr %40 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%39, %41, %28, %29) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%12) : i64
    %42 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    %43 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %44 = llvm.inttoptr %43 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%42, %44, %28, %29) : (<2>, <1>, i64, i64)
    llvm.br ^bb1(%1 : i64)
  ^bb1(%45: i64):  // 2 preds: ^bb0, ^bb5
    %46 = llvm.icmp "slt" %45, %2 : i64
    llvm.cond_br %46, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    %47 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %48 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%47, %48, %13) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    llvm.br ^bb3(%1 : i64)
  ^bb3(%49: i64):  // 2 preds: ^bb2, ^bb4
    %50 = llvm.icmp "slt" %49, %15 : i64
    llvm.cond_br %50, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %51 = llvm.mul %49, %15 : i64
    %52 = llvm.mul %49, %30 : i64
    %53 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %54 = llvm.mul %52, %31 : i64
    %55 = llvm.getelementptr %53[%54] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %56 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %57 = llvm.mul %51, %31 : i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%55, %58, %14) : (<2>, <6>, i64)
    %59 = llvm.add %49, %0 : i64
    llvm.br ^bb3(%59 : i64)
  ^bb5:  // pred: ^bb3
    %60 = llvm.add %45, %0 : i64
    llvm.br ^bb1(%60 : i64)
  ^bb6:  // pred: ^bb1
    %61 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %62 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%61, %62, %16, %17, %5) : (<3>, <2>, i64, i64, i64)
    %63 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %64 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%63, %64, %18, %19, %20) : (<4>, <2>, i64, i64, i64)
    %65 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %66 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %67 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%65, %66, %67, %21) : (<5>, <3>, <4>, i64)
    %68 = llvm.inttoptr %7 : i64 to !llvm.ptr<3>
    %69 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%68, %69, %16, %17, %5) : (<3>, <2>, i64, i64, i64)
    %70 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    %71 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%70, %71, %18, %19, %20) : (<4>, <2>, i64, i64, i64)
    %72 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    %73 = llvm.inttoptr %7 : i64 to !llvm.ptr<3>
    %74 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%72, %73, %74, %21) : (<5>, <3>, <4>, i64)
    cce.set.loop3.para(%20) : i64
    %75 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %76 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%75, %76, %22, %23) : (<6>, <5>, i64, i64)
    %77 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %78 = llvm.inttoptr %77 : i64 to !llvm.ptr<1>
    %79 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%78, %79, %24, %25) : (<1>, <6>, i64, i64)
    cce.set.loop3.para(%20) : i64
    %80 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %81 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%80, %81, %22, %23) : (<6>, <5>, i64, i64)
    %82 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %83 = llvm.inttoptr %82 : i64 to !llvm.ptr<1>
    %84 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%83, %84, %24, %25) : (<1>, <6>, i64, i64)
    llvm.return
  }
}


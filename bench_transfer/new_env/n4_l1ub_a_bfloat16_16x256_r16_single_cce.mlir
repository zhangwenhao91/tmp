module attributes {cce.target = "dav-351x"} {
  llvm.func @l1ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(16 : index) : i64
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
    %15 = llvm.mlir.constant(17596481011712 : i64) : i64
    %16 = llvm.mlir.constant(65537 : i64) : i64
    %17 = llvm.mlir.constant(1168231104512 : i64) : i64
    %18 = llvm.mlir.constant(65552 : i64) : i64
    %19 = llvm.mlir.constant(1 : i64) : i64
    %20 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %21 = llvm.mlir.constant(68720525568 : i64) : i64
    %22 = llvm.mlir.constant(8796093022224 : i64) : i64
    %23 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %24 = llvm.mlir.constant(35184372088864 : i64) : i64
    %25 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %26 = llvm.mlir.constant(256 : i64) : i64
    %27 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %28 = llvm.mlir.constant(16 : i64) : i64
    %29 = llvm.mlir.constant(256 : index) : i64
    %30 = llvm.mlir.constant(2 : i64) : i64
    %31 = cce.get.ctrl -> i64
    %32 = cce.sbitset0(%31, %3) : (i64, i64) -> i64
    cce.set.ctrl(%32) : i64
    %33 = cce.get.ctrl -> i64
    %34 = cce.sbitset1(%33, %4) : (i64, i64) -> i64
    cce.set.ctrl(%34) : i64
    cce.set.mte2.nz.para(%11) : i64
    %35 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %36 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %37 = llvm.inttoptr %36 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%35, %37, %25, %26) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%12) : i64
    %38 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %39 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%38, %40, %27, %28) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%12) : i64
    %41 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    %42 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %43 = llvm.inttoptr %42 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%41, %43, %27, %28) : (<2>, <1>, i64, i64)
    llvm.br ^bb1(%1 : i64)
  ^bb1(%44: i64):  // 2 preds: ^bb0, ^bb2
    %45 = llvm.icmp "slt" %44, %2 : i64
    llvm.cond_br %45, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %46 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %47 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%46, %47, %13) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    %48 = llvm.add %44, %0 : i64
    llvm.br ^bb1(%48 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%1 : i64)
  ^bb4(%49: i64):  // 2 preds: ^bb3, ^bb5
    %50 = llvm.icmp "slt" %49, %2 : i64
    llvm.cond_br %50, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %51 = llvm.mul %49, %2 : i64
    %52 = llvm.mul %49, %29 : i64
    %53 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %54 = llvm.mul %52, %30 : i64
    %55 = llvm.getelementptr %53[%54] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %56 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %57 = llvm.mul %51, %30 : i64
    %58 = llvm.getelementptr %56[%57] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%55, %58, %14) : (<2>, <6>, i64)
    %59 = llvm.add %49, %0 : i64
    llvm.br ^bb4(%59 : i64)
  ^bb6:  // pred: ^bb4
    %60 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %61 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%60, %61, %15, %16, %5) : (<3>, <2>, i64, i64, i64)
    %62 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %63 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%62, %63, %17, %18, %19) : (<4>, <2>, i64, i64, i64)
    %64 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %65 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %66 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%64, %65, %66, %20) : (<5>, <3>, <4>, i64)
    %67 = llvm.inttoptr %7 : i64 to !llvm.ptr<3>
    %68 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%67, %68, %15, %16, %5) : (<3>, <2>, i64, i64, i64)
    %69 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    %70 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%69, %70, %17, %18, %19) : (<4>, <2>, i64, i64, i64)
    %71 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    %72 = llvm.inttoptr %7 : i64 to !llvm.ptr<3>
    %73 = llvm.inttoptr %7 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%71, %72, %73, %20) : (<5>, <3>, <4>, i64)
    cce.set.loop3.para(%19) : i64
    %74 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %75 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%74, %75, %21, %22) : (<6>, <5>, i64, i64)
    %76 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %77 = llvm.inttoptr %76 : i64 to !llvm.ptr<1>
    %78 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%77, %78, %23, %24) : (<1>, <6>, i64, i64)
    cce.set.loop3.para(%19) : i64
    %79 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %80 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%79, %80, %21, %22) : (<6>, <5>, i64, i64)
    %81 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %82 = llvm.inttoptr %81 : i64 to !llvm.ptr<1>
    %83 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%82, %83, %23, %24) : (<1>, <6>, i64, i64)
    llvm.return
  }
}


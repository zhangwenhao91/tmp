module attributes {cce.target = "dav-351x"} {
  llvm.func @baseline_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core} {
    %0 = llvm.mlir.constant(60 : i64) : i64
    %1 = llvm.mlir.constant(48 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(8192 : i64) : i64
    %4 = llvm.mlir.constant(68719542273 : i64) : i64
    %5 = llvm.mlir.constant(1099511693313 : i64) : i64
    %6 = llvm.mlir.constant(17596481011712 : i64) : i64
    %7 = llvm.mlir.constant(65537 : i64) : i64
    %8 = llvm.mlir.constant(1168231104512 : i64) : i64
    %9 = llvm.mlir.constant(65552 : i64) : i64
    %10 = llvm.mlir.constant(1 : i64) : i64
    %11 = llvm.mlir.constant(-6917529027371597808 : i64) : i64
    %12 = llvm.mlir.constant(68720525568 : i64) : i64
    %13 = llvm.mlir.constant(8796093022224 : i64) : i64
    %14 = llvm.mlir.constant(288230377225454080 : i64) : i64
    %15 = llvm.mlir.constant(35184372088864 : i64) : i64
    %16 = llvm.mlir.constant(4503599627378688 : i64) : i64
    %17 = llvm.mlir.constant(256 : i64) : i64
    %18 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %19 = llvm.mlir.constant(16 : i64) : i64
    %20 = cce.get.ctrl -> i64
    %21 = cce.sbitset0(%20, %0) : (i64, i64) -> i64
    cce.set.ctrl(%21) : i64
    %22 = cce.get.ctrl -> i64
    %23 = cce.sbitset1(%22, %1) : (i64, i64) -> i64
    cce.set.ctrl(%23) : i64
    cce.set.mte2.nz.para(%4) : i64
    %24 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    %25 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %26 = llvm.inttoptr %25 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%24, %26, %16, %17) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%5) : i64
    %27 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    %28 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %29 = llvm.inttoptr %28 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%27, %29, %18, %19) : (<2>, <1>, i64, i64)
    %30 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %31 = llvm.inttoptr %2 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%30, %31, %6, %7, %2) : (<3>, <2>, i64, i64, i64)
    %32 = llvm.inttoptr %2 : i64 to !llvm.ptr<4>
    %33 = llvm.inttoptr %3 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%32, %33, %8, %9, %10) : (<4>, <2>, i64, i64, i64)
    %34 = llvm.inttoptr %2 : i64 to !llvm.ptr<5>
    %35 = llvm.inttoptr %2 : i64 to !llvm.ptr<3>
    %36 = llvm.inttoptr %2 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%34, %35, %36, %11) : (<5>, <3>, <4>, i64)
    cce.set.loop3.para(%10) : i64
    %37 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    %38 = llvm.inttoptr %2 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%37, %38, %12, %13) : (<6>, <5>, i64, i64)
    %39 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    %41 = llvm.inttoptr %2 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%40, %41, %14, %15) : (<1>, <6>, i64, i64)
    llvm.return
  }
}


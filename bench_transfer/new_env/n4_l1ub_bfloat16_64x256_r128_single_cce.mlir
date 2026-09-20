module attributes {cce.target = "dav-351x"} {
  llvm.func @l1ub_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: i32) attributes {cce.core = #cce.core} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(128 : index) : i64
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
    %16 = llvm.mlir.constant(16 : index) : i64
    %17 = llvm.mlir.constant(17609365913600 : i64) : i64
    %18 = llvm.mlir.constant(262148 : i64) : i64
    %19 = llvm.mlir.constant(1168231104512 : i64) : i64
    %20 = llvm.mlir.constant(65552 : i64) : i64
    %21 = llvm.mlir.constant(1 : i64) : i64
    %22 = llvm.mlir.constant(-6917529027371597760 : i64) : i64
    %23 = llvm.mlir.constant(68723671296 : i64) : i64
    %24 = llvm.mlir.constant(8796093022272 : i64) : i64
    %25 = llvm.mlir.constant(288230377225455616 : i64) : i64
    %26 = llvm.mlir.constant(35184372088864 : i64) : i64
    %27 = llvm.mlir.constant(18014398509490176 : i64) : i64
    %28 = llvm.mlir.constant(256 : i64) : i64
    %29 = llvm.mlir.constant(72057594037928448 : i64) : i64
    %30 = llvm.mlir.constant(16 : i64) : i64
    %31 = llvm.mlir.constant(1024 : index) : i64
    %32 = llvm.mlir.constant(2 : i64) : i64
    %33 = cce.get.ctrl -> i64
    %34 = cce.sbitset0(%33, %3) : (i64, i64) -> i64
    cce.set.ctrl(%34) : i64
    %35 = cce.get.ctrl -> i64
    %36 = cce.sbitset1(%35, %4) : (i64, i64) -> i64
    cce.set.ctrl(%36) : i64
    cce.set.mte2.nz.para(%11) : i64
    %37 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %38 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %39 = llvm.inttoptr %38 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%37, %39, %27, %28) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %40 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    %41 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %42 = llvm.inttoptr %41 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%40, %42, %29, %30) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%13) : i64
    %43 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    %44 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %45 = llvm.inttoptr %44 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%43, %45, %29, %30) : (<2>, <1>, i64, i64)
    llvm.br ^bb1(%1 : i64)
  ^bb1(%46: i64):  // 2 preds: ^bb0, ^bb8
    %47 = llvm.icmp "slt" %46, %2 : i64
    llvm.cond_br %47, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    %48 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %49 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%48, %49, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    llvm.br ^bb3(%1 : i64)
  ^bb3(%50: i64):  // 2 preds: ^bb2, ^bb4
    %51 = llvm.icmp "slt" %50, %16 : i64
    llvm.cond_br %51, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %52 = llvm.mul %50, %16 : i64
    %53 = llvm.mul %50, %31 : i64
    %54 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    %55 = llvm.mul %53, %32 : i64
    %56 = llvm.getelementptr %54[%55] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %57 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %58 = llvm.mul %52, %32 : i64
    %59 = llvm.getelementptr %57[%58] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%56, %59, %15) : (<2>, <6>, i64)
    %60 = llvm.add %50, %0 : i64
    llvm.br ^bb3(%60 : i64)
  ^bb5:  // pred: ^bb3
    %61 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %62 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%61, %62, %17, %18, %5) : (<3>, <2>, i64, i64, i64)
    %63 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %64 = llvm.inttoptr %7 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%63, %64, %19, %20, %21) : (<4>, <2>, i64, i64, i64)
    %65 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %66 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %67 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%65, %66, %67, %22) : (<5>, <3>, <4>, i64)
    %68 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %69 = llvm.inttoptr %6 : i64 to !llvm.ptr<2>
    cce.intr.mov.l1.to.ub.v310(%68, %69, %14) : (!llvm.ptr<6>, !llvm.ptr<2>, i64) -> ()
    llvm.br ^bb6(%1 : i64)
  ^bb6(%70: i64):  // 2 preds: ^bb5, ^bb7
    %71 = llvm.icmp "slt" %70, %16 : i64
    llvm.cond_br %71, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %72 = llvm.mul %70, %16 : i64
    %73 = llvm.mul %70, %31 : i64
    %74 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %75 = llvm.mul %73, %32 : i64
    %76 = llvm.getelementptr %74[%75] : (!llvm.ptr<2>, i64) -> !llvm.ptr<2>, i8
    %77 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %78 = llvm.mul %72, %32 : i64
    %79 = llvm.getelementptr %77[%78] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.mov.ub.to.l1.v310(%76, %79, %15) : (<2>, <6>, i64)
    %80 = llvm.add %70, %0 : i64
    llvm.br ^bb6(%80 : i64)
  ^bb8:  // pred: ^bb6
    %81 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %82 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%81, %82, %17, %18, %5) : (<3>, <2>, i64, i64, i64)
    %83 = llvm.inttoptr %12 : i64 to !llvm.ptr<4>
    %84 = llvm.inttoptr %8 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%83, %84, %19, %20, %21) : (<4>, <2>, i64, i64, i64)
    %85 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    %86 = llvm.inttoptr %6 : i64 to !llvm.ptr<3>
    %87 = llvm.inttoptr %12 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%85, %86, %87, %22) : (<5>, <3>, <4>, i64)
    %88 = llvm.add %46, %0 : i64
    llvm.br ^bb1(%88 : i64)
  ^bb9:  // pred: ^bb1
    cce.set.loop3.para(%21) : i64
    %89 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %90 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%89, %90, %23, %24) : (<6>, <5>, i64, i64)
    %91 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %92 = llvm.inttoptr %91 : i64 to !llvm.ptr<1>
    %93 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%92, %93, %25, %26) : (<1>, <6>, i64, i64)
    cce.set.loop3.para(%21) : i64
    %94 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %95 = llvm.inttoptr %9 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%94, %95, %23, %24) : (<6>, <5>, i64, i64)
    %96 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %97 = llvm.inttoptr %96 : i64 to !llvm.ptr<1>
    %98 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%97, %98, %25, %26) : (<1>, <6>, i64, i64)
    llvm.return
  }
}


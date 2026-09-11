module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @gemm_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<MIX>} {
    %0 = llvm.mlir.constant(128 : index) : i64
    %1 = llvm.mlir.constant(16 : i32) : i32
    %2 = llvm.mlir.constant(60 : i64) : i64
    %3 = llvm.mlir.constant(48 : i64) : i64
    %4 = llvm.mlir.constant(32768 : i64) : i64
    %5 = llvm.mlir.constant(0 : i64) : i64
    %6 = llvm.mlir.constant(68719542273 : i64) : i64
    %7 = llvm.mlir.constant(549755879425 : i64) : i64
    %8 = llvm.mlir.constant(8800387989504 : i64) : i64
    %9 = llvm.mlir.constant(65537 : i64) : i64
    %10 = llvm.mlir.constant(8830452760576 : i64) : i64
    %11 = llvm.mlir.constant(524296 : i64) : i64
    %12 = llvm.mlir.constant(1 : i64) : i64
    %13 = llvm.mlir.constant(-6917529025493073904 : i64) : i64
    %14 = llvm.mlir.constant(549756864512 : i64) : i64
    %15 = llvm.mlir.constant(8796093022224 : i64) : i64
    %16 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %17 = llvm.mlir.constant(35184372088864 : i64) : i64
    %18 = llvm.mlir.constant(4503599627374592 : i64) : i64
    %19 = llvm.mlir.constant(128 : i64) : i64
    %20 = llvm.mlir.constant(36028797018968064 : i64) : i64
    %21 = llvm.mlir.constant(2 : i64) : i64
    %22 = llvm.mlir.constant(4 : i64) : i64
    %23 = cce.get_block_idx -> i64
    %24 = llvm.trunc %23 : i64 to i32
    %25 = cce.get.ctrl -> i64
    %26 = cce.sbitset0(%25, %2) : (i64, i64) -> i64
    cce.set.ctrl(%26) : i64
    %27 = cce.get.ctrl -> i64
    %28 = cce.sbitset1(%27, %3) : (i64, i64) -> i64
    cce.set.ctrl(%28) : i64
    %29 = llvm.mul %24, %1 : i32
    %30 = llvm.sext %29 : i32 to i64
    %31 = llvm.mul %30, %0 : i64
    cce.set.mte2.nz.para(%6) : i64
    %32 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    %33 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %34 = llvm.mul %31, %21 : i64
    %35 = llvm.add %33, %34 : i64
    %36 = llvm.inttoptr %35 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%32, %36, %18, %19) : (<2>, <1>, i64, i64)
    cce.set.mte2.nz.para(%7) : i64
    %37 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    %38 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %39 = llvm.inttoptr %38 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.l1.multi.nd2nz.u16.v310(%37, %39, %20, %19) : (<2>, <1>, i64, i64)
    %40 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %41 = llvm.inttoptr %4 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0a.2dv2.bf16(%40, %41, %8, %9, %5) : (<3>, <2>, i64, i64, i64)
    %42 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    %43 = llvm.inttoptr %5 : i64 to !llvm.ptr<2>
    cce.intr.load.l1.to.l0b.2dv2.bf16(%42, %43, %10, %11, %12) : (<4>, <2>, i64, i64, i64)
    %44 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    %45 = llvm.inttoptr %5 : i64 to !llvm.ptr<3>
    %46 = llvm.inttoptr %5 : i64 to !llvm.ptr<4>
    cce.intr.mad.bf162f32(%44, %45, %46, %13) : (<5>, <3>, <4>, i64)
    cce.set.loop3.para(%12) : i64
    %47 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %48 = llvm.inttoptr %5 : i64 to !llvm.ptr<5>
    cce.intr.fix.l0c.to.ub.f32.ext(%47, %48, %14, %15) : (<6>, <5>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %5
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %12
    cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %5
    %49 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %50 = llvm.mul %31, %22 : i64
    %51 = llvm.add %49, %50 : i64
    %52 = llvm.inttoptr %51 : i64 to !llvm.ptr<1>
    %53 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%52, %53, %16, %17) : (<1>, <6>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %12
    llvm.return
  }
}


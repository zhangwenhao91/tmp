module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @triton_mean_dim1(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f16) : f16
    %6 = llvm.mlir.constant(263 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(0 : index) : i64
    %9 = llvm.mlir.constant(16384 : i64) : i64
    %10 = llvm.mlir.constant(8 : index) : i64
    %11 = llvm.mlir.constant(2 : i32) : i32
    %12 = llvm.mlir.constant(32 : index) : i64
    %13 = llvm.mlir.constant(128 : index) : i64
    %14 = llvm.mlir.constant(4 : i32) : i32
    %15 = llvm.mlir.constant(14 : i32) : i32
    %16 = llvm.mlir.constant(256 : i32) : i32
    %17 = llvm.mlir.constant(512 : i32) : i32
    %18 = llvm.mlir.constant(128 : i32) : i32
    %19 = llvm.mlir.constant(24576 : i64) : i64
    %20 = llvm.mlir.constant(8 : i32) : i32
    %21 = llvm.mlir.constant(5 : i32) : i32
    %22 = llvm.mlir.constant(512 : index) : i64
    %23 = llvm.mlir.constant(26624 : i64) : i64
    %24 = llvm.mlir.constant(64 : i32) : i32
    %25 = llvm.mlir.constant(7 : i32) : i32
    %26 = llvm.mlir.constant(288230393801342992 : i64) : i64
    %27 = llvm.mlir.constant(578343116210702 : i64) : i64
    %28 = llvm.mlir.constant(32 : i32) : i32
    %29 = llvm.mlir.constant(2 : i64) : i64
    %30 = llvm.mlir.constant(8 : i64) : i64
    %31 = cce.get.ctrl -> i64
    %32 = cce.sbitset0(%31, %3) : (i64, i64) -> i64
    cce.set.ctrl(%32) : i64
    %33 = cce.get.ctrl -> i64
    %34 = cce.sbitset1(%33, %2) : (i64, i64) -> i64
    cce.set.ctrl(%34) : i64
    %35 = cce.get_sub_block_idx -> i64
    %36 = llvm.icmp "eq" %35, %4 : i64
    llvm.cond_br %36, ^bb1, ^bb5
  ^bb1:  // pred: ^bb0
    llvm.br ^bb6(%1 : i32)
  ^bb2(%37: i64):  // 2 preds: ^bb3, ^bb12
    %38 = llvm.icmp "slt" %37, %6 : i64
    llvm.cond_br %38, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    %39 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    %41 = llvm.getelementptr %40[%37] : (!llvm.ptr<1>, i64) -> !llvm.ptr<1>, f16
    %42 = llvm.load %41 : !llvm.ptr<1> -> f16
    %43 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %44 = llvm.mul %37, %30 : i64
    %45 = llvm.mul %44, %29 : i64
    %46 = llvm.getelementptr %43[%45] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %42, %46 : f16, !llvm.ptr<6>
    %47 = llvm.add %37, %7 : i64
    llvm.br ^bb2(%47 : i64)
  ^bb4:  // pred: ^bb2
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb13(%1 : i32)
  ^bb5:  // 2 preds: ^bb0, ^bb33
    llvm.return
  ^bb6(%48: i32):  // 2 preds: ^bb1, ^bb11
    %49 = llvm.icmp "sle" %48, %1 : i32
    llvm.cond_br %49, ^bb7, ^bb12
  ^bb7:  // pred: ^bb6
    %50 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb8(%8 : i64)
  ^bb8(%51: i64):  // 2 preds: ^bb7, ^bb9
    %52 = llvm.icmp "slt" %51, %12 : i64
    llvm.cond_br %52, ^bb9, ^bb10
  ^bb9:  // pred: ^bb8
    %53 = llvm.mul %51, %13 : i64
    %54 = cce.vdups(%5, %50, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %55 = llvm.trunc %53 : i64 to i32
    %56 = llvm.mul %55, %11 : i32
    %57 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %58 = llvm.sext %56 : i32 to i64
    %59 = llvm.getelementptr %57[%58] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%54, %59, %1, %0, %1, %50) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %60 = llvm.add %51, %7 : i64
    llvm.br ^bb8(%60 : i64)
  ^bb10:  // pred: ^bb8
    llvm.br ^bb11
  ^bb11:  // pred: ^bb10
    %61 = llvm.add %48, %0 : i32
    llvm.br ^bb6(%61 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb12:  // pred: ^bb6
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2(%8 : i64)
  ^bb13(%62: i32):  // 2 preds: ^bb4, ^bb18
    %63 = llvm.icmp "sle" %62, %1 : i32
    llvm.cond_br %63, ^bb14, ^bb19
  ^bb14:  // pred: ^bb13
    %64 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %65 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb15(%8 : i64)
  ^bb15(%66: i64):  // 2 preds: ^bb14, ^bb16
    %67 = llvm.icmp "slt" %66, %12 : i64
    llvm.cond_br %67, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %68 = llvm.trunc %66 : i64 to i32
    %69 = llvm.mul %68, %16 : i32
    %70 = llvm.mul %68, %17 : i32
    %71 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %72 = llvm.sext %69 : i32 to i64
    %73 = llvm.getelementptr %71[%72] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %74 = cce.intr.vldsx1.f16(%73, %1, %15, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %75 = cce.vcvtff.ext(%74, %64, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %76 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %77 = llvm.sext %70 : i32 to i64
    %78 = llvm.getelementptr %76[%77] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%75, %78, %1, %11, %1, %65) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %79 = llvm.add %69, %18 : i32
    %80 = llvm.add %70, %16 : i32
    %81 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %82 = llvm.sext %79 : i32 to i64
    %83 = llvm.getelementptr %81[%82] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %84 = cce.intr.vldsx1.f16(%83, %1, %15, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %85 = cce.vcvtff.ext(%84, %64, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %86 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %87 = llvm.sext %80 : i32 to i64
    %88 = llvm.getelementptr %86[%87] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%85, %88, %1, %11, %1, %65) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %89 = llvm.add %66, %7 : i64
    llvm.br ^bb15(%89 : i64)
  ^bb17:  // pred: ^bb15
    llvm.br ^bb18
  ^bb18:  // pred: ^bb17
    %90 = llvm.add %62, %0 : i32
    llvm.br ^bb13(%90 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb19:  // pred: ^bb13
    llvm.br ^bb20(%1 : i32)
  ^bb20(%91: i32):  // 2 preds: ^bb19, ^bb25
    %92 = llvm.icmp "sle" %91, %1 : i32
    llvm.cond_br %92, ^bb21, ^bb26
  ^bb21:  // pred: ^bb20
    %dst, %restElem = cce.plt(%20) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %93 = cce.pset(%11) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb22(%8 : i64)
  ^bb22(%94: i64):  // 2 preds: ^bb21, ^bb23
    %95 = llvm.icmp "slt" %94, %22 : i64
    llvm.cond_br %95, ^bb23, ^bb24
  ^bb23:  // pred: ^bb22
    %96 = llvm.trunc %94 : i64 to i32
    %97 = llvm.mul %96, %28 : i32
    %98 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %99 = llvm.sext %97 : i32 to i64
    %100 = llvm.getelementptr %98[%99] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %101 = cce.intr.vldsx1.f32(%100, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %102 = cce.vcadd(%101, %dst) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %103 = llvm.mul %96, %14 : i32
    %104 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %105 = llvm.sext %103 : i32 to i64
    %106 = llvm.getelementptr %104[%105] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%102, %106, %1, %21, %1, %93) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %107 = llvm.add %94, %7 : i64
    llvm.br ^bb22(%107 : i64)
  ^bb24:  // pred: ^bb22
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %108 = llvm.add %91, %0 : i32
    llvm.br ^bb20(%108 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb20
    llvm.br ^bb27(%1 : i32)
  ^bb27(%109: i32):  // 2 preds: ^bb26, ^bb32
    %110 = llvm.icmp "sle" %109, %1 : i32
    llvm.cond_br %110, ^bb28, ^bb33
  ^bb28:  // pred: ^bb27
    %111 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb29(%8 : i64)
  ^bb29(%112: i64):  // 2 preds: ^bb28, ^bb30
    %113 = llvm.icmp "slt" %112, %10 : i64
    llvm.cond_br %113, ^bb30, ^bb31
  ^bb30:  // pred: ^bb29
    %114 = llvm.trunc %112 : i64 to i32
    %115 = llvm.udiv %114, %20 : i32
    %116 = llvm.urem %114, %20 : i32
    %117 = llvm.mul %116, %24 : i32
    %118 = llvm.mul %115, %17 : i32
    %119 = llvm.add %118, %117 : i32
    %120 = llvm.mul %119, %14 : i32
    %121 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %122 = llvm.sext %120 : i32 to i64
    %123 = llvm.getelementptr %121[%122] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %124 = cce.intr.vldsx1.f32(%123, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %125 = cce.vcvtff.trunc(%124, %111, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %126 = llvm.mul %119, %11 : i32
    %127 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %128 = llvm.sext %126 : i32 to i64
    %129 = llvm.getelementptr %127[%128] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%125, %129, %1, %25, %1, %111) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %130 = llvm.add %112, %7 : i64
    llvm.br ^bb29(%130 : i64)
  ^bb31:  // pred: ^bb29
    llvm.br ^bb32
  ^bb32:  // pred: ^bb31
    %131 = llvm.add %109, %0 : i32
    llvm.br ^bb27(%131 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb33:  // pred: ^bb27
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %132 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %133 = llvm.inttoptr %132 : i64 to !llvm.ptr<1>
    %134 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%133, %134, %26, %27) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb5
  }
}


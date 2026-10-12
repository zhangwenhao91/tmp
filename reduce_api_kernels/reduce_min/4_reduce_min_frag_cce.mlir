module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @reduce_min_frag_kernel(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(16 : i32) : i32
    %7 = llvm.mlir.constant(128 : index) : i64
    %8 = llvm.mlir.constant(-1.000000e+00 : f32) : f32
    %9 = llvm.mlir.constant(8192 : i64) : i64
    %10 = llvm.mlir.constant(8256 : i64) : i64
    %11 = llvm.mlir.constant(288230377225457664 : i64) : i64
    %12 = llvm.mlir.constant(35184372088864 : i64) : i64
    %13 = llvm.mlir.constant(2 : i32) : i32
    %14 = llvm.mlir.constant(5 : i32) : i32
    %15 = llvm.mlir.constant(4 : i32) : i32
    %16 = llvm.mlir.constant(16 : index) : i64
    %17 = llvm.mlir.constant(1 : index) : i64
    %18 = llvm.mlir.constant(128 : i32) : i32
    %19 = llvm.mlir.constant(64 : i32) : i32
    %20 = llvm.mlir.constant(288230377225453600 : i64) : i64
    %21 = llvm.mlir.constant(512 : i32) : i32
    %22 = llvm.mlir.constant(4 : i64) : i64
    %23 = cce.get.ctrl -> i64
    %24 = cce.sbitset0(%23, %3) : (i64, i64) -> i64
    cce.set.ctrl(%24) : i64
    %25 = cce.get.ctrl -> i64
    %26 = cce.sbitset1(%25, %2) : (i64, i64) -> i64
    cce.set.ctrl(%26) : i64
    %27 = cce.get_sub_block_idx -> i64
    %28 = llvm.icmp "eq" %27, %4 : i64
    llvm.cond_br %28, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %29 = cce.get_block_idx -> i64
    %30 = llvm.trunc %29 : i64 to i32
    %31 = llvm.mul %30, %6 : i32
    %32 = llvm.sext %31 : i32 to i64
    %33 = llvm.mul %32, %7 : i64
    %34 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %35 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %36 = llvm.mul %33, %22 : i64
    %37 = llvm.add %35, %36 : i64
    %38 = llvm.inttoptr %37 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%34, %38, %11, %12) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb13
    llvm.return
  ^bb3(%39: i32):  // 2 preds: ^bb1, ^bb8
    %40 = llvm.icmp "sle" %39, %1 : i32
    llvm.cond_br %40, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %41 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %42 = cce.pset(%13) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%5 : i64)
  ^bb5(%43: i64):  // 2 preds: ^bb4, ^bb6
    %44 = llvm.icmp "slt" %43, %16 : i64
    llvm.cond_br %44, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %45 = llvm.trunc %43 : i64 to i32
    %46 = llvm.mul %45, %18 : i32
    %47 = llvm.mul %45, %21 : i32
    %48 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %49 = llvm.sext %47 : i32 to i64
    %50 = llvm.getelementptr %48[%49] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %51 = cce.intr.vldsx1.f32(%50, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %52 = cce.vmuls(%51, %8, %41) : (vector<64xf32>, f32, vector<256xi1>) -> vector<64xf32>
    %53 = llvm.add %46, %19 : i32
    %54 = llvm.mul %53, %15 : i32
    %55 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %56 = llvm.sext %54 : i32 to i64
    %57 = llvm.getelementptr %55[%56] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %58 = cce.intr.vldsx1.f32(%57, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %59 = cce.vmuls(%58, %8, %41) : (vector<64xf32>, f32, vector<256xi1>) -> vector<64xf32>
    %60 = cce.vmax(%52, %59, %41) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %61 = cce.vcmax(%60, %41) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %62 = llvm.mul %45, %15 : i32
    %63 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %64 = llvm.sext %62 : i32 to i64
    %65 = llvm.getelementptr %63[%64] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%61, %65, %1, %14, %1, %42) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %66 = llvm.add %43, %17 : i64
    llvm.br ^bb5(%66 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %67 = llvm.add %39, %0 : i32
    llvm.br ^bb3(%67 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    llvm.br ^bb10(%1 : i32)
  ^bb10(%68: i32):  // 2 preds: ^bb9, ^bb12
    %69 = llvm.icmp "sle" %68, %1 : i32
    llvm.cond_br %69, ^bb11, ^bb13
  ^bb11:  // pred: ^bb10
    %dst, %restElem = cce.plt(%6) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %70 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %71 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %72 = cce.intr.vgather2.f32(%71, %70, %dst) : (!llvm.ptr<6>, vector<64xi32>, vector<256xi1>) -> vector<64xf32>
    %73 = cce.vmuls(%72, %8, %dst) : (vector<64xf32>, f32, vector<256xi1>) -> vector<64xf32>
    %74 = cce.intr.init_align : vector<32xi8>
    %75 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %76 = cce.intr.vstus(%73, %75, %19, %74) : (vector<64xf32>, !llvm.ptr<6>, i32, vector<32xi8>) -> vector<32xi8>
    %77 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstas(%76, %77, %19, %1) : (vector<32xi8>, !llvm.ptr<6>, i32, i32) -> ()
    llvm.br ^bb12
  ^bb12:  // pred: ^bb11
    %78 = llvm.add %68, %0 : i32
    llvm.br ^bb10(%78 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb13:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %79 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %80 = llvm.mul %32, %22 : i64
    %81 = llvm.add %79, %80 : i64
    %82 = llvm.inttoptr %81 : i64 to !llvm.ptr<1>
    %83 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%82, %83, %20, %12) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


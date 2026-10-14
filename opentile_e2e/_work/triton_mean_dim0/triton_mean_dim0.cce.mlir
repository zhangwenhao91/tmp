module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @triton_mean_dim0(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f16) : f16
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.mlir.constant(3 : index) : i64
    %8 = llvm.mlir.constant(128 : index) : i64
    %9 = llvm.mlir.constant(1.280000e+02 : f32) : f32
    %10 = llvm.mlir.constant(8192 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(8 : index) : i64
    %13 = llvm.mlir.constant(2 : i32) : i32
    %14 = llvm.mlir.constant(16 : index) : i64
    %15 = llvm.mlir.constant(4 : i32) : i32
    %16 = llvm.mlir.constant(14 : i32) : i32
    %17 = llvm.mlir.constant(256 : i32) : i32
    %18 = llvm.mlir.constant(512 : i32) : i32
    %19 = llvm.mlir.constant(128 : i32) : i32
    %20 = llvm.mlir.constant(12288 : i64) : i64
    %21 = llvm.mlir.constant(8 : i32) : i32
    %22 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %23 = llvm.mlir.constant(256 : index) : i64
    %24 = llvm.mlir.constant(12320 : i64) : i64
    %25 = llvm.mlir.constant(3 : i32) : i32
    %26 = llvm.mlir.constant(12352 : i64) : i64
    %27 = llvm.mlir.constant(5 : i32) : i32
    %28 = llvm.mlir.constant(12384 : i64) : i64
    %29 = llvm.mlir.constant(12416 : i64) : i64
    %30 = llvm.mlir.constant(288230376353038352 : i64) : i64
    %31 = llvm.mlir.constant(6597069766662 : i64) : i64
    %32 = llvm.mlir.constant(32 : i32) : i32
    %33 = llvm.mlir.constant(2 : i64) : i64
    %34 = llvm.mlir.constant(3 : i64) : i64
    %35 = llvm.mlir.constant(8 : i64) : i64
    %36 = cce.get.ctrl -> i64
    %37 = cce.sbitset0(%36, %3) : (i64, i64) -> i64
    cce.set.ctrl(%37) : i64
    %38 = cce.get.ctrl -> i64
    %39 = cce.sbitset1(%38, %2) : (i64, i64) -> i64
    cce.set.ctrl(%39) : i64
    %40 = cce.get_sub_block_idx -> i64
    %41 = llvm.icmp "eq" %40, %4 : i64
    llvm.cond_br %41, ^bb1, ^bb8
  ^bb1:  // pred: ^bb0
    llvm.br ^bb9(%1 : i32)
  ^bb2(%42: i64):  // 2 preds: ^bb6, ^bb15
    %43 = llvm.icmp "slt" %42, %8 : i64
    llvm.cond_br %43, ^bb3, ^bb7
  ^bb3:  // pred: ^bb2
    llvm.br ^bb4(%6 : i64)
  ^bb4(%44: i64):  // 2 preds: ^bb3, ^bb5
    %45 = llvm.icmp "slt" %44, %7 : i64
    llvm.cond_br %45, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %46 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %47 = llvm.inttoptr %46 : i64 to !llvm.ptr<1>
    %48 = llvm.mul %42, %34 : i64
    %49 = llvm.add %48, %44 : i64
    %50 = llvm.getelementptr %47[%49] : (!llvm.ptr<1>, i64) -> !llvm.ptr<1>, f16
    %51 = llvm.load %50 : !llvm.ptr<1> -> f16
    %52 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %53 = llvm.mul %42, %35 : i64
    %54 = llvm.add %53, %44 : i64
    %55 = llvm.mul %54, %33 : i64
    %56 = llvm.getelementptr %52[%55] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %51, %56 : f16, !llvm.ptr<6>
    %57 = llvm.add %44, %11 : i64
    llvm.br ^bb4(%57 : i64)
  ^bb6:  // pred: ^bb4
    %58 = llvm.add %42, %11 : i64
    llvm.br ^bb2(%58 : i64)
  ^bb7:  // pred: ^bb2
    cce.barrier pipe = <PIPE_ALL>
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb16(%1 : i32)
  ^bb8:  // 2 preds: ^bb0, ^bb54
    llvm.return
  ^bb9(%59: i32):  // 2 preds: ^bb1, ^bb14
    %60 = llvm.icmp "sle" %59, %1 : i32
    llvm.cond_br %60, ^bb10, ^bb15
  ^bb10:  // pred: ^bb9
    %61 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb11(%6 : i64)
  ^bb11(%62: i64):  // 2 preds: ^bb10, ^bb12
    %63 = llvm.icmp "slt" %62, %14 : i64
    llvm.cond_br %63, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %64 = llvm.mul %62, %8 : i64
    %65 = cce.vdups(%5, %61, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %66 = llvm.trunc %64 : i64 to i32
    %67 = llvm.mul %66, %13 : i32
    %68 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %69 = llvm.sext %67 : i32 to i64
    %70 = llvm.getelementptr %68[%69] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%65, %70, %1, %0, %1, %61) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %71 = llvm.add %62, %11 : i64
    llvm.br ^bb11(%71 : i64)
  ^bb13:  // pred: ^bb11
    llvm.br ^bb14
  ^bb14:  // pred: ^bb13
    %72 = llvm.add %59, %0 : i32
    llvm.br ^bb9(%72 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb15:  // pred: ^bb9
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2(%6 : i64)
  ^bb16(%73: i32):  // 2 preds: ^bb7, ^bb21
    %74 = llvm.icmp "sle" %73, %1 : i32
    llvm.cond_br %74, ^bb17, ^bb22
  ^bb17:  // pred: ^bb16
    %75 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %76 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb18(%6 : i64)
  ^bb18(%77: i64):  // 2 preds: ^bb17, ^bb19
    %78 = llvm.icmp "slt" %77, %14 : i64
    llvm.cond_br %78, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %79 = llvm.trunc %77 : i64 to i32
    %80 = llvm.mul %79, %17 : i32
    %81 = llvm.mul %79, %18 : i32
    %82 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %83 = llvm.sext %80 : i32 to i64
    %84 = llvm.getelementptr %82[%83] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %85 = cce.intr.vldsx1.f16(%84, %1, %16, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %86 = cce.vcvtff.ext(%85, %75, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %87 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %88 = llvm.sext %81 : i32 to i64
    %89 = llvm.getelementptr %87[%88] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%86, %89, %1, %13, %1, %76) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %90 = llvm.add %80, %19 : i32
    %91 = llvm.add %81, %17 : i32
    %92 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %93 = llvm.sext %90 : i32 to i64
    %94 = llvm.getelementptr %92[%93] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %95 = cce.intr.vldsx1.f16(%94, %1, %16, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %96 = cce.vcvtff.ext(%95, %75, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %97 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %98 = llvm.sext %91 : i32 to i64
    %99 = llvm.getelementptr %97[%98] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%96, %99, %1, %13, %1, %76) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %100 = llvm.add %77, %11 : i64
    llvm.br ^bb18(%100 : i64)
  ^bb20:  // pred: ^bb18
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %101 = llvm.add %73, %0 : i32
    llvm.br ^bb16(%101 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb16
    llvm.br ^bb23(%1 : i32)
  ^bb23(%102: i32):  // 2 preds: ^bb22, ^bb28
    %103 = llvm.icmp "sle" %102, %1 : i32
    llvm.cond_br %103, ^bb24, ^bb29
  ^bb24:  // pred: ^bb23
    %dst, %restElem = cce.plt(%21) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %104 = cce.vdups(%22, %dst, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    llvm.br ^bb25(%6, %104 : i64, vector<64xf32>)
  ^bb25(%105: i64, %106: vector<64xf32>):  // 2 preds: ^bb24, ^bb26
    %107 = llvm.icmp "slt" %105, %23 : i64
    llvm.cond_br %107, ^bb26, ^bb27
  ^bb26:  // pred: ^bb25
    %108 = llvm.trunc %105 : i64 to i32
    %109 = llvm.mul %108, %32 : i32
    %110 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %111 = llvm.sext %109 : i32 to i64
    %112 = llvm.getelementptr %110[%111] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %113 = cce.intr.vldsx1.f32(%112, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %114 = cce.vadd(%106, %113, %dst) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %115 = llvm.add %105, %11 : i64
    llvm.br ^bb25(%115, %114 : i64, vector<64xf32>)
  ^bb27:  // pred: ^bb25
    %116 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%106, %116, %1, %13, %1, %dst) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb28
  ^bb28:  // pred: ^bb27
    %117 = llvm.add %102, %0 : i32
    llvm.br ^bb23(%117 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb29:  // pred: ^bb23
    llvm.br ^bb30(%1 : i32)
  ^bb30(%118: i32):  // 2 preds: ^bb29, ^bb35
    %119 = llvm.icmp "sle" %118, %1 : i32
    llvm.cond_br %119, ^bb31, ^bb36
  ^bb31:  // pred: ^bb30
    %120 = cce.pset(%13) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %121 = cce.pset(%13) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb32(%6 : i64)
  ^bb32(%122: i64):  // 2 preds: ^bb31, ^bb33
    %123 = llvm.icmp "slt" %122, %12 : i64
    llvm.cond_br %123, ^bb33, ^bb34
  ^bb33:  // pred: ^bb32
    %124 = llvm.trunc %122 : i64 to i32
    %125 = llvm.mul %124, %15 : i32
    %126 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %127 = llvm.sext %125 : i32 to i64
    %128 = llvm.getelementptr %126[%127] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %129 = cce.intr.vldsx1.f32(%128, %1, %25, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %130 = cce.vcvtff.trunc(%129, %120, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %131 = llvm.mul %124, %13 : i32
    %132 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    %133 = llvm.sext %131 : i32 to i64
    %134 = llvm.getelementptr %132[%133] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%130, %134, %1, %15, %1, %121) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %135 = llvm.add %122, %11 : i64
    llvm.br ^bb32(%135 : i64)
  ^bb34:  // pred: ^bb32
    llvm.br ^bb35
  ^bb35:  // pred: ^bb34
    %136 = llvm.add %118, %0 : i32
    llvm.br ^bb30(%136 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb36:  // pred: ^bb30
    llvm.br ^bb37(%1 : i32)
  ^bb37(%137: i32):  // 2 preds: ^bb36, ^bb42
    %138 = llvm.icmp "sle" %137, %1 : i32
    llvm.cond_br %138, ^bb38, ^bb43
  ^bb38:  // pred: ^bb37
    %139 = cce.pset(%13) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %140 = cce.pset(%13) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb39(%6 : i64)
  ^bb39(%141: i64):  // 2 preds: ^bb38, ^bb40
    %142 = llvm.icmp "slt" %141, %12 : i64
    llvm.cond_br %142, ^bb40, ^bb41
  ^bb40:  // pred: ^bb39
    %143 = llvm.trunc %141 : i64 to i32
    %144 = llvm.mul %143, %13 : i32
    %145 = llvm.mul %143, %15 : i32
    %146 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    %147 = llvm.sext %144 : i32 to i64
    %148 = llvm.getelementptr %146[%147] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %149 = cce.intr.vldsx1.f16(%148, %1, %13, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %150 = cce.vcvtff.ext(%149, %139, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %151 = llvm.inttoptr %26 : i64 to !llvm.ptr<6>
    %152 = llvm.sext %145 : i32 to i64
    %153 = llvm.getelementptr %151[%152] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%150, %153, %1, %27, %1, %140) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %154 = llvm.add %141, %11 : i64
    llvm.br ^bb39(%154 : i64)
  ^bb41:  // pred: ^bb39
    llvm.br ^bb42
  ^bb42:  // pred: ^bb41
    %155 = llvm.add %137, %0 : i32
    llvm.br ^bb37(%155 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb43:  // pred: ^bb37
    llvm.br ^bb44(%1 : i32)
  ^bb44(%156: i32):  // 2 preds: ^bb43, ^bb46
    %157 = llvm.icmp "sle" %156, %1 : i32
    llvm.cond_br %157, ^bb45, ^bb47
  ^bb45:  // pred: ^bb44
    %158 = llvm.inttoptr %26 : i64 to !llvm.ptr<6>
    %159 = cce.intr.vldsx1.f32(%158, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %dst_0, %restElem_1 = cce.plt(%21) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %160 = cce.vdups(%9, %dst_0, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %161 = cce.vdiv(%159, %160, %dst_0) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %162 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%161, %162, %1, %13, %1, %dst_0) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb46
  ^bb46:  // pred: ^bb45
    %163 = llvm.add %156, %0 : i32
    llvm.br ^bb44(%163 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb47:  // pred: ^bb44
    llvm.br ^bb48(%1 : i32)
  ^bb48(%164: i32):  // 2 preds: ^bb47, ^bb53
    %165 = llvm.icmp "sle" %164, %1 : i32
    llvm.cond_br %165, ^bb49, ^bb54
  ^bb49:  // pred: ^bb48
    %166 = cce.pset(%13) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %167 = cce.pset(%13) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb50(%6 : i64)
  ^bb50(%168: i64):  // 2 preds: ^bb49, ^bb51
    %169 = llvm.icmp "slt" %168, %12 : i64
    llvm.cond_br %169, ^bb51, ^bb52
  ^bb51:  // pred: ^bb50
    %170 = llvm.trunc %168 : i64 to i32
    %171 = llvm.mul %170, %15 : i32
    %172 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %173 = llvm.sext %171 : i32 to i64
    %174 = llvm.getelementptr %172[%173] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %175 = cce.intr.vldsx1.f32(%174, %1, %25, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %176 = cce.vcvtff.trunc(%175, %166, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %177 = llvm.mul %170, %13 : i32
    %178 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %179 = llvm.sext %177 : i32 to i64
    %180 = llvm.getelementptr %178[%179] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%176, %180, %1, %15, %1, %167) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %181 = llvm.add %168, %11 : i64
    llvm.br ^bb50(%181 : i64)
  ^bb52:  // pred: ^bb50
    llvm.br ^bb53
  ^bb53:  // pred: ^bb52
    %182 = llvm.add %164, %0 : i32
    llvm.br ^bb48(%182 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb54:  // pred: ^bb48
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %183 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %184 = llvm.inttoptr %183 : i64 to !llvm.ptr<1>
    %185 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%184, %185, %30, %31) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb8
  }
}


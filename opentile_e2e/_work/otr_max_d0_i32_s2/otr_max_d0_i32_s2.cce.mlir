module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_max_d0_i32_s2(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(100 : i32) : i32
    %7 = llvm.mlir.constant(20 : i32) : i32
    %8 = llvm.mlir.constant(-2147483648 : i32) : i32
    %9 = llvm.mlir.constant(46752 : i64) : i64
    %10 = llvm.mlir.constant(1 : index) : i64
    %11 = llvm.mlir.constant(4 : i32) : i32
    %12 = llvm.mlir.constant(64 : index) : i64
    %13 = llvm.mlir.constant(2 : i32) : i32
    %14 = llvm.mlir.constant(32 : i32) : i32
    %15 = llvm.mlir.constant(64 : i32) : i32
    %16 = llvm.mlir.constant(45728 : i64) : i64
    %17 = llvm.mlir.constant(2 : index) : i64
    %18 = llvm.mlir.constant(46240 : i64) : i64
    %19 = llvm.mlir.constant(47008 : i64) : i64
    %20 = llvm.mlir.constant(47264 : i64) : i64
    %21 = llvm.mlir.constant(0 : i8) : i8
    %22 = llvm.mlir.constant(1 : i8) : i8
    %23 = llvm.mlir.constant(3 : i32) : i32
    %24 = llvm.mlir.constant(47520 : i64) : i64
    %25 = llvm.mlir.constant(32768 : i64) : i64
    %26 = llvm.mlir.constant(16 : index) : i64
    %27 = llvm.mlir.constant(256 : i32) : i32
    %28 = llvm.mlir.constant(224 : i32) : i32
    %29 = llvm.mlir.constant(4096 : i32) : i32
    %30 = llvm.mlir.constant(32 : index) : i64
    %31 = llvm.mlir.constant(128 : index) : i64
    %32 = llvm.mlir.constant(37088 : i64) : i64
    %33 = llvm.mlir.constant(41408 : i64) : i64
    %34 = llvm.mlir.constant(16 : i32) : i32
    %35 = llvm.mlir.constant(16384 : i64) : i64
    %36 = llvm.mlir.constant(47776 : i64) : i64
    %37 = llvm.mlir.constant(288230378836067904 : i64) : i64
    %38 = llvm.mlir.constant(140737488355408 : i64) : i64
    %39 = llvm.mlir.constant(288230378836066320 : i64) : i64
    %40 = llvm.mlir.constant(87960930222160 : i64) : i64
    %41 = llvm.mlir.constant(128 : i32) : i32
    %42 = cce.get.ctrl -> i64
    %43 = cce.sbitset0(%42, %3) : (i64, i64) -> i64
    cce.set.ctrl(%43) : i64
    %44 = cce.get.ctrl -> i64
    %45 = cce.sbitset1(%44, %2) : (i64, i64) -> i64
    cce.set.ctrl(%45) : i64
    %46 = cce.get_sub_block_idx -> i64
    %47 = llvm.icmp "eq" %46, %4 : i64
    llvm.cond_br %47, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb110
    llvm.return
  ^bb3(%48: i32):  // 2 preds: ^bb1, ^bb5
    %49 = llvm.icmp "sle" %48, %1 : i32
    llvm.cond_br %49, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %50 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %51 = cce.vdups(%1, %50, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %52 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%51, %52, %1, %13, %1, %50) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %53 = llvm.add %48, %0 : i32
    llvm.br ^bb3(%53 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    llvm.br ^bb7(%1 : i32)
  ^bb7(%54: i32):  // 2 preds: ^bb6, ^bb9
    %55 = llvm.icmp "sle" %54, %1 : i32
    llvm.cond_br %55, ^bb8, ^bb10
  ^bb8:  // pred: ^bb7
    %dst, %restElem = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %56 = cce.vdups(%7, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %57 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%56, %57, %1, %13, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %58 = llvm.add %54, %0 : i32
    llvm.br ^bb7(%58 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%59: i32):  // 2 preds: ^bb10, ^bb16
    %60 = llvm.icmp "sle" %59, %1 : i32
    llvm.cond_br %60, ^bb12, ^bb17
  ^bb12:  // pred: ^bb11
    %61 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb13(%5 : i64)
  ^bb13(%62: i64):  // 2 preds: ^bb12, ^bb14
    %63 = llvm.icmp "slt" %62, %17 : i64
    llvm.cond_br %63, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %64 = llvm.mul %62, %12 : i64
    %65 = cce.vdups(%6, %61, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %66 = llvm.trunc %64 : i64 to i32
    %67 = llvm.mul %66, %11 : i32
    %68 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %69 = llvm.sext %67 : i32 to i64
    %70 = llvm.getelementptr %68[%69] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%65, %70, %1, %13, %1, %61) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %71 = llvm.add %62, %10 : i64
    llvm.br ^bb13(%71 : i64)
  ^bb15:  // pred: ^bb13
    llvm.br ^bb16
  ^bb16:  // pred: ^bb15
    %72 = llvm.add %59, %0 : i32
    llvm.br ^bb11(%72 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb17:  // pred: ^bb11
    llvm.br ^bb18(%1 : i32)
  ^bb18(%73: i32):  // 2 preds: ^bb17, ^bb23
    %74 = llvm.icmp "sle" %73, %1 : i32
    llvm.cond_br %74, ^bb19, ^bb24
  ^bb19:  // pred: ^bb18
    %75 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb20(%5 : i64)
  ^bb20(%76: i64):  // 2 preds: ^bb19, ^bb21
    %77 = llvm.icmp "slt" %76, %17 : i64
    llvm.cond_br %77, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %78 = llvm.mul %76, %12 : i64
    %79 = llvm.trunc %78 : i64 to i32
    %80 = cce.vci(%79, %1) : (i32, i32) -> vector<64xi32>
    %81 = llvm.mul %79, %11 : i32
    %82 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %83 = llvm.sext %81 : i32 to i64
    %84 = llvm.getelementptr %82[%83] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%80, %84, %1, %13, %1, %75) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %85 = llvm.add %76, %10 : i64
    llvm.br ^bb20(%85 : i64)
  ^bb22:  // pred: ^bb20
    llvm.br ^bb23
  ^bb23:  // pred: ^bb22
    %86 = llvm.add %73, %0 : i32
    llvm.br ^bb18(%86 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb24:  // pred: ^bb18
    llvm.br ^bb25(%1 : i32)
  ^bb25(%87: i32):  // 2 preds: ^bb24, ^bb27
    %88 = llvm.icmp "sle" %87, %1 : i32
    llvm.cond_br %88, ^bb26, ^bb28
  ^bb26:  // pred: ^bb25
    %89 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %90 = cce.vdups(%1, %89, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %91 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%90, %91, %1, %13, %1, %89) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb27
  ^bb27:  // pred: ^bb26
    %92 = llvm.add %87, %0 : i32
    llvm.br ^bb25(%92 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb28:  // pred: ^bb25
    llvm.br ^bb29(%1 : i32)
  ^bb29(%93: i32):  // 2 preds: ^bb28, ^bb31
    %94 = llvm.icmp "sle" %93, %1 : i32
    llvm.cond_br %94, ^bb30, ^bb32
  ^bb30:  // pred: ^bb29
    %95 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %96 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%95, %96, %1, %13, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb31
  ^bb31:  // pred: ^bb30
    %97 = llvm.add %93, %0 : i32
    llvm.br ^bb29(%97 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb32:  // pred: ^bb29
    llvm.br ^bb33(%1 : i32)
  ^bb33(%98: i32):  // 2 preds: ^bb32, ^bb35
    %99 = llvm.icmp "sle" %98, %1 : i32
    llvm.cond_br %99, ^bb34, ^bb36
  ^bb34:  // pred: ^bb33
    %100 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %101 = cce.vdups(%21, %100, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %102 = cce.cmp(%101, %101, %100) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %103 = cce.vdups(%22, %100, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %104 = cce.vsel(%103, %101, %102) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %105 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%104, %105, %1, %1, %1, %100) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb35
  ^bb35:  // pred: ^bb34
    %106 = llvm.add %98, %0 : i32
    llvm.br ^bb33(%106 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb36:  // pred: ^bb33
    llvm.br ^bb37(%1 : i32)
  ^bb37(%107: i32):  // 2 preds: ^bb36, ^bb42
    %108 = llvm.icmp "sle" %107, %1 : i32
    llvm.cond_br %108, ^bb38, ^bb43
  ^bb38:  // pred: ^bb37
    %109 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %110 = cce.vdups(%1, %109, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %111 = cce.vdups(%0, %109, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %dst_2, %restElem_3 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb39(%5 : i64)
  ^bb39(%112: i64):  // 2 preds: ^bb38, ^bb40
    %113 = llvm.icmp "slt" %112, %17 : i64
    llvm.cond_br %113, ^bb40, ^bb41
  ^bb40:  // pred: ^bb39
    %114 = llvm.trunc %112 : i64 to i32
    %115 = llvm.mul %114, %15 : i32
    %116 = llvm.mul %114, %27 : i32
    %117 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %118 = llvm.sext %116 : i32 to i64
    %119 = llvm.getelementptr %117[%118] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %120 = cce.intr.vldsx1.i32(%119, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %121 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %122 = llvm.sext %116 : i32 to i64
    %123 = llvm.getelementptr %121[%122] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %124 = cce.intr.vldsx1.i32(%123, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %125 = cce.cmp(%120, %124, %109) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %126 = cce.vsel(%111, %110, %125) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %127 = cce.vpack(%126, %1) : (vector<64xi32>, i32) -> vector<128xi16>
    %128 = cce.vpack(%127, %1) : (vector<128xi16>, i32) -> vector<256xi8>
    %129 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %130 = llvm.sext %115 : i32 to i64
    %131 = llvm.getelementptr %129[%130] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%128, %131, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %132 = llvm.add %112, %10 : i64
    llvm.br ^bb39(%132 : i64)
  ^bb41:  // pred: ^bb39
    llvm.br ^bb42
  ^bb42:  // pred: ^bb41
    %133 = llvm.add %107, %0 : i32
    llvm.br ^bb37(%133 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb43:  // pred: ^bb37
    llvm.br ^bb44(%1 : i32)
  ^bb44(%134: i32):  // 2 preds: ^bb43, ^bb46
    %135 = llvm.icmp "sle" %134, %1 : i32
    llvm.cond_br %135, ^bb45, ^bb47
  ^bb45:  // pred: ^bb44
    %136 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %137 = cce.vdups(%21, %136, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %138 = cce.cmp(%137, %137, %136) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %139 = cce.vdups(%22, %136, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %140 = cce.vsel(%139, %137, %138) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %141 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%140, %141, %1, %1, %1, %136) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb46
  ^bb46:  // pred: ^bb45
    %142 = llvm.add %134, %0 : i32
    llvm.br ^bb44(%142 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb47:  // pred: ^bb44
    llvm.br ^bb48(%1 : i32)
  ^bb48(%143: i32):  // 2 preds: ^bb47, ^bb50
    %144 = llvm.icmp "sle" %143, %1 : i32
    llvm.cond_br %144, ^bb49, ^bb51
  ^bb49:  // pred: ^bb48
    %145 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %146 = cce.intr.vldsx1.i32(%145, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %147 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %148 = cce.intr.vldsx1.i32(%147, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %149 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %150 = cce.cmp(%148, %146, %149) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %151 = cce.ppack(%150, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %152 = cce.ppack(%151, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %153 = cce.vdups(%21, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %154 = cce.vdups(%22, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %155 = cce.vsel(%154, %153, %152) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %156 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%155, %156, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb50
  ^bb50:  // pred: ^bb49
    %157 = llvm.add %143, %0 : i32
    llvm.br ^bb48(%157 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb51:  // pred: ^bb48
    llvm.br ^bb52(%1 : i32)
  ^bb52(%158: i32):  // 2 preds: ^bb51, ^bb57
    %159 = llvm.icmp "sle" %158, %1 : i32
    llvm.cond_br %159, ^bb53, ^bb58
  ^bb53:  // pred: ^bb52
    %160 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %161 = cce.vdups(%21, %160, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb54(%5 : i64)
  ^bb54(%162: i64):  // 2 preds: ^bb53, ^bb55
    %163 = llvm.icmp "slt" %162, %26 : i64
    llvm.cond_br %163, ^bb55, ^bb56
  ^bb55:  // pred: ^bb54
    %164 = llvm.trunc %162 : i64 to i32
    %165 = llvm.mul %164, %27 : i32
    %166 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %167 = llvm.sext %165 : i32 to i64
    %168 = llvm.getelementptr %166[%167] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%161, %168, %1, %1, %1, %160) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %169 = llvm.add %162, %10 : i64
    llvm.br ^bb54(%169 : i64)
  ^bb56:  // pred: ^bb54
    %dst_6, %restElem_7 = cce.plt(%28) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %170 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %171 = llvm.getelementptr %170[4096] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%161, %171, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb57
  ^bb57:  // pred: ^bb56
    %172 = llvm.add %158, %0 : i32
    llvm.br ^bb52(%172 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb58:  // pred: ^bb52
    llvm.br ^bb59(%1 : i32)
  ^bb59(%173: i32):  // 2 preds: ^bb58, ^bb64
    %174 = llvm.icmp "sle" %173, %1 : i32
    llvm.cond_br %174, ^bb60, ^bb65
  ^bb60:  // pred: ^bb59
    %dst_8, %restElem_9 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb61(%5 : i64)
  ^bb61(%175: i64):  // 2 preds: ^bb60, ^bb62
    %176 = llvm.icmp "slt" %175, %31 : i64
    llvm.cond_br %176, ^bb62, ^bb63
  ^bb62:  // pred: ^bb61
    %177 = llvm.trunc %175 : i64 to i32
    %178 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %179 = llvm.sext %177 : i32 to i64
    %180 = llvm.getelementptr %178[%179] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %181 = cce.intr.vldsx1.i8(%180, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %182 = llvm.mul %177, %14 : i32
    %183 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %184 = llvm.sext %182 : i32 to i64
    %185 = llvm.getelementptr %183[%184] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%181, %185, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %186 = llvm.add %175, %10 : i64
    llvm.br ^bb61(%186 : i64)
  ^bb63:  // pred: ^bb61
    llvm.br ^bb64
  ^bb64:  // pred: ^bb63
    %187 = llvm.add %173, %0 : i32
    llvm.br ^bb59(%187 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb65:  // pred: ^bb59
    llvm.br ^bb66(%1 : i32)
  ^bb66(%188: i32):  // 2 preds: ^bb65, ^bb71
    %189 = llvm.icmp "sle" %188, %1 : i32
    llvm.cond_br %189, ^bb67, ^bb72
  ^bb67:  // pred: ^bb66
    %190 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %191 = cce.vdups(%21, %190, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%192: i64):  // 2 preds: ^bb67, ^bb69
    %193 = llvm.icmp "slt" %192, %26 : i64
    llvm.cond_br %193, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %194 = llvm.trunc %192 : i64 to i32
    %195 = llvm.mul %194, %27 : i32
    %196 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %197 = llvm.sext %195 : i32 to i64
    %198 = llvm.getelementptr %196[%197] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%191, %198, %1, %1, %1, %190) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %199 = llvm.add %192, %10 : i64
    llvm.br ^bb68(%199 : i64)
  ^bb70:  // pred: ^bb68
    %dst_10, %restElem_11 = cce.plt(%28) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %200 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %201 = llvm.getelementptr %200[4096] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%191, %201, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb71
  ^bb71:  // pred: ^bb70
    %202 = llvm.add %188, %0 : i32
    llvm.br ^bb66(%202 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb72:  // pred: ^bb66
    llvm.br ^bb73(%1 : i32)
  ^bb73(%203: i32):  // 2 preds: ^bb72, ^bb81
    %204 = llvm.icmp "sle" %203, %1 : i32
    llvm.cond_br %204, ^bb74, ^bb82
  ^bb74:  // pred: ^bb73
    %205 = cce.pset(%13) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb75(%5 : i64)
  ^bb75(%206: i64):  // 2 preds: ^bb74, ^bb79
    %207 = llvm.icmp "slt" %206, %30 : i64
    llvm.cond_br %207, ^bb76, ^bb80
  ^bb76:  // pred: ^bb75
    %208 = llvm.trunc %206 : i64 to i32
    %209 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    %210 = llvm.sext %208 : i32 to i64
    %211 = llvm.getelementptr %209[%210] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %212 = cce.intr.vldsx1.i8(%211, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb77(%5 : i64)
  ^bb77(%213: i64):  // 2 preds: ^bb76, ^bb78
    %214 = llvm.icmp "slt" %213, %31 : i64
    llvm.cond_br %214, ^bb78, ^bb79
  ^bb78:  // pred: ^bb77
    %215 = llvm.trunc %213 : i64 to i32
    %216 = llvm.mul %215, %14 : i32
    %217 = llvm.add %216, %208 : i32
    %218 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %219 = llvm.sext %217 : i32 to i64
    %220 = llvm.getelementptr %218[%219] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%212, %220, %1, %23, %1, %205) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %221 = llvm.add %213, %10 : i64
    llvm.br ^bb77(%221 : i64)
  ^bb79:  // pred: ^bb77
    %222 = llvm.add %206, %10 : i64
    llvm.br ^bb75(%222 : i64)
  ^bb80:  // pred: ^bb75
    llvm.br ^bb81
  ^bb81:  // pred: ^bb80
    %223 = llvm.add %203, %0 : i32
    llvm.br ^bb73(%223 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb82:  // pred: ^bb73
    llvm.br ^bb83(%1 : i32)
  ^bb83(%224: i32):  // 2 preds: ^bb82, ^bb88
    %225 = llvm.icmp "sle" %224, %1 : i32
    llvm.cond_br %225, ^bb84, ^bb89
  ^bb84:  // pred: ^bb83
    %226 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %227 = cce.vdups(%21, %226, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb85(%5 : i64)
  ^bb85(%228: i64):  // 2 preds: ^bb84, ^bb86
    %229 = llvm.icmp "slt" %228, %26 : i64
    llvm.cond_br %229, ^bb86, ^bb87
  ^bb86:  // pred: ^bb85
    %230 = llvm.trunc %228 : i64 to i32
    %231 = llvm.mul %230, %27 : i32
    %232 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %233 = llvm.sext %231 : i32 to i64
    %234 = llvm.getelementptr %232[%233] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%227, %234, %1, %1, %1, %226) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %235 = llvm.add %228, %10 : i64
    llvm.br ^bb85(%235 : i64)
  ^bb87:  // pred: ^bb85
    %dst_12, %restElem_13 = cce.plt(%28) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %236 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %237 = llvm.getelementptr %236[4096] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%227, %237, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb88
  ^bb88:  // pred: ^bb87
    %238 = llvm.add %224, %0 : i32
    llvm.br ^bb83(%238 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb89:  // pred: ^bb83
    llvm.br ^bb90(%1 : i32)
  ^bb90(%239: i32):  // 2 preds: ^bb89, ^bb95
    %240 = llvm.icmp "sle" %239, %1 : i32
    llvm.cond_br %240, ^bb91, ^bb96
  ^bb91:  // pred: ^bb90
    %241 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb92(%5 : i64)
  ^bb92(%242: i64):  // 2 preds: ^bb91, ^bb93
    %243 = llvm.icmp "slt" %242, %26 : i64
    llvm.cond_br %243, ^bb93, ^bb94
  ^bb93:  // pred: ^bb92
    %244 = llvm.trunc %242 : i64 to i32
    %245 = llvm.udiv %244, %34 : i32
    %246 = llvm.urem %244, %34 : i32
    %247 = llvm.mul %246, %27 : i32
    %248 = llvm.mul %245, %29 : i32
    %249 = llvm.add %248, %247 : i32
    %250 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %251 = llvm.sext %249 : i32 to i64
    %252 = llvm.getelementptr %250[%251] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %253 = cce.intr.vldsx1.i8(%252, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %254 = cce.vdups(%21, %241, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %255 = cce.cmp(%253, %254, %241) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %256 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %257 = llvm.sext %249 : i32 to i64
    %258 = llvm.getelementptr %256[%257] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %259 = cce.intr.vldsx1.i8(%258, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %260 = cce.cmp(%259, %254, %241) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %261 = cce.pand(%255, %260, %241) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %262 = cce.vdups(%22, %241, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %263 = cce.vsel(%262, %254, %261) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %264 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %265 = llvm.sext %249 : i32 to i64
    %266 = llvm.getelementptr %264[%265] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%263, %266, %1, %1, %1, %241) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %267 = llvm.add %242, %10 : i64
    llvm.br ^bb92(%267 : i64)
  ^bb94:  // pred: ^bb92
    llvm.br ^bb95
  ^bb95:  // pred: ^bb94
    %268 = llvm.add %239, %0 : i32
    llvm.br ^bb90(%268 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb96:  // pred: ^bb90
    %269 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %270 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %271 = llvm.inttoptr %270 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%269, %271, %37, %38) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb97(%1 : i32)
  ^bb97(%272: i32):  // 2 preds: ^bb96, ^bb102
    %273 = llvm.icmp "sle" %272, %1 : i32
    llvm.cond_br %273, ^bb98, ^bb103
  ^bb98:  // pred: ^bb97
    %274 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb99(%5 : i64)
  ^bb99(%275: i64):  // 2 preds: ^bb98, ^bb100
    %276 = llvm.icmp "slt" %275, %12 : i64
    llvm.cond_br %276, ^bb100, ^bb101
  ^bb100:  // pred: ^bb99
    %277 = llvm.mul %275, %12 : i64
    %278 = llvm.trunc %277 : i64 to i32
    %279 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %280 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %281 = llvm.sext %278 : i32 to i64
    %282 = llvm.getelementptr %280[%281] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %283 = cce.intr.vldsx1.i8(%282, %1, %7, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %284 = cce.vcvtii.ext(%283, %279, %1) : (vector<256xi8>, vector<256xi1>, i32) -> vector<64xi32>
    %285 = cce.vdups(%1, %274, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %286 = cce.cmp(%284, %285, %274) {predicate = "ne"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %287 = llvm.mul %278, %11 : i32
    %288 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %289 = llvm.sext %287 : i32 to i64
    %290 = llvm.getelementptr %288[%289] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %291 = cce.intr.vldsx1.i32(%290, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %292 = cce.vdups(%8, %274, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %293 = cce.vsel(%291, %292, %286) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %294 = llvm.inttoptr %35 : i64 to !llvm.ptr<6>
    %295 = llvm.sext %287 : i32 to i64
    %296 = llvm.getelementptr %294[%295] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%293, %296, %1, %13, %1, %274) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %297 = llvm.add %275, %10 : i64
    llvm.br ^bb99(%297 : i64)
  ^bb101:  // pred: ^bb99
    llvm.br ^bb102
  ^bb102:  // pred: ^bb101
    %298 = llvm.add %272, %0 : i32
    llvm.br ^bb97(%298 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb103:  // pred: ^bb97
    llvm.br ^bb104(%1 : i32)
  ^bb104(%299: i32):  // 2 preds: ^bb103, ^bb109
    %300 = llvm.icmp "sle" %299, %1 : i32
    llvm.cond_br %300, ^bb105, ^bb110
  ^bb105:  // pred: ^bb104
    %dst_14, %restElem_15 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %301 = cce.vdups(%8, %dst_14, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    llvm.br ^bb106(%5, %301 : i64, vector<64xi32>)
  ^bb106(%302: i64, %303: vector<64xi32>):  // 2 preds: ^bb105, ^bb107
    %304 = llvm.icmp "slt" %302, %31 : i64
    llvm.cond_br %304, ^bb107, ^bb108
  ^bb107:  // pred: ^bb106
    %305 = llvm.trunc %302 : i64 to i32
    %306 = llvm.mul %305, %41 : i32
    %307 = llvm.inttoptr %35 : i64 to !llvm.ptr<6>
    %308 = llvm.sext %306 : i32 to i64
    %309 = llvm.getelementptr %307[%308] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %310 = cce.intr.vldsx1.i32(%309, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %311 = cce.vmax(%303, %310, %dst_14) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %312 = llvm.add %302, %10 : i64
    llvm.br ^bb106(%312, %311 : i64, vector<64xi32>)
  ^bb108:  // pred: ^bb106
    %313 = llvm.inttoptr %36 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%303, %313, %1, %13, %1, %dst_14) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb109
  ^bb109:  // pred: ^bb108
    %314 = llvm.add %299, %0 : i32
    llvm.br ^bb104(%314 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb110:  // pred: ^bb104
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %315 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %316 = llvm.inttoptr %315 : i64 to !llvm.ptr<1>
    %317 = llvm.inttoptr %36 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%316, %317, %39, %40) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


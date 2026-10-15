module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_min_d0_i16_s2(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(100 : i32) : i32
    %7 = llvm.mlir.constant(20 : i32) : i32
    %8 = llvm.mlir.constant(32767 : i16) : i16
    %9 = llvm.mlir.constant(30368 : i64) : i64
    %10 = llvm.mlir.constant(1 : index) : i64
    %11 = llvm.mlir.constant(4 : i32) : i32
    %12 = llvm.mlir.constant(64 : index) : i64
    %13 = llvm.mlir.constant(2 : i32) : i32
    %14 = llvm.mlir.constant(32 : i32) : i32
    %15 = llvm.mlir.constant(64 : i32) : i32
    %16 = llvm.mlir.constant(29344 : i64) : i64
    %17 = llvm.mlir.constant(2 : index) : i64
    %18 = llvm.mlir.constant(29856 : i64) : i64
    %19 = llvm.mlir.constant(30624 : i64) : i64
    %20 = llvm.mlir.constant(30880 : i64) : i64
    %21 = llvm.mlir.constant(0 : i8) : i8
    %22 = llvm.mlir.constant(1 : i8) : i8
    %23 = llvm.mlir.constant(3 : i32) : i32
    %24 = llvm.mlir.constant(31136 : i64) : i64
    %25 = llvm.mlir.constant(16384 : i64) : i64
    %26 = llvm.mlir.constant(16 : index) : i64
    %27 = llvm.mlir.constant(256 : i32) : i32
    %28 = llvm.mlir.constant(224 : i32) : i32
    %29 = llvm.mlir.constant(4096 : i32) : i32
    %30 = llvm.mlir.constant(32 : index) : i64
    %31 = llvm.mlir.constant(128 : index) : i64
    %32 = llvm.mlir.constant(20704 : i64) : i64
    %33 = llvm.mlir.constant(25024 : i64) : i64
    %34 = llvm.mlir.constant(16 : i32) : i32
    %35 = llvm.mlir.constant(8192 : i64) : i64
    %36 = llvm.mlir.constant(13 : i32) : i32
    %37 = llvm.mlir.constant(0 : i16) : i16
    %38 = llvm.mlir.constant(31392 : i64) : i64
    %39 = llvm.mlir.constant(288230377493890624 : i64) : i64
    %40 = llvm.mlir.constant(70368744177704 : i64) : i64
    %41 = llvm.mlir.constant(288230377493889040 : i64) : i64
    %42 = llvm.mlir.constant(43980465111080 : i64) : i64
    %43 = cce.get.ctrl -> i64
    %44 = cce.sbitset0(%43, %3) : (i64, i64) -> i64
    cce.set.ctrl(%44) : i64
    %45 = cce.get.ctrl -> i64
    %46 = cce.sbitset1(%45, %2) : (i64, i64) -> i64
    cce.set.ctrl(%46) : i64
    %47 = cce.get_sub_block_idx -> i64
    %48 = llvm.icmp "eq" %47, %4 : i64
    llvm.cond_br %48, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb110
    llvm.return
  ^bb3(%49: i32):  // 2 preds: ^bb1, ^bb5
    %50 = llvm.icmp "sle" %49, %1 : i32
    llvm.cond_br %50, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %51 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %52 = cce.vdups(%1, %51, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %53 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%52, %53, %1, %13, %1, %51) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %54 = llvm.add %49, %0 : i32
    llvm.br ^bb3(%54 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    llvm.br ^bb7(%1 : i32)
  ^bb7(%55: i32):  // 2 preds: ^bb6, ^bb9
    %56 = llvm.icmp "sle" %55, %1 : i32
    llvm.cond_br %56, ^bb8, ^bb10
  ^bb8:  // pred: ^bb7
    %dst, %restElem = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %57 = cce.vdups(%7, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %58 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%57, %58, %1, %13, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %59 = llvm.add %55, %0 : i32
    llvm.br ^bb7(%59 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%60: i32):  // 2 preds: ^bb10, ^bb16
    %61 = llvm.icmp "sle" %60, %1 : i32
    llvm.cond_br %61, ^bb12, ^bb17
  ^bb12:  // pred: ^bb11
    %62 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb13(%5 : i64)
  ^bb13(%63: i64):  // 2 preds: ^bb12, ^bb14
    %64 = llvm.icmp "slt" %63, %17 : i64
    llvm.cond_br %64, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %65 = llvm.mul %63, %12 : i64
    %66 = cce.vdups(%6, %62, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %67 = llvm.trunc %65 : i64 to i32
    %68 = llvm.mul %67, %11 : i32
    %69 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %70 = llvm.sext %68 : i32 to i64
    %71 = llvm.getelementptr %69[%70] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%66, %71, %1, %13, %1, %62) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %72 = llvm.add %63, %10 : i64
    llvm.br ^bb13(%72 : i64)
  ^bb15:  // pred: ^bb13
    llvm.br ^bb16
  ^bb16:  // pred: ^bb15
    %73 = llvm.add %60, %0 : i32
    llvm.br ^bb11(%73 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb17:  // pred: ^bb11
    llvm.br ^bb18(%1 : i32)
  ^bb18(%74: i32):  // 2 preds: ^bb17, ^bb23
    %75 = llvm.icmp "sle" %74, %1 : i32
    llvm.cond_br %75, ^bb19, ^bb24
  ^bb19:  // pred: ^bb18
    %76 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb20(%5 : i64)
  ^bb20(%77: i64):  // 2 preds: ^bb19, ^bb21
    %78 = llvm.icmp "slt" %77, %17 : i64
    llvm.cond_br %78, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %79 = llvm.mul %77, %12 : i64
    %80 = llvm.trunc %79 : i64 to i32
    %81 = cce.vci(%80, %1) : (i32, i32) -> vector<64xi32>
    %82 = llvm.mul %80, %11 : i32
    %83 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %84 = llvm.sext %82 : i32 to i64
    %85 = llvm.getelementptr %83[%84] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%81, %85, %1, %13, %1, %76) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %86 = llvm.add %77, %10 : i64
    llvm.br ^bb20(%86 : i64)
  ^bb22:  // pred: ^bb20
    llvm.br ^bb23
  ^bb23:  // pred: ^bb22
    %87 = llvm.add %74, %0 : i32
    llvm.br ^bb18(%87 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb24:  // pred: ^bb18
    llvm.br ^bb25(%1 : i32)
  ^bb25(%88: i32):  // 2 preds: ^bb24, ^bb27
    %89 = llvm.icmp "sle" %88, %1 : i32
    llvm.cond_br %89, ^bb26, ^bb28
  ^bb26:  // pred: ^bb25
    %90 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %91 = cce.vdups(%1, %90, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %92 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%91, %92, %1, %13, %1, %90) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb27
  ^bb27:  // pred: ^bb26
    %93 = llvm.add %88, %0 : i32
    llvm.br ^bb25(%93 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb28:  // pred: ^bb25
    llvm.br ^bb29(%1 : i32)
  ^bb29(%94: i32):  // 2 preds: ^bb28, ^bb31
    %95 = llvm.icmp "sle" %94, %1 : i32
    llvm.cond_br %95, ^bb30, ^bb32
  ^bb30:  // pred: ^bb29
    %96 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %97 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%96, %97, %1, %13, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb31
  ^bb31:  // pred: ^bb30
    %98 = llvm.add %94, %0 : i32
    llvm.br ^bb29(%98 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb32:  // pred: ^bb29
    llvm.br ^bb33(%1 : i32)
  ^bb33(%99: i32):  // 2 preds: ^bb32, ^bb35
    %100 = llvm.icmp "sle" %99, %1 : i32
    llvm.cond_br %100, ^bb34, ^bb36
  ^bb34:  // pred: ^bb33
    %101 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %102 = cce.vdups(%21, %101, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %103 = cce.cmp(%102, %102, %101) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %104 = cce.vdups(%22, %101, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %105 = cce.vsel(%104, %102, %103) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %106 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%105, %106, %1, %1, %1, %101) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb35
  ^bb35:  // pred: ^bb34
    %107 = llvm.add %99, %0 : i32
    llvm.br ^bb33(%107 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb36:  // pred: ^bb33
    llvm.br ^bb37(%1 : i32)
  ^bb37(%108: i32):  // 2 preds: ^bb36, ^bb42
    %109 = llvm.icmp "sle" %108, %1 : i32
    llvm.cond_br %109, ^bb38, ^bb43
  ^bb38:  // pred: ^bb37
    %110 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %111 = cce.vdups(%1, %110, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %112 = cce.vdups(%0, %110, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %dst_2, %restElem_3 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb39(%5 : i64)
  ^bb39(%113: i64):  // 2 preds: ^bb38, ^bb40
    %114 = llvm.icmp "slt" %113, %17 : i64
    llvm.cond_br %114, ^bb40, ^bb41
  ^bb40:  // pred: ^bb39
    %115 = llvm.trunc %113 : i64 to i32
    %116 = llvm.mul %115, %15 : i32
    %117 = llvm.mul %115, %27 : i32
    %118 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %119 = llvm.sext %117 : i32 to i64
    %120 = llvm.getelementptr %118[%119] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %121 = cce.intr.vldsx1.i32(%120, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %122 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %123 = llvm.sext %117 : i32 to i64
    %124 = llvm.getelementptr %122[%123] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %125 = cce.intr.vldsx1.i32(%124, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %126 = cce.cmp(%121, %125, %110) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %127 = cce.vsel(%112, %111, %126) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %128 = cce.vpack(%127, %1) : (vector<64xi32>, i32) -> vector<128xi16>
    %129 = cce.vpack(%128, %1) : (vector<128xi16>, i32) -> vector<256xi8>
    %130 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %131 = llvm.sext %116 : i32 to i64
    %132 = llvm.getelementptr %130[%131] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%129, %132, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %133 = llvm.add %113, %10 : i64
    llvm.br ^bb39(%133 : i64)
  ^bb41:  // pred: ^bb39
    llvm.br ^bb42
  ^bb42:  // pred: ^bb41
    %134 = llvm.add %108, %0 : i32
    llvm.br ^bb37(%134 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb43:  // pred: ^bb37
    llvm.br ^bb44(%1 : i32)
  ^bb44(%135: i32):  // 2 preds: ^bb43, ^bb46
    %136 = llvm.icmp "sle" %135, %1 : i32
    llvm.cond_br %136, ^bb45, ^bb47
  ^bb45:  // pred: ^bb44
    %137 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %138 = cce.vdups(%21, %137, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %139 = cce.cmp(%138, %138, %137) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %140 = cce.vdups(%22, %137, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %141 = cce.vsel(%140, %138, %139) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %142 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%141, %142, %1, %1, %1, %137) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb46
  ^bb46:  // pred: ^bb45
    %143 = llvm.add %135, %0 : i32
    llvm.br ^bb44(%143 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb47:  // pred: ^bb44
    llvm.br ^bb48(%1 : i32)
  ^bb48(%144: i32):  // 2 preds: ^bb47, ^bb50
    %145 = llvm.icmp "sle" %144, %1 : i32
    llvm.cond_br %145, ^bb49, ^bb51
  ^bb49:  // pred: ^bb48
    %146 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %147 = cce.intr.vldsx1.i32(%146, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %148 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %149 = cce.intr.vldsx1.i32(%148, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %150 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %151 = cce.cmp(%149, %147, %150) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %152 = cce.ppack(%151, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %153 = cce.ppack(%152, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %154 = cce.vdups(%21, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %155 = cce.vdups(%22, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %156 = cce.vsel(%155, %154, %153) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %157 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%156, %157, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb50
  ^bb50:  // pred: ^bb49
    %158 = llvm.add %144, %0 : i32
    llvm.br ^bb48(%158 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb51:  // pred: ^bb48
    llvm.br ^bb52(%1 : i32)
  ^bb52(%159: i32):  // 2 preds: ^bb51, ^bb57
    %160 = llvm.icmp "sle" %159, %1 : i32
    llvm.cond_br %160, ^bb53, ^bb58
  ^bb53:  // pred: ^bb52
    %161 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %162 = cce.vdups(%21, %161, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb54(%5 : i64)
  ^bb54(%163: i64):  // 2 preds: ^bb53, ^bb55
    %164 = llvm.icmp "slt" %163, %26 : i64
    llvm.cond_br %164, ^bb55, ^bb56
  ^bb55:  // pred: ^bb54
    %165 = llvm.trunc %163 : i64 to i32
    %166 = llvm.mul %165, %27 : i32
    %167 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %168 = llvm.sext %166 : i32 to i64
    %169 = llvm.getelementptr %167[%168] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%162, %169, %1, %1, %1, %161) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %170 = llvm.add %163, %10 : i64
    llvm.br ^bb54(%170 : i64)
  ^bb56:  // pred: ^bb54
    %dst_6, %restElem_7 = cce.plt(%28) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %171 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %172 = llvm.getelementptr %171[4096] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%162, %172, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb57
  ^bb57:  // pred: ^bb56
    %173 = llvm.add %159, %0 : i32
    llvm.br ^bb52(%173 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb58:  // pred: ^bb52
    llvm.br ^bb59(%1 : i32)
  ^bb59(%174: i32):  // 2 preds: ^bb58, ^bb64
    %175 = llvm.icmp "sle" %174, %1 : i32
    llvm.cond_br %175, ^bb60, ^bb65
  ^bb60:  // pred: ^bb59
    %dst_8, %restElem_9 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb61(%5 : i64)
  ^bb61(%176: i64):  // 2 preds: ^bb60, ^bb62
    %177 = llvm.icmp "slt" %176, %31 : i64
    llvm.cond_br %177, ^bb62, ^bb63
  ^bb62:  // pred: ^bb61
    %178 = llvm.trunc %176 : i64 to i32
    %179 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %180 = llvm.sext %178 : i32 to i64
    %181 = llvm.getelementptr %179[%180] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %182 = cce.intr.vldsx1.i8(%181, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %183 = llvm.mul %178, %14 : i32
    %184 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %185 = llvm.sext %183 : i32 to i64
    %186 = llvm.getelementptr %184[%185] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%182, %186, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %187 = llvm.add %176, %10 : i64
    llvm.br ^bb61(%187 : i64)
  ^bb63:  // pred: ^bb61
    llvm.br ^bb64
  ^bb64:  // pred: ^bb63
    %188 = llvm.add %174, %0 : i32
    llvm.br ^bb59(%188 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb65:  // pred: ^bb59
    llvm.br ^bb66(%1 : i32)
  ^bb66(%189: i32):  // 2 preds: ^bb65, ^bb71
    %190 = llvm.icmp "sle" %189, %1 : i32
    llvm.cond_br %190, ^bb67, ^bb72
  ^bb67:  // pred: ^bb66
    %191 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %192 = cce.vdups(%21, %191, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%193: i64):  // 2 preds: ^bb67, ^bb69
    %194 = llvm.icmp "slt" %193, %26 : i64
    llvm.cond_br %194, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %195 = llvm.trunc %193 : i64 to i32
    %196 = llvm.mul %195, %27 : i32
    %197 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %198 = llvm.sext %196 : i32 to i64
    %199 = llvm.getelementptr %197[%198] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%192, %199, %1, %1, %1, %191) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %200 = llvm.add %193, %10 : i64
    llvm.br ^bb68(%200 : i64)
  ^bb70:  // pred: ^bb68
    %dst_10, %restElem_11 = cce.plt(%28) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %201 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %202 = llvm.getelementptr %201[4096] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%192, %202, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb71
  ^bb71:  // pred: ^bb70
    %203 = llvm.add %189, %0 : i32
    llvm.br ^bb66(%203 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb72:  // pred: ^bb66
    llvm.br ^bb73(%1 : i32)
  ^bb73(%204: i32):  // 2 preds: ^bb72, ^bb81
    %205 = llvm.icmp "sle" %204, %1 : i32
    llvm.cond_br %205, ^bb74, ^bb82
  ^bb74:  // pred: ^bb73
    %206 = cce.pset(%13) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb75(%5 : i64)
  ^bb75(%207: i64):  // 2 preds: ^bb74, ^bb79
    %208 = llvm.icmp "slt" %207, %30 : i64
    llvm.cond_br %208, ^bb76, ^bb80
  ^bb76:  // pred: ^bb75
    %209 = llvm.trunc %207 : i64 to i32
    %210 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    %211 = llvm.sext %209 : i32 to i64
    %212 = llvm.getelementptr %210[%211] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %213 = cce.intr.vldsx1.i8(%212, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb77(%5 : i64)
  ^bb77(%214: i64):  // 2 preds: ^bb76, ^bb78
    %215 = llvm.icmp "slt" %214, %31 : i64
    llvm.cond_br %215, ^bb78, ^bb79
  ^bb78:  // pred: ^bb77
    %216 = llvm.trunc %214 : i64 to i32
    %217 = llvm.mul %216, %14 : i32
    %218 = llvm.add %217, %209 : i32
    %219 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %220 = llvm.sext %218 : i32 to i64
    %221 = llvm.getelementptr %219[%220] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%213, %221, %1, %23, %1, %206) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %222 = llvm.add %214, %10 : i64
    llvm.br ^bb77(%222 : i64)
  ^bb79:  // pred: ^bb77
    %223 = llvm.add %207, %10 : i64
    llvm.br ^bb75(%223 : i64)
  ^bb80:  // pred: ^bb75
    llvm.br ^bb81
  ^bb81:  // pred: ^bb80
    %224 = llvm.add %204, %0 : i32
    llvm.br ^bb73(%224 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb82:  // pred: ^bb73
    llvm.br ^bb83(%1 : i32)
  ^bb83(%225: i32):  // 2 preds: ^bb82, ^bb88
    %226 = llvm.icmp "sle" %225, %1 : i32
    llvm.cond_br %226, ^bb84, ^bb89
  ^bb84:  // pred: ^bb83
    %227 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %228 = cce.vdups(%21, %227, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb85(%5 : i64)
  ^bb85(%229: i64):  // 2 preds: ^bb84, ^bb86
    %230 = llvm.icmp "slt" %229, %26 : i64
    llvm.cond_br %230, ^bb86, ^bb87
  ^bb86:  // pred: ^bb85
    %231 = llvm.trunc %229 : i64 to i32
    %232 = llvm.mul %231, %27 : i32
    %233 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %234 = llvm.sext %232 : i32 to i64
    %235 = llvm.getelementptr %233[%234] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%228, %235, %1, %1, %1, %227) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %236 = llvm.add %229, %10 : i64
    llvm.br ^bb85(%236 : i64)
  ^bb87:  // pred: ^bb85
    %dst_12, %restElem_13 = cce.plt(%28) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %237 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %238 = llvm.getelementptr %237[4096] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%228, %238, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb88
  ^bb88:  // pred: ^bb87
    %239 = llvm.add %225, %0 : i32
    llvm.br ^bb83(%239 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb89:  // pred: ^bb83
    llvm.br ^bb90(%1 : i32)
  ^bb90(%240: i32):  // 2 preds: ^bb89, ^bb95
    %241 = llvm.icmp "sle" %240, %1 : i32
    llvm.cond_br %241, ^bb91, ^bb96
  ^bb91:  // pred: ^bb90
    %242 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb92(%5 : i64)
  ^bb92(%243: i64):  // 2 preds: ^bb91, ^bb93
    %244 = llvm.icmp "slt" %243, %26 : i64
    llvm.cond_br %244, ^bb93, ^bb94
  ^bb93:  // pred: ^bb92
    %245 = llvm.trunc %243 : i64 to i32
    %246 = llvm.udiv %245, %34 : i32
    %247 = llvm.urem %245, %34 : i32
    %248 = llvm.mul %247, %27 : i32
    %249 = llvm.mul %246, %29 : i32
    %250 = llvm.add %249, %248 : i32
    %251 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %252 = llvm.sext %250 : i32 to i64
    %253 = llvm.getelementptr %251[%252] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %254 = cce.intr.vldsx1.i8(%253, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %255 = cce.vdups(%21, %242, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %256 = cce.cmp(%254, %255, %242) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %257 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %258 = llvm.sext %250 : i32 to i64
    %259 = llvm.getelementptr %257[%258] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %260 = cce.intr.vldsx1.i8(%259, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %261 = cce.cmp(%260, %255, %242) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %262 = cce.pand(%256, %261, %242) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %263 = cce.vdups(%22, %242, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %264 = cce.vsel(%263, %255, %262) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %265 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %266 = llvm.sext %250 : i32 to i64
    %267 = llvm.getelementptr %265[%266] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%264, %267, %1, %1, %1, %242) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %268 = llvm.add %243, %10 : i64
    llvm.br ^bb92(%268 : i64)
  ^bb94:  // pred: ^bb92
    llvm.br ^bb95
  ^bb95:  // pred: ^bb94
    %269 = llvm.add %240, %0 : i32
    llvm.br ^bb90(%269 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb96:  // pred: ^bb90
    %270 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %271 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %272 = llvm.inttoptr %271 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%270, %272, %39, %40) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb97(%1 : i32)
  ^bb97(%273: i32):  // 2 preds: ^bb96, ^bb102
    %274 = llvm.icmp "sle" %273, %1 : i32
    llvm.cond_br %274, ^bb98, ^bb103
  ^bb98:  // pred: ^bb97
    %275 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb99(%5 : i64)
  ^bb99(%276: i64):  // 2 preds: ^bb98, ^bb100
    %277 = llvm.icmp "slt" %276, %30 : i64
    llvm.cond_br %277, ^bb100, ^bb101
  ^bb100:  // pred: ^bb99
    %278 = llvm.mul %276, %31 : i64
    %279 = llvm.trunc %278 : i64 to i32
    %280 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %281 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %282 = llvm.sext %279 : i32 to i64
    %283 = llvm.getelementptr %281[%282] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %284 = cce.intr.vldsx1.i8(%283, %1, %36, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %285 = cce.vcvtii.ext(%284, %280, %1) {unsigned} : (vector<256xi8>, vector<256xi1>, i32) -> vector<128xi16>
    %286 = cce.vdups(%37, %275, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %287 = cce.cmp(%285, %286, %275) {predicate = "ne"} : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<256xi1>
    %288 = llvm.mul %279, %13 : i32
    %289 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %290 = llvm.sext %288 : i32 to i64
    %291 = llvm.getelementptr %289[%290] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %292 = cce.intr.vldsx1.i16(%291, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xi16>
    %293 = cce.vdups(%8, %275, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %294 = cce.vsel(%292, %293, %287) : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<128xi16>
    %295 = llvm.inttoptr %35 : i64 to !llvm.ptr<6>
    %296 = llvm.sext %288 : i32 to i64
    %297 = llvm.getelementptr %295[%296] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i16(%294, %297, %1, %0, %1, %275) : (vector<128xi16>, <6>, i32, i32, i32, vector<256xi1>)
    %298 = llvm.add %276, %10 : i64
    llvm.br ^bb99(%298 : i64)
  ^bb101:  // pred: ^bb99
    llvm.br ^bb102
  ^bb102:  // pred: ^bb101
    %299 = llvm.add %273, %0 : i32
    llvm.br ^bb97(%299 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb103:  // pred: ^bb97
    llvm.br ^bb104(%1 : i32)
  ^bb104(%300: i32):  // 2 preds: ^bb103, ^bb109
    %301 = llvm.icmp "sle" %300, %1 : i32
    llvm.cond_br %301, ^bb105, ^bb110
  ^bb105:  // pred: ^bb104
    %dst_14, %restElem_15 = cce.plt(%14) {mask_bitwidth = 16 : i32} : (i32) -> (vector<256xi1>, i32)
    %302 = cce.vdups(%8, %dst_14, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    llvm.br ^bb106(%5, %302 : i64, vector<128xi16>)
  ^bb106(%303: i64, %304: vector<128xi16>):  // 2 preds: ^bb105, ^bb107
    %305 = llvm.icmp "slt" %303, %31 : i64
    llvm.cond_br %305, ^bb107, ^bb108
  ^bb107:  // pred: ^bb106
    %306 = llvm.trunc %303 : i64 to i32
    %307 = llvm.mul %306, %15 : i32
    %308 = llvm.inttoptr %35 : i64 to !llvm.ptr<6>
    %309 = llvm.sext %307 : i32 to i64
    %310 = llvm.getelementptr %308[%309] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %311 = cce.intr.vldsx1.i16(%310, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xi16>
    %312 = cce.vmin(%304, %311, %dst_14) : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<128xi16>
    %313 = llvm.add %303, %10 : i64
    llvm.br ^bb106(%313, %312 : i64, vector<128xi16>)
  ^bb108:  // pred: ^bb106
    %314 = llvm.inttoptr %38 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i16(%304, %314, %1, %0, %1, %dst_14) : (vector<128xi16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb109
  ^bb109:  // pred: ^bb108
    %315 = llvm.add %300, %0 : i32
    llvm.br ^bb104(%315 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb110:  // pred: ^bb104
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %316 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %317 = llvm.inttoptr %316 : i64 to !llvm.ptr<1>
    %318 = llvm.inttoptr %38 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%317, %318, %41, %42) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


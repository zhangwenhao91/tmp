module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_max_d1_i16(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(16 : index) : i64
    %7 = llvm.mlir.constant(64 : index) : i64
    %8 = llvm.mlir.constant(64 : i32) : i32
    %9 = llvm.mlir.constant(16 : i32) : i32
    %10 = llvm.mlir.constant(-32768 : i16) : i16
    %11 = llvm.mlir.constant(15008 : i64) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(4 : i32) : i32
    %14 = llvm.mlir.constant(2 : i32) : i32
    %15 = llvm.mlir.constant(32 : i32) : i32
    %16 = llvm.mlir.constant(15264 : i64) : i64
    %17 = llvm.mlir.constant(15520 : i64) : i64
    %18 = llvm.mlir.constant(15776 : i64) : i64
    %19 = llvm.mlir.constant(16032 : i64) : i64
    %20 = llvm.mlir.constant(0 : i8) : i8
    %21 = llvm.mlir.constant(1 : i8) : i8
    %22 = llvm.mlir.constant(16288 : i64) : i64
    %23 = llvm.mlir.constant(8192 : i64) : i64
    %24 = llvm.mlir.constant(8 : index) : i64
    %25 = llvm.mlir.constant(256 : i32) : i32
    %26 = llvm.mlir.constant(224 : i32) : i32
    %27 = llvm.mlir.constant(2048 : i32) : i32
    %28 = llvm.mlir.constant(32 : index) : i64
    %29 = llvm.mlir.constant(3 : i32) : i32
    %30 = llvm.mlir.constant(10464 : i64) : i64
    %31 = llvm.mlir.constant(12736 : i64) : i64
    %32 = llvm.mlir.constant(8 : i32) : i32
    %33 = llvm.mlir.constant(4096 : i64) : i64
    %34 = llvm.mlir.constant(128 : index) : i64
    %35 = llvm.mlir.constant(13 : i32) : i32
    %36 = llvm.mlir.constant(0 : i16) : i16
    %37 = llvm.mlir.constant(16544 : i64) : i64
    %38 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %39 = llvm.mlir.constant(35184372088864 : i64) : i64
    %40 = llvm.mlir.constant(288230377225454592 : i64) : i64
    %41 = llvm.mlir.constant(70368744177696 : i64) : i64
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
  ^bb2:  // 2 preds: ^bb0, ^bb101
    llvm.return
  ^bb3(%48: i32):  // 2 preds: ^bb1, ^bb5
    %49 = llvm.icmp "sle" %48, %1 : i32
    llvm.cond_br %49, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %50 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %51 = cce.vdups(%1, %50, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %52 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%51, %52, %1, %14, %1, %50) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
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
    %dst, %restElem = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %56 = cce.vdups(%9, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %57 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%56, %57, %1, %14, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %58 = llvm.add %54, %0 : i32
    llvm.br ^bb7(%58 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%59: i32):  // 2 preds: ^bb10, ^bb13
    %60 = llvm.icmp "sle" %59, %1 : i32
    llvm.cond_br %60, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %61 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %62 = cce.vdups(%8, %61, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %63 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%62, %63, %1, %14, %1, %61) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %64 = llvm.add %59, %0 : i32
    llvm.br ^bb11(%64 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%65: i32):  // 2 preds: ^bb14, ^bb17
    %66 = llvm.icmp "sle" %65, %1 : i32
    llvm.cond_br %66, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %67 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %68 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %69 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%68, %69, %1, %14, %1, %67) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb17
  ^bb17:  // pred: ^bb16
    %70 = llvm.add %65, %0 : i32
    llvm.br ^bb15(%70 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb18:  // pred: ^bb15
    llvm.br ^bb19(%1 : i32)
  ^bb19(%71: i32):  // 2 preds: ^bb18, ^bb21
    %72 = llvm.icmp "sle" %71, %1 : i32
    llvm.cond_br %72, ^bb20, ^bb22
  ^bb20:  // pred: ^bb19
    %73 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %74 = cce.vdups(%1, %73, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %75 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%74, %75, %1, %14, %1, %73) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %76 = llvm.add %71, %0 : i32
    llvm.br ^bb19(%76 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%77: i32):  // 2 preds: ^bb22, ^bb25
    %78 = llvm.icmp "sle" %77, %1 : i32
    llvm.cond_br %78, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %79 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %80 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%79, %80, %1, %14, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %81 = llvm.add %77, %0 : i32
    llvm.br ^bb23(%81 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%82: i32):  // 2 preds: ^bb26, ^bb29
    %83 = llvm.icmp "sle" %82, %1 : i32
    llvm.cond_br %83, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %84 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %85 = cce.vdups(%20, %84, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %86 = cce.cmp(%85, %85, %84) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %87 = cce.vdups(%21, %84, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %88 = cce.vsel(%87, %85, %86) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %89 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%88, %89, %1, %1, %1, %84) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb29
  ^bb29:  // pred: ^bb28
    %90 = llvm.add %82, %0 : i32
    llvm.br ^bb27(%90 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb30:  // pred: ^bb27
    llvm.br ^bb31(%1 : i32)
  ^bb31(%91: i32):  // 2 preds: ^bb30, ^bb33
    %92 = llvm.icmp "sle" %91, %1 : i32
    llvm.cond_br %92, ^bb32, ^bb34
  ^bb32:  // pred: ^bb31
    %93 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %94 = cce.intr.vldsx1.i32(%93, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %95 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %96 = cce.intr.vldsx1.i32(%95, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %97 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %98 = cce.cmp(%96, %94, %97) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%8) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %99 = cce.ppack(%98, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %100 = cce.ppack(%99, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %101 = cce.vdups(%20, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %102 = cce.vdups(%21, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %103 = cce.vsel(%102, %101, %100) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %104 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%103, %104, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb33
  ^bb33:  // pred: ^bb32
    %105 = llvm.add %91, %0 : i32
    llvm.br ^bb31(%105 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb34:  // pred: ^bb31
    llvm.br ^bb35(%1 : i32)
  ^bb35(%106: i32):  // 2 preds: ^bb34, ^bb37
    %107 = llvm.icmp "sle" %106, %1 : i32
    llvm.cond_br %107, ^bb36, ^bb38
  ^bb36:  // pred: ^bb35
    %108 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %109 = cce.vdups(%20, %108, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %110 = cce.cmp(%109, %109, %108) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %111 = cce.vdups(%21, %108, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %112 = cce.vsel(%111, %109, %110) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %113 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%112, %113, %1, %1, %1, %108) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb37
  ^bb37:  // pred: ^bb36
    %114 = llvm.add %106, %0 : i32
    llvm.br ^bb35(%114 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb38:  // pred: ^bb35
    llvm.br ^bb39(%1 : i32)
  ^bb39(%115: i32):  // 2 preds: ^bb38, ^bb41
    %116 = llvm.icmp "sle" %115, %1 : i32
    llvm.cond_br %116, ^bb40, ^bb42
  ^bb40:  // pred: ^bb39
    %117 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %118 = cce.intr.vldsx1.i32(%117, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %119 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %120 = cce.intr.vldsx1.i32(%119, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %121 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %122 = cce.cmp(%120, %118, %121) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %123 = cce.ppack(%122, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %124 = cce.ppack(%123, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %125 = cce.vdups(%20, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %126 = cce.vdups(%21, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %127 = cce.vsel(%126, %125, %124) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %128 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%127, %128, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb41
  ^bb41:  // pred: ^bb40
    %129 = llvm.add %115, %0 : i32
    llvm.br ^bb39(%129 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb42:  // pred: ^bb39
    llvm.br ^bb43(%1 : i32)
  ^bb43(%130: i32):  // 2 preds: ^bb42, ^bb48
    %131 = llvm.icmp "sle" %130, %1 : i32
    llvm.cond_br %131, ^bb44, ^bb49
  ^bb44:  // pred: ^bb43
    %132 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %133 = cce.vdups(%20, %132, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%134: i64):  // 2 preds: ^bb44, ^bb46
    %135 = llvm.icmp "slt" %134, %24 : i64
    llvm.cond_br %135, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %136 = llvm.trunc %134 : i64 to i32
    %137 = llvm.mul %136, %25 : i32
    %138 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %139 = llvm.sext %137 : i32 to i64
    %140 = llvm.getelementptr %138[%139] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%133, %140, %1, %1, %1, %132) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %141 = llvm.add %134, %12 : i64
    llvm.br ^bb45(%141 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %142 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %143 = llvm.getelementptr %142[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%133, %143, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    %144 = llvm.add %130, %0 : i32
    llvm.br ^bb43(%144 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb49:  // pred: ^bb43
    llvm.br ^bb50(%1 : i32)
  ^bb50(%145: i32):  // 2 preds: ^bb49, ^bb55
    %146 = llvm.icmp "sle" %145, %1 : i32
    llvm.cond_br %146, ^bb51, ^bb56
  ^bb51:  // pred: ^bb50
    %dst_8, %restElem_9 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%147: i64):  // 2 preds: ^bb51, ^bb53
    %148 = llvm.icmp "slt" %147, %7 : i64
    llvm.cond_br %148, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %149 = llvm.trunc %147 : i64 to i32
    %150 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %151 = llvm.sext %149 : i32 to i64
    %152 = llvm.getelementptr %150[%151] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %153 = cce.intr.vldsx1.i8(%152, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %154 = llvm.mul %149, %15 : i32
    %155 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %156 = llvm.sext %154 : i32 to i64
    %157 = llvm.getelementptr %155[%156] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%153, %157, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %158 = llvm.add %147, %12 : i64
    llvm.br ^bb52(%158 : i64)
  ^bb54:  // pred: ^bb52
    llvm.br ^bb55
  ^bb55:  // pred: ^bb54
    %159 = llvm.add %145, %0 : i32
    llvm.br ^bb50(%159 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb56:  // pred: ^bb50
    llvm.br ^bb57(%1 : i32)
  ^bb57(%160: i32):  // 2 preds: ^bb56, ^bb62
    %161 = llvm.icmp "sle" %160, %1 : i32
    llvm.cond_br %161, ^bb58, ^bb63
  ^bb58:  // pred: ^bb57
    %162 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %163 = cce.vdups(%20, %162, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%164: i64):  // 2 preds: ^bb58, ^bb60
    %165 = llvm.icmp "slt" %164, %24 : i64
    llvm.cond_br %165, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %166 = llvm.trunc %164 : i64 to i32
    %167 = llvm.mul %166, %25 : i32
    %168 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %169 = llvm.sext %167 : i32 to i64
    %170 = llvm.getelementptr %168[%169] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%163, %170, %1, %1, %1, %162) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %171 = llvm.add %164, %12 : i64
    llvm.br ^bb59(%171 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %172 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %173 = llvm.getelementptr %172[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%163, %173, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %174 = llvm.add %160, %0 : i32
    llvm.br ^bb57(%174 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%175: i32):  // 2 preds: ^bb63, ^bb72
    %176 = llvm.icmp "sle" %175, %1 : i32
    llvm.cond_br %176, ^bb65, ^bb73
  ^bb65:  // pred: ^bb64
    %177 = cce.pset(%14) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb66(%5 : i64)
  ^bb66(%178: i64):  // 2 preds: ^bb65, ^bb70
    %179 = llvm.icmp "slt" %178, %28 : i64
    llvm.cond_br %179, ^bb67, ^bb71
  ^bb67:  // pred: ^bb66
    %180 = llvm.trunc %178 : i64 to i32
    %181 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %182 = llvm.sext %180 : i32 to i64
    %183 = llvm.getelementptr %181[%182] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %184 = cce.intr.vldsx1.i8(%183, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%185: i64):  // 2 preds: ^bb67, ^bb69
    %186 = llvm.icmp "slt" %185, %7 : i64
    llvm.cond_br %186, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %187 = llvm.trunc %185 : i64 to i32
    %188 = llvm.mul %187, %15 : i32
    %189 = llvm.add %188, %180 : i32
    %190 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %191 = llvm.sext %189 : i32 to i64
    %192 = llvm.getelementptr %190[%191] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%184, %192, %1, %29, %1, %177) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %193 = llvm.add %185, %12 : i64
    llvm.br ^bb68(%193 : i64)
  ^bb70:  // pred: ^bb68
    %194 = llvm.add %178, %12 : i64
    llvm.br ^bb66(%194 : i64)
  ^bb71:  // pred: ^bb66
    llvm.br ^bb72
  ^bb72:  // pred: ^bb71
    %195 = llvm.add %175, %0 : i32
    llvm.br ^bb64(%195 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb73:  // pred: ^bb64
    llvm.br ^bb74(%1 : i32)
  ^bb74(%196: i32):  // 2 preds: ^bb73, ^bb79
    %197 = llvm.icmp "sle" %196, %1 : i32
    llvm.cond_br %197, ^bb75, ^bb80
  ^bb75:  // pred: ^bb74
    %198 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %199 = cce.vdups(%20, %198, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb76(%5 : i64)
  ^bb76(%200: i64):  // 2 preds: ^bb75, ^bb77
    %201 = llvm.icmp "slt" %200, %24 : i64
    llvm.cond_br %201, ^bb77, ^bb78
  ^bb77:  // pred: ^bb76
    %202 = llvm.trunc %200 : i64 to i32
    %203 = llvm.mul %202, %25 : i32
    %204 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %205 = llvm.sext %203 : i32 to i64
    %206 = llvm.getelementptr %204[%205] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%199, %206, %1, %1, %1, %198) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %207 = llvm.add %200, %12 : i64
    llvm.br ^bb76(%207 : i64)
  ^bb78:  // pred: ^bb76
    %dst_12, %restElem_13 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %208 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %209 = llvm.getelementptr %208[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%199, %209, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb79
  ^bb79:  // pred: ^bb78
    %210 = llvm.add %196, %0 : i32
    llvm.br ^bb74(%210 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb80:  // pred: ^bb74
    llvm.br ^bb81(%1 : i32)
  ^bb81(%211: i32):  // 2 preds: ^bb80, ^bb86
    %212 = llvm.icmp "sle" %211, %1 : i32
    llvm.cond_br %212, ^bb82, ^bb87
  ^bb82:  // pred: ^bb81
    %213 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb83(%5 : i64)
  ^bb83(%214: i64):  // 2 preds: ^bb82, ^bb84
    %215 = llvm.icmp "slt" %214, %24 : i64
    llvm.cond_br %215, ^bb84, ^bb85
  ^bb84:  // pred: ^bb83
    %216 = llvm.trunc %214 : i64 to i32
    %217 = llvm.udiv %216, %32 : i32
    %218 = llvm.urem %216, %32 : i32
    %219 = llvm.mul %218, %25 : i32
    %220 = llvm.mul %217, %27 : i32
    %221 = llvm.add %220, %219 : i32
    %222 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %223 = llvm.sext %221 : i32 to i64
    %224 = llvm.getelementptr %222[%223] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %225 = cce.intr.vldsx1.i8(%224, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %226 = cce.vdups(%20, %213, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %227 = cce.cmp(%225, %226, %213) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %228 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %229 = llvm.sext %221 : i32 to i64
    %230 = llvm.getelementptr %228[%229] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %231 = cce.intr.vldsx1.i8(%230, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %232 = cce.cmp(%231, %226, %213) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %233 = cce.pand(%227, %232, %213) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %234 = cce.vdups(%21, %213, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %235 = cce.vsel(%234, %226, %233) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %236 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %237 = llvm.sext %221 : i32 to i64
    %238 = llvm.getelementptr %236[%237] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%235, %238, %1, %1, %1, %213) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %239 = llvm.add %214, %12 : i64
    llvm.br ^bb83(%239 : i64)
  ^bb85:  // pred: ^bb83
    llvm.br ^bb86
  ^bb86:  // pred: ^bb85
    %240 = llvm.add %211, %0 : i32
    llvm.br ^bb81(%240 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb87:  // pred: ^bb81
    %241 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %242 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %243 = llvm.inttoptr %242 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%241, %243, %40, %41) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb88(%1 : i32)
  ^bb88(%244: i32):  // 2 preds: ^bb87, ^bb93
    %245 = llvm.icmp "sle" %244, %1 : i32
    llvm.cond_br %245, ^bb89, ^bb94
  ^bb89:  // pred: ^bb88
    %246 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb90(%5 : i64)
  ^bb90(%247: i64):  // 2 preds: ^bb89, ^bb91
    %248 = llvm.icmp "slt" %247, %6 : i64
    llvm.cond_br %248, ^bb91, ^bb92
  ^bb91:  // pred: ^bb90
    %249 = llvm.mul %247, %34 : i64
    %250 = llvm.trunc %249 : i64 to i32
    %251 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %252 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %253 = llvm.sext %250 : i32 to i64
    %254 = llvm.getelementptr %252[%253] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %255 = cce.intr.vldsx1.i8(%254, %1, %35, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %256 = cce.vcvtii.ext(%255, %251, %1) {unsigned} : (vector<256xi8>, vector<256xi1>, i32) -> vector<128xi16>
    %257 = cce.vdups(%36, %246, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %258 = cce.cmp(%256, %257, %246) {predicate = "ne"} : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<256xi1>
    %259 = llvm.mul %250, %14 : i32
    %260 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %261 = llvm.sext %259 : i32 to i64
    %262 = llvm.getelementptr %260[%261] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %263 = cce.intr.vldsx1.i16(%262, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xi16>
    %264 = cce.vdups(%10, %246, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %265 = cce.vsel(%263, %264, %258) : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<128xi16>
    %266 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %267 = llvm.sext %259 : i32 to i64
    %268 = llvm.getelementptr %266[%267] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i16(%265, %268, %1, %0, %1, %246) : (vector<128xi16>, <6>, i32, i32, i32, vector<256xi1>)
    %269 = llvm.add %247, %12 : i64
    llvm.br ^bb90(%269 : i64)
  ^bb92:  // pred: ^bb90
    llvm.br ^bb93
  ^bb93:  // pred: ^bb92
    %270 = llvm.add %244, %0 : i32
    llvm.br ^bb88(%270 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb94:  // pred: ^bb88
    llvm.br ^bb95(%1 : i32)
  ^bb95(%271: i32):  // 2 preds: ^bb94, ^bb100
    %272 = llvm.icmp "sle" %271, %1 : i32
    llvm.cond_br %272, ^bb96, ^bb101
  ^bb96:  // pred: ^bb95
    %dst_14, %restElem_15 = cce.plt(%15) {mask_bitwidth = 16 : i32} : (i32) -> (vector<256xi1>, i32)
    %273 = cce.pset(%14) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb97(%5 : i64)
  ^bb97(%274: i64):  // 2 preds: ^bb96, ^bb98
    %275 = llvm.icmp "slt" %274, %7 : i64
    llvm.cond_br %275, ^bb98, ^bb99
  ^bb98:  // pred: ^bb97
    %276 = llvm.trunc %274 : i64 to i32
    %277 = llvm.mul %276, %8 : i32
    %278 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %279 = llvm.sext %277 : i32 to i64
    %280 = llvm.getelementptr %278[%279] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %281 = cce.intr.vldsx1.i16(%280, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xi16>
    %282 = cce.vcmax(%281, %dst_14) : (vector<128xi16>, vector<256xi1>) -> vector<128xi16>
    %283 = llvm.mul %276, %14 : i32
    %284 = llvm.inttoptr %37 : i64 to !llvm.ptr<6>
    %285 = llvm.sext %283 : i32 to i64
    %286 = llvm.getelementptr %284[%285] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i16(%282, %286, %1, %13, %1, %273) : (vector<128xi16>, <6>, i32, i32, i32, vector<256xi1>)
    %287 = llvm.add %274, %12 : i64
    llvm.br ^bb97(%287 : i64)
  ^bb99:  // pred: ^bb97
    llvm.br ^bb100
  ^bb100:  // pred: ^bb99
    %288 = llvm.add %271, %0 : i32
    llvm.br ^bb95(%288 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb101:  // pred: ^bb95
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %289 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %290 = llvm.inttoptr %289 : i64 to !llvm.ptr<1>
    %291 = llvm.inttoptr %37 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%290, %291, %38, %39) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


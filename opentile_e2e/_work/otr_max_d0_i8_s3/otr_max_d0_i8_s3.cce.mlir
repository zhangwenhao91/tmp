module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_max_d0_i8_s3(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(32 : index) : i64
    %7 = llvm.mlir.constant(32 : i32) : i32
    %8 = llvm.mlir.constant(48 : i32) : i32
    %9 = llvm.mlir.constant(-128 : i8) : i8
    %10 = llvm.mlir.constant(10816 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(2 : i32) : i32
    %13 = llvm.mlir.constant(11072 : i64) : i64
    %14 = llvm.mlir.constant(64 : i32) : i32
    %15 = llvm.mlir.constant(11328 : i64) : i64
    %16 = llvm.mlir.constant(11584 : i64) : i64
    %17 = llvm.mlir.constant(11840 : i64) : i64
    %18 = llvm.mlir.constant(0 : i8) : i8
    %19 = llvm.mlir.constant(1 : i8) : i8
    %20 = llvm.mlir.constant(12096 : i64) : i64
    %21 = llvm.mlir.constant(8 : index) : i64
    %22 = llvm.mlir.constant(256 : i32) : i32
    %23 = llvm.mlir.constant(192 : i32) : i32
    %24 = llvm.mlir.constant(2048 : i32) : i32
    %25 = llvm.mlir.constant(2240 : i64) : i64
    %26 = llvm.mlir.constant(20 : i32) : i32
    %27 = llvm.mlir.constant(12 : i32) : i32
    %28 = llvm.mlir.constant(4480 : i64) : i64
    %29 = llvm.mlir.constant(8 : i32) : i32
    %30 = llvm.mlir.constant(8768 : i64) : i64
    %31 = llvm.mlir.constant(6720 : i64) : i64
    %32 = llvm.mlir.constant(256 : index) : i64
    %33 = llvm.mlir.constant(12352 : i64) : i64
    %34 = llvm.mlir.constant(288230377762324992 : i64) : i64
    %35 = llvm.mlir.constant(70368744177712 : i64) : i64
    %36 = llvm.mlir.constant(288230377762324496 : i64) : i64
    %37 = llvm.mlir.constant(52776558133296 : i64) : i64
    %38 = cce.get.ctrl -> i64
    %39 = cce.sbitset0(%38, %3) : (i64, i64) -> i64
    cce.set.ctrl(%39) : i64
    %40 = cce.get.ctrl -> i64
    %41 = cce.sbitset1(%40, %2) : (i64, i64) -> i64
    cce.set.ctrl(%41) : i64
    %42 = cce.get_sub_block_idx -> i64
    %43 = llvm.icmp "eq" %42, %4 : i64
    llvm.cond_br %43, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb98
    llvm.return
  ^bb3(%44: i32):  // 2 preds: ^bb1, ^bb5
    %45 = llvm.icmp "sle" %44, %1 : i32
    llvm.cond_br %45, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %46 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %47 = cce.vdups(%8, %46, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %48 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%47, %48, %1, %12, %1, %46) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %49 = llvm.add %44, %0 : i32
    llvm.br ^bb3(%49 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    llvm.br ^bb7(%1 : i32)
  ^bb7(%50: i32):  // 2 preds: ^bb6, ^bb9
    %51 = llvm.icmp "sle" %50, %1 : i32
    llvm.cond_br %51, ^bb8, ^bb10
  ^bb8:  // pred: ^bb7
    %52 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %53 = cce.vdups(%1, %52, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %54 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%53, %54, %1, %12, %1, %52) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %55 = llvm.add %50, %0 : i32
    llvm.br ^bb7(%55 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%56: i32):  // 2 preds: ^bb10, ^bb13
    %57 = llvm.icmp "sle" %56, %1 : i32
    llvm.cond_br %57, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %dst, %restElem = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %58 = cce.vdups(%7, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %59 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%58, %59, %1, %12, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %60 = llvm.add %56, %0 : i32
    llvm.br ^bb11(%60 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%61: i32):  // 2 preds: ^bb14, ^bb17
    %62 = llvm.icmp "sle" %61, %1 : i32
    llvm.cond_br %62, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %63 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %64 = cce.vdups(%1, %63, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %65 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%64, %65, %1, %12, %1, %63) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb17
  ^bb17:  // pred: ^bb16
    %66 = llvm.add %61, %0 : i32
    llvm.br ^bb15(%66 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb18:  // pred: ^bb15
    llvm.br ^bb19(%1 : i32)
  ^bb19(%67: i32):  // 2 preds: ^bb18, ^bb21
    %68 = llvm.icmp "sle" %67, %1 : i32
    llvm.cond_br %68, ^bb20, ^bb22
  ^bb20:  // pred: ^bb19
    %69 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %70 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%69, %70, %1, %12, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %71 = llvm.add %67, %0 : i32
    llvm.br ^bb19(%71 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%72: i32):  // 2 preds: ^bb22, ^bb25
    %73 = llvm.icmp "sle" %72, %1 : i32
    llvm.cond_br %73, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %74 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %75 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %76 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%75, %76, %1, %12, %1, %74) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %77 = llvm.add %72, %0 : i32
    llvm.br ^bb23(%77 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%78: i32):  // 2 preds: ^bb26, ^bb29
    %79 = llvm.icmp "sle" %78, %1 : i32
    llvm.cond_br %79, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %80 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %81 = cce.vdups(%18, %80, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %82 = cce.cmp(%81, %81, %80) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %83 = cce.vdups(%19, %80, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %84 = cce.vsel(%83, %81, %82) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %85 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%84, %85, %1, %1, %1, %80) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb29
  ^bb29:  // pred: ^bb28
    %86 = llvm.add %78, %0 : i32
    llvm.br ^bb27(%86 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb30:  // pred: ^bb27
    llvm.br ^bb31(%1 : i32)
  ^bb31(%87: i32):  // 2 preds: ^bb30, ^bb33
    %88 = llvm.icmp "sle" %87, %1 : i32
    llvm.cond_br %88, ^bb32, ^bb34
  ^bb32:  // pred: ^bb31
    %89 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %90 = cce.intr.vldsx1.i32(%89, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %91 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %92 = cce.intr.vldsx1.i32(%91, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %93 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %94 = cce.cmp(%92, %90, %93) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%7) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %95 = cce.ppack(%94, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %96 = cce.ppack(%95, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %97 = cce.vdups(%18, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %98 = cce.vdups(%19, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %99 = cce.vsel(%98, %97, %96) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %100 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%99, %100, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb33
  ^bb33:  // pred: ^bb32
    %101 = llvm.add %87, %0 : i32
    llvm.br ^bb31(%101 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb34:  // pred: ^bb31
    llvm.br ^bb35(%1 : i32)
  ^bb35(%102: i32):  // 2 preds: ^bb34, ^bb37
    %103 = llvm.icmp "sle" %102, %1 : i32
    llvm.cond_br %103, ^bb36, ^bb38
  ^bb36:  // pred: ^bb35
    %104 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %105 = cce.vdups(%18, %104, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %106 = cce.cmp(%105, %105, %104) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %107 = cce.vdups(%19, %104, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %108 = cce.vsel(%107, %105, %106) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %109 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%108, %109, %1, %1, %1, %104) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb37
  ^bb37:  // pred: ^bb36
    %110 = llvm.add %102, %0 : i32
    llvm.br ^bb35(%110 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb38:  // pred: ^bb35
    llvm.br ^bb39(%1 : i32)
  ^bb39(%111: i32):  // 2 preds: ^bb38, ^bb41
    %112 = llvm.icmp "sle" %111, %1 : i32
    llvm.cond_br %112, ^bb40, ^bb42
  ^bb40:  // pred: ^bb39
    %113 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %114 = cce.intr.vldsx1.i32(%113, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %115 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %116 = cce.intr.vldsx1.i32(%115, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %117 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %118 = cce.cmp(%116, %114, %117) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %119 = cce.ppack(%118, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %120 = cce.ppack(%119, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %121 = cce.vdups(%18, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %122 = cce.vdups(%19, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %123 = cce.vsel(%122, %121, %120) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %124 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%123, %124, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb41
  ^bb41:  // pred: ^bb40
    %125 = llvm.add %111, %0 : i32
    llvm.br ^bb39(%125 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb42:  // pred: ^bb39
    llvm.br ^bb43(%1 : i32)
  ^bb43(%126: i32):  // 2 preds: ^bb42, ^bb48
    %127 = llvm.icmp "sle" %126, %1 : i32
    llvm.cond_br %127, ^bb44, ^bb49
  ^bb44:  // pred: ^bb43
    %128 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %129 = cce.vdups(%18, %128, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%130: i64):  // 2 preds: ^bb44, ^bb46
    %131 = llvm.icmp "slt" %130, %21 : i64
    llvm.cond_br %131, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %132 = llvm.trunc %130 : i64 to i32
    %133 = llvm.mul %132, %22 : i32
    %134 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %135 = llvm.sext %133 : i32 to i64
    %136 = llvm.getelementptr %134[%135] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%129, %136, %1, %1, %1, %128) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %137 = llvm.add %130, %11 : i64
    llvm.br ^bb45(%137 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%23) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %138 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %139 = llvm.getelementptr %138[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%129, %139, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    %140 = llvm.add %126, %0 : i32
    llvm.br ^bb43(%140 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb49:  // pred: ^bb43
    llvm.br ^bb50(%1 : i32)
  ^bb50(%141: i32):  // 2 preds: ^bb49, ^bb55
    %142 = llvm.icmp "sle" %141, %1 : i32
    llvm.cond_br %142, ^bb51, ^bb56
  ^bb51:  // pred: ^bb50
    %dst_8, %restElem_9 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%143: i64):  // 2 preds: ^bb51, ^bb53
    %144 = llvm.icmp "slt" %143, %6 : i64
    llvm.cond_br %144, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %145 = llvm.trunc %143 : i64 to i32
    %146 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %147 = llvm.sext %145 : i32 to i64
    %148 = llvm.getelementptr %146[%147] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %149 = cce.intr.vldsx1.i8(%148, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %150 = llvm.mul %145, %14 : i32
    %151 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %152 = llvm.sext %150 : i32 to i64
    %153 = llvm.getelementptr %151[%152] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%149, %153, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %154 = llvm.add %143, %11 : i64
    llvm.br ^bb52(%154 : i64)
  ^bb54:  // pred: ^bb52
    llvm.br ^bb55
  ^bb55:  // pred: ^bb54
    %155 = llvm.add %141, %0 : i32
    llvm.br ^bb50(%155 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb56:  // pred: ^bb50
    llvm.br ^bb57(%1 : i32)
  ^bb57(%156: i32):  // 2 preds: ^bb56, ^bb62
    %157 = llvm.icmp "sle" %156, %1 : i32
    llvm.cond_br %157, ^bb58, ^bb63
  ^bb58:  // pred: ^bb57
    %158 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %159 = cce.vdups(%18, %158, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%160: i64):  // 2 preds: ^bb58, ^bb60
    %161 = llvm.icmp "slt" %160, %21 : i64
    llvm.cond_br %161, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %162 = llvm.trunc %160 : i64 to i32
    %163 = llvm.mul %162, %22 : i32
    %164 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %165 = llvm.sext %163 : i32 to i64
    %166 = llvm.getelementptr %164[%165] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%159, %166, %1, %1, %1, %158) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %167 = llvm.add %160, %11 : i64
    llvm.br ^bb59(%167 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%23) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %168 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %169 = llvm.getelementptr %168[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%159, %169, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %170 = llvm.add %156, %0 : i32
    llvm.br ^bb57(%170 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%171: i32):  // 2 preds: ^bb63, ^bb69
    %172 = llvm.icmp "sle" %171, %1 : i32
    llvm.cond_br %172, ^bb65, ^bb70
  ^bb65:  // pred: ^bb64
    %dst_12, %restElem_13 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb66(%5 : i64)
  ^bb66(%173: i64):  // 2 preds: ^bb65, ^bb67
    %174 = llvm.icmp "slt" %173, %6 : i64
    llvm.cond_br %174, ^bb67, ^bb68
  ^bb67:  // pred: ^bb66
    %175 = llvm.trunc %173 : i64 to i32
    %176 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %177 = cce.intr.vldsx1.i8(%176, %1, %26, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %178 = llvm.mul %175, %14 : i32
    %179 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %180 = llvm.sext %178 : i32 to i64
    %181 = llvm.getelementptr %179[%180] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%177, %181, %1, %27, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %182 = llvm.add %173, %11 : i64
    llvm.br ^bb66(%182 : i64)
  ^bb68:  // pred: ^bb66
    llvm.br ^bb69
  ^bb69:  // pred: ^bb68
    %183 = llvm.add %171, %0 : i32
    llvm.br ^bb64(%183 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb70:  // pred: ^bb64
    llvm.br ^bb71(%1 : i32)
  ^bb71(%184: i32):  // 2 preds: ^bb70, ^bb76
    %185 = llvm.icmp "sle" %184, %1 : i32
    llvm.cond_br %185, ^bb72, ^bb77
  ^bb72:  // pred: ^bb71
    %186 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %187 = cce.vdups(%18, %186, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb73(%5 : i64)
  ^bb73(%188: i64):  // 2 preds: ^bb72, ^bb74
    %189 = llvm.icmp "slt" %188, %21 : i64
    llvm.cond_br %189, ^bb74, ^bb75
  ^bb74:  // pred: ^bb73
    %190 = llvm.trunc %188 : i64 to i32
    %191 = llvm.mul %190, %22 : i32
    %192 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %193 = llvm.sext %191 : i32 to i64
    %194 = llvm.getelementptr %192[%193] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%187, %194, %1, %1, %1, %186) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %195 = llvm.add %188, %11 : i64
    llvm.br ^bb73(%195 : i64)
  ^bb75:  // pred: ^bb73
    %dst_14, %restElem_15 = cce.plt(%23) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %196 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %197 = llvm.getelementptr %196[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%187, %197, %1, %1, %1, %dst_14) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb76
  ^bb76:  // pred: ^bb75
    %198 = llvm.add %184, %0 : i32
    llvm.br ^bb71(%198 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb77:  // pred: ^bb71
    llvm.br ^bb78(%1 : i32)
  ^bb78(%199: i32):  // 2 preds: ^bb77, ^bb83
    %200 = llvm.icmp "sle" %199, %1 : i32
    llvm.cond_br %200, ^bb79, ^bb84
  ^bb79:  // pred: ^bb78
    %201 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb80(%5 : i64)
  ^bb80(%202: i64):  // 2 preds: ^bb79, ^bb81
    %203 = llvm.icmp "slt" %202, %21 : i64
    llvm.cond_br %203, ^bb81, ^bb82
  ^bb81:  // pred: ^bb80
    %204 = llvm.trunc %202 : i64 to i32
    %205 = llvm.udiv %204, %29 : i32
    %206 = llvm.urem %204, %29 : i32
    %207 = llvm.mul %206, %22 : i32
    %208 = llvm.mul %205, %24 : i32
    %209 = llvm.add %208, %207 : i32
    %210 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %211 = llvm.sext %209 : i32 to i64
    %212 = llvm.getelementptr %210[%211] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %213 = cce.intr.vldsx1.i8(%212, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %214 = cce.vdups(%18, %201, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %215 = cce.cmp(%213, %214, %201) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %216 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %217 = llvm.sext %209 : i32 to i64
    %218 = llvm.getelementptr %216[%217] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %219 = cce.intr.vldsx1.i8(%218, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %220 = cce.cmp(%219, %214, %201) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %221 = cce.pand(%215, %220, %201) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %222 = cce.vdups(%19, %201, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %223 = cce.vsel(%222, %214, %221) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %224 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %225 = llvm.sext %209 : i32 to i64
    %226 = llvm.getelementptr %224[%225] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%223, %226, %1, %1, %1, %201) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %227 = llvm.add %202, %11 : i64
    llvm.br ^bb80(%227 : i64)
  ^bb82:  // pred: ^bb80
    llvm.br ^bb83
  ^bb83:  // pred: ^bb82
    %228 = llvm.add %199, %0 : i32
    llvm.br ^bb78(%228 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb84:  // pred: ^bb78
    %229 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %230 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %231 = llvm.inttoptr %230 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.s8.dv(%229, %231, %34, %35) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb85(%1 : i32)
  ^bb85(%232: i32):  // 2 preds: ^bb84, ^bb90
    %233 = llvm.icmp "sle" %232, %1 : i32
    llvm.cond_br %233, ^bb86, ^bb91
  ^bb86:  // pred: ^bb85
    %234 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb87(%5 : i64)
  ^bb87(%235: i64):  // 2 preds: ^bb86, ^bb88
    %236 = llvm.icmp "slt" %235, %21 : i64
    llvm.cond_br %236, ^bb88, ^bb89
  ^bb88:  // pred: ^bb87
    %237 = llvm.mul %235, %32 : i64
    %238 = llvm.trunc %237 : i64 to i32
    %239 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %240 = llvm.sext %238 : i32 to i64
    %241 = llvm.getelementptr %239[%240] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %242 = cce.intr.vldsx1.i8(%241, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %243 = cce.vdups(%18, %234, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %244 = cce.cmp(%242, %243, %234) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %245 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %246 = llvm.sext %238 : i32 to i64
    %247 = llvm.getelementptr %245[%246] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %248 = cce.intr.vldsx1.i8(%247, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %249 = cce.vdups(%9, %234, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %250 = cce.vsel(%248, %249, %244) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %251 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %252 = llvm.sext %238 : i32 to i64
    %253 = llvm.getelementptr %251[%252] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%250, %253, %1, %1, %1, %234) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %254 = llvm.add %235, %11 : i64
    llvm.br ^bb87(%254 : i64)
  ^bb89:  // pred: ^bb87
    llvm.br ^bb90
  ^bb90:  // pred: ^bb89
    %255 = llvm.add %232, %0 : i32
    llvm.br ^bb85(%255 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb91:  // pred: ^bb85
    llvm.br ^bb92(%1 : i32)
  ^bb92(%256: i32):  // 2 preds: ^bb91, ^bb97
    %257 = llvm.icmp "sle" %256, %1 : i32
    llvm.cond_br %257, ^bb93, ^bb98
  ^bb93:  // pred: ^bb92
    %dst_16, %restElem_17 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %258 = cce.vdups(%9, %dst_16, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb94(%5, %258 : i64, vector<256xi8>)
  ^bb94(%259: i64, %260: vector<256xi8>):  // 2 preds: ^bb93, ^bb95
    %261 = llvm.icmp "slt" %259, %6 : i64
    llvm.cond_br %261, ^bb95, ^bb96
  ^bb95:  // pred: ^bb94
    %262 = llvm.trunc %259 : i64 to i32
    %263 = llvm.mul %262, %14 : i32
    %264 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %265 = llvm.sext %263 : i32 to i64
    %266 = llvm.getelementptr %264[%265] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %267 = cce.intr.vldsx1.i8(%266, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %268 = cce.vmax(%260, %267, %dst_16) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %269 = llvm.add %259, %11 : i64
    llvm.br ^bb94(%269, %268 : i64, vector<256xi8>)
  ^bb96:  // pred: ^bb94
    %270 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%260, %270, %1, %1, %1, %dst_16) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb97
  ^bb97:  // pred: ^bb96
    %271 = llvm.add %256, %0 : i32
    llvm.br ^bb92(%271 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb98:  // pred: ^bb92
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %272 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %273 = llvm.inttoptr %272 : i64 to !llvm.ptr<1>
    %274 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%273, %274, %36, %37) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


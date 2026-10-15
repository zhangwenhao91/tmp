module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_max_d0_i8(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(64 : index) : i64
    %7 = llvm.mlir.constant(64 : i32) : i32
    %8 = llvm.mlir.constant(16 : i32) : i32
    %9 = llvm.mlir.constant(-128 : i8) : i8
    %10 = llvm.mlir.constant(10912 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(2 : i32) : i32
    %13 = llvm.mlir.constant(32 : i32) : i32
    %14 = llvm.mlir.constant(11168 : i64) : i64
    %15 = llvm.mlir.constant(11424 : i64) : i64
    %16 = llvm.mlir.constant(11680 : i64) : i64
    %17 = llvm.mlir.constant(11936 : i64) : i64
    %18 = llvm.mlir.constant(0 : i8) : i8
    %19 = llvm.mlir.constant(1 : i8) : i8
    %20 = llvm.mlir.constant(12192 : i64) : i64
    %21 = llvm.mlir.constant(8 : index) : i64
    %22 = llvm.mlir.constant(256 : i32) : i32
    %23 = llvm.mlir.constant(224 : i32) : i32
    %24 = llvm.mlir.constant(2048 : i32) : i32
    %25 = llvm.mlir.constant(32 : index) : i64
    %26 = llvm.mlir.constant(3 : i32) : i32
    %27 = llvm.mlir.constant(2272 : i64) : i64
    %28 = llvm.mlir.constant(4544 : i64) : i64
    %29 = llvm.mlir.constant(8 : i32) : i32
    %30 = llvm.mlir.constant(8864 : i64) : i64
    %31 = llvm.mlir.constant(6816 : i64) : i64
    %32 = llvm.mlir.constant(256 : index) : i64
    %33 = llvm.mlir.constant(12448 : i64) : i64
    %34 = llvm.mlir.constant(288230376688583680 : i64) : i64
    %35 = llvm.mlir.constant(35184372088848 : i64) : i64
    %36 = llvm.mlir.constant(288230376688582672 : i64) : i64
    %37 = llvm.mlir.constant(17592186044432 : i64) : i64
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
  ^bb2:  // 2 preds: ^bb0, ^bb101
    llvm.return
  ^bb3(%44: i32):  // 2 preds: ^bb1, ^bb5
    %45 = llvm.icmp "sle" %44, %1 : i32
    llvm.cond_br %45, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %46 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %47 = cce.vdups(%1, %46, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
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
    %dst, %restElem = cce.plt(%13) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %52 = cce.vdups(%8, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %53 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%52, %53, %1, %12, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %54 = llvm.add %50, %0 : i32
    llvm.br ^bb7(%54 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%55: i32):  // 2 preds: ^bb10, ^bb13
    %56 = llvm.icmp "sle" %55, %1 : i32
    llvm.cond_br %56, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %57 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %58 = cce.vdups(%7, %57, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %59 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%58, %59, %1, %12, %1, %57) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %60 = llvm.add %55, %0 : i32
    llvm.br ^bb11(%60 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%61: i32):  // 2 preds: ^bb14, ^bb17
    %62 = llvm.icmp "sle" %61, %1 : i32
    llvm.cond_br %62, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %63 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %64 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
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
    %69 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %70 = cce.vdups(%1, %69, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %71 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%70, %71, %1, %12, %1, %69) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %72 = llvm.add %67, %0 : i32
    llvm.br ^bb19(%72 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%73: i32):  // 2 preds: ^bb22, ^bb25
    %74 = llvm.icmp "sle" %73, %1 : i32
    llvm.cond_br %74, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %75 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%13) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %76 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%75, %76, %1, %12, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %77 = llvm.add %73, %0 : i32
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
    %89 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
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
    %dst_4, %restElem_5 = cce.plt(%13) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
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
    %dst_8, %restElem_9 = cce.plt(%13) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
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
    %150 = llvm.mul %145, %13 : i32
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
    %164 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %165 = llvm.sext %163 : i32 to i64
    %166 = llvm.getelementptr %164[%165] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%159, %166, %1, %1, %1, %158) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %167 = llvm.add %160, %11 : i64
    llvm.br ^bb59(%167 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%23) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %168 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %169 = llvm.getelementptr %168[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%159, %169, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %170 = llvm.add %156, %0 : i32
    llvm.br ^bb57(%170 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%171: i32):  // 2 preds: ^bb63, ^bb72
    %172 = llvm.icmp "sle" %171, %1 : i32
    llvm.cond_br %172, ^bb65, ^bb73
  ^bb65:  // pred: ^bb64
    %173 = cce.pset(%12) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb66(%5 : i64)
  ^bb66(%174: i64):  // 2 preds: ^bb65, ^bb70
    %175 = llvm.icmp "slt" %174, %25 : i64
    llvm.cond_br %175, ^bb67, ^bb71
  ^bb67:  // pred: ^bb66
    %176 = llvm.trunc %174 : i64 to i32
    %177 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %178 = llvm.sext %176 : i32 to i64
    %179 = llvm.getelementptr %177[%178] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %180 = cce.intr.vldsx1.i8(%179, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%181: i64):  // 2 preds: ^bb67, ^bb69
    %182 = llvm.icmp "slt" %181, %6 : i64
    llvm.cond_br %182, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %183 = llvm.trunc %181 : i64 to i32
    %184 = llvm.mul %183, %13 : i32
    %185 = llvm.add %184, %176 : i32
    %186 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %187 = llvm.sext %185 : i32 to i64
    %188 = llvm.getelementptr %186[%187] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%180, %188, %1, %26, %1, %173) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %189 = llvm.add %181, %11 : i64
    llvm.br ^bb68(%189 : i64)
  ^bb70:  // pred: ^bb68
    %190 = llvm.add %174, %11 : i64
    llvm.br ^bb66(%190 : i64)
  ^bb71:  // pred: ^bb66
    llvm.br ^bb72
  ^bb72:  // pred: ^bb71
    %191 = llvm.add %171, %0 : i32
    llvm.br ^bb64(%191 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb73:  // pred: ^bb64
    llvm.br ^bb74(%1 : i32)
  ^bb74(%192: i32):  // 2 preds: ^bb73, ^bb79
    %193 = llvm.icmp "sle" %192, %1 : i32
    llvm.cond_br %193, ^bb75, ^bb80
  ^bb75:  // pred: ^bb74
    %194 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %195 = cce.vdups(%18, %194, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb76(%5 : i64)
  ^bb76(%196: i64):  // 2 preds: ^bb75, ^bb77
    %197 = llvm.icmp "slt" %196, %21 : i64
    llvm.cond_br %197, ^bb77, ^bb78
  ^bb77:  // pred: ^bb76
    %198 = llvm.trunc %196 : i64 to i32
    %199 = llvm.mul %198, %22 : i32
    %200 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %201 = llvm.sext %199 : i32 to i64
    %202 = llvm.getelementptr %200[%201] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%195, %202, %1, %1, %1, %194) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %203 = llvm.add %196, %11 : i64
    llvm.br ^bb76(%203 : i64)
  ^bb78:  // pred: ^bb76
    %dst_12, %restElem_13 = cce.plt(%23) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %204 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %205 = llvm.getelementptr %204[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%195, %205, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb79
  ^bb79:  // pred: ^bb78
    %206 = llvm.add %192, %0 : i32
    llvm.br ^bb74(%206 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb80:  // pred: ^bb74
    llvm.br ^bb81(%1 : i32)
  ^bb81(%207: i32):  // 2 preds: ^bb80, ^bb86
    %208 = llvm.icmp "sle" %207, %1 : i32
    llvm.cond_br %208, ^bb82, ^bb87
  ^bb82:  // pred: ^bb81
    %209 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb83(%5 : i64)
  ^bb83(%210: i64):  // 2 preds: ^bb82, ^bb84
    %211 = llvm.icmp "slt" %210, %21 : i64
    llvm.cond_br %211, ^bb84, ^bb85
  ^bb84:  // pred: ^bb83
    %212 = llvm.trunc %210 : i64 to i32
    %213 = llvm.udiv %212, %29 : i32
    %214 = llvm.urem %212, %29 : i32
    %215 = llvm.mul %214, %22 : i32
    %216 = llvm.mul %213, %24 : i32
    %217 = llvm.add %216, %215 : i32
    %218 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %219 = llvm.sext %217 : i32 to i64
    %220 = llvm.getelementptr %218[%219] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %221 = cce.intr.vldsx1.i8(%220, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %222 = cce.vdups(%18, %209, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %223 = cce.cmp(%221, %222, %209) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %224 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %225 = llvm.sext %217 : i32 to i64
    %226 = llvm.getelementptr %224[%225] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %227 = cce.intr.vldsx1.i8(%226, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %228 = cce.cmp(%227, %222, %209) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %229 = cce.pand(%223, %228, %209) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %230 = cce.vdups(%19, %209, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %231 = cce.vsel(%230, %222, %229) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %232 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %233 = llvm.sext %217 : i32 to i64
    %234 = llvm.getelementptr %232[%233] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%231, %234, %1, %1, %1, %209) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %235 = llvm.add %210, %11 : i64
    llvm.br ^bb83(%235 : i64)
  ^bb85:  // pred: ^bb83
    llvm.br ^bb86
  ^bb86:  // pred: ^bb85
    %236 = llvm.add %207, %0 : i32
    llvm.br ^bb81(%236 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb87:  // pred: ^bb81
    %237 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %238 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %239 = llvm.inttoptr %238 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.s8.dv(%237, %239, %34, %35) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb88(%1 : i32)
  ^bb88(%240: i32):  // 2 preds: ^bb87, ^bb93
    %241 = llvm.icmp "sle" %240, %1 : i32
    llvm.cond_br %241, ^bb89, ^bb94
  ^bb89:  // pred: ^bb88
    %242 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb90(%5 : i64)
  ^bb90(%243: i64):  // 2 preds: ^bb89, ^bb91
    %244 = llvm.icmp "slt" %243, %21 : i64
    llvm.cond_br %244, ^bb91, ^bb92
  ^bb91:  // pred: ^bb90
    %245 = llvm.mul %243, %32 : i64
    %246 = llvm.trunc %245 : i64 to i32
    %247 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %248 = llvm.sext %246 : i32 to i64
    %249 = llvm.getelementptr %247[%248] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %250 = cce.intr.vldsx1.i8(%249, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %251 = cce.vdups(%18, %242, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %252 = cce.cmp(%250, %251, %242) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %253 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %254 = llvm.sext %246 : i32 to i64
    %255 = llvm.getelementptr %253[%254] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %256 = cce.intr.vldsx1.i8(%255, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %257 = cce.vdups(%9, %242, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %258 = cce.vsel(%256, %257, %252) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %259 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %260 = llvm.sext %246 : i32 to i64
    %261 = llvm.getelementptr %259[%260] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%258, %261, %1, %1, %1, %242) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %262 = llvm.add %243, %11 : i64
    llvm.br ^bb90(%262 : i64)
  ^bb92:  // pred: ^bb90
    llvm.br ^bb93
  ^bb93:  // pred: ^bb92
    %263 = llvm.add %240, %0 : i32
    llvm.br ^bb88(%263 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb94:  // pred: ^bb88
    llvm.br ^bb95(%1 : i32)
  ^bb95(%264: i32):  // 2 preds: ^bb94, ^bb100
    %265 = llvm.icmp "sle" %264, %1 : i32
    llvm.cond_br %265, ^bb96, ^bb101
  ^bb96:  // pred: ^bb95
    %dst_14, %restElem_15 = cce.plt(%13) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %266 = cce.vdups(%9, %dst_14, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb97(%5, %266 : i64, vector<256xi8>)
  ^bb97(%267: i64, %268: vector<256xi8>):  // 2 preds: ^bb96, ^bb98
    %269 = llvm.icmp "slt" %267, %6 : i64
    llvm.cond_br %269, ^bb98, ^bb99
  ^bb98:  // pred: ^bb97
    %270 = llvm.trunc %267 : i64 to i32
    %271 = llvm.mul %270, %13 : i32
    %272 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %273 = llvm.sext %271 : i32 to i64
    %274 = llvm.getelementptr %272[%273] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %275 = cce.intr.vldsx1.i8(%274, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %276 = cce.vmax(%268, %275, %dst_14) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %277 = llvm.add %267, %11 : i64
    llvm.br ^bb97(%277, %276 : i64, vector<256xi8>)
  ^bb99:  // pred: ^bb97
    %278 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%268, %278, %1, %1, %1, %dst_14) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb100
  ^bb100:  // pred: ^bb99
    %279 = llvm.add %264, %0 : i32
    llvm.br ^bb95(%279 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb101:  // pred: ^bb95
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %280 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %281 = llvm.inttoptr %280 : i64 to !llvm.ptr<1>
    %282 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%281, %282, %36, %37) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


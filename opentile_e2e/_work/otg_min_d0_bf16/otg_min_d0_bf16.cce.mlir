module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otg_min_d0_bf16(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
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
    %10 = llvm.mlir.constant(0x7F80 : bf16) : bf16
    %11 = llvm.mlir.constant(15008 : i64) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(2 : i32) : i32
    %14 = llvm.mlir.constant(32 : i32) : i32
    %15 = llvm.mlir.constant(15264 : i64) : i64
    %16 = llvm.mlir.constant(15520 : i64) : i64
    %17 = llvm.mlir.constant(15776 : i64) : i64
    %18 = llvm.mlir.constant(16032 : i64) : i64
    %19 = llvm.mlir.constant(0 : i8) : i8
    %20 = llvm.mlir.constant(1 : i8) : i8
    %21 = llvm.mlir.constant(16288 : i64) : i64
    %22 = llvm.mlir.constant(8192 : i64) : i64
    %23 = llvm.mlir.constant(8 : index) : i64
    %24 = llvm.mlir.constant(256 : i32) : i32
    %25 = llvm.mlir.constant(224 : i32) : i32
    %26 = llvm.mlir.constant(2048 : i32) : i32
    %27 = llvm.mlir.constant(32 : index) : i64
    %28 = llvm.mlir.constant(3 : i32) : i32
    %29 = llvm.mlir.constant(10464 : i64) : i64
    %30 = llvm.mlir.constant(12736 : i64) : i64
    %31 = llvm.mlir.constant(8 : i32) : i32
    %32 = llvm.mlir.constant(4096 : i64) : i64
    %33 = llvm.mlir.constant(128 : index) : i64
    %34 = llvm.mlir.constant(13 : i32) : i32
    %35 = llvm.mlir.constant(0 : i16) : i16
    %36 = llvm.mlir.constant(16544 : i64) : i64
    %37 = llvm.mlir.constant(288230377225454592 : i64) : i64
    %38 = llvm.mlir.constant(70368744177696 : i64) : i64
    %39 = llvm.mlir.constant(288230377225453584 : i64) : i64
    %40 = llvm.mlir.constant(35184372088864 : i64) : i64
    %41 = cce.get.ctrl -> i64
    %42 = cce.sbitset0(%41, %3) : (i64, i64) -> i64
    cce.set.ctrl(%42) : i64
    %43 = cce.get.ctrl -> i64
    %44 = cce.sbitset1(%43, %2) : (i64, i64) -> i64
    cce.set.ctrl(%44) : i64
    %45 = cce.get_sub_block_idx -> i64
    %46 = llvm.icmp "eq" %45, %4 : i64
    llvm.cond_br %46, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb101
    llvm.return
  ^bb3(%47: i32):  // 2 preds: ^bb1, ^bb5
    %48 = llvm.icmp "sle" %47, %1 : i32
    llvm.cond_br %48, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %49 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %50 = cce.vdups(%1, %49, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %51 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%50, %51, %1, %13, %1, %49) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %52 = llvm.add %47, %0 : i32
    llvm.br ^bb3(%52 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    llvm.br ^bb7(%1 : i32)
  ^bb7(%53: i32):  // 2 preds: ^bb6, ^bb9
    %54 = llvm.icmp "sle" %53, %1 : i32
    llvm.cond_br %54, ^bb8, ^bb10
  ^bb8:  // pred: ^bb7
    %dst, %restElem = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %55 = cce.vdups(%9, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %56 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%55, %56, %1, %13, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %57 = llvm.add %53, %0 : i32
    llvm.br ^bb7(%57 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%58: i32):  // 2 preds: ^bb10, ^bb13
    %59 = llvm.icmp "sle" %58, %1 : i32
    llvm.cond_br %59, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %60 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %61 = cce.vdups(%8, %60, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %62 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%61, %62, %1, %13, %1, %60) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %63 = llvm.add %58, %0 : i32
    llvm.br ^bb11(%63 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%64: i32):  // 2 preds: ^bb14, ^bb17
    %65 = llvm.icmp "sle" %64, %1 : i32
    llvm.cond_br %65, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %66 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %67 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %68 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%67, %68, %1, %13, %1, %66) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb17
  ^bb17:  // pred: ^bb16
    %69 = llvm.add %64, %0 : i32
    llvm.br ^bb15(%69 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb18:  // pred: ^bb15
    llvm.br ^bb19(%1 : i32)
  ^bb19(%70: i32):  // 2 preds: ^bb18, ^bb21
    %71 = llvm.icmp "sle" %70, %1 : i32
    llvm.cond_br %71, ^bb20, ^bb22
  ^bb20:  // pred: ^bb19
    %72 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %73 = cce.vdups(%1, %72, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %74 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%73, %74, %1, %13, %1, %72) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %75 = llvm.add %70, %0 : i32
    llvm.br ^bb19(%75 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%76: i32):  // 2 preds: ^bb22, ^bb25
    %77 = llvm.icmp "sle" %76, %1 : i32
    llvm.cond_br %77, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %78 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %79 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%78, %79, %1, %13, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %80 = llvm.add %76, %0 : i32
    llvm.br ^bb23(%80 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%81: i32):  // 2 preds: ^bb26, ^bb29
    %82 = llvm.icmp "sle" %81, %1 : i32
    llvm.cond_br %82, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %83 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %84 = cce.vdups(%19, %83, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %85 = cce.cmp(%84, %84, %83) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %86 = cce.vdups(%20, %83, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %87 = cce.vsel(%86, %84, %85) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %88 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%87, %88, %1, %1, %1, %83) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb29
  ^bb29:  // pred: ^bb28
    %89 = llvm.add %81, %0 : i32
    llvm.br ^bb27(%89 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb30:  // pred: ^bb27
    llvm.br ^bb31(%1 : i32)
  ^bb31(%90: i32):  // 2 preds: ^bb30, ^bb33
    %91 = llvm.icmp "sle" %90, %1 : i32
    llvm.cond_br %91, ^bb32, ^bb34
  ^bb32:  // pred: ^bb31
    %92 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %93 = cce.intr.vldsx1.i32(%92, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %94 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %95 = cce.intr.vldsx1.i32(%94, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %96 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %97 = cce.cmp(%95, %93, %96) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%8) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %98 = cce.ppack(%97, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %99 = cce.ppack(%98, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %100 = cce.vdups(%19, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %101 = cce.vdups(%20, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %102 = cce.vsel(%101, %100, %99) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %103 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%102, %103, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb33
  ^bb33:  // pred: ^bb32
    %104 = llvm.add %90, %0 : i32
    llvm.br ^bb31(%104 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb34:  // pred: ^bb31
    llvm.br ^bb35(%1 : i32)
  ^bb35(%105: i32):  // 2 preds: ^bb34, ^bb37
    %106 = llvm.icmp "sle" %105, %1 : i32
    llvm.cond_br %106, ^bb36, ^bb38
  ^bb36:  // pred: ^bb35
    %107 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %108 = cce.vdups(%19, %107, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %109 = cce.cmp(%108, %108, %107) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %110 = cce.vdups(%20, %107, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %111 = cce.vsel(%110, %108, %109) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %112 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%111, %112, %1, %1, %1, %107) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb37
  ^bb37:  // pred: ^bb36
    %113 = llvm.add %105, %0 : i32
    llvm.br ^bb35(%113 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb38:  // pred: ^bb35
    llvm.br ^bb39(%1 : i32)
  ^bb39(%114: i32):  // 2 preds: ^bb38, ^bb41
    %115 = llvm.icmp "sle" %114, %1 : i32
    llvm.cond_br %115, ^bb40, ^bb42
  ^bb40:  // pred: ^bb39
    %116 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %117 = cce.intr.vldsx1.i32(%116, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %118 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %119 = cce.intr.vldsx1.i32(%118, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %120 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %121 = cce.cmp(%119, %117, %120) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %122 = cce.ppack(%121, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %123 = cce.ppack(%122, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %124 = cce.vdups(%19, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %125 = cce.vdups(%20, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %126 = cce.vsel(%125, %124, %123) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %127 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%126, %127, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb41
  ^bb41:  // pred: ^bb40
    %128 = llvm.add %114, %0 : i32
    llvm.br ^bb39(%128 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb42:  // pred: ^bb39
    llvm.br ^bb43(%1 : i32)
  ^bb43(%129: i32):  // 2 preds: ^bb42, ^bb48
    %130 = llvm.icmp "sle" %129, %1 : i32
    llvm.cond_br %130, ^bb44, ^bb49
  ^bb44:  // pred: ^bb43
    %131 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %132 = cce.vdups(%19, %131, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%133: i64):  // 2 preds: ^bb44, ^bb46
    %134 = llvm.icmp "slt" %133, %23 : i64
    llvm.cond_br %134, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %135 = llvm.trunc %133 : i64 to i32
    %136 = llvm.mul %135, %24 : i32
    %137 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %138 = llvm.sext %136 : i32 to i64
    %139 = llvm.getelementptr %137[%138] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%132, %139, %1, %1, %1, %131) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %140 = llvm.add %133, %12 : i64
    llvm.br ^bb45(%140 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %141 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %142 = llvm.getelementptr %141[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%132, %142, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    %143 = llvm.add %129, %0 : i32
    llvm.br ^bb43(%143 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb49:  // pred: ^bb43
    llvm.br ^bb50(%1 : i32)
  ^bb50(%144: i32):  // 2 preds: ^bb49, ^bb55
    %145 = llvm.icmp "sle" %144, %1 : i32
    llvm.cond_br %145, ^bb51, ^bb56
  ^bb51:  // pred: ^bb50
    %dst_8, %restElem_9 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%146: i64):  // 2 preds: ^bb51, ^bb53
    %147 = llvm.icmp "slt" %146, %7 : i64
    llvm.cond_br %147, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %148 = llvm.trunc %146 : i64 to i32
    %149 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %150 = llvm.sext %148 : i32 to i64
    %151 = llvm.getelementptr %149[%150] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %152 = cce.intr.vldsx1.i8(%151, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %153 = llvm.mul %148, %14 : i32
    %154 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %155 = llvm.sext %153 : i32 to i64
    %156 = llvm.getelementptr %154[%155] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%152, %156, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %157 = llvm.add %146, %12 : i64
    llvm.br ^bb52(%157 : i64)
  ^bb54:  // pred: ^bb52
    llvm.br ^bb55
  ^bb55:  // pred: ^bb54
    %158 = llvm.add %144, %0 : i32
    llvm.br ^bb50(%158 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb56:  // pred: ^bb50
    llvm.br ^bb57(%1 : i32)
  ^bb57(%159: i32):  // 2 preds: ^bb56, ^bb62
    %160 = llvm.icmp "sle" %159, %1 : i32
    llvm.cond_br %160, ^bb58, ^bb63
  ^bb58:  // pred: ^bb57
    %161 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %162 = cce.vdups(%19, %161, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%163: i64):  // 2 preds: ^bb58, ^bb60
    %164 = llvm.icmp "slt" %163, %23 : i64
    llvm.cond_br %164, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %165 = llvm.trunc %163 : i64 to i32
    %166 = llvm.mul %165, %24 : i32
    %167 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %168 = llvm.sext %166 : i32 to i64
    %169 = llvm.getelementptr %167[%168] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%162, %169, %1, %1, %1, %161) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %170 = llvm.add %163, %12 : i64
    llvm.br ^bb59(%170 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %171 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %172 = llvm.getelementptr %171[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%162, %172, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %173 = llvm.add %159, %0 : i32
    llvm.br ^bb57(%173 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%174: i32):  // 2 preds: ^bb63, ^bb72
    %175 = llvm.icmp "sle" %174, %1 : i32
    llvm.cond_br %175, ^bb65, ^bb73
  ^bb65:  // pred: ^bb64
    %176 = cce.pset(%13) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb66(%5 : i64)
  ^bb66(%177: i64):  // 2 preds: ^bb65, ^bb70
    %178 = llvm.icmp "slt" %177, %27 : i64
    llvm.cond_br %178, ^bb67, ^bb71
  ^bb67:  // pred: ^bb66
    %179 = llvm.trunc %177 : i64 to i32
    %180 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %181 = llvm.sext %179 : i32 to i64
    %182 = llvm.getelementptr %180[%181] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %183 = cce.intr.vldsx1.i8(%182, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%184: i64):  // 2 preds: ^bb67, ^bb69
    %185 = llvm.icmp "slt" %184, %7 : i64
    llvm.cond_br %185, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %186 = llvm.trunc %184 : i64 to i32
    %187 = llvm.mul %186, %14 : i32
    %188 = llvm.add %187, %179 : i32
    %189 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %190 = llvm.sext %188 : i32 to i64
    %191 = llvm.getelementptr %189[%190] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%183, %191, %1, %28, %1, %176) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %192 = llvm.add %184, %12 : i64
    llvm.br ^bb68(%192 : i64)
  ^bb70:  // pred: ^bb68
    %193 = llvm.add %177, %12 : i64
    llvm.br ^bb66(%193 : i64)
  ^bb71:  // pred: ^bb66
    llvm.br ^bb72
  ^bb72:  // pred: ^bb71
    %194 = llvm.add %174, %0 : i32
    llvm.br ^bb64(%194 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb73:  // pred: ^bb64
    llvm.br ^bb74(%1 : i32)
  ^bb74(%195: i32):  // 2 preds: ^bb73, ^bb79
    %196 = llvm.icmp "sle" %195, %1 : i32
    llvm.cond_br %196, ^bb75, ^bb80
  ^bb75:  // pred: ^bb74
    %197 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %198 = cce.vdups(%19, %197, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb76(%5 : i64)
  ^bb76(%199: i64):  // 2 preds: ^bb75, ^bb77
    %200 = llvm.icmp "slt" %199, %23 : i64
    llvm.cond_br %200, ^bb77, ^bb78
  ^bb77:  // pred: ^bb76
    %201 = llvm.trunc %199 : i64 to i32
    %202 = llvm.mul %201, %24 : i32
    %203 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %204 = llvm.sext %202 : i32 to i64
    %205 = llvm.getelementptr %203[%204] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%198, %205, %1, %1, %1, %197) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %206 = llvm.add %199, %12 : i64
    llvm.br ^bb76(%206 : i64)
  ^bb78:  // pred: ^bb76
    %dst_12, %restElem_13 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %207 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %208 = llvm.getelementptr %207[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%198, %208, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb79
  ^bb79:  // pred: ^bb78
    %209 = llvm.add %195, %0 : i32
    llvm.br ^bb74(%209 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb80:  // pred: ^bb74
    llvm.br ^bb81(%1 : i32)
  ^bb81(%210: i32):  // 2 preds: ^bb80, ^bb86
    %211 = llvm.icmp "sle" %210, %1 : i32
    llvm.cond_br %211, ^bb82, ^bb87
  ^bb82:  // pred: ^bb81
    %212 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb83(%5 : i64)
  ^bb83(%213: i64):  // 2 preds: ^bb82, ^bb84
    %214 = llvm.icmp "slt" %213, %23 : i64
    llvm.cond_br %214, ^bb84, ^bb85
  ^bb84:  // pred: ^bb83
    %215 = llvm.trunc %213 : i64 to i32
    %216 = llvm.udiv %215, %31 : i32
    %217 = llvm.urem %215, %31 : i32
    %218 = llvm.mul %217, %24 : i32
    %219 = llvm.mul %216, %26 : i32
    %220 = llvm.add %219, %218 : i32
    %221 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %222 = llvm.sext %220 : i32 to i64
    %223 = llvm.getelementptr %221[%222] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %224 = cce.intr.vldsx1.i8(%223, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %225 = cce.vdups(%19, %212, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %226 = cce.cmp(%224, %225, %212) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %227 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %228 = llvm.sext %220 : i32 to i64
    %229 = llvm.getelementptr %227[%228] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %230 = cce.intr.vldsx1.i8(%229, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %231 = cce.cmp(%230, %225, %212) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %232 = cce.pand(%226, %231, %212) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %233 = cce.vdups(%20, %212, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %234 = cce.vsel(%233, %225, %232) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %235 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %236 = llvm.sext %220 : i32 to i64
    %237 = llvm.getelementptr %235[%236] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%234, %237, %1, %1, %1, %212) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %238 = llvm.add %213, %12 : i64
    llvm.br ^bb83(%238 : i64)
  ^bb85:  // pred: ^bb83
    llvm.br ^bb86
  ^bb86:  // pred: ^bb85
    %239 = llvm.add %210, %0 : i32
    llvm.br ^bb81(%239 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb87:  // pred: ^bb81
    %240 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %241 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %242 = llvm.inttoptr %241 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%240, %242, %37, %38) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb88(%1 : i32)
  ^bb88(%243: i32):  // 2 preds: ^bb87, ^bb93
    %244 = llvm.icmp "sle" %243, %1 : i32
    llvm.cond_br %244, ^bb89, ^bb94
  ^bb89:  // pred: ^bb88
    %245 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb90(%5 : i64)
  ^bb90(%246: i64):  // 2 preds: ^bb89, ^bb91
    %247 = llvm.icmp "slt" %246, %6 : i64
    llvm.cond_br %247, ^bb91, ^bb92
  ^bb91:  // pred: ^bb90
    %248 = llvm.mul %246, %33 : i64
    %249 = llvm.trunc %248 : i64 to i32
    %250 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %251 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %252 = llvm.sext %249 : i32 to i64
    %253 = llvm.getelementptr %251[%252] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %254 = cce.intr.vldsx1.i8(%253, %1, %34, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %255 = cce.vcvtii.ext(%254, %250, %1) {unsigned} : (vector<256xi8>, vector<256xi1>, i32) -> vector<128xi16>
    %256 = cce.vdups(%35, %245, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %257 = cce.cmp(%255, %256, %245) {predicate = "ne"} : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<256xi1>
    %258 = llvm.mul %249, %13 : i32
    %259 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %260 = llvm.sext %258 : i32 to i64
    %261 = llvm.getelementptr %259[%260] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %262 = cce.intr.vldsx1.bf16(%261, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %263 = cce.vdups(%10, %245, %1) {mode = ["z"]} : (bf16, vector<256xi1>, i32) -> vector<128xbf16>
    %264 = cce.vsel(%262, %263, %257) : (vector<128xbf16>, vector<128xbf16>, vector<256xi1>) -> vector<128xbf16>
    %265 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %266 = llvm.sext %258 : i32 to i64
    %267 = llvm.getelementptr %265[%266] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%264, %267, %1, %0, %1, %245) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %268 = llvm.add %246, %12 : i64
    llvm.br ^bb90(%268 : i64)
  ^bb92:  // pred: ^bb90
    llvm.br ^bb93
  ^bb93:  // pred: ^bb92
    %269 = llvm.add %243, %0 : i32
    llvm.br ^bb88(%269 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb94:  // pred: ^bb88
    llvm.br ^bb95(%1 : i32)
  ^bb95(%270: i32):  // 2 preds: ^bb94, ^bb100
    %271 = llvm.icmp "sle" %270, %1 : i32
    llvm.cond_br %271, ^bb96, ^bb101
  ^bb96:  // pred: ^bb95
    %dst_14, %restElem_15 = cce.plt(%14) {mask_bitwidth = 16 : i32} : (i32) -> (vector<256xi1>, i32)
    %272 = cce.vdups(%10, %dst_14, %1) {mode = ["z"]} : (bf16, vector<256xi1>, i32) -> vector<128xbf16>
    llvm.br ^bb97(%5, %272 : i64, vector<128xbf16>)
  ^bb97(%273: i64, %274: vector<128xbf16>):  // 2 preds: ^bb96, ^bb98
    %275 = llvm.icmp "slt" %273, %7 : i64
    llvm.cond_br %275, ^bb98, ^bb99
  ^bb98:  // pred: ^bb97
    %276 = llvm.trunc %273 : i64 to i32
    %277 = llvm.mul %276, %8 : i32
    %278 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %279 = llvm.sext %277 : i32 to i64
    %280 = llvm.getelementptr %278[%279] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %281 = cce.intr.vldsx1.bf16(%280, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %282 = cce.vmin(%274, %281, %dst_14) : (vector<128xbf16>, vector<128xbf16>, vector<256xi1>) -> vector<128xbf16>
    %283 = llvm.add %273, %12 : i64
    llvm.br ^bb97(%283, %282 : i64, vector<128xbf16>)
  ^bb99:  // pred: ^bb97
    %284 = llvm.inttoptr %36 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.bf16(%274, %284, %1, %0, %1, %dst_14) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb100
  ^bb100:  // pred: ^bb99
    %285 = llvm.add %270, %0 : i32
    llvm.br ^bb95(%285 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb101:  // pred: ^bb95
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %286 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %287 = llvm.inttoptr %286 : i64 to !llvm.ptr<1>
    %288 = llvm.inttoptr %36 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%287, %288, %39, %40) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


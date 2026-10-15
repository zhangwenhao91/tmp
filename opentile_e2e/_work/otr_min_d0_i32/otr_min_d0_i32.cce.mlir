module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_min_d0_i32(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(64 : index) : i64
    %7 = llvm.mlir.constant(64 : i32) : i32
    %8 = llvm.mlir.constant(16 : i32) : i32
    %9 = llvm.mlir.constant(2147483647 : i32) : i32
    %10 = llvm.mlir.constant(23200 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(4 : i32) : i32
    %13 = llvm.mlir.constant(2 : i32) : i32
    %14 = llvm.mlir.constant(32 : i32) : i32
    %15 = llvm.mlir.constant(23456 : i64) : i64
    %16 = llvm.mlir.constant(23712 : i64) : i64
    %17 = llvm.mlir.constant(23968 : i64) : i64
    %18 = llvm.mlir.constant(24224 : i64) : i64
    %19 = llvm.mlir.constant(0 : i8) : i8
    %20 = llvm.mlir.constant(1 : i8) : i8
    %21 = llvm.mlir.constant(24480 : i64) : i64
    %22 = llvm.mlir.constant(16384 : i64) : i64
    %23 = llvm.mlir.constant(8 : index) : i64
    %24 = llvm.mlir.constant(256 : i32) : i32
    %25 = llvm.mlir.constant(224 : i32) : i32
    %26 = llvm.mlir.constant(2048 : i32) : i32
    %27 = llvm.mlir.constant(32 : index) : i64
    %28 = llvm.mlir.constant(3 : i32) : i32
    %29 = llvm.mlir.constant(18656 : i64) : i64
    %30 = llvm.mlir.constant(20928 : i64) : i64
    %31 = llvm.mlir.constant(8 : i32) : i32
    %32 = llvm.mlir.constant(8192 : i64) : i64
    %33 = llvm.mlir.constant(20 : i32) : i32
    %34 = llvm.mlir.constant(24736 : i64) : i64
    %35 = llvm.mlir.constant(288230378299196416 : i64) : i64
    %36 = llvm.mlir.constant(140737488355392 : i64) : i64
    %37 = llvm.mlir.constant(288230378299195408 : i64) : i64
    %38 = llvm.mlir.constant(70368744177728 : i64) : i64
    %39 = llvm.mlir.constant(128 : i32) : i32
    %40 = cce.get.ctrl -> i64
    %41 = cce.sbitset0(%40, %3) : (i64, i64) -> i64
    cce.set.ctrl(%41) : i64
    %42 = cce.get.ctrl -> i64
    %43 = cce.sbitset1(%42, %2) : (i64, i64) -> i64
    cce.set.ctrl(%43) : i64
    %44 = cce.get_sub_block_idx -> i64
    %45 = llvm.icmp "eq" %44, %4 : i64
    llvm.cond_br %45, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb101
    llvm.return
  ^bb3(%46: i32):  // 2 preds: ^bb1, ^bb5
    %47 = llvm.icmp "sle" %46, %1 : i32
    llvm.cond_br %47, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %48 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %49 = cce.vdups(%1, %48, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %50 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%49, %50, %1, %13, %1, %48) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %51 = llvm.add %46, %0 : i32
    llvm.br ^bb3(%51 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    llvm.br ^bb7(%1 : i32)
  ^bb7(%52: i32):  // 2 preds: ^bb6, ^bb9
    %53 = llvm.icmp "sle" %52, %1 : i32
    llvm.cond_br %53, ^bb8, ^bb10
  ^bb8:  // pred: ^bb7
    %dst, %restElem = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %54 = cce.vdups(%8, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %55 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%54, %55, %1, %13, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %56 = llvm.add %52, %0 : i32
    llvm.br ^bb7(%56 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%57: i32):  // 2 preds: ^bb10, ^bb13
    %58 = llvm.icmp "sle" %57, %1 : i32
    llvm.cond_br %58, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %59 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %60 = cce.vdups(%7, %59, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %61 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%60, %61, %1, %13, %1, %59) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %62 = llvm.add %57, %0 : i32
    llvm.br ^bb11(%62 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%63: i32):  // 2 preds: ^bb14, ^bb17
    %64 = llvm.icmp "sle" %63, %1 : i32
    llvm.cond_br %64, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %65 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %66 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %67 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%66, %67, %1, %13, %1, %65) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb17
  ^bb17:  // pred: ^bb16
    %68 = llvm.add %63, %0 : i32
    llvm.br ^bb15(%68 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb18:  // pred: ^bb15
    llvm.br ^bb19(%1 : i32)
  ^bb19(%69: i32):  // 2 preds: ^bb18, ^bb21
    %70 = llvm.icmp "sle" %69, %1 : i32
    llvm.cond_br %70, ^bb20, ^bb22
  ^bb20:  // pred: ^bb19
    %71 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %72 = cce.vdups(%1, %71, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %73 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%72, %73, %1, %13, %1, %71) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %74 = llvm.add %69, %0 : i32
    llvm.br ^bb19(%74 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%75: i32):  // 2 preds: ^bb22, ^bb25
    %76 = llvm.icmp "sle" %75, %1 : i32
    llvm.cond_br %76, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %77 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %78 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%77, %78, %1, %13, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %79 = llvm.add %75, %0 : i32
    llvm.br ^bb23(%79 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%80: i32):  // 2 preds: ^bb26, ^bb29
    %81 = llvm.icmp "sle" %80, %1 : i32
    llvm.cond_br %81, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %82 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %83 = cce.vdups(%19, %82, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %84 = cce.cmp(%83, %83, %82) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %85 = cce.vdups(%20, %82, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %86 = cce.vsel(%85, %83, %84) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %87 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%86, %87, %1, %1, %1, %82) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb29
  ^bb29:  // pred: ^bb28
    %88 = llvm.add %80, %0 : i32
    llvm.br ^bb27(%88 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb30:  // pred: ^bb27
    llvm.br ^bb31(%1 : i32)
  ^bb31(%89: i32):  // 2 preds: ^bb30, ^bb33
    %90 = llvm.icmp "sle" %89, %1 : i32
    llvm.cond_br %90, ^bb32, ^bb34
  ^bb32:  // pred: ^bb31
    %91 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %92 = cce.intr.vldsx1.i32(%91, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %93 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %94 = cce.intr.vldsx1.i32(%93, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %95 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %96 = cce.cmp(%94, %92, %95) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%7) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %97 = cce.ppack(%96, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %98 = cce.ppack(%97, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %99 = cce.vdups(%19, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %100 = cce.vdups(%20, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %101 = cce.vsel(%100, %99, %98) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %102 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%101, %102, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb33
  ^bb33:  // pred: ^bb32
    %103 = llvm.add %89, %0 : i32
    llvm.br ^bb31(%103 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb34:  // pred: ^bb31
    llvm.br ^bb35(%1 : i32)
  ^bb35(%104: i32):  // 2 preds: ^bb34, ^bb37
    %105 = llvm.icmp "sle" %104, %1 : i32
    llvm.cond_br %105, ^bb36, ^bb38
  ^bb36:  // pred: ^bb35
    %106 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %107 = cce.vdups(%19, %106, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %108 = cce.cmp(%107, %107, %106) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %109 = cce.vdups(%20, %106, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %110 = cce.vsel(%109, %107, %108) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %111 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%110, %111, %1, %1, %1, %106) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb37
  ^bb37:  // pred: ^bb36
    %112 = llvm.add %104, %0 : i32
    llvm.br ^bb35(%112 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb38:  // pred: ^bb35
    llvm.br ^bb39(%1 : i32)
  ^bb39(%113: i32):  // 2 preds: ^bb38, ^bb41
    %114 = llvm.icmp "sle" %113, %1 : i32
    llvm.cond_br %114, ^bb40, ^bb42
  ^bb40:  // pred: ^bb39
    %115 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %116 = cce.intr.vldsx1.i32(%115, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %117 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %118 = cce.intr.vldsx1.i32(%117, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %119 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %120 = cce.cmp(%118, %116, %119) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %121 = cce.ppack(%120, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %122 = cce.ppack(%121, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %123 = cce.vdups(%19, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %124 = cce.vdups(%20, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %125 = cce.vsel(%124, %123, %122) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %126 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%125, %126, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb41
  ^bb41:  // pred: ^bb40
    %127 = llvm.add %113, %0 : i32
    llvm.br ^bb39(%127 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb42:  // pred: ^bb39
    llvm.br ^bb43(%1 : i32)
  ^bb43(%128: i32):  // 2 preds: ^bb42, ^bb48
    %129 = llvm.icmp "sle" %128, %1 : i32
    llvm.cond_br %129, ^bb44, ^bb49
  ^bb44:  // pred: ^bb43
    %130 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %131 = cce.vdups(%19, %130, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%132: i64):  // 2 preds: ^bb44, ^bb46
    %133 = llvm.icmp "slt" %132, %23 : i64
    llvm.cond_br %133, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %134 = llvm.trunc %132 : i64 to i32
    %135 = llvm.mul %134, %24 : i32
    %136 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %137 = llvm.sext %135 : i32 to i64
    %138 = llvm.getelementptr %136[%137] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%131, %138, %1, %1, %1, %130) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %139 = llvm.add %132, %11 : i64
    llvm.br ^bb45(%139 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %140 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %141 = llvm.getelementptr %140[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%131, %141, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    %142 = llvm.add %128, %0 : i32
    llvm.br ^bb43(%142 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb49:  // pred: ^bb43
    llvm.br ^bb50(%1 : i32)
  ^bb50(%143: i32):  // 2 preds: ^bb49, ^bb55
    %144 = llvm.icmp "sle" %143, %1 : i32
    llvm.cond_br %144, ^bb51, ^bb56
  ^bb51:  // pred: ^bb50
    %dst_8, %restElem_9 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%145: i64):  // 2 preds: ^bb51, ^bb53
    %146 = llvm.icmp "slt" %145, %6 : i64
    llvm.cond_br %146, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %147 = llvm.trunc %145 : i64 to i32
    %148 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %149 = llvm.sext %147 : i32 to i64
    %150 = llvm.getelementptr %148[%149] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %151 = cce.intr.vldsx1.i8(%150, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %152 = llvm.mul %147, %14 : i32
    %153 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %154 = llvm.sext %152 : i32 to i64
    %155 = llvm.getelementptr %153[%154] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%151, %155, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %156 = llvm.add %145, %11 : i64
    llvm.br ^bb52(%156 : i64)
  ^bb54:  // pred: ^bb52
    llvm.br ^bb55
  ^bb55:  // pred: ^bb54
    %157 = llvm.add %143, %0 : i32
    llvm.br ^bb50(%157 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb56:  // pred: ^bb50
    llvm.br ^bb57(%1 : i32)
  ^bb57(%158: i32):  // 2 preds: ^bb56, ^bb62
    %159 = llvm.icmp "sle" %158, %1 : i32
    llvm.cond_br %159, ^bb58, ^bb63
  ^bb58:  // pred: ^bb57
    %160 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %161 = cce.vdups(%19, %160, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%162: i64):  // 2 preds: ^bb58, ^bb60
    %163 = llvm.icmp "slt" %162, %23 : i64
    llvm.cond_br %163, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %164 = llvm.trunc %162 : i64 to i32
    %165 = llvm.mul %164, %24 : i32
    %166 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %167 = llvm.sext %165 : i32 to i64
    %168 = llvm.getelementptr %166[%167] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%161, %168, %1, %1, %1, %160) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %169 = llvm.add %162, %11 : i64
    llvm.br ^bb59(%169 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %170 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %171 = llvm.getelementptr %170[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%161, %171, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %172 = llvm.add %158, %0 : i32
    llvm.br ^bb57(%172 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%173: i32):  // 2 preds: ^bb63, ^bb72
    %174 = llvm.icmp "sle" %173, %1 : i32
    llvm.cond_br %174, ^bb65, ^bb73
  ^bb65:  // pred: ^bb64
    %175 = cce.pset(%13) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb66(%5 : i64)
  ^bb66(%176: i64):  // 2 preds: ^bb65, ^bb70
    %177 = llvm.icmp "slt" %176, %27 : i64
    llvm.cond_br %177, ^bb67, ^bb71
  ^bb67:  // pred: ^bb66
    %178 = llvm.trunc %176 : i64 to i32
    %179 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %180 = llvm.sext %178 : i32 to i64
    %181 = llvm.getelementptr %179[%180] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %182 = cce.intr.vldsx1.i8(%181, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%183: i64):  // 2 preds: ^bb67, ^bb69
    %184 = llvm.icmp "slt" %183, %6 : i64
    llvm.cond_br %184, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %185 = llvm.trunc %183 : i64 to i32
    %186 = llvm.mul %185, %14 : i32
    %187 = llvm.add %186, %178 : i32
    %188 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %189 = llvm.sext %187 : i32 to i64
    %190 = llvm.getelementptr %188[%189] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%182, %190, %1, %28, %1, %175) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %191 = llvm.add %183, %11 : i64
    llvm.br ^bb68(%191 : i64)
  ^bb70:  // pred: ^bb68
    %192 = llvm.add %176, %11 : i64
    llvm.br ^bb66(%192 : i64)
  ^bb71:  // pred: ^bb66
    llvm.br ^bb72
  ^bb72:  // pred: ^bb71
    %193 = llvm.add %173, %0 : i32
    llvm.br ^bb64(%193 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb73:  // pred: ^bb64
    llvm.br ^bb74(%1 : i32)
  ^bb74(%194: i32):  // 2 preds: ^bb73, ^bb79
    %195 = llvm.icmp "sle" %194, %1 : i32
    llvm.cond_br %195, ^bb75, ^bb80
  ^bb75:  // pred: ^bb74
    %196 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %197 = cce.vdups(%19, %196, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb76(%5 : i64)
  ^bb76(%198: i64):  // 2 preds: ^bb75, ^bb77
    %199 = llvm.icmp "slt" %198, %23 : i64
    llvm.cond_br %199, ^bb77, ^bb78
  ^bb77:  // pred: ^bb76
    %200 = llvm.trunc %198 : i64 to i32
    %201 = llvm.mul %200, %24 : i32
    %202 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %203 = llvm.sext %201 : i32 to i64
    %204 = llvm.getelementptr %202[%203] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%197, %204, %1, %1, %1, %196) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %205 = llvm.add %198, %11 : i64
    llvm.br ^bb76(%205 : i64)
  ^bb78:  // pred: ^bb76
    %dst_12, %restElem_13 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %206 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %207 = llvm.getelementptr %206[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%197, %207, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb79
  ^bb79:  // pred: ^bb78
    %208 = llvm.add %194, %0 : i32
    llvm.br ^bb74(%208 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb80:  // pred: ^bb74
    llvm.br ^bb81(%1 : i32)
  ^bb81(%209: i32):  // 2 preds: ^bb80, ^bb86
    %210 = llvm.icmp "sle" %209, %1 : i32
    llvm.cond_br %210, ^bb82, ^bb87
  ^bb82:  // pred: ^bb81
    %211 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb83(%5 : i64)
  ^bb83(%212: i64):  // 2 preds: ^bb82, ^bb84
    %213 = llvm.icmp "slt" %212, %23 : i64
    llvm.cond_br %213, ^bb84, ^bb85
  ^bb84:  // pred: ^bb83
    %214 = llvm.trunc %212 : i64 to i32
    %215 = llvm.udiv %214, %31 : i32
    %216 = llvm.urem %214, %31 : i32
    %217 = llvm.mul %216, %24 : i32
    %218 = llvm.mul %215, %26 : i32
    %219 = llvm.add %218, %217 : i32
    %220 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %221 = llvm.sext %219 : i32 to i64
    %222 = llvm.getelementptr %220[%221] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %223 = cce.intr.vldsx1.i8(%222, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %224 = cce.vdups(%19, %211, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %225 = cce.cmp(%223, %224, %211) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %226 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %227 = llvm.sext %219 : i32 to i64
    %228 = llvm.getelementptr %226[%227] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %229 = cce.intr.vldsx1.i8(%228, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %230 = cce.cmp(%229, %224, %211) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %231 = cce.pand(%225, %230, %211) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %232 = cce.vdups(%20, %211, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %233 = cce.vsel(%232, %224, %231) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %234 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %235 = llvm.sext %219 : i32 to i64
    %236 = llvm.getelementptr %234[%235] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%233, %236, %1, %1, %1, %211) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %237 = llvm.add %212, %11 : i64
    llvm.br ^bb83(%237 : i64)
  ^bb85:  // pred: ^bb83
    llvm.br ^bb86
  ^bb86:  // pred: ^bb85
    %238 = llvm.add %209, %0 : i32
    llvm.br ^bb81(%238 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb87:  // pred: ^bb81
    %239 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %240 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %241 = llvm.inttoptr %240 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%239, %241, %35, %36) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb88(%1 : i32)
  ^bb88(%242: i32):  // 2 preds: ^bb87, ^bb93
    %243 = llvm.icmp "sle" %242, %1 : i32
    llvm.cond_br %243, ^bb89, ^bb94
  ^bb89:  // pred: ^bb88
    %244 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb90(%5 : i64)
  ^bb90(%245: i64):  // 2 preds: ^bb89, ^bb91
    %246 = llvm.icmp "slt" %245, %27 : i64
    llvm.cond_br %246, ^bb91, ^bb92
  ^bb91:  // pred: ^bb90
    %247 = llvm.mul %245, %6 : i64
    %248 = llvm.trunc %247 : i64 to i32
    %249 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %250 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %251 = llvm.sext %248 : i32 to i64
    %252 = llvm.getelementptr %250[%251] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %253 = cce.intr.vldsx1.i8(%252, %1, %33, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %254 = cce.vcvtii.ext(%253, %249, %1) : (vector<256xi8>, vector<256xi1>, i32) -> vector<64xi32>
    %255 = cce.vdups(%1, %244, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %256 = cce.cmp(%254, %255, %244) {predicate = "ne"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %257 = llvm.mul %248, %12 : i32
    %258 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %259 = llvm.sext %257 : i32 to i64
    %260 = llvm.getelementptr %258[%259] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %261 = cce.intr.vldsx1.i32(%260, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %262 = cce.vdups(%9, %244, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %263 = cce.vsel(%261, %262, %256) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %264 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %265 = llvm.sext %257 : i32 to i64
    %266 = llvm.getelementptr %264[%265] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i32(%263, %266, %1, %13, %1, %244) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    %267 = llvm.add %245, %11 : i64
    llvm.br ^bb90(%267 : i64)
  ^bb92:  // pred: ^bb90
    llvm.br ^bb93
  ^bb93:  // pred: ^bb92
    %268 = llvm.add %242, %0 : i32
    llvm.br ^bb88(%268 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb94:  // pred: ^bb88
    llvm.br ^bb95(%1 : i32)
  ^bb95(%269: i32):  // 2 preds: ^bb94, ^bb100
    %270 = llvm.icmp "sle" %269, %1 : i32
    llvm.cond_br %270, ^bb96, ^bb101
  ^bb96:  // pred: ^bb95
    %dst_14, %restElem_15 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %271 = cce.vdups(%9, %dst_14, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    llvm.br ^bb97(%5, %271 : i64, vector<64xi32>)
  ^bb97(%272: i64, %273: vector<64xi32>):  // 2 preds: ^bb96, ^bb98
    %274 = llvm.icmp "slt" %272, %6 : i64
    llvm.cond_br %274, ^bb98, ^bb99
  ^bb98:  // pred: ^bb97
    %275 = llvm.trunc %272 : i64 to i32
    %276 = llvm.mul %275, %39 : i32
    %277 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %278 = llvm.sext %276 : i32 to i64
    %279 = llvm.getelementptr %277[%278] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %280 = cce.intr.vldsx1.i32(%279, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %281 = cce.vmin(%273, %280, %dst_14) : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<64xi32>
    %282 = llvm.add %272, %11 : i64
    llvm.br ^bb97(%282, %281 : i64, vector<64xi32>)
  ^bb99:  // pred: ^bb97
    %283 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%273, %283, %1, %13, %1, %dst_14) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb100
  ^bb100:  // pred: ^bb99
    %284 = llvm.add %269, %0 : i32
    llvm.br ^bb95(%284 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb101:  // pred: ^bb95
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %285 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %286 = llvm.inttoptr %285 : i64 to !llvm.ptr<1>
    %287 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%286, %287, %37, %38) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


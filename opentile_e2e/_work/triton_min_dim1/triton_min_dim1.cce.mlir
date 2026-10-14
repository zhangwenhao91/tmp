module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @triton_min_dim1(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
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
    %10 = llvm.mlir.constant(0x7C00 : f16) : f16
    %11 = llvm.mlir.constant(23200 : i64) : i64
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.mlir.constant(4 : i32) : i32
    %14 = llvm.mlir.constant(2 : i32) : i32
    %15 = llvm.mlir.constant(32 : i32) : i32
    %16 = llvm.mlir.constant(23456 : i64) : i64
    %17 = llvm.mlir.constant(23712 : i64) : i64
    %18 = llvm.mlir.constant(23968 : i64) : i64
    %19 = llvm.mlir.constant(24224 : i64) : i64
    %20 = llvm.mlir.constant(0 : i8) : i8
    %21 = llvm.mlir.constant(1 : i8) : i8
    %22 = llvm.mlir.constant(24480 : i64) : i64
    %23 = llvm.mlir.constant(16384 : i64) : i64
    %24 = llvm.mlir.constant(8 : index) : i64
    %25 = llvm.mlir.constant(256 : i32) : i32
    %26 = llvm.mlir.constant(224 : i32) : i32
    %27 = llvm.mlir.constant(2048 : i32) : i32
    %28 = llvm.mlir.constant(32 : index) : i64
    %29 = llvm.mlir.constant(3 : i32) : i32
    %30 = llvm.mlir.constant(18656 : i64) : i64
    %31 = llvm.mlir.constant(20928 : i64) : i64
    %32 = llvm.mlir.constant(8 : i32) : i32
    %33 = llvm.mlir.constant(12288 : i64) : i64
    %34 = llvm.mlir.constant(8192 : i64) : i64
    %35 = llvm.mlir.constant(128 : index) : i64
    %36 = llvm.mlir.constant(13 : i32) : i32
    %37 = llvm.mlir.constant(0 : i16) : i16
    %38 = llvm.mlir.constant(14 : i32) : i32
    %39 = llvm.mlir.constant(512 : i32) : i32
    %40 = llvm.mlir.constant(128 : i32) : i32
    %41 = llvm.mlir.constant(24736 : i64) : i64
    %42 = llvm.mlir.constant(5 : i32) : i32
    %43 = llvm.mlir.constant(24992 : i64) : i64
    %44 = llvm.mlir.constant(7 : i32) : i32
    %45 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %46 = llvm.mlir.constant(35184372088864 : i64) : i64
    %47 = llvm.mlir.constant(288230377225454592 : i64) : i64
    %48 = llvm.mlir.constant(70368744177696 : i64) : i64
    %49 = cce.get.ctrl -> i64
    %50 = cce.sbitset0(%49, %3) : (i64, i64) -> i64
    cce.set.ctrl(%50) : i64
    %51 = cce.get.ctrl -> i64
    %52 = cce.sbitset1(%51, %2) : (i64, i64) -> i64
    cce.set.ctrl(%52) : i64
    %53 = cce.get_sub_block_idx -> i64
    %54 = llvm.icmp "eq" %53, %4 : i64
    llvm.cond_br %54, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb112
    llvm.return
  ^bb3(%55: i32):  // 2 preds: ^bb1, ^bb5
    %56 = llvm.icmp "sle" %55, %1 : i32
    llvm.cond_br %56, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %57 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %58 = cce.vdups(%1, %57, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %59 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%58, %59, %1, %14, %1, %57) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %60 = llvm.add %55, %0 : i32
    llvm.br ^bb3(%60 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    llvm.br ^bb7(%1 : i32)
  ^bb7(%61: i32):  // 2 preds: ^bb6, ^bb9
    %62 = llvm.icmp "sle" %61, %1 : i32
    llvm.cond_br %62, ^bb8, ^bb10
  ^bb8:  // pred: ^bb7
    %dst, %restElem = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %63 = cce.vdups(%9, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %64 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%63, %64, %1, %14, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %65 = llvm.add %61, %0 : i32
    llvm.br ^bb7(%65 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%66: i32):  // 2 preds: ^bb10, ^bb13
    %67 = llvm.icmp "sle" %66, %1 : i32
    llvm.cond_br %67, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %68 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %69 = cce.vdups(%8, %68, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %70 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%69, %70, %1, %14, %1, %68) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %71 = llvm.add %66, %0 : i32
    llvm.br ^bb11(%71 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%72: i32):  // 2 preds: ^bb14, ^bb17
    %73 = llvm.icmp "sle" %72, %1 : i32
    llvm.cond_br %73, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %74 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %75 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %76 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%75, %76, %1, %14, %1, %74) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb17
  ^bb17:  // pred: ^bb16
    %77 = llvm.add %72, %0 : i32
    llvm.br ^bb15(%77 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb18:  // pred: ^bb15
    llvm.br ^bb19(%1 : i32)
  ^bb19(%78: i32):  // 2 preds: ^bb18, ^bb21
    %79 = llvm.icmp "sle" %78, %1 : i32
    llvm.cond_br %79, ^bb20, ^bb22
  ^bb20:  // pred: ^bb19
    %80 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %81 = cce.vdups(%1, %80, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %82 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%81, %82, %1, %14, %1, %80) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %83 = llvm.add %78, %0 : i32
    llvm.br ^bb19(%83 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%84: i32):  // 2 preds: ^bb22, ^bb25
    %85 = llvm.icmp "sle" %84, %1 : i32
    llvm.cond_br %85, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %86 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %87 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%86, %87, %1, %14, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %88 = llvm.add %84, %0 : i32
    llvm.br ^bb23(%88 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%89: i32):  // 2 preds: ^bb26, ^bb29
    %90 = llvm.icmp "sle" %89, %1 : i32
    llvm.cond_br %90, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %91 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %92 = cce.vdups(%20, %91, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %93 = cce.cmp(%92, %92, %91) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %94 = cce.vdups(%21, %91, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %95 = cce.vsel(%94, %92, %93) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %96 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%95, %96, %1, %1, %1, %91) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb29
  ^bb29:  // pred: ^bb28
    %97 = llvm.add %89, %0 : i32
    llvm.br ^bb27(%97 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb30:  // pred: ^bb27
    llvm.br ^bb31(%1 : i32)
  ^bb31(%98: i32):  // 2 preds: ^bb30, ^bb33
    %99 = llvm.icmp "sle" %98, %1 : i32
    llvm.cond_br %99, ^bb32, ^bb34
  ^bb32:  // pred: ^bb31
    %100 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %101 = cce.intr.vldsx1.i32(%100, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %102 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %103 = cce.intr.vldsx1.i32(%102, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %104 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %105 = cce.cmp(%103, %101, %104) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%8) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %106 = cce.ppack(%105, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %107 = cce.ppack(%106, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %108 = cce.vdups(%20, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %109 = cce.vdups(%21, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %110 = cce.vsel(%109, %108, %107) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %111 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%110, %111, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb33
  ^bb33:  // pred: ^bb32
    %112 = llvm.add %98, %0 : i32
    llvm.br ^bb31(%112 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb34:  // pred: ^bb31
    llvm.br ^bb35(%1 : i32)
  ^bb35(%113: i32):  // 2 preds: ^bb34, ^bb37
    %114 = llvm.icmp "sle" %113, %1 : i32
    llvm.cond_br %114, ^bb36, ^bb38
  ^bb36:  // pred: ^bb35
    %115 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %116 = cce.vdups(%20, %115, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %117 = cce.cmp(%116, %116, %115) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %118 = cce.vdups(%21, %115, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %119 = cce.vsel(%118, %116, %117) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %120 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%119, %120, %1, %1, %1, %115) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb37
  ^bb37:  // pred: ^bb36
    %121 = llvm.add %113, %0 : i32
    llvm.br ^bb35(%121 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb38:  // pred: ^bb35
    llvm.br ^bb39(%1 : i32)
  ^bb39(%122: i32):  // 2 preds: ^bb38, ^bb41
    %123 = llvm.icmp "sle" %122, %1 : i32
    llvm.cond_br %123, ^bb40, ^bb42
  ^bb40:  // pred: ^bb39
    %124 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %125 = cce.intr.vldsx1.i32(%124, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %126 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %127 = cce.intr.vldsx1.i32(%126, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %128 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %129 = cce.cmp(%127, %125, %128) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %130 = cce.ppack(%129, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %131 = cce.ppack(%130, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %132 = cce.vdups(%20, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %133 = cce.vdups(%21, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %134 = cce.vsel(%133, %132, %131) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %135 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%134, %135, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb41
  ^bb41:  // pred: ^bb40
    %136 = llvm.add %122, %0 : i32
    llvm.br ^bb39(%136 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb42:  // pred: ^bb39
    llvm.br ^bb43(%1 : i32)
  ^bb43(%137: i32):  // 2 preds: ^bb42, ^bb48
    %138 = llvm.icmp "sle" %137, %1 : i32
    llvm.cond_br %138, ^bb44, ^bb49
  ^bb44:  // pred: ^bb43
    %139 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %140 = cce.vdups(%20, %139, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%141: i64):  // 2 preds: ^bb44, ^bb46
    %142 = llvm.icmp "slt" %141, %24 : i64
    llvm.cond_br %142, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %143 = llvm.trunc %141 : i64 to i32
    %144 = llvm.mul %143, %25 : i32
    %145 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %146 = llvm.sext %144 : i32 to i64
    %147 = llvm.getelementptr %145[%146] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%140, %147, %1, %1, %1, %139) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %148 = llvm.add %141, %12 : i64
    llvm.br ^bb45(%148 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %149 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %150 = llvm.getelementptr %149[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%140, %150, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    %151 = llvm.add %137, %0 : i32
    llvm.br ^bb43(%151 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb49:  // pred: ^bb43
    llvm.br ^bb50(%1 : i32)
  ^bb50(%152: i32):  // 2 preds: ^bb49, ^bb55
    %153 = llvm.icmp "sle" %152, %1 : i32
    llvm.cond_br %153, ^bb51, ^bb56
  ^bb51:  // pred: ^bb50
    %dst_8, %restElem_9 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%154: i64):  // 2 preds: ^bb51, ^bb53
    %155 = llvm.icmp "slt" %154, %7 : i64
    llvm.cond_br %155, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %156 = llvm.trunc %154 : i64 to i32
    %157 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %158 = llvm.sext %156 : i32 to i64
    %159 = llvm.getelementptr %157[%158] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %160 = cce.intr.vldsx1.i8(%159, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %161 = llvm.mul %156, %15 : i32
    %162 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %163 = llvm.sext %161 : i32 to i64
    %164 = llvm.getelementptr %162[%163] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%160, %164, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %165 = llvm.add %154, %12 : i64
    llvm.br ^bb52(%165 : i64)
  ^bb54:  // pred: ^bb52
    llvm.br ^bb55
  ^bb55:  // pred: ^bb54
    %166 = llvm.add %152, %0 : i32
    llvm.br ^bb50(%166 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb56:  // pred: ^bb50
    llvm.br ^bb57(%1 : i32)
  ^bb57(%167: i32):  // 2 preds: ^bb56, ^bb62
    %168 = llvm.icmp "sle" %167, %1 : i32
    llvm.cond_br %168, ^bb58, ^bb63
  ^bb58:  // pred: ^bb57
    %169 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %170 = cce.vdups(%20, %169, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%171: i64):  // 2 preds: ^bb58, ^bb60
    %172 = llvm.icmp "slt" %171, %24 : i64
    llvm.cond_br %172, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %173 = llvm.trunc %171 : i64 to i32
    %174 = llvm.mul %173, %25 : i32
    %175 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %176 = llvm.sext %174 : i32 to i64
    %177 = llvm.getelementptr %175[%176] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%170, %177, %1, %1, %1, %169) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %178 = llvm.add %171, %12 : i64
    llvm.br ^bb59(%178 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %179 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %180 = llvm.getelementptr %179[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%170, %180, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %181 = llvm.add %167, %0 : i32
    llvm.br ^bb57(%181 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%182: i32):  // 2 preds: ^bb63, ^bb72
    %183 = llvm.icmp "sle" %182, %1 : i32
    llvm.cond_br %183, ^bb65, ^bb73
  ^bb65:  // pred: ^bb64
    %184 = cce.pset(%14) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb66(%5 : i64)
  ^bb66(%185: i64):  // 2 preds: ^bb65, ^bb70
    %186 = llvm.icmp "slt" %185, %28 : i64
    llvm.cond_br %186, ^bb67, ^bb71
  ^bb67:  // pred: ^bb66
    %187 = llvm.trunc %185 : i64 to i32
    %188 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %189 = llvm.sext %187 : i32 to i64
    %190 = llvm.getelementptr %188[%189] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %191 = cce.intr.vldsx1.i8(%190, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%192: i64):  // 2 preds: ^bb67, ^bb69
    %193 = llvm.icmp "slt" %192, %7 : i64
    llvm.cond_br %193, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %194 = llvm.trunc %192 : i64 to i32
    %195 = llvm.mul %194, %15 : i32
    %196 = llvm.add %195, %187 : i32
    %197 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %198 = llvm.sext %196 : i32 to i64
    %199 = llvm.getelementptr %197[%198] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%191, %199, %1, %29, %1, %184) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %200 = llvm.add %192, %12 : i64
    llvm.br ^bb68(%200 : i64)
  ^bb70:  // pred: ^bb68
    %201 = llvm.add %185, %12 : i64
    llvm.br ^bb66(%201 : i64)
  ^bb71:  // pred: ^bb66
    llvm.br ^bb72
  ^bb72:  // pred: ^bb71
    %202 = llvm.add %182, %0 : i32
    llvm.br ^bb64(%202 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb73:  // pred: ^bb64
    llvm.br ^bb74(%1 : i32)
  ^bb74(%203: i32):  // 2 preds: ^bb73, ^bb79
    %204 = llvm.icmp "sle" %203, %1 : i32
    llvm.cond_br %204, ^bb75, ^bb80
  ^bb75:  // pred: ^bb74
    %205 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %206 = cce.vdups(%20, %205, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb76(%5 : i64)
  ^bb76(%207: i64):  // 2 preds: ^bb75, ^bb77
    %208 = llvm.icmp "slt" %207, %24 : i64
    llvm.cond_br %208, ^bb77, ^bb78
  ^bb77:  // pred: ^bb76
    %209 = llvm.trunc %207 : i64 to i32
    %210 = llvm.mul %209, %25 : i32
    %211 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %212 = llvm.sext %210 : i32 to i64
    %213 = llvm.getelementptr %211[%212] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%206, %213, %1, %1, %1, %205) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %214 = llvm.add %207, %12 : i64
    llvm.br ^bb76(%214 : i64)
  ^bb78:  // pred: ^bb76
    %dst_12, %restElem_13 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %215 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %216 = llvm.getelementptr %215[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%206, %216, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb79
  ^bb79:  // pred: ^bb78
    %217 = llvm.add %203, %0 : i32
    llvm.br ^bb74(%217 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb80:  // pred: ^bb74
    llvm.br ^bb81(%1 : i32)
  ^bb81(%218: i32):  // 2 preds: ^bb80, ^bb86
    %219 = llvm.icmp "sle" %218, %1 : i32
    llvm.cond_br %219, ^bb82, ^bb87
  ^bb82:  // pred: ^bb81
    %220 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb83(%5 : i64)
  ^bb83(%221: i64):  // 2 preds: ^bb82, ^bb84
    %222 = llvm.icmp "slt" %221, %24 : i64
    llvm.cond_br %222, ^bb84, ^bb85
  ^bb84:  // pred: ^bb83
    %223 = llvm.trunc %221 : i64 to i32
    %224 = llvm.udiv %223, %32 : i32
    %225 = llvm.urem %223, %32 : i32
    %226 = llvm.mul %225, %25 : i32
    %227 = llvm.mul %224, %27 : i32
    %228 = llvm.add %227, %226 : i32
    %229 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %230 = llvm.sext %228 : i32 to i64
    %231 = llvm.getelementptr %229[%230] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %232 = cce.intr.vldsx1.i8(%231, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %233 = cce.vdups(%20, %220, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %234 = cce.cmp(%232, %233, %220) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %235 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %236 = llvm.sext %228 : i32 to i64
    %237 = llvm.getelementptr %235[%236] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %238 = cce.intr.vldsx1.i8(%237, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %239 = cce.cmp(%238, %233, %220) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %240 = cce.pand(%234, %239, %220) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %241 = cce.vdups(%21, %220, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %242 = cce.vsel(%241, %233, %240) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %243 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %244 = llvm.sext %228 : i32 to i64
    %245 = llvm.getelementptr %243[%244] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%242, %245, %1, %1, %1, %220) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %246 = llvm.add %221, %12 : i64
    llvm.br ^bb83(%246 : i64)
  ^bb85:  // pred: ^bb83
    llvm.br ^bb86
  ^bb86:  // pred: ^bb85
    %247 = llvm.add %218, %0 : i32
    llvm.br ^bb81(%247 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb87:  // pred: ^bb81
    %248 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    %249 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %250 = llvm.inttoptr %249 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%248, %250, %47, %48) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb88(%1 : i32)
  ^bb88(%251: i32):  // 2 preds: ^bb87, ^bb93
    %252 = llvm.icmp "sle" %251, %1 : i32
    llvm.cond_br %252, ^bb89, ^bb94
  ^bb89:  // pred: ^bb88
    %253 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb90(%5 : i64)
  ^bb90(%254: i64):  // 2 preds: ^bb89, ^bb91
    %255 = llvm.icmp "slt" %254, %6 : i64
    llvm.cond_br %255, ^bb91, ^bb92
  ^bb91:  // pred: ^bb90
    %256 = llvm.mul %254, %35 : i64
    %257 = llvm.trunc %256 : i64 to i32
    %258 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %259 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %260 = llvm.sext %257 : i32 to i64
    %261 = llvm.getelementptr %259[%260] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %262 = cce.intr.vldsx1.i8(%261, %1, %36, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %263 = cce.vcvtii.ext(%262, %258, %1) {unsigned} : (vector<256xi8>, vector<256xi1>, i32) -> vector<128xi16>
    %264 = cce.vdups(%37, %253, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %265 = cce.cmp(%263, %264, %253) {predicate = "ne"} : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<256xi1>
    %266 = llvm.mul %257, %14 : i32
    %267 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    %268 = llvm.sext %266 : i32 to i64
    %269 = llvm.getelementptr %267[%268] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %270 = cce.intr.vldsx1.f16(%269, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %271 = cce.vdups(%10, %253, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %272 = cce.vsel(%270, %271, %265) : (vector<128xf16>, vector<128xf16>, vector<256xi1>) -> vector<128xf16>
    %273 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %274 = llvm.sext %266 : i32 to i64
    %275 = llvm.getelementptr %273[%274] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%272, %275, %1, %0, %1, %253) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %276 = llvm.add %254, %12 : i64
    llvm.br ^bb90(%276 : i64)
  ^bb92:  // pred: ^bb90
    llvm.br ^bb93
  ^bb93:  // pred: ^bb92
    %277 = llvm.add %251, %0 : i32
    llvm.br ^bb88(%277 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb94:  // pred: ^bb88
    llvm.br ^bb95(%1 : i32)
  ^bb95(%278: i32):  // 2 preds: ^bb94, ^bb100
    %279 = llvm.icmp "sle" %278, %1 : i32
    llvm.cond_br %279, ^bb96, ^bb101
  ^bb96:  // pred: ^bb95
    %280 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %281 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb97(%5 : i64)
  ^bb97(%282: i64):  // 2 preds: ^bb96, ^bb98
    %283 = llvm.icmp "slt" %282, %6 : i64
    llvm.cond_br %283, ^bb98, ^bb99
  ^bb98:  // pred: ^bb97
    %284 = llvm.trunc %282 : i64 to i32
    %285 = llvm.mul %284, %25 : i32
    %286 = llvm.mul %284, %39 : i32
    %287 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %288 = llvm.sext %285 : i32 to i64
    %289 = llvm.getelementptr %287[%288] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %290 = cce.intr.vldsx1.f16(%289, %1, %38, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %291 = cce.vcvtff.ext(%290, %280, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %292 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %293 = llvm.sext %286 : i32 to i64
    %294 = llvm.getelementptr %292[%293] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%291, %294, %1, %14, %1, %281) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %295 = llvm.add %285, %40 : i32
    %296 = llvm.add %286, %25 : i32
    %297 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %298 = llvm.sext %295 : i32 to i64
    %299 = llvm.getelementptr %297[%298] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %300 = cce.intr.vldsx1.f16(%299, %1, %38, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %301 = cce.vcvtff.ext(%300, %280, %1) : (vector<128xf16>, vector<256xi1>, i32) -> vector<64xf32>
    %302 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %303 = llvm.sext %296 : i32 to i64
    %304 = llvm.getelementptr %302[%303] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%301, %304, %1, %14, %1, %281) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %305 = llvm.add %282, %12 : i64
    llvm.br ^bb97(%305 : i64)
  ^bb99:  // pred: ^bb97
    llvm.br ^bb100
  ^bb100:  // pred: ^bb99
    %306 = llvm.add %278, %0 : i32
    llvm.br ^bb95(%306 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb101:  // pred: ^bb95
    llvm.br ^bb102(%1 : i32)
  ^bb102(%307: i32):  // 2 preds: ^bb101, ^bb107
    %308 = llvm.icmp "sle" %307, %1 : i32
    llvm.cond_br %308, ^bb103, ^bb108
  ^bb103:  // pred: ^bb102
    %dst_14, %restElem_15 = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %309 = cce.pset(%14) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb104(%5 : i64)
  ^bb104(%310: i64):  // 2 preds: ^bb103, ^bb105
    %311 = llvm.icmp "slt" %310, %7 : i64
    llvm.cond_br %311, ^bb105, ^bb106
  ^bb105:  // pred: ^bb104
    %312 = llvm.trunc %310 : i64 to i32
    %313 = llvm.mul %312, %40 : i32
    %314 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %315 = llvm.sext %313 : i32 to i64
    %316 = llvm.getelementptr %314[%315] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %317 = cce.intr.vldsx1.f32(%316, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %318 = cce.vcmin(%317, %dst_14) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %319 = llvm.mul %312, %13 : i32
    %320 = llvm.inttoptr %41 : i64 to !llvm.ptr<6>
    %321 = llvm.sext %319 : i32 to i64
    %322 = llvm.getelementptr %320[%321] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%318, %322, %1, %42, %1, %309) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %323 = llvm.add %310, %12 : i64
    llvm.br ^bb104(%323 : i64)
  ^bb106:  // pred: ^bb104
    llvm.br ^bb107
  ^bb107:  // pred: ^bb106
    %324 = llvm.add %307, %0 : i32
    llvm.br ^bb102(%324 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb108:  // pred: ^bb102
    llvm.br ^bb109(%1 : i32)
  ^bb109(%325: i32):  // 2 preds: ^bb108, ^bb111
    %326 = llvm.icmp "sle" %325, %1 : i32
    llvm.cond_br %326, ^bb110, ^bb112
  ^bb110:  // pred: ^bb109
    %327 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %328 = llvm.inttoptr %41 : i64 to !llvm.ptr<6>
    %329 = cce.intr.vldsx1.f32(%328, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %330 = cce.vcvtff.trunc(%329, %327, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xf16>
    %331 = llvm.inttoptr %43 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f16(%330, %331, %1, %44, %1, %327) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb111
  ^bb111:  // pred: ^bb110
    %332 = llvm.add %325, %0 : i32
    llvm.br ^bb109(%332 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb112:  // pred: ^bb109
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %333 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %334 = llvm.inttoptr %333 : i64 to !llvm.ptr<1>
    %335 = llvm.inttoptr %43 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%334, %335, %45, %46) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


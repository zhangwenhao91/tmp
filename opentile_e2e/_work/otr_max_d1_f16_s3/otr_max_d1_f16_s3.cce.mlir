module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_max_d1_f16_s3(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(32 : index) : i64
    %7 = llvm.mlir.constant(32 : i32) : i32
    %8 = llvm.mlir.constant(48 : i32) : i32
    %9 = llvm.mlir.constant(0xFC00 : f16) : f16
    %10 = llvm.mlir.constant(14912 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(4 : i32) : i32
    %13 = llvm.mlir.constant(2 : i32) : i32
    %14 = llvm.mlir.constant(15168 : i64) : i64
    %15 = llvm.mlir.constant(64 : i32) : i32
    %16 = llvm.mlir.constant(15424 : i64) : i64
    %17 = llvm.mlir.constant(15680 : i64) : i64
    %18 = llvm.mlir.constant(15936 : i64) : i64
    %19 = llvm.mlir.constant(0 : i8) : i8
    %20 = llvm.mlir.constant(1 : i8) : i8
    %21 = llvm.mlir.constant(16192 : i64) : i64
    %22 = llvm.mlir.constant(8192 : i64) : i64
    %23 = llvm.mlir.constant(8 : index) : i64
    %24 = llvm.mlir.constant(256 : i32) : i32
    %25 = llvm.mlir.constant(192 : i32) : i32
    %26 = llvm.mlir.constant(2048 : i32) : i32
    %27 = llvm.mlir.constant(10432 : i64) : i64
    %28 = llvm.mlir.constant(20 : i32) : i32
    %29 = llvm.mlir.constant(12 : i32) : i32
    %30 = llvm.mlir.constant(12672 : i64) : i64
    %31 = llvm.mlir.constant(8 : i32) : i32
    %32 = llvm.mlir.constant(4096 : i64) : i64
    %33 = llvm.mlir.constant(16 : index) : i64
    %34 = llvm.mlir.constant(128 : index) : i64
    %35 = llvm.mlir.constant(13 : i32) : i32
    %36 = llvm.mlir.constant(0 : i16) : i16
    %37 = llvm.mlir.constant(16448 : i64) : i64
    %38 = llvm.mlir.constant(288230377225453600 : i64) : i64
    %39 = llvm.mlir.constant(35184372088864 : i64) : i64
    %40 = llvm.mlir.constant(288230379372937728 : i64) : i64
    %41 = llvm.mlir.constant(140737488355424 : i64) : i64
    %42 = llvm.mlir.constant(128 : i32) : i32
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
  ^bb2:  // 2 preds: ^bb0, ^bb98
    llvm.return
  ^bb3(%49: i32):  // 2 preds: ^bb1, ^bb5
    %50 = llvm.icmp "sle" %49, %1 : i32
    llvm.cond_br %50, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %51 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %52 = cce.vdups(%8, %51, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %53 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
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
    %57 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %58 = cce.vdups(%1, %57, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %59 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%58, %59, %1, %13, %1, %57) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %60 = llvm.add %55, %0 : i32
    llvm.br ^bb7(%60 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%61: i32):  // 2 preds: ^bb10, ^bb13
    %62 = llvm.icmp "sle" %61, %1 : i32
    llvm.cond_br %62, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %dst, %restElem = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %63 = cce.vdups(%7, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %64 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%63, %64, %1, %13, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %65 = llvm.add %61, %0 : i32
    llvm.br ^bb11(%65 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%66: i32):  // 2 preds: ^bb14, ^bb17
    %67 = llvm.icmp "sle" %66, %1 : i32
    llvm.cond_br %67, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %68 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %69 = cce.vdups(%1, %68, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %70 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%69, %70, %1, %13, %1, %68) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb17
  ^bb17:  // pred: ^bb16
    %71 = llvm.add %66, %0 : i32
    llvm.br ^bb15(%71 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb18:  // pred: ^bb15
    llvm.br ^bb19(%1 : i32)
  ^bb19(%72: i32):  // 2 preds: ^bb18, ^bb21
    %73 = llvm.icmp "sle" %72, %1 : i32
    llvm.cond_br %73, ^bb20, ^bb22
  ^bb20:  // pred: ^bb19
    %74 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %75 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%74, %75, %1, %13, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %76 = llvm.add %72, %0 : i32
    llvm.br ^bb19(%76 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%77: i32):  // 2 preds: ^bb22, ^bb25
    %78 = llvm.icmp "sle" %77, %1 : i32
    llvm.cond_br %78, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %79 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %80 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %81 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%80, %81, %1, %13, %1, %79) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %82 = llvm.add %77, %0 : i32
    llvm.br ^bb23(%82 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%83: i32):  // 2 preds: ^bb26, ^bb29
    %84 = llvm.icmp "sle" %83, %1 : i32
    llvm.cond_br %84, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %85 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %86 = cce.vdups(%19, %85, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %87 = cce.cmp(%86, %86, %85) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %88 = cce.vdups(%20, %85, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %89 = cce.vsel(%88, %86, %87) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %90 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%89, %90, %1, %1, %1, %85) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb29
  ^bb29:  // pred: ^bb28
    %91 = llvm.add %83, %0 : i32
    llvm.br ^bb27(%91 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb30:  // pred: ^bb27
    llvm.br ^bb31(%1 : i32)
  ^bb31(%92: i32):  // 2 preds: ^bb30, ^bb33
    %93 = llvm.icmp "sle" %92, %1 : i32
    llvm.cond_br %93, ^bb32, ^bb34
  ^bb32:  // pred: ^bb31
    %94 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    %95 = cce.intr.vldsx1.i32(%94, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %96 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %97 = cce.intr.vldsx1.i32(%96, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %98 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %99 = cce.cmp(%97, %95, %98) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%7) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %100 = cce.ppack(%99, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %101 = cce.ppack(%100, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %102 = cce.vdups(%19, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %103 = cce.vdups(%20, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %104 = cce.vsel(%103, %102, %101) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %105 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%104, %105, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb33
  ^bb33:  // pred: ^bb32
    %106 = llvm.add %92, %0 : i32
    llvm.br ^bb31(%106 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb34:  // pred: ^bb31
    llvm.br ^bb35(%1 : i32)
  ^bb35(%107: i32):  // 2 preds: ^bb34, ^bb37
    %108 = llvm.icmp "sle" %107, %1 : i32
    llvm.cond_br %108, ^bb36, ^bb38
  ^bb36:  // pred: ^bb35
    %109 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %110 = cce.vdups(%19, %109, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %111 = cce.cmp(%110, %110, %109) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %112 = cce.vdups(%20, %109, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %113 = cce.vsel(%112, %110, %111) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %114 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%113, %114, %1, %1, %1, %109) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb37
  ^bb37:  // pred: ^bb36
    %115 = llvm.add %107, %0 : i32
    llvm.br ^bb35(%115 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb38:  // pred: ^bb35
    llvm.br ^bb39(%1 : i32)
  ^bb39(%116: i32):  // 2 preds: ^bb38, ^bb41
    %117 = llvm.icmp "sle" %116, %1 : i32
    llvm.cond_br %117, ^bb40, ^bb42
  ^bb40:  // pred: ^bb39
    %118 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %119 = cce.intr.vldsx1.i32(%118, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %120 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %121 = cce.intr.vldsx1.i32(%120, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %122 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %123 = cce.cmp(%121, %119, %122) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %124 = cce.ppack(%123, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %125 = cce.ppack(%124, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %126 = cce.vdups(%19, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %127 = cce.vdups(%20, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %128 = cce.vsel(%127, %126, %125) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %129 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%128, %129, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb41
  ^bb41:  // pred: ^bb40
    %130 = llvm.add %116, %0 : i32
    llvm.br ^bb39(%130 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb42:  // pred: ^bb39
    llvm.br ^bb43(%1 : i32)
  ^bb43(%131: i32):  // 2 preds: ^bb42, ^bb48
    %132 = llvm.icmp "sle" %131, %1 : i32
    llvm.cond_br %132, ^bb44, ^bb49
  ^bb44:  // pred: ^bb43
    %133 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %134 = cce.vdups(%19, %133, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%135: i64):  // 2 preds: ^bb44, ^bb46
    %136 = llvm.icmp "slt" %135, %23 : i64
    llvm.cond_br %136, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %137 = llvm.trunc %135 : i64 to i32
    %138 = llvm.mul %137, %24 : i32
    %139 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %140 = llvm.sext %138 : i32 to i64
    %141 = llvm.getelementptr %139[%140] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%134, %141, %1, %1, %1, %133) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %142 = llvm.add %135, %11 : i64
    llvm.br ^bb45(%142 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %143 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %144 = llvm.getelementptr %143[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%134, %144, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    %145 = llvm.add %131, %0 : i32
    llvm.br ^bb43(%145 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb49:  // pred: ^bb43
    llvm.br ^bb50(%1 : i32)
  ^bb50(%146: i32):  // 2 preds: ^bb49, ^bb55
    %147 = llvm.icmp "sle" %146, %1 : i32
    llvm.cond_br %147, ^bb51, ^bb56
  ^bb51:  // pred: ^bb50
    %dst_8, %restElem_9 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%148: i64):  // 2 preds: ^bb51, ^bb53
    %149 = llvm.icmp "slt" %148, %6 : i64
    llvm.cond_br %149, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %150 = llvm.trunc %148 : i64 to i32
    %151 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %152 = llvm.sext %150 : i32 to i64
    %153 = llvm.getelementptr %151[%152] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %154 = cce.intr.vldsx1.i8(%153, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %155 = llvm.mul %150, %15 : i32
    %156 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %157 = llvm.sext %155 : i32 to i64
    %158 = llvm.getelementptr %156[%157] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%154, %158, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %159 = llvm.add %148, %11 : i64
    llvm.br ^bb52(%159 : i64)
  ^bb54:  // pred: ^bb52
    llvm.br ^bb55
  ^bb55:  // pred: ^bb54
    %160 = llvm.add %146, %0 : i32
    llvm.br ^bb50(%160 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb56:  // pred: ^bb50
    llvm.br ^bb57(%1 : i32)
  ^bb57(%161: i32):  // 2 preds: ^bb56, ^bb62
    %162 = llvm.icmp "sle" %161, %1 : i32
    llvm.cond_br %162, ^bb58, ^bb63
  ^bb58:  // pred: ^bb57
    %163 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %164 = cce.vdups(%19, %163, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%165: i64):  // 2 preds: ^bb58, ^bb60
    %166 = llvm.icmp "slt" %165, %23 : i64
    llvm.cond_br %166, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %167 = llvm.trunc %165 : i64 to i32
    %168 = llvm.mul %167, %24 : i32
    %169 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %170 = llvm.sext %168 : i32 to i64
    %171 = llvm.getelementptr %169[%170] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%164, %171, %1, %1, %1, %163) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %172 = llvm.add %165, %11 : i64
    llvm.br ^bb59(%172 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %173 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %174 = llvm.getelementptr %173[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%164, %174, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %175 = llvm.add %161, %0 : i32
    llvm.br ^bb57(%175 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%176: i32):  // 2 preds: ^bb63, ^bb69
    %177 = llvm.icmp "sle" %176, %1 : i32
    llvm.cond_br %177, ^bb65, ^bb70
  ^bb65:  // pred: ^bb64
    %dst_12, %restElem_13 = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb66(%5 : i64)
  ^bb66(%178: i64):  // 2 preds: ^bb65, ^bb67
    %179 = llvm.icmp "slt" %178, %6 : i64
    llvm.cond_br %179, ^bb67, ^bb68
  ^bb67:  // pred: ^bb66
    %180 = llvm.trunc %178 : i64 to i32
    %181 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %182 = cce.intr.vldsx1.i8(%181, %1, %28, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %183 = llvm.mul %180, %15 : i32
    %184 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %185 = llvm.sext %183 : i32 to i64
    %186 = llvm.getelementptr %184[%185] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%182, %186, %1, %29, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %187 = llvm.add %178, %11 : i64
    llvm.br ^bb66(%187 : i64)
  ^bb68:  // pred: ^bb66
    llvm.br ^bb69
  ^bb69:  // pred: ^bb68
    %188 = llvm.add %176, %0 : i32
    llvm.br ^bb64(%188 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb70:  // pred: ^bb64
    llvm.br ^bb71(%1 : i32)
  ^bb71(%189: i32):  // 2 preds: ^bb70, ^bb76
    %190 = llvm.icmp "sle" %189, %1 : i32
    llvm.cond_br %190, ^bb72, ^bb77
  ^bb72:  // pred: ^bb71
    %191 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %192 = cce.vdups(%19, %191, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb73(%5 : i64)
  ^bb73(%193: i64):  // 2 preds: ^bb72, ^bb74
    %194 = llvm.icmp "slt" %193, %23 : i64
    llvm.cond_br %194, ^bb74, ^bb75
  ^bb74:  // pred: ^bb73
    %195 = llvm.trunc %193 : i64 to i32
    %196 = llvm.mul %195, %24 : i32
    %197 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %198 = llvm.sext %196 : i32 to i64
    %199 = llvm.getelementptr %197[%198] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%192, %199, %1, %1, %1, %191) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %200 = llvm.add %193, %11 : i64
    llvm.br ^bb73(%200 : i64)
  ^bb75:  // pred: ^bb73
    %dst_14, %restElem_15 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %201 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %202 = llvm.getelementptr %201[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%192, %202, %1, %1, %1, %dst_14) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb76
  ^bb76:  // pred: ^bb75
    %203 = llvm.add %189, %0 : i32
    llvm.br ^bb71(%203 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb77:  // pred: ^bb71
    llvm.br ^bb78(%1 : i32)
  ^bb78(%204: i32):  // 2 preds: ^bb77, ^bb83
    %205 = llvm.icmp "sle" %204, %1 : i32
    llvm.cond_br %205, ^bb79, ^bb84
  ^bb79:  // pred: ^bb78
    %206 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb80(%5 : i64)
  ^bb80(%207: i64):  // 2 preds: ^bb79, ^bb81
    %208 = llvm.icmp "slt" %207, %23 : i64
    llvm.cond_br %208, ^bb81, ^bb82
  ^bb81:  // pred: ^bb80
    %209 = llvm.trunc %207 : i64 to i32
    %210 = llvm.udiv %209, %31 : i32
    %211 = llvm.urem %209, %31 : i32
    %212 = llvm.mul %211, %24 : i32
    %213 = llvm.mul %210, %26 : i32
    %214 = llvm.add %213, %212 : i32
    %215 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %216 = llvm.sext %214 : i32 to i64
    %217 = llvm.getelementptr %215[%216] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %218 = cce.intr.vldsx1.i8(%217, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %219 = cce.vdups(%19, %206, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %220 = cce.cmp(%218, %219, %206) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %221 = llvm.inttoptr %27 : i64 to !llvm.ptr<6>
    %222 = llvm.sext %214 : i32 to i64
    %223 = llvm.getelementptr %221[%222] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %224 = cce.intr.vldsx1.i8(%223, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %225 = cce.cmp(%224, %219, %206) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %226 = cce.pand(%220, %225, %206) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %227 = cce.vdups(%20, %206, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %228 = cce.vsel(%227, %219, %226) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %229 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %230 = llvm.sext %214 : i32 to i64
    %231 = llvm.getelementptr %229[%230] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%228, %231, %1, %1, %1, %206) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %232 = llvm.add %207, %11 : i64
    llvm.br ^bb80(%232 : i64)
  ^bb82:  // pred: ^bb80
    llvm.br ^bb83
  ^bb83:  // pred: ^bb82
    %233 = llvm.add %204, %0 : i32
    llvm.br ^bb78(%233 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb84:  // pred: ^bb78
    %234 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %235 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %236 = llvm.inttoptr %235 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%234, %236, %40, %41) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb85(%1 : i32)
  ^bb85(%237: i32):  // 2 preds: ^bb84, ^bb90
    %238 = llvm.icmp "sle" %237, %1 : i32
    llvm.cond_br %238, ^bb86, ^bb91
  ^bb86:  // pred: ^bb85
    %239 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb87(%5 : i64)
  ^bb87(%240: i64):  // 2 preds: ^bb86, ^bb88
    %241 = llvm.icmp "slt" %240, %33 : i64
    llvm.cond_br %241, ^bb88, ^bb89
  ^bb88:  // pred: ^bb87
    %242 = llvm.mul %240, %34 : i64
    %243 = llvm.trunc %242 : i64 to i32
    %244 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %245 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %246 = llvm.sext %243 : i32 to i64
    %247 = llvm.getelementptr %245[%246] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %248 = cce.intr.vldsx1.i8(%247, %1, %35, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %249 = cce.vcvtii.ext(%248, %244, %1) {unsigned} : (vector<256xi8>, vector<256xi1>, i32) -> vector<128xi16>
    %250 = cce.vdups(%36, %239, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %251 = cce.cmp(%249, %250, %239) {predicate = "ne"} : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<256xi1>
    %252 = llvm.mul %243, %13 : i32
    %253 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %254 = llvm.sext %252 : i32 to i64
    %255 = llvm.getelementptr %253[%254] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %256 = cce.intr.vldsx1.f16(%255, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %257 = cce.vdups(%9, %239, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %258 = cce.vsel(%256, %257, %251) : (vector<128xf16>, vector<128xf16>, vector<256xi1>) -> vector<128xf16>
    %259 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %260 = llvm.sext %252 : i32 to i64
    %261 = llvm.getelementptr %259[%260] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%258, %261, %1, %0, %1, %239) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %262 = llvm.add %240, %11 : i64
    llvm.br ^bb87(%262 : i64)
  ^bb89:  // pred: ^bb87
    llvm.br ^bb90
  ^bb90:  // pred: ^bb89
    %263 = llvm.add %237, %0 : i32
    llvm.br ^bb85(%263 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb91:  // pred: ^bb85
    llvm.br ^bb92(%1 : i32)
  ^bb92(%264: i32):  // 2 preds: ^bb91, ^bb97
    %265 = llvm.icmp "sle" %264, %1 : i32
    llvm.cond_br %265, ^bb93, ^bb98
  ^bb93:  // pred: ^bb92
    %dst_16, %restElem_17 = cce.plt(%15) {mask_bitwidth = 16 : i32} : (i32) -> (vector<256xi1>, i32)
    %266 = cce.pset(%13) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb94(%5 : i64)
  ^bb94(%267: i64):  // 2 preds: ^bb93, ^bb95
    %268 = llvm.icmp "slt" %267, %6 : i64
    llvm.cond_br %268, ^bb95, ^bb96
  ^bb95:  // pred: ^bb94
    %269 = llvm.trunc %267 : i64 to i32
    %270 = llvm.mul %269, %42 : i32
    %271 = llvm.inttoptr %32 : i64 to !llvm.ptr<6>
    %272 = llvm.sext %270 : i32 to i64
    %273 = llvm.getelementptr %271[%272] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %274 = cce.intr.vldsx1.f16(%273, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %275 = cce.vcmax(%274, %dst_16) : (vector<128xf16>, vector<256xi1>) -> vector<128xf16>
    %276 = llvm.mul %269, %13 : i32
    %277 = llvm.inttoptr %37 : i64 to !llvm.ptr<6>
    %278 = llvm.sext %276 : i32 to i64
    %279 = llvm.getelementptr %277[%278] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%275, %279, %1, %12, %1, %266) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %280 = llvm.add %267, %11 : i64
    llvm.br ^bb94(%280 : i64)
  ^bb96:  // pred: ^bb94
    llvm.br ^bb97
  ^bb97:  // pred: ^bb96
    %281 = llvm.add %264, %0 : i32
    llvm.br ^bb92(%281 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb98:  // pred: ^bb92
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %282 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %283 = llvm.inttoptr %282 : i64 to !llvm.ptr<1>
    %284 = llvm.inttoptr %37 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%283, %284, %38, %39) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


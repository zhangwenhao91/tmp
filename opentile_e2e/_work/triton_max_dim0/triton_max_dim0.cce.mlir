module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @triton_max_dim0(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(8 : index) : i64
    %7 = llvm.mlir.constant(64 : index) : i64
    %8 = llvm.mlir.constant(64 : i32) : i32
    %9 = llvm.mlir.constant(8 : i32) : i32
    %10 = llvm.mlir.constant(0xFF800000 : f32) : f32
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
    %24 = llvm.mlir.constant(256 : i32) : i32
    %25 = llvm.mlir.constant(224 : i32) : i32
    %26 = llvm.mlir.constant(2048 : i32) : i32
    %27 = llvm.mlir.constant(32 : index) : i64
    %28 = llvm.mlir.constant(3 : i32) : i32
    %29 = llvm.mlir.constant(18656 : i64) : i64
    %30 = llvm.mlir.constant(20928 : i64) : i64
    %31 = llvm.mlir.constant(8192 : i64) : i64
    %32 = llvm.mlir.constant(20 : i32) : i32
    %33 = llvm.mlir.constant(24736 : i64) : i64
    %34 = llvm.mlir.constant(288230377225454592 : i64) : i64
    %35 = llvm.mlir.constant(140737488355360 : i64) : i64
    %36 = llvm.mlir.constant(288230377225453584 : i64) : i64
    %37 = llvm.mlir.constant(35184372088864 : i64) : i64
    %38 = llvm.mlir.constant(128 : i32) : i32
    %39 = cce.get.ctrl -> i64
    %40 = cce.sbitset0(%39, %3) : (i64, i64) -> i64
    cce.set.ctrl(%40) : i64
    %41 = cce.get.ctrl -> i64
    %42 = cce.sbitset1(%41, %2) : (i64, i64) -> i64
    cce.set.ctrl(%42) : i64
    %43 = cce.get_sub_block_idx -> i64
    %44 = llvm.icmp "eq" %43, %4 : i64
    llvm.cond_br %44, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb101
    llvm.return
  ^bb3(%45: i32):  // 2 preds: ^bb1, ^bb5
    %46 = llvm.icmp "sle" %45, %1 : i32
    llvm.cond_br %46, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %47 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %48 = cce.vdups(%1, %47, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %49 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%48, %49, %1, %14, %1, %47) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb5
  ^bb5:  // pred: ^bb4
    %50 = llvm.add %45, %0 : i32
    llvm.br ^bb3(%50 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb6:  // pred: ^bb3
    llvm.br ^bb7(%1 : i32)
  ^bb7(%51: i32):  // 2 preds: ^bb6, ^bb9
    %52 = llvm.icmp "sle" %51, %1 : i32
    llvm.cond_br %52, ^bb8, ^bb10
  ^bb8:  // pred: ^bb7
    %dst, %restElem = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %53 = cce.vdups(%9, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %54 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%53, %54, %1, %14, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %55 = llvm.add %51, %0 : i32
    llvm.br ^bb7(%55 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%56: i32):  // 2 preds: ^bb10, ^bb13
    %57 = llvm.icmp "sle" %56, %1 : i32
    llvm.cond_br %57, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %58 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %59 = cce.vdups(%8, %58, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %60 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%59, %60, %1, %14, %1, %58) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %61 = llvm.add %56, %0 : i32
    llvm.br ^bb11(%61 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%62: i32):  // 2 preds: ^bb14, ^bb17
    %63 = llvm.icmp "sle" %62, %1 : i32
    llvm.cond_br %63, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %64 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %65 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %66 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%65, %66, %1, %14, %1, %64) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb17
  ^bb17:  // pred: ^bb16
    %67 = llvm.add %62, %0 : i32
    llvm.br ^bb15(%67 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb18:  // pred: ^bb15
    llvm.br ^bb19(%1 : i32)
  ^bb19(%68: i32):  // 2 preds: ^bb18, ^bb21
    %69 = llvm.icmp "sle" %68, %1 : i32
    llvm.cond_br %69, ^bb20, ^bb22
  ^bb20:  // pred: ^bb19
    %70 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %71 = cce.vdups(%1, %70, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %72 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%71, %72, %1, %14, %1, %70) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %73 = llvm.add %68, %0 : i32
    llvm.br ^bb19(%73 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%74: i32):  // 2 preds: ^bb22, ^bb25
    %75 = llvm.icmp "sle" %74, %1 : i32
    llvm.cond_br %75, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %76 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %77 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%76, %77, %1, %14, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %78 = llvm.add %74, %0 : i32
    llvm.br ^bb23(%78 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%79: i32):  // 2 preds: ^bb26, ^bb29
    %80 = llvm.icmp "sle" %79, %1 : i32
    llvm.cond_br %80, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %81 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %82 = cce.vdups(%20, %81, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %83 = cce.cmp(%82, %82, %81) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %84 = cce.vdups(%21, %81, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %85 = cce.vsel(%84, %82, %83) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %86 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%85, %86, %1, %1, %1, %81) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb29
  ^bb29:  // pred: ^bb28
    %87 = llvm.add %79, %0 : i32
    llvm.br ^bb27(%87 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb30:  // pred: ^bb27
    llvm.br ^bb31(%1 : i32)
  ^bb31(%88: i32):  // 2 preds: ^bb30, ^bb33
    %89 = llvm.icmp "sle" %88, %1 : i32
    llvm.cond_br %89, ^bb32, ^bb34
  ^bb32:  // pred: ^bb31
    %90 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %91 = cce.intr.vldsx1.i32(%90, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %92 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %93 = cce.intr.vldsx1.i32(%92, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %94 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %95 = cce.cmp(%93, %91, %94) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%8) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %96 = cce.ppack(%95, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %97 = cce.ppack(%96, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %98 = cce.vdups(%20, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %99 = cce.vdups(%21, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %100 = cce.vsel(%99, %98, %97) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %101 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%100, %101, %1, %1, %1, %dst_2) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb33
  ^bb33:  // pred: ^bb32
    %102 = llvm.add %88, %0 : i32
    llvm.br ^bb31(%102 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb34:  // pred: ^bb31
    llvm.br ^bb35(%1 : i32)
  ^bb35(%103: i32):  // 2 preds: ^bb34, ^bb37
    %104 = llvm.icmp "sle" %103, %1 : i32
    llvm.cond_br %104, ^bb36, ^bb38
  ^bb36:  // pred: ^bb35
    %105 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %106 = cce.vdups(%20, %105, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %107 = cce.cmp(%106, %106, %105) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %108 = cce.vdups(%21, %105, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %109 = cce.vsel(%108, %106, %107) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %110 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%109, %110, %1, %1, %1, %105) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb37
  ^bb37:  // pred: ^bb36
    %111 = llvm.add %103, %0 : i32
    llvm.br ^bb35(%111 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb38:  // pred: ^bb35
    llvm.br ^bb39(%1 : i32)
  ^bb39(%112: i32):  // 2 preds: ^bb38, ^bb41
    %113 = llvm.icmp "sle" %112, %1 : i32
    llvm.cond_br %113, ^bb40, ^bb42
  ^bb40:  // pred: ^bb39
    %114 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %115 = cce.intr.vldsx1.i32(%114, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %116 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %117 = cce.intr.vldsx1.i32(%116, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %118 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %119 = cce.cmp(%117, %115, %118) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %120 = cce.ppack(%119, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %121 = cce.ppack(%120, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %122 = cce.vdups(%20, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %123 = cce.vdups(%21, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %124 = cce.vsel(%123, %122, %121) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %125 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i8(%124, %125, %1, %1, %1, %dst_4) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb41
  ^bb41:  // pred: ^bb40
    %126 = llvm.add %112, %0 : i32
    llvm.br ^bb39(%126 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb42:  // pred: ^bb39
    llvm.br ^bb43(%1 : i32)
  ^bb43(%127: i32):  // 2 preds: ^bb42, ^bb48
    %128 = llvm.icmp "sle" %127, %1 : i32
    llvm.cond_br %128, ^bb44, ^bb49
  ^bb44:  // pred: ^bb43
    %129 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %130 = cce.vdups(%20, %129, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%131: i64):  // 2 preds: ^bb44, ^bb46
    %132 = llvm.icmp "slt" %131, %6 : i64
    llvm.cond_br %132, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %133 = llvm.trunc %131 : i64 to i32
    %134 = llvm.mul %133, %24 : i32
    %135 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %136 = llvm.sext %134 : i32 to i64
    %137 = llvm.getelementptr %135[%136] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%130, %137, %1, %1, %1, %129) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %138 = llvm.add %131, %12 : i64
    llvm.br ^bb45(%138 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %139 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %140 = llvm.getelementptr %139[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%130, %140, %1, %1, %1, %dst_6) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    %141 = llvm.add %127, %0 : i32
    llvm.br ^bb43(%141 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb49:  // pred: ^bb43
    llvm.br ^bb50(%1 : i32)
  ^bb50(%142: i32):  // 2 preds: ^bb49, ^bb55
    %143 = llvm.icmp "sle" %142, %1 : i32
    llvm.cond_br %143, ^bb51, ^bb56
  ^bb51:  // pred: ^bb50
    %dst_8, %restElem_9 = cce.plt(%15) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%144: i64):  // 2 preds: ^bb51, ^bb53
    %145 = llvm.icmp "slt" %144, %7 : i64
    llvm.cond_br %145, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %146 = llvm.trunc %144 : i64 to i32
    %147 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %148 = llvm.sext %146 : i32 to i64
    %149 = llvm.getelementptr %147[%148] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %150 = cce.intr.vldsx1.i8(%149, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %151 = llvm.mul %146, %15 : i32
    %152 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %153 = llvm.sext %151 : i32 to i64
    %154 = llvm.getelementptr %152[%153] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%150, %154, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %155 = llvm.add %144, %12 : i64
    llvm.br ^bb52(%155 : i64)
  ^bb54:  // pred: ^bb52
    llvm.br ^bb55
  ^bb55:  // pred: ^bb54
    %156 = llvm.add %142, %0 : i32
    llvm.br ^bb50(%156 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb56:  // pred: ^bb50
    llvm.br ^bb57(%1 : i32)
  ^bb57(%157: i32):  // 2 preds: ^bb56, ^bb62
    %158 = llvm.icmp "sle" %157, %1 : i32
    llvm.cond_br %158, ^bb58, ^bb63
  ^bb58:  // pred: ^bb57
    %159 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %160 = cce.vdups(%20, %159, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%161: i64):  // 2 preds: ^bb58, ^bb60
    %162 = llvm.icmp "slt" %161, %6 : i64
    llvm.cond_br %162, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %163 = llvm.trunc %161 : i64 to i32
    %164 = llvm.mul %163, %24 : i32
    %165 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %166 = llvm.sext %164 : i32 to i64
    %167 = llvm.getelementptr %165[%166] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%160, %167, %1, %1, %1, %159) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %168 = llvm.add %161, %12 : i64
    llvm.br ^bb59(%168 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %169 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %170 = llvm.getelementptr %169[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%160, %170, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %171 = llvm.add %157, %0 : i32
    llvm.br ^bb57(%171 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%172: i32):  // 2 preds: ^bb63, ^bb72
    %173 = llvm.icmp "sle" %172, %1 : i32
    llvm.cond_br %173, ^bb65, ^bb73
  ^bb65:  // pred: ^bb64
    %174 = cce.pset(%14) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb66(%5 : i64)
  ^bb66(%175: i64):  // 2 preds: ^bb65, ^bb70
    %176 = llvm.icmp "slt" %175, %27 : i64
    llvm.cond_br %176, ^bb67, ^bb71
  ^bb67:  // pred: ^bb66
    %177 = llvm.trunc %175 : i64 to i32
    %178 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %179 = llvm.sext %177 : i32 to i64
    %180 = llvm.getelementptr %178[%179] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %181 = cce.intr.vldsx1.i8(%180, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    llvm.br ^bb68(%5 : i64)
  ^bb68(%182: i64):  // 2 preds: ^bb67, ^bb69
    %183 = llvm.icmp "slt" %182, %7 : i64
    llvm.cond_br %183, ^bb69, ^bb70
  ^bb69:  // pred: ^bb68
    %184 = llvm.trunc %182 : i64 to i32
    %185 = llvm.mul %184, %15 : i32
    %186 = llvm.add %185, %177 : i32
    %187 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %188 = llvm.sext %186 : i32 to i64
    %189 = llvm.getelementptr %187[%188] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%181, %189, %1, %28, %1, %174) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %190 = llvm.add %182, %12 : i64
    llvm.br ^bb68(%190 : i64)
  ^bb70:  // pred: ^bb68
    %191 = llvm.add %175, %12 : i64
    llvm.br ^bb66(%191 : i64)
  ^bb71:  // pred: ^bb66
    llvm.br ^bb72
  ^bb72:  // pred: ^bb71
    %192 = llvm.add %172, %0 : i32
    llvm.br ^bb64(%192 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb73:  // pred: ^bb64
    llvm.br ^bb74(%1 : i32)
  ^bb74(%193: i32):  // 2 preds: ^bb73, ^bb79
    %194 = llvm.icmp "sle" %193, %1 : i32
    llvm.cond_br %194, ^bb75, ^bb80
  ^bb75:  // pred: ^bb74
    %195 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %196 = cce.vdups(%20, %195, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb76(%5 : i64)
  ^bb76(%197: i64):  // 2 preds: ^bb75, ^bb77
    %198 = llvm.icmp "slt" %197, %6 : i64
    llvm.cond_br %198, ^bb77, ^bb78
  ^bb77:  // pred: ^bb76
    %199 = llvm.trunc %197 : i64 to i32
    %200 = llvm.mul %199, %24 : i32
    %201 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %202 = llvm.sext %200 : i32 to i64
    %203 = llvm.getelementptr %201[%202] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%196, %203, %1, %1, %1, %195) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %204 = llvm.add %197, %12 : i64
    llvm.br ^bb76(%204 : i64)
  ^bb78:  // pred: ^bb76
    %dst_12, %restElem_13 = cce.plt(%25) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %205 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %206 = llvm.getelementptr %205[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%196, %206, %1, %1, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb79
  ^bb79:  // pred: ^bb78
    %207 = llvm.add %193, %0 : i32
    llvm.br ^bb74(%207 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb80:  // pred: ^bb74
    llvm.br ^bb81(%1 : i32)
  ^bb81(%208: i32):  // 2 preds: ^bb80, ^bb86
    %209 = llvm.icmp "sle" %208, %1 : i32
    llvm.cond_br %209, ^bb82, ^bb87
  ^bb82:  // pred: ^bb81
    %210 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb83(%5 : i64)
  ^bb83(%211: i64):  // 2 preds: ^bb82, ^bb84
    %212 = llvm.icmp "slt" %211, %6 : i64
    llvm.cond_br %212, ^bb84, ^bb85
  ^bb84:  // pred: ^bb83
    %213 = llvm.trunc %211 : i64 to i32
    %214 = llvm.udiv %213, %9 : i32
    %215 = llvm.urem %213, %9 : i32
    %216 = llvm.mul %215, %24 : i32
    %217 = llvm.mul %214, %26 : i32
    %218 = llvm.add %217, %216 : i32
    %219 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %220 = llvm.sext %218 : i32 to i64
    %221 = llvm.getelementptr %219[%220] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %222 = cce.intr.vldsx1.i8(%221, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %223 = cce.vdups(%20, %210, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %224 = cce.cmp(%222, %223, %210) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %225 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %226 = llvm.sext %218 : i32 to i64
    %227 = llvm.getelementptr %225[%226] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %228 = cce.intr.vldsx1.i8(%227, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %229 = cce.cmp(%228, %223, %210) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %230 = cce.pand(%224, %229, %210) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %231 = cce.vdups(%21, %210, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %232 = cce.vsel(%231, %223, %230) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %233 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %234 = llvm.sext %218 : i32 to i64
    %235 = llvm.getelementptr %233[%234] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%232, %235, %1, %1, %1, %210) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %236 = llvm.add %211, %12 : i64
    llvm.br ^bb83(%236 : i64)
  ^bb85:  // pred: ^bb83
    llvm.br ^bb86
  ^bb86:  // pred: ^bb85
    %237 = llvm.add %208, %0 : i32
    llvm.br ^bb81(%237 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb87:  // pred: ^bb81
    %238 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %239 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %240 = llvm.inttoptr %239 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%238, %240, %34, %35) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb88(%1 : i32)
  ^bb88(%241: i32):  // 2 preds: ^bb87, ^bb93
    %242 = llvm.icmp "sle" %241, %1 : i32
    llvm.cond_br %242, ^bb89, ^bb94
  ^bb89:  // pred: ^bb88
    %243 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb90(%5 : i64)
  ^bb90(%244: i64):  // 2 preds: ^bb89, ^bb91
    %245 = llvm.icmp "slt" %244, %27 : i64
    llvm.cond_br %245, ^bb91, ^bb92
  ^bb91:  // pred: ^bb90
    %246 = llvm.mul %244, %7 : i64
    %247 = llvm.trunc %246 : i64 to i32
    %248 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %249 = llvm.inttoptr %30 : i64 to !llvm.ptr<6>
    %250 = llvm.sext %247 : i32 to i64
    %251 = llvm.getelementptr %249[%250] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %252 = cce.intr.vldsx1.i8(%251, %1, %32, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %253 = cce.vcvtii.ext(%252, %248, %1) : (vector<256xi8>, vector<256xi1>, i32) -> vector<64xi32>
    %254 = cce.vdups(%1, %243, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %255 = cce.cmp(%253, %254, %243) {predicate = "ne"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %256 = llvm.mul %247, %13 : i32
    %257 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %258 = llvm.sext %256 : i32 to i64
    %259 = llvm.getelementptr %257[%258] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %260 = cce.intr.vldsx1.f32(%259, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %261 = cce.vdups(%10, %243, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %262 = cce.vsel(%260, %261, %255) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %263 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %264 = llvm.sext %256 : i32 to i64
    %265 = llvm.getelementptr %263[%264] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%262, %265, %1, %14, %1, %243) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %266 = llvm.add %244, %12 : i64
    llvm.br ^bb90(%266 : i64)
  ^bb92:  // pred: ^bb90
    llvm.br ^bb93
  ^bb93:  // pred: ^bb92
    %267 = llvm.add %241, %0 : i32
    llvm.br ^bb88(%267 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb94:  // pred: ^bb88
    llvm.br ^bb95(%1 : i32)
  ^bb95(%268: i32):  // 2 preds: ^bb94, ^bb100
    %269 = llvm.icmp "sle" %268, %1 : i32
    llvm.cond_br %269, ^bb96, ^bb101
  ^bb96:  // pred: ^bb95
    %dst_14, %restElem_15 = cce.plt(%15) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %270 = cce.vdups(%10, %dst_14, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    llvm.br ^bb97(%5, %270 : i64, vector<64xf32>)
  ^bb97(%271: i64, %272: vector<64xf32>):  // 2 preds: ^bb96, ^bb98
    %273 = llvm.icmp "slt" %271, %7 : i64
    llvm.cond_br %273, ^bb98, ^bb99
  ^bb98:  // pred: ^bb97
    %274 = llvm.trunc %271 : i64 to i32
    %275 = llvm.mul %274, %38 : i32
    %276 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %277 = llvm.sext %275 : i32 to i64
    %278 = llvm.getelementptr %276[%277] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %279 = cce.intr.vldsx1.f32(%278, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %280 = cce.vmax(%272, %279, %dst_14) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %281 = llvm.add %271, %12 : i64
    llvm.br ^bb97(%281, %280 : i64, vector<64xf32>)
  ^bb99:  // pred: ^bb97
    %282 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%272, %282, %1, %14, %1, %dst_14) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb100
  ^bb100:  // pred: ^bb99
    %283 = llvm.add %268, %0 : i32
    llvm.br ^bb95(%283 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb101:  // pred: ^bb95
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %284 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %285 = llvm.inttoptr %284 : i64 to !llvm.ptr<1>
    %286 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%285, %286, %36, %37) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


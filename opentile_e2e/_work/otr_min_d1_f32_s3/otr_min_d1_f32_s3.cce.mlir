module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_min_d1_f32_s3(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(32 : index) : i64
    %7 = llvm.mlir.constant(32 : i32) : i32
    %8 = llvm.mlir.constant(48 : i32) : i32
    %9 = llvm.mlir.constant(0x7F800000 : f32) : f32
    %10 = llvm.mlir.constant(23104 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(4 : i32) : i32
    %13 = llvm.mlir.constant(64 : index) : i64
    %14 = llvm.mlir.constant(2 : i32) : i32
    %15 = llvm.mlir.constant(23360 : i64) : i64
    %16 = llvm.mlir.constant(64 : i32) : i32
    %17 = llvm.mlir.constant(23616 : i64) : i64
    %18 = llvm.mlir.constant(23872 : i64) : i64
    %19 = llvm.mlir.constant(24128 : i64) : i64
    %20 = llvm.mlir.constant(0 : i8) : i8
    %21 = llvm.mlir.constant(1 : i8) : i8
    %22 = llvm.mlir.constant(24384 : i64) : i64
    %23 = llvm.mlir.constant(16384 : i64) : i64
    %24 = llvm.mlir.constant(8 : index) : i64
    %25 = llvm.mlir.constant(256 : i32) : i32
    %26 = llvm.mlir.constant(192 : i32) : i32
    %27 = llvm.mlir.constant(2048 : i32) : i32
    %28 = llvm.mlir.constant(18624 : i64) : i64
    %29 = llvm.mlir.constant(20 : i32) : i32
    %30 = llvm.mlir.constant(12 : i32) : i32
    %31 = llvm.mlir.constant(20864 : i64) : i64
    %32 = llvm.mlir.constant(8 : i32) : i32
    %33 = llvm.mlir.constant(8192 : i64) : i64
    %34 = llvm.mlir.constant(24640 : i64) : i64
    %35 = llvm.mlir.constant(5 : i32) : i32
    %36 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %37 = llvm.mlir.constant(35184372088864 : i64) : i64
    %38 = llvm.mlir.constant(288230382594163200 : i64) : i64
    %39 = llvm.mlir.constant(281474976710848 : i64) : i64
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
  ^bb2:  // 2 preds: ^bb0, ^bb98
    llvm.return
  ^bb3(%46: i32):  // 2 preds: ^bb1, ^bb5
    %47 = llvm.icmp "sle" %46, %1 : i32
    llvm.cond_br %47, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %48 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %49 = cce.vdups(%8, %48, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %50 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%49, %50, %1, %14, %1, %48) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
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
    %54 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %55 = cce.vdups(%1, %54, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %56 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%55, %56, %1, %14, %1, %54) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %57 = llvm.add %52, %0 : i32
    llvm.br ^bb7(%57 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%58: i32):  // 2 preds: ^bb10, ^bb13
    %59 = llvm.icmp "sle" %58, %1 : i32
    llvm.cond_br %59, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %dst, %restElem = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %60 = cce.vdups(%7, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %61 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%60, %61, %1, %14, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %62 = llvm.add %58, %0 : i32
    llvm.br ^bb11(%62 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%63: i32):  // 2 preds: ^bb14, ^bb17
    %64 = llvm.icmp "sle" %63, %1 : i32
    llvm.cond_br %64, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %65 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %66 = cce.vdups(%1, %65, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %67 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%66, %67, %1, %14, %1, %65) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
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
    %71 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %72 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%71, %72, %1, %14, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %73 = llvm.add %69, %0 : i32
    llvm.br ^bb19(%73 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%74: i32):  // 2 preds: ^bb22, ^bb25
    %75 = llvm.icmp "sle" %74, %1 : i32
    llvm.cond_br %75, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %76 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %77 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %78 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%77, %78, %1, %14, %1, %76) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %79 = llvm.add %74, %0 : i32
    llvm.br ^bb23(%79 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%80: i32):  // 2 preds: ^bb26, ^bb29
    %81 = llvm.icmp "sle" %80, %1 : i32
    llvm.cond_br %81, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %82 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %83 = cce.vdups(%20, %82, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %84 = cce.cmp(%83, %83, %82) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %85 = cce.vdups(%21, %82, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %86 = cce.vsel(%85, %83, %84) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %87 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
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
    %93 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %94 = cce.intr.vldsx1.i32(%93, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %95 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %96 = cce.cmp(%94, %92, %95) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%7) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %97 = cce.ppack(%96, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %98 = cce.ppack(%97, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %99 = cce.vdups(%20, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %100 = cce.vdups(%21, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %101 = cce.vsel(%100, %99, %98) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %102 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
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
    %107 = cce.vdups(%20, %106, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %108 = cce.cmp(%107, %107, %106) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %109 = cce.vdups(%21, %106, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %110 = cce.vsel(%109, %107, %108) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %111 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
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
    %117 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %118 = cce.intr.vldsx1.i32(%117, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %119 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %120 = cce.cmp(%118, %116, %119) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%16) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %121 = cce.ppack(%120, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %122 = cce.ppack(%121, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %123 = cce.vdups(%20, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %124 = cce.vdups(%21, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %125 = cce.vsel(%124, %123, %122) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %126 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
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
    %131 = cce.vdups(%20, %130, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%132: i64):  // 2 preds: ^bb44, ^bb46
    %133 = llvm.icmp "slt" %132, %24 : i64
    llvm.cond_br %133, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %134 = llvm.trunc %132 : i64 to i32
    %135 = llvm.mul %134, %25 : i32
    %136 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %137 = llvm.sext %135 : i32 to i64
    %138 = llvm.getelementptr %136[%137] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%131, %138, %1, %1, %1, %130) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %139 = llvm.add %132, %11 : i64
    llvm.br ^bb45(%139 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %140 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
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
    %dst_8, %restElem_9 = cce.plt(%16) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%145: i64):  // 2 preds: ^bb51, ^bb53
    %146 = llvm.icmp "slt" %145, %6 : i64
    llvm.cond_br %146, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %147 = llvm.trunc %145 : i64 to i32
    %148 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %149 = llvm.sext %147 : i32 to i64
    %150 = llvm.getelementptr %148[%149] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %151 = cce.intr.vldsx1.i8(%150, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %152 = llvm.mul %147, %16 : i32
    %153 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
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
    %161 = cce.vdups(%20, %160, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%162: i64):  // 2 preds: ^bb58, ^bb60
    %163 = llvm.icmp "slt" %162, %24 : i64
    llvm.cond_br %163, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %164 = llvm.trunc %162 : i64 to i32
    %165 = llvm.mul %164, %25 : i32
    %166 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %167 = llvm.sext %165 : i32 to i64
    %168 = llvm.getelementptr %166[%167] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%161, %168, %1, %1, %1, %160) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %169 = llvm.add %162, %11 : i64
    llvm.br ^bb59(%169 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %170 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %171 = llvm.getelementptr %170[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%161, %171, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %172 = llvm.add %158, %0 : i32
    llvm.br ^bb57(%172 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%173: i32):  // 2 preds: ^bb63, ^bb69
    %174 = llvm.icmp "sle" %173, %1 : i32
    llvm.cond_br %174, ^bb65, ^bb70
  ^bb65:  // pred: ^bb64
    %dst_12, %restElem_13 = cce.plt(%16) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb66(%5 : i64)
  ^bb66(%175: i64):  // 2 preds: ^bb65, ^bb67
    %176 = llvm.icmp "slt" %175, %6 : i64
    llvm.cond_br %176, ^bb67, ^bb68
  ^bb67:  // pred: ^bb66
    %177 = llvm.trunc %175 : i64 to i32
    %178 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %179 = cce.intr.vldsx1.i8(%178, %1, %29, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %180 = llvm.mul %177, %16 : i32
    %181 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %182 = llvm.sext %180 : i32 to i64
    %183 = llvm.getelementptr %181[%182] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%179, %183, %1, %30, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %184 = llvm.add %175, %11 : i64
    llvm.br ^bb66(%184 : i64)
  ^bb68:  // pred: ^bb66
    llvm.br ^bb69
  ^bb69:  // pred: ^bb68
    %185 = llvm.add %173, %0 : i32
    llvm.br ^bb64(%185 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb70:  // pred: ^bb64
    llvm.br ^bb71(%1 : i32)
  ^bb71(%186: i32):  // 2 preds: ^bb70, ^bb76
    %187 = llvm.icmp "sle" %186, %1 : i32
    llvm.cond_br %187, ^bb72, ^bb77
  ^bb72:  // pred: ^bb71
    %188 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %189 = cce.vdups(%20, %188, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb73(%5 : i64)
  ^bb73(%190: i64):  // 2 preds: ^bb72, ^bb74
    %191 = llvm.icmp "slt" %190, %24 : i64
    llvm.cond_br %191, ^bb74, ^bb75
  ^bb74:  // pred: ^bb73
    %192 = llvm.trunc %190 : i64 to i32
    %193 = llvm.mul %192, %25 : i32
    %194 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %195 = llvm.sext %193 : i32 to i64
    %196 = llvm.getelementptr %194[%195] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%189, %196, %1, %1, %1, %188) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %197 = llvm.add %190, %11 : i64
    llvm.br ^bb73(%197 : i64)
  ^bb75:  // pred: ^bb73
    %dst_14, %restElem_15 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %198 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %199 = llvm.getelementptr %198[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%189, %199, %1, %1, %1, %dst_14) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb76
  ^bb76:  // pred: ^bb75
    %200 = llvm.add %186, %0 : i32
    llvm.br ^bb71(%200 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb77:  // pred: ^bb71
    llvm.br ^bb78(%1 : i32)
  ^bb78(%201: i32):  // 2 preds: ^bb77, ^bb83
    %202 = llvm.icmp "sle" %201, %1 : i32
    llvm.cond_br %202, ^bb79, ^bb84
  ^bb79:  // pred: ^bb78
    %203 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb80(%5 : i64)
  ^bb80(%204: i64):  // 2 preds: ^bb79, ^bb81
    %205 = llvm.icmp "slt" %204, %24 : i64
    llvm.cond_br %205, ^bb81, ^bb82
  ^bb81:  // pred: ^bb80
    %206 = llvm.trunc %204 : i64 to i32
    %207 = llvm.udiv %206, %32 : i32
    %208 = llvm.urem %206, %32 : i32
    %209 = llvm.mul %208, %25 : i32
    %210 = llvm.mul %207, %27 : i32
    %211 = llvm.add %210, %209 : i32
    %212 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %213 = llvm.sext %211 : i32 to i64
    %214 = llvm.getelementptr %212[%213] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %215 = cce.intr.vldsx1.i8(%214, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %216 = cce.vdups(%20, %203, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %217 = cce.cmp(%215, %216, %203) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %218 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %219 = llvm.sext %211 : i32 to i64
    %220 = llvm.getelementptr %218[%219] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %221 = cce.intr.vldsx1.i8(%220, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %222 = cce.cmp(%221, %216, %203) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %223 = cce.pand(%217, %222, %203) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %224 = cce.vdups(%21, %203, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %225 = cce.vsel(%224, %216, %223) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %226 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %227 = llvm.sext %211 : i32 to i64
    %228 = llvm.getelementptr %226[%227] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%225, %228, %1, %1, %1, %203) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %229 = llvm.add %204, %11 : i64
    llvm.br ^bb80(%229 : i64)
  ^bb82:  // pred: ^bb80
    llvm.br ^bb83
  ^bb83:  // pred: ^bb82
    %230 = llvm.add %201, %0 : i32
    llvm.br ^bb78(%230 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb84:  // pred: ^bb78
    %231 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %232 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %233 = llvm.inttoptr %232 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%231, %233, %38, %39) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb85(%1 : i32)
  ^bb85(%234: i32):  // 2 preds: ^bb84, ^bb90
    %235 = llvm.icmp "sle" %234, %1 : i32
    llvm.cond_br %235, ^bb86, ^bb91
  ^bb86:  // pred: ^bb85
    %236 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb87(%5 : i64)
  ^bb87(%237: i64):  // 2 preds: ^bb86, ^bb88
    %238 = llvm.icmp "slt" %237, %6 : i64
    llvm.cond_br %238, ^bb88, ^bb89
  ^bb88:  // pred: ^bb87
    %239 = llvm.mul %237, %13 : i64
    %240 = llvm.trunc %239 : i64 to i32
    %241 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %242 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %243 = llvm.sext %240 : i32 to i64
    %244 = llvm.getelementptr %242[%243] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %245 = cce.intr.vldsx1.i8(%244, %1, %29, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %246 = cce.vcvtii.ext(%245, %241, %1) : (vector<256xi8>, vector<256xi1>, i32) -> vector<64xi32>
    %247 = cce.vdups(%1, %236, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %248 = cce.cmp(%246, %247, %236) {predicate = "ne"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %249 = llvm.mul %240, %12 : i32
    %250 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %251 = llvm.sext %249 : i32 to i64
    %252 = llvm.getelementptr %250[%251] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %253 = cce.intr.vldsx1.f32(%252, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %254 = cce.vdups(%9, %236, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %255 = cce.vsel(%253, %254, %248) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %256 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %257 = llvm.sext %249 : i32 to i64
    %258 = llvm.getelementptr %256[%257] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%255, %258, %1, %14, %1, %236) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %259 = llvm.add %237, %11 : i64
    llvm.br ^bb87(%259 : i64)
  ^bb89:  // pred: ^bb87
    llvm.br ^bb90
  ^bb90:  // pred: ^bb89
    %260 = llvm.add %234, %0 : i32
    llvm.br ^bb85(%260 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb91:  // pred: ^bb85
    llvm.br ^bb92(%1 : i32)
  ^bb92(%261: i32):  // 2 preds: ^bb91, ^bb97
    %262 = llvm.icmp "sle" %261, %1 : i32
    llvm.cond_br %262, ^bb93, ^bb98
  ^bb93:  // pred: ^bb92
    %263 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %264 = cce.pset(%14) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb94(%5 : i64)
  ^bb94(%265: i64):  // 2 preds: ^bb93, ^bb95
    %266 = llvm.icmp "slt" %265, %6 : i64
    llvm.cond_br %266, ^bb95, ^bb96
  ^bb95:  // pred: ^bb94
    %267 = llvm.trunc %265 : i64 to i32
    %268 = llvm.mul %267, %25 : i32
    %269 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %270 = llvm.sext %268 : i32 to i64
    %271 = llvm.getelementptr %269[%270] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %272 = cce.intr.vldsx1.f32(%271, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %273 = cce.vcmin(%272, %263) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %274 = llvm.mul %267, %12 : i32
    %275 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    %276 = llvm.sext %274 : i32 to i64
    %277 = llvm.getelementptr %275[%276] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%273, %277, %1, %35, %1, %264) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %278 = llvm.add %265, %11 : i64
    llvm.br ^bb94(%278 : i64)
  ^bb96:  // pred: ^bb94
    llvm.br ^bb97
  ^bb97:  // pred: ^bb96
    %279 = llvm.add %261, %0 : i32
    llvm.br ^bb92(%279 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb98:  // pred: ^bb92
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %280 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %281 = llvm.inttoptr %280 : i64 to !llvm.ptr<1>
    %282 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%281, %282, %36, %37) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


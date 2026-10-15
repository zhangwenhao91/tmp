module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_min_d0_f16_s3(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(32 : index) : i64
    %7 = llvm.mlir.constant(32 : i32) : i32
    %8 = llvm.mlir.constant(48 : i32) : i32
    %9 = llvm.mlir.constant(0x7C00 : f16) : f16
    %10 = llvm.mlir.constant(14912 : i64) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.mlir.constant(2 : i32) : i32
    %13 = llvm.mlir.constant(15168 : i64) : i64
    %14 = llvm.mlir.constant(64 : i32) : i32
    %15 = llvm.mlir.constant(15424 : i64) : i64
    %16 = llvm.mlir.constant(15680 : i64) : i64
    %17 = llvm.mlir.constant(15936 : i64) : i64
    %18 = llvm.mlir.constant(0 : i8) : i8
    %19 = llvm.mlir.constant(1 : i8) : i8
    %20 = llvm.mlir.constant(16192 : i64) : i64
    %21 = llvm.mlir.constant(8192 : i64) : i64
    %22 = llvm.mlir.constant(8 : index) : i64
    %23 = llvm.mlir.constant(256 : i32) : i32
    %24 = llvm.mlir.constant(192 : i32) : i32
    %25 = llvm.mlir.constant(2048 : i32) : i32
    %26 = llvm.mlir.constant(10432 : i64) : i64
    %27 = llvm.mlir.constant(20 : i32) : i32
    %28 = llvm.mlir.constant(12 : i32) : i32
    %29 = llvm.mlir.constant(12672 : i64) : i64
    %30 = llvm.mlir.constant(8 : i32) : i32
    %31 = llvm.mlir.constant(4096 : i64) : i64
    %32 = llvm.mlir.constant(16 : index) : i64
    %33 = llvm.mlir.constant(128 : index) : i64
    %34 = llvm.mlir.constant(13 : i32) : i32
    %35 = llvm.mlir.constant(0 : i16) : i16
    %36 = llvm.mlir.constant(16448 : i64) : i64
    %37 = llvm.mlir.constant(288230379372937728 : i64) : i64
    %38 = llvm.mlir.constant(140737488355424 : i64) : i64
    %39 = llvm.mlir.constant(288230379372937232 : i64) : i64
    %40 = llvm.mlir.constant(105553116266592 : i64) : i64
    %41 = llvm.mlir.constant(128 : i32) : i32
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
  ^bb2:  // 2 preds: ^bb0, ^bb98
    llvm.return
  ^bb3(%48: i32):  // 2 preds: ^bb1, ^bb5
    %49 = llvm.icmp "sle" %48, %1 : i32
    llvm.cond_br %49, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %50 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %51 = cce.vdups(%8, %50, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %52 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%51, %52, %1, %12, %1, %50) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
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
    %56 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %57 = cce.vdups(%1, %56, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %58 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%57, %58, %1, %12, %1, %56) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %59 = llvm.add %54, %0 : i32
    llvm.br ^bb7(%59 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%60: i32):  // 2 preds: ^bb10, ^bb13
    %61 = llvm.icmp "sle" %60, %1 : i32
    llvm.cond_br %61, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %dst, %restElem = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %62 = cce.vdups(%7, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %63 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%62, %63, %1, %12, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %64 = llvm.add %60, %0 : i32
    llvm.br ^bb11(%64 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%65: i32):  // 2 preds: ^bb14, ^bb17
    %66 = llvm.icmp "sle" %65, %1 : i32
    llvm.cond_br %66, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %67 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %68 = cce.vdups(%1, %67, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %69 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%68, %69, %1, %12, %1, %67) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
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
    %73 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %74 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%73, %74, %1, %12, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %75 = llvm.add %71, %0 : i32
    llvm.br ^bb19(%75 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%76: i32):  // 2 preds: ^bb22, ^bb25
    %77 = llvm.icmp "sle" %76, %1 : i32
    llvm.cond_br %77, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %78 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %79 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %80 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%79, %80, %1, %12, %1, %78) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %81 = llvm.add %76, %0 : i32
    llvm.br ^bb23(%81 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb26:  // pred: ^bb23
    llvm.br ^bb27(%1 : i32)
  ^bb27(%82: i32):  // 2 preds: ^bb26, ^bb29
    %83 = llvm.icmp "sle" %82, %1 : i32
    llvm.cond_br %83, ^bb28, ^bb30
  ^bb28:  // pred: ^bb27
    %84 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %85 = cce.vdups(%18, %84, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %86 = cce.cmp(%85, %85, %84) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %87 = cce.vdups(%19, %84, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %88 = cce.vsel(%87, %85, %86) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %89 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
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
    %93 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %94 = cce.intr.vldsx1.i32(%93, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %95 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %96 = cce.intr.vldsx1.i32(%95, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %97 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %98 = cce.cmp(%96, %94, %97) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%7) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %99 = cce.ppack(%98, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %100 = cce.ppack(%99, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %101 = cce.vdups(%18, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %102 = cce.vdups(%19, %dst_2, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %103 = cce.vsel(%102, %101, %100) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %104 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
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
    %109 = cce.vdups(%18, %108, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %110 = cce.cmp(%109, %109, %108) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %111 = cce.vdups(%19, %108, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %112 = cce.vsel(%111, %109, %110) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %113 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
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
    %117 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %118 = cce.intr.vldsx1.i32(%117, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %119 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %120 = cce.intr.vldsx1.i32(%119, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %121 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %122 = cce.cmp(%120, %118, %121) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %123 = cce.ppack(%122, %1) {dst_mask_bitwidth = 16 : i32, src_mask_bitwidth = 32 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %124 = cce.ppack(%123, %1) {dst_mask_bitwidth = 8 : i32, src_mask_bitwidth = 16 : i32} : (vector<256xi1>, i32) -> vector<256xi1>
    %125 = cce.vdups(%18, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %126 = cce.vdups(%19, %dst_4, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %127 = cce.vsel(%126, %125, %124) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %128 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
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
    %133 = cce.vdups(%18, %132, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb45(%5 : i64)
  ^bb45(%134: i64):  // 2 preds: ^bb44, ^bb46
    %135 = llvm.icmp "slt" %134, %22 : i64
    llvm.cond_br %135, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %136 = llvm.trunc %134 : i64 to i32
    %137 = llvm.mul %136, %23 : i32
    %138 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %139 = llvm.sext %137 : i32 to i64
    %140 = llvm.getelementptr %138[%139] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%133, %140, %1, %1, %1, %132) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %141 = llvm.add %134, %11 : i64
    llvm.br ^bb45(%141 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%24) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %142 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
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
    %dst_8, %restElem_9 = cce.plt(%14) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%147: i64):  // 2 preds: ^bb51, ^bb53
    %148 = llvm.icmp "slt" %147, %6 : i64
    llvm.cond_br %148, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %149 = llvm.trunc %147 : i64 to i32
    %150 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %151 = llvm.sext %149 : i32 to i64
    %152 = llvm.getelementptr %150[%151] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %153 = cce.intr.vldsx1.i8(%152, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %154 = llvm.mul %149, %14 : i32
    %155 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %156 = llvm.sext %154 : i32 to i64
    %157 = llvm.getelementptr %155[%156] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%153, %157, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %158 = llvm.add %147, %11 : i64
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
    %163 = cce.vdups(%18, %162, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb59(%5 : i64)
  ^bb59(%164: i64):  // 2 preds: ^bb58, ^bb60
    %165 = llvm.icmp "slt" %164, %22 : i64
    llvm.cond_br %165, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %166 = llvm.trunc %164 : i64 to i32
    %167 = llvm.mul %166, %23 : i32
    %168 = llvm.inttoptr %26 : i64 to !llvm.ptr<6>
    %169 = llvm.sext %167 : i32 to i64
    %170 = llvm.getelementptr %168[%169] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%163, %170, %1, %1, %1, %162) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %171 = llvm.add %164, %11 : i64
    llvm.br ^bb59(%171 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%24) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %172 = llvm.inttoptr %26 : i64 to !llvm.ptr<6>
    %173 = llvm.getelementptr %172[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%163, %173, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %174 = llvm.add %160, %0 : i32
    llvm.br ^bb57(%174 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%175: i32):  // 2 preds: ^bb63, ^bb69
    %176 = llvm.icmp "sle" %175, %1 : i32
    llvm.cond_br %176, ^bb65, ^bb70
  ^bb65:  // pred: ^bb64
    %dst_12, %restElem_13 = cce.plt(%14) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb66(%5 : i64)
  ^bb66(%177: i64):  // 2 preds: ^bb65, ^bb67
    %178 = llvm.icmp "slt" %177, %6 : i64
    llvm.cond_br %178, ^bb67, ^bb68
  ^bb67:  // pred: ^bb66
    %179 = llvm.trunc %177 : i64 to i32
    %180 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %181 = cce.intr.vldsx1.i8(%180, %1, %27, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %182 = llvm.mul %179, %14 : i32
    %183 = llvm.inttoptr %26 : i64 to !llvm.ptr<6>
    %184 = llvm.sext %182 : i32 to i64
    %185 = llvm.getelementptr %183[%184] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%181, %185, %1, %28, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %186 = llvm.add %177, %11 : i64
    llvm.br ^bb66(%186 : i64)
  ^bb68:  // pred: ^bb66
    llvm.br ^bb69
  ^bb69:  // pred: ^bb68
    %187 = llvm.add %175, %0 : i32
    llvm.br ^bb64(%187 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb70:  // pred: ^bb64
    llvm.br ^bb71(%1 : i32)
  ^bb71(%188: i32):  // 2 preds: ^bb70, ^bb76
    %189 = llvm.icmp "sle" %188, %1 : i32
    llvm.cond_br %189, ^bb72, ^bb77
  ^bb72:  // pred: ^bb71
    %190 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %191 = cce.vdups(%18, %190, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb73(%5 : i64)
  ^bb73(%192: i64):  // 2 preds: ^bb72, ^bb74
    %193 = llvm.icmp "slt" %192, %22 : i64
    llvm.cond_br %193, ^bb74, ^bb75
  ^bb74:  // pred: ^bb73
    %194 = llvm.trunc %192 : i64 to i32
    %195 = llvm.mul %194, %23 : i32
    %196 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %197 = llvm.sext %195 : i32 to i64
    %198 = llvm.getelementptr %196[%197] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%191, %198, %1, %1, %1, %190) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %199 = llvm.add %192, %11 : i64
    llvm.br ^bb73(%199 : i64)
  ^bb75:  // pred: ^bb73
    %dst_14, %restElem_15 = cce.plt(%24) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %200 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %201 = llvm.getelementptr %200[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%191, %201, %1, %1, %1, %dst_14) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb76
  ^bb76:  // pred: ^bb75
    %202 = llvm.add %188, %0 : i32
    llvm.br ^bb71(%202 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb77:  // pred: ^bb71
    llvm.br ^bb78(%1 : i32)
  ^bb78(%203: i32):  // 2 preds: ^bb77, ^bb83
    %204 = llvm.icmp "sle" %203, %1 : i32
    llvm.cond_br %204, ^bb79, ^bb84
  ^bb79:  // pred: ^bb78
    %205 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb80(%5 : i64)
  ^bb80(%206: i64):  // 2 preds: ^bb79, ^bb81
    %207 = llvm.icmp "slt" %206, %22 : i64
    llvm.cond_br %207, ^bb81, ^bb82
  ^bb81:  // pred: ^bb80
    %208 = llvm.trunc %206 : i64 to i32
    %209 = llvm.udiv %208, %30 : i32
    %210 = llvm.urem %208, %30 : i32
    %211 = llvm.mul %210, %23 : i32
    %212 = llvm.mul %209, %25 : i32
    %213 = llvm.add %212, %211 : i32
    %214 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %215 = llvm.sext %213 : i32 to i64
    %216 = llvm.getelementptr %214[%215] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %217 = cce.intr.vldsx1.i8(%216, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %218 = cce.vdups(%18, %205, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %219 = cce.cmp(%217, %218, %205) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %220 = llvm.inttoptr %26 : i64 to !llvm.ptr<6>
    %221 = llvm.sext %213 : i32 to i64
    %222 = llvm.getelementptr %220[%221] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %223 = cce.intr.vldsx1.i8(%222, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %224 = cce.cmp(%223, %218, %205) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %225 = cce.pand(%219, %224, %205) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %226 = cce.vdups(%19, %205, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %227 = cce.vsel(%226, %218, %225) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %228 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %229 = llvm.sext %213 : i32 to i64
    %230 = llvm.getelementptr %228[%229] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%227, %230, %1, %1, %1, %205) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %231 = llvm.add %206, %11 : i64
    llvm.br ^bb80(%231 : i64)
  ^bb82:  // pred: ^bb80
    llvm.br ^bb83
  ^bb83:  // pred: ^bb82
    %232 = llvm.add %203, %0 : i32
    llvm.br ^bb78(%232 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb84:  // pred: ^bb78
    %233 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %234 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %235 = llvm.inttoptr %234 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%233, %235, %37, %38) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb85(%1 : i32)
  ^bb85(%236: i32):  // 2 preds: ^bb84, ^bb90
    %237 = llvm.icmp "sle" %236, %1 : i32
    llvm.cond_br %237, ^bb86, ^bb91
  ^bb86:  // pred: ^bb85
    %238 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb87(%5 : i64)
  ^bb87(%239: i64):  // 2 preds: ^bb86, ^bb88
    %240 = llvm.icmp "slt" %239, %32 : i64
    llvm.cond_br %240, ^bb88, ^bb89
  ^bb88:  // pred: ^bb87
    %241 = llvm.mul %239, %33 : i64
    %242 = llvm.trunc %241 : i64 to i32
    %243 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %244 = llvm.inttoptr %29 : i64 to !llvm.ptr<6>
    %245 = llvm.sext %242 : i32 to i64
    %246 = llvm.getelementptr %244[%245] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %247 = cce.intr.vldsx1.i8(%246, %1, %34, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %248 = cce.vcvtii.ext(%247, %243, %1) {unsigned} : (vector<256xi8>, vector<256xi1>, i32) -> vector<128xi16>
    %249 = cce.vdups(%35, %238, %1) {mode = ["z"]} : (i16, vector<256xi1>, i32) -> vector<128xi16>
    %250 = cce.cmp(%248, %249, %238) {predicate = "ne"} : (vector<128xi16>, vector<128xi16>, vector<256xi1>) -> vector<256xi1>
    %251 = llvm.mul %242, %12 : i32
    %252 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %253 = llvm.sext %251 : i32 to i64
    %254 = llvm.getelementptr %252[%253] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %255 = cce.intr.vldsx1.f16(%254, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %256 = cce.vdups(%9, %238, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    %257 = cce.vsel(%255, %256, %250) : (vector<128xf16>, vector<128xf16>, vector<256xi1>) -> vector<128xf16>
    %258 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %259 = llvm.sext %251 : i32 to i64
    %260 = llvm.getelementptr %258[%259] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f16(%257, %260, %1, %0, %1, %238) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    %261 = llvm.add %239, %11 : i64
    llvm.br ^bb87(%261 : i64)
  ^bb89:  // pred: ^bb87
    llvm.br ^bb90
  ^bb90:  // pred: ^bb89
    %262 = llvm.add %236, %0 : i32
    llvm.br ^bb85(%262 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb91:  // pred: ^bb85
    llvm.br ^bb92(%1 : i32)
  ^bb92(%263: i32):  // 2 preds: ^bb91, ^bb97
    %264 = llvm.icmp "sle" %263, %1 : i32
    llvm.cond_br %264, ^bb93, ^bb98
  ^bb93:  // pred: ^bb92
    %dst_16, %restElem_17 = cce.plt(%14) {mask_bitwidth = 16 : i32} : (i32) -> (vector<256xi1>, i32)
    %265 = cce.vdups(%9, %dst_16, %1) {mode = ["z"]} : (f16, vector<256xi1>, i32) -> vector<128xf16>
    llvm.br ^bb94(%5, %265 : i64, vector<128xf16>)
  ^bb94(%266: i64, %267: vector<128xf16>):  // 2 preds: ^bb93, ^bb95
    %268 = llvm.icmp "slt" %266, %6 : i64
    llvm.cond_br %268, ^bb95, ^bb96
  ^bb95:  // pred: ^bb94
    %269 = llvm.trunc %266 : i64 to i32
    %270 = llvm.mul %269, %41 : i32
    %271 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %272 = llvm.sext %270 : i32 to i64
    %273 = llvm.getelementptr %271[%272] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %274 = cce.intr.vldsx1.f16(%273, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xf16>
    %275 = cce.vmin(%267, %274, %dst_16) : (vector<128xf16>, vector<128xf16>, vector<256xi1>) -> vector<128xf16>
    %276 = llvm.add %266, %11 : i64
    llvm.br ^bb94(%276, %275 : i64, vector<128xf16>)
  ^bb96:  // pred: ^bb94
    %277 = llvm.inttoptr %36 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f16(%267, %277, %1, %0, %1, %dst_16) : (vector<128xf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb97
  ^bb97:  // pred: ^bb96
    %278 = llvm.add %263, %0 : i32
    llvm.br ^bb92(%278 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb98:  // pred: ^bb92
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %279 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %280 = llvm.inttoptr %279 : i64 to !llvm.ptr<1>
    %281 = llvm.inttoptr %36 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%280, %281, %39, %40) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otr_min_d0_f32_s3(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
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
    %35 = llvm.mlir.constant(288230382594163200 : i64) : i64
    %36 = llvm.mlir.constant(281474976710848 : i64) : i64
    %37 = llvm.mlir.constant(288230382594162704 : i64) : i64
    %38 = llvm.mlir.constant(211106232533184 : i64) : i64
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
  ^bb2:  // 2 preds: ^bb0, ^bb98
    llvm.return
  ^bb3(%45: i32):  // 2 preds: ^bb1, ^bb5
    %46 = llvm.icmp "sle" %45, %1 : i32
    llvm.cond_br %46, ^bb4, ^bb6
  ^bb4:  // pred: ^bb3
    %47 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %48 = cce.vdups(%8, %47, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %49 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
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
    %53 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %54 = cce.vdups(%1, %53, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %55 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%54, %55, %1, %14, %1, %53) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb9
  ^bb9:  // pred: ^bb8
    %56 = llvm.add %51, %0 : i32
    llvm.br ^bb7(%56 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb10:  // pred: ^bb7
    llvm.br ^bb11(%1 : i32)
  ^bb11(%57: i32):  // 2 preds: ^bb10, ^bb13
    %58 = llvm.icmp "sle" %57, %1 : i32
    llvm.cond_br %58, ^bb12, ^bb14
  ^bb12:  // pred: ^bb11
    %dst, %restElem = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %59 = cce.vdups(%7, %dst, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %60 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%59, %60, %1, %14, %1, %dst) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb13
  ^bb13:  // pred: ^bb12
    %61 = llvm.add %57, %0 : i32
    llvm.br ^bb11(%61 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb14:  // pred: ^bb11
    llvm.br ^bb15(%1 : i32)
  ^bb15(%62: i32):  // 2 preds: ^bb14, ^bb17
    %63 = llvm.icmp "sle" %62, %1 : i32
    llvm.cond_br %63, ^bb16, ^bb18
  ^bb16:  // pred: ^bb15
    %64 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %65 = cce.vdups(%1, %64, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
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
    %70 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %dst_0, %restElem_1 = cce.plt(%7) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %71 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%70, %71, %1, %14, %1, %dst_0) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb21
  ^bb21:  // pred: ^bb20
    %72 = llvm.add %68, %0 : i32
    llvm.br ^bb19(%72 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb22:  // pred: ^bb19
    llvm.br ^bb23(%1 : i32)
  ^bb23(%73: i32):  // 2 preds: ^bb22, ^bb25
    %74 = llvm.icmp "sle" %73, %1 : i32
    llvm.cond_br %74, ^bb24, ^bb26
  ^bb24:  // pred: ^bb23
    %75 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %76 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %77 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.i32(%76, %77, %1, %14, %1, %75) : (vector<64xi32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb25
  ^bb25:  // pred: ^bb24
    %78 = llvm.add %73, %0 : i32
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
    %90 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %91 = cce.intr.vldsx1.i32(%90, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %92 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %93 = cce.intr.vldsx1.i32(%92, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %94 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %95 = cce.cmp(%93, %91, %94) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_2, %restElem_3 = cce.plt(%7) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
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
    %114 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %115 = cce.intr.vldsx1.i32(%114, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %116 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %117 = cce.intr.vldsx1.i32(%116, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xi32>
    %118 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %119 = cce.cmp(%117, %115, %118) {predicate = "lt"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %dst_4, %restElem_5 = cce.plt(%16) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
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
    %132 = llvm.icmp "slt" %131, %24 : i64
    llvm.cond_br %132, ^bb46, ^bb47
  ^bb46:  // pred: ^bb45
    %133 = llvm.trunc %131 : i64 to i32
    %134 = llvm.mul %133, %25 : i32
    %135 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %136 = llvm.sext %134 : i32 to i64
    %137 = llvm.getelementptr %135[%136] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%130, %137, %1, %1, %1, %129) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %138 = llvm.add %131, %11 : i64
    llvm.br ^bb45(%138 : i64)
  ^bb47:  // pred: ^bb45
    %dst_6, %restElem_7 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
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
    %dst_8, %restElem_9 = cce.plt(%16) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb52(%5 : i64)
  ^bb52(%144: i64):  // 2 preds: ^bb51, ^bb53
    %145 = llvm.icmp "slt" %144, %6 : i64
    llvm.cond_br %145, ^bb53, ^bb54
  ^bb53:  // pred: ^bb52
    %146 = llvm.trunc %144 : i64 to i32
    %147 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %148 = llvm.sext %146 : i32 to i64
    %149 = llvm.getelementptr %147[%148] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %150 = cce.intr.vldsx1.i8(%149, %1, %0, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %151 = llvm.mul %146, %16 : i32
    %152 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %153 = llvm.sext %151 : i32 to i64
    %154 = llvm.getelementptr %152[%153] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%150, %154, %1, %1, %1, %dst_8) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %155 = llvm.add %144, %11 : i64
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
    %162 = llvm.icmp "slt" %161, %24 : i64
    llvm.cond_br %162, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %163 = llvm.trunc %161 : i64 to i32
    %164 = llvm.mul %163, %25 : i32
    %165 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %166 = llvm.sext %164 : i32 to i64
    %167 = llvm.getelementptr %165[%166] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%160, %167, %1, %1, %1, %159) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %168 = llvm.add %161, %11 : i64
    llvm.br ^bb59(%168 : i64)
  ^bb61:  // pred: ^bb59
    %dst_10, %restElem_11 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %169 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %170 = llvm.getelementptr %169[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%160, %170, %1, %1, %1, %dst_10) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %171 = llvm.add %157, %0 : i32
    llvm.br ^bb57(%171 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb57
    llvm.br ^bb64(%1 : i32)
  ^bb64(%172: i32):  // 2 preds: ^bb63, ^bb69
    %173 = llvm.icmp "sle" %172, %1 : i32
    llvm.cond_br %173, ^bb65, ^bb70
  ^bb65:  // pred: ^bb64
    %dst_12, %restElem_13 = cce.plt(%16) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    llvm.br ^bb66(%5 : i64)
  ^bb66(%174: i64):  // 2 preds: ^bb65, ^bb67
    %175 = llvm.icmp "slt" %174, %6 : i64
    llvm.cond_br %175, ^bb67, ^bb68
  ^bb67:  // pred: ^bb66
    %176 = llvm.trunc %174 : i64 to i32
    %177 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %178 = cce.intr.vldsx1.i8(%177, %1, %29, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %179 = llvm.mul %176, %16 : i32
    %180 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %181 = llvm.sext %179 : i32 to i64
    %182 = llvm.getelementptr %180[%181] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%178, %182, %1, %30, %1, %dst_12) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %183 = llvm.add %174, %11 : i64
    llvm.br ^bb66(%183 : i64)
  ^bb68:  // pred: ^bb66
    llvm.br ^bb69
  ^bb69:  // pred: ^bb68
    %184 = llvm.add %172, %0 : i32
    llvm.br ^bb64(%184 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb70:  // pred: ^bb64
    llvm.br ^bb71(%1 : i32)
  ^bb71(%185: i32):  // 2 preds: ^bb70, ^bb76
    %186 = llvm.icmp "sle" %185, %1 : i32
    llvm.cond_br %186, ^bb72, ^bb77
  ^bb72:  // pred: ^bb71
    %187 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %188 = cce.vdups(%20, %187, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    llvm.br ^bb73(%5 : i64)
  ^bb73(%189: i64):  // 2 preds: ^bb72, ^bb74
    %190 = llvm.icmp "slt" %189, %24 : i64
    llvm.cond_br %190, ^bb74, ^bb75
  ^bb74:  // pred: ^bb73
    %191 = llvm.trunc %189 : i64 to i32
    %192 = llvm.mul %191, %25 : i32
    %193 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %194 = llvm.sext %192 : i32 to i64
    %195 = llvm.getelementptr %193[%194] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%188, %195, %1, %1, %1, %187) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %196 = llvm.add %189, %11 : i64
    llvm.br ^bb73(%196 : i64)
  ^bb75:  // pred: ^bb73
    %dst_14, %restElem_15 = cce.plt(%26) {mask_bitwidth = 8 : i32} : (i32) -> (vector<256xi1>, i32)
    %197 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %198 = llvm.getelementptr %197[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%188, %198, %1, %1, %1, %dst_14) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb76
  ^bb76:  // pred: ^bb75
    %199 = llvm.add %185, %0 : i32
    llvm.br ^bb71(%199 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb77:  // pred: ^bb71
    llvm.br ^bb78(%1 : i32)
  ^bb78(%200: i32):  // 2 preds: ^bb77, ^bb83
    %201 = llvm.icmp "sle" %200, %1 : i32
    llvm.cond_br %201, ^bb79, ^bb84
  ^bb79:  // pred: ^bb78
    %202 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb80(%5 : i64)
  ^bb80(%203: i64):  // 2 preds: ^bb79, ^bb81
    %204 = llvm.icmp "slt" %203, %24 : i64
    llvm.cond_br %204, ^bb81, ^bb82
  ^bb81:  // pred: ^bb80
    %205 = llvm.trunc %203 : i64 to i32
    %206 = llvm.udiv %205, %32 : i32
    %207 = llvm.urem %205, %32 : i32
    %208 = llvm.mul %207, %25 : i32
    %209 = llvm.mul %206, %27 : i32
    %210 = llvm.add %209, %208 : i32
    %211 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %212 = llvm.sext %210 : i32 to i64
    %213 = llvm.getelementptr %211[%212] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %214 = cce.intr.vldsx1.i8(%213, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %215 = cce.vdups(%20, %202, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %216 = cce.cmp(%214, %215, %202) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %217 = llvm.inttoptr %28 : i64 to !llvm.ptr<6>
    %218 = llvm.sext %210 : i32 to i64
    %219 = llvm.getelementptr %217[%218] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %220 = cce.intr.vldsx1.i8(%219, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %221 = cce.cmp(%220, %215, %202) {predicate = "ne"} : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi1>
    %222 = cce.pand(%216, %221, %202) {mask_bitwidth = 8 : i32} : (vector<256xi1>, vector<256xi1>, vector<256xi1>) -> vector<256xi1>
    %223 = cce.vdups(%21, %202, %1) {mode = ["z"]} : (i8, vector<256xi1>, i32) -> vector<256xi8>
    %224 = cce.vsel(%223, %215, %222) : (vector<256xi8>, vector<256xi8>, vector<256xi1>) -> vector<256xi8>
    %225 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %226 = llvm.sext %210 : i32 to i64
    %227 = llvm.getelementptr %225[%226] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.i8(%224, %227, %1, %1, %1, %202) : (vector<256xi8>, <6>, i32, i32, i32, vector<256xi1>)
    %228 = llvm.add %203, %11 : i64
    llvm.br ^bb80(%228 : i64)
  ^bb82:  // pred: ^bb80
    llvm.br ^bb83
  ^bb83:  // pred: ^bb82
    %229 = llvm.add %200, %0 : i32
    llvm.br ^bb78(%229 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb84:  // pred: ^bb78
    %230 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %231 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %232 = llvm.inttoptr %231 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f32.dv(%230, %232, %35, %36) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb85(%1 : i32)
  ^bb85(%233: i32):  // 2 preds: ^bb84, ^bb90
    %234 = llvm.icmp "sle" %233, %1 : i32
    llvm.cond_br %234, ^bb86, ^bb91
  ^bb86:  // pred: ^bb85
    %235 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb87(%5 : i64)
  ^bb87(%236: i64):  // 2 preds: ^bb86, ^bb88
    %237 = llvm.icmp "slt" %236, %6 : i64
    llvm.cond_br %237, ^bb88, ^bb89
  ^bb88:  // pred: ^bb87
    %238 = llvm.mul %236, %13 : i64
    %239 = llvm.trunc %238 : i64 to i32
    %240 = cce.pset(%1) {mask_bitwidth = 8 : i32} : (i32) -> vector<256xi1>
    %241 = llvm.inttoptr %31 : i64 to !llvm.ptr<6>
    %242 = llvm.sext %239 : i32 to i64
    %243 = llvm.getelementptr %241[%242] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %244 = cce.intr.vldsx1.i8(%243, %1, %29, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<256xi8>
    %245 = cce.vcvtii.ext(%244, %240, %1) : (vector<256xi8>, vector<256xi1>, i32) -> vector<64xi32>
    %246 = cce.vdups(%1, %235, %1) {mode = ["z"]} : (i32, vector<256xi1>, i32) -> vector<64xi32>
    %247 = cce.cmp(%245, %246, %235) {predicate = "ne"} : (vector<64xi32>, vector<64xi32>, vector<256xi1>) -> vector<256xi1>
    %248 = llvm.mul %239, %12 : i32
    %249 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %250 = llvm.sext %248 : i32 to i64
    %251 = llvm.getelementptr %249[%250] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %252 = cce.intr.vldsx1.f32(%251, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %253 = cce.vdups(%9, %235, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    %254 = cce.vsel(%252, %253, %247) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %255 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %256 = llvm.sext %248 : i32 to i64
    %257 = llvm.getelementptr %255[%256] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%254, %257, %1, %14, %1, %235) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %258 = llvm.add %236, %11 : i64
    llvm.br ^bb87(%258 : i64)
  ^bb89:  // pred: ^bb87
    llvm.br ^bb90
  ^bb90:  // pred: ^bb89
    %259 = llvm.add %233, %0 : i32
    llvm.br ^bb85(%259 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb91:  // pred: ^bb85
    llvm.br ^bb92(%1 : i32)
  ^bb92(%260: i32):  // 2 preds: ^bb91, ^bb97
    %261 = llvm.icmp "sle" %260, %1 : i32
    llvm.cond_br %261, ^bb93, ^bb98
  ^bb93:  // pred: ^bb92
    %262 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %263 = cce.vdups(%9, %262, %1) {mode = ["z"]} : (f32, vector<256xi1>, i32) -> vector<64xf32>
    llvm.br ^bb94(%5, %263 : i64, vector<64xf32>)
  ^bb94(%264: i64, %265: vector<64xf32>):  // 2 preds: ^bb93, ^bb95
    %266 = llvm.icmp "slt" %264, %6 : i64
    llvm.cond_br %266, ^bb95, ^bb96
  ^bb95:  // pred: ^bb94
    %267 = llvm.trunc %264 : i64 to i32
    %268 = llvm.mul %267, %25 : i32
    %269 = llvm.inttoptr %33 : i64 to !llvm.ptr<6>
    %270 = llvm.sext %268 : i32 to i64
    %271 = llvm.getelementptr %269[%270] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %272 = cce.intr.vldsx1.f32(%271, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %273 = cce.vmin(%265, %272, %262) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %274 = llvm.add %264, %11 : i64
    llvm.br ^bb94(%274, %273 : i64, vector<64xf32>)
  ^bb96:  // pred: ^bb94
    %275 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%265, %275, %1, %14, %1, %262) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb97
  ^bb97:  // pred: ^bb96
    %276 = llvm.add %260, %0 : i32
    llvm.br ^bb92(%276 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb98:  // pred: ^bb92
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %277 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %278 = llvm.inttoptr %277 : i64 to !llvm.ptr<1>
    %279 = llvm.inttoptr %34 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%278, %279, %37, %38) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<AIV>} {
  llvm.func @otg_sum_d1_bf16(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : bf16) : bf16
    %6 = llvm.mlir.constant(16 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(2 : i32) : i32
    %10 = llvm.mlir.constant(128 : index) : i64
    %11 = llvm.mlir.constant(4096 : i64) : i64
    %12 = llvm.mlir.constant(32 : i32) : i32
    %13 = llvm.mlir.constant(4 : i32) : i32
    %14 = llvm.mlir.constant(288230377225453632 : i64) : i64
    %15 = llvm.mlir.constant(35184372088864 : i64) : i64
    %16 = llvm.mlir.constant(288230377225454592 : i64) : i64
    %17 = llvm.mlir.constant(70368744177696 : i64) : i64
    %18 = cce.get.ctrl -> i64
    %19 = cce.sbitset0(%18, %3) : (i64, i64) -> i64
    cce.set.ctrl(%19) : i64
    %20 = cce.get.ctrl -> i64
    %21 = cce.sbitset1(%20, %2) : (i64, i64) -> i64
    cce.set.ctrl(%21) : i64
    %22 = cce.get_sub_block_idx -> i64
    %23 = llvm.icmp "eq" %22, %4 : i64
    llvm.cond_br %23, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.br ^bb3(%1 : i32)
  ^bb2:  // 2 preds: ^bb0, ^bb13
    llvm.return
  ^bb3(%24: i32):  // 2 preds: ^bb1, ^bb8
    %25 = llvm.icmp "sle" %24, %1 : i32
    llvm.cond_br %25, ^bb4, ^bb9
  ^bb4:  // pred: ^bb3
    %26 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb5(%7 : i64)
  ^bb5(%27: i64):  // 2 preds: ^bb4, ^bb6
    %28 = llvm.icmp "slt" %27, %6 : i64
    llvm.cond_br %28, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %29 = llvm.mul %27, %10 : i64
    %30 = cce.vdups(%5, %26, %1) {mode = ["z"]} : (bf16, vector<256xi1>, i32) -> vector<128xbf16>
    %31 = llvm.trunc %29 : i64 to i32
    %32 = llvm.mul %31, %9 : i32
    %33 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %34 = llvm.sext %32 : i32 to i64
    %35 = llvm.getelementptr %33[%34] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%30, %35, %1, %0, %1, %26) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %36 = llvm.add %27, %8 : i64
    llvm.br ^bb5(%36 : i64)
  ^bb7:  // pred: ^bb5
    llvm.br ^bb8
  ^bb8:  // pred: ^bb7
    %37 = llvm.add %24, %0 : i32
    llvm.br ^bb3(%37 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb9:  // pred: ^bb3
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %38 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %39 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %40 = llvm.inttoptr %39 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%38, %40, %16, %17) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb10(%1 : i32)
  ^bb10(%41: i32):  // 2 preds: ^bb9, ^bb12
    %42 = llvm.icmp "sle" %41, %1 : i32
    llvm.cond_br %42, ^bb11, ^bb13
  ^bb11:  // pred: ^bb10
    %43 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %44 = cce.intr.vldsx1.bf16(%43, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %45 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %46 = llvm.getelementptr %45[64] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %47 = cce.intr.vldsx1.bf16(%46, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %48 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %49 = llvm.getelementptr %48[128] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %50 = cce.intr.vldsx1.bf16(%49, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %51 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %52 = llvm.getelementptr %51[192] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %53 = cce.intr.vldsx1.bf16(%52, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %54 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %55 = llvm.getelementptr %54[256] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %56 = cce.intr.vldsx1.bf16(%55, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %57 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %58 = llvm.getelementptr %57[320] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %59 = cce.intr.vldsx1.bf16(%58, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %60 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %61 = llvm.getelementptr %60[384] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %62 = cce.intr.vldsx1.bf16(%61, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %63 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %64 = llvm.getelementptr %63[448] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %65 = cce.intr.vldsx1.bf16(%64, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %66 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %67 = llvm.getelementptr %66[512] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %68 = cce.intr.vldsx1.bf16(%67, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %69 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %70 = llvm.getelementptr %69[576] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %71 = cce.intr.vldsx1.bf16(%70, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %72 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %73 = llvm.getelementptr %72[640] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %74 = cce.intr.vldsx1.bf16(%73, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %75 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %76 = llvm.getelementptr %75[704] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %77 = cce.intr.vldsx1.bf16(%76, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %78 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %79 = llvm.getelementptr %78[768] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %80 = cce.intr.vldsx1.bf16(%79, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %81 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %82 = llvm.getelementptr %81[832] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %83 = cce.intr.vldsx1.bf16(%82, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %84 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %85 = llvm.getelementptr %84[896] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %86 = cce.intr.vldsx1.bf16(%85, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %87 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %88 = llvm.getelementptr %87[960] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %89 = cce.intr.vldsx1.bf16(%88, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %90 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %91 = llvm.getelementptr %90[1024] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %92 = cce.intr.vldsx1.bf16(%91, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %93 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %94 = llvm.getelementptr %93[1088] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %95 = cce.intr.vldsx1.bf16(%94, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %96 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %97 = llvm.getelementptr %96[1152] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %98 = cce.intr.vldsx1.bf16(%97, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %99 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %100 = llvm.getelementptr %99[1216] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %101 = cce.intr.vldsx1.bf16(%100, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %102 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %103 = llvm.getelementptr %102[1280] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %104 = cce.intr.vldsx1.bf16(%103, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %105 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %106 = llvm.getelementptr %105[1344] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %107 = cce.intr.vldsx1.bf16(%106, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %108 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %109 = llvm.getelementptr %108[1408] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %110 = cce.intr.vldsx1.bf16(%109, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %111 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %112 = llvm.getelementptr %111[1472] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %113 = cce.intr.vldsx1.bf16(%112, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %114 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %115 = llvm.getelementptr %114[1536] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %116 = cce.intr.vldsx1.bf16(%115, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %117 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %118 = llvm.getelementptr %117[1600] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %119 = cce.intr.vldsx1.bf16(%118, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %120 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %121 = llvm.getelementptr %120[1664] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %122 = cce.intr.vldsx1.bf16(%121, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %123 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %124 = llvm.getelementptr %123[1728] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %125 = cce.intr.vldsx1.bf16(%124, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %126 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %127 = llvm.getelementptr %126[1792] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %128 = cce.intr.vldsx1.bf16(%127, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %129 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %130 = llvm.getelementptr %129[1856] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %131 = cce.intr.vldsx1.bf16(%130, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %132 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %133 = llvm.getelementptr %132[1920] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %134 = cce.intr.vldsx1.bf16(%133, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %135 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %136 = llvm.getelementptr %135[1984] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %137 = cce.intr.vldsx1.bf16(%136, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %138 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %139 = llvm.getelementptr %138[2048] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %140 = cce.intr.vldsx1.bf16(%139, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %141 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %142 = llvm.getelementptr %141[2112] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %143 = cce.intr.vldsx1.bf16(%142, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %144 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %145 = llvm.getelementptr %144[2176] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %146 = cce.intr.vldsx1.bf16(%145, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %147 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %148 = llvm.getelementptr %147[2240] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %149 = cce.intr.vldsx1.bf16(%148, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %150 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %151 = llvm.getelementptr %150[2304] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %152 = cce.intr.vldsx1.bf16(%151, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %153 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %154 = llvm.getelementptr %153[2368] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %155 = cce.intr.vldsx1.bf16(%154, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %156 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %157 = llvm.getelementptr %156[2432] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %158 = cce.intr.vldsx1.bf16(%157, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %159 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %160 = llvm.getelementptr %159[2496] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %161 = cce.intr.vldsx1.bf16(%160, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %162 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %163 = llvm.getelementptr %162[2560] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %164 = cce.intr.vldsx1.bf16(%163, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %165 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %166 = llvm.getelementptr %165[2624] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %167 = cce.intr.vldsx1.bf16(%166, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %168 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %169 = llvm.getelementptr %168[2688] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %170 = cce.intr.vldsx1.bf16(%169, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %171 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %172 = llvm.getelementptr %171[2752] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %173 = cce.intr.vldsx1.bf16(%172, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %174 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %175 = llvm.getelementptr %174[2816] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %176 = cce.intr.vldsx1.bf16(%175, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %177 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %178 = llvm.getelementptr %177[2880] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %179 = cce.intr.vldsx1.bf16(%178, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %180 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %181 = llvm.getelementptr %180[2944] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %182 = cce.intr.vldsx1.bf16(%181, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %183 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %184 = llvm.getelementptr %183[3008] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %185 = cce.intr.vldsx1.bf16(%184, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %186 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %187 = llvm.getelementptr %186[3072] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %188 = cce.intr.vldsx1.bf16(%187, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %189 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %190 = llvm.getelementptr %189[3136] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %191 = cce.intr.vldsx1.bf16(%190, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %192 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %193 = llvm.getelementptr %192[3200] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %194 = cce.intr.vldsx1.bf16(%193, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %195 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %196 = llvm.getelementptr %195[3264] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %197 = cce.intr.vldsx1.bf16(%196, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %198 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %199 = llvm.getelementptr %198[3328] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %200 = cce.intr.vldsx1.bf16(%199, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %201 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %202 = llvm.getelementptr %201[3392] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %203 = cce.intr.vldsx1.bf16(%202, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %204 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %205 = llvm.getelementptr %204[3456] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %206 = cce.intr.vldsx1.bf16(%205, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %207 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %208 = llvm.getelementptr %207[3520] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %209 = cce.intr.vldsx1.bf16(%208, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %210 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %211 = llvm.getelementptr %210[3584] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %212 = cce.intr.vldsx1.bf16(%211, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %213 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %214 = llvm.getelementptr %213[3648] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %215 = cce.intr.vldsx1.bf16(%214, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %216 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %217 = llvm.getelementptr %216[3712] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %218 = cce.intr.vldsx1.bf16(%217, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %219 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %220 = llvm.getelementptr %219[3776] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %221 = cce.intr.vldsx1.bf16(%220, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %222 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %223 = llvm.getelementptr %222[3840] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %224 = cce.intr.vldsx1.bf16(%223, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %225 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %226 = llvm.getelementptr %225[3904] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %227 = cce.intr.vldsx1.bf16(%226, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %228 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %229 = llvm.getelementptr %228[3968] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %230 = cce.intr.vldsx1.bf16(%229, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %231 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %232 = llvm.getelementptr %231[4032] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    %233 = cce.intr.vldsx1.bf16(%232, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %dst, %restElem = cce.plt(%12) {mask_bitwidth = 16 : i32} : (i32) -> (vector<256xi1>, i32)
    %234 = cce.vcvtff.ext(%44, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %dst_0, %restElem_1 = cce.plt(%12) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %235 = cce.vcadd(%234, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %236 = cce.pset(%9) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %237 = cce.vcvtff.trunc(%235, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %238 = cce.vcvtff.ext(%47, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %239 = cce.vcadd(%238, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %240 = cce.vcvtff.trunc(%239, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %241 = cce.vcvtff.ext(%50, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %242 = cce.vcadd(%241, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %243 = cce.vcvtff.trunc(%242, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %244 = cce.vcvtff.ext(%53, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %245 = cce.vcadd(%244, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %246 = cce.vcvtff.trunc(%245, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %247 = cce.vcvtff.ext(%56, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %248 = cce.vcadd(%247, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %249 = cce.vcvtff.trunc(%248, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %250 = cce.vcvtff.ext(%59, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %251 = cce.vcadd(%250, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %252 = cce.vcvtff.trunc(%251, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %253 = cce.vcvtff.ext(%62, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %254 = cce.vcadd(%253, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %255 = cce.vcvtff.trunc(%254, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %256 = cce.vcvtff.ext(%65, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %257 = cce.vcadd(%256, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %258 = cce.vcvtff.trunc(%257, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %259 = cce.vcvtff.ext(%68, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %260 = cce.vcadd(%259, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %261 = cce.vcvtff.trunc(%260, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %262 = cce.vcvtff.ext(%71, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %263 = cce.vcadd(%262, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %264 = cce.vcvtff.trunc(%263, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %265 = cce.vcvtff.ext(%74, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %266 = cce.vcadd(%265, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %267 = cce.vcvtff.trunc(%266, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %268 = cce.vcvtff.ext(%77, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %269 = cce.vcadd(%268, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %270 = cce.vcvtff.trunc(%269, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %271 = cce.vcvtff.ext(%80, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %272 = cce.vcadd(%271, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %273 = cce.vcvtff.trunc(%272, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %274 = cce.vcvtff.ext(%83, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %275 = cce.vcadd(%274, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %276 = cce.vcvtff.trunc(%275, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %277 = cce.vcvtff.ext(%86, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %278 = cce.vcadd(%277, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %279 = cce.vcvtff.trunc(%278, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %280 = cce.vcvtff.ext(%89, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %281 = cce.vcadd(%280, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %282 = cce.vcvtff.trunc(%281, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %283 = cce.vcvtff.ext(%92, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %284 = cce.vcadd(%283, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %285 = cce.vcvtff.trunc(%284, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %286 = cce.vcvtff.ext(%95, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %287 = cce.vcadd(%286, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %288 = cce.vcvtff.trunc(%287, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %289 = cce.vcvtff.ext(%98, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %290 = cce.vcadd(%289, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %291 = cce.vcvtff.trunc(%290, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %292 = cce.vcvtff.ext(%101, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %293 = cce.vcadd(%292, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %294 = cce.vcvtff.trunc(%293, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %295 = cce.vcvtff.ext(%104, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %296 = cce.vcadd(%295, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %297 = cce.vcvtff.trunc(%296, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %298 = cce.vcvtff.ext(%107, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %299 = cce.vcadd(%298, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %300 = cce.vcvtff.trunc(%299, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %301 = cce.vcvtff.ext(%110, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %302 = cce.vcadd(%301, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %303 = cce.vcvtff.trunc(%302, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %304 = cce.vcvtff.ext(%113, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %305 = cce.vcadd(%304, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %306 = cce.vcvtff.trunc(%305, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %307 = cce.vcvtff.ext(%116, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %308 = cce.vcadd(%307, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %309 = cce.vcvtff.trunc(%308, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %310 = cce.vcvtff.ext(%119, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %311 = cce.vcadd(%310, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %312 = cce.vcvtff.trunc(%311, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %313 = cce.vcvtff.ext(%122, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %314 = cce.vcadd(%313, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %315 = cce.vcvtff.trunc(%314, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %316 = cce.vcvtff.ext(%125, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %317 = cce.vcadd(%316, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %318 = cce.vcvtff.trunc(%317, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %319 = cce.vcvtff.ext(%128, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %320 = cce.vcadd(%319, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %321 = cce.vcvtff.trunc(%320, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %322 = cce.vcvtff.ext(%131, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %323 = cce.vcadd(%322, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %324 = cce.vcvtff.trunc(%323, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %325 = cce.vcvtff.ext(%134, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %326 = cce.vcadd(%325, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %327 = cce.vcvtff.trunc(%326, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %328 = cce.vcvtff.ext(%137, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %329 = cce.vcadd(%328, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %330 = cce.vcvtff.trunc(%329, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %331 = cce.vcvtff.ext(%140, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %332 = cce.vcadd(%331, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %333 = cce.vcvtff.trunc(%332, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %334 = cce.vcvtff.ext(%143, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %335 = cce.vcadd(%334, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %336 = cce.vcvtff.trunc(%335, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %337 = cce.vcvtff.ext(%146, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %338 = cce.vcadd(%337, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %339 = cce.vcvtff.trunc(%338, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %340 = cce.vcvtff.ext(%149, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %341 = cce.vcadd(%340, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %342 = cce.vcvtff.trunc(%341, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %343 = cce.vcvtff.ext(%152, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %344 = cce.vcadd(%343, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %345 = cce.vcvtff.trunc(%344, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %346 = cce.vcvtff.ext(%155, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %347 = cce.vcadd(%346, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %348 = cce.vcvtff.trunc(%347, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %349 = cce.vcvtff.ext(%158, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %350 = cce.vcadd(%349, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %351 = cce.vcvtff.trunc(%350, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %352 = cce.vcvtff.ext(%161, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %353 = cce.vcadd(%352, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %354 = cce.vcvtff.trunc(%353, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %355 = cce.vcvtff.ext(%164, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %356 = cce.vcadd(%355, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %357 = cce.vcvtff.trunc(%356, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %358 = cce.vcvtff.ext(%167, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %359 = cce.vcadd(%358, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %360 = cce.vcvtff.trunc(%359, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %361 = cce.vcvtff.ext(%170, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %362 = cce.vcadd(%361, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %363 = cce.vcvtff.trunc(%362, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %364 = cce.vcvtff.ext(%173, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %365 = cce.vcadd(%364, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %366 = cce.vcvtff.trunc(%365, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %367 = cce.vcvtff.ext(%176, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %368 = cce.vcadd(%367, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %369 = cce.vcvtff.trunc(%368, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %370 = cce.vcvtff.ext(%179, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %371 = cce.vcadd(%370, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %372 = cce.vcvtff.trunc(%371, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %373 = cce.vcvtff.ext(%182, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %374 = cce.vcadd(%373, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %375 = cce.vcvtff.trunc(%374, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %376 = cce.vcvtff.ext(%185, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %377 = cce.vcadd(%376, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %378 = cce.vcvtff.trunc(%377, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %379 = cce.vcvtff.ext(%188, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %380 = cce.vcadd(%379, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %381 = cce.vcvtff.trunc(%380, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %382 = cce.vcvtff.ext(%191, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %383 = cce.vcadd(%382, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %384 = cce.vcvtff.trunc(%383, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %385 = cce.vcvtff.ext(%194, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %386 = cce.vcadd(%385, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %387 = cce.vcvtff.trunc(%386, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %388 = cce.vcvtff.ext(%197, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %389 = cce.vcadd(%388, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %390 = cce.vcvtff.trunc(%389, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %391 = cce.vcvtff.ext(%200, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %392 = cce.vcadd(%391, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %393 = cce.vcvtff.trunc(%392, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %394 = cce.vcvtff.ext(%203, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %395 = cce.vcadd(%394, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %396 = cce.vcvtff.trunc(%395, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %397 = cce.vcvtff.ext(%206, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %398 = cce.vcadd(%397, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %399 = cce.vcvtff.trunc(%398, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %400 = cce.vcvtff.ext(%209, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %401 = cce.vcadd(%400, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %402 = cce.vcvtff.trunc(%401, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %403 = cce.vcvtff.ext(%212, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %404 = cce.vcadd(%403, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %405 = cce.vcvtff.trunc(%404, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %406 = cce.vcvtff.ext(%215, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %407 = cce.vcadd(%406, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %408 = cce.vcvtff.trunc(%407, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %409 = cce.vcvtff.ext(%218, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %410 = cce.vcadd(%409, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %411 = cce.vcvtff.trunc(%410, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %412 = cce.vcvtff.ext(%221, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %413 = cce.vcadd(%412, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %414 = cce.vcvtff.trunc(%413, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %415 = cce.vcvtff.ext(%224, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %416 = cce.vcadd(%415, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %417 = cce.vcvtff.trunc(%416, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %418 = cce.vcvtff.ext(%227, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %419 = cce.vcadd(%418, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %420 = cce.vcvtff.trunc(%419, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %421 = cce.vcvtff.ext(%230, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %422 = cce.vcadd(%421, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %423 = cce.vcvtff.trunc(%422, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %424 = cce.vcvtff.ext(%233, %dst, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %425 = cce.vcadd(%424, %dst_0) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %426 = cce.vcvtff.trunc(%425, %236, %0, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %427 = cce.pset(%9) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %428 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.bf16(%237, %428, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %429 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %430 = llvm.getelementptr %429[2] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%240, %430, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %431 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %432 = llvm.getelementptr %431[4] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%243, %432, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %433 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %434 = llvm.getelementptr %433[6] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%246, %434, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %435 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %436 = llvm.getelementptr %435[8] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%249, %436, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %437 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %438 = llvm.getelementptr %437[10] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%252, %438, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %439 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %440 = llvm.getelementptr %439[12] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%255, %440, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %441 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %442 = llvm.getelementptr %441[14] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%258, %442, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %443 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %444 = llvm.getelementptr %443[16] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%261, %444, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %445 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %446 = llvm.getelementptr %445[18] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%264, %446, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %447 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %448 = llvm.getelementptr %447[20] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%267, %448, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %449 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %450 = llvm.getelementptr %449[22] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%270, %450, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %451 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %452 = llvm.getelementptr %451[24] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%273, %452, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %453 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %454 = llvm.getelementptr %453[26] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%276, %454, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %455 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %456 = llvm.getelementptr %455[28] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%279, %456, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %457 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %458 = llvm.getelementptr %457[30] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%282, %458, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %459 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %460 = llvm.getelementptr %459[32] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%285, %460, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %461 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %462 = llvm.getelementptr %461[34] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%288, %462, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %463 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %464 = llvm.getelementptr %463[36] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%291, %464, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %465 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %466 = llvm.getelementptr %465[38] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%294, %466, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %467 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %468 = llvm.getelementptr %467[40] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%297, %468, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %469 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %470 = llvm.getelementptr %469[42] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%300, %470, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %471 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %472 = llvm.getelementptr %471[44] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%303, %472, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %473 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %474 = llvm.getelementptr %473[46] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%306, %474, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %475 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %476 = llvm.getelementptr %475[48] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%309, %476, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %477 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %478 = llvm.getelementptr %477[50] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%312, %478, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %479 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %480 = llvm.getelementptr %479[52] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%315, %480, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %481 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %482 = llvm.getelementptr %481[54] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%318, %482, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %483 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %484 = llvm.getelementptr %483[56] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%321, %484, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %485 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %486 = llvm.getelementptr %485[58] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%324, %486, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %487 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %488 = llvm.getelementptr %487[60] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%327, %488, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %489 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %490 = llvm.getelementptr %489[62] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%330, %490, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %491 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %492 = llvm.getelementptr %491[64] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%333, %492, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %493 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %494 = llvm.getelementptr %493[66] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%336, %494, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %495 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %496 = llvm.getelementptr %495[68] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%339, %496, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %497 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %498 = llvm.getelementptr %497[70] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%342, %498, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %499 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %500 = llvm.getelementptr %499[72] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%345, %500, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %501 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %502 = llvm.getelementptr %501[74] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%348, %502, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %503 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %504 = llvm.getelementptr %503[76] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%351, %504, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %505 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %506 = llvm.getelementptr %505[78] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%354, %506, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %507 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %508 = llvm.getelementptr %507[80] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%357, %508, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %509 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %510 = llvm.getelementptr %509[82] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%360, %510, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %511 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %512 = llvm.getelementptr %511[84] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%363, %512, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %513 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %514 = llvm.getelementptr %513[86] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%366, %514, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %515 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %516 = llvm.getelementptr %515[88] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%369, %516, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %517 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %518 = llvm.getelementptr %517[90] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%372, %518, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %519 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %520 = llvm.getelementptr %519[92] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%375, %520, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %521 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %522 = llvm.getelementptr %521[94] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%378, %522, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %523 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %524 = llvm.getelementptr %523[96] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%381, %524, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %525 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %526 = llvm.getelementptr %525[98] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%384, %526, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %527 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %528 = llvm.getelementptr %527[100] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%387, %528, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %529 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %530 = llvm.getelementptr %529[102] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%390, %530, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %531 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %532 = llvm.getelementptr %531[104] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%393, %532, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %533 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %534 = llvm.getelementptr %533[106] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%396, %534, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %535 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %536 = llvm.getelementptr %535[108] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%399, %536, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %537 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %538 = llvm.getelementptr %537[110] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%402, %538, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %539 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %540 = llvm.getelementptr %539[112] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%405, %540, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %541 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %542 = llvm.getelementptr %541[114] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%408, %542, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %543 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %544 = llvm.getelementptr %543[116] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%411, %544, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %545 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %546 = llvm.getelementptr %545[118] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%414, %546, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %547 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %548 = llvm.getelementptr %547[120] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%417, %548, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %549 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %550 = llvm.getelementptr %549[122] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%420, %550, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %551 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %552 = llvm.getelementptr %551[124] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%423, %552, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    %553 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %554 = llvm.getelementptr %553[126] : (!llvm.ptr<6>) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.bf16(%426, %554, %1, %13, %1, %427) : (vector<128xbf16>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb12
  ^bb12:  // pred: ^bb11
    %555 = llvm.add %41, %0 : i32
    llvm.br ^bb10(%555 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb13:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %556 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %557 = llvm.inttoptr %556 : i64 to !llvm.ptr<1>
    %558 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%557, %558, %14, %15) : (<1>, <6>, i64, i64)
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb2
  }
}


module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  llvm.func @paged_decode_probe_kernel_mix_aic(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: !llvm.ptr<1>, %arg6: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(48 : i64) : i64
    %1 = llvm.mlir.constant(60 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = cce.get.ctrl -> i64
    %4 = cce.sbitset0(%3, %1) : (i64, i64) -> i64
    cce.set.ctrl(%4) : i64
    %5 = cce.get.ctrl -> i64
    %6 = cce.sbitset1(%5, %0) : (i64, i64) -> i64
    cce.set.ctrl(%6) : i64
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %2
    cce.barrier pipe = <PIPE_ALL>
    llvm.return
  }
  llvm.func @paged_decode_probe_kernel_mix_aiv(%arg0: !llvm.ptr<1>, %arg1: !llvm.ptr<1>, %arg2: !llvm.ptr<1>, %arg3: !llvm.ptr<1>, %arg4: !llvm.ptr<1>, %arg5: !llvm.ptr<1>, %arg6: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.constant(48 : i64) : i64
    %3 = llvm.mlir.constant(60 : i64) : i64
    %4 = llvm.mlir.constant(0 : i64) : i64
    %5 = llvm.mlir.constant(37888 : i64) : i64
    %6 = llvm.mlir.constant(24576 : i64) : i64
    %7 = llvm.mlir.constant(28672 : i64) : i64
    %8 = llvm.mlir.constant(32768 : i64) : i64
    %9 = llvm.mlir.constant(38144 : i64) : i64
    %10 = llvm.mlir.constant(16384 : i64) : i64
    %11 = llvm.mlir.constant(8192 : i64) : i64
    %12 = llvm.mlir.constant(39168 : i64) : i64
    %13 = llvm.mlir.constant(39232 : i64) : i64
    %14 = llvm.mlir.constant(39296 : i64) : i64
    %15 = llvm.mlir.constant(36864 : i64) : i64
    %16 = llvm.mlir.constant(37376 : i64) : i64
    %17 = llvm.mlir.constant(39360 : i64) : i64
    %18 = llvm.mlir.constant(39392 : i64) : i64
    %19 = llvm.mlir.constant(39424 : i64) : i64
    %20 = llvm.mlir.constant(39456 : i64) : i64
    %21 = llvm.mlir.constant(39488 : i64) : i64
    %22 = llvm.mlir.constant(39520 : i64) : i64
    %23 = llvm.mlir.constant(38400 : i64) : i64
    %24 = llvm.mlir.constant(38656 : i64) : i64
    %25 = llvm.mlir.constant(38912 : i64) : i64
    %26 = llvm.mlir.constant(64 : index) : i64
    %27 = llvm.mlir.constant(8 : index) : i64
    %28 = llvm.mlir.constant(16 : index) : i64
    %29 = llvm.mlir.constant(2 : index) : i64
    %30 = llvm.mlir.constant(0 : index) : i64
    %31 = llvm.mlir.constant(1 : index) : i64
    %32 = llvm.mlir.constant(256 : index) : i64
    %33 = llvm.mlir.constant(128 : index) : i64
    %34 = llvm.mlir.constant(16 : i32) : i32
    %35 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %36 = llvm.mlir.constant(-9.99999968E+37 : f32) : f32
    %37 = llvm.mlir.constant(288230377225453696 : i64) : i64
    %38 = llvm.mlir.constant(35184372088864 : i64) : i64
    %39 = llvm.mlir.constant(2 : i32) : i32
    %40 = llvm.mlir.constant(4 : i32) : i32
    %41 = llvm.mlir.constant(14 : i32) : i32
    %42 = llvm.mlir.constant(256 : i32) : i32
    %43 = llvm.mlir.constant(512 : i32) : i32
    %44 = llvm.mlir.constant(128 : i32) : i32
    %45 = llvm.mlir.constant(288230384741646592 : i64) : i64
    %46 = llvm.mlir.constant(281474976711168 : i64) : i64
    %47 = llvm.mlir.constant(64 : i32) : i32
    %48 = llvm.mlir.constant(5 : i32) : i32
    %49 = llvm.mlir.constant(7 : i32) : i32
    %50 = llvm.mlir.constant(2 : i64) : i64
    %51 = llvm.mlir.constant(128 : i64) : i64
    %52 = llvm.mlir.constant(4 : i64) : i64
    %53 = llvm.mlir.constant(8 : i64) : i64
    %54 = cce.get.ctrl -> i64
    %55 = cce.sbitset0(%54, %3) : (i64, i64) -> i64
    cce.set.ctrl(%55) : i64
    %56 = cce.get.ctrl -> i64
    %57 = cce.sbitset1(%56, %2) : (i64, i64) -> i64
    cce.set.ctrl(%57) : i64
    %58 = cce.get_sub_block_idx -> i64
    %59 = llvm.icmp "eq" %58, %4 : i64
    llvm.cond_br %59, ^bb1, ^bb43
  ^bb1:  // pred: ^bb0
    %60 = cce.get_block_idx -> i64
    %61 = llvm.trunc %60 : i64 to i32
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID2>
    llvm.br ^bb2(%30 : i64)
  ^bb2(%62: i64):  // 2 preds: ^bb1, ^bb85
    %63 = llvm.icmp "slt" %62, %29 : i64
    llvm.cond_br %63, ^bb3, ^bb42
  ^bb3:  // pred: ^bb2
    %64 = llvm.sext %61 : i32 to i64
    %65 = llvm.mul %64, %32 : i64
    %66 = llvm.mul %62, %33 : i64
    %67 = llvm.add %65, %66 : i64
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %68 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %69 = llvm.ptrtoint %arg0 : !llvm.ptr<1> to i64
    %70 = llvm.mul %67, %50 : i64
    %71 = llvm.add %69, %70 : i64
    %72 = llvm.inttoptr %71 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%68, %72, %37, %38) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    llvm.br ^bb4(%30 : i64)
  ^bb4(%73: i64):  // 2 preds: ^bb3, ^bb8
    %74 = llvm.icmp "slt" %73, %28 : i64
    llvm.cond_br %74, ^bb5, ^bb9
  ^bb5:  // pred: ^bb4
    llvm.br ^bb6(%30 : i64)
  ^bb6(%75: i64):  // 2 preds: ^bb5, ^bb7
    %76 = llvm.icmp "slt" %75, %33 : i64
    llvm.cond_br %76, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %77 = llvm.inttoptr %5 : i64 to !llvm.ptr<6>
    %78 = llvm.mul %75, %50 : i64
    %79 = llvm.getelementptr %77[%78] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %80 = llvm.load %79 : !llvm.ptr<6> -> bf16
    %81 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %82 = llvm.mul %73, %51 : i64
    %83 = llvm.add %82, %75 : i64
    %84 = llvm.mul %83, %50 : i64
    %85 = llvm.getelementptr %81[%84] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %80, %85 : bf16, !llvm.ptr<6>
    %86 = llvm.add %75, %31 : i64
    llvm.br ^bb6(%86 : i64)
  ^bb8:  // pred: ^bb6
    %87 = llvm.add %73, %31 : i64
    llvm.br ^bb4(%87 : i64)
  ^bb9:  // pred: ^bb4
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb44(%1 : i32)
  ^bb10(%88: i64):  // 2 preds: ^bb11, ^bb50
    %89 = llvm.icmp "slt" %88, %33 : i64
    llvm.cond_br %89, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %90 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %91 = llvm.mul %88, %52 : i64
    %92 = llvm.getelementptr %90[%91] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %35, %92 : f32, !llvm.ptr<6>
    %93 = llvm.add %88, %31 : i64
    llvm.br ^bb10(%93 : i64)
  ^bb12:  // pred: ^bb10
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    %94 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    llvm.store %36, %94 : f32, !llvm.ptr<6>
    %95 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    llvm.store %35, %95 : f32, !llvm.ptr<6>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    llvm.br ^bb13(%30 : i64)
  ^bb13(%96: i64):  // 2 preds: ^bb12, ^bb37
    %97 = llvm.icmp "slt" %96, %27 : i64
    llvm.cond_br %97, ^bb14, ^bb38
  ^bb14:  // pred: ^bb13
    %98 = llvm.mul %96, %28 : i64
    %99 = llvm.ptrtoint %arg3 : !llvm.ptr<1> to i64
    %100 = llvm.inttoptr %99 : i64 to !llvm.ptr<1>
    %101 = llvm.getelementptr %100[%64] : (!llvm.ptr<1>, i64) -> !llvm.ptr<1>, i32
    %102 = llvm.load %101 : !llvm.ptr<1> -> i32
    %103 = llvm.sext %102 : i32 to i64
    %104 = llvm.icmp "slt" %98, %103 : i64
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    llvm.cond_br %104, ^bb15, ^bb37
  ^bb15:  // pred: ^bb14
    %105 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %106 = llvm.inttoptr %105 : i64 to !llvm.ptr<1>
    %107 = llvm.mul %64, %53 : i64
    %108 = llvm.add %107, %96 : i64
    %109 = llvm.getelementptr %106[%108] : (!llvm.ptr<1>, i64) -> !llvm.ptr<1>, i32
    %110 = llvm.load %109 : !llvm.ptr<1> -> i32
    %111 = llvm.mul %110, %34 : i32
    %112 = llvm.sext %111 : i32 to i64
    %113 = llvm.mul %112, %32 : i64
    %114 = llvm.add %113, %66 : i64
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %115 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %116 = llvm.ptrtoint %arg1 : !llvm.ptr<1> to i64
    %117 = llvm.mul %114, %50 : i64
    %118 = llvm.add %116, %117 : i64
    %119 = llvm.inttoptr %118 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%115, %119, %45, %46) : (<6>, <1>, i64, i64)
    %120 = llvm.ptrtoint %arg4 : !llvm.ptr<1> to i64
    %121 = llvm.inttoptr %120 : i64 to !llvm.ptr<1>
    %122 = llvm.mul %64, %53 : i64
    %123 = llvm.add %122, %96 : i64
    %124 = llvm.getelementptr %121[%123] : (!llvm.ptr<1>, i64) -> !llvm.ptr<1>, i32
    %125 = llvm.load %124 : !llvm.ptr<1> -> i32
    %126 = llvm.mul %125, %34 : i32
    %127 = llvm.sext %126 : i32 to i64
    %128 = llvm.mul %127, %32 : i64
    %129 = llvm.add %128, %66 : i64
    %130 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %131 = llvm.ptrtoint %arg2 : !llvm.ptr<1> to i64
    %132 = llvm.mul %129, %50 : i64
    %133 = llvm.add %131, %132 : i64
    %134 = llvm.inttoptr %133 : i64 to !llvm.ptr<1>
    cce.intr.mov.out.to.ub.align.v2.f16.dv(%130, %134, %45, %46) : (<6>, <1>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb51(%1 : i32)
  ^bb16(%135: i64):  // 2 preds: ^bb17, ^bb63
    %136 = llvm.icmp "slt" %135, %28 : i64
    llvm.cond_br %136, ^bb17, ^bb18
  ^bb17:  // pred: ^bb16
    %137 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %138 = llvm.load %137 : !llvm.ptr<6> -> f32
    %139 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %140 = llvm.mul %135, %52 : i64
    %141 = llvm.getelementptr %139[%140] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %142 = llvm.load %141 : !llvm.ptr<6> -> f32
    %143 = llvm.fcmp "olt" %138, %142 : f32
    %144 = llvm.select %143, %142, %138 : i1, f32
    %145 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    llvm.store %144, %145 : f32, !llvm.ptr<6>
    %146 = llvm.add %135, %31 : i64
    llvm.br ^bb16(%146 : i64)
  ^bb18:  // pred: ^bb16
    %147 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    %148 = llvm.load %147 : !llvm.ptr<6> -> f32
    %149 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %150 = llvm.load %149 : !llvm.ptr<6> -> f32
    %151 = llvm.fcmp "olt" %148, %150 : f32
    %152 = llvm.select %151, %150, %148 : i1, f32
    %153 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    llvm.store %152, %153 : f32, !llvm.ptr<6>
    llvm.br ^bb19(%30 : i64)
  ^bb19(%154: i64):  // 2 preds: ^bb18, ^bb20
    %155 = llvm.icmp "slt" %154, %26 : i64
    llvm.cond_br %155, ^bb20, ^bb21
  ^bb20:  // pred: ^bb19
    %156 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    %157 = llvm.load %156 : !llvm.ptr<6> -> f32
    %158 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %159 = llvm.mul %154, %52 : i64
    %160 = llvm.getelementptr %158[%159] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %157, %160 : f32, !llvm.ptr<6>
    %161 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %162 = llvm.load %161 : !llvm.ptr<6> -> f32
    %163 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    %164 = llvm.mul %154, %52 : i64
    %165 = llvm.getelementptr %163[%164] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %162, %165 : f32, !llvm.ptr<6>
    %166 = llvm.add %154, %31 : i64
    llvm.br ^bb19(%166 : i64)
  ^bb21:  // pred: ^bb19
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb64(%1 : i32)
  ^bb22(%167: i64):  // 2 preds: ^bb23, ^bb67
    %168 = llvm.icmp "slt" %167, %28 : i64
    llvm.cond_br %168, ^bb23, ^bb24
  ^bb23:  // pred: ^bb22
    %169 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %170 = llvm.load %169 : !llvm.ptr<6> -> f32
    %171 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    %172 = llvm.mul %167, %52 : i64
    %173 = llvm.getelementptr %171[%172] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %170, %173 : f32, !llvm.ptr<6>
    %174 = llvm.add %167, %31 : i64
    llvm.br ^bb22(%174 : i64)
  ^bb24:  // pred: ^bb22
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb68(%1 : i32)
  ^bb25(%175: i64):  // 2 preds: ^bb26, ^bb71
    %176 = llvm.icmp "slt" %175, %28 : i64
    llvm.cond_br %176, ^bb26, ^bb27
  ^bb26:  // pred: ^bb25
    %177 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %178 = llvm.load %177 : !llvm.ptr<6> -> f32
    %179 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %180 = llvm.mul %175, %52 : i64
    %181 = llvm.getelementptr %179[%180] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %182 = llvm.load %181 : !llvm.ptr<6> -> f32
    %183 = llvm.fadd %178, %182 : f32
    %184 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    llvm.store %183, %184 : f32, !llvm.ptr<6>
    %185 = llvm.add %175, %31 : i64
    llvm.br ^bb25(%185 : i64)
  ^bb27:  // pred: ^bb25
    %186 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %187 = llvm.load %186 : !llvm.ptr<6> -> f32
    %188 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %189 = llvm.load %188 : !llvm.ptr<6> -> f32
    %190 = llvm.fmul %187, %189 : f32
    %191 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    %192 = llvm.load %191 : !llvm.ptr<6> -> f32
    %193 = llvm.fadd %190, %192 : f32
    %194 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    llvm.store %193, %194 : f32, !llvm.ptr<6>
    llvm.br ^bb28(%30 : i64)
  ^bb28(%195: i64):  // 2 preds: ^bb27, ^bb29
    %196 = llvm.icmp "slt" %195, %33 : i64
    llvm.cond_br %196, ^bb29, ^bb30
  ^bb29:  // pred: ^bb28
    %197 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    %198 = llvm.load %197 : !llvm.ptr<6> -> f32
    %199 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %200 = llvm.mul %195, %52 : i64
    %201 = llvm.getelementptr %199[%200] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %198, %201 : f32, !llvm.ptr<6>
    %202 = llvm.add %195, %31 : i64
    llvm.br ^bb28(%202 : i64)
  ^bb30:  // pred: ^bb28
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID1>
    llvm.br ^bb72(%1 : i32)
  ^bb31(%203: i64):  // 2 preds: ^bb35, ^bb78
    %204 = llvm.icmp "slt" %203, %28 : i64
    llvm.cond_br %204, ^bb32, ^bb36
  ^bb32:  // pred: ^bb31
    llvm.br ^bb33(%30 : i64)
  ^bb33(%205: i64):  // 2 preds: ^bb32, ^bb34
    %206 = llvm.icmp "slt" %205, %33 : i64
    llvm.cond_br %206, ^bb34, ^bb35
  ^bb34:  // pred: ^bb33
    %207 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %208 = llvm.mul %205, %52 : i64
    %209 = llvm.getelementptr %207[%208] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %210 = llvm.load %209 : !llvm.ptr<6> -> f32
    %211 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %212 = llvm.mul %203, %52 : i64
    %213 = llvm.getelementptr %211[%212] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %214 = llvm.load %213 : !llvm.ptr<6> -> f32
    %215 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %216 = llvm.mul %203, %51 : i64
    %217 = llvm.add %216, %205 : i64
    %218 = llvm.mul %217, %52 : i64
    %219 = llvm.getelementptr %215[%218] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %220 = llvm.load %219 : !llvm.ptr<6> -> f32
    %221 = llvm.fmul %214, %220 : f32
    %222 = llvm.fadd %210, %221 : f32
    %223 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %224 = llvm.mul %205, %52 : i64
    %225 = llvm.getelementptr %223[%224] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %222, %225 : f32, !llvm.ptr<6>
    %226 = llvm.add %205, %31 : i64
    llvm.br ^bb33(%226 : i64)
  ^bb35:  // pred: ^bb33
    %227 = llvm.add %203, %31 : i64
    llvm.br ^bb31(%227 : i64)
  ^bb36:  // pred: ^bb31
    llvm.br ^bb37
  ^bb37:  // 2 preds: ^bb14, ^bb36
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    %228 = llvm.add %96, %31 : i64
    llvm.br ^bb13(%228 : i64)
  ^bb38:  // pred: ^bb13
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    llvm.br ^bb39(%30 : i64)
  ^bb39(%229: i64):  // 2 preds: ^bb38, ^bb40
    %230 = llvm.icmp "slt" %229, %33 : i64
    llvm.cond_br %230, ^bb40, ^bb41
  ^bb40:  // pred: ^bb39
    %231 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %232 = llvm.mul %229, %52 : i64
    %233 = llvm.getelementptr %231[%232] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %234 = llvm.load %233 : !llvm.ptr<6> -> f32
    %235 = llvm.inttoptr %20 : i64 to !llvm.ptr<6>
    %236 = llvm.load %235 : !llvm.ptr<6> -> f32
    %237 = llvm.fdiv %234, %236 : f32
    %238 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %239 = llvm.mul %229, %52 : i64
    %240 = llvm.getelementptr %238[%239] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    llvm.store %237, %240 : f32, !llvm.ptr<6>
    %241 = llvm.add %229, %31 : i64
    llvm.br ^bb39(%241 : i64)
  ^bb41:  // pred: ^bb39
    cce.set_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    llvm.br ^bb79(%1 : i32)
  ^bb42:  // pred: ^bb2
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID2>
    cce.wait_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_S> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %4
    cce.barrier pipe = <PIPE_ALL>
    llvm.br ^bb43
  ^bb43:  // 2 preds: ^bb0, ^bb42
    llvm.return
  ^bb44(%242: i32):  // 2 preds: ^bb9, ^bb49
    %243 = llvm.icmp "sle" %242, %1 : i32
    llvm.cond_br %243, ^bb45, ^bb50
  ^bb45:  // pred: ^bb44
    %244 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %245 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb46(%30 : i64)
  ^bb46(%246: i64):  // 2 preds: ^bb45, ^bb47
    %247 = llvm.icmp "slt" %246, %28 : i64
    llvm.cond_br %247, ^bb47, ^bb48
  ^bb47:  // pred: ^bb46
    %248 = llvm.trunc %246 : i64 to i32
    %249 = llvm.mul %248, %42 : i32
    %250 = llvm.mul %248, %43 : i32
    %251 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %252 = llvm.sext %249 : i32 to i64
    %253 = llvm.getelementptr %251[%252] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %254 = cce.intr.vldsx1.bf16(%253, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %255 = cce.vcvtff.ext(%254, %244, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %256 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %257 = llvm.sext %250 : i32 to i64
    %258 = llvm.getelementptr %256[%257] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%255, %258, %1, %39, %1, %245) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %259 = llvm.add %249, %44 : i32
    %260 = llvm.add %250, %42 : i32
    %261 = llvm.inttoptr %6 : i64 to !llvm.ptr<6>
    %262 = llvm.sext %259 : i32 to i64
    %263 = llvm.getelementptr %261[%262] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %264 = cce.intr.vldsx1.bf16(%263, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %265 = cce.vcvtff.ext(%264, %244, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %266 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %267 = llvm.sext %260 : i32 to i64
    %268 = llvm.getelementptr %266[%267] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%265, %268, %1, %39, %1, %245) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %269 = llvm.add %246, %31 : i64
    llvm.br ^bb46(%269 : i64)
  ^bb48:  // pred: ^bb46
    llvm.br ^bb49
  ^bb49:  // pred: ^bb48
    %270 = llvm.add %242, %0 : i32
    llvm.br ^bb44(%270 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb50:  // pred: ^bb44
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID2>
    llvm.br ^bb10(%30 : i64)
  ^bb51(%271: i32):  // 2 preds: ^bb15, ^bb62
    %272 = llvm.icmp "sle" %271, %1 : i32
    llvm.cond_br %272, ^bb52, ^bb63
  ^bb52:  // pred: ^bb51
    %273 = cce.pset(%1) {mask_bitwidth = 16 : i32} : (i32) -> vector<256xi1>
    %274 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb53(%30 : i64)
  ^bb53(%275: i64):  // 2 preds: ^bb52, ^bb54
    %276 = llvm.icmp "slt" %275, %28 : i64
    llvm.cond_br %276, ^bb54, ^bb55
  ^bb54:  // pred: ^bb53
    %277 = llvm.trunc %275 : i64 to i32
    %278 = llvm.mul %277, %42 : i32
    %279 = llvm.mul %277, %43 : i32
    %280 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %281 = llvm.sext %278 : i32 to i64
    %282 = llvm.getelementptr %280[%281] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %283 = cce.intr.vldsx1.bf16(%282, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %284 = cce.vcvtff.ext(%283, %273, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %285 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %286 = llvm.sext %279 : i32 to i64
    %287 = llvm.getelementptr %285[%286] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%284, %287, %1, %39, %1, %274) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %288 = llvm.add %278, %44 : i32
    %289 = llvm.add %279, %42 : i32
    %290 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %291 = llvm.sext %288 : i32 to i64
    %292 = llvm.getelementptr %290[%291] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %293 = cce.intr.vldsx1.bf16(%292, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %294 = cce.vcvtff.ext(%293, %273, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %295 = llvm.inttoptr %10 : i64 to !llvm.ptr<6>
    %296 = llvm.sext %289 : i32 to i64
    %297 = llvm.getelementptr %295[%296] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%294, %297, %1, %39, %1, %274) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %298 = llvm.add %275, %31 : i64
    llvm.br ^bb53(%298 : i64)
  ^bb55:  // pred: ^bb53
    llvm.br ^bb56(%30 : i64)
  ^bb56(%299: i64):  // 2 preds: ^bb55, ^bb57
    %300 = llvm.icmp "slt" %299, %28 : i64
    llvm.cond_br %300, ^bb57, ^bb58
  ^bb57:  // pred: ^bb56
    %301 = llvm.trunc %299 : i64 to i32
    %302 = llvm.mul %301, %42 : i32
    %303 = llvm.mul %301, %43 : i32
    %304 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %305 = llvm.sext %302 : i32 to i64
    %306 = llvm.getelementptr %304[%305] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %307 = cce.intr.vldsx1.bf16(%306, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %308 = cce.vcvtff.ext(%307, %273, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %309 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %310 = llvm.sext %303 : i32 to i64
    %311 = llvm.getelementptr %309[%310] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%308, %311, %1, %39, %1, %274) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %312 = llvm.add %302, %44 : i32
    %313 = llvm.add %303, %42 : i32
    %314 = llvm.inttoptr %8 : i64 to !llvm.ptr<6>
    %315 = llvm.sext %312 : i32 to i64
    %316 = llvm.getelementptr %314[%315] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %317 = cce.intr.vldsx1.bf16(%316, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %318 = cce.vcvtff.ext(%317, %273, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %319 = llvm.inttoptr %11 : i64 to !llvm.ptr<6>
    %320 = llvm.sext %313 : i32 to i64
    %321 = llvm.getelementptr %319[%320] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%318, %321, %1, %39, %1, %274) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %322 = llvm.add %299, %31 : i64
    llvm.br ^bb56(%322 : i64)
  ^bb58:  // pred: ^bb56
    %323 = cce.pset(%39) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb59(%30 : i64)
  ^bb59(%324: i64):  // 2 preds: ^bb58, ^bb60
    %325 = llvm.icmp "slt" %324, %28 : i64
    llvm.cond_br %325, ^bb60, ^bb61
  ^bb60:  // pred: ^bb59
    %326 = llvm.trunc %324 : i64 to i32
    %327 = llvm.mul %326, %44 : i32
    %328 = llvm.mul %326, %43 : i32
    %329 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %330 = llvm.sext %328 : i32 to i64
    %331 = llvm.getelementptr %329[%330] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %332 = cce.intr.vldsx1.f32(%331, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %333 = llvm.mul %326, %42 : i32
    %334 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %335 = llvm.sext %333 : i32 to i64
    %336 = llvm.getelementptr %334[%335] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %337 = cce.intr.vldsx1.bf16(%336, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %338 = cce.vcvtff.ext(%337, %273, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %339 = cce.vmul(%332, %338, %274) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %340 = llvm.add %327, %47 : i32
    %341 = llvm.mul %340, %40 : i32
    %342 = llvm.inttoptr %4 : i64 to !llvm.ptr<6>
    %343 = llvm.sext %341 : i32 to i64
    %344 = llvm.getelementptr %342[%343] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %345 = cce.intr.vldsx1.f32(%344, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %346 = llvm.mul %340, %39 : i32
    %347 = llvm.inttoptr %7 : i64 to !llvm.ptr<6>
    %348 = llvm.sext %346 : i32 to i64
    %349 = llvm.getelementptr %347[%348] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %350 = cce.intr.vldsx1.bf16(%349, %1, %41, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<128xbf16>
    %351 = cce.vcvtff.ext(%350, %273, %1) : (vector<128xbf16>, vector<256xi1>, i32) -> vector<64xf32>
    %352 = cce.vmul(%345, %351, %274) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %353 = cce.vadd(%339, %352, %274) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %354 = cce.vcadd(%353, %274) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %355 = llvm.mul %326, %40 : i32
    %356 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %357 = llvm.sext %355 : i32 to i64
    %358 = llvm.getelementptr %356[%357] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%354, %358, %1, %48, %1, %323) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %359 = llvm.add %324, %31 : i64
    llvm.br ^bb59(%359 : i64)
  ^bb61:  // pred: ^bb59
    llvm.br ^bb62
  ^bb62:  // pred: ^bb61
    %360 = llvm.add %271, %0 : i32
    llvm.br ^bb51(%360 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb63:  // pred: ^bb51
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE2> pipeID = <EVENT_ID0>
    %361 = llvm.inttoptr %17 : i64 to !llvm.ptr<6>
    llvm.store %36, %361 : f32, !llvm.ptr<6>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    llvm.br ^bb16(%30 : i64)
  ^bb64(%362: i32):  // 2 preds: ^bb21, ^bb66
    %363 = llvm.icmp "sle" %362, %1 : i32
    llvm.cond_br %363, ^bb65, ^bb67
  ^bb65:  // pred: ^bb64
    %364 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    %365 = llvm.inttoptr %23 : i64 to !llvm.ptr<6>
    %366 = cce.intr.vldsx1.f32(%365, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %367 = llvm.inttoptr %24 : i64 to !llvm.ptr<6>
    %368 = cce.intr.vldsx1.f32(%367, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %369 = cce.vsub(%366, %368, %364) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %370 = cce.vexp(%369, %364) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %371 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    cce.intr.vstsx1.f32(%370, %371, %1, %39, %1, %364) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    llvm.br ^bb66
  ^bb66:  // pred: ^bb65
    %372 = llvm.add %362, %0 : i32
    llvm.br ^bb64(%372 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb67:  // pred: ^bb64
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    %373 = llvm.inttoptr %25 : i64 to !llvm.ptr<6>
    %374 = llvm.load %373 : !llvm.ptr<6> -> f32
    %375 = llvm.inttoptr %22 : i64 to !llvm.ptr<6>
    llvm.store %374, %375 : f32, !llvm.ptr<6>
    %376 = llvm.inttoptr %18 : i64 to !llvm.ptr<6>
    %377 = llvm.load %376 : !llvm.ptr<6> -> f32
    %378 = llvm.inttoptr %19 : i64 to !llvm.ptr<6>
    llvm.store %377, %378 : f32, !llvm.ptr<6>
    llvm.br ^bb22(%30 : i64)
  ^bb68(%379: i32):  // 2 preds: ^bb24, ^bb70
    %380 = llvm.icmp "sle" %379, %1 : i32
    llvm.cond_br %380, ^bb69, ^bb71
  ^bb69:  // pred: ^bb68
    %dst, %restElem = cce.plt(%34) {mask_bitwidth = 32 : i32} : (i32) -> (vector<256xi1>, i32)
    %381 = cce.vci(%1, %1) : (i32, i32) -> vector<64xi32>
    %382 = llvm.inttoptr %12 : i64 to !llvm.ptr<6>
    %383 = cce.intr.vgather2.f32(%382, %381, %dst) : (!llvm.ptr<6>, vector<64xi32>, vector<256xi1>) -> vector<64xf32>
    %384 = llvm.inttoptr %14 : i64 to !llvm.ptr<6>
    %385 = cce.intr.vgather2.f32(%384, %381, %dst) : (!llvm.ptr<6>, vector<64xi32>, vector<256xi1>) -> vector<64xf32>
    %386 = cce.vsub(%383, %385, %dst) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %387 = cce.vexp(%386, %dst) : (vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %388 = cce.intr.init_align : vector<32xi8>
    %389 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    %390 = cce.intr.vstus(%387, %389, %47, %388) : (vector<64xf32>, !llvm.ptr<6>, i32, vector<32xi8>) -> vector<32xi8>
    %391 = llvm.inttoptr %13 : i64 to !llvm.ptr<6>
    cce.intr.vstas(%390, %391, %47, %1) : (vector<32xi8>, !llvm.ptr<6>, i32, i32) -> ()
    llvm.br ^bb70
  ^bb70:  // pred: ^bb69
    %392 = llvm.add %379, %0 : i32
    llvm.br ^bb68(%392 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb71:  // pred: ^bb68
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    %393 = llvm.inttoptr %21 : i64 to !llvm.ptr<6>
    llvm.store %35, %393 : f32, !llvm.ptr<6>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    llvm.br ^bb25(%30 : i64)
  ^bb72(%394: i32):  // 2 preds: ^bb30, ^bb77
    %395 = llvm.icmp "sle" %394, %1 : i32
    llvm.cond_br %395, ^bb73, ^bb78
  ^bb73:  // pred: ^bb72
    %396 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb74(%30 : i64)
  ^bb74(%397: i64):  // 2 preds: ^bb73, ^bb75
    %398 = llvm.icmp "slt" %397, %29 : i64
    llvm.cond_br %398, ^bb75, ^bb76
  ^bb75:  // pred: ^bb74
    %399 = llvm.mul %397, %26 : i64
    %400 = llvm.trunc %399 : i64 to i32
    %401 = llvm.mul %400, %40 : i32
    %402 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %403 = llvm.sext %401 : i32 to i64
    %404 = llvm.getelementptr %402[%403] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %405 = cce.intr.vldsx1.f32(%404, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %406 = llvm.inttoptr %16 : i64 to !llvm.ptr<6>
    %407 = llvm.sext %401 : i32 to i64
    %408 = llvm.getelementptr %406[%407] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %409 = cce.intr.vldsx1.f32(%408, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %410 = cce.vmul(%405, %409, %396) : (vector<64xf32>, vector<64xf32>, vector<256xi1>) -> vector<64xf32>
    %411 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %412 = llvm.sext %401 : i32 to i64
    %413 = llvm.getelementptr %411[%412] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vstsx1.f32(%410, %413, %1, %39, %1, %396) : (vector<64xf32>, <6>, i32, i32, i32, vector<256xi1>)
    %414 = llvm.add %397, %31 : i64
    llvm.br ^bb74(%414 : i64)
  ^bb76:  // pred: ^bb74
    llvm.br ^bb77
  ^bb77:  // pred: ^bb76
    %415 = llvm.add %394, %0 : i32
    llvm.br ^bb72(%415 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb78:  // pred: ^bb72
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID3>
    llvm.br ^bb31(%30 : i64)
  ^bb79(%416: i32):  // 2 preds: ^bb41, ^bb84
    %417 = llvm.icmp "sle" %416, %1 : i32
    llvm.cond_br %417, ^bb80, ^bb85
  ^bb80:  // pred: ^bb79
    %418 = cce.pset(%1) {mask_bitwidth = 32 : i32} : (i32) -> vector<256xi1>
    llvm.br ^bb81(%30 : i64)
  ^bb81(%419: i64):  // 2 preds: ^bb80, ^bb82
    %420 = llvm.icmp "slt" %419, %29 : i64
    llvm.cond_br %420, ^bb82, ^bb83
  ^bb82:  // pred: ^bb81
    %421 = llvm.trunc %419 : i64 to i32
    %422 = llvm.udiv %421, %39 : i32
    %423 = llvm.urem %421, %39 : i32
    %424 = llvm.mul %423, %47 : i32
    %425 = llvm.mul %422, %44 : i32
    %426 = llvm.add %425, %424 : i32
    %427 = llvm.mul %426, %40 : i32
    %428 = llvm.inttoptr %15 : i64 to !llvm.ptr<6>
    %429 = llvm.sext %427 : i32 to i64
    %430 = llvm.getelementptr %428[%429] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    %431 = cce.intr.vldsx1.f32(%430, %1, %1, %1) : (!llvm.ptr<6>, i32, i32, i32) -> vector<64xf32>
    %432 = cce.vcvtff.trunc(%431, %418, %1, %1, %1) : (vector<64xf32>, vector<256xi1>, i32, i32, i32) -> vector<128xbf16>
    %433 = llvm.mul %426, %39 : i32
    %434 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    %435 = llvm.sext %433 : i32 to i64
    %436 = llvm.getelementptr %434[%435] : (!llvm.ptr<6>, i64) -> !llvm.ptr<6>, i8
    cce.intr.vsstb.bf16(%432, %436, %49, %1, %418) : (vector<128xbf16>, <6>, i32, i32, vector<256xi1>)
    %437 = llvm.add %419, %31 : i64
    llvm.br ^bb81(%437 : i64)
  ^bb83:  // pred: ^bb81
    llvm.br ^bb84
  ^bb84:  // pred: ^bb83
    %438 = llvm.add %416, %0 : i32
    llvm.br ^bb79(%438 : i32) {cce.vec_scope = #cce.vec_scope}
  ^bb85:  // pred: ^bb79
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_S> pipeID = <EVENT_ID2>
    cce.set_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_V> tpipe = <PIPE_MTE3> pipeID = <EVENT_ID0>
    %439 = llvm.ptrtoint %arg5 : !llvm.ptr<1> to i64
    %440 = llvm.mul %67, %50 : i64
    %441 = llvm.add %439, %440 : i64
    %442 = llvm.inttoptr %441 : i64 to !llvm.ptr<1>
    %443 = llvm.inttoptr %9 : i64 to !llvm.ptr<6>
    cce.intr.mov.ub.to.out.align.v2.dv(%442, %443, %37, %38) : (<1>, <6>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE3> tpipe = <PIPE_V> pipeID = <EVENT_ID0>
    %444 = llvm.add %62, %31 : i64
    llvm.br ^bb2(%444 : i64)
  }
}


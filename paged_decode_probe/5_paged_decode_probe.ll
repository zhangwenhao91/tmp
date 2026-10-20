; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @paged_decode_probe_kernel_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, ptr addrspace(1) %5, i32 %6) #0 {
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET0(i64 %8, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.CTRL()
  %11 = call i64 @llvm.hivm.SBITSET1(i64 %10, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %11)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 0)
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

define dso_local ptc_kernel void @paged_decode_probe_kernel_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, ptr addrspace(1) %5, i32 %6) #1 {
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET0(i64 %8, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  %10 = call i64 @llvm.hivm.GET.CTRL()
  %11 = call i64 @llvm.hivm.SBITSET1(i64 %10, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %11)
  %12 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %14, label %202

14:                                               ; preds = %7
  %15 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %16 = trunc i64 %15 to i32
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 4, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 2)
  br label %17

17:                                               ; preds = %410, %14
  %18 = phi i64 [ %415, %410 ], [ 0, %14 ]
  %19 = icmp slt i64 %18, 2
  br i1 %19, label %20, label %201

20:                                               ; preds = %17
  %21 = sext i32 %16 to i64
  %22 = mul i64 %21, 256
  %23 = mul i64 %18, 128
  %24 = add i64 %22, %23
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 4, i64 0)
  %25 = ptrtoint ptr addrspace(1) %0 to i64
  %26 = mul i64 %24, 2
  %27 = add i64 %25, %26
  %28 = inttoptr i64 %27 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) inttoptr (i64 37888 to ptr addrspace(6)), ptr addrspace(1) %28, i64 288230377225453696, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 0, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 0, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 0)
  br label %29

29:                                               ; preds = %45, %20
  %30 = phi i64 [ %46, %45 ], [ 0, %20 ]
  %31 = icmp slt i64 %30, 16
  br i1 %31, label %32, label %47

32:                                               ; preds = %29
  br label %33

33:                                               ; preds = %36, %32
  %34 = phi i64 [ %44, %36 ], [ 0, %32 ]
  %35 = icmp slt i64 %34, 128
  br i1 %35, label %36, label %45

36:                                               ; preds = %33
  %37 = mul i64 %34, 2
  %38 = getelementptr i8, ptr addrspace(6) inttoptr (i64 37888 to ptr addrspace(6)), i64 %37
  %39 = load bfloat, ptr addrspace(6) %38, align 2
  %40 = mul i64 %30, 128
  %41 = add i64 %40, %34
  %42 = mul i64 %41, 2
  %43 = getelementptr i8, ptr addrspace(6) inttoptr (i64 24576 to ptr addrspace(6)), i64 %42
  store bfloat %39, ptr addrspace(6) %43, align 2
  %44 = add i64 %34, 1
  br label %33

45:                                               ; preds = %33
  %46 = add i64 %30, 1
  br label %29

47:                                               ; preds = %29
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 0)
  br label %203

48:                                               ; preds = %51, %234
  %49 = phi i64 [ 0, %234 ], [ %54, %51 ]
  %50 = icmp slt i64 %49, 128
  br i1 %50, label %51, label %55

51:                                               ; preds = %48
  %52 = mul i64 %49, 4
  %53 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %52
  store float 0.000000e+00, ptr addrspace(6) %53, align 4
  %54 = add i64 %49, 1
  br label %48

55:                                               ; preds = %48
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 1)
  store float 0xC7D2CED320000000, ptr addrspace(6) inttoptr (i64 39424 to ptr addrspace(6)), align 4
  store float 0.000000e+00, ptr addrspace(6) inttoptr (i64 39456 to ptr addrspace(6)), align 4
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 1)
  br label %56

56:                                               ; preds = %185, %55
  %57 = phi i64 [ %186, %185 ], [ 0, %55 ]
  %58 = icmp slt i64 %57, 8
  br i1 %58, label %59, label %187

59:                                               ; preds = %56
  %60 = mul i64 %57, 16
  %61 = ptrtoint ptr addrspace(1) %3 to i64
  %62 = inttoptr i64 %61 to ptr addrspace(1)
  %63 = getelementptr i32, ptr addrspace(1) %62, i64 %21
  %64 = load i32, ptr addrspace(1) %63, align 4
  %65 = sext i32 %64 to i64
  %66 = icmp slt i64 %60, %65
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 1)
  br i1 %66, label %67, label %185

67:                                               ; preds = %59
  %68 = ptrtoint ptr addrspace(1) %4 to i64
  %69 = inttoptr i64 %68 to ptr addrspace(1)
  %70 = mul i64 %21, 8
  %71 = add i64 %70, %57
  %72 = getelementptr i32, ptr addrspace(1) %69, i64 %71
  %73 = load i32, ptr addrspace(1) %72, align 4
  %74 = mul i32 %73, 16
  %75 = sext i32 %74 to i64
  %76 = mul i64 %75, 256
  %77 = add i64 %76, %23
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  %78 = ptrtoint ptr addrspace(1) %1 to i64
  %79 = mul i64 %77, 2
  %80 = add i64 %78, %79
  %81 = inttoptr i64 %80 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) inttoptr (i64 28672 to ptr addrspace(6)), ptr addrspace(1) %81, i64 288230384741646592, i64 281474976711168)
  %82 = ptrtoint ptr addrspace(1) %4 to i64
  %83 = inttoptr i64 %82 to ptr addrspace(1)
  %84 = mul i64 %21, 8
  %85 = add i64 %84, %57
  %86 = getelementptr i32, ptr addrspace(1) %83, i64 %85
  %87 = load i32, ptr addrspace(1) %86, align 4
  %88 = mul i32 %87, 16
  %89 = sext i32 %88 to i64
  %90 = mul i64 %89, 256
  %91 = add i64 %90, %23
  %92 = ptrtoint ptr addrspace(1) %2 to i64
  %93 = mul i64 %91, 2
  %94 = add i64 %92, %93
  %95 = inttoptr i64 %94 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), ptr addrspace(1) %95, i64 288230384741646592, i64 281474976711168)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %235

96:                                               ; preds = %99, %324
  %97 = phi i64 [ 0, %324 ], [ %106, %99 ]
  %98 = icmp slt i64 %97, 16
  br i1 %98, label %99, label %107

99:                                               ; preds = %96
  %100 = load float, ptr addrspace(6) inttoptr (i64 39360 to ptr addrspace(6)), align 4
  %101 = mul i64 %97, 4
  %102 = getelementptr i8, ptr addrspace(6) inttoptr (i64 39168 to ptr addrspace(6)), i64 %101
  %103 = load float, ptr addrspace(6) %102, align 4
  %104 = fcmp olt float %100, %103
  %105 = select i1 %104, float %103, float %100
  store float %105, ptr addrspace(6) inttoptr (i64 39360 to ptr addrspace(6)), align 4
  %106 = add i64 %97, 1
  br label %96

107:                                              ; preds = %96
  %108 = load float, ptr addrspace(6) inttoptr (i64 39360 to ptr addrspace(6)), align 4
  %109 = load float, ptr addrspace(6) inttoptr (i64 39424 to ptr addrspace(6)), align 4
  %110 = fcmp olt float %108, %109
  %111 = select i1 %110, float %109, float %108
  store float %111, ptr addrspace(6) inttoptr (i64 39392 to ptr addrspace(6)), align 4
  br label %112

112:                                              ; preds = %115, %107
  %113 = phi i64 [ %122, %115 ], [ 0, %107 ]
  %114 = icmp slt i64 %113, 64
  br i1 %114, label %115, label %123

115:                                              ; preds = %112
  %116 = load float, ptr addrspace(6) inttoptr (i64 39424 to ptr addrspace(6)), align 4
  %117 = mul i64 %113, 4
  %118 = getelementptr i8, ptr addrspace(6) inttoptr (i64 38400 to ptr addrspace(6)), i64 %117
  store float %116, ptr addrspace(6) %118, align 4
  %119 = load float, ptr addrspace(6) inttoptr (i64 39392 to ptr addrspace(6)), align 4
  %120 = mul i64 %113, 4
  %121 = getelementptr i8, ptr addrspace(6) inttoptr (i64 38656 to ptr addrspace(6)), i64 %120
  store float %119, ptr addrspace(6) %121, align 4
  %122 = add i64 %113, 1
  br label %112

123:                                              ; preds = %112
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 1)
  br label %325

124:                                              ; preds = %127, %336
  %125 = phi i64 [ 0, %336 ], [ %131, %127 ]
  %126 = icmp slt i64 %125, 16
  br i1 %126, label %127, label %132

127:                                              ; preds = %124
  %128 = load float, ptr addrspace(6) inttoptr (i64 39392 to ptr addrspace(6)), align 4
  %129 = mul i64 %125, 4
  %130 = getelementptr i8, ptr addrspace(6) inttoptr (i64 39296 to ptr addrspace(6)), i64 %129
  store float %128, ptr addrspace(6) %130, align 4
  %131 = add i64 %125, 1
  br label %124

132:                                              ; preds = %124
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 1)
  br label %339

133:                                              ; preds = %136, %356
  %134 = phi i64 [ 0, %356 ], [ %142, %136 ]
  %135 = icmp slt i64 %134, 16
  br i1 %135, label %136, label %143

136:                                              ; preds = %133
  %137 = load float, ptr addrspace(6) inttoptr (i64 39488 to ptr addrspace(6)), align 4
  %138 = mul i64 %134, 4
  %139 = getelementptr i8, ptr addrspace(6) inttoptr (i64 39232 to ptr addrspace(6)), i64 %138
  %140 = load float, ptr addrspace(6) %139, align 4
  %141 = fadd float %137, %140
  store float %141, ptr addrspace(6) inttoptr (i64 39488 to ptr addrspace(6)), align 4
  %142 = add i64 %134, 1
  br label %133

143:                                              ; preds = %133
  %144 = load float, ptr addrspace(6) inttoptr (i64 39456 to ptr addrspace(6)), align 4
  %145 = load float, ptr addrspace(6) inttoptr (i64 39520 to ptr addrspace(6)), align 4
  %146 = fmul float %144, %145
  %147 = load float, ptr addrspace(6) inttoptr (i64 39488 to ptr addrspace(6)), align 4
  %148 = fadd float %146, %147
  store float %148, ptr addrspace(6) inttoptr (i64 39456 to ptr addrspace(6)), align 4
  br label %149

149:                                              ; preds = %152, %143
  %150 = phi i64 [ %156, %152 ], [ 0, %143 ]
  %151 = icmp slt i64 %150, 128
  br i1 %151, label %152, label %157

152:                                              ; preds = %149
  %153 = load float, ptr addrspace(6) inttoptr (i64 39520 to ptr addrspace(6)), align 4
  %154 = mul i64 %150, 4
  %155 = getelementptr i8, ptr addrspace(6) inttoptr (i64 37376 to ptr addrspace(6)), i64 %154
  store float %153, ptr addrspace(6) %155, align 4
  %156 = add i64 %150, 1
  br label %149

157:                                              ; preds = %149
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 1)
  br label %357

158:                                              ; preds = %182, %382
  %159 = phi i64 [ 0, %382 ], [ %183, %182 ]
  %160 = icmp slt i64 %159, 16
  br i1 %160, label %161, label %184

161:                                              ; preds = %158
  br label %162

162:                                              ; preds = %165, %161
  %163 = phi i64 [ %181, %165 ], [ 0, %161 ]
  %164 = icmp slt i64 %163, 128
  br i1 %164, label %165, label %182

165:                                              ; preds = %162
  %166 = mul i64 %163, 4
  %167 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %166
  %168 = load float, ptr addrspace(6) %167, align 4
  %169 = mul i64 %159, 4
  %170 = getelementptr i8, ptr addrspace(6) inttoptr (i64 39232 to ptr addrspace(6)), i64 %169
  %171 = load float, ptr addrspace(6) %170, align 4
  %172 = mul i64 %159, 128
  %173 = add i64 %172, %163
  %174 = mul i64 %173, 4
  %175 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %174
  %176 = load float, ptr addrspace(6) %175, align 4
  %177 = fmul float %171, %176
  %178 = fadd float %168, %177
  %179 = mul i64 %163, 4
  %180 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %179
  store float %178, ptr addrspace(6) %180, align 4
  %181 = add i64 %163, 1
  br label %162

182:                                              ; preds = %162
  %183 = add i64 %159, 1
  br label %158

184:                                              ; preds = %158
  br label %185

185:                                              ; preds = %184, %59
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 0)
  %186 = add i64 %57, 1
  br label %56

187:                                              ; preds = %56
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 3)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 3)
  br label %188

188:                                              ; preds = %191, %187
  %189 = phi i64 [ %199, %191 ], [ 0, %187 ]
  %190 = icmp slt i64 %189, 128
  br i1 %190, label %191, label %200

191:                                              ; preds = %188
  %192 = mul i64 %189, 4
  %193 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %192
  %194 = load float, ptr addrspace(6) %193, align 4
  %195 = load float, ptr addrspace(6) inttoptr (i64 39456 to ptr addrspace(6)), align 4
  %196 = fdiv float %194, %195
  %197 = mul i64 %189, 4
  %198 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %197
  store float %196, ptr addrspace(6) %198, align 4
  %199 = add i64 %189, 1
  br label %188

200:                                              ; preds = %188
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %383

201:                                              ; preds = %17
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 2)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 4, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %202

202:                                              ; preds = %201, %7
  ret void

203:                                              ; preds = %232, %47
  %204 = phi i32 [ %233, %232 ], [ 0, %47 ]
  %205 = icmp sle i32 %204, 0
  br i1 %205, label %206, label %234

206:                                              ; preds = %203
  %207 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  %208 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %209

209:                                              ; preds = %212, %206
  %210 = phi i64 [ %230, %212 ], [ 0, %206 ]
  %211 = icmp slt i64 %210, 16
  br i1 %211, label %212, label %231

212:                                              ; preds = %209
  %213 = trunc i64 %210 to i32
  %214 = mul i32 %213, 256
  %215 = mul i32 %213, 512
  %216 = sext i32 %214 to i64
  %217 = getelementptr i8, ptr addrspace(6) inttoptr (i64 24576 to ptr addrspace(6)), i64 %216
  %218 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %217, i32 0, i32 14, i32 0)
  %219 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %218, <256 x i1> %207, i32 0)
  %220 = sext i32 %215 to i64
  %221 = getelementptr i8, ptr addrspace(6) null, i64 %220
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %219, ptr addrspace(6) %221, i32 0, i32 2, i32 0, <256 x i1> %208)
  %222 = add i32 %214, 128
  %223 = add i32 %215, 256
  %224 = sext i32 %222 to i64
  %225 = getelementptr i8, ptr addrspace(6) inttoptr (i64 24576 to ptr addrspace(6)), i64 %224
  %226 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %225, i32 0, i32 14, i32 0)
  %227 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %226, <256 x i1> %207, i32 0)
  %228 = sext i32 %223 to i64
  %229 = getelementptr i8, ptr addrspace(6) null, i64 %228
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %227, ptr addrspace(6) %229, i32 0, i32 2, i32 0, <256 x i1> %208)
  %230 = add i64 %210, 1
  br label %209

231:                                              ; preds = %209
  br label %232

232:                                              ; preds = %231
  %233 = add i32 %204, 1
  br label %203, !llvm.loop !3

234:                                              ; preds = %203
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 2)
  br label %48

235:                                              ; preds = %322, %67
  %236 = phi i32 [ %323, %322 ], [ 0, %67 ]
  %237 = icmp sle i32 %236, 0
  br i1 %237, label %238, label %324

238:                                              ; preds = %235
  %239 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  %240 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %241

241:                                              ; preds = %244, %238
  %242 = phi i64 [ %262, %244 ], [ 0, %238 ]
  %243 = icmp slt i64 %242, 16
  br i1 %243, label %244, label %263

244:                                              ; preds = %241
  %245 = trunc i64 %242 to i32
  %246 = mul i32 %245, 256
  %247 = mul i32 %245, 512
  %248 = sext i32 %246 to i64
  %249 = getelementptr i8, ptr addrspace(6) inttoptr (i64 28672 to ptr addrspace(6)), i64 %248
  %250 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %249, i32 0, i32 14, i32 0)
  %251 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %250, <256 x i1> %239, i32 0)
  %252 = sext i32 %247 to i64
  %253 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %252
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %251, ptr addrspace(6) %253, i32 0, i32 2, i32 0, <256 x i1> %240)
  %254 = add i32 %246, 128
  %255 = add i32 %247, 256
  %256 = sext i32 %254 to i64
  %257 = getelementptr i8, ptr addrspace(6) inttoptr (i64 28672 to ptr addrspace(6)), i64 %256
  %258 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %257, i32 0, i32 14, i32 0)
  %259 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %258, <256 x i1> %239, i32 0)
  %260 = sext i32 %255 to i64
  %261 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %260
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %259, ptr addrspace(6) %261, i32 0, i32 2, i32 0, <256 x i1> %240)
  %262 = add i64 %242, 1
  br label %241

263:                                              ; preds = %241
  br label %264

264:                                              ; preds = %267, %263
  %265 = phi i64 [ %285, %267 ], [ 0, %263 ]
  %266 = icmp slt i64 %265, 16
  br i1 %266, label %267, label %286

267:                                              ; preds = %264
  %268 = trunc i64 %265 to i32
  %269 = mul i32 %268, 256
  %270 = mul i32 %268, 512
  %271 = sext i32 %269 to i64
  %272 = getelementptr i8, ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i64 %271
  %273 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %272, i32 0, i32 14, i32 0)
  %274 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %273, <256 x i1> %239, i32 0)
  %275 = sext i32 %270 to i64
  %276 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %275
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %274, ptr addrspace(6) %276, i32 0, i32 2, i32 0, <256 x i1> %240)
  %277 = add i32 %269, 128
  %278 = add i32 %270, 256
  %279 = sext i32 %277 to i64
  %280 = getelementptr i8, ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i64 %279
  %281 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %280, i32 0, i32 14, i32 0)
  %282 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %281, <256 x i1> %239, i32 0)
  %283 = sext i32 %278 to i64
  %284 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %283
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %282, ptr addrspace(6) %284, i32 0, i32 2, i32 0, <256 x i1> %240)
  %285 = add i64 %265, 1
  br label %264

286:                                              ; preds = %264
  %287 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %288

288:                                              ; preds = %291, %286
  %289 = phi i64 [ %320, %291 ], [ 0, %286 ]
  %290 = icmp slt i64 %289, 16
  br i1 %290, label %291, label %321

291:                                              ; preds = %288
  %292 = trunc i64 %289 to i32
  %293 = mul i32 %292, 128
  %294 = mul i32 %292, 512
  %295 = sext i32 %294 to i64
  %296 = getelementptr i8, ptr addrspace(6) null, i64 %295
  %297 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %296, i32 0, i32 0, i32 0)
  %298 = mul i32 %292, 256
  %299 = sext i32 %298 to i64
  %300 = getelementptr i8, ptr addrspace(6) inttoptr (i64 28672 to ptr addrspace(6)), i64 %299
  %301 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %300, i32 0, i32 14, i32 0)
  %302 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %301, <256 x i1> %239, i32 0)
  %303 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %297, <64 x float> %302, <256 x i1> %240)
  %304 = add i32 %293, 64
  %305 = mul i32 %304, 4
  %306 = sext i32 %305 to i64
  %307 = getelementptr i8, ptr addrspace(6) null, i64 %306
  %308 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %307, i32 0, i32 0, i32 0)
  %309 = mul i32 %304, 2
  %310 = sext i32 %309 to i64
  %311 = getelementptr i8, ptr addrspace(6) inttoptr (i64 28672 to ptr addrspace(6)), i64 %310
  %312 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %311, i32 0, i32 14, i32 0)
  %313 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %312, <256 x i1> %239, i32 0)
  %314 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %308, <64 x float> %313, <256 x i1> %240)
  %315 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %303, <64 x float> %314, <256 x i1> %240)
  %316 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %315, <256 x i1> %240)
  %317 = mul i32 %292, 4
  %318 = sext i32 %317 to i64
  %319 = getelementptr i8, ptr addrspace(6) inttoptr (i64 39168 to ptr addrspace(6)), i64 %318
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %316, ptr addrspace(6) %319, i32 0, i32 5, i32 0, <256 x i1> %287)
  %320 = add i64 %289, 1
  br label %288

321:                                              ; preds = %288
  br label %322

322:                                              ; preds = %321
  %323 = add i32 %236, 1
  br label %235, !llvm.loop !5

324:                                              ; preds = %235
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 3)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  store float 0xC7D2CED320000000, ptr addrspace(6) inttoptr (i64 39360 to ptr addrspace(6)), align 4
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 3)
  br label %96

325:                                              ; preds = %334, %123
  %326 = phi i32 [ %335, %334 ], [ 0, %123 ]
  %327 = icmp sle i32 %326, 0
  br i1 %327, label %328, label %336

328:                                              ; preds = %325
  %329 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %330 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 38400 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %331 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 38656 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %332 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %330, <64 x float> %331, <256 x i1> %329)
  %333 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %332, <256 x i1> %329)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %333, ptr addrspace(6) inttoptr (i64 38912 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %329)
  br label %334

334:                                              ; preds = %328
  %335 = add i32 %326, 1
  br label %325, !llvm.loop !6

336:                                              ; preds = %325
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 3)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 3)
  %337 = load float, ptr addrspace(6) inttoptr (i64 38912 to ptr addrspace(6)), align 4
  store float %337, ptr addrspace(6) inttoptr (i64 39520 to ptr addrspace(6)), align 4
  %338 = load float, ptr addrspace(6) inttoptr (i64 39392 to ptr addrspace(6)), align 4
  store float %338, ptr addrspace(6) inttoptr (i64 39424 to ptr addrspace(6)), align 4
  br label %124

339:                                              ; preds = %354, %132
  %340 = phi i32 [ %355, %354 ], [ 0, %132 ]
  %341 = icmp sle i32 %340, 0
  br i1 %341, label %342, label %356

342:                                              ; preds = %339
  %343 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 16)
  %344 = extractvalue { <256 x i1>, i32 } %343, 0
  %345 = extractvalue { <256 x i1>, i32 } %343, 1
  %346 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 0, i32 0)
  %347 = call <64 x float> @llvm.hivm.vgather2.v300.v64f32(ptr addrspace(6) inttoptr (i64 39168 to ptr addrspace(6)), <64 x i32> %346, <256 x i1> %344)
  %348 = call <64 x float> @llvm.hivm.vgather2.v300.v64f32(ptr addrspace(6) inttoptr (i64 39296 to ptr addrspace(6)), <64 x i32> %346, <256 x i1> %344)
  %349 = call <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float> %347, <64 x float> %348, <256 x i1> %344)
  %350 = call <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float> %349, <256 x i1> %344)
  %351 = call <32 x i8> @llvm.hivm.init.vector.align.data()
  %352 = bitcast <64 x float> %350 to <256 x i8>
  %353 = call <32 x i8> @llvm.hivm.vstus(<256 x i8> %352, ptr addrspace(6) inttoptr (i64 39232 to ptr addrspace(6)), i32 64, <32 x i8> %351)
  call void @llvm.hivm.vstas(<32 x i8> %353, ptr addrspace(6) inttoptr (i64 39232 to ptr addrspace(6)), i32 64, i32 0)
  br label %354

354:                                              ; preds = %342
  %355 = add i32 %340, 1
  br label %339, !llvm.loop !7

356:                                              ; preds = %339
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 3)
  store float 0.000000e+00, ptr addrspace(6) inttoptr (i64 39488 to ptr addrspace(6)), align 4
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 3)
  br label %133

357:                                              ; preds = %380, %157
  %358 = phi i32 [ %381, %380 ], [ 0, %157 ]
  %359 = icmp sle i32 %358, 0
  br i1 %359, label %360, label %382

360:                                              ; preds = %357
  %361 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %362

362:                                              ; preds = %365, %360
  %363 = phi i64 [ %378, %365 ], [ 0, %360 ]
  %364 = icmp slt i64 %363, 2
  br i1 %364, label %365, label %379

365:                                              ; preds = %362
  %366 = mul i64 %363, 64
  %367 = trunc i64 %366 to i32
  %368 = mul i32 %367, 4
  %369 = sext i32 %368 to i64
  %370 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %369
  %371 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %370, i32 0, i32 0, i32 0)
  %372 = sext i32 %368 to i64
  %373 = getelementptr i8, ptr addrspace(6) inttoptr (i64 37376 to ptr addrspace(6)), i64 %372
  %374 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %373, i32 0, i32 0, i32 0)
  %375 = call <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float> %371, <64 x float> %374, <256 x i1> %361)
  %376 = sext i32 %368 to i64
  %377 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %376
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %375, ptr addrspace(6) %377, i32 0, i32 2, i32 0, <256 x i1> %361)
  %378 = add i64 %363, 1
  br label %362

379:                                              ; preds = %362
  br label %380

380:                                              ; preds = %379
  %381 = add i32 %358, 1
  br label %357, !llvm.loop !8

382:                                              ; preds = %357
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 3)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 0, i64 3)
  br label %158

383:                                              ; preds = %408, %200
  %384 = phi i32 [ %409, %408 ], [ 0, %200 ]
  %385 = icmp sle i32 %384, 0
  br i1 %385, label %386, label %410

386:                                              ; preds = %383
  %387 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %388

388:                                              ; preds = %391, %386
  %389 = phi i64 [ %406, %391 ], [ 0, %386 ]
  %390 = icmp slt i64 %389, 2
  br i1 %390, label %391, label %407

391:                                              ; preds = %388
  %392 = trunc i64 %389 to i32
  %393 = udiv i32 %392, 2
  %394 = urem i32 %392, 2
  %395 = mul i32 %394, 64
  %396 = mul i32 %393, 128
  %397 = add i32 %396, %395
  %398 = mul i32 %397, 4
  %399 = sext i32 %398 to i64
  %400 = getelementptr i8, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i64 %399
  %401 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %400, i32 0, i32 0, i32 0)
  %402 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %401, <256 x i1> %387, i32 0, i32 0, i32 0)
  %403 = mul i32 %397, 2
  %404 = sext i32 %403 to i64
  %405 = getelementptr i8, ptr addrspace(6) inttoptr (i64 38144 to ptr addrspace(6)), i64 %404
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %402, ptr addrspace(6) %405, i32 0, i32 7, i32 0, <256 x i1> %387)
  %406 = add i64 %389, 1
  br label %388

407:                                              ; preds = %388
  br label %408

408:                                              ; preds = %407
  %409 = add i32 %384, 1
  br label %383, !llvm.loop !9

410:                                              ; preds = %383
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 0, i64 2)
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %411 = ptrtoint ptr addrspace(1) %5 to i64
  %412 = mul i64 %24, 2
  %413 = add i64 %411, %412
  %414 = inttoptr i64 %413 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %414, ptr addrspace(6) inttoptr (i64 38144 to ptr addrspace(6)), i64 288230377225453696, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  %415 = add i64 %18, 1
  br label %17
}

; Unknown intrinsic
declare i64 @llvm.hivm.GET.CTRL()

; Unknown intrinsic
declare i64 @llvm.hivm.SBITSET0(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.CTRL(i64)

; Unknown intrinsic
declare i64 @llvm.hivm.SBITSET1(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare i64 @llvm.hivm.GET.BLOCK.IDX()

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float>, <256 x i1>, i32, i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmul.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vci.v64i32(i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vgather2.v300.v64f32(ptr addrspace(6), <64 x i32>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vsub.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vexp.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare <32 x i8> @llvm.hivm.init.vector.align.data()

; Unknown intrinsic
declare <32 x i8> @llvm.hivm.vstus(<256 x i8>, ptr addrspace(6), i32, <32 x i8>)

; Unknown intrinsic
declare void @llvm.hivm.vstas(<32 x i8>, ptr addrspace(6), i32, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b16(i32)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat>, <256 x i1>, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float>, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1, !2}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @paged_decode_probe_kernel_mix_aic, !"kernel", i32 1}
!2 = !{ptr @paged_decode_probe_kernel_mix_aiv, !"kernel", i32 1}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.aivector_scope"}
!5 = distinct !{!5, !4}
!6 = distinct !{!6, !4}
!7 = distinct !{!7, !4}
!8 = distinct !{!8, !4}
!9 = distinct !{!9, !4}
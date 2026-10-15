; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @otr_min_d1_f32_s2(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
  %3 = call i64 @llvm.hivm.GET.CTRL()
  %4 = call i64 @llvm.hivm.SBITSET0(i64 %3, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %4)
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET1(i64 %5, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %9, label %10

9:                                                ; preds = %2
  br label %11

10:                                               ; preds = %378, %2
  ret void

11:                                               ; preds = %17, %9
  %12 = phi i32 [ %18, %17 ], [ 0, %9 ]
  %13 = icmp sle i32 %12, 0
  br i1 %13, label %14, label %19

14:                                               ; preds = %11
  %15 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %16 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %15, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %16, ptr addrspace(6) inttoptr (i64 47264 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %15)
  br label %17

17:                                               ; preds = %14
  %18 = add i32 %12, 1
  br label %11, !llvm.loop !2

19:                                               ; preds = %11
  br label %20

20:                                               ; preds = %28, %19
  %21 = phi i32 [ %29, %28 ], [ 0, %19 ]
  %22 = icmp sle i32 %21, 0
  br i1 %22, label %23, label %30

23:                                               ; preds = %20
  %24 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %25 = extractvalue { <256 x i1>, i32 } %24, 0
  %26 = extractvalue { <256 x i1>, i32 } %24, 1
  %27 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 20, <256 x i1> %25, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %27, ptr addrspace(6) inttoptr (i64 47264 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %25)
  br label %28

28:                                               ; preds = %23
  %29 = add i32 %21, 1
  br label %20, !llvm.loop !4

30:                                               ; preds = %20
  br label %31

31:                                               ; preds = %48, %30
  %32 = phi i32 [ %49, %48 ], [ 0, %30 ]
  %33 = icmp sle i32 %32, 0
  br i1 %33, label %34, label %50

34:                                               ; preds = %31
  %35 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %36

36:                                               ; preds = %39, %34
  %37 = phi i64 [ %46, %39 ], [ 0, %34 ]
  %38 = icmp slt i64 %37, 2
  br i1 %38, label %39, label %47

39:                                               ; preds = %36
  %40 = mul i64 %37, 64
  %41 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 100, <256 x i1> %35, i32 0)
  %42 = trunc i64 %40 to i32
  %43 = mul i32 %42, 4
  %44 = sext i32 %43 to i64
  %45 = getelementptr i8, ptr addrspace(6) inttoptr (i64 45728 to ptr addrspace(6)), i64 %44
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %41, ptr addrspace(6) %45, i32 0, i32 2, i32 0, <256 x i1> %35)
  %46 = add i64 %37, 1
  br label %36

47:                                               ; preds = %36
  br label %48

48:                                               ; preds = %47
  %49 = add i32 %32, 1
  br label %31, !llvm.loop !5

50:                                               ; preds = %31
  br label %51

51:                                               ; preds = %68, %50
  %52 = phi i32 [ %69, %68 ], [ 0, %50 ]
  %53 = icmp sle i32 %52, 0
  br i1 %53, label %54, label %70

54:                                               ; preds = %51
  %55 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %56

56:                                               ; preds = %59, %54
  %57 = phi i64 [ %66, %59 ], [ 0, %54 ]
  %58 = icmp slt i64 %57, 2
  br i1 %58, label %59, label %67

59:                                               ; preds = %56
  %60 = mul i64 %57, 64
  %61 = trunc i64 %60 to i32
  %62 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 %61, i32 0)
  %63 = mul i32 %61, 4
  %64 = sext i32 %63 to i64
  %65 = getelementptr i8, ptr addrspace(6) inttoptr (i64 46240 to ptr addrspace(6)), i64 %64
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %62, ptr addrspace(6) %65, i32 0, i32 2, i32 0, <256 x i1> %55)
  %66 = add i64 %57, 1
  br label %56

67:                                               ; preds = %56
  br label %68

68:                                               ; preds = %67
  %69 = add i32 %52, 1
  br label %51, !llvm.loop !6

70:                                               ; preds = %51
  br label %71

71:                                               ; preds = %77, %70
  %72 = phi i32 [ %78, %77 ], [ 0, %70 ]
  %73 = icmp sle i32 %72, 0
  br i1 %73, label %74, label %79

74:                                               ; preds = %71
  %75 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %76 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %75, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %76, ptr addrspace(6) inttoptr (i64 47520 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %75)
  br label %77

77:                                               ; preds = %74
  %78 = add i32 %72, 1
  br label %71, !llvm.loop !7

79:                                               ; preds = %71
  br label %80

80:                                               ; preds = %88, %79
  %81 = phi i32 [ %89, %88 ], [ 0, %79 ]
  %82 = icmp sle i32 %81, 0
  br i1 %82, label %83, label %90

83:                                               ; preds = %80
  %84 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 0, i32 0)
  %85 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %86 = extractvalue { <256 x i1>, i32 } %85, 0
  %87 = extractvalue { <256 x i1>, i32 } %85, 1
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %84, ptr addrspace(6) inttoptr (i64 47520 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %86)
  br label %88

88:                                               ; preds = %83
  %89 = add i32 %81, 1
  br label %80, !llvm.loop !8

90:                                               ; preds = %80
  br label %91

91:                                               ; preds = %100, %90
  %92 = phi i32 [ %101, %100 ], [ 0, %90 ]
  %93 = icmp sle i32 %92, 0
  br i1 %93, label %94, label %102

94:                                               ; preds = %91
  %95 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %96 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %95, i32 0)
  %97 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %96, <256 x i8> %96, <256 x i1> %95)
  %98 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %95, i32 0)
  %99 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %98, <256 x i8> %96, <256 x i1> %97)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %99, ptr addrspace(6) inttoptr (i64 47776 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %95)
  br label %100

100:                                              ; preds = %94
  %101 = add i32 %92, 1
  br label %91, !llvm.loop !9

102:                                              ; preds = %91
  br label %103

103:                                              ; preds = %134, %102
  %104 = phi i32 [ %135, %134 ], [ 0, %102 ]
  %105 = icmp sle i32 %104, 0
  br i1 %105, label %106, label %136

106:                                              ; preds = %103
  %107 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %108 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %107, i32 0)
  %109 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 1, <256 x i1> %107, i32 0)
  %110 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 64)
  %111 = extractvalue { <256 x i1>, i32 } %110, 0
  %112 = extractvalue { <256 x i1>, i32 } %110, 1
  br label %113

113:                                              ; preds = %116, %106
  %114 = phi i64 [ %132, %116 ], [ 0, %106 ]
  %115 = icmp slt i64 %114, 2
  br i1 %115, label %116, label %133

116:                                              ; preds = %113
  %117 = trunc i64 %114 to i32
  %118 = mul i32 %117, 64
  %119 = mul i32 %117, 256
  %120 = sext i32 %119 to i64
  %121 = getelementptr i8, ptr addrspace(6) inttoptr (i64 46240 to ptr addrspace(6)), i64 %120
  %122 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) %121, i32 0, i32 0, i32 0)
  %123 = sext i32 %119 to i64
  %124 = getelementptr i8, ptr addrspace(6) inttoptr (i64 45728 to ptr addrspace(6)), i64 %123
  %125 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) %124, i32 0, i32 0, i32 0)
  %126 = call <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32> %122, <64 x i32> %125, <256 x i1> %107)
  %127 = call <64 x i32> @llvm.hivm.vsel.v64i32(<64 x i32> %109, <64 x i32> %108, <256 x i1> %126)
  %128 = call <128 x i16> @llvm.hivm.vpack.x.v64i32(<64 x i32> %127, i32 0)
  %129 = call <256 x i8> @llvm.hivm.vpack.x.v128i16(<128 x i16> %128, i32 0)
  %130 = sext i32 %118 to i64
  %131 = getelementptr i8, ptr addrspace(6) inttoptr (i64 47776 to ptr addrspace(6)), i64 %130
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %129, ptr addrspace(6) %131, i32 0, i32 0, i32 0, <256 x i1> %111)
  %132 = add i64 %114, 1
  br label %113

133:                                              ; preds = %113
  br label %134

134:                                              ; preds = %133
  %135 = add i32 %104, 1
  br label %103, !llvm.loop !10

136:                                              ; preds = %103
  br label %137

137:                                              ; preds = %146, %136
  %138 = phi i32 [ %147, %146 ], [ 0, %136 ]
  %139 = icmp sle i32 %138, 0
  br i1 %139, label %140, label %148

140:                                              ; preds = %137
  %141 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %142 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %141, i32 0)
  %143 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %142, <256 x i8> %142, <256 x i1> %141)
  %144 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %141, i32 0)
  %145 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %144, <256 x i8> %142, <256 x i1> %143)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %145, ptr addrspace(6) inttoptr (i64 48032 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %141)
  br label %146

146:                                              ; preds = %140
  %147 = add i32 %138, 1
  br label %137, !llvm.loop !11

148:                                              ; preds = %137
  br label %149

149:                                              ; preds = %165, %148
  %150 = phi i32 [ %166, %165 ], [ 0, %148 ]
  %151 = icmp sle i32 %150, 0
  br i1 %151, label %152, label %167

152:                                              ; preds = %149
  %153 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 47264 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %154 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 47520 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %155 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %156 = call <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32> %154, <64 x i32> %153, <256 x i1> %155)
  %157 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 32)
  %158 = extractvalue { <256 x i1>, i32 } %157, 0
  %159 = extractvalue { <256 x i1>, i32 } %157, 1
  %160 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %156, i32 0)
  %161 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %160, i32 0)
  %162 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %158, i32 0)
  %163 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %158, i32 0)
  %164 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %163, <256 x i8> %162, <256 x i1> %161)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %164, ptr addrspace(6) inttoptr (i64 48032 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %158)
  br label %165

165:                                              ; preds = %152
  %166 = add i32 %150, 1
  br label %149, !llvm.loop !12

167:                                              ; preds = %149
  br label %168

168:                                              ; preds = %187, %167
  %169 = phi i32 [ %188, %187 ], [ 0, %167 ]
  %170 = icmp sle i32 %169, 0
  br i1 %170, label %171, label %189

171:                                              ; preds = %168
  %172 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %173 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %172, i32 0)
  br label %174

174:                                              ; preds = %177, %171
  %175 = phi i64 [ %182, %177 ], [ 0, %171 ]
  %176 = icmp slt i64 %175, 16
  br i1 %176, label %177, label %183

177:                                              ; preds = %174
  %178 = trunc i64 %175 to i32
  %179 = mul i32 %178, 256
  %180 = sext i32 %179 to i64
  %181 = getelementptr i8, ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i64 %180
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %173, ptr addrspace(6) %181, i32 0, i32 0, i32 0, <256 x i1> %172)
  %182 = add i64 %175, 1
  br label %174

183:                                              ; preds = %174
  %184 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 224)
  %185 = extractvalue { <256 x i1>, i32 } %184, 0
  %186 = extractvalue { <256 x i1>, i32 } %184, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %173, ptr addrspace(6) inttoptr (i64 36864 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %185)
  br label %187

187:                                              ; preds = %183
  %188 = add i32 %169, 1
  br label %168, !llvm.loop !13

189:                                              ; preds = %168
  br label %190

190:                                              ; preds = %210, %189
  %191 = phi i32 [ %211, %210 ], [ 0, %189 ]
  %192 = icmp sle i32 %191, 0
  br i1 %192, label %193, label %212

193:                                              ; preds = %190
  %194 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 32)
  %195 = extractvalue { <256 x i1>, i32 } %194, 0
  %196 = extractvalue { <256 x i1>, i32 } %194, 1
  br label %197

197:                                              ; preds = %200, %193
  %198 = phi i64 [ %208, %200 ], [ 0, %193 ]
  %199 = icmp slt i64 %198, 128
  br i1 %199, label %200, label %209

200:                                              ; preds = %197
  %201 = trunc i64 %198 to i32
  %202 = sext i32 %201 to i64
  %203 = getelementptr i8, ptr addrspace(6) inttoptr (i64 47776 to ptr addrspace(6)), i64 %202
  %204 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %203, i32 0, i32 1, i32 0)
  %205 = mul i32 %201, 32
  %206 = sext i32 %205 to i64
  %207 = getelementptr i8, ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i64 %206
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %204, ptr addrspace(6) %207, i32 0, i32 0, i32 0, <256 x i1> %195)
  %208 = add i64 %198, 1
  br label %197

209:                                              ; preds = %197
  br label %210

210:                                              ; preds = %209
  %211 = add i32 %191, 1
  br label %190, !llvm.loop !14

212:                                              ; preds = %190
  br label %213

213:                                              ; preds = %232, %212
  %214 = phi i32 [ %233, %232 ], [ 0, %212 ]
  %215 = icmp sle i32 %214, 0
  br i1 %215, label %216, label %234

216:                                              ; preds = %213
  %217 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %218 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %217, i32 0)
  br label %219

219:                                              ; preds = %222, %216
  %220 = phi i64 [ %227, %222 ], [ 0, %216 ]
  %221 = icmp slt i64 %220, 16
  br i1 %221, label %222, label %228

222:                                              ; preds = %219
  %223 = trunc i64 %220 to i32
  %224 = mul i32 %223, 256
  %225 = sext i32 %224 to i64
  %226 = getelementptr i8, ptr addrspace(6) inttoptr (i64 37088 to ptr addrspace(6)), i64 %225
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %218, ptr addrspace(6) %226, i32 0, i32 0, i32 0, <256 x i1> %217)
  %227 = add i64 %220, 1
  br label %219

228:                                              ; preds = %219
  %229 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 224)
  %230 = extractvalue { <256 x i1>, i32 } %229, 0
  %231 = extractvalue { <256 x i1>, i32 } %229, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %218, ptr addrspace(6) inttoptr (i64 41184 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %230)
  br label %232

232:                                              ; preds = %228
  %233 = add i32 %214, 1
  br label %213, !llvm.loop !15

234:                                              ; preds = %213
  br label %235

235:                                              ; preds = %261, %234
  %236 = phi i32 [ %262, %261 ], [ 0, %234 ]
  %237 = icmp sle i32 %236, 0
  br i1 %237, label %238, label %263

238:                                              ; preds = %235
  %239 = call <256 x i1> @llvm.hivm.pset.b8(i32 2)
  br label %240

240:                                              ; preds = %258, %238
  %241 = phi i64 [ %259, %258 ], [ 0, %238 ]
  %242 = icmp slt i64 %241, 32
  br i1 %242, label %243, label %260

243:                                              ; preds = %240
  %244 = trunc i64 %241 to i32
  %245 = sext i32 %244 to i64
  %246 = getelementptr i8, ptr addrspace(6) inttoptr (i64 48032 to ptr addrspace(6)), i64 %245
  %247 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %246, i32 0, i32 1, i32 0)
  br label %248

248:                                              ; preds = %251, %243
  %249 = phi i64 [ %257, %251 ], [ 0, %243 ]
  %250 = icmp slt i64 %249, 128
  br i1 %250, label %251, label %258

251:                                              ; preds = %248
  %252 = trunc i64 %249 to i32
  %253 = mul i32 %252, 32
  %254 = add i32 %253, %244
  %255 = sext i32 %254 to i64
  %256 = getelementptr i8, ptr addrspace(6) inttoptr (i64 37088 to ptr addrspace(6)), i64 %255
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %247, ptr addrspace(6) %256, i32 0, i32 3, i32 0, <256 x i1> %239)
  %257 = add i64 %249, 1
  br label %248

258:                                              ; preds = %248
  %259 = add i64 %241, 1
  br label %240

260:                                              ; preds = %240
  br label %261

261:                                              ; preds = %260
  %262 = add i32 %236, 1
  br label %235, !llvm.loop !16

263:                                              ; preds = %235
  br label %264

264:                                              ; preds = %283, %263
  %265 = phi i32 [ %284, %283 ], [ 0, %263 ]
  %266 = icmp sle i32 %265, 0
  br i1 %266, label %267, label %285

267:                                              ; preds = %264
  %268 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %269 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %268, i32 0)
  br label %270

270:                                              ; preds = %273, %267
  %271 = phi i64 [ %278, %273 ], [ 0, %267 ]
  %272 = icmp slt i64 %271, 16
  br i1 %272, label %273, label %279

273:                                              ; preds = %270
  %274 = trunc i64 %271 to i32
  %275 = mul i32 %274, 256
  %276 = sext i32 %275 to i64
  %277 = getelementptr i8, ptr addrspace(6) inttoptr (i64 41408 to ptr addrspace(6)), i64 %276
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %269, ptr addrspace(6) %277, i32 0, i32 0, i32 0, <256 x i1> %268)
  %278 = add i64 %271, 1
  br label %270

279:                                              ; preds = %270
  %280 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 224)
  %281 = extractvalue { <256 x i1>, i32 } %280, 0
  %282 = extractvalue { <256 x i1>, i32 } %280, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %269, ptr addrspace(6) inttoptr (i64 45504 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %281)
  br label %283

283:                                              ; preds = %279
  %284 = add i32 %265, 1
  br label %264, !llvm.loop !17

285:                                              ; preds = %264
  br label %286

286:                                              ; preds = %317, %285
  %287 = phi i32 [ %318, %317 ], [ 0, %285 ]
  %288 = icmp sle i32 %287, 0
  br i1 %288, label %289, label %319

289:                                              ; preds = %286
  %290 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  br label %291

291:                                              ; preds = %294, %289
  %292 = phi i64 [ %315, %294 ], [ 0, %289 ]
  %293 = icmp slt i64 %292, 16
  br i1 %293, label %294, label %316

294:                                              ; preds = %291
  %295 = trunc i64 %292 to i32
  %296 = udiv i32 %295, 16
  %297 = urem i32 %295, 16
  %298 = mul i32 %297, 256
  %299 = mul i32 %296, 4096
  %300 = add i32 %299, %298
  %301 = sext i32 %300 to i64
  %302 = getelementptr i8, ptr addrspace(6) inttoptr (i64 32768 to ptr addrspace(6)), i64 %301
  %303 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %302, i32 0, i32 0, i32 0)
  %304 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %290, i32 0)
  %305 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %303, <256 x i8> %304, <256 x i1> %290)
  %306 = sext i32 %300 to i64
  %307 = getelementptr i8, ptr addrspace(6) inttoptr (i64 37088 to ptr addrspace(6)), i64 %306
  %308 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %307, i32 0, i32 0, i32 0)
  %309 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %308, <256 x i8> %304, <256 x i1> %290)
  %310 = call <256 x i1> @llvm.hivm.pand.z(<256 x i1> %305, <256 x i1> %309, <256 x i1> %290)
  %311 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %290, i32 0)
  %312 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %311, <256 x i8> %304, <256 x i1> %310)
  %313 = sext i32 %300 to i64
  %314 = getelementptr i8, ptr addrspace(6) inttoptr (i64 41408 to ptr addrspace(6)), i64 %313
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %312, ptr addrspace(6) %314, i32 0, i32 0, i32 0, <256 x i1> %290)
  %315 = add i64 %292, 1
  br label %291

316:                                              ; preds = %291
  br label %317

317:                                              ; preds = %316
  %318 = add i32 %287, 1
  br label %286, !llvm.loop !18

319:                                              ; preds = %286
  %320 = ptrtoint ptr addrspace(1) %0 to i64
  %321 = inttoptr i64 %320 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %321, i64 288230378836067904, i64 140737488355408)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %322

322:                                              ; preds = %350, %319
  %323 = phi i32 [ %351, %350 ], [ 0, %319 ]
  %324 = icmp sle i32 %323, 0
  br i1 %324, label %325, label %352

325:                                              ; preds = %322
  %326 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %327

327:                                              ; preds = %330, %325
  %328 = phi i64 [ %348, %330 ], [ 0, %325 ]
  %329 = icmp slt i64 %328, 64
  br i1 %329, label %330, label %349

330:                                              ; preds = %327
  %331 = mul i64 %328, 64
  %332 = trunc i64 %331 to i32
  %333 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %334 = sext i32 %332 to i64
  %335 = getelementptr i8, ptr addrspace(6) inttoptr (i64 41408 to ptr addrspace(6)), i64 %334
  %336 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %335, i32 0, i32 20, i32 0)
  %337 = call <64 x i32> @llvm.hivm.vcvtii.s82s32.x(<256 x i8> %336, <256 x i1> %333, i32 0)
  %338 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %326, i32 0)
  %339 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s32(<64 x i32> %337, <64 x i32> %338, <256 x i1> %326)
  %340 = mul i32 %332, 4
  %341 = sext i32 %340 to i64
  %342 = getelementptr i8, ptr addrspace(6) null, i64 %341
  %343 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %342, i32 0, i32 0, i32 0)
  %344 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 0x7FF0000000000000, <256 x i1> %326, i32 0)
  %345 = call <64 x float> @llvm.hivm.vsel.v64f32(<64 x float> %343, <64 x float> %344, <256 x i1> %339)
  %346 = sext i32 %340 to i64
  %347 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %346
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %345, ptr addrspace(6) %347, i32 0, i32 2, i32 0, <256 x i1> %326)
  %348 = add i64 %328, 1
  br label %327

349:                                              ; preds = %327
  br label %350

350:                                              ; preds = %349
  %351 = add i32 %323, 1
  br label %322, !llvm.loop !19

352:                                              ; preds = %322
  br label %353

353:                                              ; preds = %376, %352
  %354 = phi i32 [ %377, %376 ], [ 0, %352 ]
  %355 = icmp sle i32 %354, 0
  br i1 %355, label %356, label %378

356:                                              ; preds = %353
  %357 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %358 = extractvalue { <256 x i1>, i32 } %357, 0
  %359 = extractvalue { <256 x i1>, i32 } %357, 1
  %360 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %361

361:                                              ; preds = %364, %356
  %362 = phi i64 [ %374, %364 ], [ 0, %356 ]
  %363 = icmp slt i64 %362, 128
  br i1 %363, label %364, label %375

364:                                              ; preds = %361
  %365 = trunc i64 %362 to i32
  %366 = mul i32 %365, 128
  %367 = sext i32 %366 to i64
  %368 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 %367
  %369 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %368, i32 0, i32 0, i32 0)
  %370 = call <64 x float> @llvm.hivm.vcmin.s.x.v64f32(<64 x float> %369, <256 x i1> %358)
  %371 = mul i32 %365, 4
  %372 = sext i32 %371 to i64
  %373 = getelementptr i8, ptr addrspace(6) inttoptr (i64 46752 to ptr addrspace(6)), i64 %372
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %370, ptr addrspace(6) %373, i32 0, i32 5, i32 0, <256 x i1> %360)
  %374 = add i64 %362, 1
  br label %361

375:                                              ; preds = %361
  br label %376

376:                                              ; preds = %375
  %377 = add i32 %354, 1
  br label %353, !llvm.loop !20

378:                                              ; preds = %353
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %379 = ptrtoint ptr addrspace(1) %1 to i64
  %380 = inttoptr i64 %379 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %380, ptr addrspace(6) inttoptr (i64 46752 to ptr addrspace(6)), i64 288230389573484560, i64 439804651110800)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %10
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
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcmin.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b8(i32)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vcvtii.s82s32.x(<256 x i8>, <256 x i1>, i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vdups.z.v64i32(i32, <256 x i1>, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.vcmp.ne.s.z.s32(<64 x i32>, <64 x i32>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vdups.z.v64f32(float, <256 x i1>, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vsel.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vdups.z.v256i8(i8, <256 x i1>, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8>, <256 x i8>, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pand.z(<256 x i1>, <256 x i1>, <256 x i1>)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8>, <256 x i8>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v256s8(<256 x i8>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32>, <64 x i32>, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.ppack.z(<256 x i1>, i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vsel.v64i32(<64 x i32>, <64 x i32>, <256 x i1>)

; Unknown intrinsic
declare <128 x i16> @llvm.hivm.vpack.x.v64i32(<64 x i32>, i32)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vpack.x.v128i16(<128 x i16>, i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vci.v64i32(i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64s32(<64 x i32>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @otr_min_d1_f32_s2, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
!5 = distinct !{!5, !3}
!6 = distinct !{!6, !3}
!7 = distinct !{!7, !3}
!8 = distinct !{!8, !3}
!9 = distinct !{!9, !3}
!10 = distinct !{!10, !3}
!11 = distinct !{!11, !3}
!12 = distinct !{!12, !3}
!13 = distinct !{!13, !3}
!14 = distinct !{!14, !3}
!15 = distinct !{!15, !3}
!16 = distinct !{!16, !3}
!17 = distinct !{!17, !3}
!18 = distinct !{!18, !3}
!19 = distinct !{!19, !3}
!20 = distinct !{!20, !3}
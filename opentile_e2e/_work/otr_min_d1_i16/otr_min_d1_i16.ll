; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @otr_min_d1_i16(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
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

10:                                               ; preds = %341, %2
  ret void

11:                                               ; preds = %17, %9
  %12 = phi i32 [ %18, %17 ], [ 0, %9 ]
  %13 = icmp sle i32 %12, 0
  br i1 %13, label %14, label %19

14:                                               ; preds = %11
  %15 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %16 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %15, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %16, ptr addrspace(6) inttoptr (i64 15008 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %15)
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
  %27 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 16, <256 x i1> %25, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %27, ptr addrspace(6) inttoptr (i64 15008 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %25)
  br label %28

28:                                               ; preds = %23
  %29 = add i32 %21, 1
  br label %20, !llvm.loop !4

30:                                               ; preds = %20
  br label %31

31:                                               ; preds = %37, %30
  %32 = phi i32 [ %38, %37 ], [ 0, %30 ]
  %33 = icmp sle i32 %32, 0
  br i1 %33, label %34, label %39

34:                                               ; preds = %31
  %35 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %36 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 64, <256 x i1> %35, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %36, ptr addrspace(6) inttoptr (i64 15264 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %35)
  br label %37

37:                                               ; preds = %34
  %38 = add i32 %32, 1
  br label %31, !llvm.loop !5

39:                                               ; preds = %31
  br label %40

40:                                               ; preds = %46, %39
  %41 = phi i32 [ %47, %46 ], [ 0, %39 ]
  %42 = icmp sle i32 %41, 0
  br i1 %42, label %43, label %48

43:                                               ; preds = %40
  %44 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %45 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 0, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %45, ptr addrspace(6) inttoptr (i64 15520 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %44)
  br label %46

46:                                               ; preds = %43
  %47 = add i32 %41, 1
  br label %40, !llvm.loop !6

48:                                               ; preds = %40
  br label %49

49:                                               ; preds = %55, %48
  %50 = phi i32 [ %56, %55 ], [ 0, %48 ]
  %51 = icmp sle i32 %50, 0
  br i1 %51, label %52, label %57

52:                                               ; preds = %49
  %53 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %54 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %53, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %54, ptr addrspace(6) inttoptr (i64 15776 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %53)
  br label %55

55:                                               ; preds = %52
  %56 = add i32 %50, 1
  br label %49, !llvm.loop !7

57:                                               ; preds = %49
  br label %58

58:                                               ; preds = %66, %57
  %59 = phi i32 [ %67, %66 ], [ 0, %57 ]
  %60 = icmp sle i32 %59, 0
  br i1 %60, label %61, label %68

61:                                               ; preds = %58
  %62 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 0, i32 0)
  %63 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %64 = extractvalue { <256 x i1>, i32 } %63, 0
  %65 = extractvalue { <256 x i1>, i32 } %63, 1
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %62, ptr addrspace(6) inttoptr (i64 15776 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %64)
  br label %66

66:                                               ; preds = %61
  %67 = add i32 %59, 1
  br label %58, !llvm.loop !8

68:                                               ; preds = %58
  br label %69

69:                                               ; preds = %78, %68
  %70 = phi i32 [ %79, %78 ], [ 0, %68 ]
  %71 = icmp sle i32 %70, 0
  br i1 %71, label %72, label %80

72:                                               ; preds = %69
  %73 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %74 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %73, i32 0)
  %75 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %74, <256 x i8> %74, <256 x i1> %73)
  %76 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %73, i32 0)
  %77 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %76, <256 x i8> %74, <256 x i1> %75)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %77, ptr addrspace(6) inttoptr (i64 16032 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %73)
  br label %78

78:                                               ; preds = %72
  %79 = add i32 %70, 1
  br label %69, !llvm.loop !9

80:                                               ; preds = %69
  br label %81

81:                                               ; preds = %97, %80
  %82 = phi i32 [ %98, %97 ], [ 0, %80 ]
  %83 = icmp sle i32 %82, 0
  br i1 %83, label %84, label %99

84:                                               ; preds = %81
  %85 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 15264 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %86 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 15520 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %87 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %88 = call <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32> %86, <64 x i32> %85, <256 x i1> %87)
  %89 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 64)
  %90 = extractvalue { <256 x i1>, i32 } %89, 0
  %91 = extractvalue { <256 x i1>, i32 } %89, 1
  %92 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %88, i32 0)
  %93 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %92, i32 0)
  %94 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %90, i32 0)
  %95 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %90, i32 0)
  %96 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %95, <256 x i8> %94, <256 x i1> %93)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %96, ptr addrspace(6) inttoptr (i64 16032 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %90)
  br label %97

97:                                               ; preds = %84
  %98 = add i32 %82, 1
  br label %81, !llvm.loop !10

99:                                               ; preds = %81
  br label %100

100:                                              ; preds = %109, %99
  %101 = phi i32 [ %110, %109 ], [ 0, %99 ]
  %102 = icmp sle i32 %101, 0
  br i1 %102, label %103, label %111

103:                                              ; preds = %100
  %104 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %105 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %104, i32 0)
  %106 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %105, <256 x i8> %105, <256 x i1> %104)
  %107 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %104, i32 0)
  %108 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %107, <256 x i8> %105, <256 x i1> %106)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %108, ptr addrspace(6) inttoptr (i64 16288 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %104)
  br label %109

109:                                              ; preds = %103
  %110 = add i32 %101, 1
  br label %100, !llvm.loop !11

111:                                              ; preds = %100
  br label %112

112:                                              ; preds = %128, %111
  %113 = phi i32 [ %129, %128 ], [ 0, %111 ]
  %114 = icmp sle i32 %113, 0
  br i1 %114, label %115, label %130

115:                                              ; preds = %112
  %116 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 15008 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %117 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 15776 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %118 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %119 = call <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32> %117, <64 x i32> %116, <256 x i1> %118)
  %120 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 32)
  %121 = extractvalue { <256 x i1>, i32 } %120, 0
  %122 = extractvalue { <256 x i1>, i32 } %120, 1
  %123 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %119, i32 0)
  %124 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %123, i32 0)
  %125 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %121, i32 0)
  %126 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %121, i32 0)
  %127 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %126, <256 x i8> %125, <256 x i1> %124)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %127, ptr addrspace(6) inttoptr (i64 16288 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %121)
  br label %128

128:                                              ; preds = %115
  %129 = add i32 %113, 1
  br label %112, !llvm.loop !12

130:                                              ; preds = %112
  br label %131

131:                                              ; preds = %150, %130
  %132 = phi i32 [ %151, %150 ], [ 0, %130 ]
  %133 = icmp sle i32 %132, 0
  br i1 %133, label %134, label %152

134:                                              ; preds = %131
  %135 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %136 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %135, i32 0)
  br label %137

137:                                              ; preds = %140, %134
  %138 = phi i64 [ %145, %140 ], [ 0, %134 ]
  %139 = icmp slt i64 %138, 8
  br i1 %139, label %140, label %146

140:                                              ; preds = %137
  %141 = trunc i64 %138 to i32
  %142 = mul i32 %141, 256
  %143 = sext i32 %142 to i64
  %144 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %143
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %136, ptr addrspace(6) %144, i32 0, i32 0, i32 0, <256 x i1> %135)
  %145 = add i64 %138, 1
  br label %137

146:                                              ; preds = %137
  %147 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 224)
  %148 = extractvalue { <256 x i1>, i32 } %147, 0
  %149 = extractvalue { <256 x i1>, i32 } %147, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %136, ptr addrspace(6) inttoptr (i64 10240 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %148)
  br label %150

150:                                              ; preds = %146
  %151 = add i32 %132, 1
  br label %131, !llvm.loop !13

152:                                              ; preds = %131
  br label %153

153:                                              ; preds = %173, %152
  %154 = phi i32 [ %174, %173 ], [ 0, %152 ]
  %155 = icmp sle i32 %154, 0
  br i1 %155, label %156, label %175

156:                                              ; preds = %153
  %157 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 32)
  %158 = extractvalue { <256 x i1>, i32 } %157, 0
  %159 = extractvalue { <256 x i1>, i32 } %157, 1
  br label %160

160:                                              ; preds = %163, %156
  %161 = phi i64 [ %171, %163 ], [ 0, %156 ]
  %162 = icmp slt i64 %161, 64
  br i1 %162, label %163, label %172

163:                                              ; preds = %160
  %164 = trunc i64 %161 to i32
  %165 = sext i32 %164 to i64
  %166 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16032 to ptr addrspace(6)), i64 %165
  %167 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %166, i32 0, i32 1, i32 0)
  %168 = mul i32 %164, 32
  %169 = sext i32 %168 to i64
  %170 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %169
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %167, ptr addrspace(6) %170, i32 0, i32 0, i32 0, <256 x i1> %158)
  %171 = add i64 %161, 1
  br label %160

172:                                              ; preds = %160
  br label %173

173:                                              ; preds = %172
  %174 = add i32 %154, 1
  br label %153, !llvm.loop !14

175:                                              ; preds = %153
  br label %176

176:                                              ; preds = %195, %175
  %177 = phi i32 [ %196, %195 ], [ 0, %175 ]
  %178 = icmp sle i32 %177, 0
  br i1 %178, label %179, label %197

179:                                              ; preds = %176
  %180 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %181 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %180, i32 0)
  br label %182

182:                                              ; preds = %185, %179
  %183 = phi i64 [ %190, %185 ], [ 0, %179 ]
  %184 = icmp slt i64 %183, 8
  br i1 %184, label %185, label %191

185:                                              ; preds = %182
  %186 = trunc i64 %183 to i32
  %187 = mul i32 %186, 256
  %188 = sext i32 %187 to i64
  %189 = getelementptr i8, ptr addrspace(6) inttoptr (i64 10464 to ptr addrspace(6)), i64 %188
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %181, ptr addrspace(6) %189, i32 0, i32 0, i32 0, <256 x i1> %180)
  %190 = add i64 %183, 1
  br label %182

191:                                              ; preds = %182
  %192 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 224)
  %193 = extractvalue { <256 x i1>, i32 } %192, 0
  %194 = extractvalue { <256 x i1>, i32 } %192, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %181, ptr addrspace(6) inttoptr (i64 12512 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %193)
  br label %195

195:                                              ; preds = %191
  %196 = add i32 %177, 1
  br label %176, !llvm.loop !15

197:                                              ; preds = %176
  br label %198

198:                                              ; preds = %224, %197
  %199 = phi i32 [ %225, %224 ], [ 0, %197 ]
  %200 = icmp sle i32 %199, 0
  br i1 %200, label %201, label %226

201:                                              ; preds = %198
  %202 = call <256 x i1> @llvm.hivm.pset.b8(i32 2)
  br label %203

203:                                              ; preds = %221, %201
  %204 = phi i64 [ %222, %221 ], [ 0, %201 ]
  %205 = icmp slt i64 %204, 32
  br i1 %205, label %206, label %223

206:                                              ; preds = %203
  %207 = trunc i64 %204 to i32
  %208 = sext i32 %207 to i64
  %209 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16288 to ptr addrspace(6)), i64 %208
  %210 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %209, i32 0, i32 1, i32 0)
  br label %211

211:                                              ; preds = %214, %206
  %212 = phi i64 [ %220, %214 ], [ 0, %206 ]
  %213 = icmp slt i64 %212, 64
  br i1 %213, label %214, label %221

214:                                              ; preds = %211
  %215 = trunc i64 %212 to i32
  %216 = mul i32 %215, 32
  %217 = add i32 %216, %207
  %218 = sext i32 %217 to i64
  %219 = getelementptr i8, ptr addrspace(6) inttoptr (i64 10464 to ptr addrspace(6)), i64 %218
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %210, ptr addrspace(6) %219, i32 0, i32 3, i32 0, <256 x i1> %202)
  %220 = add i64 %212, 1
  br label %211

221:                                              ; preds = %211
  %222 = add i64 %204, 1
  br label %203

223:                                              ; preds = %203
  br label %224

224:                                              ; preds = %223
  %225 = add i32 %199, 1
  br label %198, !llvm.loop !16

226:                                              ; preds = %198
  br label %227

227:                                              ; preds = %246, %226
  %228 = phi i32 [ %247, %246 ], [ 0, %226 ]
  %229 = icmp sle i32 %228, 0
  br i1 %229, label %230, label %248

230:                                              ; preds = %227
  %231 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %232 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %231, i32 0)
  br label %233

233:                                              ; preds = %236, %230
  %234 = phi i64 [ %241, %236 ], [ 0, %230 ]
  %235 = icmp slt i64 %234, 8
  br i1 %235, label %236, label %242

236:                                              ; preds = %233
  %237 = trunc i64 %234 to i32
  %238 = mul i32 %237, 256
  %239 = sext i32 %238 to i64
  %240 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12736 to ptr addrspace(6)), i64 %239
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %232, ptr addrspace(6) %240, i32 0, i32 0, i32 0, <256 x i1> %231)
  %241 = add i64 %234, 1
  br label %233

242:                                              ; preds = %233
  %243 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 224)
  %244 = extractvalue { <256 x i1>, i32 } %243, 0
  %245 = extractvalue { <256 x i1>, i32 } %243, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %232, ptr addrspace(6) inttoptr (i64 14784 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %244)
  br label %246

246:                                              ; preds = %242
  %247 = add i32 %228, 1
  br label %227, !llvm.loop !17

248:                                              ; preds = %227
  br label %249

249:                                              ; preds = %280, %248
  %250 = phi i32 [ %281, %280 ], [ 0, %248 ]
  %251 = icmp sle i32 %250, 0
  br i1 %251, label %252, label %282

252:                                              ; preds = %249
  %253 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  br label %254

254:                                              ; preds = %257, %252
  %255 = phi i64 [ %278, %257 ], [ 0, %252 ]
  %256 = icmp slt i64 %255, 8
  br i1 %256, label %257, label %279

257:                                              ; preds = %254
  %258 = trunc i64 %255 to i32
  %259 = udiv i32 %258, 8
  %260 = urem i32 %258, 8
  %261 = mul i32 %260, 256
  %262 = mul i32 %259, 2048
  %263 = add i32 %262, %261
  %264 = sext i32 %263 to i64
  %265 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %264
  %266 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %265, i32 0, i32 0, i32 0)
  %267 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %253, i32 0)
  %268 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %266, <256 x i8> %267, <256 x i1> %253)
  %269 = sext i32 %263 to i64
  %270 = getelementptr i8, ptr addrspace(6) inttoptr (i64 10464 to ptr addrspace(6)), i64 %269
  %271 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %270, i32 0, i32 0, i32 0)
  %272 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %271, <256 x i8> %267, <256 x i1> %253)
  %273 = call <256 x i1> @llvm.hivm.pand.z(<256 x i1> %268, <256 x i1> %272, <256 x i1> %253)
  %274 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %253, i32 0)
  %275 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %274, <256 x i8> %267, <256 x i1> %273)
  %276 = sext i32 %263 to i64
  %277 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12736 to ptr addrspace(6)), i64 %276
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %275, ptr addrspace(6) %277, i32 0, i32 0, i32 0, <256 x i1> %253)
  %278 = add i64 %255, 1
  br label %254

279:                                              ; preds = %254
  br label %280

280:                                              ; preds = %279
  %281 = add i32 %250, 1
  br label %249, !llvm.loop !18

282:                                              ; preds = %249
  %283 = ptrtoint ptr addrspace(1) %0 to i64
  %284 = inttoptr i64 %283 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) null, ptr addrspace(1) %284, i64 288230377225454592, i64 70368744177696)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %285

285:                                              ; preds = %313, %282
  %286 = phi i32 [ %314, %313 ], [ 0, %282 ]
  %287 = icmp sle i32 %286, 0
  br i1 %287, label %288, label %315

288:                                              ; preds = %285
  %289 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %290

290:                                              ; preds = %293, %288
  %291 = phi i64 [ %311, %293 ], [ 0, %288 ]
  %292 = icmp slt i64 %291, 16
  br i1 %292, label %293, label %312

293:                                              ; preds = %290
  %294 = mul i64 %291, 128
  %295 = trunc i64 %294 to i32
  %296 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %297 = sext i32 %295 to i64
  %298 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12736 to ptr addrspace(6)), i64 %297
  %299 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %298, i32 0, i32 13, i32 0)
  %300 = call <128 x i16> @llvm.hivm.vcvtii.u82u16.x(<256 x i8> %299, <256 x i1> %296, i32 0)
  %301 = call <128 x i16> @llvm.hivm.vdups.z.v128i16(i16 0, <256 x i1> %289, i32 0)
  %302 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s16(<128 x i16> %300, <128 x i16> %301, <256 x i1> %289)
  %303 = mul i32 %295, 2
  %304 = sext i32 %303 to i64
  %305 = getelementptr i8, ptr addrspace(6) null, i64 %304
  %306 = call <128 x i16> @llvm.hivm.vldsx1.v128s16(ptr addrspace(6) %305, i32 0, i32 0, i32 0)
  %307 = call <128 x i16> @llvm.hivm.vdups.z.v128i16(i16 32767, <256 x i1> %289, i32 0)
  %308 = call <128 x i16> @llvm.hivm.vsel.v128i16(<128 x i16> %306, <128 x i16> %307, <256 x i1> %302)
  %309 = sext i32 %303 to i64
  %310 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), i64 %309
  call void @llvm.hivm.vstsx1.v128s16(<128 x i16> %308, ptr addrspace(6) %310, i32 0, i32 1, i32 0, <256 x i1> %289)
  %311 = add i64 %291, 1
  br label %290

312:                                              ; preds = %290
  br label %313

313:                                              ; preds = %312
  %314 = add i32 %286, 1
  br label %285, !llvm.loop !19

315:                                              ; preds = %285
  br label %316

316:                                              ; preds = %339, %315
  %317 = phi i32 [ %340, %339 ], [ 0, %315 ]
  %318 = icmp sle i32 %317, 0
  br i1 %318, label %319, label %341

319:                                              ; preds = %316
  %320 = call { <256 x i1>, i32 } @llvm.hivm.plt.b16.v300(i32 32)
  %321 = extractvalue { <256 x i1>, i32 } %320, 0
  %322 = extractvalue { <256 x i1>, i32 } %320, 1
  %323 = call <256 x i1> @llvm.hivm.pset.b16(i32 2)
  br label %324

324:                                              ; preds = %327, %319
  %325 = phi i64 [ %337, %327 ], [ 0, %319 ]
  %326 = icmp slt i64 %325, 64
  br i1 %326, label %327, label %338

327:                                              ; preds = %324
  %328 = trunc i64 %325 to i32
  %329 = mul i32 %328, 64
  %330 = sext i32 %329 to i64
  %331 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), i64 %330
  %332 = call <128 x i16> @llvm.hivm.vldsx1.v128s16(ptr addrspace(6) %331, i32 0, i32 0, i32 0)
  %333 = call <128 x i16> @llvm.hivm.vcmin.s.x.v128i16(<128 x i16> %332, <256 x i1> %321)
  %334 = mul i32 %328, 2
  %335 = sext i32 %334 to i64
  %336 = getelementptr i8, ptr addrspace(6) inttoptr (i64 16544 to ptr addrspace(6)), i64 %335
  call void @llvm.hivm.vstsx1.v128s16(<128 x i16> %333, ptr addrspace(6) %336, i32 0, i32 4, i32 0, <256 x i1> %323)
  %337 = add i64 %325, 1
  br label %324

338:                                              ; preds = %324
  br label %339

339:                                              ; preds = %338
  %340 = add i32 %317, 1
  br label %316, !llvm.loop !20

341:                                              ; preds = %316
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %342 = ptrtoint ptr addrspace(1) %1 to i64
  %343 = inttoptr i64 %342 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %343, ptr addrspace(6) inttoptr (i64 16544 to ptr addrspace(6)), i64 288230377225453632, i64 35184372088864)
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
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b16.v300(i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b16(i32)

; Unknown intrinsic
declare <128 x i16> @llvm.hivm.vldsx1.v128s16(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <128 x i16> @llvm.hivm.vcmin.s.x.v128i16(<128 x i16>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v128s16(<128 x i16>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b8(i32)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <128 x i16> @llvm.hivm.vcvtii.u82u16.x(<256 x i8>, <256 x i1>, i32)

; Unknown intrinsic
declare <128 x i16> @llvm.hivm.vdups.z.v128i16(i16, <256 x i1>, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.vcmp.ne.s.z.s16(<128 x i16>, <128 x i16>, <256 x i1>)

; Unknown intrinsic
declare <128 x i16> @llvm.hivm.vsel.v128i16(<128 x i16>, <128 x i16>, <256 x i1>)

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
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32>, <64 x i32>, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.ppack.z(<256 x i1>, i32)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vci.v64i32(i32, i32)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64s32(<64 x i32>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vdups.z.v64i32(i32, <256 x i1>, i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @otr_min_d1_i16, !"kernel", i32 1}
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
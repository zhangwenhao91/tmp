; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @otr_min_d1_i8_s3(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
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

10:                                               ; preds = %329, %2
  ret void

11:                                               ; preds = %17, %9
  %12 = phi i32 [ %18, %17 ], [ 0, %9 ]
  %13 = icmp sle i32 %12, 0
  br i1 %13, label %14, label %19

14:                                               ; preds = %11
  %15 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %16 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 48, <256 x i1> %15, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %16, ptr addrspace(6) inttoptr (i64 10816 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %15)
  br label %17

17:                                               ; preds = %14
  %18 = add i32 %12, 1
  br label %11, !llvm.loop !2

19:                                               ; preds = %11
  br label %20

20:                                               ; preds = %26, %19
  %21 = phi i32 [ %27, %26 ], [ 0, %19 ]
  %22 = icmp sle i32 %21, 0
  br i1 %22, label %23, label %28

23:                                               ; preds = %20
  %24 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %25 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %24, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %25, ptr addrspace(6) inttoptr (i64 11072 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %24)
  br label %26

26:                                               ; preds = %23
  %27 = add i32 %21, 1
  br label %20, !llvm.loop !4

28:                                               ; preds = %20
  br label %29

29:                                               ; preds = %37, %28
  %30 = phi i32 [ %38, %37 ], [ 0, %28 ]
  %31 = icmp sle i32 %30, 0
  br i1 %31, label %32, label %39

32:                                               ; preds = %29
  %33 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %34 = extractvalue { <256 x i1>, i32 } %33, 0
  %35 = extractvalue { <256 x i1>, i32 } %33, 1
  %36 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 32, <256 x i1> %34, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %36, ptr addrspace(6) inttoptr (i64 11072 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %34)
  br label %37

37:                                               ; preds = %32
  %38 = add i32 %30, 1
  br label %29, !llvm.loop !5

39:                                               ; preds = %29
  br label %40

40:                                               ; preds = %46, %39
  %41 = phi i32 [ %47, %46 ], [ 0, %39 ]
  %42 = icmp sle i32 %41, 0
  br i1 %42, label %43, label %48

43:                                               ; preds = %40
  %44 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %45 = call <64 x i32> @llvm.hivm.vdups.z.v64i32(i32 0, <256 x i1> %44, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %45, ptr addrspace(6) inttoptr (i64 11328 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %44)
  br label %46

46:                                               ; preds = %43
  %47 = add i32 %41, 1
  br label %40, !llvm.loop !6

48:                                               ; preds = %40
  br label %49

49:                                               ; preds = %57, %48
  %50 = phi i32 [ %58, %57 ], [ 0, %48 ]
  %51 = icmp sle i32 %50, 0
  br i1 %51, label %52, label %59

52:                                               ; preds = %49
  %53 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 0, i32 0)
  %54 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %55 = extractvalue { <256 x i1>, i32 } %54, 0
  %56 = extractvalue { <256 x i1>, i32 } %54, 1
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %53, ptr addrspace(6) inttoptr (i64 11328 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %55)
  br label %57

57:                                               ; preds = %52
  %58 = add i32 %50, 1
  br label %49, !llvm.loop !7

59:                                               ; preds = %49
  br label %60

60:                                               ; preds = %66, %59
  %61 = phi i32 [ %67, %66 ], [ 0, %59 ]
  %62 = icmp sle i32 %61, 0
  br i1 %62, label %63, label %68

63:                                               ; preds = %60
  %64 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %65 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 0, i32 0)
  call void @llvm.hivm.vstsx1.v64s32(<64 x i32> %65, ptr addrspace(6) inttoptr (i64 11584 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %64)
  br label %66

66:                                               ; preds = %63
  %67 = add i32 %61, 1
  br label %60, !llvm.loop !8

68:                                               ; preds = %60
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
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %77, ptr addrspace(6) inttoptr (i64 11840 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %73)
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
  %85 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 11072 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %86 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 11328 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %87 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %88 = call <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32> %86, <64 x i32> %85, <256 x i1> %87)
  %89 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 32)
  %90 = extractvalue { <256 x i1>, i32 } %89, 0
  %91 = extractvalue { <256 x i1>, i32 } %89, 1
  %92 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %88, i32 0)
  %93 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %92, i32 0)
  %94 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %90, i32 0)
  %95 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %90, i32 0)
  %96 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %95, <256 x i8> %94, <256 x i1> %93)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %96, ptr addrspace(6) inttoptr (i64 11840 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %90)
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
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %108, ptr addrspace(6) inttoptr (i64 12096 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %104)
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
  %116 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 10816 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %117 = call <64 x i32> @llvm.hivm.vldsx1.v64s32(ptr addrspace(6) inttoptr (i64 11584 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %118 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %119 = call <256 x i1> @llvm.hivm.vcmp.lt.s.z.s32(<64 x i32> %117, <64 x i32> %116, <256 x i1> %118)
  %120 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 64)
  %121 = extractvalue { <256 x i1>, i32 } %120, 0
  %122 = extractvalue { <256 x i1>, i32 } %120, 1
  %123 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %119, i32 0)
  %124 = call <256 x i1> @llvm.hivm.ppack.z(<256 x i1> %123, i32 0)
  %125 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %121, i32 0)
  %126 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %121, i32 0)
  %127 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %126, <256 x i8> %125, <256 x i1> %124)
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %127, ptr addrspace(6) inttoptr (i64 12096 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %121)
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
  %144 = getelementptr i8, ptr addrspace(6) null, i64 %143
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %136, ptr addrspace(6) %144, i32 0, i32 0, i32 0, <256 x i1> %135)
  %145 = add i64 %138, 1
  br label %137

146:                                              ; preds = %137
  %147 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 192)
  %148 = extractvalue { <256 x i1>, i32 } %147, 0
  %149 = extractvalue { <256 x i1>, i32 } %147, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %136, ptr addrspace(6) inttoptr (i64 2048 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %148)
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
  %157 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 64)
  %158 = extractvalue { <256 x i1>, i32 } %157, 0
  %159 = extractvalue { <256 x i1>, i32 } %157, 1
  br label %160

160:                                              ; preds = %163, %156
  %161 = phi i64 [ %171, %163 ], [ 0, %156 ]
  %162 = icmp slt i64 %161, 32
  br i1 %162, label %163, label %172

163:                                              ; preds = %160
  %164 = trunc i64 %161 to i32
  %165 = sext i32 %164 to i64
  %166 = getelementptr i8, ptr addrspace(6) inttoptr (i64 11840 to ptr addrspace(6)), i64 %165
  %167 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %166, i32 0, i32 1, i32 0)
  %168 = mul i32 %164, 64
  %169 = sext i32 %168 to i64
  %170 = getelementptr i8, ptr addrspace(6) null, i64 %169
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
  %189 = getelementptr i8, ptr addrspace(6) inttoptr (i64 2240 to ptr addrspace(6)), i64 %188
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %181, ptr addrspace(6) %189, i32 0, i32 0, i32 0, <256 x i1> %180)
  %190 = add i64 %183, 1
  br label %182

191:                                              ; preds = %182
  %192 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 192)
  %193 = extractvalue { <256 x i1>, i32 } %192, 0
  %194 = extractvalue { <256 x i1>, i32 } %192, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %181, ptr addrspace(6) inttoptr (i64 4288 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %193)
  br label %195

195:                                              ; preds = %191
  %196 = add i32 %177, 1
  br label %176, !llvm.loop !15

197:                                              ; preds = %176
  br label %198

198:                                              ; preds = %216, %197
  %199 = phi i32 [ %217, %216 ], [ 0, %197 ]
  %200 = icmp sle i32 %199, 0
  br i1 %200, label %201, label %218

201:                                              ; preds = %198
  %202 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 64)
  %203 = extractvalue { <256 x i1>, i32 } %202, 0
  %204 = extractvalue { <256 x i1>, i32 } %202, 1
  br label %205

205:                                              ; preds = %208, %201
  %206 = phi i64 [ %214, %208 ], [ 0, %201 ]
  %207 = icmp slt i64 %206, 32
  br i1 %207, label %208, label %215

208:                                              ; preds = %205
  %209 = trunc i64 %206 to i32
  %210 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) inttoptr (i64 12096 to ptr addrspace(6)), i32 0, i32 20, i32 0)
  %211 = mul i32 %209, 64
  %212 = sext i32 %211 to i64
  %213 = getelementptr i8, ptr addrspace(6) inttoptr (i64 2240 to ptr addrspace(6)), i64 %212
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %210, ptr addrspace(6) %213, i32 0, i32 12, i32 0, <256 x i1> %203)
  %214 = add i64 %206, 1
  br label %205

215:                                              ; preds = %205
  br label %216

216:                                              ; preds = %215
  %217 = add i32 %199, 1
  br label %198, !llvm.loop !16

218:                                              ; preds = %198
  br label %219

219:                                              ; preds = %238, %218
  %220 = phi i32 [ %239, %238 ], [ 0, %218 ]
  %221 = icmp sle i32 %220, 0
  br i1 %221, label %222, label %240

222:                                              ; preds = %219
  %223 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  %224 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %223, i32 0)
  br label %225

225:                                              ; preds = %228, %222
  %226 = phi i64 [ %233, %228 ], [ 0, %222 ]
  %227 = icmp slt i64 %226, 8
  br i1 %227, label %228, label %234

228:                                              ; preds = %225
  %229 = trunc i64 %226 to i32
  %230 = mul i32 %229, 256
  %231 = sext i32 %230 to i64
  %232 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4480 to ptr addrspace(6)), i64 %231
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %224, ptr addrspace(6) %232, i32 0, i32 0, i32 0, <256 x i1> %223)
  %233 = add i64 %226, 1
  br label %225

234:                                              ; preds = %225
  %235 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 192)
  %236 = extractvalue { <256 x i1>, i32 } %235, 0
  %237 = extractvalue { <256 x i1>, i32 } %235, 1
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %224, ptr addrspace(6) inttoptr (i64 6528 to ptr addrspace(6)), i32 0, i32 0, i32 0, <256 x i1> %236)
  br label %238

238:                                              ; preds = %234
  %239 = add i32 %220, 1
  br label %219, !llvm.loop !17

240:                                              ; preds = %219
  br label %241

241:                                              ; preds = %272, %240
  %242 = phi i32 [ %273, %272 ], [ 0, %240 ]
  %243 = icmp sle i32 %242, 0
  br i1 %243, label %244, label %274

244:                                              ; preds = %241
  %245 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  br label %246

246:                                              ; preds = %249, %244
  %247 = phi i64 [ %270, %249 ], [ 0, %244 ]
  %248 = icmp slt i64 %247, 8
  br i1 %248, label %249, label %271

249:                                              ; preds = %246
  %250 = trunc i64 %247 to i32
  %251 = udiv i32 %250, 8
  %252 = urem i32 %250, 8
  %253 = mul i32 %252, 256
  %254 = mul i32 %251, 2048
  %255 = add i32 %254, %253
  %256 = sext i32 %255 to i64
  %257 = getelementptr i8, ptr addrspace(6) null, i64 %256
  %258 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %257, i32 0, i32 0, i32 0)
  %259 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %245, i32 0)
  %260 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %258, <256 x i8> %259, <256 x i1> %245)
  %261 = sext i32 %255 to i64
  %262 = getelementptr i8, ptr addrspace(6) inttoptr (i64 2240 to ptr addrspace(6)), i64 %261
  %263 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %262, i32 0, i32 0, i32 0)
  %264 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %263, <256 x i8> %259, <256 x i1> %245)
  %265 = call <256 x i1> @llvm.hivm.pand.z(<256 x i1> %260, <256 x i1> %264, <256 x i1> %245)
  %266 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 1, <256 x i1> %245, i32 0)
  %267 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %266, <256 x i8> %259, <256 x i1> %265)
  %268 = sext i32 %255 to i64
  %269 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4480 to ptr addrspace(6)), i64 %268
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %267, ptr addrspace(6) %269, i32 0, i32 0, i32 0, <256 x i1> %245)
  %270 = add i64 %247, 1
  br label %246

271:                                              ; preds = %246
  br label %272

272:                                              ; preds = %271
  %273 = add i32 %242, 1
  br label %241, !llvm.loop !18

274:                                              ; preds = %241
  %275 = ptrtoint ptr addrspace(1) %0 to i64
  %276 = inttoptr i64 %275 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.s8.DV(ptr addrspace(6) inttoptr (i64 6720 to ptr addrspace(6)), ptr addrspace(1) %276, i64 288230377762324992, i64 70368744177712)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %277

277:                                              ; preds = %302, %274
  %278 = phi i32 [ %303, %302 ], [ 0, %274 ]
  %279 = icmp sle i32 %278, 0
  br i1 %279, label %280, label %304

280:                                              ; preds = %277
  %281 = call <256 x i1> @llvm.hivm.pset.b8(i32 0)
  br label %282

282:                                              ; preds = %285, %280
  %283 = phi i64 [ %300, %285 ], [ 0, %280 ]
  %284 = icmp slt i64 %283, 8
  br i1 %284, label %285, label %301

285:                                              ; preds = %282
  %286 = mul i64 %283, 256
  %287 = trunc i64 %286 to i32
  %288 = sext i32 %287 to i64
  %289 = getelementptr i8, ptr addrspace(6) inttoptr (i64 4480 to ptr addrspace(6)), i64 %288
  %290 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %289, i32 0, i32 0, i32 0)
  %291 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 0, <256 x i1> %281, i32 0)
  %292 = call <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8> %290, <256 x i8> %291, <256 x i1> %281)
  %293 = sext i32 %287 to i64
  %294 = getelementptr i8, ptr addrspace(6) inttoptr (i64 6720 to ptr addrspace(6)), i64 %293
  %295 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %294, i32 0, i32 0, i32 0)
  %296 = call <256 x i8> @llvm.hivm.vdups.z.v256i8(i8 127, <256 x i1> %281, i32 0)
  %297 = call <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8> %295, <256 x i8> %296, <256 x i1> %292)
  %298 = sext i32 %287 to i64
  %299 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8768 to ptr addrspace(6)), i64 %298
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %297, ptr addrspace(6) %299, i32 0, i32 0, i32 0, <256 x i1> %281)
  %300 = add i64 %283, 1
  br label %282

301:                                              ; preds = %282
  br label %302

302:                                              ; preds = %301
  %303 = add i32 %278, 1
  br label %277, !llvm.loop !19

304:                                              ; preds = %277
  br label %305

305:                                              ; preds = %327, %304
  %306 = phi i32 [ %328, %327 ], [ 0, %304 ]
  %307 = icmp sle i32 %306, 0
  br i1 %307, label %308, label %329

308:                                              ; preds = %305
  %309 = call { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32 64)
  %310 = extractvalue { <256 x i1>, i32 } %309, 0
  %311 = extractvalue { <256 x i1>, i32 } %309, 1
  %312 = call <256 x i1> @llvm.hivm.pset.b8(i32 2)
  br label %313

313:                                              ; preds = %316, %308
  %314 = phi i64 [ %325, %316 ], [ 0, %308 ]
  %315 = icmp slt i64 %314, 32
  br i1 %315, label %316, label %326

316:                                              ; preds = %313
  %317 = trunc i64 %314 to i32
  %318 = mul i32 %317, 64
  %319 = sext i32 %318 to i64
  %320 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8768 to ptr addrspace(6)), i64 %319
  %321 = call <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6) %320, i32 0, i32 0, i32 0)
  %322 = call <256 x i8> @llvm.hivm.vcmin.s.x.v256i8(<256 x i8> %321, <256 x i1> %310)
  %323 = sext i32 %317 to i64
  %324 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12352 to ptr addrspace(6)), i64 %323
  call void @llvm.hivm.vstsx1.v256s8(<256 x i8> %322, ptr addrspace(6) %324, i32 0, i32 3, i32 0, <256 x i1> %312)
  %325 = add i64 %314, 1
  br label %313

326:                                              ; preds = %313
  br label %327

327:                                              ; preds = %326
  %328 = add i32 %306, 1
  br label %305, !llvm.loop !20

329:                                              ; preds = %305
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %330 = ptrtoint ptr addrspace(1) %1 to i64
  %331 = inttoptr i64 %330 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %331, ptr addrspace(6) inttoptr (i64 12352 to ptr addrspace(6)), i64 288230377225453584, i64 35184372088864)
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
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.s8.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b8.v300(i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b8(i32)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vldsx1.v256s8(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vcmin.s.x.v256i8(<256 x i8>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v256s8(<256 x i8>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vdups.z.v256i8(i8, <256 x i1>, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.vcmp.ne.s.z.s8(<256 x i8>, <256 x i8>, <256 x i1>)

; Unknown intrinsic
declare <256 x i8> @llvm.hivm.vsel.v256i8(<256 x i8>, <256 x i8>, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pand.z(<256 x i1>, <256 x i1>, <256 x i1>)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

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
declare void @llvm.hivm.vstsx1.v64s32(<64 x i32>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <64 x i32> @llvm.hivm.vdups.z.v64i32(i32, <256 x i1>, i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @otr_min_d1_i8_s3, !"kernel", i32 1}
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
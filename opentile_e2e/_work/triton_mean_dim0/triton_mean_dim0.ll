; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @triton_mean_dim0(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
  %3 = call i64 @llvm.hivm.GET.CTRL()
  %4 = call i64 @llvm.hivm.SBITSET0(i64 %3, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %4)
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET1(i64 %5, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %9, label %32

9:                                                ; preds = %2
  br label %33

10:                                               ; preds = %29, %52
  %11 = phi i64 [ 0, %52 ], [ %30, %29 ]
  %12 = icmp slt i64 %11, 128
  br i1 %12, label %13, label %31

13:                                               ; preds = %10
  br label %14

14:                                               ; preds = %17, %13
  %15 = phi i64 [ %28, %17 ], [ 0, %13 ]
  %16 = icmp slt i64 %15, 3
  br i1 %16, label %17, label %29

17:                                               ; preds = %14
  %18 = ptrtoint ptr addrspace(1) %0 to i64
  %19 = inttoptr i64 %18 to ptr addrspace(1)
  %20 = mul i64 %11, 3
  %21 = add i64 %20, %15
  %22 = getelementptr half, ptr addrspace(1) %19, i64 %21
  %23 = load half, ptr addrspace(1) %22, align 2
  %24 = mul i64 %11, 8
  %25 = add i64 %24, %15
  %26 = mul i64 %25, 2
  %27 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %26
  store half %23, ptr addrspace(6) %27, align 2
  %28 = add i64 %15, 1
  br label %14

29:                                               ; preds = %14
  %30 = add i64 %11, 1
  br label %10

31:                                               ; preds = %10
  call void @llvm.hivm.BARRIER(i64 6)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %53

32:                                               ; preds = %193, %2
  ret void

33:                                               ; preds = %50, %9
  %34 = phi i32 [ %51, %50 ], [ 0, %9 ]
  %35 = icmp sle i32 %34, 0
  br i1 %35, label %36, label %52

36:                                               ; preds = %33
  %37 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %38

38:                                               ; preds = %41, %36
  %39 = phi i64 [ %48, %41 ], [ 0, %36 ]
  %40 = icmp slt i64 %39, 16
  br i1 %40, label %41, label %49

41:                                               ; preds = %38
  %42 = mul i64 %39, 128
  %43 = call <128 x half> @llvm.hivm.vdups.z.v128f16(half 0xH0000, <256 x i1> %37, i32 0)
  %44 = trunc i64 %42 to i32
  %45 = mul i32 %44, 2
  %46 = sext i32 %45 to i64
  %47 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %46
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %43, ptr addrspace(6) %47, i32 0, i32 1, i32 0, <256 x i1> %37)
  %48 = add i64 %39, 1
  br label %38

49:                                               ; preds = %38
  br label %50

50:                                               ; preds = %49
  %51 = add i32 %34, 1
  br label %33, !llvm.loop !2

52:                                               ; preds = %33
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %10

53:                                               ; preds = %82, %31
  %54 = phi i32 [ %83, %82 ], [ 0, %31 ]
  %55 = icmp sle i32 %54, 0
  br i1 %55, label %56, label %84

56:                                               ; preds = %53
  %57 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  %58 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  br label %59

59:                                               ; preds = %62, %56
  %60 = phi i64 [ %80, %62 ], [ 0, %56 ]
  %61 = icmp slt i64 %60, 16
  br i1 %61, label %62, label %81

62:                                               ; preds = %59
  %63 = trunc i64 %60 to i32
  %64 = mul i32 %63, 256
  %65 = mul i32 %63, 512
  %66 = sext i32 %64 to i64
  %67 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %66
  %68 = call <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6) %67, i32 0, i32 14, i32 0)
  %69 = call <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half> %68, <256 x i1> %57, i32 0)
  %70 = sext i32 %65 to i64
  %71 = getelementptr i8, ptr addrspace(6) null, i64 %70
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %69, ptr addrspace(6) %71, i32 0, i32 2, i32 0, <256 x i1> %58)
  %72 = add i32 %64, 128
  %73 = add i32 %65, 256
  %74 = sext i32 %72 to i64
  %75 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %74
  %76 = call <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6) %75, i32 0, i32 14, i32 0)
  %77 = call <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half> %76, <256 x i1> %57, i32 0)
  %78 = sext i32 %73 to i64
  %79 = getelementptr i8, ptr addrspace(6) null, i64 %78
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %77, ptr addrspace(6) %79, i32 0, i32 2, i32 0, <256 x i1> %58)
  %80 = add i64 %60, 1
  br label %59

81:                                               ; preds = %59
  br label %82

82:                                               ; preds = %81
  %83 = add i32 %54, 1
  br label %53, !llvm.loop !4

84:                                               ; preds = %53
  br label %85

85:                                               ; preds = %106, %84
  %86 = phi i32 [ %107, %106 ], [ 0, %84 ]
  %87 = icmp sle i32 %86, 0
  br i1 %87, label %88, label %108

88:                                               ; preds = %85
  %89 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 8)
  %90 = extractvalue { <256 x i1>, i32 } %89, 0
  %91 = extractvalue { <256 x i1>, i32 } %89, 1
  %92 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 0.000000e+00, <256 x i1> %90, i32 0)
  br label %93

93:                                               ; preds = %97, %88
  %94 = phi i64 [ %104, %97 ], [ 0, %88 ]
  %95 = phi <64 x float> [ %103, %97 ], [ %92, %88 ]
  %96 = icmp slt i64 %94, 256
  br i1 %96, label %97, label %105

97:                                               ; preds = %93
  %98 = trunc i64 %94 to i32
  %99 = mul i32 %98, 32
  %100 = sext i32 %99 to i64
  %101 = getelementptr i8, ptr addrspace(6) null, i64 %100
  %102 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %101, i32 0, i32 0, i32 0)
  %103 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %95, <64 x float> %102, <256 x i1> %90)
  %104 = add i64 %94, 1
  br label %93

105:                                              ; preds = %93
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %95, ptr addrspace(6) inttoptr (i64 12288 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %90)
  br label %106

106:                                              ; preds = %105
  %107 = add i32 %86, 1
  br label %85, !llvm.loop !5

108:                                              ; preds = %85
  br label %109

109:                                              ; preds = %130, %108
  %110 = phi i32 [ %131, %130 ], [ 0, %108 ]
  %111 = icmp sle i32 %110, 0
  br i1 %111, label %112, label %132

112:                                              ; preds = %109
  %113 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  %114 = call <256 x i1> @llvm.hivm.pset.b16(i32 2)
  br label %115

115:                                              ; preds = %118, %112
  %116 = phi i64 [ %128, %118 ], [ 0, %112 ]
  %117 = icmp slt i64 %116, 8
  br i1 %117, label %118, label %129

118:                                              ; preds = %115
  %119 = trunc i64 %116 to i32
  %120 = mul i32 %119, 4
  %121 = sext i32 %120 to i64
  %122 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12288 to ptr addrspace(6)), i64 %121
  %123 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %122, i32 0, i32 3, i32 0)
  %124 = call <128 x half> @llvm.hivm.vcvtff.f322f16.x(<64 x float> %123, <256 x i1> %113, i32 0, i32 0, i32 0)
  %125 = mul i32 %119, 2
  %126 = sext i32 %125 to i64
  %127 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12320 to ptr addrspace(6)), i64 %126
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %124, ptr addrspace(6) %127, i32 0, i32 4, i32 0, <256 x i1> %114)
  %128 = add i64 %116, 1
  br label %115

129:                                              ; preds = %115
  br label %130

130:                                              ; preds = %129
  %131 = add i32 %110, 1
  br label %109, !llvm.loop !6

132:                                              ; preds = %109
  br label %133

133:                                              ; preds = %154, %132
  %134 = phi i32 [ %155, %154 ], [ 0, %132 ]
  %135 = icmp sle i32 %134, 0
  br i1 %135, label %136, label %156

136:                                              ; preds = %133
  %137 = call <256 x i1> @llvm.hivm.pset.b16(i32 2)
  %138 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %139

139:                                              ; preds = %142, %136
  %140 = phi i64 [ %152, %142 ], [ 0, %136 ]
  %141 = icmp slt i64 %140, 8
  br i1 %141, label %142, label %153

142:                                              ; preds = %139
  %143 = trunc i64 %140 to i32
  %144 = mul i32 %143, 2
  %145 = mul i32 %143, 4
  %146 = sext i32 %144 to i64
  %147 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12320 to ptr addrspace(6)), i64 %146
  %148 = call <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6) %147, i32 0, i32 2, i32 0)
  %149 = call <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half> %148, <256 x i1> %137, i32 0)
  %150 = sext i32 %145 to i64
  %151 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12352 to ptr addrspace(6)), i64 %150
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %149, ptr addrspace(6) %151, i32 0, i32 5, i32 0, <256 x i1> %138)
  %152 = add i64 %140, 1
  br label %139

153:                                              ; preds = %139
  br label %154

154:                                              ; preds = %153
  %155 = add i32 %134, 1
  br label %133, !llvm.loop !7

156:                                              ; preds = %133
  br label %157

157:                                              ; preds = %167, %156
  %158 = phi i32 [ %168, %167 ], [ 0, %156 ]
  %159 = icmp sle i32 %158, 0
  br i1 %159, label %160, label %169

160:                                              ; preds = %157
  %161 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) inttoptr (i64 12352 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %162 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 8)
  %163 = extractvalue { <256 x i1>, i32 } %162, 0
  %164 = extractvalue { <256 x i1>, i32 } %162, 1
  %165 = call <64 x float> @llvm.hivm.vdups.z.v64f32(float 1.280000e+02, <256 x i1> %163, i32 0)
  %166 = call <64 x float> @llvm.hivm.vdiv.s.x.v64f32(<64 x float> %161, <64 x float> %165, <256 x i1> %163)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %166, ptr addrspace(6) inttoptr (i64 12384 to ptr addrspace(6)), i32 0, i32 2, i32 0, <256 x i1> %163)
  br label %167

167:                                              ; preds = %160
  %168 = add i32 %158, 1
  br label %157, !llvm.loop !8

169:                                              ; preds = %157
  br label %170

170:                                              ; preds = %191, %169
  %171 = phi i32 [ %192, %191 ], [ 0, %169 ]
  %172 = icmp sle i32 %171, 0
  br i1 %172, label %173, label %193

173:                                              ; preds = %170
  %174 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  %175 = call <256 x i1> @llvm.hivm.pset.b16(i32 2)
  br label %176

176:                                              ; preds = %179, %173
  %177 = phi i64 [ %189, %179 ], [ 0, %173 ]
  %178 = icmp slt i64 %177, 8
  br i1 %178, label %179, label %190

179:                                              ; preds = %176
  %180 = trunc i64 %177 to i32
  %181 = mul i32 %180, 4
  %182 = sext i32 %181 to i64
  %183 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12384 to ptr addrspace(6)), i64 %182
  %184 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %183, i32 0, i32 3, i32 0)
  %185 = call <128 x half> @llvm.hivm.vcvtff.f322f16.x(<64 x float> %184, <256 x i1> %174, i32 0, i32 0, i32 0)
  %186 = mul i32 %180, 2
  %187 = sext i32 %186 to i64
  %188 = getelementptr i8, ptr addrspace(6) inttoptr (i64 12416 to ptr addrspace(6)), i64 %187
  call void @llvm.hivm.vstsx1.v128f16(<128 x half> %185, ptr addrspace(6) %188, i32 0, i32 4, i32 0, <256 x i1> %175)
  %189 = add i64 %177, 1
  br label %176

190:                                              ; preds = %176
  br label %191

191:                                              ; preds = %190
  %192 = add i32 %171, 1
  br label %170, !llvm.loop !9

193:                                              ; preds = %170
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %194 = ptrtoint ptr addrspace(1) %1 to i64
  %195 = inttoptr i64 %194 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %195, ptr addrspace(6) inttoptr (i64 12416 to ptr addrspace(6)), i64 288230376353038352, i64 6597069766662)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %32
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
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b16(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <128 x half> @llvm.hivm.vcvtff.f322f16.x(<64 x float>, <256 x i1>, i32, i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v128f16(<128 x half>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vdups.z.v64f32(float, <256 x i1>, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vdiv.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <128 x half> @llvm.hivm.vldsx1.v128f16(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcvtff.f162f32.x(<128 x half>, <256 x i1>, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <128 x half> @llvm.hivm.vdups.z.v128f16(half, <256 x i1>, i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @triton_mean_dim0, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
!5 = distinct !{!5, !3}
!6 = distinct !{!6, !3}
!7 = distinct !{!7, !3}
!8 = distinct !{!8, !3}
!9 = distinct !{!9, !3}
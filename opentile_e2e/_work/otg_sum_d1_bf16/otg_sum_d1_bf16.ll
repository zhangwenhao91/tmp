; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @otg_sum_d1_bf16(ptr addrspace(1) %0, ptr addrspace(1) %1) #0 {
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

10:                                               ; preds = %303, %2
  ret void

11:                                               ; preds = %28, %9
  %12 = phi i32 [ %29, %28 ], [ 0, %9 ]
  %13 = icmp sle i32 %12, 0
  br i1 %13, label %14, label %30

14:                                               ; preds = %11
  %15 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %16

16:                                               ; preds = %19, %14
  %17 = phi i64 [ %26, %19 ], [ 0, %14 ]
  %18 = icmp slt i64 %17, 16
  br i1 %18, label %19, label %27

19:                                               ; preds = %16
  %20 = mul i64 %17, 128
  %21 = call <128 x bfloat> @llvm.hivm.vdups.z.v128bf16(bfloat 0xR0000, <256 x i1> %15, i32 0)
  %22 = trunc i64 %20 to i32
  %23 = mul i32 %22, 2
  %24 = sext i32 %23 to i64
  %25 = getelementptr i8, ptr addrspace(6) null, i64 %24
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %21, ptr addrspace(6) %25, i32 0, i32 1, i32 0, <256 x i1> %15)
  %26 = add i64 %17, 1
  br label %16

27:                                               ; preds = %16
  br label %28

28:                                               ; preds = %27
  %29 = add i32 %12, 1
  br label %11, !llvm.loop !2

30:                                               ; preds = %11
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 4, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 4, i64 0)
  %31 = ptrtoint ptr addrspace(1) %0 to i64
  %32 = inttoptr i64 %31 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) null, ptr addrspace(1) %32, i64 288230377225454592, i64 70368744177696)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %33

33:                                               ; preds = %301, %30
  %34 = phi i32 [ %302, %301 ], [ 0, %30 ]
  %35 = icmp sle i32 %34, 0
  br i1 %35, label %36, label %303

36:                                               ; preds = %33
  %37 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) null, i32 0, i32 0, i32 0)
  %38 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 64 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %39 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 128 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %40 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 192 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %41 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 256 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %42 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 320 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %43 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 384 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %44 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 448 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %45 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 512 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %46 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 576 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %47 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 640 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %48 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 704 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %49 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 768 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %50 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 832 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %51 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 896 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %52 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 960 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %53 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1024 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %54 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1088 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %55 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1152 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %56 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1216 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %57 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1280 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %58 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1344 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %59 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1408 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %60 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1472 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %61 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1536 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %62 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1600 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %63 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1664 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %64 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1728 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %65 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1792 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %66 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1856 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %67 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1920 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %68 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 1984 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %69 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2048 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %70 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2112 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %71 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2176 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %72 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2240 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %73 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2304 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %74 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2368 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %75 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2432 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %76 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2496 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %77 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2560 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %78 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2624 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %79 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2688 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %80 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2752 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %81 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2816 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %82 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2880 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %83 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 2944 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %84 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3008 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %85 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3072 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %86 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3136 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %87 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3200 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %88 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3264 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %89 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3328 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %90 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3392 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %91 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3456 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %92 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3520 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %93 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3584 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %94 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3648 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %95 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3712 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %96 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3776 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %97 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3840 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %98 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3904 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %99 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 3968 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %100 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) inttoptr (i64 4032 to ptr addrspace(6)), i32 0, i32 0, i32 0)
  %101 = call { <256 x i1>, i32 } @llvm.hivm.plt.b16.v300(i32 32)
  %102 = extractvalue { <256 x i1>, i32 } %101, 0
  %103 = extractvalue { <256 x i1>, i32 } %101, 1
  %104 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %37, <256 x i1> %102, i32 0)
  %105 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 32)
  %106 = extractvalue { <256 x i1>, i32 } %105, 0
  %107 = extractvalue { <256 x i1>, i32 } %105, 1
  %108 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %104, <256 x i1> %106)
  %109 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  %110 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %108, <256 x i1> %109, i32 1, i32 0, i32 0)
  %111 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %38, <256 x i1> %102, i32 0)
  %112 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %111, <256 x i1> %106)
  %113 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %112, <256 x i1> %109, i32 1, i32 0, i32 0)
  %114 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %39, <256 x i1> %102, i32 0)
  %115 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %114, <256 x i1> %106)
  %116 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %115, <256 x i1> %109, i32 1, i32 0, i32 0)
  %117 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %40, <256 x i1> %102, i32 0)
  %118 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %117, <256 x i1> %106)
  %119 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %118, <256 x i1> %109, i32 1, i32 0, i32 0)
  %120 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %41, <256 x i1> %102, i32 0)
  %121 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %120, <256 x i1> %106)
  %122 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %121, <256 x i1> %109, i32 1, i32 0, i32 0)
  %123 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %42, <256 x i1> %102, i32 0)
  %124 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %123, <256 x i1> %106)
  %125 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %124, <256 x i1> %109, i32 1, i32 0, i32 0)
  %126 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %43, <256 x i1> %102, i32 0)
  %127 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %126, <256 x i1> %106)
  %128 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %127, <256 x i1> %109, i32 1, i32 0, i32 0)
  %129 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %44, <256 x i1> %102, i32 0)
  %130 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %129, <256 x i1> %106)
  %131 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %130, <256 x i1> %109, i32 1, i32 0, i32 0)
  %132 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %45, <256 x i1> %102, i32 0)
  %133 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %132, <256 x i1> %106)
  %134 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %133, <256 x i1> %109, i32 1, i32 0, i32 0)
  %135 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %46, <256 x i1> %102, i32 0)
  %136 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %135, <256 x i1> %106)
  %137 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %136, <256 x i1> %109, i32 1, i32 0, i32 0)
  %138 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %47, <256 x i1> %102, i32 0)
  %139 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %138, <256 x i1> %106)
  %140 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %139, <256 x i1> %109, i32 1, i32 0, i32 0)
  %141 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %48, <256 x i1> %102, i32 0)
  %142 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %141, <256 x i1> %106)
  %143 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %142, <256 x i1> %109, i32 1, i32 0, i32 0)
  %144 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %49, <256 x i1> %102, i32 0)
  %145 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %144, <256 x i1> %106)
  %146 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %145, <256 x i1> %109, i32 1, i32 0, i32 0)
  %147 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %50, <256 x i1> %102, i32 0)
  %148 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %147, <256 x i1> %106)
  %149 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %148, <256 x i1> %109, i32 1, i32 0, i32 0)
  %150 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %51, <256 x i1> %102, i32 0)
  %151 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %150, <256 x i1> %106)
  %152 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %151, <256 x i1> %109, i32 1, i32 0, i32 0)
  %153 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %52, <256 x i1> %102, i32 0)
  %154 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %153, <256 x i1> %106)
  %155 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %154, <256 x i1> %109, i32 1, i32 0, i32 0)
  %156 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %53, <256 x i1> %102, i32 0)
  %157 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %156, <256 x i1> %106)
  %158 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %157, <256 x i1> %109, i32 1, i32 0, i32 0)
  %159 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %54, <256 x i1> %102, i32 0)
  %160 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %159, <256 x i1> %106)
  %161 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %160, <256 x i1> %109, i32 1, i32 0, i32 0)
  %162 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %55, <256 x i1> %102, i32 0)
  %163 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %162, <256 x i1> %106)
  %164 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %163, <256 x i1> %109, i32 1, i32 0, i32 0)
  %165 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %56, <256 x i1> %102, i32 0)
  %166 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %165, <256 x i1> %106)
  %167 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %166, <256 x i1> %109, i32 1, i32 0, i32 0)
  %168 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %57, <256 x i1> %102, i32 0)
  %169 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %168, <256 x i1> %106)
  %170 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %169, <256 x i1> %109, i32 1, i32 0, i32 0)
  %171 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %58, <256 x i1> %102, i32 0)
  %172 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %171, <256 x i1> %106)
  %173 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %172, <256 x i1> %109, i32 1, i32 0, i32 0)
  %174 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %59, <256 x i1> %102, i32 0)
  %175 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %174, <256 x i1> %106)
  %176 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %175, <256 x i1> %109, i32 1, i32 0, i32 0)
  %177 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %60, <256 x i1> %102, i32 0)
  %178 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %177, <256 x i1> %106)
  %179 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %178, <256 x i1> %109, i32 1, i32 0, i32 0)
  %180 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %61, <256 x i1> %102, i32 0)
  %181 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %180, <256 x i1> %106)
  %182 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %181, <256 x i1> %109, i32 1, i32 0, i32 0)
  %183 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %62, <256 x i1> %102, i32 0)
  %184 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %183, <256 x i1> %106)
  %185 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %184, <256 x i1> %109, i32 1, i32 0, i32 0)
  %186 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %63, <256 x i1> %102, i32 0)
  %187 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %186, <256 x i1> %106)
  %188 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %187, <256 x i1> %109, i32 1, i32 0, i32 0)
  %189 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %64, <256 x i1> %102, i32 0)
  %190 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %189, <256 x i1> %106)
  %191 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %190, <256 x i1> %109, i32 1, i32 0, i32 0)
  %192 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %65, <256 x i1> %102, i32 0)
  %193 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %192, <256 x i1> %106)
  %194 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %193, <256 x i1> %109, i32 1, i32 0, i32 0)
  %195 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %66, <256 x i1> %102, i32 0)
  %196 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %195, <256 x i1> %106)
  %197 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %196, <256 x i1> %109, i32 1, i32 0, i32 0)
  %198 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %67, <256 x i1> %102, i32 0)
  %199 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %198, <256 x i1> %106)
  %200 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %199, <256 x i1> %109, i32 1, i32 0, i32 0)
  %201 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %68, <256 x i1> %102, i32 0)
  %202 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %201, <256 x i1> %106)
  %203 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %202, <256 x i1> %109, i32 1, i32 0, i32 0)
  %204 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %69, <256 x i1> %102, i32 0)
  %205 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %204, <256 x i1> %106)
  %206 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %205, <256 x i1> %109, i32 1, i32 0, i32 0)
  %207 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %70, <256 x i1> %102, i32 0)
  %208 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %207, <256 x i1> %106)
  %209 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %208, <256 x i1> %109, i32 1, i32 0, i32 0)
  %210 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %71, <256 x i1> %102, i32 0)
  %211 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %210, <256 x i1> %106)
  %212 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %211, <256 x i1> %109, i32 1, i32 0, i32 0)
  %213 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %72, <256 x i1> %102, i32 0)
  %214 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %213, <256 x i1> %106)
  %215 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %214, <256 x i1> %109, i32 1, i32 0, i32 0)
  %216 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %73, <256 x i1> %102, i32 0)
  %217 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %216, <256 x i1> %106)
  %218 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %217, <256 x i1> %109, i32 1, i32 0, i32 0)
  %219 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %74, <256 x i1> %102, i32 0)
  %220 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %219, <256 x i1> %106)
  %221 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %220, <256 x i1> %109, i32 1, i32 0, i32 0)
  %222 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %75, <256 x i1> %102, i32 0)
  %223 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %222, <256 x i1> %106)
  %224 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %223, <256 x i1> %109, i32 1, i32 0, i32 0)
  %225 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %76, <256 x i1> %102, i32 0)
  %226 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %225, <256 x i1> %106)
  %227 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %226, <256 x i1> %109, i32 1, i32 0, i32 0)
  %228 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %77, <256 x i1> %102, i32 0)
  %229 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %228, <256 x i1> %106)
  %230 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %229, <256 x i1> %109, i32 1, i32 0, i32 0)
  %231 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %78, <256 x i1> %102, i32 0)
  %232 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %231, <256 x i1> %106)
  %233 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %232, <256 x i1> %109, i32 1, i32 0, i32 0)
  %234 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %79, <256 x i1> %102, i32 0)
  %235 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %234, <256 x i1> %106)
  %236 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %235, <256 x i1> %109, i32 1, i32 0, i32 0)
  %237 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %80, <256 x i1> %102, i32 0)
  %238 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %237, <256 x i1> %106)
  %239 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %238, <256 x i1> %109, i32 1, i32 0, i32 0)
  %240 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %81, <256 x i1> %102, i32 0)
  %241 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %240, <256 x i1> %106)
  %242 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %241, <256 x i1> %109, i32 1, i32 0, i32 0)
  %243 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %82, <256 x i1> %102, i32 0)
  %244 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %243, <256 x i1> %106)
  %245 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %244, <256 x i1> %109, i32 1, i32 0, i32 0)
  %246 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %83, <256 x i1> %102, i32 0)
  %247 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %246, <256 x i1> %106)
  %248 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %247, <256 x i1> %109, i32 1, i32 0, i32 0)
  %249 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %84, <256 x i1> %102, i32 0)
  %250 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %249, <256 x i1> %106)
  %251 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %250, <256 x i1> %109, i32 1, i32 0, i32 0)
  %252 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %85, <256 x i1> %102, i32 0)
  %253 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %252, <256 x i1> %106)
  %254 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %253, <256 x i1> %109, i32 1, i32 0, i32 0)
  %255 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %86, <256 x i1> %102, i32 0)
  %256 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %255, <256 x i1> %106)
  %257 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %256, <256 x i1> %109, i32 1, i32 0, i32 0)
  %258 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %87, <256 x i1> %102, i32 0)
  %259 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %258, <256 x i1> %106)
  %260 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %259, <256 x i1> %109, i32 1, i32 0, i32 0)
  %261 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %88, <256 x i1> %102, i32 0)
  %262 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %261, <256 x i1> %106)
  %263 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %262, <256 x i1> %109, i32 1, i32 0, i32 0)
  %264 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %89, <256 x i1> %102, i32 0)
  %265 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %264, <256 x i1> %106)
  %266 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %265, <256 x i1> %109, i32 1, i32 0, i32 0)
  %267 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %90, <256 x i1> %102, i32 0)
  %268 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %267, <256 x i1> %106)
  %269 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %268, <256 x i1> %109, i32 1, i32 0, i32 0)
  %270 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %91, <256 x i1> %102, i32 0)
  %271 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %270, <256 x i1> %106)
  %272 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %271, <256 x i1> %109, i32 1, i32 0, i32 0)
  %273 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %92, <256 x i1> %102, i32 0)
  %274 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %273, <256 x i1> %106)
  %275 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %274, <256 x i1> %109, i32 1, i32 0, i32 0)
  %276 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %93, <256 x i1> %102, i32 0)
  %277 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %276, <256 x i1> %106)
  %278 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %277, <256 x i1> %109, i32 1, i32 0, i32 0)
  %279 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %94, <256 x i1> %102, i32 0)
  %280 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %279, <256 x i1> %106)
  %281 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %280, <256 x i1> %109, i32 1, i32 0, i32 0)
  %282 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %95, <256 x i1> %102, i32 0)
  %283 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %282, <256 x i1> %106)
  %284 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %283, <256 x i1> %109, i32 1, i32 0, i32 0)
  %285 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %96, <256 x i1> %102, i32 0)
  %286 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %285, <256 x i1> %106)
  %287 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %286, <256 x i1> %109, i32 1, i32 0, i32 0)
  %288 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %97, <256 x i1> %102, i32 0)
  %289 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %288, <256 x i1> %106)
  %290 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %289, <256 x i1> %109, i32 1, i32 0, i32 0)
  %291 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %98, <256 x i1> %102, i32 0)
  %292 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %291, <256 x i1> %106)
  %293 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %292, <256 x i1> %109, i32 1, i32 0, i32 0)
  %294 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %99, <256 x i1> %102, i32 0)
  %295 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %294, <256 x i1> %106)
  %296 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %295, <256 x i1> %109, i32 1, i32 0, i32 0)
  %297 = call <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat> %100, <256 x i1> %102, i32 0)
  %298 = call <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float> %297, <256 x i1> %106)
  %299 = call <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float> %298, <256 x i1> %109, i32 1, i32 0, i32 0)
  %300 = call <256 x i1> @llvm.hivm.pset.b16(i32 2)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %110, ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %113, ptr addrspace(6) inttoptr (i64 4098 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %116, ptr addrspace(6) inttoptr (i64 4100 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %119, ptr addrspace(6) inttoptr (i64 4102 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %122, ptr addrspace(6) inttoptr (i64 4104 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %125, ptr addrspace(6) inttoptr (i64 4106 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %128, ptr addrspace(6) inttoptr (i64 4108 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %131, ptr addrspace(6) inttoptr (i64 4110 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %134, ptr addrspace(6) inttoptr (i64 4112 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %137, ptr addrspace(6) inttoptr (i64 4114 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %140, ptr addrspace(6) inttoptr (i64 4116 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %143, ptr addrspace(6) inttoptr (i64 4118 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %146, ptr addrspace(6) inttoptr (i64 4120 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %149, ptr addrspace(6) inttoptr (i64 4122 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %152, ptr addrspace(6) inttoptr (i64 4124 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %155, ptr addrspace(6) inttoptr (i64 4126 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %158, ptr addrspace(6) inttoptr (i64 4128 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %161, ptr addrspace(6) inttoptr (i64 4130 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %164, ptr addrspace(6) inttoptr (i64 4132 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %167, ptr addrspace(6) inttoptr (i64 4134 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %170, ptr addrspace(6) inttoptr (i64 4136 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %173, ptr addrspace(6) inttoptr (i64 4138 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %176, ptr addrspace(6) inttoptr (i64 4140 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %179, ptr addrspace(6) inttoptr (i64 4142 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %182, ptr addrspace(6) inttoptr (i64 4144 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %185, ptr addrspace(6) inttoptr (i64 4146 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %188, ptr addrspace(6) inttoptr (i64 4148 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %191, ptr addrspace(6) inttoptr (i64 4150 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %194, ptr addrspace(6) inttoptr (i64 4152 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %197, ptr addrspace(6) inttoptr (i64 4154 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %200, ptr addrspace(6) inttoptr (i64 4156 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %203, ptr addrspace(6) inttoptr (i64 4158 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %206, ptr addrspace(6) inttoptr (i64 4160 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %209, ptr addrspace(6) inttoptr (i64 4162 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %212, ptr addrspace(6) inttoptr (i64 4164 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %215, ptr addrspace(6) inttoptr (i64 4166 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %218, ptr addrspace(6) inttoptr (i64 4168 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %221, ptr addrspace(6) inttoptr (i64 4170 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %224, ptr addrspace(6) inttoptr (i64 4172 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %227, ptr addrspace(6) inttoptr (i64 4174 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %230, ptr addrspace(6) inttoptr (i64 4176 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %233, ptr addrspace(6) inttoptr (i64 4178 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %236, ptr addrspace(6) inttoptr (i64 4180 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %239, ptr addrspace(6) inttoptr (i64 4182 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %242, ptr addrspace(6) inttoptr (i64 4184 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %245, ptr addrspace(6) inttoptr (i64 4186 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %248, ptr addrspace(6) inttoptr (i64 4188 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %251, ptr addrspace(6) inttoptr (i64 4190 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %254, ptr addrspace(6) inttoptr (i64 4192 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %257, ptr addrspace(6) inttoptr (i64 4194 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %260, ptr addrspace(6) inttoptr (i64 4196 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %263, ptr addrspace(6) inttoptr (i64 4198 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %266, ptr addrspace(6) inttoptr (i64 4200 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %269, ptr addrspace(6) inttoptr (i64 4202 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %272, ptr addrspace(6) inttoptr (i64 4204 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %275, ptr addrspace(6) inttoptr (i64 4206 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %278, ptr addrspace(6) inttoptr (i64 4208 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %281, ptr addrspace(6) inttoptr (i64 4210 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %284, ptr addrspace(6) inttoptr (i64 4212 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %287, ptr addrspace(6) inttoptr (i64 4214 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %290, ptr addrspace(6) inttoptr (i64 4216 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %293, ptr addrspace(6) inttoptr (i64 4218 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %296, ptr addrspace(6) inttoptr (i64 4220 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  call void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat> %299, ptr addrspace(6) inttoptr (i64 4222 to ptr addrspace(6)), i32 0, i32 4, i32 0, <256 x i1> %300)
  br label %301

301:                                              ; preds = %36
  %302 = add i32 %34, 1
  br label %33, !llvm.loop !4

303:                                              ; preds = %33
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %304 = ptrtoint ptr addrspace(1) %1 to i64
  %305 = inttoptr i64 %304 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %305, ptr addrspace(6) inttoptr (i64 4096 to ptr addrspace(6)), i64 288230377225453632, i64 35184372088864)
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
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b16.v300(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcvtff.bf162f32.x(<128 x bfloat>, <256 x i1>, i32)

; Unknown intrinsic
declare { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcadd.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vcvtff.f322bf16.x(<64 x float>, <256 x i1>, i32, i32, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b16(i32)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v128bf16(<128 x bfloat>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vdups.z.v128bf16(bfloat, <256 x i1>, i32)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @otg_sum_d1_bf16, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
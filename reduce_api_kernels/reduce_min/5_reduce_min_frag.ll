; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @reduce_min_frag_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
  %4 = call i64 @llvm.hivm.GET.CTRL()
  %5 = call i64 @llvm.hivm.SBITSET0(i64 %4, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %5)
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET1(i64 %6, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %20

10:                                               ; preds = %3
  %11 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %12 = trunc i64 %11 to i32
  %13 = mul i32 %12, 16
  %14 = sext i32 %13 to i64
  %15 = mul i64 %14, 128
  %16 = ptrtoint ptr addrspace(1) %0 to i64
  %17 = mul i64 %15, 4
  %18 = add i64 %16, %17
  %19 = inttoptr i64 %18 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %19, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 1, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 1, i64 0)
  br label %21

20:                                               ; preds = %69, %3
  ret void

21:                                               ; preds = %51, %10
  %22 = phi i32 [ %52, %51 ], [ 0, %10 ]
  %23 = icmp sle i32 %22, 0
  br i1 %23, label %24, label %53

24:                                               ; preds = %21
  %25 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %26 = call <256 x i1> @llvm.hivm.pset.b32(i32 2)
  br label %27

27:                                               ; preds = %30, %24
  %28 = phi i64 [ %49, %30 ], [ 0, %24 ]
  %29 = icmp slt i64 %28, 16
  br i1 %29, label %30, label %50

30:                                               ; preds = %27
  %31 = trunc i64 %28 to i32
  %32 = mul i32 %31, 128
  %33 = mul i32 %31, 512
  %34 = sext i32 %33 to i64
  %35 = getelementptr i8, ptr addrspace(6) null, i64 %34
  %36 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %35, i32 0, i32 0, i32 0)
  %37 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %36, float -1.000000e+00, <256 x i1> %25)
  %38 = add i32 %32, 64
  %39 = mul i32 %38, 4
  %40 = sext i32 %39 to i64
  %41 = getelementptr i8, ptr addrspace(6) null, i64 %40
  %42 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) %41, i32 0, i32 0, i32 0)
  %43 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %42, float -1.000000e+00, <256 x i1> %25)
  %44 = call <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float> %37, <64 x float> %43, <256 x i1> %25)
  %45 = call <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float> %44, <256 x i1> %25)
  %46 = mul i32 %31, 4
  %47 = sext i32 %46 to i64
  %48 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 %47
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %45, ptr addrspace(6) %48, i32 0, i32 5, i32 0, <256 x i1> %26)
  %49 = add i64 %28, 1
  br label %27

50:                                               ; preds = %27
  br label %51

51:                                               ; preds = %50
  %52 = add i32 %22, 1
  br label %21, !llvm.loop !2

53:                                               ; preds = %21
  br label %54

54:                                               ; preds = %67, %53
  %55 = phi i32 [ %68, %67 ], [ 0, %53 ]
  %56 = icmp sle i32 %55, 0
  br i1 %56, label %57, label %69

57:                                               ; preds = %54
  %58 = call { <256 x i1>, i32 } @llvm.hivm.plt.b32.v300(i32 16)
  %59 = extractvalue { <256 x i1>, i32 } %58, 0
  %60 = extractvalue { <256 x i1>, i32 } %58, 1
  %61 = call <64 x i32> @llvm.hivm.vci.v64i32(i32 0, i32 0)
  %62 = call <64 x float> @llvm.hivm.vgather2.v300.v64f32(ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), <64 x i32> %61, <256 x i1> %59)
  %63 = call <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float> %62, float -1.000000e+00, <256 x i1> %59)
  %64 = call <32 x i8> @llvm.hivm.init.vector.align.data()
  %65 = bitcast <64 x float> %63 to <256 x i8>
  %66 = call <32 x i8> @llvm.hivm.vstus(<256 x i8> %65, ptr addrspace(6) inttoptr (i64 8256 to ptr addrspace(6)), i32 64, <32 x i8> %64)
  call void @llvm.hivm.vstas(<32 x i8> %66, ptr addrspace(6) inttoptr (i64 8256 to ptr addrspace(6)), i32 64, i32 0)
  br label %67

67:                                               ; preds = %57
  %68 = add i32 %55, 1
  br label %54, !llvm.loop !4

69:                                               ; preds = %54
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  %70 = mul i32 %12, 16
  %71 = sext i32 %70 to i64
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  %72 = ptrtoint ptr addrspace(1) %1 to i64
  %73 = mul i64 %71, 4
  %74 = add i64 %72, %73
  %75 = inttoptr i64 %74 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %75, ptr addrspace(6) inttoptr (i64 8256 to ptr addrspace(6)), i64 288230377225453600, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %20
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
declare i64 @llvm.hivm.GET.BLOCK.IDX()

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
declare <64 x i32> @llvm.hivm.vci.v64i32(i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vgather2.v300.v64f32(ptr addrspace(6), <64 x i32>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmuls.s.x.v64f32(<64 x float>, float, <256 x i1>)

; Unknown intrinsic
declare <32 x i8> @llvm.hivm.init.vector.align.data()

; Unknown intrinsic
declare <32 x i8> @llvm.hivm.vstus(<256 x i8>, ptr addrspace(6), i32, <32 x i8>)

; Unknown intrinsic
declare void @llvm.hivm.vstas(<32 x i8>, ptr addrspace(6), i32, i32)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b32(i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vmax.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)

; Unknown intrinsic
declare <64 x float> @llvm.hivm.vcmax.s.x.v64f32(<64 x float>, <256 x i1>)

; Unknown intrinsic
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @reduce_min_frag_kernel, !"kernel", i32 1}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.aivector_scope"}
!4 = distinct !{!4, !3}
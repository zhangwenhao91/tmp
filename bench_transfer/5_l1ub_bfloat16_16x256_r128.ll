; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @l1ub_kernel_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5) #0 {
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET0(i64 %7, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.CTRL()
  %10 = call i64 @llvm.hivm.SBITSET1(i64 %9, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %10)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %11 = ptrtoint ptr addrspace(1) %0 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), ptr addrspace(1) %12, i64 4503599627378688, i64 256)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 5)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %13 = ptrtoint ptr addrspace(1) %1 to i64
  %14 = inttoptr i64 %13 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), ptr addrspace(1) %14, i64 72057594037928448, i64 16)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %15 = ptrtoint ptr addrspace(1) %2 to i64
  %16 = inttoptr i64 %15 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 24576 to ptr addrspace(2)), ptr addrspace(1) %16, i64 72057594037928448, i64 16)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 1)
  br label %17

17:                                               ; preds = %20, %6
  %18 = phi i64 [ %21, %20 ], [ 0, %6 ]
  %19 = icmp slt i64 %18, 128
  br i1 %19, label %20, label %22

20:                                               ; preds = %17
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), i64 16777232)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 6)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 7)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) inttoptr (i64 16384 to ptr addrspace(3)), ptr addrspace(2) null, i64 17596481011712, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) inttoptr (i64 16384 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), i64 1168231104512, i64 65552, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) null, ptr addrspace(3) inttoptr (i64 16384 to ptr addrspace(3)), ptr addrspace(4) inttoptr (i64 16384 to ptr addrspace(4)), i64 -6917529027371597808)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 0)
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), ptr addrspace(2) null, i64 16777232)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 8)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 2)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) inttoptr (i64 24576 to ptr addrspace(3)), ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), i64 17596481011712, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) inttoptr (i64 24576 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 24576 to ptr addrspace(2)), i64 1168231104512, i64 65552, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), ptr addrspace(3) inttoptr (i64 24576 to ptr addrspace(3)), ptr addrspace(4) inttoptr (i64 24576 to ptr addrspace(4)), i64 -6917529027371597808)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 3)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 3, i64 3)
  %21 = add i64 %18, 1
  br label %17

22:                                               ; preds = %17
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 3, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 25600 to ptr addrspace(6)), ptr addrspace(5) null, i64 68720525568, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 9)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 26624 to ptr addrspace(6)), ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), i64 68720525568, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 10)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 4)
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

define dso_local ptc_kernel void @l1ub_kernel_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5) #1 {
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET0(i64 %7, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.CTRL()
  %10 = call i64 @llvm.hivm.SBITSET1(i64 %9, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %10)
  %11 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %13, label %23

13:                                               ; preds = %6
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 5)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 1)
  br label %14

14:                                               ; preds = %85, %13
  %15 = phi i64 [ %86, %85 ], [ 0, %13 ]
  %16 = icmp slt i64 %15, 128
  br i1 %16, label %17, label %18

17:                                               ; preds = %14
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 7)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  br label %24

18:                                               ; preds = %14
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 9)
  %19 = ptrtoint ptr addrspace(1) %3 to i64
  %20 = inttoptr i64 %19 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %20, ptr addrspace(6) inttoptr (i64 25600 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 10)
  %21 = ptrtoint ptr addrspace(1) %4 to i64
  %22 = inttoptr i64 %21 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %22, ptr addrspace(6) inttoptr (i64 26624 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 4)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %23

23:                                               ; preds = %18, %6
  ret void

24:                                               ; preds = %52, %17
  %25 = phi i32 [ %53, %52 ], [ 0, %17 ]
  %26 = icmp sle i32 %25, 0
  br i1 %26, label %27, label %54

27:                                               ; preds = %24
  %28 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %29

29:                                               ; preds = %49, %27
  %30 = phi i64 [ %50, %49 ], [ 0, %27 ]
  %31 = icmp slt i64 %30, 2
  br i1 %31, label %32, label %51

32:                                               ; preds = %29
  br label %33

33:                                               ; preds = %36, %32
  %34 = phi i64 [ %48, %36 ], [ 0, %32 ]
  %35 = icmp slt i64 %34, 16
  br i1 %35, label %36, label %49

36:                                               ; preds = %33
  %37 = mul i64 %34, 256
  %38 = mul i64 %30, 128
  %39 = add i64 %37, %38
  %40 = mul i64 %39, 2
  %41 = getelementptr i8, ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), i64 %40
  %42 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %41, i32 0, i32 0, i32 0)
  %43 = mul i64 %30, 2176
  %44 = mul i64 %34, 16
  %45 = add i64 %43, %44
  %46 = mul i64 %45, 2
  %47 = getelementptr i8, ptr addrspace(6) null, i64 %46
  call void @llvm.hivm.vsstb.v128bf16(<128 x bfloat> %42, ptr addrspace(6) %47, i32 1114112, i32 0, <256 x i1> %28)
  %48 = add i64 %34, 1
  br label %33

49:                                               ; preds = %33
  %50 = add i64 %30, 1
  br label %29

51:                                               ; preds = %29
  br label %52

52:                                               ; preds = %51
  %53 = add i32 %25, 1
  br label %24, !llvm.loop !3

54:                                               ; preds = %24
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) null, ptr addrspace(6) null, i64 4296016128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 1)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 8)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 5, i64 1, i64 1)
  br label %55

55:                                               ; preds = %83, %54
  %56 = phi i32 [ %84, %83 ], [ 0, %54 ]
  %57 = icmp sle i32 %56, 0
  br i1 %57, label %58, label %85

58:                                               ; preds = %55
  %59 = call <256 x i1> @llvm.hivm.pset.b16(i32 0)
  br label %60

60:                                               ; preds = %80, %58
  %61 = phi i64 [ %81, %80 ], [ 0, %58 ]
  %62 = icmp slt i64 %61, 2
  br i1 %62, label %63, label %82

63:                                               ; preds = %60
  br label %64

64:                                               ; preds = %67, %63
  %65 = phi i64 [ %79, %67 ], [ 0, %63 ]
  %66 = icmp slt i64 %65, 16
  br i1 %66, label %67, label %80

67:                                               ; preds = %64
  %68 = mul i64 %65, 256
  %69 = mul i64 %61, 128
  %70 = add i64 %68, %69
  %71 = mul i64 %70, 2
  %72 = getelementptr i8, ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), i64 %71
  %73 = call <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6) %72, i32 0, i32 0, i32 0)
  %74 = mul i64 %61, 2176
  %75 = mul i64 %65, 16
  %76 = add i64 %74, %75
  %77 = mul i64 %76, 2
  %78 = getelementptr i8, ptr addrspace(6) inttoptr (i64 8704 to ptr addrspace(6)), i64 %77
  call void @llvm.hivm.vsstb.v128bf16(<128 x bfloat> %73, ptr addrspace(6) %78, i32 1114112, i32 0, <256 x i1> %59)
  %79 = add i64 %65, 1
  br label %64

80:                                               ; preds = %64
  %81 = add i64 %61, 1
  br label %60

82:                                               ; preds = %60
  br label %83

83:                                               ; preds = %82
  %84 = add i32 %56, 1
  br label %55, !llvm.loop !5

85:                                               ; preds = %55
  call void @llvm.hivm.SET.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 6)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 1, i64 5, i64 0)
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), ptr addrspace(6) inttoptr (i64 8704 to ptr addrspace(6)), i64 4296016128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 5, i64 1, i64 1)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 2)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 3)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 3)
  %86 = add i64 %15, 1
  br label %14
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
declare void @llvm.hivm.SET.MTE2.NZ.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.LOOP3.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6), ptr addrspace(2), i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5), ptr addrspace(3), ptr addrspace(4), i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2), ptr addrspace(6), i64)

; Unknown intrinsic
declare <256 x i1> @llvm.hivm.pset.b16(i32)

; Unknown intrinsic
declare <128 x bfloat> @llvm.hivm.vldsx1.v128bf16(ptr addrspace(6), i32, i32, i32)

; Unknown intrinsic
declare void @llvm.hivm.vsstb.v128bf16(<128 x bfloat>, ptr addrspace(6), i32, i32, <256 x i1>)


attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1, !2}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @l1ub_kernel_mix_aic, !"kernel", i32 1}
!2 = !{ptr @l1ub_kernel_mix_aiv, !"kernel", i32 1}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.aivector_scope"}
!5 = distinct !{!5, !4}
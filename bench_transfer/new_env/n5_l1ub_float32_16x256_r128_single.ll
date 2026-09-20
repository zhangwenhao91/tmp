; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @l1ub_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5) #0 {
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET0(i64 %7, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.CTRL()
  %10 = call i64 @llvm.hivm.SBITSET1(i64 %9, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %10)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %11 = ptrtoint ptr addrspace(1) %0 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) null, ptr addrspace(1) %12, i64 4503599627386880, i64 256)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %13 = ptrtoint ptr addrspace(1) %1 to i64
  %14 = inttoptr i64 %13 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), ptr addrspace(1) %14, i64 72057594037928960, i64 16)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %15 = ptrtoint ptr addrspace(1) %2 to i64
  %16 = inttoptr i64 %15 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), ptr addrspace(1) %16, i64 72057594037928960, i64 16)
  br label %17

17:                                               ; preds = %44, %6
  %18 = phi i64 [ %45, %44 ], [ 0, %6 ]
  %19 = icmp slt i64 %18, 128
  br i1 %19, label %20, label %46

20:                                               ; preds = %17
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) null, ptr addrspace(2) null, i64 33554448)
  br label %21

21:                                               ; preds = %24, %20
  %22 = phi i64 [ %31, %24 ], [ 0, %20 ]
  %23 = icmp slt i64 %22, 32
  br i1 %23, label %24, label %32

24:                                               ; preds = %21
  %25 = mul i64 %22, 8
  %26 = mul i64 %22, 128
  %27 = mul i64 %26, 4
  %28 = getelementptr i8, ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), i64 %27
  %29 = mul i64 %25, 4
  %30 = getelementptr i8, ptr addrspace(6) null, i64 %29
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) %28, ptr addrspace(6) %30, i64 133144051968)
  %31 = add i64 %22, 1
  br label %21

32:                                               ; preds = %21
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.f32(ptr addrspace(3) null, ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), i64 35188667056128, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.f32(ptr addrspace(4) null, ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), i64 2267742732288, i64 65552, i64 1)
  call void @llvm.hivm.MAD.f322f32.c310(ptr addrspace(5) null, ptr addrspace(3) null, ptr addrspace(4) null, i64 -6917529027371597808)
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) null, ptr addrspace(2) inttoptr (i64 49152 to ptr addrspace(2)), i64 33554448)
  br label %33

33:                                               ; preds = %36, %32
  %34 = phi i64 [ %43, %36 ], [ 0, %32 ]
  %35 = icmp slt i64 %34, 32
  br i1 %35, label %36, label %44

36:                                               ; preds = %33
  %37 = mul i64 %34, 8
  %38 = mul i64 %34, 128
  %39 = mul i64 %38, 4
  %40 = getelementptr i8, ptr addrspace(2) null, i64 %39
  %41 = mul i64 %37, 4
  %42 = getelementptr i8, ptr addrspace(6) null, i64 %41
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) %40, ptr addrspace(6) %42, i64 133144051968)
  %43 = add i64 %34, 1
  br label %33

44:                                               ; preds = %33
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.f32(ptr addrspace(3) inttoptr (i64 16384 to ptr addrspace(3)), ptr addrspace(2) null, i64 35188667056128, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.f32(ptr addrspace(4) inttoptr (i64 16384 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 2267742732288, i64 65552, i64 1)
  call void @llvm.hivm.MAD.f322f32.c310(ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), ptr addrspace(3) inttoptr (i64 16384 to ptr addrspace(3)), ptr addrspace(4) inttoptr (i64 16384 to ptr addrspace(4)), i64 -6917529027371597808)
  %45 = add i64 %18, 1
  br label %17

46:                                               ; preds = %17
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), ptr addrspace(5) null, i64 68720525568, i64 8796093022224)
  %47 = ptrtoint ptr addrspace(1) %3 to i64
  %48 = inttoptr i64 %47 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %48, ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), i64 68720525568, i64 8796093022224)
  %49 = ptrtoint ptr addrspace(1) %4 to i64
  %50 = inttoptr i64 %49 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %50, ptr addrspace(6) inttoptr (i64 17408 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  ret void
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
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.LOOP3.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6), ptr addrspace(2), i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.f32(ptr addrspace(3), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.f32(ptr addrspace(4), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MAD.f322f32.c310(ptr addrspace(5), ptr addrspace(3), ptr addrspace(4), i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2), ptr addrspace(6), i64)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @l1ub_kernel, !"kernel", i32 1}
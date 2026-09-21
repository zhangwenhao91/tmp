; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @l1ub_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, ptr addrspace(1) %4, i32 %5) align 256 #0 {
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET0(i64 %7, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.CTRL()
  %10 = call i64 @llvm.hivm.SBITSET1(i64 %9, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %10)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %11 = ptrtoint ptr addrspace(1) %0 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) null, ptr addrspace(1) %12, i64 4503599627378688, i64 256)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %13 = ptrtoint ptr addrspace(1) %1 to i64
  %14 = inttoptr i64 %13 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), ptr addrspace(1) %14, i64 72057594037928448, i64 16)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %15 = ptrtoint ptr addrspace(1) %2 to i64
  %16 = inttoptr i64 %15 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), ptr addrspace(1) %16, i64 72057594037928448, i64 16)
  br label %17

17:                                               ; preds = %20, %6
  %18 = phi i64 [ %21, %20 ], [ 0, %6 ]
  %19 = icmp slt i64 %18, 128
  br i1 %19, label %20, label %22

20:                                               ; preds = %17
  call void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6) null, ptr addrspace(2) null, i64 16777232)
  %21 = add i64 %18, 1
  br label %17

22:                                               ; preds = %17
  br label %23

23:                                               ; preds = %26, %22
  %24 = phi i64 [ %33, %26 ], [ 0, %22 ]
  %25 = icmp slt i64 %24, 16
  br i1 %25, label %26, label %34

26:                                               ; preds = %23
  %27 = mul i64 %24, 16
  %28 = mul i64 %24, 256
  %29 = mul i64 %28, 2
  %30 = getelementptr i8, ptr addrspace(2) inttoptr (i64 24576 to ptr addrspace(2)), i64 %29
  %31 = mul i64 %27, 2
  %32 = getelementptr i8, ptr addrspace(6) null, i64 %31
  call void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2) %30, ptr addrspace(6) %32, i64 64424575232)
  %33 = add i64 %24, 1
  br label %23

34:                                               ; preds = %23
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) null, ptr addrspace(2) inttoptr (i64 24576 to ptr addrspace(2)), i64 17596481011712, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) null, ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), i64 1168231104512, i64 65552, i64 1)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) null, ptr addrspace(3) null, ptr addrspace(4) null, i64 -6917529027371597808)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) inttoptr (i64 8192 to ptr addrspace(3)), ptr addrspace(2) null, i64 17596481011712, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) inttoptr (i64 8192 to ptr addrspace(4)), ptr addrspace(2) inttoptr (i64 16384 to ptr addrspace(2)), i64 1168231104512, i64 65552, i64 1)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), ptr addrspace(3) inttoptr (i64 8192 to ptr addrspace(3)), ptr addrspace(4) inttoptr (i64 8192 to ptr addrspace(4)), i64 -6917529027371597808)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), ptr addrspace(5) null, i64 68720525568, i64 8796093022224)
  %35 = ptrtoint ptr addrspace(1) %3 to i64
  %36 = inttoptr i64 %35 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %36, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 9216 to ptr addrspace(6)), ptr addrspace(5) inttoptr (i64 1024 to ptr addrspace(5)), i64 68720525568, i64 8796093022224)
  %37 = ptrtoint ptr addrspace(1) %4 to i64
  %38 = inttoptr i64 %37 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %38, ptr addrspace(6) inttoptr (i64 9216 to ptr addrspace(6)), i64 288230377225454080, i64 35184372088864)
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
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4), ptr addrspace(2), i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5), ptr addrspace(3), ptr addrspace(4), i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.LOOP3.PARA(i64)

; Unknown intrinsic
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.L1.v310(ptr addrspace(2), ptr addrspace(6), i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.L1.TO.UB.v310(ptr addrspace(6), ptr addrspace(2), i64)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @l1ub_kernel, !"kernel", i32 1}
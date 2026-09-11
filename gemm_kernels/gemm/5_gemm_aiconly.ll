; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @gemm_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3) #0 {
  %5 = call i64 @llvm.hivm.GET.BLOCK.IDX()
  %6 = trunc i64 %5 to i32
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET0(i64 %7, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.CTRL()
  %10 = call i64 @llvm.hivm.SBITSET1(i64 %9, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %10)
  %11 = mul i32 %6, 16
  %12 = sext i32 %11 to i64
  %13 = mul i64 %12, 128
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %14 = ptrtoint ptr addrspace(1) %0 to i64
  %15 = mul i64 %13, 2
  %16 = add i64 %14, %15
  %17 = inttoptr i64 %16 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), ptr addrspace(1) %17, i64 4503599627374592, i64 128)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 549755879425)
  %18 = ptrtoint ptr addrspace(1) %1 to i64
  %19 = inttoptr i64 %18 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) null, ptr addrspace(1) %19, i64 36028797018968064, i64 128)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) null, ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 8800387989504, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) null, ptr addrspace(2) null, i64 8830452760576, i64 524296, i64 1)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) null, ptr addrspace(3) null, ptr addrspace(4) null, i64 -6917529025493073904)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) null, ptr addrspace(5) null, i64 549756864512, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 1)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 0)
  %20 = ptrtoint ptr addrspace(1) %2 to i64
  %21 = mul i64 %13, 4
  %22 = add i64 %20, %21
  %23 = inttoptr i64 %22 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %23, ptr addrspace(6) null, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 1)
  ret void
}

; Unknown intrinsic
declare i64 @llvm.hivm.GET.BLOCK.IDX()

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
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @gemm_kernel, !"kernel", i32 1}
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @baseline_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3) align 256 #0 {
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET0(i64 %5, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET1(i64 %7, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %9 = ptrtoint ptr addrspace(1) %0 to i64
  %10 = inttoptr i64 %9 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) null, ptr addrspace(1) %10, i64 4503599627378688, i64 256)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 1099511693313)
  %11 = ptrtoint ptr addrspace(1) %1 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), ptr addrspace(1) %12, i64 72057594037928448, i64 16)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) null, ptr addrspace(2) null, i64 17596481011712, i64 65537, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) null, ptr addrspace(2) inttoptr (i64 8192 to ptr addrspace(2)), i64 1168231104512, i64 65552, i64 1)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) null, ptr addrspace(3) null, ptr addrspace(4) null, i64 -6917529027371597808)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) null, ptr addrspace(5) null, i64 68720525568, i64 8796093022224)
  %13 = ptrtoint ptr addrspace(1) %2 to i64
  %14 = inttoptr i64 %13 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %14, ptr addrspace(6) null, i64 288230377225454080, i64 35184372088864)
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


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @baseline_kernel, !"kernel", i32 1}
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @k_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, i32 %4) #0 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.CTRL()
  %9 = call i64 @llvm.hivm.SBITSET1(i64 %8, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %9)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %10 = ptrtoint ptr addrspace(1) %0 to i64
  %11 = inttoptr i64 %10 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) inttoptr (i64 65536 to ptr addrspace(2)), ptr addrspace(1) %11, i64 4503599627378688, i64 128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 549755879425)
  %12 = ptrtoint ptr addrspace(1) %1 to i64
  %13 = inttoptr i64 %12 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2) null, ptr addrspace(1) %13, i64 36028797018972160, i64 128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.f32(ptr addrspace(3) null, ptr addrspace(2) inttoptr (i64 65536 to ptr addrspace(2)), i64 17596481011712, i64 65537, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.f32(ptr addrspace(4) null, ptr addrspace(2) null, i64 17626545782784, i64 524296, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.MAD.f322f32.c310(ptr addrspace(5) null, ptr addrspace(3) null, ptr addrspace(4) null, i64 2305843011361701904)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 16384 to ptr addrspace(6)), ptr addrspace(5) null, i64 549756864512, i64 8796093022224)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 1)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 0)
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

define dso_local ptc_kernel void @k_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, ptr addrspace(1) %3, i32 %4) #1 {
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET0(i64 %6, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %26

10:
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 1)
  br label %12

12:
  %14 = phi i64 [ %24, %22 ], [ 0, %10 ]
  %15 = icmp slt i64 %14, 16
  br i1 %15, label %16, label %25

16:
  %17 = mul i64 %14, 4
  %18 = trunc i64 %17 to i32
  %19 = call <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6) null, i32 %18, i32 0, i32 0)
  %20 = call <256 x i1> @llvm.hivm.pset.b32(i32 0)
  %21 = call <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float> %19, <64 x float> %19, <256 x i1> %20)
  call void @llvm.hivm.vstsx1.v64f32(<64 x float> %21, ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i32 %18, i32 2, i32 0, <256 x i1> %20)
  %24 = add i64 %14, 1
  br label %12

25:
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 0)
  br label %26

26:
  call void @llvm.hivm.BARRIER(i64 6)

  ret void
}

declare void @llvm.hivm.SET.MTE2.NZ.PARA(i64)
declare void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.F32.V310(ptr addrspace(2), ptr addrspace(1), i64, i64)
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)
declare void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.f32(ptr addrspace(3), ptr addrspace(2), i64, i64, i64)
declare void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.f32(ptr addrspace(4), ptr addrspace(2), i64, i64, i64)
declare void @llvm.hivm.MAD.f322f32.c310(ptr addrspace(5), ptr addrspace(3), ptr addrspace(4), i64)
declare void @llvm.hivm.SET.LOOP3.PARA(i64)
declare void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6), ptr addrspace(5), i64, i64)
declare i64 @llvm.hivm.GET.CTRL()
declare i64 @llvm.hivm.SBITSET0(i64, i64)
declare void @llvm.hivm.SET.CTRL(i64)
declare void @llvm.hivm.BARRIER(i64)
declare i64 @llvm.hivm.GET.SUBBLOCKID()
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)
declare <64 x float> @llvm.hivm.vldsx1.v64f32(ptr addrspace(6), i32, i32, i32)
declare <256 x i1> @llvm.hivm.pset.b32(i32)
declare <64 x float> @llvm.hivm.vadd.s.x.v64f32(<64 x float>, <64 x float>, <256 x i1>)
declare void @llvm.hivm.vstsx1.v64f32(<64 x float>, ptr addrspace(6), i32, i32, i32, <256 x i1>)

attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1, !2}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @k_mix_aic, !"kernel", i32 1}
!2 = !{ptr @k_mix_aiv, !"kernel", i32 1}

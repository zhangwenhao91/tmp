; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

@_debug_prefix_12108603912770652896 = private constant [8 x i8] c"l0c_acc\00"

@_debug_desc_0 = private constant { ptr addrspace(6), ptr addrspace(6), i64, [2 x i64], [2 x i64] } { ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), i64 0, [2 x i64] [i64 16, i64 128], [2 x i64] [i64 128, i64 1] }
@_debug_desc_1 = private constant { ptr addrspace(6), ptr addrspace(6), i64, [2 x i64], [2 x i64] } { ptr addrspace(6) null, ptr addrspace(6) null, i64 0, [2 x i64] [i64 16, i64 128], [2 x i64] [i64 128, i64 1] }
@_debug_prefix_9586956735109918980 = private constant [11 x i8] c"ub_fix_out\00"

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
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

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

declare void @_mlir_ciface_print_2d_float_ubuf.cube(ptr, i64, ptr, i8)

; Unknown intrinsic
declare void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)

; Unknown intrinsic
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

define dso_local ptc_kernel void @gemm_kernel_mix_aic(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3) #0 {
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET0(i64 %5, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET1(i64 %7, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 68719542273)
  %9 = ptrtoint ptr addrspace(1) %0 to i64
  %10 = inttoptr i64 %9 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), ptr addrspace(1) %10, i64 4503599627374592, i64 128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.SET.MTE2.NZ.PARA(i64 549755879425)
  %11 = ptrtoint ptr addrspace(1) %1 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.L1.MULTI.ND2NZ.U16.V310(ptr addrspace(2) null, ptr addrspace(1) %12, i64 36028797018968064, i64 128)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 0)
  call void @llvm.hivm.LOAD.L1.TO.L0A.2Dv2.bf16(ptr addrspace(3) null, ptr addrspace(2) inttoptr (i64 32768 to ptr addrspace(2)), i64 8800387989504, i64 65537, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 3, i64 1)
  call void @llvm.hivm.LOAD.L1.TO.L0B.2Dv2.bf16(ptr addrspace(4) null, ptr addrspace(2) null, i64 8830452760576, i64 524296, i64 1)
  call void @llvm.hivm.SET.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 3, i64 2, i64 0)
  call void @llvm.hivm.MAD.bf162f32.c310(ptr addrspace(5) null, ptr addrspace(3) null, ptr addrspace(4) null, i64 -6917529025493073904)
  call void @llvm.hivm.SET.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 2, i64 10, i64 0)
  call void @llvm.hivm.SET.LOOP3.PARA(i64 1)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) null, ptr addrspace(5) null, i64 549756864512, i64 8796093022224)
  call void @llvm.hivm.FIX.L0C.TO.UB.f32.EXT(ptr addrspace(6) inttoptr (i64 8192 to ptr addrspace(6)), ptr addrspace(5) null, i64 549756864512, i64 8796093022224)
  call void @_mlir_ciface_print_2d_float_ubuf.cube(ptr @_debug_prefix_12108603912770652896, i64 7, ptr @_debug_desc_0, i8 0)
  call void @_mlir_ciface_print_2d_float_ubuf.cube(ptr @_debug_prefix_9586956735109918980, i64 10, ptr @_debug_desc_1, i8 0)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 10, i64 0)
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 10, i64 1)
  call void @llvm.hivm.BARRIER(i64 6)
  ret void
}

define dso_local ptc_kernel void @gemm_kernel_mix_aiv(ptr addrspace(1) %0, ptr addrspace(1) %1, ptr addrspace(1) %2, i32 %3) #1 {
  %5 = call i64 @llvm.hivm.GET.CTRL()
  %6 = call i64 @llvm.hivm.SBITSET0(i64 %5, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %6)
  %7 = call i64 @llvm.hivm.GET.CTRL()
  %8 = call i64 @llvm.hivm.SBITSET1(i64 %7, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %8)
  %9 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %11, label %14

11:                                               ; preds = %4
  call void @llvm.hivm.WAIT.INTRA.BLOCKI.mode(i64 1, i64 0)
  %12 = ptrtoint ptr addrspace(1) %2 to i64
  %13 = inttoptr i64 %12 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %13, ptr addrspace(6) null, i64 288230377225457664, i64 35184372088864)
  call void @llvm.hivm.SET.INTRA.BLOCKI.mode(i64 5, i64 1)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %14

14:                                               ; preds = %11, %4
  ret void
}


attributes #0 = { "target-cpu"="dav-c310-vec" }
attributes #1 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1, !2}
!1 = !{ptr @gemm_kernel_mix_aic, !"kernel", i32 1}
!2 = !{ptr @gemm_kernel_mix_aiv, !"kernel", i32 1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
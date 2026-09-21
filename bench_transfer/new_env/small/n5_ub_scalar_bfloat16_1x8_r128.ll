; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "hiipu64-hisilicon-cce"

define dso_local ptc_kernel void @ub_scalar_kernel(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
  %4 = call i64 @llvm.hivm.GET.CTRL()
  %5 = call i64 @llvm.hivm.SBITSET0(i64 %4, i64 60)
  call void @llvm.hivm.SET.CTRL(i64 %5)
  %6 = call i64 @llvm.hivm.GET.CTRL()
  %7 = call i64 @llvm.hivm.SBITSET1(i64 %6, i64 48)
  call void @llvm.hivm.SET.CTRL(i64 %7)
  %8 = call i64 @llvm.hivm.GET.SUBBLOCKID()
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %30

10:                                               ; preds = %3
  %11 = ptrtoint ptr addrspace(1) %0 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6) null, ptr addrspace(1) %12, i64 288230376688582672, i64 17592186044432)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 0, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 0, i64 0)
  br label %13

13:                                               ; preds = %25, %10
  %14 = phi i64 [ %26, %25 ], [ 0, %10 ]
  %15 = icmp slt i64 %14, 128
  br i1 %15, label %16, label %27

16:                                               ; preds = %13
  br label %17

17:                                               ; preds = %20, %16
  %18 = phi i64 [ %24, %20 ], [ 0, %16 ]
  %19 = icmp slt i64 %18, 8
  br i1 %19, label %20, label %25

20:                                               ; preds = %17
  %21 = getelementptr bfloat, ptr addrspace(6) null, i64 %18
  %22 = load bfloat, ptr addrspace(6) %21, align 2
  %23 = getelementptr bfloat, ptr addrspace(6) inttoptr (i64 32 to ptr addrspace(6)), i64 %18
  store bfloat %22, ptr addrspace(6) %23, align 2
  %24 = add i64 %18, 1
  br label %17

25:                                               ; preds = %17
  %26 = add i64 %14, 1
  br label %13

27:                                               ; preds = %13
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 5, i64 0)
  %28 = ptrtoint ptr addrspace(1) %1 to i64
  %29 = inttoptr i64 %28 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %29, ptr addrspace(6) inttoptr (i64 32 to ptr addrspace(6)), i64 288230376688582672, i64 17592186044432)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %30

30:                                               ; preds = %27, %3
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
declare i64 @llvm.hivm.GET.SUBBLOCKID()

; Unknown intrinsic
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f16.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.SET.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.WAIT.FLAG.IMM(i64, i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1), ptr addrspace(6), i64, i64)

; Unknown intrinsic
declare void @llvm.hivm.BARRIER(i64)


attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @ub_scalar_kernel, !"kernel", i32 1}
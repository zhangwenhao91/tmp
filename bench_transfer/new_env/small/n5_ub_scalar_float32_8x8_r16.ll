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
  br i1 %9, label %10, label %40

10:                                               ; preds = %3
  %11 = ptrtoint ptr addrspace(1) %0 to i64
  %12 = inttoptr i64 %11 to ptr addrspace(1)
  call void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6) null, ptr addrspace(1) %12, i64 288230377225453696, i64 35184372088864)
  call void @llvm.hivm.SET.FLAG.IMM(i64 4, i64 0, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 4, i64 0, i64 0)
  br label %13

13:                                               ; preds = %35, %10
  %14 = phi i64 [ %36, %35 ], [ 0, %10 ]
  %15 = icmp slt i64 %14, 16
  br i1 %15, label %16, label %37

16:                                               ; preds = %13
  br label %17

17:                                               ; preds = %33, %16
  %18 = phi i64 [ %34, %33 ], [ 0, %16 ]
  %19 = icmp slt i64 %18, 8
  br i1 %19, label %20, label %35

20:                                               ; preds = %17
  br label %21

21:                                               ; preds = %24, %20
  %22 = phi i64 [ %32, %24 ], [ 0, %20 ]
  %23 = icmp slt i64 %22, 8
  br i1 %23, label %24, label %33

24:                                               ; preds = %21
  %25 = mul i64 %18, 8
  %26 = add i64 %25, %22
  %27 = getelementptr float, ptr addrspace(6) null, i64 %26
  %28 = load float, ptr addrspace(6) %27, align 4
  %29 = mul i64 %18, 8
  %30 = add i64 %29, %22
  %31 = getelementptr float, ptr addrspace(6) inttoptr (i64 256 to ptr addrspace(6)), i64 %30
  store float %28, ptr addrspace(6) %31, align 4
  %32 = add i64 %22, 1
  br label %21

33:                                               ; preds = %21
  %34 = add i64 %18, 1
  br label %17

35:                                               ; preds = %17
  %36 = add i64 %14, 1
  br label %13

37:                                               ; preds = %13
  call void @llvm.hivm.SET.FLAG.IMM(i64 0, i64 5, i64 0)
  call void @llvm.hivm.WAIT.FLAG.IMM(i64 0, i64 5, i64 0)
  %38 = ptrtoint ptr addrspace(1) %1 to i64
  %39 = inttoptr i64 %38 to ptr addrspace(1)
  call void @llvm.hivm.MOV.UB.TO.OUT.ALIGN.V2.DV(ptr addrspace(1) %39, ptr addrspace(6) inttoptr (i64 256 to ptr addrspace(6)), i64 288230377225453696, i64 35184372088864)
  call void @llvm.hivm.BARRIER(i64 6)
  br label %40

40:                                               ; preds = %37, %3
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
declare void @llvm.hivm.MOV.OUT.TO.UB.ALIGN.V2.f32.DV(ptr addrspace(6), ptr addrspace(1), i64, i64)

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
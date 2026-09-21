; ModuleID = 'scalar_l1_test'
source_filename = "scalar_l1_test"
target triple = "hiipu64-hisilicon-cce"

; Test: L1 -> scalar -> L1 on CUBE core (dav-c310-cube)
; Move 4 x f32 from L1 src to L1 dst via scalar load/store.
define dso_local ptc_kernel void @scalar_l1_test(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
  %src = inttoptr i64 8192 to ptr addrspace(2)
  %dst = inttoptr i64 16384 to ptr addrspace(2)

  %v1 = load float, ptr addrspace(2) %src, align 4
  %p2 = getelementptr float, ptr addrspace(2) %src, i64 1
  %v2 = load float, ptr addrspace(2) %p2, align 4
  %p3 = getelementptr float, ptr addrspace(2) %src, i64 2
  %v3 = load float, ptr addrspace(2) %p3, align 4
  %p4 = getelementptr float, ptr addrspace(2) %src, i64 3
  %v4 = load float, ptr addrspace(2) %p4, align 4

  store float %v1, ptr addrspace(2) %dst, align 4
  %q2 = getelementptr float, ptr addrspace(2) %dst, i64 1
  store float %v2, ptr addrspace(2) %q2, align 4
  %q3 = getelementptr float, ptr addrspace(2) %dst, i64 2
  store float %v3, ptr addrspace(2) %q3, align 4
  %q4 = getelementptr float, ptr addrspace(2) %dst, i64 3
  store float %v4, ptr addrspace(2) %q4, align 4

  ret void
}

attributes #0 = { "target-cpu"="dav-c310-cube" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @scalar_l1_test, !"kernel", i32 1}

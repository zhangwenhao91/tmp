; ModuleID = 'scalar_ub_test'
source_filename = "scalar_ub_test"
target triple = "hiipu64-hisilicon-cce"

; Test: UB -> scalar -> UB on VECTOR core (dav-c310-vec)
; Move 4 x f32 from UB src to UB dst via scalar load/store.
define dso_local ptc_kernel void @scalar_ub_test(ptr addrspace(1) %0, ptr addrspace(1) %1, i32 %2) #0 {
  %src = inttoptr i64 8192 to ptr addrspace(6)
  %dst = inttoptr i64 16384 to ptr addrspace(6)

  %v1 = load float, ptr addrspace(6) %src, align 4
  %p2 = getelementptr float, ptr addrspace(6) %src, i64 1
  %v2 = load float, ptr addrspace(6) %p2, align 4
  %p3 = getelementptr float, ptr addrspace(6) %src, i64 2
  %v3 = load float, ptr addrspace(6) %p3, align 4
  %p4 = getelementptr float, ptr addrspace(6) %src, i64 3
  %v4 = load float, ptr addrspace(6) %p4, align 4

  store float %v1, ptr addrspace(6) %dst, align 4
  %q2 = getelementptr float, ptr addrspace(6) %dst, i64 1
  store float %v2, ptr addrspace(6) %q2, align 4
  %q3 = getelementptr float, ptr addrspace(6) %dst, i64 2
  store float %v3, ptr addrspace(6) %q3, align 4
  %q4 = getelementptr float, ptr addrspace(6) %dst, i64 3
  store float %v4, ptr addrspace(6) %q4, align 4

  ret void
}

attributes #0 = { "target-cpu"="dav-c310-vec" }

!llvm.module.flags = !{!0}
!hivm.annotations = !{!1}
!nvvm.annotations = !{}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{ptr @scalar_ub_test, !"kernel", i32 1}

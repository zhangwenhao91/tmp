reduce_max_npu.mlir:26:14: error: cannot compute vector load offset
        %4 = npu.vload %reinterpret_cast_3 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> vector<1xf32>
             ^
reduce_max_npu.mlir:26:14: note: see current operation: %21 = "npu.vload"(%20) {tcore_type = #npu.tcore_type<VECTOR>} : (memref<f32, strided<[], offset: ?>, #cce.address_space<ub>>) -> vector<1xf32>
reduce_max_npu.mlir:26:14: error: NPU-to-CCE vector lowering is not implemented
        %4 = npu.vload %reinterpret_cast_3 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> vector<1xf32>
             ^
reduce_max_npu.mlir:26:14: note: see current operation: %21 = "npu.vload"(%20) {tcore_type = #npu.tcore_type<VECTOR>} : (memref<f32, strided<[], offset: ?>, #cce.address_space<ub>>) -> vector<1xf32>

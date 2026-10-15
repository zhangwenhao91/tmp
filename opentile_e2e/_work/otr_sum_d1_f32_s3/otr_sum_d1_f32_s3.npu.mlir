module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @otr_sum_d1_f32_s3(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %cst = arith.constant 0.000000e+00 : f32
    %c1_i64 = arith.constant 1 : i64
    %c32 = arith.constant 32 : index
    %c48 = arith.constant 48 : index
    %c0 = arith.constant 0 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c32, %c48], strides: [48, 1] {opentile.zero_pad_dynamic_copy} : memref<?xf32, #npu.address_space<gm>> to memref<?x?xf32, strided<[48, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast {opentile.zero_pad_dynamic_copy} : memref<?x?xf32, strided<[48, 1], offset: ?>, #npu.address_space<gm>> to memref<32x64xf32, strided<[48, 1], offset: ?>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<32x64xf32, #npu.address_space<ub>>
    npu.scope() {
      %2 = npu.broadcast %cst : f32 -> vector<32x64xf32>
      npu.vstore %2, %0 : (vector<32x64xf32>, memref<32x64xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.copy ins(%cast : memref<32x64xf32, strided<[48, 1], offset: ?>, #npu.address_space<gm>>) outs(%0 : memref<32x64xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    %c8192_i64 = arith.constant 8192 : i64
    %1 = npu.alloc(%c8192_i64) : memref<32xf32, #npu.address_space<ub>>
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %2 = npu.vload %0 : (memref<32x64xf32, #npu.address_space<ub>>) -> vector<32x64xf32>
      %3 = npu.reduce %2, %c1_i64 : vector<32x64xf32>, i64 -> vector<32xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32]
      npu.vstore %3, %1 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%1 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<32xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


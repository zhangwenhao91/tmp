module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @otg_sum_d0_i64(%arg0: memref<?xi64, #npu.address_space<gm>>, %arg1: memref<?xi64, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c0_i64 = arith.constant 0 : i64
    %c64 = arith.constant 64 : index
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c64, %c16], strides: [16, 1] {opentile.zero_pad_dynamic_copy} : memref<?xi64, #npu.address_space<gm>> to memref<?x?xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast {opentile.zero_pad_dynamic_copy} : memref<?x?xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>> to memref<64x32xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %c0_i64_0 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64_0) : memref<64x32xi64, #npu.address_space<ub>>
    npu.scope() {
      %2 = npu.broadcast %c0_i64 : i64 -> vector<64x32xi64>
      npu.vstore %2, %0 : (vector<64x32xi64>, memref<64x32xi64, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.copy ins(%cast : memref<64x32xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>>) outs(%0 : memref<64x32xi64, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    %c16384_i64 = arith.constant 16384 : i64
    %1 = npu.alloc(%c16384_i64) : memref<32xi64, #npu.address_space<ub>>
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %2 = npu.vload %0 : (memref<64x32xi64, #npu.address_space<ub>>) -> vector<64x32xi64>
      %3 = npu.reduce %2, %c0_i64 : vector<64x32xi64>, i64 -> vector<32xi64> #npu.reduce_op<sum> identities=[0 : i64]
      npu.vstore %3, %1 : (vector<32xi64>, memref<32xi64, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [%c16], strides: [1] : memref<?xi64, #npu.address_space<gm>> to memref<?xi64, strided<[1], offset: ?>, #npu.address_space<gm>>
    %cast_2 = memref.cast %reinterpret_cast_1 : memref<?xi64, strided<[1], offset: ?>, #npu.address_space<gm>> to memref<32xi64, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%1 : memref<32xi64, #npu.address_space<ub>>) outs(%cast_2 : memref<32xi64, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


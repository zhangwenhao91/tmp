module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @otr_sum_d1_i32_s2(%arg0: memref<?xi32, #npu.address_space<gm>>, %arg1: memref<?xi32, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c100 = arith.constant 100 : index
    %c20 = arith.constant 20 : index
    %c0 = arith.constant 0 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c100, %c20], strides: [20, 1] {opentile.zero_pad_dynamic_copy} : memref<?xi32, #npu.address_space<gm>> to memref<?x?xi32, strided<[20, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast {opentile.zero_pad_dynamic_copy} : memref<?x?xi32, strided<[20, 1], offset: ?>, #npu.address_space<gm>> to memref<128x32xi32, strided<[20, 1], offset: ?>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<128x32xi32, #npu.address_space<ub>>
    npu.scope() {
      %2 = npu.broadcast %c0_i32 : i32 -> vector<128x32xi32>
      npu.vstore %2, %0 : (vector<128x32xi32>, memref<128x32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.copy ins(%cast : memref<128x32xi32, strided<[20, 1], offset: ?>, #npu.address_space<gm>>) outs(%0 : memref<128x32xi32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    %c16384_i64 = arith.constant 16384 : i64
    %1 = npu.alloc(%c16384_i64) : memref<128xi32, #npu.address_space<ub>>
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %2 = npu.vload %0 : (memref<128x32xi32, #npu.address_space<ub>>) -> vector<128x32xi32>
      %3 = npu.reduce %2, %c1_i64 : vector<128x32xi32>, i64 -> vector<128xi32> #npu.reduce_op<sum> identities=[0 : i32]
      npu.vstore %3, %1 : (vector<128xi32>, memref<128xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [%c100], strides: [1] : memref<?xi32, #npu.address_space<gm>> to memref<?xi32, strided<[1], offset: ?>, #npu.address_space<gm>>
    %cast_1 = memref.cast %reinterpret_cast_0 : memref<?xi32, strided<[1], offset: ?>, #npu.address_space<gm>> to memref<128xi32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%1 : memref<128xi32, #npu.address_space<ub>>) outs(%cast_1 : memref<128xi32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @triton_sum_dim1(%arg0: memref<?xf16, #npu.address_space<gm>>, %arg1: memref<?xf16, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %cst = arith.constant 0.000000e+00 : f16
    %c1_i64 = arith.constant 1 : i64
    %c57 = arith.constant 57 : index
    %c3 = arith.constant 3 : index
    %c0 = arith.constant 0 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c57, %c3], strides: [3, 1] {opentile.zero_pad_dynamic_copy} : memref<?xf16, #npu.address_space<gm>> to memref<?x?xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast {opentile.zero_pad_dynamic_copy} : memref<?x?xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>> to memref<64x16xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>>
    %c4096_i64 = arith.constant 4096 : i64
    %0 = npu.alloc(%c4096_i64) : memref<64x16xf16, #npu.address_space<ub>>
    npu.scope() {
      %4 = npu.broadcast %cst : f16 -> vector<64x16xf16>
      npu.vstore %4, %0 : (vector<64x16xf16>, memref<64x16xf16, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.copy ins(%cast : memref<64x16xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>>) outs(%0 : memref<64x16xf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<64x16xf32, #npu.address_space<ub>>
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %4 = npu.vload %0 : (memref<64x16xf16, #npu.address_space<ub>>) -> vector<64x16xf16>
      %5 = npu.cvt %4 : vector<64x16xf16> -> vector<64x16xf32> {round_mode = #npu.round_mode<rint>}
      npu.vstore %5, %1 : (vector<64x16xf32>, memref<64x16xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    %c6144_i64 = arith.constant 6144 : i64
    %2 = npu.alloc(%c6144_i64) : memref<64xf32, #npu.address_space<ub>>
    npu.scope() {
      %4 = npu.vload %1 : (memref<64x16xf32, #npu.address_space<ub>>) -> vector<64x16xf32>
      %5 = npu.reduce %4, %c1_i64 : vector<64x16xf32>, i64 -> vector<64xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32]
      npu.vstore %5, %2 : (vector<64xf32>, memref<64xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_1"} : () -> ()
    %c6400_i64 = arith.constant 6400 : i64
    %3 = npu.alloc(%c6400_i64) : memref<64xf16, #npu.address_space<ub>>
    npu.scope() {
      %4 = npu.vload %2 : (memref<64xf32, #npu.address_space<ub>>) -> vector<64xf32>
      %5 = npu.cvt %4 : vector<64xf32> -> vector<64xf16> {round_mode = #npu.round_mode<rint>}
      npu.vstore %5, %3 : (vector<64xf16>, memref<64xf16, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_2"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [%c57], strides: [1] : memref<?xf16, #npu.address_space<gm>> to memref<?xf16, strided<[1], offset: ?>, #npu.address_space<gm>>
    %cast_1 = memref.cast %reinterpret_cast_0 : memref<?xf16, strided<[1], offset: ?>, #npu.address_space<gm>> to memref<64xf16, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%3 : memref<64xf16, #npu.address_space<ub>>) outs(%cast_1 : memref<64xf16, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


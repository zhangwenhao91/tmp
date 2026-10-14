module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @triton_mean_dim0(%arg0: memref<?xf16, #npu.address_space<gm>>, %arg1: memref<?xf16, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %cst = arith.constant 0.000000e+00 : f16
    %c0_i64 = arith.constant 0 : i64
    %c0 = arith.constant 0 : index
    %c3 = arith.constant 3 : index
    %c128 = arith.constant 128 : index
    %cst_0 = arith.constant 1.280000e+02 : f32
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c128, %c3], strides: [3, 1] {opentile.zero_pad_dynamic_copy} : memref<?xf16, #npu.address_space<gm>> to memref<?x?xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast {opentile.zero_pad_dynamic_copy} : memref<?x?xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>> to memref<256x8xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>>
    %c8192_i64 = arith.constant 8192 : i64
    %0 = npu.alloc(%c8192_i64) : memref<256x8xf16, #npu.address_space<ub>>
    npu.scope() {
      %7 = npu.broadcast %cst : f16 -> vector<256x8xf16>
      npu.vstore %7, %0 : (vector<256x8xf16>, memref<256x8xf16, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.copy ins(%cast : memref<256x8xf16, strided<[3, 1], offset: ?>, #npu.address_space<gm>>) outs(%0 : memref<256x8xf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    %c0_i64_1 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64_1) : memref<256x8xf32, #npu.address_space<ub>>
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %7 = npu.vload %0 : (memref<256x8xf16, #npu.address_space<ub>>) -> vector<256x8xf16>
      %8 = npu.cvt %7 : vector<256x8xf16> -> vector<256x8xf32> {round_mode = #npu.round_mode<rint>}
      npu.vstore %8, %1 : (vector<256x8xf32>, memref<256x8xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    %c12288_i64 = arith.constant 12288 : i64
    %2 = npu.alloc(%c12288_i64) : memref<8xf32, #npu.address_space<ub>>
    npu.scope() {
      %7 = npu.vload %1 : (memref<256x8xf32, #npu.address_space<ub>>) -> vector<256x8xf32>
      %8 = npu.reduce %7, %c0_i64 : vector<256x8xf32>, i64 -> vector<8xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32]
      npu.vstore %8, %2 : (vector<8xf32>, memref<8xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_1"} : () -> ()
    %c12320_i64 = arith.constant 12320 : i64
    %3 = npu.alloc(%c12320_i64) : memref<8xf16, #npu.address_space<ub>>
    npu.scope() {
      %7 = npu.vload %2 : (memref<8xf32, #npu.address_space<ub>>) -> vector<8xf32>
      %8 = npu.cvt %7 : vector<8xf32> -> vector<8xf16> {round_mode = #npu.round_mode<rint>}
      npu.vstore %8, %3 : (vector<8xf16>, memref<8xf16, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_2"} : () -> ()
    %c12352_i64 = arith.constant 12352 : i64
    %4 = npu.alloc(%c12352_i64) : memref<8xf32, #npu.address_space<ub>>
    npu.scope() {
      %7 = npu.vload %3 : (memref<8xf16, #npu.address_space<ub>>) -> vector<8xf16>
      %8 = npu.cvt %7 : vector<8xf16> -> vector<8xf32> {round_mode = #npu.round_mode<rint>}
      npu.vstore %8, %4 : (vector<8xf32>, memref<8xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_3"} : () -> ()
    %c12384_i64 = arith.constant 12384 : i64
    %5 = npu.alloc(%c12384_i64) : memref<8xf32, #npu.address_space<ub>>
    npu.scope() {
      %7 = npu.vload %4 : (memref<8xf32, #npu.address_space<ub>>) -> vector<8xf32>
      %8 = npu.div %7, %cst_0 : vector<8xf32>, f32 -> vector<8xf32> {round_mode = #npu.round_mode<rint>}
      npu.vstore %8, %5 : (vector<8xf32>, memref<8xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_4"} : () -> ()
    %c12416_i64 = arith.constant 12416 : i64
    %6 = npu.alloc(%c12416_i64) : memref<8xf16, #npu.address_space<ub>>
    npu.scope() {
      %7 = npu.vload %5 : (memref<8xf32, #npu.address_space<ub>>) -> vector<8xf32>
      %8 = npu.cvt %7 : vector<8xf32> -> vector<8xf16> {round_mode = #npu.round_mode<rint>}
      npu.vstore %8, %6 : (vector<8xf16>, memref<8xf16, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_5"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [%c3], strides: [1] : memref<?xf16, #npu.address_space<gm>> to memref<?xf16, strided<[1], offset: ?>, #npu.address_space<gm>>
    %cast_3 = memref.cast %reinterpret_cast_2 : memref<?xf16, strided<[1], offset: ?>, #npu.address_space<gm>> to memref<8xf16, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%6 : memref<8xf16, #npu.address_space<ub>>) outs(%cast_3 : memref<8xf16, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


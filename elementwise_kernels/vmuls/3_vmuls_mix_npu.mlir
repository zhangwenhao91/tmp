module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @vmuls_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c16384_i64 = arith.constant 16384 : i64
    %1 = npu.alloc(%c16384_i64) : memref<4xi8, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %2 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<ub>>
    npu.scope() {
      %c0 = arith.constant 0 : index
      %c16_i32 = arith.constant 16 : i32
      %c128 = arith.constant 128 : index
      %3 = npu.get_block_idx() : i64
      %4 = arith.trunci %3 : i64 to i32
      %view = memref.view %0[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
      %view_0 = memref.view %1[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
      %view_1 = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
      %5 = arith.muli %4, %c16_i32 : i32
      %6 = arith.index_cast %5 : i32 to index
      %7 = arith.muli %6, %c128 : index
      %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%7], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
      npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
      %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [], strides: [] : memref<?xf32, #npu.address_space<gm>> to memref<f32, strided<[]>, #npu.address_space<gm>>
      %reinterpret_cast_3 = memref.reinterpret_cast %view_0 to offset: [0], sizes: [], strides: [] : memref<1xf32, #npu.address_space<ub>> to memref<f32, strided<[]>, #npu.address_space<ub>>
      npu.copy ins(%reinterpret_cast_2 : memref<f32, strided<[]>, #npu.address_space<gm>>) outs(%reinterpret_cast_3 : memref<f32, strided<[]>, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
      npu.scope() {
        %11 = npu.vload %view {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
        %12 = memref.load %view_0[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
        %13 = npu.broadcast %12 : f32 -> vector<16x128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
        %14 = npu.mul %11, %13 : vector<16x128xf32>, vector<16x128xf32> -> vector<16x128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
        npu.vstore %14, %view_1 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      %8 = arith.muli %4, %c16_i32 : i32
      %9 = arith.index_cast %8 : i32 to index
      %10 = arith.muli %9, %c128 : index
      %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [%10], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      npu.copy ins(%view_1 : memref<16x128xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_4 : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.yield
    } {tcore_type = #npu.tcore_type<VECTOR>} : () -> ()
    npu.scope() {
      npu.yield
    } {tcore_type = #npu.tcore_type<CUBE>} : () -> ()
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


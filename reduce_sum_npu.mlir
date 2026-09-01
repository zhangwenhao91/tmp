module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @reduce_sum_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c32 = arith.constant 32 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<16384xi8, #npu.address_space<ub>>
    %view = memref.view %1[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<32x128xf32, #npu.address_space<ub>>
    %c16384_i64 = arith.constant 16384 : i64
    %2 = npu.alloc(%c16384_i64) : memref<128xi8, #npu.address_space<ub>>
    %view_1 = memref.view %2[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<32x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      scf.for %arg3 = %c0 to %c32 step %c1 {
        %3 = arith.muli %arg3, %c128 : index
        %reinterpret_cast_2 = memref.reinterpret_cast %view to offset: [%3], sizes: [], strides: [] : memref<32x128xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
        %4 = npu.vload %reinterpret_cast_2 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> vector<f32>
        scf.for %arg4 = %c1 to %c128 step %c1 {
          %5 = arith.muli %arg3, %c128 : index
          %6 = arith.addi %5, %arg4 : index
          %reinterpret_cast_4 = memref.reinterpret_cast %view to offset: [%6], sizes: [], strides: [] : memref<32x128xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
          %7 = npu.vload %reinterpret_cast_4 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> vector<f32>
          %8 = npu.add %4, %7 : vector<f32>, vector<f32> -> vector<f32> {tcore_type = #npu.tcore_type<VECTOR>}
        } {tilelang.loop_kind = "serial"}
        %reinterpret_cast_3 = memref.reinterpret_cast %view_1 to offset: [%arg3], sizes: [], strides: [] : memref<32xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
        npu.vstore %4, %reinterpret_cast_3 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<f32>, memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> ()
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_1 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<32xf32, strided<[1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}

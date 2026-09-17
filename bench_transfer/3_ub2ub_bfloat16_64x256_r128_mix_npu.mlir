module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @ub2ub_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: i32) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<ub>>
    %view = memref.view %1[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<64x256xbf16, #npu.address_space<ub>>
    %c32768_i64 = arith.constant 32768 : i64
    %2 = npu.alloc(%c32768_i64) : memref<32768xi8, #npu.address_space<ub>>
    %view_1 = memref.view %2[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<64x256xbf16, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<64x256xbf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    scf.for %arg3 = %c0 to %c128 step %c1 {
      npu.copy ins(%view : memref<64x256xbf16, #npu.address_space<ub>>) outs(%view_1 : memref<64x256xbf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    } {tilelang.loop_kind = "serial"}
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_1 : memref<64x256xbf16, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


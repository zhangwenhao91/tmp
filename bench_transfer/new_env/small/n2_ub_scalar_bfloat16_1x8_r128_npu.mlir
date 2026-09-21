module {
  func.func @ub_scalar_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: i32) {
    %c8 = arith.constant 8 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %alloc = memref.alloc() : memref<16xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<16xi8, #npu.address_space<ub>> to memref<1x8xbf16, #npu.address_space<ub>>
    %alloc_0 = memref.alloc() : memref<16xi8, #npu.address_space<ub>>
    %view_1 = memref.view %alloc_0[%c0][] : memref<16xi8, #npu.address_space<ub>> to memref<1x8xbf16, #npu.address_space<ub>>
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [8], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<8xbf16, strided<[1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %view to offset: [0], sizes: [8], strides: [1] : memref<1x8xbf16, #npu.address_space<ub>> to memref<8xbf16, strided<[1]>, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<8xbf16, strided<[1]>, #npu.address_space<gm>>) outs(%reinterpret_cast_2 : memref<8xbf16, strided<[1]>, #npu.address_space<ub>>)
    scf.for %arg3 = %c0 to %c128 step %c1 {
      scf.for %arg4 = %c0 to %c1 step %c1 {
        scf.for %arg5 = %c0 to %c8 step %c1 {
          %1 = memref.load %view[%c0, %arg5] : memref<1x8xbf16, #npu.address_space<ub>>
          memref.store %1, %view_1[%c0, %arg5] : memref<1x8xbf16, #npu.address_space<ub>>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
    } {tilelang.loop_kind = "serial"}
    %reinterpret_cast_3 = memref.reinterpret_cast %view_1 to offset: [0], sizes: [8], strides: [1] : memref<1x8xbf16, #npu.address_space<ub>> to memref<8xbf16, strided<[1]>, #npu.address_space<ub>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [8], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<8xbf16, strided<[1]>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast_3 : memref<8xbf16, strided<[1]>, #npu.address_space<ub>>) outs(%reinterpret_cast_4 : memref<8xbf16, strided<[1]>, #npu.address_space<gm>>)
    return
  }
}


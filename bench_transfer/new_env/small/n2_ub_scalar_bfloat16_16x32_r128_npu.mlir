module {
  func.func @ub_scalar_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: i32) {
    %c32 = arith.constant 32 : index
    %c16 = arith.constant 16 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 32], strides: [32, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16, 32], strides: [32, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<1024xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x32xbf16, #npu.address_space<ub>>
    %alloc_1 = memref.alloc() : memref<1024xi8, #npu.address_space<ub>>
    %view_2 = memref.view %alloc_1[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x32xbf16, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x32xbf16, #npu.address_space<ub>>)
    scf.for %arg3 = %c0 to %c128 step %c1 {
      scf.for %arg4 = %c0 to %c16 step %c1 {
        scf.for %arg5 = %c0 to %c32 step %c1 {
          %1 = memref.load %view[%arg4, %arg5] : memref<16x32xbf16, #npu.address_space<ub>>
          memref.store %1, %view_2[%arg4, %arg5] : memref<16x32xbf16, #npu.address_space<ub>>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
    } {tilelang.loop_kind = "serial"}
    npu.copy ins(%view_2 : memref<16x32xbf16, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>)
    return
  }
}


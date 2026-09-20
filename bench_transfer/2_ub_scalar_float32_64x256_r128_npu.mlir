module {
  func.func @ub_scalar_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c256 = arith.constant 256 : index
    %c64 = arith.constant 64 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<65536xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<65536xi8, #npu.address_space<ub>> to memref<64x256xf32, #npu.address_space<ub>>
    %alloc_1 = memref.alloc() : memref<65536xi8, #npu.address_space<ub>>
    %view_2 = memref.view %alloc_1[%c0][] : memref<65536xi8, #npu.address_space<ub>> to memref<64x256xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<64x256xf32, #npu.address_space<ub>>)
    scf.for %arg3 = %c0 to %c128 step %c1 {
      scf.for %arg4 = %c0 to %c64 step %c1 {
        scf.for %arg5 = %c0 to %c256 step %c1 {
          %1 = memref.load %view[%arg4, %arg5] : memref<64x256xf32, #npu.address_space<ub>>
          memref.store %1, %view_2[%arg4, %arg5] : memref<64x256xf32, #npu.address_space<ub>>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
    } {tilelang.loop_kind = "serial"}
    npu.copy ins(%view_2 : memref<64x256xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>)
    return
  }
}


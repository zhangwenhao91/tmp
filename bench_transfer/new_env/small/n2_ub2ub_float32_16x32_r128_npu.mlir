module {
  func.func @ub2ub_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 32], strides: [32, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x32xf32, strided<[32, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16, 32], strides: [32, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x32xf32, strided<[32, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<2048xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<2048xi8, #npu.address_space<ub>> to memref<16x32xf32, #npu.address_space<ub>>
    %alloc_1 = memref.alloc() : memref<2048xi8, #npu.address_space<ub>>
    %view_2 = memref.view %alloc_1[%c0][] : memref<2048xi8, #npu.address_space<ub>> to memref<16x32xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x32xf32, strided<[32, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x32xf32, #npu.address_space<ub>>)
    scf.for %arg3 = %c0 to %c128 step %c1 {
      npu.copy ins(%view : memref<16x32xf32, #npu.address_space<ub>>) outs(%view_2 : memref<16x32xf32, #npu.address_space<ub>>)
    } {tilelang.loop_kind = "serial"}
    npu.copy ins(%view_2 : memref<16x32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<16x32xf32, strided<[32, 1]>, #npu.address_space<gm>>)
    return
  }
}


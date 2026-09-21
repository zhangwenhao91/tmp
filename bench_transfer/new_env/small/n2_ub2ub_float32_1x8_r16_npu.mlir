module {
  func.func @ub2ub_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %alloc = memref.alloc() : memref<32xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<32xi8, #npu.address_space<ub>> to memref<1x8xf32, #npu.address_space<ub>>
    %alloc_0 = memref.alloc() : memref<32xi8, #npu.address_space<ub>>
    %view_1 = memref.view %alloc_0[%c0][] : memref<32xi8, #npu.address_space<ub>> to memref<1x8xf32, #npu.address_space<ub>>
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [8], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<8xf32, strided<[1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %view to offset: [0], sizes: [8], strides: [1] : memref<1x8xf32, #npu.address_space<ub>> to memref<8xf32, strided<[1]>, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<8xf32, strided<[1]>, #npu.address_space<gm>>) outs(%reinterpret_cast_2 : memref<8xf32, strided<[1]>, #npu.address_space<ub>>)
    scf.for %arg3 = %c0 to %c16 step %c1 {
      %reinterpret_cast_5 = memref.reinterpret_cast %view to offset: [0], sizes: [8], strides: [1] : memref<1x8xf32, #npu.address_space<ub>> to memref<8xf32, strided<[1]>, #npu.address_space<ub>>
      %reinterpret_cast_6 = memref.reinterpret_cast %view_1 to offset: [0], sizes: [8], strides: [1] : memref<1x8xf32, #npu.address_space<ub>> to memref<8xf32, strided<[1]>, #npu.address_space<ub>>
      npu.copy ins(%reinterpret_cast_5 : memref<8xf32, strided<[1]>, #npu.address_space<ub>>) outs(%reinterpret_cast_6 : memref<8xf32, strided<[1]>, #npu.address_space<ub>>)
    } {tilelang.loop_kind = "serial"}
    %reinterpret_cast_3 = memref.reinterpret_cast %view_1 to offset: [0], sizes: [8], strides: [1] : memref<1x8xf32, #npu.address_space<ub>> to memref<8xf32, strided<[1]>, #npu.address_space<ub>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [8], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<8xf32, strided<[1]>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast_3 : memref<8xf32, strided<[1]>, #npu.address_space<ub>>) outs(%reinterpret_cast_4 : memref<8xf32, strided<[1]>, #npu.address_space<gm>>)
    return
  }
}


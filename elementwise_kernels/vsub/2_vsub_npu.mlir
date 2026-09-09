module {
  func.func @vsub_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) {
    %c0 = arith.constant 0 : index
    %c16_i32 = arith.constant 16 : i32
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %alloc = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_0 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_1 = memref.view %alloc_0[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_2 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_3 = memref.view %alloc_2[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %2 = arith.muli %1, %c16_i32 : i32
    %3 = arith.index_cast %2 : i32 to index
    %4 = arith.muli %3, %c128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%4], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>)
    %5 = arith.muli %1, %c16_i32 : i32
    %6 = arith.index_cast %5 : i32 to index
    %7 = arith.muli %6, %c128 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [%7], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast_4 : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view_1 : memref<16x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      %11 = npu.vload %view : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %12 = npu.vload %view_1 : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %13 = npu.sub %11, %12 : vector<16x128xf32>, vector<16x128xf32> -> vector<16x128xf32>
      npu.vstore %13, %view_3 : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %8 = arith.muli %1, %c16_i32 : i32
    %9 = arith.index_cast %8 : i32 to index
    %10 = arith.muli %9, %c128 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [%10], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%view_3 : memref<16x128xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_5 : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>)
    return
  }
}


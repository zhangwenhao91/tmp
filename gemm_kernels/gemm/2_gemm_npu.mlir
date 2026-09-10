module {
  func.func @gemm_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) {
    %c0 = arith.constant 0 : index
    %c16_i32 = arith.constant 16 : i32
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<128x128xbf16, strided<[128, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<4096xi8, #npu.address_space<cbuf>>
    %view = memref.view %alloc[%c0][] : memref<4096xi8, #npu.address_space<cbuf>> to memref<16x128xbf16, #npu.address_space<cbuf>>
    %alloc_0 = memref.alloc() : memref<32768xi8, #npu.address_space<cbuf>>
    %view_1 = memref.view %alloc_0[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<128x128xbf16, #npu.address_space<cbuf>>
    %alloc_2 = memref.alloc() : memref<16x128xf32, #npu.address_space<cc>>
    %alloc_3 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_4 = memref.view %alloc_3[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %2 = arith.muli %1, %c16_i32 : i32
    %3 = arith.index_cast %2 : i32 to index
    %4 = arith.muli %3, %c128 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg0 to offset: [%4], sizes: [16, 128], strides: [128, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x128xbf16, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast_5 : memref<16x128xbf16, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xbf16, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast : memref<128x128xbf16, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view_1 : memref<128x128xbf16, #npu.address_space<cbuf>>)
    %alloc_6 = memref.alloc() : memref<16x128xbf16, #npu.address_space<ca>>
    npu.copy ins(%view : memref<16x128xbf16, #npu.address_space<cbuf>>) outs(%alloc_6 : memref<16x128xbf16, #npu.address_space<ca>>)
    %alloc_7 = memref.alloc() : memref<128x128xbf16, #npu.address_space<cb>>
    npu.copy ins(%view_1 : memref<128x128xbf16, #npu.address_space<cbuf>>) outs(%alloc_7 : memref<128x128xbf16, #npu.address_space<cb>>)
    npu.mad ins(%alloc_6, %alloc_7 : memref<16x128xbf16, #npu.address_space<ca>>, memref<128x128xbf16, #npu.address_space<cb>>) outs(%alloc_2 : memref<16x128xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
    npu.copy ins(%alloc_2 : memref<16x128xf32, #npu.address_space<cc>>) outs(%view_4 : memref<16x128xf32, #npu.address_space<ub>>)
    %5 = arith.muli %1, %c16_i32 : i32
    %6 = arith.index_cast %5 : i32 to index
    %7 = arith.muli %6, %c128 : index
    %reinterpret_cast_8 = memref.reinterpret_cast %arg2 to offset: [%7], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%view_4 : memref<16x128xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_8 : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>)
    return
  }
}


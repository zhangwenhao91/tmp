module {
  func.func @baseline_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) {
    %c0 = arith.constant 0 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<32768xi8, #npu.address_space<cbuf>>
    %view = memref.view %alloc[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<64x256xbf16, #npu.address_space<cbuf>>
    %alloc_2 = memref.alloc() : memref<8192xi8, #npu.address_space<cbuf>>
    %view_3 = memref.view %alloc_2[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %alloc_4 = memref.alloc() : memref<64x16xf32, #npu.address_space<cc>>
    %alloc_5 = memref.alloc() : memref<4096xi8, #npu.address_space<ub>>
    %view_6 = memref.view %alloc_5[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<64x256xbf16, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_0 : memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_3 : memref<256x16xbf16, #npu.address_space<cbuf>>)
    %alloc_7 = memref.alloc() : memref<64x256xbf16, #npu.address_space<ca>>
    npu.copy ins(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%alloc_7 : memref<64x256xbf16, #npu.address_space<ca>>)
    %alloc_8 = memref.alloc() : memref<256x16xbf16, #npu.address_space<cb>>
    npu.copy ins(%view_3 : memref<256x16xbf16, #npu.address_space<cbuf>>) outs(%alloc_8 : memref<256x16xbf16, #npu.address_space<cb>>)
    npu.mad ins(%alloc_7, %alloc_8 : memref<64x256xbf16, #npu.address_space<ca>>, memref<256x16xbf16, #npu.address_space<cb>>) outs(%alloc_4 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
    npu.copy ins(%alloc_4 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_6 : memref<64x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_6 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    return
  }
}


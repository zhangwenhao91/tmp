module {
  func.func @baseline_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) {
    %c0 = arith.constant 0 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %view = memref.view %1[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x256xbf16, #npu.address_space<cbuf>>
    %c8192_i64 = arith.constant 8192 : i64
    %2 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %view_2 = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %c0_i64_3 = arith.constant 0 : i64
    %3 = npu.alloc(%c0_i64_3) : memref<16x16xf32, #npu.address_space<cc>>
    %c0_i64_4 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_4) : memref<1024xi8, #npu.address_space<ub>>
    %view_5 = memref.view %4[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x256xbf16, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_0 : memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_2 : memref<256x16xbf16, #npu.address_space<cbuf>>)
    %c0_i64_6 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_6) : memref<16x256xbf16, #npu.address_space<ca>>
    npu.copy ins(%view : memref<16x256xbf16, #npu.address_space<cbuf>>) outs(%5 : memref<16x256xbf16, #npu.address_space<ca>>)
    %c0_i64_7 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_7) : memref<256x16xbf16, #npu.address_space<cb>>
    npu.copy ins(%view_2 : memref<256x16xbf16, #npu.address_space<cbuf>>) outs(%6 : memref<256x16xbf16, #npu.address_space<cb>>)
    npu.mad ins(%5, %6 : memref<16x256xbf16, #npu.address_space<ca>>, memref<256x16xbf16, #npu.address_space<cb>>) outs(%3 : memref<16x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
    npu.copy ins(%3 : memref<16x16xf32, #npu.address_space<cc>>) outs(%view_5 : memref<16x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_5 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    return
  }
}


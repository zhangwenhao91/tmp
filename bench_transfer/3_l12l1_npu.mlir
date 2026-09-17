module {
  func.func @l12l1_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xbf16, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) {
    %c64 = arith.constant 64 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %view = memref.view %1[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<64x256xbf16, #npu.address_space<cbuf>>
    %c32768_i64 = arith.constant 32768 : i64
    %2 = npu.alloc(%c32768_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %view_4 = memref.view %2[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<64x256xbf16, #npu.address_space<cbuf>>
    %c65536_i64 = arith.constant 65536 : i64
    %3 = npu.alloc(%c65536_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %view_5 = memref.view %3[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %c73728_i64 = arith.constant 73728 : i64
    %4 = npu.alloc(%c73728_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %view_6 = memref.view %4[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %c0_i64_7 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_7) : memref<64x16xf32, #npu.address_space<cc>>
    %c4096_i64 = arith.constant 4096 : i64
    %6 = npu.alloc(%c4096_i64) : memref<64x16xf32, #npu.address_space<cc>>
    %c0_i64_8 = arith.constant 0 : i64
    %7 = npu.alloc(%c0_i64_8) : memref<4096xi8, #npu.address_space<ub>>
    %view_9 = memref.view %7[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    %c4096_i64_10 = arith.constant 4096 : i64
    %8 = npu.alloc(%c4096_i64_10) : memref<4096xi8, #npu.address_space<ub>>
    %view_11 = memref.view %8[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<64x256xbf16, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_0 : memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_5 : memref<256x16xbf16, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_1 : memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_6 : memref<256x16xbf16, #npu.address_space<cbuf>>)
    scf.for %arg6 = %c0 to %c64 step %c1 {
      npu.copy ins(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%view_4 : memref<64x256xbf16, #npu.address_space<cbuf>>)
      %c0_i64_12 = arith.constant 0 : i64
      %9 = npu.alloc(%c0_i64_12) : memref<64x256xbf16, #npu.address_space<ca>>
      npu.copy ins(%view_4 : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%9 : memref<64x256xbf16, #npu.address_space<ca>>)
      %c0_i64_13 = arith.constant 0 : i64
      %10 = npu.alloc(%c0_i64_13) : memref<256x16xbf16, #npu.address_space<cb>>
      npu.copy ins(%view_5 : memref<256x16xbf16, #npu.address_space<cbuf>>) outs(%10 : memref<256x16xbf16, #npu.address_space<cb>>)
      npu.mad ins(%9, %10 : memref<64x256xbf16, #npu.address_space<ca>>, memref<256x16xbf16, #npu.address_space<cb>>) outs(%5 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
      npu.copy ins(%view_4 : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%view : memref<64x256xbf16, #npu.address_space<cbuf>>)
      %c32768_i64_14 = arith.constant 32768 : i64
      %11 = npu.alloc(%c32768_i64_14) : memref<64x256xbf16, #npu.address_space<ca>>
      npu.copy ins(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%11 : memref<64x256xbf16, #npu.address_space<ca>>)
      %c8192_i64 = arith.constant 8192 : i64
      %12 = npu.alloc(%c8192_i64) : memref<256x16xbf16, #npu.address_space<cb>>
      npu.copy ins(%view_6 : memref<256x16xbf16, #npu.address_space<cbuf>>) outs(%12 : memref<256x16xbf16, #npu.address_space<cb>>)
      npu.mad ins(%11, %12 : memref<64x256xbf16, #npu.address_space<ca>>, memref<256x16xbf16, #npu.address_space<cb>>) outs(%6 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
    } {tilelang.loop_kind = "serial"}
    npu.copy ins(%5 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_9 : memref<64x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_9 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    npu.copy ins(%6 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_11 : memref<64x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_11 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_3 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    return
  }
}


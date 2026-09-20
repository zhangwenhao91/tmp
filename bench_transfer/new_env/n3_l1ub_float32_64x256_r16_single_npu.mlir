module {
  func.func @l1ub_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) {
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<65536xi8, #npu.address_space<cbuf>>
    %view = memref.view %1[%c0][] : memref<65536xi8, #npu.address_space<cbuf>> to memref<64x256xf32, #npu.address_space<cbuf>>
    %c65536_i64 = arith.constant 65536 : i64
    %2 = npu.alloc(%c65536_i64) : memref<65536xi8, #npu.address_space<cbuf>>
    %view_4 = memref.view %2[%c0][] : memref<65536xi8, #npu.address_space<cbuf>> to memref<64x256xf32, #npu.address_space<cbuf>>
    %c0_i64_5 = arith.constant 0 : i64
    %3 = npu.alloc(%c0_i64_5) : memref<65536xi8, #npu.address_space<ub>>
    %view_6 = memref.view %3[%c0][] : memref<65536xi8, #npu.address_space<ub>> to memref<64x256xf32, #npu.address_space<ub>>
    %c131072_i64 = arith.constant 131072 : i64
    %4 = npu.alloc(%c131072_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %view_7 = memref.view %4[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %c147456_i64 = arith.constant 147456 : i64
    %5 = npu.alloc(%c147456_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %view_8 = memref.view %5[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %c0_i64_9 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_9) : memref<64x16xf32, #npu.address_space<cc>>
    %c4096_i64 = arith.constant 4096 : i64
    %7 = npu.alloc(%c4096_i64) : memref<64x16xf32, #npu.address_space<cc>>
    %c65536_i64_10 = arith.constant 65536 : i64
    %8 = npu.alloc(%c65536_i64_10) : memref<4096xi8, #npu.address_space<ub>>
    %view_11 = memref.view %8[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    %c69632_i64 = arith.constant 69632 : i64
    %9 = npu.alloc(%c69632_i64) : memref<4096xi8, #npu.address_space<ub>>
    %view_12 = memref.view %9[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<64x256xf32, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_0 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_7 : memref<256x16xf32, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_1 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_8 : memref<256x16xf32, #npu.address_space<cbuf>>)
    scf.for %arg6 = %c0 to %c16 step %c1 {
      npu.copy ins(%view : memref<64x256xf32, #npu.address_space<cbuf>>) outs(%view_6 : memref<64x256xf32, #npu.address_space<ub>>)
      npu.copy ins(%view_6 : memref<64x256xf32, #npu.address_space<ub>>) outs(%view_4 : memref<64x256xf32, #npu.address_space<cbuf>>)
      %c0_i64_13 = arith.constant 0 : i64
      %10 = npu.alloc(%c0_i64_13) : memref<64x256xf32, #npu.address_space<ca>>
      npu.copy ins(%view_4 : memref<64x256xf32, #npu.address_space<cbuf>>) outs(%10 : memref<64x256xf32, #npu.address_space<ca>>)
      %c0_i64_14 = arith.constant 0 : i64
      %11 = npu.alloc(%c0_i64_14) : memref<256x16xf32, #npu.address_space<cb>>
      npu.copy ins(%view_7 : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%11 : memref<256x16xf32, #npu.address_space<cb>>)
      npu.mad ins(%10, %11 : memref<64x256xf32, #npu.address_space<ca>>, memref<256x16xf32, #npu.address_space<cb>>) outs(%6 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
      npu.copy ins(%view_4 : memref<64x256xf32, #npu.address_space<cbuf>>) outs(%view_6 : memref<64x256xf32, #npu.address_space<ub>>)
      npu.copy ins(%view_6 : memref<64x256xf32, #npu.address_space<ub>>) outs(%view : memref<64x256xf32, #npu.address_space<cbuf>>)
      %c0_i64_15 = arith.constant 0 : i64
      %12 = npu.alloc(%c0_i64_15) : memref<64x256xf32, #npu.address_space<ca>>
      npu.copy ins(%view : memref<64x256xf32, #npu.address_space<cbuf>>) outs(%12 : memref<64x256xf32, #npu.address_space<ca>>)
      %c16384_i64 = arith.constant 16384 : i64
      %13 = npu.alloc(%c16384_i64) : memref<256x16xf32, #npu.address_space<cb>>
      npu.copy ins(%view_8 : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%13 : memref<256x16xf32, #npu.address_space<cb>>)
      npu.mad ins(%12, %13 : memref<64x256xf32, #npu.address_space<ca>>, memref<256x16xf32, #npu.address_space<cb>>) outs(%7 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
    } {tilelang.loop_kind = "serial"}
    npu.copy ins(%6 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_11 : memref<64x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_11 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    npu.copy ins(%7 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_12 : memref<64x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_12 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_3 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    return
  }
}


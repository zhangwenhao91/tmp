module {
  func.func @mixCV_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: i32) {
    %c64 = arith.constant 64 : index
    %c2 = arith.constant 2 : index
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<128x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<8192xi8, #npu.address_space<cbuf>>
    %view = memref.view %alloc[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x128xf32, #npu.address_space<cbuf>>
    %alloc_3 = memref.alloc() : memref<65536xi8, #npu.address_space<cbuf>>
    %view_4 = memref.view %alloc_3[%c0][] : memref<65536xi8, #npu.address_space<cbuf>> to memref<128x128xf32, #npu.address_space<cbuf>>
    %alloc_5 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_6 = memref.view %alloc_5[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_7 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_8 = memref.view %alloc_7[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_9 = memref.alloc() : memref<16x128xf32, #npu.address_space<cc>>
    %alloc_10 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_11 = memref.view %alloc_10[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_0 : memref<128x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view_4 : memref<128x128xf32, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_1 : memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view_6 : memref<16x128xf32, #npu.address_space<ub>>)
    %alloc_12 = memref.alloc() : memref<16x128xf32, #npu.address_space<ca>>
    npu.copy ins(%view : memref<16x128xf32, #npu.address_space<cbuf>>) outs(%alloc_12 : memref<16x128xf32, #npu.address_space<ca>>)
    %alloc_13 = memref.alloc() : memref<128x128xf32, #npu.address_space<cb>>
    npu.copy ins(%view_4 : memref<128x128xf32, #npu.address_space<cbuf>>) outs(%alloc_13 : memref<128x128xf32, #npu.address_space<cb>>)
    npu.mad ins(%alloc_12, %alloc_13 : memref<16x128xf32, #npu.address_space<ca>>, memref<128x128xf32, #npu.address_space<cb>>) outs(%alloc_9 : memref<16x128xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = false}
    npu.copy ins(%alloc_9 : memref<16x128xf32, #npu.address_space<cc>>) outs(%view_11 : memref<16x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      scf.for %arg5 = %c0 to %c16 step %c1 {
        scf.for %arg6 = %c0 to %c2 step %c1 {
          %1 = arith.muli %arg5, %c128 : index
          %2 = arith.muli %arg6, %c64 : index
          %3 = arith.addi %1, %2 : index
          %reinterpret_cast_14 = memref.reinterpret_cast %view_11 to offset: [%3], sizes: [64], strides: [1] : memref<16x128xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
          %4 = npu.vload %reinterpret_cast_14 : (memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> vector<64xf32>
          %5 = arith.muli %arg5, %c128 : index
          %6 = arith.muli %arg6, %c64 : index
          %7 = arith.addi %5, %6 : index
          %reinterpret_cast_15 = memref.reinterpret_cast %view_6 to offset: [%7], sizes: [64], strides: [1] : memref<16x128xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
          %8 = npu.vload %reinterpret_cast_15 : (memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> vector<64xf32>
          %9 = npu.add %4, %8 : vector<64xf32>, vector<64xf32> -> vector<64xf32>
          %10 = arith.muli %arg5, %c128 : index
          %11 = arith.muli %arg6, %c64 : index
          %12 = arith.addi %10, %11 : index
          %reinterpret_cast_16 = memref.reinterpret_cast %view_8 to offset: [%12], sizes: [64], strides: [1] : memref<16x128xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
          npu.vstore %9, %reinterpret_cast_16 : (vector<64xf32>, memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> ()
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.copy ins(%view_8 : memref<16x128xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>)
    return
  }
}


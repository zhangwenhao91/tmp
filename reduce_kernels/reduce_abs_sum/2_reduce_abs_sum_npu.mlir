module {
  func.func @reduce_abs_sum_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c16_i32 = arith.constant 16 : i32
    %c128 = arith.constant 128 : index
    %cst = arith.constant -1.000000e+00 : f32
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %alloc = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_0 = memref.alloc() : memref<64xi8, #npu.address_space<ub>>
    %view_1 = memref.view %alloc_0[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %2 = arith.muli %1, %c16_i32 : i32
    %3 = arith.index_cast %2 : i32 to index
    %4 = arith.muli %3, %c128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%4], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      %7 = npu.broadcast %cst : f32 -> vector<16x128xf32>
      %8 = npu.vload %view : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %9 = npu.mul %8, %7 : vector<16x128xf32>, vector<16x128xf32> -> vector<16x128xf32>
      %10 = npu.max %8, %9 : vector<16x128xf32>, vector<16x128xf32> -> vector<16x128xf32>
      %11 = npu.reduce %10, %c1_i64 : vector<16x128xf32>, i64 -> vector<16xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32]
      npu.vstore %11, %view_1 : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %5 = arith.muli %1, %c16_i32 : i32
    %6 = arith.index_cast %5 : i32 to index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [%6], sizes: [16], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%view_1 : memref<16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>)
    return
  }
}


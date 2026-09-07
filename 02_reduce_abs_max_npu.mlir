module {
  func.func @reduce_abs_max_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c1_i64 = arith.constant 1 : i64
    %c64 = arith.constant 64 : index
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant -1.000000e+00 : f32
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<16384xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<32x128xf32, #npu.address_space<ub>>
    %alloc_2 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_3 = memref.view %alloc_2[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<32x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      scf.for %arg3 = %c0 to %c1 step %c1 {
        %1 = npu.broadcast %cst : f32 -> vector<32xf32>
        scf.for %arg4 = %c0 to %c2 step %c1 {
          %2 = arith.muli %arg4, %c64 : index
          %reinterpret_cast_4 = memref.reinterpret_cast %view to offset: [%2], sizes: [32, 64], strides: [128, 1] : memref<32x128xf32, #npu.address_space<ub>> to memref<32x64xf32, strided<[128, 1], offset: ?>, #npu.address_space<ub>>
          %3 = npu.vload %reinterpret_cast_4 : (memref<32x64xf32, strided<[128, 1], offset: ?>, #npu.address_space<ub>>) -> vector<32x64xf32>
          %4 = npu.mul %3, %cst_0 : vector<32x64xf32>, f32 -> vector<32x64xf32>
          %5 = npu.max %3, %4 : vector<32x64xf32>, vector<32x64xf32> -> vector<32x64xf32>
          %6 = npu.reduce %5, %c1_i64 : vector<32x64xf32>, i64 -> vector<32xf32> #npu.reduce_op<max> identities=[0xFF800000 : f32]
          %7 = npu.broadcast %cst : f32 -> vector<32xf32>
          %8 = npu.max %7, %6 : vector<32xf32>, vector<32xf32> -> vector<32xf32>
        } {tilelang.loop_kind = "serial"}
        npu.vstore %1, %view_3 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.copy ins(%view_3 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<32xf32, strided<[1]>, #npu.address_space<gm>>)
    return
  }
}


module {
  func.func @reduce_sum_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c1_i64 = arith.constant 1 : i64
    %c64 = arith.constant 64 : index
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<16384xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<32x128xf32, #npu.address_space<ub>>
    %alloc_1 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_2 = memref.view %alloc_1[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<32x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      scf.for %arg3 = %c0 to %c1 step %c1 {
        %1 = npu.broadcast %cst : f32 -> vector<32xf32>
        scf.for %arg4 = %c0 to %c2 step %c1 {
          %2 = arith.muli %arg4, %c64 : index
          %reinterpret_cast_3 = memref.reinterpret_cast %view to offset: [%2], sizes: [32, 64], strides: [128, 1] : memref<32x128xf32, #npu.address_space<ub>> to memref<32x64xf32, strided<[128, 1], offset: ?>, #npu.address_space<ub>>
          %3 = npu.vload %reinterpret_cast_3 : (memref<32x64xf32, strided<[128, 1], offset: ?>, #npu.address_space<ub>>) -> vector<32x64xf32>
          %4 = npu.reduce %3, %c1_i64 : vector<32x64xf32>, i64 -> vector<32xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32]
          %5 = npu.broadcast %cst : f32 -> vector<32xf32>
          %6 = npu.add %5, %4 : vector<32xf32>, vector<32xf32> -> vector<32xf32>
        } {tilelang.loop_kind = "serial"}
        npu.vstore %1, %view_2 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.copy ins(%view_2 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<32xf32, strided<[1]>, #npu.address_space<gm>>)
    return
  }
}


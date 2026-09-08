module {
  func.func @reduce_max_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
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
        %1 = npu.vload %view : (memref<32x128xf32, #npu.address_space<ub>>) -> vector<32x128xf32>
        %2 = npu.reduce %1, %c1_i64 : vector<32x128xf32>, i64 -> vector<32xf32> #npu.reduce_op<max> identities=[0xFF800000 : f32]
        npu.vstore %2, %view_2 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.copy ins(%view_2 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<32xf32, strided<[1]>, #npu.address_space<gm>>)
    return
  }
}


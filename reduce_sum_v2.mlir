module {
  func.func @reduce_sum_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c32 = arith.constant 32 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<16384xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<32x128xf32, #npu.address_space<ub>>
    %alloc_1 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_2 = memref.view %alloc_1[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<32x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      scf.for %arg3 = %c0 to %c32 step %c1 {
        %1 = arith.muli %arg3, %c128 : index
        %reinterpret_cast_3 = memref.reinterpret_cast %view to offset: [%1], sizes: [], strides: [] : memref<32x128xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
        %2 = npu.vload %reinterpret_cast_3 : (memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> vector<f32>
        scf.for %arg4 = %c1 to %c128 step %c1 {
          %3 = arith.muli %arg3, %c128 : index
          %4 = arith.addi %3, %arg4 : index
          %reinterpret_cast_5 = memref.reinterpret_cast %view to offset: [%4], sizes: [], strides: [] : memref<32x128xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
          %5 = npu.vload %reinterpret_cast_5 : (memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> vector<f32>
          %6 = npu.add %2, %5 : vector<f32>, vector<f32> -> vector<f32>
        } {tilelang.loop_kind = "serial"}
        %reinterpret_cast_4 = memref.reinterpret_cast %view_2 to offset: [%arg3], sizes: [], strides: [] : memref<32xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
        npu.vstore %2, %reinterpret_cast_4 : (vector<f32>, memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>) -> ()
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.copy ins(%view_2 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_0 : memref<32xf32, strided<[1]>, #npu.address_space<gm>>)
    return
  }
}

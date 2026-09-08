module {
  func.func @reduce_max_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) attributes {SyncBlockLockArgIdx = 0 : i64, WorkspaceArgIdx = 1 : i64, global_kernel = "local", hivm.part_of_mix, mix_mode = "mix", parallel_mode = "simd"} {
    %c1_i64 = arith.constant 1 : i64
    %c128 = arith.constant 128 : index
    %c16_i32 = arith.constant 16 : i32
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_0 = memref.alloc() : memref<64xi8, #npu.address_space<ub>>
    %view_1 = memref.view %alloc_0[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %0 = arith.muli %arg2, %c16_i32 : i32
    %1 = arith.index_cast %0 : i32 to index
    %2 = arith.muli %1, %c128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%2], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      %5 = npu.vload %view : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %6 = npu.reduce %5, %c1_i64 : vector<16x128xf32>, i64 -> vector<16xf32> #npu.reduce_op<max> identities=[0xFF800000 : f32]
      npu.vstore %6, %view_1 : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %3 = arith.muli %arg2, %c16_i32 : i32
    %4 = arith.index_cast %3 : i32 to index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [%4], sizes: [16], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%view_1 : memref<16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>)
    return
  }
}


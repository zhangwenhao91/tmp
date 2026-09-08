module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @reduce_max_kernel(%arg0: memref<?xi8, #npu.address_space<gm>> {hacc.arg_type = #hacc.arg_type<sync_block_lock>}, %arg1: memref<?xi8, #npu.address_space<gm>> {hacc.arg_type = #hacc.arg_type<workspace>}, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>) attributes {SyncBlockLockArgIdx = 0 : i64, WorkspaceArgIdx = 1 : i64, func_core_type = #npu.func_core_type<AIV>, global_kernel = "local", hivm.part_of_mix, mix_mode = "mix", parallel_mode = "simd"} {
    %c1_i64 = arith.constant 1 : i64
    %c128 = arith.constant 128 : index
    %c16_i32 = arith.constant 16 : i32
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<ub>>
    %view = memref.view %0[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %1 = npu.alloc(%c8192_i64) : memref<64xi8, #npu.address_space<ub>>
    %view_0 = memref.view %1[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %2 = npu.get_block_idx() : i64
    %3 = arith.trunci %2 : i64 to i32
    %4 = arith.muli %3, %c16_i32 : i32
    %5 = arith.index_cast %4 : i32 to index
    %6 = arith.muli %5, %c128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [%6], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %9 = npu.vload %view {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %10 = npu.reduce %9, %c1_i64 : vector<16x128xf32>, i64 -> vector<16xf32> #npu.reduce_op<max> identities=[0xFF800000 : f32] {tcore_type = #npu.tcore_type<VECTOR>}
      npu.vstore %10, %view_0 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %7 = arith.muli %3, %c16_i32 : i32
    %8 = arith.index_cast %7 : i32 to index
    %reinterpret_cast_1 = memref.reinterpret_cast %arg3 to offset: [%8], sizes: [16], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_0 : memref<16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


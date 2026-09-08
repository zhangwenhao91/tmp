module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @vadd_kernel(%arg0: memref<?xi8, #npu.address_space<gm>> {hacc.arg_type = #hacc.arg_type<sync_block_lock>}, %arg1: memref<?xi8, #npu.address_space<gm>> {hacc.arg_type = #hacc.arg_type<workspace>}, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>) attributes {SyncBlockLockArgIdx = 0 : i64, WorkspaceArgIdx = 1 : i64, func_core_type = #npu.func_core_type<AIV>, global_kernel = "local", hivm.part_of_mix, mix_mode = "mix", parallel_mode = "simd"} {
    %c128 = arith.constant 128 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c64 = arith.constant 64 : index
    %c32_i32 = arith.constant 32 : i32
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %2 = arith.muli %1, %c32_i32 : i32
    %3 = arith.index_cast %2 : i32 to index
    %c0_i64 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<ub>>
    %c32768_i64 = arith.constant 32768 : i64
    %5 = npu.alloc(%c32768_i64) : memref<32768xi8, #npu.address_space<ub>>
    %c65536_i64 = arith.constant 65536 : i64
    %6 = npu.alloc(%c65536_i64) : memref<32768xi8, #npu.address_space<ub>>
    %view = memref.view %4[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<8192xf32, #npu.address_space<ub>>
    %view_0 = memref.view %5[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<8192xf32, #npu.address_space<ub>>
    %view_1 = memref.view %6[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<8192xf32, #npu.address_space<ub>>
    %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [%3], sizes: [8192], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<8192xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [%3], sizes: [8192], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<8192xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [%3], sizes: [8192], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<8192xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<8192xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<8192xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.copy ins(%reinterpret_cast_2 : memref<8192xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%view_0 : memref<8192xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      scf.for %arg5 = %c0 to %c128 step %c1 {
        %7 = arith.muli %arg5, %c64 : index
        %reinterpret_cast_4 = memref.reinterpret_cast %view to offset: [%7], sizes: [64], strides: [1] : memref<8192xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
        %reinterpret_cast_5 = memref.reinterpret_cast %view_0 to offset: [%7], sizes: [64], strides: [1] : memref<8192xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
        %reinterpret_cast_6 = memref.reinterpret_cast %view_1 to offset: [%7], sizes: [64], strides: [1] : memref<8192xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
        %8 = npu.vload %reinterpret_cast_4 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> vector<64xf32>
        %9 = npu.vload %reinterpret_cast_5 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> vector<64xf32>
        %10 = npu.add %8, %9 : vector<64xf32>, vector<64xf32> -> vector<64xf32> {tcore_type = #npu.tcore_type<VECTOR>}
        npu.vstore %10, %reinterpret_cast_6 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<64xf32>, memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> ()
      }
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_1 : memref<8192xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_3 : memref<8192xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


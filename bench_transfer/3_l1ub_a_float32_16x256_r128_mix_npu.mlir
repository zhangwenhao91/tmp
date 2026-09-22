module attributes {npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  func.func @l1ub_kernel_mix_aic(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c1 = arith.constant {block_id = 4 : i32} 1 : index
    %c0 = arith.constant {block_id = 4 : i32} 0 : index
    %c128 = arith.constant {block_id = 4 : i32} 128 : index
    %c36864_i64 = arith.constant 36864 : i64
    %0 = npu.alloc(%c36864_i64) : memref<16x16xf32, #npu.address_space<ub>>
    %c35840_i64 = arith.constant 35840 : i64
    %1 = npu.alloc(%c35840_i64) : memref<16x16xf32, #npu.address_space<ub>>
    %c81920_i64 = arith.constant 81920 : i64
    %2 = npu.alloc(%c81920_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c65536_i64 = arith.constant 65536 : i64
    %3 = npu.alloc(%c65536_i64) : memref<16x256xf32, #npu.address_space<cbuf>>
    %c49152_i64 = arith.constant 49152 : i64
    %4 = npu.alloc(%c49152_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c114688_i64 = arith.constant 114688 : i64
    %5 = npu.alloc(%c114688_i64) : memref<16x256xf32, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64) : memref<16x16xf32, #npu.address_space<cc>>
    %c1024_i64 = arith.constant 1024 : i64
    %7 = npu.alloc(%c1024_i64) : memref<16x16xf32, #npu.address_space<cc>>
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 3 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 1
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 2 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 8
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 0 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 7
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 1 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 0
    npu.mad_l1 ins(%5, %4 : memref<16x256xf32, #npu.address_space<cbuf>>, memref<256x16xf32, #npu.address_space<cbuf>>) outs(%7 : memref<16x16xf32, #npu.address_space<cc>>) {block_id = 1 : i32, kloop_db_cond = 256 : i64, lhs_trans = false, rhs_trans = false, unit_flag = 0 : i8, zero_init = true}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%7 : memref<16x16xf32, #npu.address_space<cc>>) outs(%1 : memref<16x16xf32, #npu.address_space<ub>>) {block_id = 1 : i32, crossCoreDeps = [9 : i32, 1 : i32], linear_transfer, transfer_id = 9 : i32}
    npu.sync_block_set {block_id = 1 : i32, transfer_id = 9 : i32}[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 10
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 8 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 5
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 7 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 6
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 6 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 4
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 4 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 2
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 5 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 3
    npu.mad_l1 ins(%3, %2 : memref<16x256xf32, #npu.address_space<cbuf>>, memref<256x16xf32, #npu.address_space<cbuf>>) outs(%6 : memref<16x16xf32, #npu.address_space<cc>>) {block_id = 2 : i32, kloop_db_cond = 256 : i64, lhs_trans = false, rhs_trans = false, unit_flag = 0 : i8, zero_init = true}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%6 : memref<16x16xf32, #npu.address_space<cc>>) outs(%0 : memref<16x16xf32, #npu.address_space<ub>>) {block_id = 2 : i32, crossCoreDeps = [10 : i32, 1 : i32], linear_transfer, transfer_id = 10 : i32}
    npu.sync_block_set {block_id = 2 : i32, transfer_id = 10 : i32}[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 11
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 9
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @l1ub_kernel_mix_aiv(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c1 = arith.constant {block_id = 4 : i32} 1 : index
    %c0 = arith.constant {block_id = 4 : i32} 0 : index
    %c128 = arith.constant {block_id = 4 : i32} 128 : index
    %c36864_i64 = arith.constant 36864 : i64
    %0 = npu.alloc(%c36864_i64) : memref<16x16xf32, #npu.address_space<ub>>
    %c35840_i64 = arith.constant 35840 : i64
    %1 = npu.alloc(%c35840_i64) : memref<16x16xf32, #npu.address_space<ub>>
    %c81920_i64 = arith.constant 81920 : i64
    %2 = npu.alloc(%c81920_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c65536_i64 = arith.constant 65536 : i64
    %3 = npu.alloc(%c65536_i64) : memref<16x256xf32, #npu.address_space<cbuf>>
    %c49152_i64 = arith.constant 49152 : i64
    %4 = npu.alloc(%c49152_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c114688_i64 = arith.constant 114688 : i64
    %5 = npu.alloc(%c114688_i64) : memref<16x256xf32, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64) : memref<16x16xf32, #npu.address_space<cc>>
    %c1024_i64 = arith.constant 1024 : i64
    %7 = npu.alloc(%c1024_i64) : memref<16x16xf32, #npu.address_space<cc>>
    %8 = npu.get_block_idx() {block_id = 7 : i32} : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 256], strides: [256, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<16x256xf32, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [16, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %c32768_i64 = arith.constant 32768 : i64
    %9 = npu.alloc(%c32768_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %view = memref.view %9[%c0][] {block_id = 12 : i32} : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %c16384_i64 = arith.constant 16384 : i64
    %10 = npu.alloc(%c16384_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %view_4 = memref.view %10[%c0][] {block_id = 11 : i32} : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %c17408_i64 = arith.constant 17408 : i64
    %11 = npu.alloc(%c17408_i64) : memref<16384xi8, #npu.address_space<ub>>
    %view_5 = memref.view %11[%c0][] {block_id = 6 : i32} : memref<16384xi8, #npu.address_space<ub>> to memref<16x256xf32, #npu.address_space<ub>>
    %c0_i64_6 = arith.constant 0 : i64
    %12 = npu.alloc(%c0_i64_6) : memref<16384xi8, #npu.address_space<cbuf>>
    %view_7 = memref.view %12[%c0][] {block_id = 5 : i32} : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %c33792_i64 = arith.constant 33792 : i64
    %13 = npu.alloc(%c33792_i64) : memref<1024xi8, #npu.address_space<ub>>
    %view_8 = memref.view %13[%c0][] {block_id = 15 : i32} : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    %c34816_i64 = arith.constant 34816 : i64
    %14 = npu.alloc(%c34816_i64) : memref<1024xi8, #npu.address_space<ub>>
    %view_9 = memref.view %14[%c0][] {block_id = 15 : i32} : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x256xf32, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view_7 : memref<16x256xf32, #npu.address_space<cbuf>>) {block_id = 15 : i32}
    npu.copy ins(%reinterpret_cast_0 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_4 : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 15 : i32}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.copy ins(%reinterpret_cast_1 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 15 : i32}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.copy ins(%view_4 : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%4 : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 15 : i32, crossCoreDeps = [1 : i32, 1 : i32], transfer_id = 1 : i32}
    npu.sync_block_set {block_id = 15 : i32, transfer_id = 1 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 0
    npu.sync_block_set {block_id = 15 : i32, transfer_id = 3 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 1
    npu.copy ins(%view_7 : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%3 : memref<16x256xf32, #npu.address_space<cbuf>>) {block_id = 15 : i32, crossCoreDeps = [4 : i32, 1 : i32], transfer_id = 4 : i32}
    npu.sync_block_set {block_id = 15 : i32, transfer_id = 4 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 2
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%view : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%2 : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 15 : i32, crossCoreDeps = [5 : i32, 1 : i32], transfer_id = 5 : i32}
    npu.sync_block_set {block_id = 15 : i32, transfer_id = 5 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 3
    npu.sync_block_set {block_id = 15 : i32, transfer_id = 6 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 4
    npu.sync_block_set {block_id = 15 : i32, transfer_id = 8 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 5
    scf.for %arg6 = %c0 to %c128 step %c1 {
      npu.copy ins(%view_7 : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%view_5 : memref<16x256xf32, #npu.address_space<ub>>) {block_id = 3 : i32}
    } {block_id = 17 : i32, tilelang.loop_kind = "serial"}
    npu.set_flag[<PIPE_MTE1>, <PIPE_V>, <EVENT_ID0>]
    npu.sync_block_set {block_id = 17 : i32, transfer_id = 7 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 6
    %c98304_i64 = arith.constant 98304 : i64
    %15 = npu.alloc(%c98304_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %view_10 = memref.view %15[%c0][] {block_id = 10 : i32} : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %c0_i64_11 = arith.constant 0 : i64
    %16 = npu.alloc(%c0_i64_11) : memref<4352xf32, #npu.address_space<ub>>
    npu.wait_flag[<PIPE_MTE1>, <PIPE_V>, <EVENT_ID0>]
    npu.nd2nz_scatter ins(%view_5 : memref<16x256xf32, #npu.address_space<ub>>) outs(%16 : memref<4352xf32, #npu.address_space<ub>>) {block_id = 8 : i32}
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%16 : memref<4352xf32, #npu.address_space<ub>>) outs(%view_10 : memref<16x256xf32, #npu.address_space<cbuf>>) {block_id = 8 : i32, linear_transfer}
    npu.set_flag[<PIPE_MTE3>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE3>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%view_10 : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%5 : memref<16x256xf32, #npu.address_space<cbuf>>) {block_id = 8 : i32, crossCoreDeps = [0 : i32, 1 : i32], transfer_id = 0 : i32}
    npu.sync_block_set {block_id = 8 : i32, transfer_id = 0 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 7
    npu.sync_block_set {block_id = 8 : i32, transfer_id = 2 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 8
    npu.sync_block_wait {block_id = 16 : i32, transfer_id = 9 : i32}[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 10
    npu.copy ins(%1 : memref<16x16xf32, #npu.address_space<ub>>) outs(%view_8 : memref<16x16xf32, #npu.address_space<ub>>) {block_id = 16 : i32}
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_8 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {block_id = 16 : i32}
    npu.sync_block_wait {block_id = 16 : i32, transfer_id = 10 : i32}[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 11
    npu.copy ins(%0 : memref<16x16xf32, #npu.address_space<ub>>) outs(%view_9 : memref<16x16xf32, #npu.address_space<ub>>) {block_id = 16 : i32}
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_9 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_3 : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {block_id = 16 : i32}
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 9
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


module attributes {npu.module_core_type = #npu.module_core_type<MIX>, npu.only_enable_core0} {
  func.func @l1ub_kernel_mix_aic(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c1 = arith.constant {block_id = 4 : i32} 1 : index
    %c0 = arith.constant {block_id = 4 : i32} 0 : index
    %c128 = arith.constant {block_id = 4 : i32} 128 : index
    %c140288_i64 = arith.constant 140288 : i64
    %0 = npu.alloc(%c140288_i64) : memref<64x16xf32, #npu.address_space<ub>>
    %c144384_i64 = arith.constant 144384 : i64
    %1 = npu.alloc(%c144384_i64) : memref<64x16xf32, #npu.address_space<ub>>
    %c311296_i64 = arith.constant 311296 : i64
    %2 = npu.alloc(%c311296_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c196608_i64 = arith.constant 196608 : i64
    %3 = npu.alloc(%c196608_i64) : memref<64x256xf32, #npu.address_space<cbuf>>
    %c294912_i64 = arith.constant 294912 : i64
    %4 = npu.alloc(%c294912_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c65536_i64 = arith.constant 65536 : i64
    %5 = npu.alloc(%c65536_i64) : memref<64x256xf32, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64) : memref<64x16xf32, #npu.address_space<cc>>
    %c4096_i64 = arith.constant 4096 : i64
    %7 = npu.alloc(%c4096_i64) : memref<64x16xf32, #npu.address_space<cc>>
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 4 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 3
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 3 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 6
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 2 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 2
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 0 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 0
    npu.sync_block_wait {block_id = 2 : i32, transfer_id = 1 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 1
    npu.mad_l1 ins(%5, %4 : memref<64x256xf32, #npu.address_space<cbuf>>, memref<256x16xf32, #npu.address_space<cbuf>>) outs(%7 : memref<64x16xf32, #npu.address_space<cc>>) {block_id = 2 : i32, kloop_db_cond = 256 : i64, lhs_trans = false, rhs_trans = false, unit_flag = 0 : i8, zero_init = true}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%7 : memref<64x16xf32, #npu.address_space<cc>>) outs(%0 : memref<64x16xf32, #npu.address_space<ub>>) {block_id = 2 : i32, crossCoreDeps = [10 : i32, 1 : i32], linear_transfer, transfer_id = 10 : i32}
    npu.sync_block_set {block_id = 2 : i32, transfer_id = 10 : i32}[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 10
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 8 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 5
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 7 : i32}[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 8
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 5 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 7
    npu.sync_block_wait {block_id = 1 : i32, transfer_id = 6 : i32}[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 4
    npu.mad_l1 ins(%3, %2 : memref<64x256xf32, #npu.address_space<cbuf>>, memref<256x16xf32, #npu.address_space<cbuf>>) outs(%6 : memref<64x16xf32, #npu.address_space<cc>>) {block_id = 1 : i32, kloop_db_cond = 256 : i64, lhs_trans = false, rhs_trans = false, unit_flag = 0 : i8, zero_init = true}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%6 : memref<64x16xf32, #npu.address_space<cc>>) outs(%1 : memref<64x16xf32, #npu.address_space<ub>>) {block_id = 1 : i32, crossCoreDeps = [9 : i32, 1 : i32], linear_transfer, transfer_id = 9 : i32}
    npu.sync_block_set {block_id = 1 : i32, transfer_id = 9 : i32}[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 11
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 9
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @l1ub_kernel_mix_aiv(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c1 = arith.constant {block_id = 4 : i32} 1 : index
    %c0 = arith.constant {block_id = 4 : i32} 0 : index
    %c128 = arith.constant {block_id = 4 : i32} 128 : index
    %c140288_i64 = arith.constant 140288 : i64
    %0 = npu.alloc(%c140288_i64) : memref<64x16xf32, #npu.address_space<ub>>
    %c144384_i64 = arith.constant 144384 : i64
    %1 = npu.alloc(%c144384_i64) : memref<64x16xf32, #npu.address_space<ub>>
    %c311296_i64 = arith.constant 311296 : i64
    %2 = npu.alloc(%c311296_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c196608_i64 = arith.constant 196608 : i64
    %3 = npu.alloc(%c196608_i64) : memref<64x256xf32, #npu.address_space<cbuf>>
    %c294912_i64 = arith.constant 294912 : i64
    %4 = npu.alloc(%c294912_i64) : memref<256x16xf32, #npu.address_space<cbuf>>
    %c65536_i64 = arith.constant 65536 : i64
    %5 = npu.alloc(%c65536_i64) : memref<64x256xf32, #npu.address_space<cbuf>>
    %c131072_i64 = arith.constant 131072 : i64
    %6 = npu.alloc(%c131072_i64) : memref<65536xi8, #npu.address_space<cbuf>>
    %view = memref.view %6[%c0][] {block_id = 4 : i32} : memref<65536xi8, #npu.address_space<cbuf>> to memref<64x256xf32, #npu.address_space<cbuf>>
    %c262144_i64 = arith.constant 262144 : i64
    %7 = npu.alloc(%c262144_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %view_0 = memref.view %7[%c0][] {block_id = 4 : i32} : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %c66560_i64 = arith.constant 66560 : i64
    %8 = npu.alloc(%c66560_i64) : memref<65536xi8, #npu.address_space<ub>>
    %view_1 = memref.view %8[%c0][] {block_id = 6 : i32} : memref<65536xi8, #npu.address_space<ub>> to memref<64x256xf32, #npu.address_space<ub>>
    %c0_i64 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64) : memref<65536xi8, #npu.address_space<cbuf>>
    %view_2 = memref.view %9[%c0][] {block_id = 5 : i32} : memref<65536xi8, #npu.address_space<cbuf>> to memref<64x256xf32, #npu.address_space<cbuf>>
    %c278528_i64 = arith.constant 278528 : i64
    %10 = npu.alloc(%c278528_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %view_3 = memref.view %10[%c0][] {block_id = 5 : i32} : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %11 = npu.get_block_idx() {block_id = 7 : i32} : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [64, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [64, 16], strides: [16, 1] {block_id = 7 : i32} : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %c132096_i64 = arith.constant 132096 : i64
    %12 = npu.alloc(%c132096_i64) : memref<4096xi8, #npu.address_space<ub>>
    %view_8 = memref.view %12[%c0][] {block_id = 7 : i32} : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    %c136192_i64 = arith.constant 136192 : i64
    %13 = npu.alloc(%c136192_i64) : memref<4096xi8, #npu.address_space<ub>>
    %view_9 = memref.view %13[%c0][] {block_id = 7 : i32} : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<64x256xf32, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view_2 : memref<64x256xf32, #npu.address_space<cbuf>>) {block_id = 7 : i32}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%reinterpret_cast_4 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_0 : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 7 : i32}
    npu.copy ins(%reinterpret_cast_5 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_3 : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 7 : i32}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%view_2 : memref<64x256xf32, #npu.address_space<cbuf>>) outs(%5 : memref<64x256xf32, #npu.address_space<cbuf>>) {block_id = 7 : i32, crossCoreDeps = [0 : i32, 1 : i32], transfer_id = 0 : i32}
    npu.sync_block_set {block_id = 7 : i32, transfer_id = 0 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 0
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.copy ins(%view_3 : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%4 : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 7 : i32, crossCoreDeps = [1 : i32, 1 : i32], transfer_id = 1 : i32}
    npu.sync_block_set {block_id = 7 : i32, transfer_id = 1 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 1
    npu.sync_block_set {block_id = 7 : i32, transfer_id = 2 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 2
    npu.sync_block_set {block_id = 7 : i32, transfer_id = 4 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 3
    npu.copy ins(%view_0 : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%2 : memref<256x16xf32, #npu.address_space<cbuf>>) {block_id = 7 : i32, crossCoreDeps = [6 : i32, 1 : i32], transfer_id = 6 : i32}
    npu.sync_block_set {block_id = 7 : i32, transfer_id = 6 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 4
    npu.sync_block_set {block_id = 7 : i32, transfer_id = 8 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 5
    npu.set_flag[<PIPE_V>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
    scf.for %arg6 = %c0 to %c128 step %c1 {
      npu.wait_flag[<PIPE_V>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.copy ins(%view_2 : memref<64x256xf32, #npu.address_space<cbuf>>) outs(%view_1 : memref<64x256xf32, #npu.address_space<ub>>) {block_id = 3 : i32}
      npu.set_flag[<PIPE_MTE1>, <PIPE_V>, <EVENT_ID0>]
      %c0_i64_10 = arith.constant 0 : i64
      %14 = npu.alloc(%c0_i64_10) : memref<16640xf32, #npu.address_space<ub>>
      npu.wait_flag[<PIPE_MTE1>, <PIPE_V>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
      npu.nd2nz_scatter ins(%view_1 : memref<64x256xf32, #npu.address_space<ub>>) outs(%14 : memref<16640xf32, #npu.address_space<ub>>) {block_id = 3 : i32}
      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      npu.set_flag[<PIPE_V>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      npu.copy ins(%14 : memref<16640xf32, #npu.address_space<ub>>) outs(%view : memref<64x256xf32, #npu.address_space<cbuf>>) {block_id = 3 : i32, linear_transfer}
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
    } {block_id = 9 : i32, tilelang.loop_kind = "serial"}
    npu.set_flag[<PIPE_MTE3>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.sync_block_set {block_id = 9 : i32, transfer_id = 3 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 6
    npu.wait_flag[<PIPE_MTE3>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%view : memref<64x256xf32, #npu.address_space<cbuf>>) outs(%3 : memref<64x256xf32, #npu.address_space<cbuf>>) {block_id = 9 : i32, crossCoreDeps = [5 : i32, 1 : i32], transfer_id = 5 : i32}
    npu.sync_block_set {block_id = 9 : i32, transfer_id = 5 : i32}[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 7
    npu.sync_block_set {block_id = 9 : i32, transfer_id = 7 : i32}[<VECTOR>, <PIPE_MTE2>, <PIPE_S>] flag = 8
    npu.sync_block_wait {block_id = 8 : i32, transfer_id = 9 : i32}[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 11
    npu.copy ins(%1 : memref<64x16xf32, #npu.address_space<ub>>) outs(%view_8 : memref<64x16xf32, #npu.address_space<ub>>) {block_id = 8 : i32}
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_8 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_6 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {block_id = 8 : i32}
    npu.sync_block_wait {block_id = 8 : i32, transfer_id = 10 : i32}[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 10
    npu.copy ins(%0 : memref<64x16xf32, #npu.address_space<ub>>) outs(%view_9 : memref<64x16xf32, #npu.address_space<ub>>) {block_id = 8 : i32}
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_9 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_7 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {block_id = 8 : i32}
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 9
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


module attributes {npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @l1ub_kernel_mix_aic(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c16384_i64 = arith.constant 16384 : i64
    %0 = npu.alloc(%c16384_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c34816_i64 = arith.constant 34816 : i64
    %2 = npu.alloc(%c34816_i64) : memref<16384xi8, #npu.address_space<ub>>
    %c32768_i64 = arith.constant 32768 : i64
    %3 = npu.alloc(%c32768_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c49152_i64 = arith.constant 49152 : i64
    %4 = npu.alloc(%c49152_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c0_i64_0 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_0) : memref<16x16xf32, #npu.address_space<cc>>
    %c1024_i64 = arith.constant 1024 : i64
    %6 = npu.alloc(%c1024_i64) : memref<16x16xf32, #npu.address_space<cc>>
    %c51200_i64 = arith.constant 51200 : i64
    %7 = npu.alloc(%c51200_i64) : memref<1024xi8, #npu.address_space<ub>>
    %c52224_i64 = arith.constant 52224 : i64
    %8 = npu.alloc(%c52224_i64) : memref<1024xi8, #npu.address_space<ub>>
    %c0_i64_1 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_1) : memref<4352xf32, #npu.address_space<ub>>
    %c0_i64_2 = arith.constant 0 : i64
    %10 = npu.alloc(%c0_i64_2) : memref<16x256xf32, #npu.address_space<ca>>
    %c0_i64_3 = arith.constant 0 : i64
    %11 = npu.alloc(%c0_i64_3) : memref<256x16xf32, #npu.address_space<cb>>
    %c17408_i64 = arith.constant 17408 : i64
    %12 = npu.alloc(%c17408_i64) : memref<4352xf32, #npu.address_space<ub>>
    %c16384_i64_4 = arith.constant 16384 : i64
    %13 = npu.alloc(%c16384_i64_4) : memref<16x256xf32, #npu.address_space<ca>>
    %c16384_i64_5 = arith.constant 16384 : i64
    %14 = npu.alloc(%c16384_i64_5) : memref<256x16xf32, #npu.address_space<cb>>
    %c32768_i64_6 = arith.constant 32768 : i64
    %15 = npu.alloc(%c32768_i64_6) : memref<16x256xf32, #npu.address_space<ca>>
    %c32768_i64_7 = arith.constant 32768 : i64
    %16 = npu.alloc(%c32768_i64_7) : memref<256x16xf32, #npu.address_space<cb>>
    %c49152_i64_8 = arith.constant 49152 : i64
    %17 = npu.alloc(%c49152_i64_8) : memref<16x256xf32, #npu.address_space<ca>>
    %c49152_i64_9 = arith.constant 49152 : i64
    %18 = npu.alloc(%c49152_i64_9) : memref<256x16xf32, #npu.address_space<cb>>
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 256], strides: [256, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x256xf32, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %view = memref.view %0[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %view_12 = memref.view %1[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %view_13 = memref.view %2[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<16x256xf32, #npu.address_space<ub>>
    %view_14 = memref.view %3[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %view_15 = memref.view %4[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %view_16 = memref.view %7[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    %view_17 = memref.view %8[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x256xf32, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x256xf32, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.copy ins(%reinterpret_cast_10 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_14 : memref<256x16xf32, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.copy ins(%reinterpret_cast_11 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_15 : memref<256x16xf32, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.sync_block_set[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 7
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 6
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 3
    npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
    scf.for %arg6 = %c0 to %c128 step %c1 {
      npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 1
      npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.copy ins(%view_12 : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%15 : memref<16x256xf32, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.copy ins(%view_14 : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%16 : memref<256x16xf32, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.mad ins(%15, %16 : memref<16x256xf32, #npu.address_space<ca>>, memref<256x16xf32, #npu.address_space<cb>>) outs(%5 : memref<16x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
      npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID0>]
      npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 6
      npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 2
      npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
      npu.copy ins(%view : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%17 : memref<16x256xf32, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.copy ins(%view_15 : memref<256x16xf32, #npu.address_space<cbuf>>) outs(%18 : memref<256x16xf32, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.mad ins(%17, %18 : memref<16x256xf32, #npu.address_space<ca>>, memref<256x16xf32, #npu.address_space<cb>>) outs(%6 : memref<16x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
      npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
      npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID1>]
      npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 3
    } {tilelang.loop_kind = "serial"}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%5 : memref<16x16xf32, #npu.address_space<cc>>) outs(%view_16 : memref<16x16xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 9
    npu.copy ins(%6 : memref<16x16xf32, #npu.address_space<cc>>) outs(%view_17 : memref<16x16xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 10
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 4
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @l1ub_kernel_mix_aiv(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c16384_i64 = arith.constant 16384 : i64
    %0 = npu.alloc(%c16384_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c34816_i64 = arith.constant 34816 : i64
    %2 = npu.alloc(%c34816_i64) : memref<16384xi8, #npu.address_space<ub>>
    %c32768_i64 = arith.constant 32768 : i64
    %3 = npu.alloc(%c32768_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c49152_i64 = arith.constant 49152 : i64
    %4 = npu.alloc(%c49152_i64) : memref<16384xi8, #npu.address_space<cbuf>>
    %c0_i64_0 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_0) : memref<16x16xf32, #npu.address_space<cc>>
    %c1024_i64 = arith.constant 1024 : i64
    %6 = npu.alloc(%c1024_i64) : memref<16x16xf32, #npu.address_space<cc>>
    %c51200_i64 = arith.constant 51200 : i64
    %7 = npu.alloc(%c51200_i64) : memref<1024xi8, #npu.address_space<ub>>
    %c52224_i64 = arith.constant 52224 : i64
    %8 = npu.alloc(%c52224_i64) : memref<1024xi8, #npu.address_space<ub>>
    %c0_i64_1 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_1) : memref<4352xf32, #npu.address_space<ub>>
    %c0_i64_2 = arith.constant 0 : i64
    %10 = npu.alloc(%c0_i64_2) : memref<16x256xf32, #npu.address_space<ca>>
    %c0_i64_3 = arith.constant 0 : i64
    %11 = npu.alloc(%c0_i64_3) : memref<256x16xf32, #npu.address_space<cb>>
    %c17408_i64 = arith.constant 17408 : i64
    %12 = npu.alloc(%c17408_i64) : memref<4352xf32, #npu.address_space<ub>>
    %c16384_i64_4 = arith.constant 16384 : i64
    %13 = npu.alloc(%c16384_i64_4) : memref<16x256xf32, #npu.address_space<ca>>
    %c16384_i64_5 = arith.constant 16384 : i64
    %14 = npu.alloc(%c16384_i64_5) : memref<256x16xf32, #npu.address_space<cb>>
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %view = memref.view %0[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %view_7 = memref.view %1[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %view_8 = memref.view %2[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<16x256xf32, #npu.address_space<ub>>
    %view_9 = memref.view %7[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    %view_10 = memref.view %8[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    npu.sync_block_wait[<VECTOR>, <PIPE_MTE2>, <PIPE_V>] flag = 7
    scf.for %arg6 = %c0 to %c128 step %c1 {
      npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 6
      npu.copy ins(%view : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%view_8 : memref<16x256xf32, #npu.address_space<ub>>) {linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      npu.nd2nz_scatter ins(%view_8 : memref<16x256xf32, #npu.address_space<ub>>) outs(%9 : memref<4352xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
      npu.copy ins(%9 : memref<4352xf32, #npu.address_space<ub>>) outs(%view_7 : memref<16x256xf32, #npu.address_space<cbuf>>) {linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
      npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 1
      npu.copy ins(%view_7 : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%view_8 : memref<16x256xf32, #npu.address_space<ub>>) {linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID1>]
      npu.nd2nz_scatter ins(%view_8 : memref<16x256xf32, #npu.address_space<ub>>) outs(%12 : memref<4352xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
      npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 3
      npu.copy ins(%12 : memref<4352xf32, #npu.address_space<ub>>) outs(%view : memref<16x256xf32, #npu.address_space<cbuf>>) {linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
      npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 2
    } {tilelang.loop_kind = "serial"}
    npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
    npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 9
    npu.copy ins(%view_9 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 10
    npu.copy ins(%view_10 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_6 : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 4
    %c32768_i64_11 = arith.constant 32768 : i64
    %15 = npu.alloc(%c32768_i64_11) : memref<16x256xf32, #npu.address_space<ca>>
    %c32768_i64_12 = arith.constant 32768 : i64
    %16 = npu.alloc(%c32768_i64_12) : memref<256x16xf32, #npu.address_space<cb>>
    %c49152_i64_13 = arith.constant 49152 : i64
    %17 = npu.alloc(%c49152_i64_13) : memref<16x256xf32, #npu.address_space<ca>>
    %c49152_i64_14 = arith.constant 49152 : i64
    %18 = npu.alloc(%c49152_i64_14) : memref<256x16xf32, #npu.address_space<cb>>
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


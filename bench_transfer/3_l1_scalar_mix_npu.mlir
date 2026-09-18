module attributes {npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @l1_scalar_kernel_mix_aic(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xbf16, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c24576_i64 = arith.constant 24576 : i64
    %1 = npu.alloc(%c24576_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c8192_i64 = arith.constant 8192 : i64
    %2 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c16384_i64 = arith.constant 16384 : i64
    %3 = npu.alloc(%c16384_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c0_i64_0 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_0) : memref<16x16xf32, #npu.address_space<cc>>
    %c1024_i64 = arith.constant 1024 : i64
    %5 = npu.alloc(%c1024_i64) : memref<16x16xf32, #npu.address_space<cc>>
    %c0_i64_1 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_1) : memref<1024xi8, #npu.address_space<ub>>
    %c1024_i64_2 = arith.constant 1024 : i64
    %7 = npu.alloc(%c1024_i64_2) : memref<1024xi8, #npu.address_space<ub>>
    %c0_i64_3 = arith.constant 0 : i64
    %8 = npu.alloc(%c0_i64_3) : memref<16x256xbf16, #npu.address_space<ca>>
    %c0_i64_4 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_4) : memref<256x16xbf16, #npu.address_space<cb>>
    %c8192_i64_5 = arith.constant 8192 : i64
    %10 = npu.alloc(%c8192_i64_5) : memref<16x256xbf16, #npu.address_space<ca>>
    %c8192_i64_6 = arith.constant 8192 : i64
    %11 = npu.alloc(%c8192_i64_6) : memref<256x16xbf16, #npu.address_space<cb>>
    %c16384_i64_7 = arith.constant 16384 : i64
    %12 = npu.alloc(%c16384_i64_7) : memref<16x256xbf16, #npu.address_space<ca>>
    %c16384_i64_8 = arith.constant 16384 : i64
    %13 = npu.alloc(%c16384_i64_8) : memref<256x16xbf16, #npu.address_space<cb>>
    %c24576_i64_9 = arith.constant 24576 : i64
    %14 = npu.alloc(%c24576_i64_9) : memref<16x256xbf16, #npu.address_space<ca>>
    %c24576_i64_10 = arith.constant 24576 : i64
    %15 = npu.alloc(%c24576_i64_10) : memref<256x16xbf16, #npu.address_space<cb>>
    %c256 = arith.constant 256 : index
    %c16 = arith.constant 16 : index
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %view = memref.view %0[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x256xbf16, #npu.address_space<cbuf>>
    %view_13 = memref.view %1[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x256xbf16, #npu.address_space<cbuf>>
    %view_14 = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %view_15 = memref.view %3[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %view_16 = memref.view %6[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    %view_17 = memref.view %7[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x256xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
    npu.copy ins(%reinterpret_cast_11 : memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_14 : memref<256x16xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.copy ins(%reinterpret_cast_12 : memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_15 : memref<256x16xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.set_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.set_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID1>]
    npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
    scf.for %arg6 = %c0 to %c2 step %c1 {
      npu.wait_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID0>]
      scf.for %arg7 = %c0 to %c16 step %c1 {
        scf.for %arg8 = %c0 to %c256 step %c1 {
          %16 = memref.load %view[%arg7, %arg8] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<16x256xbf16, #npu.address_space<cbuf>>
          memref.store %16, %view_13[%arg7, %arg8] {tcore_type = #npu.tcore_type<CUBE>} : memref<16x256xbf16, #npu.address_space<cbuf>>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
      npu.set_flag[<PIPE_S>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_S>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.copy ins(%view_13 : memref<16x256xbf16, #npu.address_space<cbuf>>) outs(%12 : memref<16x256xbf16, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.set_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID0>]
      npu.copy ins(%view_14 : memref<256x16xbf16, #npu.address_space<cbuf>>) outs(%13 : memref<256x16xbf16, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.mad ins(%12, %13 : memref<16x256xbf16, #npu.address_space<ca>>, memref<256x16xbf16, #npu.address_space<cb>>) outs(%4 : memref<16x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
      npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID1>]
      scf.for %arg7 = %c0 to %c16 step %c1 {
        scf.for %arg8 = %c0 to %c256 step %c1 {
          %16 = memref.load %view_13[%arg7, %arg8] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<16x256xbf16, #npu.address_space<cbuf>>
          memref.store %16, %view[%arg7, %arg8] {tcore_type = #npu.tcore_type<CUBE>} : memref<16x256xbf16, #npu.address_space<cbuf>>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
      npu.set_flag[<PIPE_S>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_S>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
      npu.copy ins(%view : memref<16x256xbf16, #npu.address_space<cbuf>>) outs(%14 : memref<16x256xbf16, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.set_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID1>]
      npu.copy ins(%view_15 : memref<256x16xbf16, #npu.address_space<cbuf>>) outs(%15 : memref<256x16xbf16, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
      npu.mad ins(%14, %15 : memref<16x256xbf16, #npu.address_space<ca>>, memref<256x16xbf16, #npu.address_space<cb>>) outs(%5 : memref<16x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
      npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
    } {tilelang.loop_kind = "serial"}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE1>, <PIPE_S>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%4 : memref<16x16xf32, #npu.address_space<cc>>) outs(%view_16 : memref<16x16xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 1
    npu.copy ins(%5 : memref<16x16xf32, #npu.address_space<cc>>) outs(%view_17 : memref<16x16xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 2
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 0
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @l1_scalar_kernel_mix_aiv(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xbf16, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c24576_i64 = arith.constant 24576 : i64
    %1 = npu.alloc(%c24576_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c8192_i64 = arith.constant 8192 : i64
    %2 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c16384_i64 = arith.constant 16384 : i64
    %3 = npu.alloc(%c16384_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c0_i64_0 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_0) : memref<16x16xf32, #npu.address_space<cc>>
    %c1024_i64 = arith.constant 1024 : i64
    %5 = npu.alloc(%c1024_i64) : memref<16x16xf32, #npu.address_space<cc>>
    %c0_i64_1 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_1) : memref<1024xi8, #npu.address_space<ub>>
    %c1024_i64_2 = arith.constant 1024 : i64
    %7 = npu.alloc(%c1024_i64_2) : memref<1024xi8, #npu.address_space<ub>>
    %c0_i64_3 = arith.constant 0 : i64
    %8 = npu.alloc(%c0_i64_3) : memref<16x256xbf16, #npu.address_space<ca>>
    %c0_i64_4 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_4) : memref<256x16xbf16, #npu.address_space<cb>>
    %c8192_i64_5 = arith.constant 8192 : i64
    %10 = npu.alloc(%c8192_i64_5) : memref<16x256xbf16, #npu.address_space<ca>>
    %c8192_i64_6 = arith.constant 8192 : i64
    %11 = npu.alloc(%c8192_i64_6) : memref<256x16xbf16, #npu.address_space<cb>>
    %c0 = arith.constant 0 : index
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %view = memref.view %6[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    %view_8 = memref.view %7[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 1
    npu.copy ins(%view : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 2
    npu.copy ins(%view_8 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_7 : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 0
    %c16384_i64_9 = arith.constant 16384 : i64
    %12 = npu.alloc(%c16384_i64_9) : memref<16x256xbf16, #npu.address_space<ca>>
    %c16384_i64_10 = arith.constant 16384 : i64
    %13 = npu.alloc(%c16384_i64_10) : memref<256x16xbf16, #npu.address_space<cb>>
    %c24576_i64_11 = arith.constant 24576 : i64
    %14 = npu.alloc(%c24576_i64_11) : memref<16x256xbf16, #npu.address_space<ca>>
    %c24576_i64_12 = arith.constant 24576 : i64
    %15 = npu.alloc(%c24576_i64_12) : memref<256x16xbf16, #npu.address_space<cb>>
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


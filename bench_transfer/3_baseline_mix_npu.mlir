module attributes {npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @baseline_kernel_mix_aic(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c0 = arith.constant 0 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %view = memref.view %1[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<64x256xbf16, #npu.address_space<cbuf>>
    %c32768_i64 = arith.constant 32768 : i64
    %2 = npu.alloc(%c32768_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %view_2 = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %c0_i64_3 = arith.constant 0 : i64
    %3 = npu.alloc(%c0_i64_3) : memref<64x16xf32, #npu.address_space<cc>>
    %c0_i64_4 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_4) : memref<4096xi8, #npu.address_space<ub>>
    %view_5 = memref.view %4[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    %c0_i64_6 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_6) : memref<64x256xbf16, #npu.address_space<ca>>
    %c0_i64_7 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_7) : memref<256x16xbf16, #npu.address_space<cb>>
    npu.copy ins(%reinterpret_cast : memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%reinterpret_cast_0 : memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_2 : memref<256x16xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%5 : memref<64x256xbf16, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.copy ins(%view_2 : memref<256x16xbf16, #npu.address_space<cbuf>>) outs(%6 : memref<256x16xbf16, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
    npu.mad ins(%5, %6 : memref<64x256xbf16, #npu.address_space<ca>>, memref<256x16xbf16, #npu.address_space<cb>>) outs(%3 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%3 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_5 : memref<64x16xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 0
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 1
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @baseline_kernel_mix_aiv(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c0 = arith.constant 0 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<256x16xbf16, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %view = memref.view %1[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<64x256xbf16, #npu.address_space<cbuf>>
    %c32768_i64 = arith.constant 32768 : i64
    %2 = npu.alloc(%c32768_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %view_2 = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<256x16xbf16, #npu.address_space<cbuf>>
    %c0_i64_3 = arith.constant 0 : i64
    %3 = npu.alloc(%c0_i64_3) : memref<64x16xf32, #npu.address_space<cc>>
    %c0_i64_4 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_4) : memref<4096xi8, #npu.address_space<ub>>
    %view_5 = memref.view %4[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<64x16xf32, #npu.address_space<ub>>
    %c0_i64_6 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_6) : memref<64x256xbf16, #npu.address_space<ca>>
    %c0_i64_7 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_7) : memref<256x16xbf16, #npu.address_space<cb>>
    npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 0
    npu.copy ins(%view_5 : memref<64x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<64x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 1
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


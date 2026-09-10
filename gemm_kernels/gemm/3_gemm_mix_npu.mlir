module attributes {npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @gemm_kernel_mix_aic(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c0 = arith.constant 0 : index
    %c16_i32 = arith.constant 16 : i32
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<128x128xbf16, strided<[128, 1]>, #npu.address_space<gm>>
    %c32768_i64 = arith.constant 32768 : i64
    %2 = npu.alloc(%c32768_i64) : memref<4096xi8, #npu.address_space<cbuf>>
    %view = memref.view %2[%c0][] : memref<4096xi8, #npu.address_space<cbuf>> to memref<16x128xbf16, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %3 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %view_0 = memref.view %3[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<128x128xbf16, #npu.address_space<cbuf>>
    %c0_i64_1 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_1) : memref<16x128xf32, #npu.address_space<cc>>
    %c0_i64_2 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_2) : memref<8192xi8, #npu.address_space<ub>>
    %view_3 = memref.view %5[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %6 = arith.muli %1, %c16_i32 : i32
    %7 = arith.index_cast %6 : i32 to index
    %8 = arith.muli %7, %c128 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [%8], sizes: [16, 128], strides: [128, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x128xbf16, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    %c0_i64_5 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_5) : memref<16x128xbf16, #npu.address_space<ca>>
    %c0_i64_6 = arith.constant 0 : i64
    %10 = npu.alloc(%c0_i64_6) : memref<128x128xbf16, #npu.address_space<cb>>
    %11 = arith.muli %1, %c16_i32 : i32
    %12 = arith.index_cast %11 : i32 to index
    %13 = arith.muli %12, %c128 : index
    %reinterpret_cast_7 = memref.reinterpret_cast %arg2 to offset: [%13], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast_4 : memref<16x128xbf16, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%reinterpret_cast : memref<128x128xbf16, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view_0 : memref<128x128xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%view : memref<16x128xbf16, #npu.address_space<cbuf>>) outs(%9 : memref<16x128xbf16, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.copy ins(%view_0 : memref<128x128xbf16, #npu.address_space<cbuf>>) outs(%10 : memref<128x128xbf16, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
    npu.mad ins(%9, %10 : memref<16x128xbf16, #npu.address_space<ca>>, memref<128x128xbf16, #npu.address_space<cb>>) outs(%4 : memref<16x128xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%4 : memref<16x128xf32, #npu.address_space<cc>>) outs(%view_3 : memref<16x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 0
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 1
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @gemm_kernel_mix_aiv(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c0 = arith.constant 0 : index
    %c16_i32 = arith.constant 16 : i32
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<128x128xbf16, strided<[128, 1]>, #npu.address_space<gm>>
    %c32768_i64 = arith.constant 32768 : i64
    %2 = npu.alloc(%c32768_i64) : memref<4096xi8, #npu.address_space<cbuf>>
    %view = memref.view %2[%c0][] : memref<4096xi8, #npu.address_space<cbuf>> to memref<16x128xbf16, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %3 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %view_0 = memref.view %3[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<128x128xbf16, #npu.address_space<cbuf>>
    %c0_i64_1 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_1) : memref<16x128xf32, #npu.address_space<cc>>
    %c0_i64_2 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64_2) : memref<8192xi8, #npu.address_space<ub>>
    %view_3 = memref.view %5[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %6 = arith.muli %1, %c16_i32 : i32
    %7 = arith.index_cast %6 : i32 to index
    %8 = arith.muli %7, %c128 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [%8], sizes: [16, 128], strides: [128, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x128xbf16, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    %c0_i64_5 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_5) : memref<16x128xbf16, #npu.address_space<ca>>
    %c0_i64_6 = arith.constant 0 : i64
    %10 = npu.alloc(%c0_i64_6) : memref<128x128xbf16, #npu.address_space<cb>>
    %11 = arith.muli %1, %c16_i32 : i32
    %12 = arith.index_cast %11 : i32 to index
    %13 = arith.muli %12, %c128 : index
    %reinterpret_cast_7 = memref.reinterpret_cast %arg2 to offset: [%13], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 0
    npu.copy ins(%view_3 : memref<16x128xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_7 : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 1
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


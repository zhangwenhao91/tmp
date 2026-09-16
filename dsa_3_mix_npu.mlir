module attributes {npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @main_mix_aic(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xi32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32, %arg6: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %c32768_i64 = arith.constant 32768 : i64
    %1 = npu.alloc(%c32768_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c40960_i64 = arith.constant 40960 : i64
    %2 = npu.alloc(%c40960_i64) : memref<2048xi8, #npu.address_space<cbuf>>
    %c85504_i64 = arith.constant 85504 : i64
    %3 = npu.alloc(%c85504_i64) : memref<512xi8, #npu.address_space<ub>>
    %c74240_i64 = arith.constant 74240 : i64
    %4 = npu.alloc(%c74240_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c65536_i64 = arith.constant 65536 : i64
    %5 = npu.alloc(%c65536_i64) : memref<64x16xf32, #npu.address_space<cc>>
    %c0_i64_0 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_0) : memref<64x256xf32, #npu.address_space<cc>>
    %c82432_i64 = arith.constant 82432 : i64
    %7 = npu.alloc(%c82432_i64) : memref<2048xi8, #npu.address_space<ub>>
    %c84480_i64 = arith.constant 84480 : i64
    %8 = npu.alloc(%c84480_i64) : memref<1024xi8, #npu.address_space<ub>>
    %c0_i64_1 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_1) : memref<32768xi8, #npu.address_space<ub>>
    %c32768_i64_2 = arith.constant 32768 : i64
    %10 = npu.alloc(%c32768_i64_2) : memref<32768xi8, #npu.address_space<ub>>
    %c86016_i64 = arith.constant 86016 : i64
    %11 = npu.alloc(%c86016_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86144_i64 = arith.constant 86144 : i64
    %12 = npu.alloc(%c86144_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86272_i64 = arith.constant 86272 : i64
    %13 = npu.alloc(%c86272_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86400_i64 = arith.constant 86400 : i64
    %14 = npu.alloc(%c86400_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86528_i64 = arith.constant 86528 : i64
    %15 = npu.alloc(%c86528_i64) : memref<128xi8, #npu.address_space<ub>>
    %c65536_i64_3 = arith.constant 65536 : i64
    %16 = npu.alloc(%c65536_i64_3) : memref<4352xbf16, #npu.address_space<ub>>
    %c0_i64_4 = arith.constant 0 : i64
    %17 = npu.alloc(%c0_i64_4) : memref<64x256xbf16, #npu.address_space<ca>>
    %c0_i64_5 = arith.constant 0 : i64
    %18 = npu.alloc(%c0_i64_5) : memref<16x256xbf16, #npu.address_space<cb>>
    %c0_i64_6 = arith.constant 0 : i64
    %19 = npu.alloc(%c0_i64_6) : memref<64x16xbf16, #npu.address_space<ca>>
    %c8192_i64 = arith.constant 8192 : i64
    %20 = npu.alloc(%c8192_i64) : memref<16x256xbf16, #npu.address_space<cb>>
    %c0_i64_7 = arith.constant 0 : i64
    %21 = npu.alloc(%c0_i64_7) : memref<64x256xbf16, #npu.address_space<ca>>
    %c16384_i64 = arith.constant 16384 : i64
    %22 = npu.alloc(%c16384_i64) : memref<16x256xbf16, #npu.address_space<cb>>
    %c32768_i64_8 = arith.constant 32768 : i64
    %23 = npu.alloc(%c32768_i64_8) : memref<64x16xbf16, #npu.address_space<ca>>
    %c24576_i64 = arith.constant 24576 : i64
    %24 = npu.alloc(%c24576_i64) : memref<16x256xbf16, #npu.address_space<cb>>
    %c8 = arith.constant 8 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c1 = arith.constant 1 : index
    %c16384 = arith.constant 16384 : index
    %25 = npu.get_block_idx() : i64
    %26 = arith.trunci %25 : i64 to i32
    %view = memref.view %0[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<64x256xbf16, #npu.address_space<cbuf>>
    %view_9 = memref.view %1[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x256xbf16, #npu.address_space<cbuf>>
    %view_10 = memref.view %2[%c0][] : memref<2048xi8, #npu.address_space<cbuf>> to memref<64x16xbf16, #npu.address_space<cbuf>>
    %view_11 = memref.view %7[%c0][] : memref<2048xi8, #npu.address_space<ub>> to memref<32x16xf32, #npu.address_space<ub>>
    %view_12 = memref.view %10[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<32x256xf32, #npu.address_space<ub>>
    npu.set_flag[<PIPE_MTE1>, <PIPE_MTE2>, <EVENT_ID0>]
    scf.for %arg7 = %c0 to %c128 step %c1 {
      %27 = arith.muli %26, %c128_i32 : i32
      %28 = arith.index_cast %27 : i32 to index
      %29 = arith.addi %28, %arg7 : index
      %30 = arith.muli %29, %c16384 : index
      %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%30], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
      npu.wait_flag[<PIPE_MTE1>, <PIPE_MTE2>, <EVENT_ID0>]
      npu.copy ins(%reinterpret_cast : memref<64x256xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
      npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.set_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID0>]
      npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
      npu.set_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID1>]
      scf.for %arg8 = %c0 to %c8 step %c1 {
        npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
        npu.copy ins(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%21 : memref<64x256xbf16, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
        npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 0
        npu.copy ins(%view_9 : memref<16x256xbf16, #npu.address_space<cbuf>>) outs(%22 : memref<16x256xbf16, #npu.address_space<cb>>) {Transposed = true, tcore_type = #npu.tcore_type<CUBE>}
        npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID0>]
        npu.mad ins(%21, %22 : memref<64x256xbf16, #npu.address_space<ca>>, memref<16x256xbf16, #npu.address_space<cb>>) outs(%5 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = true, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
        npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
        npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
        npu.copy ins(%5 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_11 : memref<32x16xf32, #npu.address_space<ub>>) {split_dim = 0 : i64, tcore_type = #npu.tcore_type<CUBE>}
        npu.set_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID0>]
        npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 4
        npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 1
        npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
        npu.copy ins(%view_10 : memref<64x16xbf16, #npu.address_space<cbuf>>) outs(%23 : memref<64x16xbf16, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
        npu.copy ins(%view_9 : memref<16x256xbf16, #npu.address_space<cbuf>>) outs(%24 : memref<16x256xbf16, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
        npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID1>]
        npu.mad ins(%23, %24 : memref<64x16xbf16, #npu.address_space<ca>>, memref<16x256xbf16, #npu.address_space<cb>>) outs(%6 : memref<64x256xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = true}
        npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
        npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
        npu.copy ins(%6 : memref<64x256xf32, #npu.address_space<cc>>) outs(%view_12 : memref<32x256xf32, #npu.address_space<ub>>) {split_dim = 0 : i64, tcore_type = #npu.tcore_type<CUBE>}
        npu.set_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID1>]
        npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 5
        npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 2
        npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 2
      } {tilelang.loop_kind = "serial"}
      npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID0>]
      npu.set_flag[<PIPE_MTE1>, <PIPE_MTE2>, <EVENT_ID0>]
    } {num_stages = 2 : i64, tilelang.loop_kind = "pipelined"}
    npu.wait_flag[<PIPE_MTE1>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 3
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @main_mix_aiv(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xi32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32, %arg6: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<32768xi8, #npu.address_space<cbuf>>
    %c32768_i64 = arith.constant 32768 : i64
    %1 = npu.alloc(%c32768_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c40960_i64 = arith.constant 40960 : i64
    %2 = npu.alloc(%c40960_i64) : memref<2048xi8, #npu.address_space<cbuf>>
    %c85504_i64 = arith.constant 85504 : i64
    %3 = npu.alloc(%c85504_i64) : memref<512xi8, #npu.address_space<ub>>
    %c74240_i64 = arith.constant 74240 : i64
    %4 = npu.alloc(%c74240_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c65536_i64 = arith.constant 65536 : i64
    %5 = npu.alloc(%c65536_i64) : memref<64x16xf32, #npu.address_space<cc>>
    %c0_i64_0 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_0) : memref<64x256xf32, #npu.address_space<cc>>
    %c82432_i64 = arith.constant 82432 : i64
    %7 = npu.alloc(%c82432_i64) : memref<2048xi8, #npu.address_space<ub>>
    %c84480_i64 = arith.constant 84480 : i64
    %8 = npu.alloc(%c84480_i64) : memref<1024xi8, #npu.address_space<ub>>
    %c0_i64_1 = arith.constant 0 : i64
    %9 = npu.alloc(%c0_i64_1) : memref<32768xi8, #npu.address_space<ub>>
    %c32768_i64_2 = arith.constant 32768 : i64
    %10 = npu.alloc(%c32768_i64_2) : memref<32768xi8, #npu.address_space<ub>>
    %c86016_i64 = arith.constant 86016 : i64
    %11 = npu.alloc(%c86016_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86144_i64 = arith.constant 86144 : i64
    %12 = npu.alloc(%c86144_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86272_i64 = arith.constant 86272 : i64
    %13 = npu.alloc(%c86272_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86400_i64 = arith.constant 86400 : i64
    %14 = npu.alloc(%c86400_i64) : memref<128xi8, #npu.address_space<ub>>
    %c86528_i64 = arith.constant 86528 : i64
    %15 = npu.alloc(%c86528_i64) : memref<128xi8, #npu.address_space<ub>>
    %c65536_i64_3 = arith.constant 65536 : i64
    %16 = npu.alloc(%c65536_i64_3) : memref<4352xbf16, #npu.address_space<ub>>
    %c0_i64_4 = arith.constant 0 : i64
    %17 = npu.alloc(%c0_i64_4) : memref<64x256xbf16, #npu.address_space<ca>>
    %c0_i64_5 = arith.constant 0 : i64
    %18 = npu.alloc(%c0_i64_5) : memref<16x256xbf16, #npu.address_space<cb>>
    %c0_i64_6 = arith.constant 0 : i64
    %19 = npu.alloc(%c0_i64_6) : memref<64x16xbf16, #npu.address_space<ca>>
    %c8192_i64 = arith.constant 8192 : i64
    %20 = npu.alloc(%c8192_i64) : memref<16x256xbf16, #npu.address_space<cb>>
    %c1_i64 = arith.constant 1 : i64
    %c16 = arith.constant 16 : index
    %c8 = arith.constant 8 : index
    %c128 = arith.constant 128 : index
    %c0 = arith.constant 0 : index
    %c128_i32 = arith.constant 128 : i32
    %c1 = arith.constant 1 : index
    %c16384 = arith.constant 16384 : index
    %c256 = arith.constant 256 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_7 = arith.constant 1.000000e+00 : f32
    %c32_i32 = arith.constant 32 : i32
    %cst_8 = arith.constant 6.250000e-02 : f32
    %21 = npu.get_sub_block_idx() : i64
    %22 = arith.trunci %21 : i64 to i32
    %23 = npu.get_block_idx() : i64
    %24 = arith.trunci %23 : i64 to i32
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [1, 4096, 128], strides: [524288, 128, 1] : memref<?xi32, #npu.address_space<gm>> to memref<1x4096x128xi32, strided<[524288, 128, 1]>, #npu.address_space<gm>>
    %view = memref.view %1[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x256xbf16, #npu.address_space<cbuf>>
    %view_9 = memref.view %2[%c0][] : memref<2048xi8, #npu.address_space<cbuf>> to memref<64x16xbf16, #npu.address_space<cbuf>>
    %view_10 = memref.view %3[%c0][] : memref<512xi8, #npu.address_space<ub>> to memref<128xi32, #npu.address_space<ub>>
    %view_11 = memref.view %4[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x256xbf16, #npu.address_space<ub>>
    %view_12 = memref.view %7[%c0][] : memref<2048xi8, #npu.address_space<ub>> to memref<32x16xf32, #npu.address_space<ub>>
    %view_13 = memref.view %8[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<32x16xbf16, #npu.address_space<ub>>
    %view_14 = memref.view %9[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<32x256xf32, #npu.address_space<ub>>
    %view_15 = memref.view %10[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<32x256xf32, #npu.address_space<ub>>
    %view_16 = memref.view %11[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %view_17 = memref.view %12[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %view_18 = memref.view %13[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %view_19 = memref.view %14[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %view_20 = memref.view %15[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID2>]
    npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID1>]
    scf.for %arg7 = %c0 to %c128 step %c1 {
      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID2>]
      npu.scope() {
        %39 = npu.broadcast %cst : f32 -> vector<32x256xf32> {tcore_type = #npu.tcore_type<VECTOR>}
        npu.vstore %39, %view_14 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32x256xf32>, memref<32x256xf32, #npu.address_space<ub>>) -> ()
        %40 = npu.broadcast %cst_7 : f32 -> vector<32xf32> {tcore_type = #npu.tcore_type<VECTOR>}
        npu.vstore %40, %view_19 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      %29 = arith.muli %22, %c32_i32 : i32
      %30 = arith.index_cast %29 : i32 to index
      %reinterpret_cast_23 = memref.reinterpret_cast %arg2 to offset: [%30], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
      npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID1>]
      npu.copy ins(%reinterpret_cast_23 : memref<32xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%view_16 : memref<32xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
      scf.for %arg8 = %c0 to %c128 step %c1 {
        %39 = arith.muli %24, %c128_i32 : i32
        %40 = arith.index_cast %39 : i32 to index
        %41 = arith.addi %40, %arg7 : index
        %42 = memref.load %reinterpret_cast[%c0, %41, %arg8] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1x4096x128xi32, strided<[524288, 128, 1]>, #npu.address_space<gm>>
        memref.store %42, %view_10[%arg8] {tcore_type = #npu.tcore_type<VECTOR>} : memref<128xi32, #npu.address_space<ub>>
      } {tilelang.loop_kind = "serial"}
      npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
      npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
      scf.for %arg8 = %c0 to %c8 step %c1 {
        npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
        scf.for %arg9 = %c0 to %c16 step %c1 {
          %39 = arith.muli %arg8, %c16 : index
          %40 = arith.addi %39, %arg9 : index
          %41 = memref.load %view_10[%40] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<128xi32, #npu.address_space<ub>>
          %42 = arith.index_cast %41 : i32 to index
          %43 = arith.muli %42, %c256 : index
          %reinterpret_cast_25 = memref.reinterpret_cast %arg1 to offset: [%43], sizes: [256], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>
          %44 = arith.muli %arg9, %c256 : index
          %reinterpret_cast_26 = memref.reinterpret_cast %view_11 to offset: [%44], sizes: [256], strides: [1] : memref<16x256xbf16, #npu.address_space<ub>> to memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<ub>>
          npu.copy ins(%reinterpret_cast_25 : memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%reinterpret_cast_26 : memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
        } {tilelang.loop_kind = "serial"}
        npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
        npu.nd2nz_scatter ins(%view_11 : memref<16x256xbf16, #npu.address_space<ub>>) outs(%16 : memref<4352xbf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
        npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
        npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
        npu.copy ins(%16 : memref<4352xbf16, #npu.address_space<ub>>) outs(%view : memref<16x256xbf16, #npu.address_space<cbuf>>) {linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}
        npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
        npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 0
        npu.scope() {
          npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 4
          %39 = npu.vload %view_12 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32x16xf32, #npu.address_space<ub>>) -> vector<32x16xf32>
          %40 = npu.mul %39, %cst_8 : vector<32x16xf32>, f32 -> vector<32x16xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %40, %view_12 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32x16xf32>, memref<32x16xf32, #npu.address_space<ub>>) -> ()
          npu.copy ins(%view_16 : memref<32xf32, #npu.address_space<ub>>) outs(%view_17 : memref<32xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
          %41 = npu.reduce %40, %c1_i64 : vector<32x16xf32>, i64 -> vector<32xf32> #npu.reduce_op<max> identities=[0xFF800000 : f32] {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %41, %view_16 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
        npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
        npu.scope() {
          %39 = npu.vload %view_12 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32x16xf32, #npu.address_space<ub>>) -> vector<32x16xf32>
          %40 = npu.vload %view_16 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %41 = npu.vload %view_17 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %42 = npu.max %40, %41 : vector<32xf32>, vector<32xf32> -> vector<32xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %42, %view_16 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          %43 = npu.broadcast %42 : vector<32xf32> -> vector<32x16xf32> {broadcast_dim = 1 : i64, tcore_type = #npu.tcore_type<VECTOR>}
          %44 = npu.sub %39, %43 : vector<32x16xf32>, vector<32x16xf32> -> vector<32x16xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          %45 = npu.exp %44 : vector<32x16xf32> -> vector<32x16xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          %46 = npu.cvt %45 : vector<32x16xf32> -> vector<32x16xbf16> {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %46, %view_13 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32x16xbf16>, memref<32x16xbf16, #npu.address_space<ub>>) -> ()
          %47 = npu.reduce %45, %c1_i64 : vector<32x16xf32>, i64 -> vector<32xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32] {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %47, %view_18 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
        npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
        npu.scope() {
          %39 = npu.vload %view_17 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %40 = npu.vload %view_16 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %41 = npu.vload %view_19 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %42 = npu.vload %view_18 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %43 = npu.sub %39, %40 : vector<32xf32>, vector<32xf32> -> vector<32xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          %44 = npu.exp %43 : vector<32xf32> -> vector<32xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %44, %view_20 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          %45 = npu.mul %41, %44 : vector<32xf32>, vector<32xf32> -> vector<32xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          %46 = npu.add %45, %42 : vector<32xf32>, vector<32xf32> -> vector<32xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %46, %view_19 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
        npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
        npu.copy ins(%view_13 : memref<32x16xbf16, #npu.address_space<ub>>) outs(%view_9 : memref<64x16xbf16, #npu.address_space<cbuf>>) {split_dim = 0 : i64, tcore_type = #npu.tcore_type<VECTOR>}
        npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
        npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 1
        npu.scope() {
          %39 = npu.vload %view_14 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32x256xf32, #npu.address_space<ub>>) -> vector<32x256xf32>
          npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 5
          %40 = npu.vload %view_15 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32x256xf32, #npu.address_space<ub>>) -> vector<32x256xf32>
          %41 = npu.vload %view_20 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %42 = npu.broadcast %41 : vector<32xf32> -> vector<32x256xf32> {broadcast_dim = 1 : i64, tcore_type = #npu.tcore_type<VECTOR>}
          %43 = npu.mul %39, %42 : vector<32x256xf32>, vector<32x256xf32> -> vector<32x256xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          %44 = npu.add %43, %40 : vector<32x256xf32>, vector<32x256xf32> -> vector<32x256xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          npu.vstore %44, %view_14 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32x256xf32>, memref<32x256xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
        npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 2
        npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 2
      } {tilelang.loop_kind = "serial"}
      npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
      npu.scope() {
        %39 = npu.vload %view_14 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32x256xf32, #npu.address_space<ub>>) -> vector<32x256xf32>
        %40 = npu.vload %view_19 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
        %41 = npu.broadcast %40 : vector<32xf32> -> vector<32x256xf32> {broadcast_dim = 1 : i64, tcore_type = #npu.tcore_type<VECTOR>}
        %42 = npu.div %39, %41 : vector<32x256xf32>, vector<32x256xf32> -> vector<32x256xf32> {tcore_type = #npu.tcore_type<VECTOR>}
        npu.vstore %42, %view_14 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<32x256xf32>, memref<32x256xf32, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      %31 = arith.muli %24, %c128_i32 : i32
      %32 = arith.index_cast %31 : i32 to index
      %33 = arith.addi %32, %arg7 : index
      %34 = arith.muli %33, %c16384 : index
      %35 = arith.muli %22, %c32_i32 : i32
      %36 = arith.index_cast %35 : i32 to index
      %37 = arith.muli %36, %c256 : index
      %38 = arith.addi %34, %37 : index
      %reinterpret_cast_24 = memref.reinterpret_cast %arg4 to offset: [%38], sizes: [32, 256], strides: [256, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x256xf32, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      npu.copy ins(%view_14 : memref<32x256xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_24 : memref<32x256xf32, strided<[256, 1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID2>]
    } {num_stages = 2 : i64, tilelang.loop_kind = "pipelined"}
    npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID2>]
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 3
    %c0_i64_21 = arith.constant 0 : i64
    %25 = npu.alloc(%c0_i64_21) : memref<64x256xbf16, #npu.address_space<ca>>
    %c16384_i64 = arith.constant 16384 : i64
    %26 = npu.alloc(%c16384_i64) : memref<16x256xbf16, #npu.address_space<cb>>
    %c32768_i64_22 = arith.constant 32768 : i64
    %27 = npu.alloc(%c32768_i64_22) : memref<64x16xbf16, #npu.address_space<ca>>
    %c24576_i64 = arith.constant 24576 : i64
    %28 = npu.alloc(%c24576_i64) : memref<16x256xbf16, #npu.address_space<cb>>
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


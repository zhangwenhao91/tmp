module attributes {npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @mixCV_kernel_mix_aic(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c65536_i64 = arith.constant 65536 : i64
    %0 = npu.alloc(%c65536_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<65536xi8, #npu.address_space<cbuf>>
    %c0_i64_0 = arith.constant 0 : i64
    %2 = npu.alloc(%c0_i64_0) : memref<8192xi8, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %3 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c0_i64_1 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_1) : memref<16x128xf32, #npu.address_space<cc>>
    %c16384_i64 = arith.constant 16384 : i64
    %5 = npu.alloc(%c16384_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c0_i64_2 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_2) : memref<16x128xf32, #npu.address_space<ca>>
    %c0_i64_3 = arith.constant 0 : i64
    %7 = npu.alloc(%c0_i64_3) : memref<128x128xf32, #npu.address_space<cb>>
    %c0 = arith.constant 0 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<128x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %view = memref.view %0[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x128xf32, #npu.address_space<cbuf>>
    %view_5 = memref.view %1[%c0][] : memref<65536xi8, #npu.address_space<cbuf>> to memref<128x128xf32, #npu.address_space<cbuf>>
    %view_6 = memref.view %5[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%reinterpret_cast_4 : memref<128x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view_5 : memref<128x128xf32, #npu.address_space<cbuf>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]
    npu.copy ins(%view : memref<16x128xf32, #npu.address_space<cbuf>>) outs(%6 : memref<16x128xf32, #npu.address_space<ca>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID1>]
    npu.copy ins(%view_5 : memref<128x128xf32, #npu.address_space<cbuf>>) outs(%7 : memref<128x128xf32, #npu.address_space<cb>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.set_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE1>, <PIPE_M>, <EVENT_ID0>]
    npu.mad ins(%6, %7 : memref<16x128xf32, #npu.address_space<ca>>, memref<128x128xf32, #npu.address_space<cb>>) outs(%4 : memref<16x128xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, tcore_type = #npu.tcore_type<CUBE>, zero_init = false}
    npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]
    npu.copy ins(%4 : memref<16x128xf32, #npu.address_space<cc>>) outs(%view_6 : memref<16x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<CUBE>}
    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_V>] flag = 1
    npu.sync_block_wait[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 0
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @mixCV_kernel_mix_aiv(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c65536_i64 = arith.constant 65536 : i64
    %0 = npu.alloc(%c65536_i64) : memref<8192xi8, #npu.address_space<cbuf>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<65536xi8, #npu.address_space<cbuf>>
    %c0_i64_0 = arith.constant 0 : i64
    %2 = npu.alloc(%c0_i64_0) : memref<8192xi8, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %3 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c0_i64_1 = arith.constant 0 : i64
    %4 = npu.alloc(%c0_i64_1) : memref<16x128xf32, #npu.address_space<cc>>
    %c16384_i64 = arith.constant 16384 : i64
    %5 = npu.alloc(%c16384_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c0_i64_2 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_2) : memref<16x128xf32, #npu.address_space<ca>>
    %c0_i64_3 = arith.constant 0 : i64
    %7 = npu.alloc(%c0_i64_3) : memref<128x128xf32, #npu.address_space<cb>>
    %c64 = arith.constant 64 : index
    %c2 = arith.constant 2 : index
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %view = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %view_5 = memref.view %3[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %view_6 = memref.view %5[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      scf.for %arg5 = %c0 to %c16 step %c1 {
        scf.for %arg6 = %c0 to %c2 step %c1 {
          %8 = arith.muli %arg5, %c128 : index
          %9 = arith.muli %arg6, %c64 : index
          %10 = arith.addi %8, %9 : index
          %reinterpret_cast_7 = memref.reinterpret_cast %view_6 to offset: [%10], sizes: [64], strides: [1] : memref<16x128xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
          npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 1
          %11 = npu.vload %reinterpret_cast_7 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> vector<64xf32>
          %12 = arith.muli %arg5, %c128 : index
          %13 = arith.muli %arg6, %c64 : index
          %14 = arith.addi %12, %13 : index
          %reinterpret_cast_8 = memref.reinterpret_cast %view to offset: [%14], sizes: [64], strides: [1] : memref<16x128xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
          %15 = npu.vload %reinterpret_cast_8 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> vector<64xf32>
          %16 = npu.add %11, %15 : vector<64xf32>, vector<64xf32> -> vector<64xf32> {tcore_type = #npu.tcore_type<VECTOR>}
          %17 = arith.muli %arg5, %c128 : index
          %18 = arith.muli %arg6, %c64 : index
          %19 = arith.addi %17, %18 : index
          %reinterpret_cast_9 = memref.reinterpret_cast %view_5 to offset: [%19], sizes: [64], strides: [1] : memref<16x128xf32, #npu.address_space<ub>> to memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>
          npu.vstore %16, %reinterpret_cast_9 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<64xf32>, memref<64xf32, strided<[1], offset: ?>, #npu.address_space<ub>>) -> ()
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_5 : memref<16x128xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_4 : memref<16x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 0
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


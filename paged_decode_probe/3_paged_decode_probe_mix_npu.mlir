module attributes {npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @paged_decode_probe_kernel_mix_aic(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xbf16, #npu.address_space<gm>>, %arg3: memref<?xi32, #npu.address_space<gm>>, %arg4: memref<?xi32, #npu.address_space<gm>>, %arg5: memref<?xbf16, #npu.address_space<gm>>, %arg6: i32) attributes {func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c37888_i64 = arith.constant 37888 : i64
    %0 = npu.alloc(%c37888_i64) : memref<256xi8, #npu.address_space<ub>>
    %c24576_i64 = arith.constant 24576 : i64
    %1 = npu.alloc(%c24576_i64) : memref<4096xi8, #npu.address_space<ub>>
    %c28672_i64 = arith.constant 28672 : i64
    %2 = npu.alloc(%c28672_i64) : memref<4096xi8, #npu.address_space<ub>>
    %c32768_i64 = arith.constant 32768 : i64
    %3 = npu.alloc(%c32768_i64) : memref<4096xi8, #npu.address_space<ub>>
    %c38144_i64 = arith.constant 38144 : i64
    %4 = npu.alloc(%c38144_i64) : memref<256xi8, #npu.address_space<ub>>
    %c0_i64 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c16384_i64 = arith.constant 16384 : i64
    %6 = npu.alloc(%c16384_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %7 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c39168_i64 = arith.constant 39168 : i64
    %8 = npu.alloc(%c39168_i64) : memref<64xi8, #npu.address_space<ub>>
    %c39232_i64 = arith.constant 39232 : i64
    %9 = npu.alloc(%c39232_i64) : memref<64xi8, #npu.address_space<ub>>
    %c39296_i64 = arith.constant 39296 : i64
    %10 = npu.alloc(%c39296_i64) : memref<64xi8, #npu.address_space<ub>>
    %c36864_i64 = arith.constant 36864 : i64
    %11 = npu.alloc(%c36864_i64) : memref<512xi8, #npu.address_space<ub>>
    %c37376_i64 = arith.constant 37376 : i64
    %12 = npu.alloc(%c37376_i64) : memref<512xi8, #npu.address_space<ub>>
    %c39360_i64 = arith.constant 39360 : i64
    %13 = npu.alloc(%c39360_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39392_i64 = arith.constant 39392 : i64
    %14 = npu.alloc(%c39392_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39424_i64 = arith.constant 39424 : i64
    %15 = npu.alloc(%c39424_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39456_i64 = arith.constant 39456 : i64
    %16 = npu.alloc(%c39456_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39488_i64 = arith.constant 39488 : i64
    %17 = npu.alloc(%c39488_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39520_i64 = arith.constant 39520 : i64
    %18 = npu.alloc(%c39520_i64) : memref<4xi8, #npu.address_space<ub>>
    %c38400_i64 = arith.constant 38400 : i64
    %19 = npu.alloc(%c38400_i64) : memref<256xi8, #npu.address_space<ub>>
    %c38656_i64 = arith.constant 38656 : i64
    %20 = npu.alloc(%c38656_i64) : memref<256xi8, #npu.address_space<ub>>
    %c38912_i64 = arith.constant 38912 : i64
    %21 = npu.alloc(%c38912_i64) : memref<256xi8, #npu.address_space<ub>>
    npu.sync_block_wait {npu.logical_sync_id = 1 : i64}[<CUBE>, <PIPE_MTE3>, <PIPE_FIX>] flag = 0
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
  func.func @paged_decode_probe_kernel_mix_aiv(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xbf16, #npu.address_space<gm>>, %arg3: memref<?xi32, #npu.address_space<gm>>, %arg4: memref<?xi32, #npu.address_space<gm>>, %arg5: memref<?xbf16, #npu.address_space<gm>>, %arg6: i32) attributes {func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c37888_i64 = arith.constant 37888 : i64
    %0 = npu.alloc(%c37888_i64) : memref<256xi8, #npu.address_space<ub>>
    %c24576_i64 = arith.constant 24576 : i64
    %1 = npu.alloc(%c24576_i64) : memref<4096xi8, #npu.address_space<ub>>
    %c28672_i64 = arith.constant 28672 : i64
    %2 = npu.alloc(%c28672_i64) : memref<4096xi8, #npu.address_space<ub>>
    %c32768_i64 = arith.constant 32768 : i64
    %3 = npu.alloc(%c32768_i64) : memref<4096xi8, #npu.address_space<ub>>
    %c38144_i64 = arith.constant 38144 : i64
    %4 = npu.alloc(%c38144_i64) : memref<256xi8, #npu.address_space<ub>>
    %c0_i64 = arith.constant 0 : i64
    %5 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c16384_i64 = arith.constant 16384 : i64
    %6 = npu.alloc(%c16384_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %7 = npu.alloc(%c8192_i64) : memref<8192xi8, #npu.address_space<ub>>
    %c39168_i64 = arith.constant 39168 : i64
    %8 = npu.alloc(%c39168_i64) : memref<64xi8, #npu.address_space<ub>>
    %c39232_i64 = arith.constant 39232 : i64
    %9 = npu.alloc(%c39232_i64) : memref<64xi8, #npu.address_space<ub>>
    %c39296_i64 = arith.constant 39296 : i64
    %10 = npu.alloc(%c39296_i64) : memref<64xi8, #npu.address_space<ub>>
    %c36864_i64 = arith.constant 36864 : i64
    %11 = npu.alloc(%c36864_i64) : memref<512xi8, #npu.address_space<ub>>
    %c37376_i64 = arith.constant 37376 : i64
    %12 = npu.alloc(%c37376_i64) : memref<512xi8, #npu.address_space<ub>>
    %c39360_i64 = arith.constant 39360 : i64
    %13 = npu.alloc(%c39360_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39392_i64 = arith.constant 39392 : i64
    %14 = npu.alloc(%c39392_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39424_i64 = arith.constant 39424 : i64
    %15 = npu.alloc(%c39424_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39456_i64 = arith.constant 39456 : i64
    %16 = npu.alloc(%c39456_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39488_i64 = arith.constant 39488 : i64
    %17 = npu.alloc(%c39488_i64) : memref<4xi8, #npu.address_space<ub>>
    %c39520_i64 = arith.constant 39520 : i64
    %18 = npu.alloc(%c39520_i64) : memref<4xi8, #npu.address_space<ub>>
    %c38400_i64 = arith.constant 38400 : i64
    %19 = npu.alloc(%c38400_i64) : memref<256xi8, #npu.address_space<ub>>
    %c38656_i64 = arith.constant 38656 : i64
    %20 = npu.alloc(%c38656_i64) : memref<256xi8, #npu.address_space<ub>>
    %c38912_i64 = arith.constant 38912 : i64
    %21 = npu.alloc(%c38912_i64) : memref<256xi8, #npu.address_space<ub>>
    %c1_i64 = arith.constant 1 : i64
    %c64 = arith.constant 64 : index
    %c8 = arith.constant 8 : index
    %c16 = arith.constant 16 : index
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c256 = arith.constant 256 : index
    %c128 = arith.constant 128 : index
    %c16_i32 = arith.constant 16 : i32
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant -9.99999968E+37 : f32
    %22 = npu.get_block_idx() : i64
    %23 = arith.trunci %22 : i64 to i32
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [2], strides: [1] : memref<?xi32, #npu.address_space<gm>> to memref<2xi32, strided<[1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [2, 8], strides: [8, 1] : memref<?xi32, #npu.address_space<gm>> to memref<2x8xi32, strided<[8, 1]>, #npu.address_space<gm>>
    %view = memref.view %0[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<128xbf16, #npu.address_space<ub>>
    %view_2 = memref.view %1[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<16x128xbf16, #npu.address_space<ub>>
    %view_3 = memref.view %2[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<16x128xbf16, #npu.address_space<ub>>
    %view_4 = memref.view %3[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<16x128xbf16, #npu.address_space<ub>>
    %view_5 = memref.view %4[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<128xbf16, #npu.address_space<ub>>
    %view_6 = memref.view %5[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %view_7 = memref.view %6[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %view_8 = memref.view %7[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %view_9 = memref.view %8[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %view_10 = memref.view %9[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %view_11 = memref.view %10[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %view_12 = memref.view %11[%c0][] : memref<512xi8, #npu.address_space<ub>> to memref<128xf32, #npu.address_space<ub>>
    %view_13 = memref.view %12[%c0][] : memref<512xi8, #npu.address_space<ub>> to memref<128xf32, #npu.address_space<ub>>
    %view_14 = memref.view %13[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %view_15 = memref.view %14[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %view_16 = memref.view %15[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %view_17 = memref.view %16[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %view_18 = memref.view %17[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %view_19 = memref.view %18[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %view_20 = memref.view %19[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<64xf32, #npu.address_space<ub>>
    %view_21 = memref.view %20[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<64xf32, #npu.address_space<ub>>
    %view_22 = memref.view %21[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<64xf32, #npu.address_space<ub>>
    npu.set_flag[<PIPE_S>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID0>]
    npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
    npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID2>]
    scf.for %arg7 = %c0 to %c2 step %c1 {
      %24 = arith.index_cast %23 : i32 to index
      %25 = arith.muli %24, %c256 : index
      %26 = arith.muli %arg7, %c128 : index
      %27 = arith.addi %25, %26 : index
      %reinterpret_cast_23 = memref.reinterpret_cast %arg0 to offset: [%27], sizes: [128], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>
      npu.wait_flag[<PIPE_S>, <PIPE_MTE2>, <EVENT_ID0>]
      npu.copy ins(%reinterpret_cast_23 : memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<128xbf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID0>]
      scf.for %arg8 = %c0 to %c16 step %c1 {
        scf.for %arg9 = %c0 to %c128 step %c1 {
          %32 = memref.load %view[%arg9] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<128xbf16, #npu.address_space<ub>>
          memref.store %32, %view_2[%arg8, %arg9] {tcore_type = #npu.tcore_type<VECTOR>} : memref<16x128xbf16, #npu.address_space<ub>>
        } {tilelang.loop_kind = "parallel"}
      } {tilelang.loop_kind = "parallel"}
      npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
      npu.set_flag[<PIPE_S>, <PIPE_MTE2>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
      npu.scope() {
        %32 = npu.vload %view_2 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xbf16, #npu.address_space<ub>>) -> vector<16x128xbf16>
        %33 = npu.cvt %32 : vector<16x128xbf16> -> vector<16x128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
        npu.vstore %33, %view_6 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID2>]
      scf.for %arg8 = %c0 to %c128 step %c1 {
        memref.store %cst, %view_12[%arg8] {tcore_type = #npu.tcore_type<VECTOR>} : memref<128xf32, #npu.address_space<ub>>
      } {tilelang.loop_kind = "parallel"}
      npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
      memref.store %cst_0, %view_16[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
      memref.store %cst, %view_17[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
      npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
      npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
      npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
      npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID1>]
      scf.for %arg8 = %c0 to %c8 step %c1 {
        %32 = arith.muli %arg8, %c16 : index
        %33 = arith.index_cast %23 : i32 to index
        %34 = memref.load %reinterpret_cast[%33] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<2xi32, strided<[1]>, #npu.address_space<gm>>
        %35 = arith.index_cast %34 : i32 to index
        %36 = arith.cmpi slt, %32, %35 : index
        npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
        npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID1>]
        scf.if %36 {
          %37 = arith.index_cast %23 : i32 to index
          %38 = memref.load %reinterpret_cast_1[%37, %arg8] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<2x8xi32, strided<[8, 1]>, #npu.address_space<gm>>
          %39 = arith.muli %38, %c16_i32 : i32
          %40 = arith.index_cast %39 : i32 to index
          %41 = arith.muli %40, %c256 : index
          %42 = arith.muli %arg7, %c128 : index
          %43 = arith.addi %41, %42 : index
          %reinterpret_cast_25 = memref.reinterpret_cast %arg1 to offset: [%43], sizes: [16, 128], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
          npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
          npu.copy ins(%reinterpret_cast_25 : memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>) outs(%view_3 : memref<16x128xbf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
          %44 = arith.index_cast %23 : i32 to index
          %45 = memref.load %reinterpret_cast_1[%44, %arg8] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<2x8xi32, strided<[8, 1]>, #npu.address_space<gm>>
          %46 = arith.muli %45, %c16_i32 : i32
          %47 = arith.index_cast %46 : i32 to index
          %48 = arith.muli %47, %c256 : index
          %49 = arith.muli %arg7, %c128 : index
          %50 = arith.addi %48, %49 : index
          %reinterpret_cast_26 = memref.reinterpret_cast %arg2 to offset: [%50], sizes: [16, 128], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
          npu.copy ins(%reinterpret_cast_26 : memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>) outs(%view_4 : memref<16x128xbf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
          npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
          npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
          npu.scope() {
            %64 = npu.vload %view_3 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xbf16, #npu.address_space<ub>>) -> vector<16x128xbf16>
            %65 = npu.cvt %64 : vector<16x128xbf16> -> vector<16x128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            npu.vstore %65, %view_7 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
            %66 = npu.vload %view_4 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xbf16, #npu.address_space<ub>>) -> vector<16x128xbf16>
            %67 = npu.cvt %66 : vector<16x128xbf16> -> vector<16x128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            npu.vstore %67, %view_8 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
            %68 = npu.vload %view_6 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
            %69 = npu.mul %68, %65 : vector<16x128xf32>, vector<16x128xf32> -> vector<16x128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            %70 = npu.reduce %69, %c1_i64 : vector<16x128xf32>, i64 -> vector<16xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32] {tcore_type = #npu.tcore_type<VECTOR>}
            npu.vstore %70, %view_9 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          npu.set_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
          memref.store %cst_0, %view_14[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          scf.for %arg9 = %c0 to %c16 step %c1 {
            %64 = memref.load %view_14[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
            %65 = memref.load %view_9[%arg9] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<16xf32, #npu.address_space<ub>>
            %66 = arith.cmpf olt, %64, %65 : f32
            %67 = memref.load %view_9[%arg9] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<16xf32, #npu.address_space<ub>>
            %68 = memref.load %view_14[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
            %69 = arith.select %66, %67, %68 : f32
            memref.store %69, %view_14[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "serial"}
          %51 = memref.load %view_14[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %52 = memref.load %view_16[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %53 = arith.cmpf olt, %51, %52 : f32
          %54 = memref.load %view_16[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %55 = memref.load %view_14[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %56 = arith.select %53, %54, %55 : f32
          memref.store %56, %view_15[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c64 step %c1 {
            %64 = memref.load %view_16[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
            memref.store %64, %view_20[%arg9] {tcore_type = #npu.tcore_type<VECTOR>} : memref<64xf32, #npu.address_space<ub>>
            %65 = memref.load %view_15[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
            memref.store %65, %view_21[%arg9] {tcore_type = #npu.tcore_type<VECTOR>} : memref<64xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "parallel"}
          npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
          npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
          npu.scope() {
            %64 = npu.vload %view_20 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<64xf32, #npu.address_space<ub>>) -> vector<64xf32>
            %65 = npu.vload %view_21 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<64xf32, #npu.address_space<ub>>) -> vector<64xf32>
            %66 = npu.sub %64, %65 : vector<64xf32>, vector<64xf32> -> vector<64xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            %67 = npu.exp %66 : vector<64xf32> -> vector<64xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            npu.vstore %67, %view_22 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<64xf32>, memref<64xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          %57 = memref.load %view_22[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<64xf32, #npu.address_space<ub>>
          memref.store %57, %view_19[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %58 = memref.load %view_15[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          memref.store %58, %view_16[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c16 step %c1 {
            %64 = memref.load %view_15[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
            memref.store %64, %view_11[%arg9] {tcore_type = #npu.tcore_type<VECTOR>} : memref<16xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "parallel"}
          npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
          npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
          npu.scope() {
            %64 = npu.vload %view_9 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16xf32, #npu.address_space<ub>>) -> vector<16xf32>
            %65 = npu.vload %view_11 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16xf32, #npu.address_space<ub>>) -> vector<16xf32>
            %66 = npu.sub %64, %65 : vector<16xf32>, vector<16xf32> -> vector<16xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            %67 = npu.exp %66 : vector<16xf32> -> vector<16xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            npu.vstore %67, %view_10 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          memref.store %cst, %view_18[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          scf.for %arg9 = %c0 to %c16 step %c1 {
            %64 = memref.load %view_18[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
            %65 = memref.load %view_10[%arg9] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<16xf32, #npu.address_space<ub>>
            %66 = arith.addf %64, %65 : f32
            memref.store %66, %view_18[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "serial"}
          %59 = memref.load %view_17[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %60 = memref.load %view_19[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %61 = arith.mulf %59, %60 : f32
          %62 = memref.load %view_18[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          %63 = arith.addf %61, %62 : f32
          memref.store %63, %view_17[%c0] {tcore_type = #npu.tcore_type<VECTOR>} : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c128 step %c1 {
            %64 = memref.load %view_19[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
            memref.store %64, %view_13[%arg9] {tcore_type = #npu.tcore_type<VECTOR>} : memref<128xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "parallel"}
          npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
          npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID1>]
          npu.scope() {
            %64 = npu.vload %view_12 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<128xf32, #npu.address_space<ub>>) -> vector<128xf32>
            %65 = npu.vload %view_13 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<128xf32, #npu.address_space<ub>>) -> vector<128xf32>
            %66 = npu.mul %64, %65 : vector<128xf32>, vector<128xf32> -> vector<128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
            npu.vstore %66, %view_12 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<128xf32>, memref<128xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
          scf.for %arg9 = %c0 to %c16 step %c1 {
            scf.for %arg10 = %c0 to %c128 step %c1 {
              %64 = memref.load %view_12[%arg10] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<128xf32, #npu.address_space<ub>>
              %65 = memref.load %view_10[%arg9] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<16xf32, #npu.address_space<ub>>
              %66 = memref.load %view_8[%arg9, %arg10] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<16x128xf32, #npu.address_space<ub>>
              %67 = arith.mulf %65, %66 : f32
              %68 = arith.addf %64, %67 : f32
              memref.store %68, %view_12[%arg10] {tcore_type = #npu.tcore_type<VECTOR>} : memref<128xf32, #npu.address_space<ub>>
            } {tilelang.loop_kind = "parallel"}
          } {tilelang.loop_kind = "serial"}
        }
        npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID1>]
        npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
      } {tilelang.loop_kind = "serial"}
      npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID1>]
      npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
      npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
      npu.wait_flag[<PIPE_V>, <PIPE_MTE2>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID3>]
      scf.for %arg8 = %c0 to %c128 step %c1 {
        %32 = memref.load %view_12[%arg8] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<128xf32, #npu.address_space<ub>>
        %33 = memref.load %view_17[%c0] {tcore_type = #npu.tcore_type<CUBE_AND_VECTOR>} : memref<1xf32, #npu.address_space<ub>>
        %34 = arith.divf %32, %33 : f32
        memref.store %34, %view_12[%arg8] {tcore_type = #npu.tcore_type<VECTOR>} : memref<128xf32, #npu.address_space<ub>>
      } {tilelang.loop_kind = "parallel"}
      npu.set_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_S>, <PIPE_V>, <EVENT_ID0>]
      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
      npu.scope() {
        %32 = npu.vload %view_12 {tcore_type = #npu.tcore_type<VECTOR>} : (memref<128xf32, #npu.address_space<ub>>) -> vector<128xf32>
        %33 = npu.cvt %32 : vector<128xf32> -> vector<128xbf16> {tcore_type = #npu.tcore_type<VECTOR>}
        npu.vstore %33, %view_5 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<128xbf16>, memref<128xbf16, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      npu.set_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID2>]
      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      %28 = arith.index_cast %23 : i32 to index
      %29 = arith.muli %28, %c256 : index
      %30 = arith.muli %arg7, %c128 : index
      %31 = arith.addi %29, %30 : index
      %reinterpret_cast_24 = memref.reinterpret_cast %arg5 to offset: [%31], sizes: [128], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>
      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
      npu.copy ins(%view_5 : memref<128xbf16, #npu.address_space<ub>>) outs(%reinterpret_cast_24 : memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
    } {tilelang.loop_kind = "serial"}
    npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID2>]
    npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_V>, <PIPE_S>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_S>, <PIPE_MTE2>, <EVENT_ID0>]
    npu.sync_block_set {npu.logical_sync_id = 1 : i64}[<VECTOR>, <PIPE_MTE3>, <PIPE_FIX>] flag = 0
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


module {
  func.func @main(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xi32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32, %arg6: i32) {
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
    %cst_0 = arith.constant 1.000000e+00 : f32
    %c32_i32 = arith.constant 32 : i32
    %cst_1 = arith.constant 6.250000e-02 : f32
    %0 = npu.get_sub_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %2 = npu.get_block_idx() : i64
    %3 = arith.trunci %2 : i64 to i32
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [1, 4096, 128], strides: [524288, 128, 1] : memref<?xi32, #npu.address_space<gm>> to memref<1x4096x128xi32, strided<[524288, 128, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<32768xi8, #npu.address_space<cbuf>>
    %view = memref.view %alloc[%c0][] : memref<32768xi8, #npu.address_space<cbuf>> to memref<64x256xbf16, #npu.address_space<cbuf>>
    %alloc_2 = memref.alloc() : memref<8192xi8, #npu.address_space<cbuf>>
    %view_3 = memref.view %alloc_2[%c0][] : memref<8192xi8, #npu.address_space<cbuf>> to memref<16x256xbf16, #npu.address_space<cbuf>>
    %alloc_4 = memref.alloc() : memref<2048xi8, #npu.address_space<cbuf>>
    %view_5 = memref.view %alloc_4[%c0][] : memref<2048xi8, #npu.address_space<cbuf>> to memref<64x16xbf16, #npu.address_space<cbuf>>
    %alloc_6 = memref.alloc() : memref<512xi8, #npu.address_space<ub>>
    %view_7 = memref.view %alloc_6[%c0][] : memref<512xi8, #npu.address_space<ub>> to memref<128xi32, #npu.address_space<ub>>
    %alloc_8 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_9 = memref.view %alloc_8[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x256xbf16, #npu.address_space<ub>>
    %alloc_10 = memref.alloc() : memref<64x16xf32, #npu.address_space<cc>>
    %alloc_11 = memref.alloc() : memref<64x256xf32, #npu.address_space<cc>>
    %alloc_12 = memref.alloc() : memref<2048xi8, #npu.address_space<ub>>
    %view_13 = memref.view %alloc_12[%c0][] : memref<2048xi8, #npu.address_space<ub>> to memref<32x16xf32, #npu.address_space<ub>>
    %alloc_14 = memref.alloc() : memref<1024xi8, #npu.address_space<ub>>
    %view_15 = memref.view %alloc_14[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<32x16xbf16, #npu.address_space<ub>>
    %alloc_16 = memref.alloc() : memref<32768xi8, #npu.address_space<ub>>
    %view_17 = memref.view %alloc_16[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<32x256xf32, #npu.address_space<ub>>
    %alloc_18 = memref.alloc() : memref<32768xi8, #npu.address_space<ub>>
    %view_19 = memref.view %alloc_18[%c0][] : memref<32768xi8, #npu.address_space<ub>> to memref<32x256xf32, #npu.address_space<ub>>
    %alloc_20 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_21 = memref.view %alloc_20[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %alloc_22 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_23 = memref.view %alloc_22[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %alloc_24 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_25 = memref.view %alloc_24[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %alloc_26 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_27 = memref.view %alloc_26[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    %alloc_28 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_29 = memref.view %alloc_28[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    scf.for %arg7 = %c0 to %c128 step %c1 {
      %4 = arith.muli %3, %c128_i32 : i32
      %5 = arith.index_cast %4 : i32 to index
      %6 = arith.addi %5, %arg7 : index
      %7 = arith.muli %6, %c16384 : index
      %reinterpret_cast_30 = memref.reinterpret_cast %arg0 to offset: [%7], sizes: [64, 256], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<64x256xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
      npu.copy ins(%reinterpret_cast_30 : memref<64x256xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<64x256xbf16, #npu.address_space<cbuf>>)
      npu.scope() {
        %18 = npu.broadcast %cst : f32 -> vector<32x256xf32>
        npu.vstore %18, %view_17 : (vector<32x256xf32>, memref<32x256xf32, #npu.address_space<ub>>) -> ()
        %19 = npu.broadcast %cst_0 : f32 -> vector<32xf32>
        npu.vstore %19, %view_27 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      %8 = arith.muli %1, %c32_i32 : i32
      %9 = arith.index_cast %8 : i32 to index
      %reinterpret_cast_31 = memref.reinterpret_cast %arg2 to offset: [%9], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
      npu.copy ins(%reinterpret_cast_31 : memref<32xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%view_21 : memref<32xf32, #npu.address_space<ub>>)
      scf.for %arg8 = %c0 to %c128 step %c1 {
        %18 = arith.muli %3, %c128_i32 : i32
        %19 = arith.index_cast %18 : i32 to index
        %20 = arith.addi %19, %arg7 : index
        %21 = memref.load %reinterpret_cast[%c0, %20, %arg8] : memref<1x4096x128xi32, strided<[524288, 128, 1]>, #npu.address_space<gm>>
        memref.store %21, %view_7[%arg8] : memref<128xi32, #npu.address_space<ub>>
      } {tilelang.loop_kind = "serial"}
      scf.for %arg8 = %c0 to %c8 step %c1 {
        scf.for %arg9 = %c0 to %c16 step %c1 {
          %18 = arith.muli %arg8, %c16 : index
          %19 = arith.addi %18, %arg9 : index
          %20 = memref.load %view_7[%19] : memref<128xi32, #npu.address_space<ub>>
          %21 = arith.index_cast %20 : i32 to index
          %22 = arith.muli %21, %c256 : index
          %reinterpret_cast_38 = memref.reinterpret_cast %arg1 to offset: [%22], sizes: [256], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>
          %23 = arith.muli %arg9, %c256 : index
          %reinterpret_cast_39 = memref.reinterpret_cast %view_9 to offset: [%23], sizes: [256], strides: [1] : memref<16x256xbf16, #npu.address_space<ub>> to memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<ub>>
          npu.copy ins(%reinterpret_cast_38 : memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%reinterpret_cast_39 : memref<256xbf16, strided<[1], offset: ?>, #npu.address_space<ub>>)
        } {tilelang.loop_kind = "serial"}
        %alloc_33 = memref.alloc() {npu.mem_unique = #npu.mem_unique} : memref<4352xbf16, #npu.address_space<ub>>
        npu.nd2nz_scatter ins(%view_9 : memref<16x256xbf16, #npu.address_space<ub>>) outs(%alloc_33 : memref<4352xbf16, #npu.address_space<ub>>)
        npu.copy ins(%alloc_33 : memref<4352xbf16, #npu.address_space<ub>>) outs(%view_3 : memref<16x256xbf16, #npu.address_space<cbuf>>) {linear_transfer}
        %alloc_34 = memref.alloc() : memref<64x256xbf16, #npu.address_space<ca>>
        npu.copy ins(%view : memref<64x256xbf16, #npu.address_space<cbuf>>) outs(%alloc_34 : memref<64x256xbf16, #npu.address_space<ca>>)
        %alloc_35 = memref.alloc() : memref<16x256xbf16, #npu.address_space<cb>>
        npu.copy ins(%view_3 : memref<16x256xbf16, #npu.address_space<cbuf>>) outs(%alloc_35 : memref<16x256xbf16, #npu.address_space<cb>>) {Transposed = true}
        npu.mad ins(%alloc_34, %alloc_35 : memref<64x256xbf16, #npu.address_space<ca>>, memref<16x256xbf16, #npu.address_space<cb>>) outs(%alloc_10 : memref<64x16xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = true, zero_init = true}
        npu.copy ins(%alloc_10 : memref<64x16xf32, #npu.address_space<cc>>) outs(%view_13 : memref<32x16xf32, #npu.address_space<ub>>) {split_dim = 0 : i64}
        npu.scope() {
          %18 = npu.vload %view_13 : (memref<32x16xf32, #npu.address_space<ub>>) -> vector<32x16xf32>
          %19 = npu.mul %18, %cst_1 : vector<32x16xf32>, f32 -> vector<32x16xf32>
          npu.vstore %19, %view_13 : (vector<32x16xf32>, memref<32x16xf32, #npu.address_space<ub>>) -> ()
          npu.copy ins(%view_21 : memref<32xf32, #npu.address_space<ub>>) outs(%view_23 : memref<32xf32, #npu.address_space<ub>>)
          %20 = npu.reduce %19, %c1_i64 : vector<32x16xf32>, i64 -> vector<32xf32> #npu.reduce_op<max> identities=[0xFF800000 : f32]
          npu.vstore %20, %view_21 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
        npu.scope() {
          %18 = npu.vload %view_13 : (memref<32x16xf32, #npu.address_space<ub>>) -> vector<32x16xf32>
          %19 = npu.vload %view_21 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %20 = npu.vload %view_23 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %21 = npu.max %19, %20 : vector<32xf32>, vector<32xf32> -> vector<32xf32>
          npu.vstore %21, %view_21 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          %22 = npu.broadcast %21 : vector<32xf32> -> vector<32x16xf32> {broadcast_dim = 1 : i64}
          %23 = npu.sub %18, %22 : vector<32x16xf32>, vector<32x16xf32> -> vector<32x16xf32>
          %24 = npu.exp %23 : vector<32x16xf32> -> vector<32x16xf32>
          %25 = npu.cvt %24 : vector<32x16xf32> -> vector<32x16xbf16>
          npu.vstore %25, %view_15 : (vector<32x16xbf16>, memref<32x16xbf16, #npu.address_space<ub>>) -> ()
          %26 = npu.reduce %24, %c1_i64 : vector<32x16xf32>, i64 -> vector<32xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32]
          npu.vstore %26, %view_25 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
        npu.scope() {
          %18 = npu.vload %view_23 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %19 = npu.vload %view_21 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %20 = npu.vload %view_27 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %21 = npu.vload %view_25 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %22 = npu.sub %18, %19 : vector<32xf32>, vector<32xf32> -> vector<32xf32>
          %23 = npu.exp %22 : vector<32xf32> -> vector<32xf32>
          npu.vstore %23, %view_29 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          %24 = npu.mul %20, %23 : vector<32xf32>, vector<32xf32> -> vector<32xf32>
          %25 = npu.add %24, %21 : vector<32xf32>, vector<32xf32> -> vector<32xf32>
          npu.vstore %25, %view_27 : (vector<32xf32>, memref<32xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
        npu.copy ins(%view_15 : memref<32x16xbf16, #npu.address_space<ub>>) outs(%view_5 : memref<64x16xbf16, #npu.address_space<cbuf>>) {split_dim = 0 : i64}
        %alloc_36 = memref.alloc() : memref<64x16xbf16, #npu.address_space<ca>>
        npu.copy ins(%view_5 : memref<64x16xbf16, #npu.address_space<cbuf>>) outs(%alloc_36 : memref<64x16xbf16, #npu.address_space<ca>>)
        %alloc_37 = memref.alloc() : memref<16x256xbf16, #npu.address_space<cb>>
        npu.copy ins(%view_3 : memref<16x256xbf16, #npu.address_space<cbuf>>) outs(%alloc_37 : memref<16x256xbf16, #npu.address_space<cb>>)
        npu.mad ins(%alloc_36, %alloc_37 : memref<64x16xbf16, #npu.address_space<ca>>, memref<16x256xbf16, #npu.address_space<cb>>) outs(%alloc_11 : memref<64x256xf32, #npu.address_space<cc>>) {lhs_trans = false, rhs_trans = false, zero_init = true}
        npu.copy ins(%alloc_11 : memref<64x256xf32, #npu.address_space<cc>>) outs(%view_19 : memref<32x256xf32, #npu.address_space<ub>>) {split_dim = 0 : i64}
        npu.scope() {
          %18 = npu.vload %view_17 : (memref<32x256xf32, #npu.address_space<ub>>) -> vector<32x256xf32>
          %19 = npu.vload %view_19 : (memref<32x256xf32, #npu.address_space<ub>>) -> vector<32x256xf32>
          %20 = npu.vload %view_29 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
          %21 = npu.broadcast %20 : vector<32xf32> -> vector<32x256xf32> {broadcast_dim = 1 : i64}
          %22 = npu.mul %18, %21 : vector<32x256xf32>, vector<32x256xf32> -> vector<32x256xf32>
          %23 = npu.add %22, %19 : vector<32x256xf32>, vector<32x256xf32> -> vector<32x256xf32>
          npu.vstore %23, %view_17 : (vector<32x256xf32>, memref<32x256xf32, #npu.address_space<ub>>) -> ()
          npu.yield
        } {mode = #npu.scope_mode<simd>} : () -> ()
      } {tilelang.loop_kind = "serial"}
      npu.scope() {
        %18 = npu.vload %view_17 : (memref<32x256xf32, #npu.address_space<ub>>) -> vector<32x256xf32>
        %19 = npu.vload %view_27 : (memref<32xf32, #npu.address_space<ub>>) -> vector<32xf32>
        %20 = npu.broadcast %19 : vector<32xf32> -> vector<32x256xf32> {broadcast_dim = 1 : i64}
        %21 = npu.div %18, %20 : vector<32x256xf32>, vector<32x256xf32> -> vector<32x256xf32>
        npu.vstore %21, %view_17 : (vector<32x256xf32>, memref<32x256xf32, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      %10 = arith.muli %3, %c128_i32 : i32
      %11 = arith.index_cast %10 : i32 to index
      %12 = arith.addi %11, %arg7 : index
      %13 = arith.muli %12, %c16384 : index
      %14 = arith.muli %1, %c32_i32 : i32
      %15 = arith.index_cast %14 : i32 to index
      %16 = arith.muli %15, %c256 : index
      %17 = arith.addi %13, %16 : index
      %reinterpret_cast_32 = memref.reinterpret_cast %arg4 to offset: [%17], sizes: [32, 256], strides: [256, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x256xf32, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
      npu.copy ins(%view_17 : memref<32x256xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_32 : memref<32x256xf32, strided<[256, 1], offset: ?>, #npu.address_space<gm>>)
    } {num_stages = 2 : i64, tilelang.loop_kind = "pipelined"}
    return
  }
}


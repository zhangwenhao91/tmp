module {
  func.func @paged_decode_probe_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: memref<?xbf16, #npu.address_space<gm>>, %arg3: memref<?xi32, #npu.address_space<gm>>, %arg4: memref<?xi32, #npu.address_space<gm>>, %arg5: memref<?xbf16, #npu.address_space<gm>>, %arg6: i32) {
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
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [2], strides: [1] : memref<?xi32, #npu.address_space<gm>> to memref<2xi32, strided<[1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [2, 8], strides: [8, 1] : memref<?xi32, #npu.address_space<gm>> to memref<2x8xi32, strided<[8, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<256xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<128xbf16, #npu.address_space<ub>>
    %alloc_2 = memref.alloc() : memref<4096xi8, #npu.address_space<ub>>
    %view_3 = memref.view %alloc_2[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<16x128xbf16, #npu.address_space<ub>>
    %alloc_4 = memref.alloc() : memref<4096xi8, #npu.address_space<ub>>
    %view_5 = memref.view %alloc_4[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<16x128xbf16, #npu.address_space<ub>>
    %alloc_6 = memref.alloc() : memref<4096xi8, #npu.address_space<ub>>
    %view_7 = memref.view %alloc_6[%c0][] : memref<4096xi8, #npu.address_space<ub>> to memref<16x128xbf16, #npu.address_space<ub>>
    %alloc_8 = memref.alloc() : memref<256xi8, #npu.address_space<ub>>
    %view_9 = memref.view %alloc_8[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<128xbf16, #npu.address_space<ub>>
    %alloc_10 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_11 = memref.view %alloc_10[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_12 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_13 = memref.view %alloc_12[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_14 = memref.alloc() : memref<8192xi8, #npu.address_space<ub>>
    %view_15 = memref.view %alloc_14[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %alloc_16 = memref.alloc() : memref<64xi8, #npu.address_space<ub>>
    %view_17 = memref.view %alloc_16[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %alloc_18 = memref.alloc() : memref<64xi8, #npu.address_space<ub>>
    %view_19 = memref.view %alloc_18[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %alloc_20 = memref.alloc() : memref<64xi8, #npu.address_space<ub>>
    %view_21 = memref.view %alloc_20[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %alloc_22 = memref.alloc() : memref<512xi8, #npu.address_space<ub>>
    %view_23 = memref.view %alloc_22[%c0][] : memref<512xi8, #npu.address_space<ub>> to memref<128xf32, #npu.address_space<ub>>
    %alloc_24 = memref.alloc() : memref<512xi8, #npu.address_space<ub>>
    %view_25 = memref.view %alloc_24[%c0][] : memref<512xi8, #npu.address_space<ub>> to memref<128xf32, #npu.address_space<ub>>
    %alloc_26 = memref.alloc() : memref<4xi8, #npu.address_space<ub>>
    %view_27 = memref.view %alloc_26[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %alloc_28 = memref.alloc() : memref<4xi8, #npu.address_space<ub>>
    %view_29 = memref.view %alloc_28[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %alloc_30 = memref.alloc() : memref<4xi8, #npu.address_space<ub>>
    %view_31 = memref.view %alloc_30[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %alloc_32 = memref.alloc() : memref<4xi8, #npu.address_space<ub>>
    %view_33 = memref.view %alloc_32[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %alloc_34 = memref.alloc() : memref<4xi8, #npu.address_space<ub>>
    %view_35 = memref.view %alloc_34[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %alloc_36 = memref.alloc() : memref<4xi8, #npu.address_space<ub>>
    %view_37 = memref.view %alloc_36[%c0][] : memref<4xi8, #npu.address_space<ub>> to memref<1xf32, #npu.address_space<ub>>
    %alloc_38 = memref.alloc() : memref<256xi8, #npu.address_space<ub>>
    %view_39 = memref.view %alloc_38[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<64xf32, #npu.address_space<ub>>
    %alloc_40 = memref.alloc() : memref<256xi8, #npu.address_space<ub>>
    %view_41 = memref.view %alloc_40[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<64xf32, #npu.address_space<ub>>
    %alloc_42 = memref.alloc() : memref<256xi8, #npu.address_space<ub>>
    %view_43 = memref.view %alloc_42[%c0][] : memref<256xi8, #npu.address_space<ub>> to memref<64xf32, #npu.address_space<ub>>
    scf.for %arg7 = %c0 to %c2 step %c1 {
      %2 = arith.index_cast %1 : i32 to index
      %3 = arith.muli %2, %c256 : index
      %4 = arith.muli %arg7, %c128 : index
      %5 = arith.addi %3, %4 : index
      %reinterpret_cast_44 = memref.reinterpret_cast %arg0 to offset: [%5], sizes: [128], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>
      npu.copy ins(%reinterpret_cast_44 : memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<128xbf16, #npu.address_space<ub>>)
      scf.for %arg8 = %c0 to %c16 step %c1 {
        scf.for %arg9 = %c0 to %c128 step %c1 {
          %10 = memref.load %view[%arg9] : memref<128xbf16, #npu.address_space<ub>>
          memref.store %10, %view_3[%arg8, %arg9] : memref<16x128xbf16, #npu.address_space<ub>>
        } {tilelang.loop_kind = "parallel"}
      } {tilelang.loop_kind = "parallel"}
      npu.scope() {
        %10 = npu.vload %view_3 : (memref<16x128xbf16, #npu.address_space<ub>>) -> vector<16x128xbf16>
        %11 = npu.cvt %10 : vector<16x128xbf16> -> vector<16x128xf32>
        npu.vstore %11, %view_11 : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      scf.for %arg8 = %c0 to %c128 step %c1 {
        memref.store %cst, %view_23[%arg8] : memref<128xf32, #npu.address_space<ub>>
      } {tilelang.loop_kind = "parallel"}
      memref.store %cst_0, %view_31[%c0] : memref<1xf32, #npu.address_space<ub>>
      memref.store %cst, %view_33[%c0] : memref<1xf32, #npu.address_space<ub>>
      scf.for %arg8 = %c0 to %c8 step %c1 {
        %10 = arith.muli %arg8, %c16 : index
        %11 = arith.index_cast %1 : i32 to index
        %12 = memref.load %reinterpret_cast[%11] : memref<2xi32, strided<[1]>, #npu.address_space<gm>>
        %13 = arith.index_cast %12 : i32 to index
        %14 = arith.cmpi slt, %10, %13 : index
        scf.if %14 {
          %15 = arith.index_cast %1 : i32 to index
          %16 = memref.load %reinterpret_cast_1[%15, %arg8] : memref<2x8xi32, strided<[8, 1]>, #npu.address_space<gm>>
          %17 = arith.muli %16, %c16_i32 : i32
          %18 = arith.index_cast %17 : i32 to index
          %19 = arith.muli %18, %c256 : index
          %20 = arith.muli %arg7, %c128 : index
          %21 = arith.addi %19, %20 : index
          %reinterpret_cast_46 = memref.reinterpret_cast %arg1 to offset: [%21], sizes: [16, 128], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
          npu.copy ins(%reinterpret_cast_46 : memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>) outs(%view_5 : memref<16x128xbf16, #npu.address_space<ub>>)
          %22 = arith.index_cast %1 : i32 to index
          %23 = memref.load %reinterpret_cast_1[%22, %arg8] : memref<2x8xi32, strided<[8, 1]>, #npu.address_space<gm>>
          %24 = arith.muli %23, %c16_i32 : i32
          %25 = arith.index_cast %24 : i32 to index
          %26 = arith.muli %25, %c256 : index
          %27 = arith.muli %arg7, %c128 : index
          %28 = arith.addi %26, %27 : index
          %reinterpret_cast_47 = memref.reinterpret_cast %arg2 to offset: [%28], sizes: [16, 128], strides: [256, 1] : memref<?xbf16, #npu.address_space<gm>> to memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>
          npu.copy ins(%reinterpret_cast_47 : memref<16x128xbf16, strided<[256, 1], offset: ?>, #npu.address_space<gm>>) outs(%view_7 : memref<16x128xbf16, #npu.address_space<ub>>)
          npu.scope() {
            %42 = npu.vload %view_5 : (memref<16x128xbf16, #npu.address_space<ub>>) -> vector<16x128xbf16>
            %43 = npu.cvt %42 : vector<16x128xbf16> -> vector<16x128xf32>
            npu.vstore %43, %view_13 : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
            %44 = npu.vload %view_7 : (memref<16x128xbf16, #npu.address_space<ub>>) -> vector<16x128xbf16>
            %45 = npu.cvt %44 : vector<16x128xbf16> -> vector<16x128xf32>
            npu.vstore %45, %view_15 : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
            %46 = npu.vload %view_11 : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
            %47 = npu.mul %46, %43 : vector<16x128xf32>, vector<16x128xf32> -> vector<16x128xf32>
            %48 = npu.reduce %47, %c1_i64 : vector<16x128xf32>, i64 -> vector<16xf32> #npu.reduce_op<sum> identities=[0.000000e+00 : f32]
            npu.vstore %48, %view_17 : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          memref.store %cst_0, %view_27[%c0] : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c16 step %c1 {
            %42 = memref.load %view_27[%c0] : memref<1xf32, #npu.address_space<ub>>
            %43 = memref.load %view_17[%arg9] : memref<16xf32, #npu.address_space<ub>>
            %44 = arith.cmpf olt, %42, %43 : f32
            %45 = memref.load %view_17[%arg9] : memref<16xf32, #npu.address_space<ub>>
            %46 = memref.load %view_27[%c0] : memref<1xf32, #npu.address_space<ub>>
            %47 = arith.select %44, %45, %46 : f32
            memref.store %47, %view_27[%c0] : memref<1xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "serial"}
          %29 = memref.load %view_27[%c0] : memref<1xf32, #npu.address_space<ub>>
          %30 = memref.load %view_31[%c0] : memref<1xf32, #npu.address_space<ub>>
          %31 = arith.cmpf olt, %29, %30 : f32
          %32 = memref.load %view_31[%c0] : memref<1xf32, #npu.address_space<ub>>
          %33 = memref.load %view_27[%c0] : memref<1xf32, #npu.address_space<ub>>
          %34 = arith.select %31, %32, %33 : f32
          memref.store %34, %view_29[%c0] : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c64 step %c1 {
            %42 = memref.load %view_31[%c0] : memref<1xf32, #npu.address_space<ub>>
            memref.store %42, %view_39[%arg9] : memref<64xf32, #npu.address_space<ub>>
            %43 = memref.load %view_29[%c0] : memref<1xf32, #npu.address_space<ub>>
            memref.store %43, %view_41[%arg9] : memref<64xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "parallel"}
          npu.scope() {
            %42 = npu.vload %view_39 : (memref<64xf32, #npu.address_space<ub>>) -> vector<64xf32>
            %43 = npu.vload %view_41 : (memref<64xf32, #npu.address_space<ub>>) -> vector<64xf32>
            %44 = npu.sub %42, %43 : vector<64xf32>, vector<64xf32> -> vector<64xf32>
            %45 = npu.exp %44 : vector<64xf32> -> vector<64xf32>
            npu.vstore %45, %view_43 : (vector<64xf32>, memref<64xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          %35 = memref.load %view_43[%c0] : memref<64xf32, #npu.address_space<ub>>
          memref.store %35, %view_37[%c0] : memref<1xf32, #npu.address_space<ub>>
          %36 = memref.load %view_29[%c0] : memref<1xf32, #npu.address_space<ub>>
          memref.store %36, %view_31[%c0] : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c16 step %c1 {
            %42 = memref.load %view_29[%c0] : memref<1xf32, #npu.address_space<ub>>
            memref.store %42, %view_21[%arg9] : memref<16xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "parallel"}
          npu.scope() {
            %42 = npu.vload %view_17 : (memref<16xf32, #npu.address_space<ub>>) -> vector<16xf32>
            %43 = npu.vload %view_21 : (memref<16xf32, #npu.address_space<ub>>) -> vector<16xf32>
            %44 = npu.sub %42, %43 : vector<16xf32>, vector<16xf32> -> vector<16xf32>
            %45 = npu.exp %44 : vector<16xf32> -> vector<16xf32>
            npu.vstore %45, %view_19 : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          memref.store %cst, %view_35[%c0] : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c16 step %c1 {
            %42 = memref.load %view_35[%c0] : memref<1xf32, #npu.address_space<ub>>
            %43 = memref.load %view_19[%arg9] : memref<16xf32, #npu.address_space<ub>>
            %44 = arith.addf %42, %43 : f32
            memref.store %44, %view_35[%c0] : memref<1xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "serial"}
          %37 = memref.load %view_33[%c0] : memref<1xf32, #npu.address_space<ub>>
          %38 = memref.load %view_37[%c0] : memref<1xf32, #npu.address_space<ub>>
          %39 = arith.mulf %37, %38 : f32
          %40 = memref.load %view_35[%c0] : memref<1xf32, #npu.address_space<ub>>
          %41 = arith.addf %39, %40 : f32
          memref.store %41, %view_33[%c0] : memref<1xf32, #npu.address_space<ub>>
          scf.for %arg9 = %c0 to %c128 step %c1 {
            %42 = memref.load %view_37[%c0] : memref<1xf32, #npu.address_space<ub>>
            memref.store %42, %view_25[%arg9] : memref<128xf32, #npu.address_space<ub>>
          } {tilelang.loop_kind = "parallel"}
          npu.scope() {
            %42 = npu.vload %view_23 : (memref<128xf32, #npu.address_space<ub>>) -> vector<128xf32>
            %43 = npu.vload %view_25 : (memref<128xf32, #npu.address_space<ub>>) -> vector<128xf32>
            %44 = npu.mul %42, %43 : vector<128xf32>, vector<128xf32> -> vector<128xf32>
            npu.vstore %44, %view_23 : (vector<128xf32>, memref<128xf32, #npu.address_space<ub>>) -> ()
            npu.yield
          } {mode = #npu.scope_mode<simd>} : () -> ()
          scf.for %arg9 = %c0 to %c16 step %c1 {
            scf.for %arg10 = %c0 to %c128 step %c1 {
              %42 = memref.load %view_23[%arg10] : memref<128xf32, #npu.address_space<ub>>
              %43 = memref.load %view_19[%arg9] : memref<16xf32, #npu.address_space<ub>>
              %44 = memref.load %view_15[%arg9, %arg10] : memref<16x128xf32, #npu.address_space<ub>>
              %45 = arith.mulf %43, %44 : f32
              %46 = arith.addf %42, %45 : f32
              memref.store %46, %view_23[%arg10] : memref<128xf32, #npu.address_space<ub>>
            } {tilelang.loop_kind = "parallel"}
          } {tilelang.loop_kind = "serial"}
        }
      } {tilelang.loop_kind = "serial"}
      scf.for %arg8 = %c0 to %c128 step %c1 {
        %10 = memref.load %view_23[%arg8] : memref<128xf32, #npu.address_space<ub>>
        %11 = memref.load %view_33[%c0] : memref<1xf32, #npu.address_space<ub>>
        %12 = arith.divf %10, %11 : f32
        memref.store %12, %view_23[%arg8] : memref<128xf32, #npu.address_space<ub>>
      } {tilelang.loop_kind = "parallel"}
      npu.scope() {
        %10 = npu.vload %view_23 : (memref<128xf32, #npu.address_space<ub>>) -> vector<128xf32>
        %11 = npu.cvt %10 : vector<128xf32> -> vector<128xbf16>
        npu.vstore %11, %view_9 : (vector<128xbf16>, memref<128xbf16, #npu.address_space<ub>>) -> ()
        npu.yield
      } {mode = #npu.scope_mode<simd>} : () -> ()
      %6 = arith.index_cast %1 : i32 to index
      %7 = arith.muli %6, %c256 : index
      %8 = arith.muli %arg7, %c128 : index
      %9 = arith.addi %7, %8 : index
      %reinterpret_cast_45 = memref.reinterpret_cast %arg5 to offset: [%9], sizes: [128], strides: [1] : memref<?xbf16, #npu.address_space<gm>> to memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>
      npu.copy ins(%view_9 : memref<128xbf16, #npu.address_space<ub>>) outs(%reinterpret_cast_45 : memref<128xbf16, strided<[1], offset: ?>, #npu.address_space<gm>>)
    } {tilelang.loop_kind = "serial"}
    return
  }
}


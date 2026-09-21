module {
  func.func @main(%arg0: memref<?xbf16>, %arg1: memref<?xbf16>, %arg2: memref<?xf32>, %arg3: memref<?xi32>, %arg4: memref<?xf32>, %arg5: i32, %arg6: i32) attributes {BlockIdx = 5 : i64, SubBlockIdx = 6 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [1, 4096, 64, 256], strides: [67108864, 16384, 256, 1] : memref<?xbf16> to memref<1x4096x64x256xbf16, strided<[67108864, 16384, 256, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [1, 4096, 256], strides: [1048576, 256, 1] : memref<?xbf16> to memref<1x4096x256xbf16, strided<[1048576, 256, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [64], strides: [1] : memref<?xf32> to memref<64xf32, strided<[1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [1, 4096, 128], strides: [524288, 128, 1] : memref<?xi32> to memref<1x4096x128xi32, strided<[524288, 128, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [1, 4096, 64, 256], strides: [67108864, 16384, 256, 1] : memref<?xf32> to memref<1x4096x64x256xf32, strided<[67108864, 16384, 256, 1]>>
    %alloc = memref.alloc() : memref<32768xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<32768xi8, 1> to memref<64x256xbf16, 1>
    %alloc_4 = memref.alloc() : memref<8192xi8, 1>
    %c0_5 = arith.constant 0 : index
    %view_6 = memref.view %alloc_4[%c0_5][] : memref<8192xi8, 1> to memref<16x256xbf16, 1>
    %alloc_7 = memref.alloc() : memref<2048xi8, 1>
    %c0_8 = arith.constant 0 : index
    %view_9 = memref.view %alloc_7[%c0_8][] : memref<2048xi8, 1> to memref<64x16xbf16, 1>
    %alloc_10 = memref.alloc() : memref<512xi8, 1>
    %c0_11 = arith.constant 0 : index
    %view_12 = memref.view %alloc_10[%c0_11][] : memref<512xi8, 1> to memref<128xi32, 1>
    %alloc_13 = memref.alloc() : memref<8192xi8, 1>
    %c0_14 = arith.constant 0 : index
    %view_15 = memref.view %alloc_13[%c0_14][] : memref<8192xi8, 1> to memref<16x256xbf16, 1>
    %alloc_16 = memref.alloc() : memref<64x16xf32, 2>
    %alloc_17 = memref.alloc() : memref<64x256xf32, 2>
    %alloc_18 = memref.alloc() : memref<2048xi8, 1>
    %c0_19 = arith.constant 0 : index
    %view_20 = memref.view %alloc_18[%c0_19][] : memref<2048xi8, 1> to memref<32x16xf32, 1>
    %alloc_21 = memref.alloc() : memref<1024xi8, 1>
    %c0_22 = arith.constant 0 : index
    %view_23 = memref.view %alloc_21[%c0_22][] : memref<1024xi8, 1> to memref<32x16xbf16, 1>
    %alloc_24 = memref.alloc() : memref<32768xi8, 1>
    %c0_25 = arith.constant 0 : index
    %view_26 = memref.view %alloc_24[%c0_25][] : memref<32768xi8, 1> to memref<32x256xf32, 1>
    %alloc_27 = memref.alloc() : memref<32768xi8, 1>
    %c0_28 = arith.constant 0 : index
    %view_29 = memref.view %alloc_27[%c0_28][] : memref<32768xi8, 1> to memref<32x256xf32, 1>
    %alloc_30 = memref.alloc() : memref<128xi8, 1>
    %c0_31 = arith.constant 0 : index
    %view_32 = memref.view %alloc_30[%c0_31][] : memref<128xi8, 1> to memref<32xf32, 1>
    %alloc_33 = memref.alloc() : memref<128xi8, 1>
    %c0_34 = arith.constant 0 : index
    %view_35 = memref.view %alloc_33[%c0_34][] : memref<128xi8, 1> to memref<32xf32, 1>
    %alloc_36 = memref.alloc() : memref<128xi8, 1>
    %c0_37 = arith.constant 0 : index
    %view_38 = memref.view %alloc_36[%c0_37][] : memref<128xi8, 1> to memref<32xf32, 1>
    %alloc_39 = memref.alloc() : memref<128xi8, 1>
    %c0_40 = arith.constant 0 : index
    %view_41 = memref.view %alloc_39[%c0_40][] : memref<128xi8, 1> to memref<32xf32, 1>
    %alloc_42 = memref.alloc() : memref<128xi8, 1>
    %c0_43 = arith.constant 0 : index
    %view_44 = memref.view %alloc_42[%c0_43][] : memref<128xi8, 1> to memref<32xf32, 1>
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c128_i32 = arith.constant 128 : i32
    %1 = arith.index_cast %c128_i32 : i32 to index
    %2 = arith.addi %0, %1 : index
    %c1 = arith.constant 1 : index
    scf.for %arg7 = %0 to %2 step %c1 {
      %c0_i32_45 = arith.constant 0 : i32
      %3 = arith.index_cast %c0_i32_45 : i32 to index
      %c0_i32_46 = arith.constant 0 : i32
      %4 = arith.index_cast %c0_i32_46 : i32 to index
      %c67108864 = arith.constant 67108864 : index
      %5 = arith.muli %4, %c67108864 : index
      %6 = arith.addi %3, %5 : index
      %c128_i32_47 = arith.constant 128 : i32
      %7 = arith.muli %arg5, %c128_i32_47 : i32
      %8 = arith.index_cast %7 : i32 to index
      %9 = arith.addi %8, %arg7 : index
      %c16384 = arith.constant 16384 : index
      %10 = arith.muli %9, %c16384 : index
      %11 = arith.addi %6, %10 : index
      %c0_i32_48 = arith.constant 0 : i32
      %12 = arith.index_cast %c0_i32_48 : i32 to index
      %c256 = arith.constant 256 : index
      %13 = arith.muli %12, %c256 : index
      %14 = arith.addi %11, %13 : index
      %c0_i32_49 = arith.constant 0 : i32
      %15 = arith.index_cast %c0_i32_49 : i32 to index
      %c1_50 = arith.constant 1 : index
      %16 = arith.muli %15, %c1_50 : index
      %17 = arith.addi %14, %16 : index
      %reinterpret_cast_51 = memref.reinterpret_cast %reinterpret_cast to offset: [%17], sizes: [64, 256], strides: [256, 1] : memref<1x4096x64x256xbf16, strided<[67108864, 16384, 256, 1]>> to memref<64x256xbf16, strided<[256, 1], offset: ?>>
      "tilelang.copy"(%reinterpret_cast_51, %view) : (memref<64x256xbf16, strided<[256, 1], offset: ?>>, memref<64x256xbf16, 1>) -> ()
      "tilelang.scope"() ({
        %cst = arith.constant 0.000000e+00 : f32
        linalg.fill ins(%cst : f32) outs(%view_26 : memref<32x256xf32, 1>)
        %cst_70 = arith.constant 1.000000e+00 : f32
        linalg.fill ins(%cst_70 : f32) outs(%view_41 : memref<32xf32, 1>)
      }) {mode = #tilelang.scope_mode<simd>} : () -> ()
      %c0_i32_52 = arith.constant 0 : i32
      %18 = arith.index_cast %c0_i32_52 : i32 to index
      %c32_i32 = arith.constant 32 : i32
      %19 = arith.muli %arg6, %c32_i32 : i32
      %20 = arith.index_cast %19 : i32 to index
      %c1_53 = arith.constant 1 : index
      %21 = arith.muli %20, %c1_53 : index
      %22 = arith.addi %18, %21 : index
      %reinterpret_cast_54 = memref.reinterpret_cast %reinterpret_cast_1 to offset: [%22], sizes: [32], strides: [1] : memref<64xf32, strided<[1]>> to memref<32xf32, strided<[1], offset: ?>>
      "tilelang.copy"(%reinterpret_cast_54, %view_32) : (memref<32xf32, strided<[1], offset: ?>>, memref<32xf32, 1>) -> ()
      %c0_i32_55 = arith.constant 0 : i32
      %23 = arith.index_cast %c0_i32_55 : i32 to index
      %c128_i32_56 = arith.constant 128 : i32
      %24 = arith.index_cast %c128_i32_56 : i32 to index
      %25 = arith.addi %23, %24 : index
      %c1_57 = arith.constant 1 : index
      scf.for %arg8 = %23 to %25 step %c1_57 {
        %c0_i32_70 = arith.constant 0 : i32
        %45 = arith.index_cast %c0_i32_70 : i32 to index
        %c128_i32_71 = arith.constant 128 : i32
        %46 = arith.muli %arg5, %c128_i32_71 : i32
        %47 = arith.index_cast %46 : i32 to index
        %48 = arith.addi %47, %arg7 : index
        %49 = memref.load %reinterpret_cast_2[%45, %48, %arg8] : memref<1x4096x128xi32, strided<[524288, 128, 1]>>
        memref.store %49, %view_12[%arg8] : memref<128xi32, 1>
      } {tilelang.loop_kind = "serial"}
      %c0_i32_58 = arith.constant 0 : i32
      %26 = arith.index_cast %c0_i32_58 : i32 to index
      %c8_i32 = arith.constant 8 : i32
      %27 = arith.index_cast %c8_i32 : i32 to index
      %28 = arith.addi %26, %27 : index
      %c1_59 = arith.constant 1 : index
      scf.for %arg8 = %26 to %28 step %c1_59 {
        %c0_i32_70 = arith.constant 0 : i32
        %45 = arith.index_cast %c0_i32_70 : i32 to index
        %c16_i32 = arith.constant 16 : i32
        %46 = arith.index_cast %c16_i32 : i32 to index
        %47 = arith.addi %45, %46 : index
        %c1_71 = arith.constant 1 : index
        scf.for %arg9 = %45 to %47 step %c1_71 {
          %c0_i32_72 = arith.constant 0 : i32
          %48 = arith.index_cast %c0_i32_72 : i32 to index
          %c0_i32_73 = arith.constant 0 : i32
          %49 = arith.index_cast %c0_i32_73 : i32 to index
          %c1048576 = arith.constant 1048576 : index
          %50 = arith.muli %49, %c1048576 : index
          %51 = arith.addi %48, %50 : index
          %c16_i32_74 = arith.constant 16 : i32
          %52 = arith.index_cast %c16_i32_74 : i32 to index
          %53 = arith.muli %arg8, %52 : index
          %54 = arith.addi %53, %arg9 : index
          %55 = memref.load %view_12[%54] : memref<128xi32, 1>
          %56 = arith.index_cast %55 : i32 to index
          %c256_75 = arith.constant 256 : index
          %57 = arith.muli %56, %c256_75 : index
          %58 = arith.addi %51, %57 : index
          %c0_i32_76 = arith.constant 0 : i32
          %59 = arith.index_cast %c0_i32_76 : i32 to index
          %c1_77 = arith.constant 1 : index
          %60 = arith.muli %59, %c1_77 : index
          %61 = arith.addi %58, %60 : index
          %reinterpret_cast_78 = memref.reinterpret_cast %reinterpret_cast_0 to offset: [%61], sizes: [256], strides: [1] : memref<1x4096x256xbf16, strided<[1048576, 256, 1]>> to memref<256xbf16, strided<[1], offset: ?>>
          %c0_i32_79 = arith.constant 0 : i32
          %62 = arith.index_cast %c0_i32_79 : i32 to index
          %c256_80 = arith.constant 256 : index
          %63 = arith.muli %arg9, %c256_80 : index
          %64 = arith.addi %62, %63 : index
          %c0_i32_81 = arith.constant 0 : i32
          %65 = arith.index_cast %c0_i32_81 : i32 to index
          %c1_82 = arith.constant 1 : index
          %66 = arith.muli %65, %c1_82 : index
          %67 = arith.addi %64, %66 : index
          %reinterpret_cast_83 = memref.reinterpret_cast %view_15 to offset: [%67], sizes: [256], strides: [1] : memref<16x256xbf16, 1> to memref<256xbf16, strided<[1], offset: ?>, 1>
          "tilelang.copy"(%reinterpret_cast_78, %reinterpret_cast_83) : (memref<256xbf16, strided<[1], offset: ?>>, memref<256xbf16, strided<[1], offset: ?>, 1>) -> ()
        } {tilelang.loop_kind = "serial"}
        "tilelang.copy"(%view_15, %view_6) : (memref<16x256xbf16, 1>, memref<16x256xbf16, 1>) -> ()
        "tilelang.gemm"(%view, %view_6, %alloc_16) {clear_accum, transpose_b} : (memref<64x256xbf16, 1>, memref<16x256xbf16, 1>, memref<64x16xf32, 2>) -> ()
        "tilelang.copy"(%alloc_16, %view_20) {split_dim = 0 : i64} : (memref<64x16xf32, 2>, memref<32x16xf32, 1>) -> ()
        "tilelang.scope"() ({
          %alloc_72 = memref.alloc() : memref<32x16xf32, 2>
          %alloc_73 = memref.alloc() : memref<32xf32, 2>
          "tilelang.copy"(%view_20, %alloc_72) : (memref<32x16xf32, 1>, memref<32x16xf32, 2>) -> ()
          %cst = arith.constant 6.250000e-02 : f32
          "tilelang.vmuls"(%alloc_72, %cst, %alloc_72) : (memref<32x16xf32, 2>, f32, memref<32x16xf32, 2>) -> ()
          "tilelang.copy"(%alloc_72, %view_20) : (memref<32x16xf32, 2>, memref<32x16xf32, 1>) -> ()
          "tilelang.copy"(%view_32, %view_35) : (memref<32xf32, 1>, memref<32xf32, 1>) -> ()
          %cst_74 = arith.constant 0xFF800000 : f32
          linalg.fill ins(%cst_74 : f32) outs(%alloc_73 : memref<32xf32, 2>)
          linalg.reduce ins(%alloc_72 : memref<32x16xf32, 2>) outs(%alloc_73 : memref<32xf32, 2>) dimensions = [1] 
            (%in: f32, %init: f32) {
              %48 = arith.maximumf %in, %init : f32
              linalg.yield %48 : f32
            }
          "tilelang.copy"(%alloc_73, %view_32) : (memref<32xf32, 2>, memref<32xf32, 1>) -> ()
        }) {mode = #tilelang.scope_mode<simd>} : () -> ()
        "tilelang.scope"() ({
          %alloc_72 = memref.alloc() : memref<32x16xf32, 2>
          %alloc_73 = memref.alloc() : memref<32x16xf32, 2>
          %alloc_74 = memref.alloc() : memref<32x16xbf16, 2>
          %alloc_75 = memref.alloc() : memref<32xf32, 2>
          %alloc_76 = memref.alloc() : memref<32xf32, 2>
          %alloc_77 = memref.alloc() : memref<32xf32, 2>
          %alloc_78 = memref.alloc() : memref<32x16xf32, 2>
          %alloc_79 = memref.alloc() : memref<32xf32, 2>
          "tilelang.copy"(%view_20, %alloc_72) : (memref<32x16xf32, 1>, memref<32x16xf32, 2>) -> ()
          "tilelang.copy"(%view_32, %alloc_77) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
          "tilelang.copy"(%view_35, %alloc_75) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
          "tilelang.vmax"(%alloc_77, %alloc_75, %alloc_76) {dtype = "float32"} : (memref<32xf32, 2>, memref<32xf32, 2>, memref<32xf32, 2>) -> ()
          "tilelang.copy"(%alloc_76, %view_32) : (memref<32xf32, 2>, memref<32xf32, 1>) -> ()
          linalg.broadcast ins(%alloc_76 : memref<32xf32, 2>) outs(%alloc_78 : memref<32x16xf32, 2>) dimensions = [1] 
          "tilelang.vexpdif"(%alloc_72, %alloc_78, %alloc_73) : (memref<32x16xf32, 2>, memref<32x16xf32, 2>, memref<32x16xf32, 2>) -> ()
          "tilelang.vcvt"(%alloc_73, %alloc_74) {dst_dtype = "bfloat16", src_dtype = "float32"} : (memref<32x16xf32, 2>, memref<32x16xbf16, 2>) -> ()
          "tilelang.copy"(%alloc_74, %view_23) : (memref<32x16xbf16, 2>, memref<32x16xbf16, 1>) -> ()
          %cst = arith.constant 0.000000e+00 : f32
          linalg.fill ins(%cst : f32) outs(%alloc_79 : memref<32xf32, 2>)
          linalg.reduce ins(%alloc_73 : memref<32x16xf32, 2>) outs(%alloc_79 : memref<32xf32, 2>) dimensions = [1] 
            (%in: f32, %init: f32) {
              %48 = arith.addf %in, %init : f32
              linalg.yield %48 : f32
            }
          "tilelang.copy"(%alloc_79, %view_38) : (memref<32xf32, 2>, memref<32xf32, 1>) -> ()
        }) {mode = #tilelang.scope_mode<simd>} : () -> ()
        "tilelang.scope"() ({
          %alloc_72 = memref.alloc() : memref<32xf32, 2>
          %alloc_73 = memref.alloc() : memref<32xf32, 2>
          %alloc_74 = memref.alloc() : memref<32xf32, 2>
          %alloc_75 = memref.alloc() : memref<32xf32, 2>
          %alloc_76 = memref.alloc() : memref<32xf32, 2>
          "tilelang.copy"(%view_35, %alloc_72) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
          "tilelang.copy"(%view_32, %alloc_73) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
          "tilelang.copy"(%view_41, %alloc_74) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
          "tilelang.copy"(%view_38, %alloc_76) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
          "tilelang.vexpdif"(%alloc_72, %alloc_73, %alloc_75) : (memref<32xf32, 2>, memref<32xf32, 2>, memref<32xf32, 2>) -> ()
          "tilelang.copy"(%alloc_75, %view_44) : (memref<32xf32, 2>, memref<32xf32, 1>) -> ()
          linalg.mul ins(%alloc_74, %alloc_75 : memref<32xf32, 2>, memref<32xf32, 2>) outs(%alloc_74 : memref<32xf32, 2>)
          linalg.add ins(%alloc_74, %alloc_76 : memref<32xf32, 2>, memref<32xf32, 2>) outs(%alloc_74 : memref<32xf32, 2>)
          "tilelang.copy"(%alloc_74, %view_41) : (memref<32xf32, 2>, memref<32xf32, 1>) -> ()
        }) {mode = #tilelang.scope_mode<simd>} : () -> ()
        "tilelang.copy"(%view_23, %view_9) {split_dim = 0 : i64} : (memref<32x16xbf16, 1>, memref<64x16xbf16, 1>) -> ()
        "tilelang.gemm"(%view_9, %view_6, %alloc_17) {clear_accum} : (memref<64x16xbf16, 1>, memref<16x256xbf16, 1>, memref<64x256xf32, 2>) -> ()
        "tilelang.copy"(%alloc_17, %view_29) {split_dim = 0 : i64} : (memref<64x256xf32, 2>, memref<32x256xf32, 1>) -> ()
        "tilelang.scope"() ({
          %alloc_72 = memref.alloc() : memref<32x256xf32, 2>
          %alloc_73 = memref.alloc() : memref<32x256xf32, 2>
          %alloc_74 = memref.alloc() : memref<32xf32, 2>
          %alloc_75 = memref.alloc() : memref<32x256xf32, 2>
          "tilelang.copy"(%view_26, %alloc_72) : (memref<32x256xf32, 1>, memref<32x256xf32, 2>) -> ()
          "tilelang.copy"(%view_29, %alloc_73) : (memref<32x256xf32, 1>, memref<32x256xf32, 2>) -> ()
          "tilelang.copy"(%view_44, %alloc_74) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
          linalg.broadcast ins(%alloc_74 : memref<32xf32, 2>) outs(%alloc_75 : memref<32x256xf32, 2>) dimensions = [1] 
          linalg.mul ins(%alloc_72, %alloc_75 : memref<32x256xf32, 2>, memref<32x256xf32, 2>) outs(%alloc_72 : memref<32x256xf32, 2>)
          linalg.add ins(%alloc_72, %alloc_73 : memref<32x256xf32, 2>, memref<32x256xf32, 2>) outs(%alloc_72 : memref<32x256xf32, 2>)
          "tilelang.copy"(%alloc_72, %view_26) : (memref<32x256xf32, 2>, memref<32x256xf32, 1>) -> ()
        }) {mode = #tilelang.scope_mode<simd>} : () -> ()
      } {tilelang.loop_kind = "serial"}
      "tilelang.scope"() ({
        %alloc_70 = memref.alloc() : memref<32x256xf32, 2>
        %alloc_71 = memref.alloc() : memref<32xf32, 2>
        %alloc_72 = memref.alloc() : memref<32x256xf32, 2>
        "tilelang.copy"(%view_26, %alloc_70) : (memref<32x256xf32, 1>, memref<32x256xf32, 2>) -> ()
        "tilelang.copy"(%view_41, %alloc_71) : (memref<32xf32, 1>, memref<32xf32, 2>) -> ()
        linalg.broadcast ins(%alloc_71 : memref<32xf32, 2>) outs(%alloc_72 : memref<32x256xf32, 2>) dimensions = [1] 
        linalg.div ins(%alloc_70, %alloc_72 : memref<32x256xf32, 2>, memref<32x256xf32, 2>) outs(%alloc_70 : memref<32x256xf32, 2>)
        "tilelang.copy"(%alloc_70, %view_26) : (memref<32x256xf32, 2>, memref<32x256xf32, 1>) -> ()
      }) {mode = #tilelang.scope_mode<simd>} : () -> ()
      %c0_i32_60 = arith.constant 0 : i32
      %29 = arith.index_cast %c0_i32_60 : i32 to index
      %c0_i32_61 = arith.constant 0 : i32
      %30 = arith.index_cast %c0_i32_61 : i32 to index
      %c67108864_62 = arith.constant 67108864 : index
      %31 = arith.muli %30, %c67108864_62 : index
      %32 = arith.addi %29, %31 : index
      %c128_i32_63 = arith.constant 128 : i32
      %33 = arith.muli %arg5, %c128_i32_63 : i32
      %34 = arith.index_cast %33 : i32 to index
      %35 = arith.addi %34, %arg7 : index
      %c16384_64 = arith.constant 16384 : index
      %36 = arith.muli %35, %c16384_64 : index
      %37 = arith.addi %32, %36 : index
      %c32_i32_65 = arith.constant 32 : i32
      %38 = arith.muli %arg6, %c32_i32_65 : i32
      %39 = arith.index_cast %38 : i32 to index
      %c256_66 = arith.constant 256 : index
      %40 = arith.muli %39, %c256_66 : index
      %41 = arith.addi %37, %40 : index
      %c0_i32_67 = arith.constant 0 : i32
      %42 = arith.index_cast %c0_i32_67 : i32 to index
      %c1_68 = arith.constant 1 : index
      %43 = arith.muli %42, %c1_68 : index
      %44 = arith.addi %41, %43 : index
      %reinterpret_cast_69 = memref.reinterpret_cast %reinterpret_cast_3 to offset: [%44], sizes: [32, 256], strides: [256, 1] : memref<1x4096x64x256xf32, strided<[67108864, 16384, 256, 1]>> to memref<32x256xf32, strided<[256, 1], offset: ?>>
      "tilelang.copy"(%view_26, %reinterpret_cast_69) : (memref<32x256xf32, 1>, memref<32x256xf32, strided<[256, 1], offset: ?>>) -> ()
    } {num_stages = 2 : i64, tilelang.loop_kind = "pipelined"}
    return
  }
}

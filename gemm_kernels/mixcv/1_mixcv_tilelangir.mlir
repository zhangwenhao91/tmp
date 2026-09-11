module {
  func.func @mixCV_kernel(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<?xf32>, %arg4: i32) attributes {BlockIdx = 4 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32> to memref<16x128xf32, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xf32> to memref<128x128xf32, strided<[128, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32> to memref<16x128xf32, strided<[128, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32> to memref<16x128xf32, strided<[128, 1]>>
    %alloc = memref.alloc() : memref<8192xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    %alloc_3 = memref.alloc() : memref<65536xi8, 1>
    %c0_4 = arith.constant 0 : index
    %view_5 = memref.view %alloc_3[%c0_4][] : memref<65536xi8, 1> to memref<128x128xf32, 1>
    %alloc_6 = memref.alloc() : memref<8192xi8, 1>
    %c0_7 = arith.constant 0 : index
    %view_8 = memref.view %alloc_6[%c0_7][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    %alloc_9 = memref.alloc() : memref<8192xi8, 1>
    %c0_10 = arith.constant 0 : index
    %view_11 = memref.view %alloc_9[%c0_10][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    %alloc_12 = memref.alloc() : memref<16x128xf32, 2>
    %alloc_13 = memref.alloc() : memref<8192xi8, 1>
    %c0_14 = arith.constant 0 : index
    %view_15 = memref.view %alloc_13[%c0_14][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x128xf32, strided<[128, 1]>>, memref<16x128xf32, 1>) -> ()
    "tilelang.copy"(%reinterpret_cast_0, %view_5) : (memref<128x128xf32, strided<[128, 1]>>, memref<128x128xf32, 1>) -> ()
    "tilelang.copy"(%reinterpret_cast_1, %view_8) : (memref<16x128xf32, strided<[128, 1]>>, memref<16x128xf32, 1>) -> ()
    "tilelang.gemm"(%view, %view_5, %alloc_12) : (memref<16x128xf32, 1>, memref<128x128xf32, 1>, memref<16x128xf32, 2>) -> ()
    "tilelang.copy"(%alloc_12, %view_15) : (memref<16x128xf32, 2>, memref<16x128xf32, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_16 = memref.alloc() : memref<64xf32, 2>
      %alloc_17 = memref.alloc() : memref<64xf32, 2>
      %alloc_18 = memref.alloc() : memref<64xf32, 2>
      %c0_i32 = arith.constant 0 : i32
      %0 = arith.index_cast %c0_i32 : i32 to index
      %c16_i32 = arith.constant 16 : i32
      %1 = arith.index_cast %c16_i32 : i32 to index
      %2 = arith.addi %0, %1 : index
      %c1 = arith.constant 1 : index
      scf.for %arg5 = %0 to %2 step %c1 {
        %c0_i32_19 = arith.constant 0 : i32
        %3 = arith.index_cast %c0_i32_19 : i32 to index
        %c2_i32 = arith.constant 2 : i32
        %4 = arith.index_cast %c2_i32 : i32 to index
        %5 = arith.addi %3, %4 : index
        %c1_20 = arith.constant 1 : index
        scf.for %arg6 = %3 to %5 step %c1_20 {
          %c0_i32_21 = arith.constant 0 : i32
          %6 = arith.index_cast %c0_i32_21 : i32 to index
          %c128 = arith.constant 128 : index
          %7 = arith.muli %arg5, %c128 : index
          %8 = arith.addi %6, %7 : index
          %c64_i32 = arith.constant 64 : i32
          %9 = arith.index_cast %c64_i32 : i32 to index
          %10 = arith.muli %arg6, %9 : index
          %c1_22 = arith.constant 1 : index
          %11 = arith.muli %10, %c1_22 : index
          %12 = arith.addi %8, %11 : index
          %reinterpret_cast_23 = memref.reinterpret_cast %view_15 to offset: [%12], sizes: [64], strides: [1] : memref<16x128xf32, 1> to memref<64xf32, strided<[1], offset: ?>, 1>
          "tilelang.copy"(%reinterpret_cast_23, %alloc_16) : (memref<64xf32, strided<[1], offset: ?>, 1>, memref<64xf32, 2>) -> ()
          %c0_i32_24 = arith.constant 0 : i32
          %13 = arith.index_cast %c0_i32_24 : i32 to index
          %c128_25 = arith.constant 128 : index
          %14 = arith.muli %arg5, %c128_25 : index
          %15 = arith.addi %13, %14 : index
          %c64_i32_26 = arith.constant 64 : i32
          %16 = arith.index_cast %c64_i32_26 : i32 to index
          %17 = arith.muli %arg6, %16 : index
          %c1_27 = arith.constant 1 : index
          %18 = arith.muli %17, %c1_27 : index
          %19 = arith.addi %15, %18 : index
          %reinterpret_cast_28 = memref.reinterpret_cast %view_8 to offset: [%19], sizes: [64], strides: [1] : memref<16x128xf32, 1> to memref<64xf32, strided<[1], offset: ?>, 1>
          "tilelang.copy"(%reinterpret_cast_28, %alloc_17) : (memref<64xf32, strided<[1], offset: ?>, 1>, memref<64xf32, 2>) -> ()
          linalg.add ins(%alloc_16, %alloc_17 : memref<64xf32, 2>, memref<64xf32, 2>) outs(%alloc_18 : memref<64xf32, 2>)
          %c0_i32_29 = arith.constant 0 : i32
          %20 = arith.index_cast %c0_i32_29 : i32 to index
          %c128_30 = arith.constant 128 : index
          %21 = arith.muli %arg5, %c128_30 : index
          %22 = arith.addi %20, %21 : index
          %c64_i32_31 = arith.constant 64 : i32
          %23 = arith.index_cast %c64_i32_31 : i32 to index
          %24 = arith.muli %arg6, %23 : index
          %c1_32 = arith.constant 1 : index
          %25 = arith.muli %24, %c1_32 : index
          %26 = arith.addi %22, %25 : index
          %reinterpret_cast_33 = memref.reinterpret_cast %view_11 to offset: [%26], sizes: [64], strides: [1] : memref<16x128xf32, 1> to memref<64xf32, strided<[1], offset: ?>, 1>
          "tilelang.copy"(%alloc_18, %reinterpret_cast_33) : (memref<64xf32, 2>, memref<64xf32, strided<[1], offset: ?>, 1>) -> ()
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_11, %reinterpret_cast_2) : (memref<16x128xf32, 1>, memref<16x128xf32, strided<[128, 1]>>) -> ()
    return
  }
}

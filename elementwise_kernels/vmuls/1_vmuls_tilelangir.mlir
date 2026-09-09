module {
  func.func @vmuls_kernel(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: i32) attributes {BlockIdx = 3 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32> to memref<32x128xf32, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [1], strides: [1] : memref<?xf32> to memref<1xf32, strided<[1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32> to memref<32x128xf32, strided<[128, 1]>>
    %alloc = memref.alloc() : memref<8192xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    %alloc_2 = memref.alloc() : memref<4xi8, 1>
    %c0_3 = arith.constant 0 : index
    %view_4 = memref.view %alloc_2[%c0_3][] : memref<4xi8, 1> to memref<1xf32, 1>
    %alloc_5 = memref.alloc() : memref<8192xi8, 1>
    %c0_6 = arith.constant 0 : index
    %view_7 = memref.view %alloc_5[%c0_6][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c16_i32 = arith.constant 16 : i32
    %1 = arith.muli %arg3, %c16_i32 : i32
    %2 = arith.index_cast %1 : i32 to index
    %c128 = arith.constant 128 : index
    %3 = arith.muli %2, %c128 : index
    %4 = arith.addi %0, %3 : index
    %c0_i32_8 = arith.constant 0 : i32
    %5 = arith.index_cast %c0_i32_8 : i32 to index
    %c1 = arith.constant 1 : index
    %6 = arith.muli %5, %c1 : index
    %7 = arith.addi %4, %6 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %reinterpret_cast to offset: [%7], sizes: [16, 128], strides: [128, 1] : memref<32x128xf32, strided<[128, 1]>> to memref<16x128xf32, strided<[128, 1], offset: ?>>
    "tilelang.copy"(%reinterpret_cast_9, %view) : (memref<16x128xf32, strided<[128, 1], offset: ?>>, memref<16x128xf32, 1>) -> ()
    %reinterpret_cast_10 = memref.reinterpret_cast %reinterpret_cast_0 to offset: [0], sizes: [], strides: [] : memref<1xf32, strided<[1]>> to memref<f32, strided<[]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %view_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 1> to memref<f32, strided<[]>, 1>
    "tilelang.copy"(%reinterpret_cast_10, %reinterpret_cast_11) : (memref<f32, strided<[]>>, memref<f32, strided<[]>, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_18 = memref.alloc() : memref<16x128xf32, 2>
      %alloc_19 = memref.alloc() : memref<16x128xf32, 2>
      %alloc_20 = memref.alloc() : memref<16x128xf32, 2>
      "tilelang.copy"(%view, %alloc_18) : (memref<16x128xf32, 1>, memref<16x128xf32, 2>) -> ()
      %c0_i32_21 = arith.constant 0 : i32
      %16 = arith.index_cast %c0_i32_21 : i32 to index
      %17 = memref.load %view_4[%16] : memref<1xf32, 1>
      linalg.fill ins(%17 : f32) outs(%alloc_20 : memref<16x128xf32, 2>)
      linalg.mul ins(%alloc_18, %alloc_20 : memref<16x128xf32, 2>, memref<16x128xf32, 2>) outs(%alloc_19 : memref<16x128xf32, 2>)
      "tilelang.copy"(%alloc_19, %view_7) : (memref<16x128xf32, 2>, memref<16x128xf32, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    %c0_i32_12 = arith.constant 0 : i32
    %8 = arith.index_cast %c0_i32_12 : i32 to index
    %c16_i32_13 = arith.constant 16 : i32
    %9 = arith.muli %arg3, %c16_i32_13 : i32
    %10 = arith.index_cast %9 : i32 to index
    %c128_14 = arith.constant 128 : index
    %11 = arith.muli %10, %c128_14 : index
    %12 = arith.addi %8, %11 : index
    %c0_i32_15 = arith.constant 0 : i32
    %13 = arith.index_cast %c0_i32_15 : i32 to index
    %c1_16 = arith.constant 1 : index
    %14 = arith.muli %13, %c1_16 : index
    %15 = arith.addi %12, %14 : index
    %reinterpret_cast_17 = memref.reinterpret_cast %reinterpret_cast_1 to offset: [%15], sizes: [16, 128], strides: [128, 1] : memref<32x128xf32, strided<[128, 1]>> to memref<16x128xf32, strided<[128, 1], offset: ?>>
    "tilelang.copy"(%view_7, %reinterpret_cast_17) : (memref<16x128xf32, 1>, memref<16x128xf32, strided<[128, 1], offset: ?>>) -> ()
    return
  }
}

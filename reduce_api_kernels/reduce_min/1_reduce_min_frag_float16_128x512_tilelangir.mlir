module {
  func.func @reduce_min_frag_kernel(%arg0: memref<?xf16>, %arg1: memref<?xf16>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [128, 512], strides: [512, 1] : memref<?xf16> to memref<128x512xf16, strided<[512, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128], strides: [1] : memref<?xf16> to memref<128xf16, strided<[1]>>
    %alloc = memref.alloc() : memref<16384xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<16384xi8, 1> to memref<16x512xf16, 1>
    %alloc_1 = memref.alloc() : memref<32xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<32xi8, 1> to memref<16xf16, 1>
    %alloc_4 = memref.alloc() : memref<32xi8, 1>
    %c0_5 = arith.constant 0 : index
    %view_6 = memref.view %alloc_4[%c0_5][] : memref<32xi8, 1> to memref<16xf16, 1>
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c16_i32 = arith.constant 16 : i32
    %1 = arith.muli %arg2, %c16_i32 : i32
    %2 = arith.index_cast %1 : i32 to index
    %c512 = arith.constant 512 : index
    %3 = arith.muli %2, %c512 : index
    %4 = arith.addi %0, %3 : index
    %c0_i32_7 = arith.constant 0 : i32
    %5 = arith.index_cast %c0_i32_7 : i32 to index
    %c1 = arith.constant 1 : index
    %6 = arith.muli %5, %c1 : index
    %7 = arith.addi %4, %6 : index
    %reinterpret_cast_8 = memref.reinterpret_cast %reinterpret_cast to offset: [%7], sizes: [16, 512], strides: [512, 1] : memref<128x512xf16, strided<[512, 1]>> to memref<16x512xf16, strided<[512, 1], offset: ?>>
    "tilelang.copy"(%reinterpret_cast_8, %view) : (memref<16x512xf16, strided<[512, 1], offset: ?>>, memref<16x512xf16, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_13 = memref.alloc() : memref<16x512xf16, 2>
      %alloc_14 = memref.alloc() : memref<16x512xf16, 2>
      %alloc_15 = memref.alloc() : memref<16x512xf16, 2>
      %alloc_16 = memref.alloc() : memref<16xf16, 2>
      %cst = arith.constant -1.000000e+00 : f16
      linalg.fill ins(%cst : f16) outs(%alloc_15 : memref<16x512xf16, 2>)
      "tilelang.copy"(%view, %alloc_13) : (memref<16x512xf16, 1>, memref<16x512xf16, 2>) -> ()
      linalg.elementwise <mul> ins(%alloc_13, %alloc_15 : memref<16x512xf16, 2>, memref<16x512xf16, 2>) outs(%alloc_14 : memref<16x512xf16, 2>)
      %cst_17 = arith.constant 0xFC00 : f16
      linalg.fill ins(%cst_17 : f16) outs(%alloc_16 : memref<16xf16, 2>)
      linalg.reduce ins(%alloc_14 : memref<16x512xf16, 2>) outs(%alloc_16 : memref<16xf16, 2>) dimensions = [1] 
        (%in: f16, %init: f16) {
          %13 = arith.maximumf %in, %init : f16
          linalg.yield %13 : f16
        }
      "tilelang.copy"(%alloc_16, %view_6) : (memref<16xf16, 2>, memref<16xf16, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.scope"() ({
      %alloc_13 = memref.alloc() : memref<16xf16, 2>
      %alloc_14 = memref.alloc() : memref<16xf16, 2>
      %alloc_15 = memref.alloc() : memref<16xf16, 2>
      %cst = arith.constant -1.000000e+00 : f16
      linalg.fill ins(%cst : f16) outs(%alloc_14 : memref<16xf16, 2>)
      "tilelang.copy"(%view_6, %alloc_13) : (memref<16xf16, 1>, memref<16xf16, 2>) -> ()
      linalg.elementwise <mul> ins(%alloc_13, %alloc_14 : memref<16xf16, 2>, memref<16xf16, 2>) outs(%alloc_15 : memref<16xf16, 2>)
      "tilelang.copy"(%alloc_15, %view_3) : (memref<16xf16, 2>, memref<16xf16, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    %c0_i32_9 = arith.constant 0 : i32
    %8 = arith.index_cast %c0_i32_9 : i32 to index
    %c16_i32_10 = arith.constant 16 : i32
    %9 = arith.muli %arg2, %c16_i32_10 : i32
    %10 = arith.index_cast %9 : i32 to index
    %c1_11 = arith.constant 1 : index
    %11 = arith.muli %10, %c1_11 : index
    %12 = arith.addi %8, %11 : index
    %reinterpret_cast_12 = memref.reinterpret_cast %reinterpret_cast_0 to offset: [%12], sizes: [16], strides: [1] : memref<128xf16, strided<[1]>> to memref<16xf16, strided<[1], offset: ?>>
    "tilelang.copy"(%view_3, %reinterpret_cast_12) : (memref<16xf16, 1>, memref<16xf16, strided<[1], offset: ?>>) -> ()
    return
  }
}

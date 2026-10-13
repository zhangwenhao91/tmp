module {
  func.func @reduce_absmax_frag_kernel(%arg0: memref<?xi16>, %arg1: memref<?xi16>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [128, 512], strides: [512, 1] : memref<?xi16> to memref<128x512xi16, strided<[512, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128], strides: [1] : memref<?xi16> to memref<128xi16, strided<[1]>>
    %alloc = memref.alloc() : memref<16384xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<16384xi8, 1> to memref<16x512xi16, 1>
    %alloc_1 = memref.alloc() : memref<32xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<32xi8, 1> to memref<16xi16, 1>
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c16_i32 = arith.constant 16 : i32
    %1 = arith.muli %arg2, %c16_i32 : i32
    %2 = arith.index_cast %1 : i32 to index
    %c512 = arith.constant 512 : index
    %3 = arith.muli %2, %c512 : index
    %4 = arith.addi %0, %3 : index
    %c0_i32_4 = arith.constant 0 : i32
    %5 = arith.index_cast %c0_i32_4 : i32 to index
    %c1 = arith.constant 1 : index
    %6 = arith.muli %5, %c1 : index
    %7 = arith.addi %4, %6 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %reinterpret_cast to offset: [%7], sizes: [16, 512], strides: [512, 1] : memref<128x512xi16, strided<[512, 1]>> to memref<16x512xi16, strided<[512, 1], offset: ?>>
    "tilelang.copy"(%reinterpret_cast_5, %view) : (memref<16x512xi16, strided<[512, 1], offset: ?>>, memref<16x512xi16, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_10 = memref.alloc() : memref<16x512xi16, 2>
      %alloc_11 = memref.alloc() : memref<16x512xi16, 2>
      %alloc_12 = memref.alloc() : memref<16x512xi16, 2>
      %alloc_13 = memref.alloc() : memref<16x512xi16, 2>
      %alloc_14 = memref.alloc() : memref<16xi16, 2>
      %c-1_i16 = arith.constant -1 : i16
      linalg.fill ins(%c-1_i16 : i16) outs(%alloc_13 : memref<16x512xi16, 2>)
      "tilelang.copy"(%view, %alloc_10) : (memref<16x512xi16, 1>, memref<16x512xi16, 2>) -> ()
      linalg.elementwise <mul> ins(%alloc_10, %alloc_13 : memref<16x512xi16, 2>, memref<16x512xi16, 2>) outs(%alloc_11 : memref<16x512xi16, 2>)
      "tilelang.vmax"(%alloc_10, %alloc_11, %alloc_12) {dtype = "int16"} : (memref<16x512xi16, 2>, memref<16x512xi16, 2>, memref<16x512xi16, 2>) -> ()
      %c-32768_i16 = arith.constant -32768 : i16
      linalg.fill ins(%c-32768_i16 : i16) outs(%alloc_14 : memref<16xi16, 2>)
      linalg.reduce ins(%alloc_12 : memref<16x512xi16, 2>) outs(%alloc_14 : memref<16xi16, 2>) dimensions = [1] 
        (%in: i16, %init: i16) {
          %13 = arith.maxsi %in, %init : i16
          linalg.yield %13 : i16
        }
      "tilelang.copy"(%alloc_14, %view_3) : (memref<16xi16, 2>, memref<16xi16, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    %c0_i32_6 = arith.constant 0 : i32
    %8 = arith.index_cast %c0_i32_6 : i32 to index
    %c16_i32_7 = arith.constant 16 : i32
    %9 = arith.muli %arg2, %c16_i32_7 : i32
    %10 = arith.index_cast %9 : i32 to index
    %c1_8 = arith.constant 1 : index
    %11 = arith.muli %10, %c1_8 : index
    %12 = arith.addi %8, %11 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %reinterpret_cast_0 to offset: [%12], sizes: [16], strides: [1] : memref<128xi16, strided<[1]>> to memref<16xi16, strided<[1], offset: ?>>
    "tilelang.copy"(%view_3, %reinterpret_cast_9) : (memref<16xi16, 1>, memref<16xi16, strided<[1], offset: ?>>) -> ()
    return
  }
}

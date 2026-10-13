module {
  func.func @reduce_min_frag_kernel(%arg0: memref<?xi16>, %arg1: memref<?xi16>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xi16> to memref<16x128xi16, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16], strides: [1] : memref<?xi16> to memref<16xi16, strided<[1]>>
    %alloc = memref.alloc() : memref<4096xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<4096xi8, 1> to memref<16x128xi16, 1>
    %alloc_1 = memref.alloc() : memref<32xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<32xi8, 1> to memref<16xi16, 1>
    %alloc_4 = memref.alloc() : memref<32xi8, 1>
    %c0_5 = arith.constant 0 : index
    %view_6 = memref.view %alloc_4[%c0_5][] : memref<32xi8, 1> to memref<16xi16, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x128xi16, strided<[128, 1]>>, memref<16x128xi16, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_7 = memref.alloc() : memref<16x128xi16, 2>
      %alloc_8 = memref.alloc() : memref<16x128xi16, 2>
      %alloc_9 = memref.alloc() : memref<16x128xi16, 2>
      %alloc_10 = memref.alloc() : memref<16xi16, 2>
      %c-1_i16 = arith.constant -1 : i16
      linalg.fill ins(%c-1_i16 : i16) outs(%alloc_9 : memref<16x128xi16, 2>)
      "tilelang.copy"(%view, %alloc_7) : (memref<16x128xi16, 1>, memref<16x128xi16, 2>) -> ()
      linalg.elementwise <mul> ins(%alloc_7, %alloc_9 : memref<16x128xi16, 2>, memref<16x128xi16, 2>) outs(%alloc_8 : memref<16x128xi16, 2>)
      %c-32768_i16 = arith.constant -32768 : i16
      linalg.fill ins(%c-32768_i16 : i16) outs(%alloc_10 : memref<16xi16, 2>)
      linalg.reduce ins(%alloc_8 : memref<16x128xi16, 2>) outs(%alloc_10 : memref<16xi16, 2>) dimensions = [1] 
        (%in: i16, %init: i16) {
          %0 = arith.maxsi %in, %init : i16
          linalg.yield %0 : i16
        }
      "tilelang.copy"(%alloc_10, %view_6) : (memref<16xi16, 2>, memref<16xi16, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.scope"() ({
      %alloc_7 = memref.alloc() : memref<16xi16, 2>
      %alloc_8 = memref.alloc() : memref<16xi16, 2>
      %alloc_9 = memref.alloc() : memref<16xi16, 2>
      %c-1_i16 = arith.constant -1 : i16
      linalg.fill ins(%c-1_i16 : i16) outs(%alloc_8 : memref<16xi16, 2>)
      "tilelang.copy"(%view_6, %alloc_7) : (memref<16xi16, 1>, memref<16xi16, 2>) -> ()
      linalg.elementwise <mul> ins(%alloc_7, %alloc_8 : memref<16xi16, 2>, memref<16xi16, 2>) outs(%alloc_9 : memref<16xi16, 2>)
      "tilelang.copy"(%alloc_9, %view_3) : (memref<16xi16, 2>, memref<16xi16, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<16xi16, 1>, memref<16xi16, strided<[1]>>) -> ()
    return
  }
}

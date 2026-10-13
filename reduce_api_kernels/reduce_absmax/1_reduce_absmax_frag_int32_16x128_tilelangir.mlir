module {
  func.func @reduce_absmax_frag_kernel(%arg0: memref<?xi32>, %arg1: memref<?xi32>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xi32> to memref<16x128xi32, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16], strides: [1] : memref<?xi32> to memref<16xi32, strided<[1]>>
    %alloc = memref.alloc() : memref<8192xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<8192xi8, 1> to memref<16x128xi32, 1>
    %alloc_1 = memref.alloc() : memref<64xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<64xi8, 1> to memref<16xi32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x128xi32, strided<[128, 1]>>, memref<16x128xi32, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_4 = memref.alloc() : memref<16x128xi32, 2>
      %alloc_5 = memref.alloc() : memref<16x128xi32, 2>
      %alloc_6 = memref.alloc() : memref<16x128xi32, 2>
      %alloc_7 = memref.alloc() : memref<16x128xi32, 2>
      %alloc_8 = memref.alloc() : memref<16xi32, 2>
      %c-1_i32 = arith.constant -1 : i32
      linalg.fill ins(%c-1_i32 : i32) outs(%alloc_7 : memref<16x128xi32, 2>)
      "tilelang.copy"(%view, %alloc_4) : (memref<16x128xi32, 1>, memref<16x128xi32, 2>) -> ()
      linalg.elementwise <mul> ins(%alloc_4, %alloc_7 : memref<16x128xi32, 2>, memref<16x128xi32, 2>) outs(%alloc_5 : memref<16x128xi32, 2>)
      "tilelang.vmax"(%alloc_4, %alloc_5, %alloc_6) {dtype = "int32"} : (memref<16x128xi32, 2>, memref<16x128xi32, 2>, memref<16x128xi32, 2>) -> ()
      %c-2147483648_i32 = arith.constant -2147483648 : i32
      linalg.fill ins(%c-2147483648_i32 : i32) outs(%alloc_8 : memref<16xi32, 2>)
      linalg.reduce ins(%alloc_6 : memref<16x128xi32, 2>) outs(%alloc_8 : memref<16xi32, 2>) dimensions = [1] 
        (%in: i32, %init: i32) {
          %0 = arith.maxsi %in, %init : i32
          linalg.yield %0 : i32
        }
      "tilelang.copy"(%alloc_8, %view_3) : (memref<16xi32, 2>, memref<16xi32, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<16xi32, 1>, memref<16xi32, strided<[1]>>) -> ()
    return
  }
}

module {
  func.func @reduce_sum_frag_kernel(%arg0: memref<?xi32>, %arg1: memref<?xi32>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 64], strides: [64, 1] : memref<?xi32> to memref<16x64xi32, strided<[64, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16], strides: [1] : memref<?xi32> to memref<16xi32, strided<[1]>>
    %alloc = memref.alloc() : memref<4096xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<4096xi8, 1> to memref<16x64xi32, 1>
    %alloc_1 = memref.alloc() : memref<64xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<64xi8, 1> to memref<16xi32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x64xi32, strided<[64, 1]>>, memref<16x64xi32, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_4 = memref.alloc() : memref<16x64xi32, 2>
      %alloc_5 = memref.alloc() : memref<16xi32, 2>
      "tilelang.copy"(%view, %alloc_4) : (memref<16x64xi32, 1>, memref<16x64xi32, 2>) -> ()
      %c0_i32 = arith.constant 0 : i32
      linalg.fill ins(%c0_i32 : i32) outs(%alloc_5 : memref<16xi32, 2>)
      linalg.reduce ins(%alloc_4 : memref<16x64xi32, 2>) outs(%alloc_5 : memref<16xi32, 2>) dimensions = [1] 
        (%in: i32, %init: i32) {
          %0 = arith.addi %in, %init : i32
          linalg.yield %0 : i32
        }
      "tilelang.copy"(%alloc_5, %view_3) : (memref<16xi32, 2>, memref<16xi32, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<16xi32, 1>, memref<16xi32, strided<[1]>>) -> ()
    return
  }
}

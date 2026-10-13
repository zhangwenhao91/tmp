module {
  func.func @reduce_absmax_shared_kernel(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32> to memref<16x128xf32, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16], strides: [1] : memref<?xf32> to memref<16xf32, strided<[1]>>
    %alloc = memref.alloc() : memref<8192xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    %alloc_1 = memref.alloc() : memref<64xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<64xi8, 1> to memref<16xf32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x128xf32, strided<[128, 1]>>, memref<16x128xf32, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_4 = memref.alloc() : memref<16x128xf32, 2>
      %alloc_5 = memref.alloc() : memref<16xf32, 2>
      "tilelang.copy"(%view, %alloc_4) : (memref<16x128xf32, 1>, memref<16x128xf32, 2>) -> ()
      %alloc_6 = memref.alloc() : memref<16x128xf32, 2>
      linalg.elementwise <abs> ins(%alloc_4 : memref<16x128xf32, 2>) outs(%alloc_6 : memref<16x128xf32, 2>)
      %cst = arith.constant 0xFF800000 : f32
      linalg.fill ins(%cst : f32) outs(%alloc_5 : memref<16xf32, 2>)
      linalg.reduce ins(%alloc_6 : memref<16x128xf32, 2>) outs(%alloc_5 : memref<16xf32, 2>) dimensions = [1] 
        (%in: f32, %init: f32) {
          %0 = arith.maximumf %in, %init : f32
          linalg.yield %0 : f32
        }
      "tilelang.copy"(%alloc_5, %view_3) : (memref<16xf32, 2>, memref<16xf32, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<16xf32, 1>, memref<16xf32, strided<[1]>>) -> ()
    return
  }
}

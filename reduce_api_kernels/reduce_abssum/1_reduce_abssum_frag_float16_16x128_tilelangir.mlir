module {
  func.func @reduce_abssum_frag_kernel(%arg0: memref<?xf16>, %arg1: memref<?xf16>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf16> to memref<16x128xf16, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16], strides: [1] : memref<?xf16> to memref<16xf16, strided<[1]>>
    %alloc = memref.alloc() : memref<4096xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<4096xi8, 1> to memref<16x128xf16, 1>
    %alloc_1 = memref.alloc() : memref<32xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<32xi8, 1> to memref<16xf16, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x128xf16, strided<[128, 1]>>, memref<16x128xf16, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_4 = memref.alloc() : memref<16x128xf16, 2>
      %alloc_5 = memref.alloc() : memref<16x128xf16, 2>
      %alloc_6 = memref.alloc() : memref<16x128xf16, 2>
      %alloc_7 = memref.alloc() : memref<16x128xf16, 2>
      %alloc_8 = memref.alloc() : memref<16xf16, 2>
      %cst = arith.constant -1.000000e+00 : f16
      linalg.fill ins(%cst : f16) outs(%alloc_7 : memref<16x128xf16, 2>)
      "tilelang.copy"(%view, %alloc_4) : (memref<16x128xf16, 1>, memref<16x128xf16, 2>) -> ()
      linalg.elementwise <mul> ins(%alloc_4, %alloc_7 : memref<16x128xf16, 2>, memref<16x128xf16, 2>) outs(%alloc_5 : memref<16x128xf16, 2>)
      "tilelang.vmax"(%alloc_4, %alloc_5, %alloc_6) {dtype = "float16"} : (memref<16x128xf16, 2>, memref<16x128xf16, 2>, memref<16x128xf16, 2>) -> ()
      %cst_9 = arith.constant 0.000000e+00 : f16
      linalg.fill ins(%cst_9 : f16) outs(%alloc_8 : memref<16xf16, 2>)
      linalg.reduce ins(%alloc_6 : memref<16x128xf16, 2>) outs(%alloc_8 : memref<16xf16, 2>) dimensions = [1] 
        (%in: f16, %init: f16) {
          %0 = arith.addf %in, %init : f16
          linalg.yield %0 : f16
        }
      "tilelang.copy"(%alloc_8, %view_3) : (memref<16xf16, 2>, memref<16xf16, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<16xf16, 1>, memref<16xf16, strided<[1]>>) -> ()
    return
  }
}

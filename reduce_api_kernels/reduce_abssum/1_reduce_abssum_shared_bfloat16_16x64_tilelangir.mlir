module {
  func.func @reduce_abssum_shared_kernel(%arg0: memref<?xbf16>, %arg1: memref<?xbf16>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 64], strides: [64, 1] : memref<?xbf16> to memref<16x64xbf16, strided<[64, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16], strides: [1] : memref<?xbf16> to memref<16xbf16, strided<[1]>>
    %alloc = memref.alloc() : memref<2048xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<2048xi8, 1> to memref<16x64xbf16, 1>
    %alloc_1 = memref.alloc() : memref<32xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<32xi8, 1> to memref<16xbf16, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x64xbf16, strided<[64, 1]>>, memref<16x64xbf16, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_4 = memref.alloc() : memref<16x64xbf16, 2>
      %alloc_5 = memref.alloc() : memref<16xbf16, 2>
      "tilelang.copy"(%view, %alloc_4) : (memref<16x64xbf16, 1>, memref<16x64xbf16, 2>) -> ()
      %alloc_6 = memref.alloc() : memref<16x64xbf16, 2>
      linalg.elementwise <abs> ins(%alloc_4 : memref<16x64xbf16, 2>) outs(%alloc_6 : memref<16x64xbf16, 2>)
      %cst = arith.constant 0.000000e+00 : bf16
      linalg.fill ins(%cst : bf16) outs(%alloc_5 : memref<16xbf16, 2>)
      linalg.reduce ins(%alloc_6 : memref<16x64xbf16, 2>) outs(%alloc_5 : memref<16xbf16, 2>) dimensions = [1] 
        (%in: bf16, %init: bf16) {
          %0 = arith.addf %in, %init : bf16
          linalg.yield %0 : bf16
        }
      "tilelang.copy"(%alloc_5, %view_3) : (memref<16xbf16, 2>, memref<16xbf16, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<16xbf16, 1>, memref<16xbf16, strided<[1]>>) -> ()
    return
  }
}

#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @reduce_abs_max_kernel(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32> to memref<32x128xf32, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32> to memref<32xf32, strided<[1]>>
    %alloc = memref.alloc() : memref<8192xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    %alloc_1 = memref.alloc() : memref<64xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<64xi8, 1> to memref<16xf32, 1>
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c16_i32 = arith.constant 16 : i32
    %1 = arith.muli %arg2, %c16_i32 : i32
    %2 = arith.index_cast %1 : i32 to index
    %c128 = arith.constant 128 : index
    %3 = arith.muli %2, %c128 : index
    %4 = arith.addi %0, %3 : index
    %c0_i32_4 = arith.constant 0 : i32
    %5 = arith.index_cast %c0_i32_4 : i32 to index
    %c1 = arith.constant 1 : index
    %6 = arith.muli %5, %c1 : index
    %7 = arith.addi %4, %6 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %reinterpret_cast to offset: [%7], sizes: [16, 128], strides: [128, 1] : memref<32x128xf32, strided<[128, 1]>> to memref<16x128xf32, strided<[128, 1], offset: ?>>
    "tilelang.copy"(%reinterpret_cast_5, %view) : (memref<16x128xf32, strided<[128, 1], offset: ?>>, memref<16x128xf32, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_10 = memref.alloc() : memref<16x128xf32, 2>
      %alloc_11 = memref.alloc() : memref<16x128xf32, 2>
      %alloc_12 = memref.alloc() : memref<16x128xf32, 2>
      %alloc_13 = memref.alloc() : memref<16x128xf32, 2>
      %alloc_14 = memref.alloc() : memref<16xf32, 2>
      %cst = arith.constant -1.000000e+00 : f32
      linalg.fill ins(%cst : f32) outs(%alloc_13 : memref<16x128xf32, 2>)
      "tilelang.copy"(%view, %alloc_10) : (memref<16x128xf32, 1>, memref<16x128xf32, 2>) -> ()
      linalg.mul ins(%alloc_10, %alloc_13 : memref<16x128xf32, 2>, memref<16x128xf32, 2>) outs(%alloc_11 : memref<16x128xf32, 2>)
      linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%alloc_10, %alloc_11 : memref<16x128xf32, 2>, memref<16x128xf32, 2>) outs(%alloc_12 : memref<16x128xf32, 2>) {
      ^bb0(%in: f32, %in_16: f32, %out: f32):
        %13 = arith.maximumf %in, %in_16 : f32
        linalg.yield %13 : f32
      }
      %cst_15 = arith.constant 0xFF800000 : f32
      linalg.fill ins(%cst_15 : f32) outs(%alloc_14 : memref<16xf32, 2>)
      linalg.reduce ins(%alloc_12 : memref<16x128xf32, 2>) outs(%alloc_14 : memref<16xf32, 2>) dimensions = [1] 
        (%in: f32, %init: f32) {
          %13 = arith.maximumf %in, %init : f32
          linalg.yield %13 : f32
        }
      "tilelang.copy"(%alloc_14, %view_3) : (memref<16xf32, 2>, memref<16xf32, 1>) -> ()
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    %c0_i32_6 = arith.constant 0 : i32
    %8 = arith.index_cast %c0_i32_6 : i32 to index
    %c16_i32_7 = arith.constant 16 : i32
    %9 = arith.muli %arg2, %c16_i32_7 : i32
    %10 = arith.index_cast %9 : i32 to index
    %c1_8 = arith.constant 1 : index
    %11 = arith.muli %10, %c1_8 : index
    %12 = arith.addi %8, %11 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %reinterpret_cast_0 to offset: [%12], sizes: [16], strides: [1] : memref<32xf32, strided<[1]>> to memref<16xf32, strided<[1], offset: ?>>
    "tilelang.copy"(%view_3, %reinterpret_cast_9) : (memref<16xf32, 1>, memref<16xf32, strided<[1], offset: ?>>) -> ()
    return
  }
}

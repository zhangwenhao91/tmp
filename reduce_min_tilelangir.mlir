#map = affine_map<(d0) -> (d0)>
module {
  func.func @reduce_min_kernel(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32> to memref<32x128xf32, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32> to memref<32xf32, strided<[1]>>
    %alloc = memref.alloc() : memref<16384xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<16384xi8, 1> to memref<32x128xf32, 1>
    %alloc_1 = memref.alloc() : memref<128xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<128xi8, 1> to memref<32xf32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<32x128xf32, strided<[128, 1]>>, memref<32x128xf32, 1>) -> ()
    "tilelang.scope"() ({
      %alloc_4 = memref.alloc() : memref<32xf32, 2>
      %alloc_5 = memref.alloc() : memref<32xf32, 2>
      %alloc_6 = memref.alloc() : memref<32x64xf32, 2>
      %alloc_7 = memref.alloc() : memref<32x64xf32, 2>
      %alloc_8 = memref.alloc() : memref<32x64xf32, 2>
      %alloc_9 = memref.alloc() : memref<32xf32, 2>
      %c0_i32 = arith.constant 0 : i32
      %0 = arith.index_cast %c0_i32 : i32 to index
      %c1_i32 = arith.constant 1 : i32
      %1 = arith.index_cast %c1_i32 : i32 to index
      %2 = arith.addi %0, %1 : index
      %c1 = arith.constant 1 : index
      scf.for %arg3 = %0 to %2 step %c1 {
        %cst = arith.constant -1.000000e+30 : f32
        linalg.fill ins(%cst : f32) outs(%alloc_4 : memref<32xf32, 2>)
        %cst_10 = arith.constant -1.000000e+00 : f32
        linalg.fill ins(%cst_10 : f32) outs(%alloc_5 : memref<32xf32, 2>)
        %cst_11 = arith.constant -1.000000e+00 : f32
        linalg.fill ins(%cst_11 : f32) outs(%alloc_6 : memref<32x64xf32, 2>)
        %c0_i32_12 = arith.constant 0 : i32
        %3 = arith.index_cast %c0_i32_12 : i32 to index
        %c2_i32 = arith.constant 2 : i32
        %4 = arith.index_cast %c2_i32 : i32 to index
        %5 = arith.addi %3, %4 : index
        %c1_13 = arith.constant 1 : index
        scf.for %arg4 = %3 to %5 step %c1_13 {
          %c0_i32_14 = arith.constant 0 : i32
          %6 = arith.index_cast %c0_i32_14 : i32 to index
          %c0_i32_15 = arith.constant 0 : i32
          %7 = arith.index_cast %c0_i32_15 : i32 to index
          %c128 = arith.constant 128 : index
          %8 = arith.muli %7, %c128 : index
          %9 = arith.addi %6, %8 : index
          %c64_i32 = arith.constant 64 : i32
          %10 = arith.index_cast %c64_i32 : i32 to index
          %11 = arith.muli %arg4, %10 : index
          %c1_16 = arith.constant 1 : index
          %12 = arith.muli %11, %c1_16 : index
          %13 = arith.addi %9, %12 : index
          %reinterpret_cast_17 = memref.reinterpret_cast %view to offset: [%13], sizes: [32, 64], strides: [128, 1] : memref<32x128xf32, 1> to memref<32x64xf32, strided<[128, 1], offset: ?>, 1>
          "tilelang.copy"(%reinterpret_cast_17, %alloc_7) : (memref<32x64xf32, strided<[128, 1], offset: ?>, 1>, memref<32x64xf32, 2>) -> ()
          linalg.mul ins(%alloc_7, %alloc_6 : memref<32x64xf32, 2>, memref<32x64xf32, 2>) outs(%alloc_8 : memref<32x64xf32, 2>)
          %cst_18 = arith.constant 0xFF800000 : f32
          linalg.fill ins(%cst_18 : f32) outs(%alloc_9 : memref<32xf32, 2>)
          linalg.reduce ins(%alloc_8 : memref<32x64xf32, 2>) outs(%alloc_9 : memref<32xf32, 2>) dimensions = [1] 
            (%in: f32, %init: f32) {
              %14 = arith.maximumf %in, %init : f32
              linalg.yield %14 : f32
            }
          linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%alloc_4, %alloc_9 : memref<32xf32, 2>, memref<32xf32, 2>) outs(%alloc_4 : memref<32xf32, 2>) {
          ^bb0(%in: f32, %in_19: f32, %out: f32):
            %14 = arith.maximumf %in, %in_19 : f32
            linalg.yield %14 : f32
          }
        } {tilelang.loop_kind = "serial"}
        linalg.mul ins(%alloc_4, %alloc_5 : memref<32xf32, 2>, memref<32xf32, 2>) outs(%alloc_4 : memref<32xf32, 2>)
        "tilelang.copy"(%alloc_4, %view_3) : (memref<32xf32, 2>, memref<32xf32, 1>) -> ()
      } {tilelang.loop_kind = "serial"}
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<32xf32, 1>, memref<32xf32, strided<[1]>>) -> ()
    return
  }
}

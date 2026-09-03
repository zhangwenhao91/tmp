module {
  func.func @reduce_sum_kernel(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
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
      %alloc_4 = memref.alloc() : memref<1xf32, 2>
      %alloc_5 = memref.alloc() : memref<64xf32, 2>
      %alloc_6 = memref.alloc() : memref<1xf32, 2>
      %c0_i32 = arith.constant 0 : i32
      %0 = arith.index_cast %c0_i32 : i32 to index
      %c32_i32 = arith.constant 32 : i32
      %1 = arith.index_cast %c32_i32 : i32 to index
      %2 = arith.addi %0, %1 : index
      %c1 = arith.constant 1 : index
      scf.for %arg3 = %0 to %2 step %c1 {
        %reinterpret_cast_7 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        %cst = arith.constant 0.000000e+00 : f32
        linalg.fill ins(%cst : f32) outs(%reinterpret_cast_7 : memref<f32, strided<[]>, 2>)
        %c0_i32_8 = arith.constant 0 : i32
        %3 = arith.index_cast %c0_i32_8 : i32 to index
        %c2_i32 = arith.constant 2 : i32
        %4 = arith.index_cast %c2_i32 : i32 to index
        %5 = arith.addi %3, %4 : index
        %c1_9 = arith.constant 1 : index
        scf.for %arg4 = %3 to %5 step %c1_9 {
          %c0_i32_14 = arith.constant 0 : i32
          %9 = arith.index_cast %c0_i32_14 : i32 to index
          %c128 = arith.constant 128 : index
          %10 = arith.muli %arg3, %c128 : index
          %11 = arith.addi %9, %10 : index
          %c64_i32 = arith.constant 64 : i32
          %12 = arith.index_cast %c64_i32 : i32 to index
          %13 = arith.muli %arg4, %12 : index
          %c1_15 = arith.constant 1 : index
          %14 = arith.muli %13, %c1_15 : index
          %15 = arith.addi %11, %14 : index
          %reinterpret_cast_16 = memref.reinterpret_cast %view to offset: [%15], sizes: [64], strides: [1] : memref<32x128xf32, 1> to memref<64xf32, strided<[1], offset: ?>, 1>
          "tilelang.copy"(%reinterpret_cast_16, %alloc_5) : (memref<64xf32, strided<[1], offset: ?>, 1>, memref<64xf32, 2>) -> ()
          %reinterpret_cast_17 = memref.reinterpret_cast %alloc_6 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %cst_18 = arith.constant 0.000000e+00 : f32
          linalg.fill ins(%cst_18 : f32) outs(%reinterpret_cast_17 : memref<f32, strided<[]>, 2>)
          linalg.reduce ins(%alloc_5 : memref<64xf32, 2>) outs(%reinterpret_cast_17 : memref<f32, strided<[]>, 2>) dimensions = [0] 
            (%in: f32, %init: f32) {
              %16 = arith.addf %in, %init : f32
              linalg.yield %16 : f32
            }
          %reinterpret_cast_19 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_20 = memref.reinterpret_cast %alloc_6 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_21 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          linalg.add ins(%reinterpret_cast_19, %reinterpret_cast_20 : memref<f32, strided<[]>, 2>, memref<f32, strided<[]>, 2>) outs(%reinterpret_cast_21 : memref<f32, strided<[]>, 2>)
        } {tilelang.loop_kind = "serial"}
        %reinterpret_cast_10 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        %c0_i32_11 = arith.constant 0 : i32
        %6 = arith.index_cast %c0_i32_11 : i32 to index
        %c1_12 = arith.constant 1 : index
        %7 = arith.muli %arg3, %c1_12 : index
        %8 = arith.addi %6, %7 : index
        %reinterpret_cast_13 = memref.reinterpret_cast %view_3 to offset: [%8], sizes: [], strides: [] : memref<32xf32, 1> to memref<f32, strided<[], offset: ?>, 1>
        "tilelang.copy"(%reinterpret_cast_10, %reinterpret_cast_13) : (memref<f32, strided<[]>, 2>, memref<f32, strided<[], offset: ?>, 1>) -> ()
      } {tilelang.loop_kind = "serial"}
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<32xf32, 1>, memref<32xf32, strided<[1]>>) -> ()
    return
  }
}

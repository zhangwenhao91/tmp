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
      %alloc_5 = memref.alloc() : memref<1xf32, 2>
      %c0_i32 = arith.constant 0 : i32
      %0 = arith.index_cast %c0_i32 : i32 to index
      %c32_i32 = arith.constant 32 : i32
      %1 = arith.index_cast %c32_i32 : i32 to index
      %2 = arith.addi %0, %1 : index
      %c1 = arith.constant 1 : index
      scf.for %arg3 = %0 to %2 step %c1 {
        %c0_i32_6 = arith.constant 0 : i32
        %3 = arith.index_cast %c0_i32_6 : i32 to index
        %c128 = arith.constant 128 : index
        %4 = arith.muli %arg3, %c128 : index
        %5 = arith.addi %3, %4 : index
        %c0_i32_7 = arith.constant 0 : i32
        %6 = arith.index_cast %c0_i32_7 : i32 to index
        %c1_8 = arith.constant 1 : index
        %7 = arith.muli %6, %c1_8 : index
        %8 = arith.addi %5, %7 : index
        %reinterpret_cast_9 = memref.reinterpret_cast %view to offset: [%8], sizes: [], strides: [] : memref<32x128xf32, 1> to memref<f32, strided<[], offset: ?>, 1>
        %reinterpret_cast_10 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        "tilelang.copy"(%reinterpret_cast_9, %reinterpret_cast_10) : (memref<f32, strided<[], offset: ?>, 1>, memref<f32, strided<[]>, 2>) -> ()
        %c1_i32 = arith.constant 1 : i32
        %9 = arith.index_cast %c1_i32 : i32 to index
        %c127_i32 = arith.constant 127 : i32
        %10 = arith.index_cast %c127_i32 : i32 to index
        %11 = arith.addi %9, %10 : index
        %c1_11 = arith.constant 1 : index
        scf.for %arg4 = %9 to %11 step %c1_11 {
          %15 = arith.index_cast %c0_i32_6 : i32 to index
          %c128_16 = arith.constant 128 : index
          %16 = arith.muli %arg3, %c128_16 : index
          %17 = arith.addi %15, %16 : index
          %c1_17 = arith.constant 1 : index
          %18 = arith.muli %arg4, %c1_17 : index
          %19 = arith.addi %17, %18 : index
          %reinterpret_cast_18 = memref.reinterpret_cast %view to offset: [%19], sizes: [], strides: [] : memref<32x128xf32, 1> to memref<f32, strided<[], offset: ?>, 1>
          %reinterpret_cast_19 = memref.reinterpret_cast %alloc_5 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          "tilelang.copy"(%reinterpret_cast_18, %reinterpret_cast_19) : (memref<f32, strided<[], offset: ?>, 1>, memref<f32, strided<[]>, 2>) -> ()
          %reinterpret_cast_20 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_21 = memref.reinterpret_cast %alloc_5 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_22 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          linalg.add ins(%reinterpret_cast_20, %reinterpret_cast_21 : memref<f32, strided<[]>, 2>, memref<f32, strided<[]>, 2>) outs(%reinterpret_cast_22 : memref<f32, strided<[]>, 2>)
        } {tilelang.loop_kind = "serial"}
        %reinterpret_cast_12 = memref.reinterpret_cast %alloc_4 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        %c0_i32_13 = arith.constant 0 : i32
        %12 = arith.index_cast %c0_i32_13 : i32 to index
        %c1_14 = arith.constant 1 : index
        %13 = arith.muli %arg3, %c1_14 : index
        %14 = arith.addi %12, %13 : index
        %reinterpret_cast_15 = memref.reinterpret_cast %view_3 to offset: [%14], sizes: [], strides: [] : memref<32xf32, 1> to memref<f32, strided<[], offset: ?>, 1>
        "tilelang.copy"(%reinterpret_cast_12, %reinterpret_cast_15) : (memref<f32, strided<[]>, 2>, memref<f32, strided<[], offset: ?>, 1>) -> ()
      } {tilelang.loop_kind = "serial"}
    }) {mode = #tilelang.scope_mode<simd>} : () -> ()
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<32xf32, 1>, memref<32xf32, strided<[1]>>) -> ()
    return
  }
}

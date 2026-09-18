module {
  func.func @l1_scalar_kernel(%arg0: memref<?xbf16>, %arg1: memref<?xbf16>, %arg2: memref<?xbf16>, %arg3: memref<?xf32>, %arg4: memref<?xf32>, %arg5: i32) attributes {BlockIdx = 5 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 256], strides: [256, 1] : memref<?xbf16> to memref<16x256xbf16, strided<[256, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16> to memref<256x16xbf16, strided<[16, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xbf16> to memref<256x16xbf16, strided<[16, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32> to memref<16x16xf32, strided<[16, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32> to memref<16x16xf32, strided<[16, 1]>>
    %alloc = memref.alloc() : memref<8192xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<8192xi8, 1> to memref<16x256xbf16, 1>
    %alloc_4 = memref.alloc() : memref<8192xi8, 1>
    %c0_5 = arith.constant 0 : index
    %view_6 = memref.view %alloc_4[%c0_5][] : memref<8192xi8, 1> to memref<16x256xbf16, 1>
    %alloc_7 = memref.alloc() : memref<8192xi8, 1>
    %c0_8 = arith.constant 0 : index
    %view_9 = memref.view %alloc_7[%c0_8][] : memref<8192xi8, 1> to memref<256x16xbf16, 1>
    %alloc_10 = memref.alloc() : memref<8192xi8, 1>
    %c0_11 = arith.constant 0 : index
    %view_12 = memref.view %alloc_10[%c0_11][] : memref<8192xi8, 1> to memref<256x16xbf16, 1>
    %alloc_13 = memref.alloc() : memref<16x16xf32, 2>
    %alloc_14 = memref.alloc() : memref<16x16xf32, 2>
    %alloc_15 = memref.alloc() : memref<1024xi8, 1>
    %c0_16 = arith.constant 0 : index
    %view_17 = memref.view %alloc_15[%c0_16][] : memref<1024xi8, 1> to memref<16x16xf32, 1>
    %alloc_18 = memref.alloc() : memref<1024xi8, 1>
    %c0_19 = arith.constant 0 : index
    %view_20 = memref.view %alloc_18[%c0_19][] : memref<1024xi8, 1> to memref<16x16xf32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x256xbf16, strided<[256, 1]>>, memref<16x256xbf16, 1>) -> ()
    "tilelang.copy"(%reinterpret_cast_0, %view_9) : (memref<256x16xbf16, strided<[16, 1]>>, memref<256x16xbf16, 1>) -> ()
    "tilelang.copy"(%reinterpret_cast_1, %view_12) : (memref<256x16xbf16, strided<[16, 1]>>, memref<256x16xbf16, 1>) -> ()
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c2_i32 = arith.constant 2 : i32
    %1 = arith.index_cast %c2_i32 : i32 to index
    %2 = arith.addi %0, %1 : index
    %c1 = arith.constant 1 : index
    scf.for %arg6 = %0 to %2 step %c1 {
      %c0_i32_21 = arith.constant 0 : i32
      %3 = arith.index_cast %c0_i32_21 : i32 to index
      %c16_i32 = arith.constant 16 : i32
      %4 = arith.index_cast %c16_i32 : i32 to index
      %5 = arith.addi %3, %4 : index
      %c1_22 = arith.constant 1 : index
      scf.for %arg7 = %3 to %5 step %c1_22 {
        %c0_i32_26 = arith.constant 0 : i32
        %9 = arith.index_cast %c0_i32_26 : i32 to index
        %c256_i32 = arith.constant 256 : i32
        %10 = arith.index_cast %c256_i32 : i32 to index
        %11 = arith.addi %9, %10 : index
        %c1_27 = arith.constant 1 : index
        scf.for %arg8 = %9 to %11 step %c1_27 {
          %12 = memref.load %view[%arg7, %arg8] : memref<16x256xbf16, 1>
          memref.store %12, %view_6[%arg7, %arg8] : memref<16x256xbf16, 1>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
      "tilelang.gemm"(%view_6, %view_9, %alloc_13) {clear_accum} : (memref<16x256xbf16, 1>, memref<256x16xbf16, 1>, memref<16x16xf32, 2>) -> ()
      %c0_i32_23 = arith.constant 0 : i32
      %6 = arith.index_cast %c0_i32_23 : i32 to index
      %c16_i32_24 = arith.constant 16 : i32
      %7 = arith.index_cast %c16_i32_24 : i32 to index
      %8 = arith.addi %6, %7 : index
      %c1_25 = arith.constant 1 : index
      scf.for %arg7 = %6 to %8 step %c1_25 {
        %c0_i32_26 = arith.constant 0 : i32
        %9 = arith.index_cast %c0_i32_26 : i32 to index
        %c256_i32 = arith.constant 256 : i32
        %10 = arith.index_cast %c256_i32 : i32 to index
        %11 = arith.addi %9, %10 : index
        %c1_27 = arith.constant 1 : index
        scf.for %arg8 = %9 to %11 step %c1_27 {
          %12 = memref.load %view_6[%arg7, %arg8] : memref<16x256xbf16, 1>
          memref.store %12, %view[%arg7, %arg8] : memref<16x256xbf16, 1>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
      "tilelang.gemm"(%view, %view_12, %alloc_14) {clear_accum} : (memref<16x256xbf16, 1>, memref<256x16xbf16, 1>, memref<16x16xf32, 2>) -> ()
    } {tilelang.loop_kind = "serial"}
    "tilelang.copy"(%alloc_13, %view_17) : (memref<16x16xf32, 2>, memref<16x16xf32, 1>) -> ()
    "tilelang.copy"(%view_17, %reinterpret_cast_2) : (memref<16x16xf32, 1>, memref<16x16xf32, strided<[16, 1]>>) -> ()
    "tilelang.copy"(%alloc_14, %view_20) : (memref<16x16xf32, 2>, memref<16x16xf32, 1>) -> ()
    "tilelang.copy"(%view_20, %reinterpret_cast_3) : (memref<16x16xf32, 1>, memref<16x16xf32, strided<[16, 1]>>) -> ()
    return
  }
}

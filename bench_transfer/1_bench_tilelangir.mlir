module {
  func.func @l1ub_kernel(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: memref<?xf32>, %arg4: memref<?xf32>, %arg5: i32) attributes {BlockIdx = 5 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xf32> to memref<64x256xf32, strided<[256, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32> to memref<256x16xf32, strided<[16, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32> to memref<256x16xf32, strided<[16, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32> to memref<64x16xf32, strided<[16, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [64, 16], strides: [16, 1] : memref<?xf32> to memref<64x16xf32, strided<[16, 1]>>
    %alloc = memref.alloc() : memref<65536xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<65536xi8, 1> to memref<64x256xf32, 1>
    %alloc_4 = memref.alloc() : memref<65536xi8, 1>
    %c0_5 = arith.constant 0 : index
    %view_6 = memref.view %alloc_4[%c0_5][] : memref<65536xi8, 1> to memref<64x256xf32, 1>
    %alloc_7 = memref.alloc() : memref<65536xi8, 1>
    %c0_8 = arith.constant 0 : index
    %view_9 = memref.view %alloc_7[%c0_8][] : memref<65536xi8, 1> to memref<64x256xf32, 1>
    %alloc_10 = memref.alloc() : memref<16384xi8, 1>
    %c0_11 = arith.constant 0 : index
    %view_12 = memref.view %alloc_10[%c0_11][] : memref<16384xi8, 1> to memref<256x16xf32, 1>
    %alloc_13 = memref.alloc() : memref<16384xi8, 1>
    %c0_14 = arith.constant 0 : index
    %view_15 = memref.view %alloc_13[%c0_14][] : memref<16384xi8, 1> to memref<256x16xf32, 1>
    %alloc_16 = memref.alloc() : memref<64x16xf32, 2>
    %alloc_17 = memref.alloc() : memref<64x16xf32, 2>
    %alloc_18 = memref.alloc() : memref<4096xi8, 1>
    %c0_19 = arith.constant 0 : index
    %view_20 = memref.view %alloc_18[%c0_19][] : memref<4096xi8, 1> to memref<64x16xf32, 1>
    %alloc_21 = memref.alloc() : memref<4096xi8, 1>
    %c0_22 = arith.constant 0 : index
    %view_23 = memref.view %alloc_21[%c0_22][] : memref<4096xi8, 1> to memref<64x16xf32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<64x256xf32, strided<[256, 1]>>, memref<64x256xf32, 1>) -> ()
    "tilelang.copy"(%reinterpret_cast_0, %view_12) : (memref<256x16xf32, strided<[16, 1]>>, memref<256x16xf32, 1>) -> ()
    "tilelang.copy"(%reinterpret_cast_1, %view_15) : (memref<256x16xf32, strided<[16, 1]>>, memref<256x16xf32, 1>) -> ()
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c128_i32 = arith.constant 128 : i32
    %1 = arith.index_cast %c128_i32 : i32 to index
    %2 = arith.addi %0, %1 : index
    %c1 = arith.constant 1 : index
    scf.for %arg6 = %0 to %2 step %c1 {
      "tilelang.copy"(%view, %view_9) : (memref<64x256xf32, 1>, memref<64x256xf32, 1>) -> ()
      "tilelang.copy"(%view_9, %view_6) : (memref<64x256xf32, 1>, memref<64x256xf32, 1>) -> ()
      "tilelang.gemm"(%view_6, %view_12, %alloc_16) {clear_accum} : (memref<64x256xf32, 1>, memref<256x16xf32, 1>, memref<64x16xf32, 2>) -> ()
      "tilelang.copy"(%view_6, %view_9) : (memref<64x256xf32, 1>, memref<64x256xf32, 1>) -> ()
      "tilelang.copy"(%view_9, %view) : (memref<64x256xf32, 1>, memref<64x256xf32, 1>) -> ()
      "tilelang.gemm"(%view, %view_15, %alloc_17) {clear_accum} : (memref<64x256xf32, 1>, memref<256x16xf32, 1>, memref<64x16xf32, 2>) -> ()
    } {tilelang.loop_kind = "serial"}
    "tilelang.copy"(%alloc_16, %view_20) : (memref<64x16xf32, 2>, memref<64x16xf32, 1>) -> ()
    "tilelang.copy"(%view_20, %reinterpret_cast_2) : (memref<64x16xf32, 1>, memref<64x16xf32, strided<[16, 1]>>) -> ()
    "tilelang.copy"(%alloc_17, %view_23) : (memref<64x16xf32, 2>, memref<64x16xf32, 1>) -> ()
    "tilelang.copy"(%view_23, %reinterpret_cast_3) : (memref<64x16xf32, 1>, memref<64x16xf32, strided<[16, 1]>>) -> ()
    return
  }
}

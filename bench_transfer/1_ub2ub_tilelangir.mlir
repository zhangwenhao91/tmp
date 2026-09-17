module {
  func.func @ub2ub_kernel(%arg0: memref<?xbf16>, %arg1: memref<?xbf16>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16> to memref<64x256xbf16, strided<[256, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [64, 256], strides: [256, 1] : memref<?xbf16> to memref<64x256xbf16, strided<[256, 1]>>
    %alloc = memref.alloc() : memref<32768xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<32768xi8, 1> to memref<64x256xbf16, 1>
    %alloc_1 = memref.alloc() : memref<32768xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<32768xi8, 1> to memref<64x256xbf16, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<64x256xbf16, strided<[256, 1]>>, memref<64x256xbf16, 1>) -> ()
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c64_i32 = arith.constant 64 : i32
    %1 = arith.index_cast %c64_i32 : i32 to index
    %2 = arith.addi %0, %1 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %0 to %2 step %c1 {
      "tilelang.copy"(%view, %view_3) : (memref<64x256xbf16, 1>, memref<64x256xbf16, 1>) -> ()
    } {tilelang.loop_kind = "serial"}
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<64x256xbf16, 1>, memref<64x256xbf16, strided<[256, 1]>>) -> ()
    return
  }
}

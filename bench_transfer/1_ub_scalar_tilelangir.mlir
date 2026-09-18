module {
  func.func @ub_scalar_kernel(%arg0: memref<?xbf16>, %arg1: memref<?xbf16>, %arg2: i32) attributes {BlockIdx = 2 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 256], strides: [256, 1] : memref<?xbf16> to memref<16x256xbf16, strided<[256, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16, 256], strides: [256, 1] : memref<?xbf16> to memref<16x256xbf16, strided<[256, 1]>>
    %alloc = memref.alloc() : memref<8192xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<8192xi8, 1> to memref<16x256xbf16, 1>
    %alloc_1 = memref.alloc() : memref<8192xi8, 1>
    %c0_2 = arith.constant 0 : index
    %view_3 = memref.view %alloc_1[%c0_2][] : memref<8192xi8, 1> to memref<16x256xbf16, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x256xbf16, strided<[256, 1]>>, memref<16x256xbf16, 1>) -> ()
    %c0_i32 = arith.constant 0 : i32
    %0 = arith.index_cast %c0_i32 : i32 to index
    %c2_i32 = arith.constant 2 : i32
    %1 = arith.index_cast %c2_i32 : i32 to index
    %2 = arith.addi %0, %1 : index
    %c1 = arith.constant 1 : index
    scf.for %arg3 = %0 to %2 step %c1 {
      %c0_i32_4 = arith.constant 0 : i32
      %3 = arith.index_cast %c0_i32_4 : i32 to index
      %c16_i32 = arith.constant 16 : i32
      %4 = arith.index_cast %c16_i32 : i32 to index
      %5 = arith.addi %3, %4 : index
      %c1_5 = arith.constant 1 : index
      scf.for %arg4 = %3 to %5 step %c1_5 {
        %c0_i32_6 = arith.constant 0 : i32
        %6 = arith.index_cast %c0_i32_6 : i32 to index
        %c256_i32 = arith.constant 256 : i32
        %7 = arith.index_cast %c256_i32 : i32 to index
        %8 = arith.addi %6, %7 : index
        %c1_7 = arith.constant 1 : index
        scf.for %arg5 = %6 to %8 step %c1_7 {
          %9 = memref.load %view[%arg4, %arg5] : memref<16x256xbf16, 1>
          memref.store %9, %view_3[%arg4, %arg5] : memref<16x256xbf16, 1>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
    } {tilelang.loop_kind = "serial"}
    "tilelang.copy"(%view_3, %reinterpret_cast_0) : (memref<16x256xbf16, 1>, memref<16x256xbf16, strided<[256, 1]>>) -> ()
    return
  }
}

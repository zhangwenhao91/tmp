module {
  func.func @gemm_kernel(%arg0: memref<?xbf16>, %arg1: memref<?xbf16>, %arg2: memref<?xf32>, %arg3: i32) attributes {BlockIdx = 3 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xbf16> to memref<16x128xbf16, strided<[128, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xbf16> to memref<128x128xbf16, strided<[128, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32> to memref<16x128xf32, strided<[128, 1]>>
    %alloc = memref.alloc() : memref<4096xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<4096xi8, 1> to memref<16x128xbf16, 1>
    %alloc_2 = memref.alloc() : memref<32768xi8, 1>
    %c0_3 = arith.constant 0 : index
    %view_4 = memref.view %alloc_2[%c0_3][] : memref<32768xi8, 1> to memref<128x128xbf16, 1>
    %alloc_5 = memref.alloc() : memref<16x128xf32, 2>
    %alloc_6 = memref.alloc() : memref<8192xi8, 1>
    %c0_7 = arith.constant 0 : index
    %view_8 = memref.view %alloc_6[%c0_7][] : memref<8192xi8, 1> to memref<16x128xf32, 1>
    "tilelang.copy"(%reinterpret_cast, %view) : (memref<16x128xbf16, strided<[128, 1]>>, memref<16x128xbf16, 1>) -> ()
    "tilelang.copy"(%reinterpret_cast_0, %view_4) : (memref<128x128xbf16, strided<[128, 1]>>, memref<128x128xbf16, 1>) -> ()
    "tilelang.gemm"(%view, %view_4, %alloc_5) {clear_accum} : (memref<16x128xbf16, 1>, memref<128x128xbf16, 1>, memref<16x128xf32, 2>) -> ()
    "tilelang.copy"(%alloc_5, %view_8) : (memref<16x128xf32, 2>, memref<16x128xf32, 1>) -> ()
    "tilelang.copy"(%view_8, %reinterpret_cast_1) : (memref<16x128xf32, 1>, memref<16x128xf32, strided<[128, 1]>>) -> ()
    return
  }
}

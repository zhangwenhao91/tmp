module {
  func.func @print_kernel(%arg0: memref<?xf16>, %arg1: i32) attributes {BlockIdx = 1 : i64} {
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf16> to memref<16x16xf16, strided<[16, 1]>>
    %alloc = memref.alloc() : memref<512xi8, 1>
    %c0 = arith.constant 0 : index
    %view = memref.view %alloc[%c0][] : memref<512xi8, 1> to memref<16x16xf16, 1>
    "tilelang.print"(%view) {prefix = "buffer<shared_buf, float16>"} : (memref<16x16xf16, 1>) -> ()
    "tilelang.print"(%arg1) {prefix = "block id"} : (i32) -> ()
    "tilelang.print"() {prefix = "hello"} : () -> ()
    return
  }
}

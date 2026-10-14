module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @triton_min_dim1(%arg0: memref<?xf16, #npu.address_space<gm>>, %arg1: memref<?xf16, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %false = arith.constant false
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c16 = arith.constant 16 : index
    %c64 = arith.constant 64 : index
    %c64_i32 = arith.constant 64 : i32
    %c16_i32 = arith.constant 16 : i32
    %cst = arith.constant 0x7C00 : f16
    %c23200_i64 = arith.constant 23200 : i64
    %0 = npu.alloc(%c23200_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %c0_i32 : i32 -> vector<64xi32>
      npu.vstore %14, %0 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast = memref.reinterpret_cast %0 to offset: [0], sizes: [32], strides: [1] : memref<64xi32, #npu.address_space<ub>> to memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %c16_i32 : i32 -> vector<32xi32>
      npu.vstore %14, %reinterpret_cast : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    %c23456_i64 = arith.constant 23456 : i64
    %1 = npu.alloc(%c23456_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %c64_i32 : i32 -> vector<64xi32>
      npu.vstore %14, %1 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_1"} : () -> ()
    %c23712_i64 = arith.constant 23712 : i64
    %2 = npu.alloc(%c23712_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.iota : vector<64xi32>
      npu.vstore %14, %2 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_2"} : () -> ()
    %c23968_i64 = arith.constant 23968 : i64
    %3 = npu.alloc(%c23968_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %c0_i32 : i32 -> vector<64xi32>
      npu.vstore %14, %3 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_0 = memref.reinterpret_cast %3 to offset: [0], sizes: [32], strides: [1] : memref<64xi32, #npu.address_space<ub>> to memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.iota : vector<32xi32>
      npu.vstore %14, %reinterpret_cast_0 : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_3"} : () -> ()
    %c24224_i64 = arith.constant 24224 : i64
    %4 = npu.alloc(%c24224_i64) : memref<256xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %false : i1 -> vector<256xi1>
      npu.vstore %14, %4 : (vector<256xi1>, memref<256xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_1 = memref.reinterpret_cast %4 to offset: [0], sizes: [64], strides: [1] {npu.predicate_storage} : memref<256xi1, #npu.address_space<ub>> to memref<64xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %1 : (memref<64xi32, #npu.address_space<ub>>) -> vector<64xi32>
      %15 = npu.vload %2 : (memref<64xi32, #npu.address_space<ub>>) -> vector<64xi32>
      %16 = npu.cmp %15, %14 : vector<64xi32>, vector<64xi32> -> vector<64xi1> {compare_mode = #npu.compare_mode<lt>, integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %16, %reinterpret_cast_1 : (vector<64xi1>, memref<64xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_4"} : () -> ()
    %c24480_i64 = arith.constant 24480 : i64
    %5 = npu.alloc(%c24480_i64) : memref<256xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %false : i1 -> vector<256xi1>
      npu.vstore %14, %5 : (vector<256xi1>, memref<256xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_2 = memref.reinterpret_cast %5 to offset: [0], sizes: [32], strides: [1] {npu.predicate_storage} : memref<256xi1, #npu.address_space<ub>> to memref<32xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %reinterpret_cast : (memref<32xi32, #npu.address_space<ub>>) -> vector<32xi32>
      %15 = npu.vload %reinterpret_cast_0 : (memref<32xi32, #npu.address_space<ub>>) -> vector<32xi32>
      %16 = npu.cmp %15, %14 : vector<32xi32>, vector<32xi32> -> vector<32xi1> {compare_mode = #npu.compare_mode<lt>, integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %16, %reinterpret_cast_2 : (vector<32xi1>, memref<32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_5"} : () -> ()
    %c16384_i64 = arith.constant 16384 : i64
    %6 = npu.alloc(%c16384_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %14, %6 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_3 = memref.reinterpret_cast %6 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %reinterpret_cast_1 : (memref<64xi1, #npu.address_space<ub>>) -> vector<64xi1>
      %15 = npu.broadcast %14 : vector<64xi1> -> vector<64x32xi1> {broadcast_dim = 1 : i64}
      npu.vstore %15, %reinterpret_cast_3 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_6"} : () -> ()
    %c18656_i64 = arith.constant 18656 : i64
    %7 = npu.alloc(%c18656_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %14, %7 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_4 = memref.reinterpret_cast %7 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %reinterpret_cast_2 : (memref<32xi1, #npu.address_space<ub>>) -> vector<32xi1>
      %15 = npu.broadcast %14 : vector<32xi1> -> vector<64x32xi1> {broadcast_dim = 0 : i64}
      npu.vstore %15, %reinterpret_cast_4 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_7"} : () -> ()
    %c20928_i64 = arith.constant 20928 : i64
    %8 = npu.alloc(%c20928_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %14, %8 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_5 = memref.reinterpret_cast %8 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %reinterpret_cast_4 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %15 = npu.vload %reinterpret_cast_3 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %16 = npu.and %15, %14 : vector<64x32xi1>, vector<64x32xi1> -> vector<64x32xi1>
      npu.vstore %16, %reinterpret_cast_5 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_8"} : () -> ()
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c64, %c16], strides: [16, 1] : memref<?xf16, #npu.address_space<gm>> to memref<?x?xf16, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast_6 : memref<?x?xf16, strided<[16, 1], offset: ?>, #npu.address_space<gm>> to memref<64x32xf16, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %c12288_i64 = arith.constant 12288 : i64
    %9 = npu.alloc(%c12288_i64) : memref<64x32xf16, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %10 = npu.alloc(%c8192_i64) : memref<64x32xf16, #npu.address_space<ub>>
    npu.copy ins(%cast : memref<64x32xf16, strided<[16, 1], offset: ?>, #npu.address_space<gm>>) outs(%10 : memref<64x32xf16, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %14 = npu.vload %10 : (memref<64x32xf16, #npu.address_space<ub>>) -> vector<64x32xf16>
      %15 = npu.vload %reinterpret_cast_5 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %16 = npu.select %15, %14, %cst : vector<64x32xi1>, vector<64x32xf16>, f16 -> vector<64x32xf16>
      npu.vstore %16, %9 : (vector<64x32xf16>, memref<64x32xf16, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_9"} : () -> ()
    %c0_i64 = arith.constant 0 : i64
    %11 = npu.alloc(%c0_i64) : memref<64x32xf32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %9 : (memref<64x32xf16, #npu.address_space<ub>>) -> vector<64x32xf16>
      %15 = npu.cvt %14 : vector<64x32xf16> -> vector<64x32xf32> {round_mode = #npu.round_mode<rint>}
      npu.vstore %15, %11 : (vector<64x32xf32>, memref<64x32xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_10"} : () -> ()
    %c24736_i64 = arith.constant 24736 : i64
    %12 = npu.alloc(%c24736_i64) : memref<64xf32, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %11 : (memref<64x32xf32, #npu.address_space<ub>>) -> vector<64x32xf32>
      %15 = npu.reduce %14, %c1_i64 : vector<64x32xf32>, i64 -> vector<64xf32> #npu.reduce_op<min> identities=[0x7F800000 : f32]
      npu.vstore %15, %12 : (vector<64xf32>, memref<64xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_11"} : () -> ()
    %c24992_i64 = arith.constant 24992 : i64
    %13 = npu.alloc(%c24992_i64) : memref<64xf16, #npu.address_space<ub>>
    npu.scope() {
      %14 = npu.vload %12 : (memref<64xf32, #npu.address_space<ub>>) -> vector<64xf32>
      %15 = npu.cvt %14 : vector<64xf32> -> vector<64xf16> {round_mode = #npu.round_mode<rint>}
      npu.vstore %15, %13 : (vector<64xf16>, memref<64xf16, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_12"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_7 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [64], strides: [1] : memref<?xf16, #npu.address_space<gm>> to memref<64xf16, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%13 : memref<64xf16, #npu.address_space<ub>>) outs(%reinterpret_cast_7 : memref<64xf16, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


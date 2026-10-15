module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @otr_max_d0_i8(%arg0: memref<?xi8, #npu.address_space<gm>>, %arg1: memref<?xi8, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %false = arith.constant false
    %c0_i32 = arith.constant 0 : i32
    %c0_i64 = arith.constant 0 : i64
    %c0 = arith.constant 0 : index
    %c16 = arith.constant 16 : index
    %c64 = arith.constant 64 : index
    %c64_i32 = arith.constant 64 : i32
    %c16_i32 = arith.constant 16 : i32
    %c-128_i8 = arith.constant -128 : i8
    %c10912_i64 = arith.constant 10912 : i64
    %0 = npu.alloc(%c10912_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c0_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %0 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast = memref.reinterpret_cast %0 to offset: [0], sizes: [32], strides: [1] : memref<64xi32, #npu.address_space<ub>> to memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c16_i32 : i32 -> vector<32xi32>
      npu.vstore %12, %reinterpret_cast : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    %c11168_i64 = arith.constant 11168 : i64
    %1 = npu.alloc(%c11168_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c64_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %1 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_1"} : () -> ()
    %c11424_i64 = arith.constant 11424 : i64
    %2 = npu.alloc(%c11424_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.iota : vector<64xi32>
      npu.vstore %12, %2 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_2"} : () -> ()
    %c11680_i64 = arith.constant 11680 : i64
    %3 = npu.alloc(%c11680_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c0_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %3 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_0 = memref.reinterpret_cast %3 to offset: [0], sizes: [32], strides: [1] : memref<64xi32, #npu.address_space<ub>> to memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.iota : vector<32xi32>
      npu.vstore %12, %reinterpret_cast_0 : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_3"} : () -> ()
    %c11936_i64 = arith.constant 11936 : i64
    %4 = npu.alloc(%c11936_i64) : memref<256xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<256xi1>
      npu.vstore %12, %4 : (vector<256xi1>, memref<256xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_1 = memref.reinterpret_cast %4 to offset: [0], sizes: [64], strides: [1] {npu.predicate_storage} : memref<256xi1, #npu.address_space<ub>> to memref<64xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %1 : (memref<64xi32, #npu.address_space<ub>>) -> vector<64xi32>
      %13 = npu.vload %2 : (memref<64xi32, #npu.address_space<ub>>) -> vector<64xi32>
      %14 = npu.cmp %13, %12 : vector<64xi32>, vector<64xi32> -> vector<64xi1> {compare_mode = #npu.compare_mode<lt>, integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %14, %reinterpret_cast_1 : (vector<64xi1>, memref<64xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_4"} : () -> ()
    %c12192_i64 = arith.constant 12192 : i64
    %5 = npu.alloc(%c12192_i64) : memref<256xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<256xi1>
      npu.vstore %12, %5 : (vector<256xi1>, memref<256xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_2 = memref.reinterpret_cast %5 to offset: [0], sizes: [32], strides: [1] {npu.predicate_storage} : memref<256xi1, #npu.address_space<ub>> to memref<32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast : (memref<32xi32, #npu.address_space<ub>>) -> vector<32xi32>
      %13 = npu.vload %reinterpret_cast_0 : (memref<32xi32, #npu.address_space<ub>>) -> vector<32xi32>
      %14 = npu.cmp %13, %12 : vector<32xi32>, vector<32xi32> -> vector<32xi1> {compare_mode = #npu.compare_mode<lt>, integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %14, %reinterpret_cast_2 : (vector<32xi1>, memref<32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_5"} : () -> ()
    %c0_i64_3 = arith.constant 0 : i64
    %6 = npu.alloc(%c0_i64_3) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %12, %6 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_4 = memref.reinterpret_cast %6 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_1 : (memref<64xi1, #npu.address_space<ub>>) -> vector<64xi1>
      %13 = npu.broadcast %12 : vector<64xi1> -> vector<64x32xi1> {broadcast_dim = 1 : i64}
      npu.vstore %13, %reinterpret_cast_4 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_6"} : () -> ()
    %c2272_i64 = arith.constant 2272 : i64
    %7 = npu.alloc(%c2272_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %12, %7 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_5 = memref.reinterpret_cast %7 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_2 : (memref<32xi1, #npu.address_space<ub>>) -> vector<32xi1>
      %13 = npu.broadcast %12 : vector<32xi1> -> vector<64x32xi1> {broadcast_dim = 0 : i64}
      npu.vstore %13, %reinterpret_cast_5 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_7"} : () -> ()
    %c4544_i64 = arith.constant 4544 : i64
    %8 = npu.alloc(%c4544_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %12, %8 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_6 = memref.reinterpret_cast %8 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_5 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %13 = npu.vload %reinterpret_cast_4 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %14 = npu.and %13, %12 : vector<64x32xi1>, vector<64x32xi1> -> vector<64x32xi1>
      npu.vstore %14, %reinterpret_cast_6 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_8"} : () -> ()
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c64, %c16], strides: [16, 1] : memref<?xi8, #npu.address_space<gm>> to memref<?x?xi8, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast_7 : memref<?x?xi8, strided<[16, 1], offset: ?>, #npu.address_space<gm>> to memref<64x32xi8, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %c8864_i64 = arith.constant 8864 : i64
    %9 = npu.alloc(%c8864_i64) : memref<64x32xi8, #npu.address_space<ub>>
    %c6816_i64 = arith.constant 6816 : i64
    %10 = npu.alloc(%c6816_i64) : memref<64x32xi8, #npu.address_space<ub>>
    npu.copy ins(%cast : memref<64x32xi8, strided<[16, 1], offset: ?>, #npu.address_space<gm>>) outs(%10 : memref<64x32xi8, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %12 = npu.vload %10 : (memref<64x32xi8, #npu.address_space<ub>>) -> vector<64x32xi8>
      %13 = npu.vload %reinterpret_cast_6 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %14 = npu.select %13, %12, %c-128_i8 : vector<64x32xi1>, vector<64x32xi8>, i8 -> vector<64x32xi8>
      npu.vstore %14, %9 : (vector<64x32xi8>, memref<64x32xi8, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_9"} : () -> ()
    %c12448_i64 = arith.constant 12448 : i64
    %11 = npu.alloc(%c12448_i64) : memref<32xi8, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %9 : (memref<64x32xi8, #npu.address_space<ub>>) -> vector<64x32xi8>
      %13 = npu.reduce %12, %c0_i64 : vector<64x32xi8>, i64 -> vector<32xi8> #npu.reduce_op<max> identities=[-128 : i8] {integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %13, %11 : (vector<32xi8>, memref<32xi8, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_10"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_8 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [%c16], strides: [1] : memref<?xi8, #npu.address_space<gm>> to memref<?xi8, strided<[1], offset: ?>, #npu.address_space<gm>>
    %cast_9 = memref.cast %reinterpret_cast_8 : memref<?xi8, strided<[1], offset: ?>, #npu.address_space<gm>> to memref<32xi8, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%11 : memref<32xi8, #npu.address_space<ub>>) outs(%cast_9 : memref<32xi8, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


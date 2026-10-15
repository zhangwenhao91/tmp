module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @otg_max_d1_i64(%arg0: memref<?xi64, #npu.address_space<gm>>, %arg1: memref<?xi64, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %false = arith.constant false
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c16 = arith.constant 16 : index
    %c64 = arith.constant 64 : index
    %c64_i32 = arith.constant 64 : i32
    %c16_i32 = arith.constant 16 : i32
    %c-9223372036854775808_i64 = arith.constant -9223372036854775808 : i64
    %c40096_i64 = arith.constant 40096 : i64
    %0 = npu.alloc(%c40096_i64) : memref<64xi32, #npu.address_space<ub>>
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
    %c40352_i64 = arith.constant 40352 : i64
    %1 = npu.alloc(%c40352_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c64_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %1 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_1"} : () -> ()
    %c40608_i64 = arith.constant 40608 : i64
    %2 = npu.alloc(%c40608_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.iota : vector<64xi32>
      npu.vstore %12, %2 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_2"} : () -> ()
    %c40864_i64 = arith.constant 40864 : i64
    %3 = npu.alloc(%c40864_i64) : memref<64xi32, #npu.address_space<ub>>
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
    %c41120_i64 = arith.constant 41120 : i64
    %4 = npu.alloc(%c41120_i64) : memref<256xi1, #npu.address_space<ub>>
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
    %c41376_i64 = arith.constant 41376 : i64
    %5 = npu.alloc(%c41376_i64) : memref<256xi1, #npu.address_space<ub>>
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
    %c32768_i64 = arith.constant 32768 : i64
    %6 = npu.alloc(%c32768_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %12, %6 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_3 = memref.reinterpret_cast %6 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_1 : (memref<64xi1, #npu.address_space<ub>>) -> vector<64xi1>
      %13 = npu.broadcast %12 : vector<64xi1> -> vector<64x32xi1> {broadcast_dim = 1 : i64}
      npu.vstore %13, %reinterpret_cast_3 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_6"} : () -> ()
    %c35040_i64 = arith.constant 35040 : i64
    %7 = npu.alloc(%c35040_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %12, %7 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_4 = memref.reinterpret_cast %7 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_2 : (memref<32xi1, #npu.address_space<ub>>) -> vector<32xi1>
      %13 = npu.broadcast %12 : vector<32xi1> -> vector<64x32xi1> {broadcast_dim = 0 : i64}
      npu.vstore %13, %reinterpret_cast_4 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_7"} : () -> ()
    %c37312_i64 = arith.constant 37312 : i64
    %8 = npu.alloc(%c37312_i64) : memref<2272xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2272xi1>
      npu.vstore %12, %8 : (vector<2272xi1>, memref<2272xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_5 = memref.reinterpret_cast %8 to offset: [0], sizes: [64, 32], strides: [32, 1] {npu.predicate_storage} : memref<2272xi1, #npu.address_space<ub>> to memref<64x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_4 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %13 = npu.vload %reinterpret_cast_3 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %14 = npu.and %13, %12 : vector<64x32xi1>, vector<64x32xi1> -> vector<64x32xi1>
      npu.vstore %14, %reinterpret_cast_5 : (vector<64x32xi1>, memref<64x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_8"} : () -> ()
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c64, %c16], strides: [16, 1] : memref<?xi64, #npu.address_space<gm>> to memref<?x?xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast_6 : memref<?x?xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>> to memref<64x32xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>>
    %c16384_i64 = arith.constant 16384 : i64
    %9 = npu.alloc(%c16384_i64) : memref<64x32xi64, #npu.address_space<ub>>
    %c0_i64 = arith.constant 0 : i64
    %10 = npu.alloc(%c0_i64) : memref<64x32xi64, #npu.address_space<ub>>
    npu.copy ins(%cast : memref<64x32xi64, strided<[16, 1], offset: ?>, #npu.address_space<gm>>) outs(%10 : memref<64x32xi64, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %12 = npu.vload %10 : (memref<64x32xi64, #npu.address_space<ub>>) -> vector<64x32xi64>
      %13 = npu.vload %reinterpret_cast_5 : (memref<64x32xi1, #npu.address_space<ub>>) -> vector<64x32xi1>
      %14 = npu.select %13, %12, %c-9223372036854775808_i64 : vector<64x32xi1>, vector<64x32xi64>, i64 -> vector<64x32xi64>
      npu.vstore %14, %9 : (vector<64x32xi64>, memref<64x32xi64, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_9"} : () -> ()
    %c39584_i64 = arith.constant 39584 : i64
    %11 = npu.alloc(%c39584_i64) : memref<64xi64, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %9 : (memref<64x32xi64, #npu.address_space<ub>>) -> vector<64x32xi64>
      %13 = npu.reduce %12, %c1_i64 : vector<64x32xi64>, i64 -> vector<64xi64> #npu.reduce_op<max> identities=[-9223372036854775808 : i64] {integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %13, %11 : (vector<64xi64>, memref<64xi64, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_10"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_7 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [64], strides: [1] : memref<?xi64, #npu.address_space<gm>> to memref<64xi64, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%11 : memref<64xi64, #npu.address_space<ub>>) outs(%reinterpret_cast_7 : memref<64xi64, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @otr_min_d1_i32_s3(%arg0: memref<?xi32, #npu.address_space<gm>>, %arg1: memref<?xi32, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %false = arith.constant false
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c48 = arith.constant 48 : index
    %c32 = arith.constant 32 : index
    %c32_i32 = arith.constant 32 : i32
    %c48_i32 = arith.constant 48 : i32
    %c2147483647_i32 = arith.constant 2147483647 : i32
    %c23104_i64 = arith.constant 23104 : i64
    %0 = npu.alloc(%c23104_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c48_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %0 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    %c23360_i64 = arith.constant 23360 : i64
    %1 = npu.alloc(%c23360_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c0_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %1 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast = memref.reinterpret_cast %1 to offset: [0], sizes: [32], strides: [1] : memref<64xi32, #npu.address_space<ub>> to memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c32_i32 : i32 -> vector<32xi32>
      npu.vstore %12, %reinterpret_cast : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_1"} : () -> ()
    %c23616_i64 = arith.constant 23616 : i64
    %2 = npu.alloc(%c23616_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c0_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %2 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_0 = memref.reinterpret_cast %2 to offset: [0], sizes: [32], strides: [1] : memref<64xi32, #npu.address_space<ub>> to memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.iota : vector<32xi32>
      npu.vstore %12, %reinterpret_cast_0 : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_2"} : () -> ()
    %c23872_i64 = arith.constant 23872 : i64
    %3 = npu.alloc(%c23872_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.iota : vector<64xi32>
      npu.vstore %12, %3 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_3"} : () -> ()
    %c24128_i64 = arith.constant 24128 : i64
    %4 = npu.alloc(%c24128_i64) : memref<256xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<256xi1>
      npu.vstore %12, %4 : (vector<256xi1>, memref<256xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_1 = memref.reinterpret_cast %4 to offset: [0], sizes: [32], strides: [1] {npu.predicate_storage} : memref<256xi1, #npu.address_space<ub>> to memref<32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast : (memref<32xi32, #npu.address_space<ub>>) -> vector<32xi32>
      %13 = npu.vload %reinterpret_cast_0 : (memref<32xi32, #npu.address_space<ub>>) -> vector<32xi32>
      %14 = npu.cmp %13, %12 : vector<32xi32>, vector<32xi32> -> vector<32xi1> {compare_mode = #npu.compare_mode<lt>, integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %14, %reinterpret_cast_1 : (vector<32xi1>, memref<32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_4"} : () -> ()
    %c24384_i64 = arith.constant 24384 : i64
    %5 = npu.alloc(%c24384_i64) : memref<256xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<256xi1>
      npu.vstore %12, %5 : (vector<256xi1>, memref<256xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_2 = memref.reinterpret_cast %5 to offset: [0], sizes: [64], strides: [1] {npu.predicate_storage} : memref<256xi1, #npu.address_space<ub>> to memref<64xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %0 : (memref<64xi32, #npu.address_space<ub>>) -> vector<64xi32>
      %13 = npu.vload %3 : (memref<64xi32, #npu.address_space<ub>>) -> vector<64xi32>
      %14 = npu.cmp %13, %12 : vector<64xi32>, vector<64xi32> -> vector<64xi1> {compare_mode = #npu.compare_mode<lt>, integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %14, %reinterpret_cast_2 : (vector<64xi1>, memref<64xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_5"} : () -> ()
    %c16384_i64 = arith.constant 16384 : i64
    %6 = npu.alloc(%c16384_i64) : memref<2240xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2240xi1>
      npu.vstore %12, %6 : (vector<2240xi1>, memref<2240xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_3 = memref.reinterpret_cast %6 to offset: [0], sizes: [32, 64], strides: [64, 1] {npu.predicate_storage} : memref<2240xi1, #npu.address_space<ub>> to memref<32x64xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_1 : (memref<32xi1, #npu.address_space<ub>>) -> vector<32xi1>
      %13 = npu.broadcast %12 : vector<32xi1> -> vector<32x64xi1> {broadcast_dim = 1 : i64}
      npu.vstore %13, %reinterpret_cast_3 : (vector<32x64xi1>, memref<32x64xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_6"} : () -> ()
    %c18624_i64 = arith.constant 18624 : i64
    %7 = npu.alloc(%c18624_i64) : memref<2240xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2240xi1>
      npu.vstore %12, %7 : (vector<2240xi1>, memref<2240xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_4 = memref.reinterpret_cast %7 to offset: [0], sizes: [32, 64], strides: [64, 1] {npu.predicate_storage} : memref<2240xi1, #npu.address_space<ub>> to memref<32x64xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_2 : (memref<64xi1, #npu.address_space<ub>>) -> vector<64xi1>
      %13 = npu.broadcast %12 : vector<64xi1> -> vector<32x64xi1> {broadcast_dim = 0 : i64}
      npu.vstore %13, %reinterpret_cast_4 : (vector<32x64xi1>, memref<32x64xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_7"} : () -> ()
    %c20864_i64 = arith.constant 20864 : i64
    %8 = npu.alloc(%c20864_i64) : memref<2240xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<2240xi1>
      npu.vstore %12, %8 : (vector<2240xi1>, memref<2240xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_5 = memref.reinterpret_cast %8 to offset: [0], sizes: [32, 64], strides: [64, 1] {npu.predicate_storage} : memref<2240xi1, #npu.address_space<ub>> to memref<32x64xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_4 : (memref<32x64xi1, #npu.address_space<ub>>) -> vector<32x64xi1>
      %13 = npu.vload %reinterpret_cast_3 : (memref<32x64xi1, #npu.address_space<ub>>) -> vector<32x64xi1>
      %14 = npu.and %13, %12 : vector<32x64xi1>, vector<32x64xi1> -> vector<32x64xi1>
      npu.vstore %14, %reinterpret_cast_5 : (vector<32x64xi1>, memref<32x64xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_8"} : () -> ()
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c32, %c48], strides: [48, 1] : memref<?xi32, #npu.address_space<gm>> to memref<?x?xi32, strided<[48, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast_6 : memref<?x?xi32, strided<[48, 1], offset: ?>, #npu.address_space<gm>> to memref<32x64xi32, strided<[48, 1], offset: ?>, #npu.address_space<gm>>
    %c8192_i64 = arith.constant 8192 : i64
    %9 = npu.alloc(%c8192_i64) : memref<32x64xi32, #npu.address_space<ub>>
    %c0_i64 = arith.constant 0 : i64
    %10 = npu.alloc(%c0_i64) : memref<32x64xi32, #npu.address_space<ub>>
    npu.copy ins(%cast : memref<32x64xi32, strided<[48, 1], offset: ?>, #npu.address_space<gm>>) outs(%10 : memref<32x64xi32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %12 = npu.vload %10 : (memref<32x64xi32, #npu.address_space<ub>>) -> vector<32x64xi32>
      %13 = npu.vload %reinterpret_cast_5 : (memref<32x64xi1, #npu.address_space<ub>>) -> vector<32x64xi1>
      %14 = npu.select %13, %12, %c2147483647_i32 : vector<32x64xi1>, vector<32x64xi32>, i32 -> vector<32x64xi32>
      npu.vstore %14, %9 : (vector<32x64xi32>, memref<32x64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_9"} : () -> ()
    %c24640_i64 = arith.constant 24640 : i64
    %11 = npu.alloc(%c24640_i64) : memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %9 : (memref<32x64xi32, #npu.address_space<ub>>) -> vector<32x64xi32>
      %13 = npu.reduce %12, %c1_i64 : vector<32x64xi32>, i64 -> vector<32xi32> #npu.reduce_op<min> identities=[2147483647 : i32] {integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %13, %11 : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_10"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_7 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [32], strides: [1] : memref<?xi32, #npu.address_space<gm>> to memref<32xi32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%11 : memref<32xi32, #npu.address_space<ub>>) outs(%reinterpret_cast_7 : memref<32xi32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


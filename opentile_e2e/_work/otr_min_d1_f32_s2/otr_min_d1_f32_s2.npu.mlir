module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @otr_min_d1_f32_s2(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %false = arith.constant false
    %c0_i32 = arith.constant 0 : i32
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c20 = arith.constant 20 : index
    %c100 = arith.constant 100 : index
    %c100_i32 = arith.constant 100 : i32
    %c20_i32 = arith.constant 20 : i32
    %cst = arith.constant 0x7F800000 : f32
    %c47264_i64 = arith.constant 47264 : i64
    %0 = npu.alloc(%c47264_i64) : memref<64xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c0_i32 : i32 -> vector<64xi32>
      npu.vstore %12, %0 : (vector<64xi32>, memref<64xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast = memref.reinterpret_cast %0 to offset: [0], sizes: [32], strides: [1] : memref<64xi32, #npu.address_space<ub>> to memref<32xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c20_i32 : i32 -> vector<32xi32>
      npu.vstore %12, %reinterpret_cast : (vector<32xi32>, memref<32xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_0"} : () -> ()
    %c45728_i64 = arith.constant 45728 : i64
    %1 = npu.alloc(%c45728_i64) : memref<128xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %c100_i32 : i32 -> vector<128xi32>
      npu.vstore %12, %1 : (vector<128xi32>, memref<128xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_1"} : () -> ()
    %c46240_i64 = arith.constant 46240 : i64
    %2 = npu.alloc(%c46240_i64) : memref<128xi32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.iota : vector<128xi32>
      npu.vstore %12, %2 : (vector<128xi32>, memref<128xi32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_2"} : () -> ()
    %c47520_i64 = arith.constant 47520 : i64
    %3 = npu.alloc(%c47520_i64) : memref<64xi32, #npu.address_space<ub>>
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
    %c47776_i64 = arith.constant 47776 : i64
    %4 = npu.alloc(%c47776_i64) : memref<256xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<256xi1>
      npu.vstore %12, %4 : (vector<256xi1>, memref<256xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_1 = memref.reinterpret_cast %4 to offset: [0], sizes: [128], strides: [1] {npu.predicate_storage} : memref<256xi1, #npu.address_space<ub>> to memref<128xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %1 : (memref<128xi32, #npu.address_space<ub>>) -> vector<128xi32>
      %13 = npu.vload %2 : (memref<128xi32, #npu.address_space<ub>>) -> vector<128xi32>
      %14 = npu.cmp %13, %12 : vector<128xi32>, vector<128xi32> -> vector<128xi1> {compare_mode = #npu.compare_mode<lt>, integer_signedness = #npu.integer_signedness<signed>}
      npu.vstore %14, %reinterpret_cast_1 : (vector<128xi1>, memref<128xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_4"} : () -> ()
    %c48032_i64 = arith.constant 48032 : i64
    %5 = npu.alloc(%c48032_i64) : memref<256xi1, #npu.address_space<ub>>
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
    %6 = npu.alloc(%c32768_i64) : memref<4320xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<4320xi1>
      npu.vstore %12, %6 : (vector<4320xi1>, memref<4320xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_3 = memref.reinterpret_cast %6 to offset: [0], sizes: [128, 32], strides: [32, 1] {npu.predicate_storage} : memref<4320xi1, #npu.address_space<ub>> to memref<128x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_1 : (memref<128xi1, #npu.address_space<ub>>) -> vector<128xi1>
      %13 = npu.broadcast %12 : vector<128xi1> -> vector<128x32xi1> {broadcast_dim = 1 : i64}
      npu.vstore %13, %reinterpret_cast_3 : (vector<128x32xi1>, memref<128x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_6"} : () -> ()
    %c37088_i64 = arith.constant 37088 : i64
    %7 = npu.alloc(%c37088_i64) : memref<4320xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<4320xi1>
      npu.vstore %12, %7 : (vector<4320xi1>, memref<4320xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_4 = memref.reinterpret_cast %7 to offset: [0], sizes: [128, 32], strides: [32, 1] {npu.predicate_storage} : memref<4320xi1, #npu.address_space<ub>> to memref<128x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_2 : (memref<32xi1, #npu.address_space<ub>>) -> vector<32xi1>
      %13 = npu.broadcast %12 : vector<32xi1> -> vector<128x32xi1> {broadcast_dim = 0 : i64}
      npu.vstore %13, %reinterpret_cast_4 : (vector<128x32xi1>, memref<128x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_7"} : () -> ()
    %c41408_i64 = arith.constant 41408 : i64
    %8 = npu.alloc(%c41408_i64) : memref<4320xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.broadcast %false : i1 -> vector<4320xi1>
      npu.vstore %12, %8 : (vector<4320xi1>, memref<4320xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    %reinterpret_cast_5 = memref.reinterpret_cast %8 to offset: [0], sizes: [128, 32], strides: [32, 1] {npu.predicate_storage} : memref<4320xi1, #npu.address_space<ub>> to memref<128x32xi1, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %reinterpret_cast_4 : (memref<128x32xi1, #npu.address_space<ub>>) -> vector<128x32xi1>
      %13 = npu.vload %reinterpret_cast_3 : (memref<128x32xi1, #npu.address_space<ub>>) -> vector<128x32xi1>
      %14 = npu.and %13, %12 : vector<128x32xi1>, vector<128x32xi1> -> vector<128x32xi1>
      npu.vstore %14, %reinterpret_cast_5 : (vector<128x32xi1>, memref<128x32xi1, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_8"} : () -> ()
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [%c0], sizes: [%c100, %c20], strides: [20, 1] : memref<?xf32, #npu.address_space<gm>> to memref<?x?xf32, strided<[20, 1], offset: ?>, #npu.address_space<gm>>
    %cast = memref.cast %reinterpret_cast_6 : memref<?x?xf32, strided<[20, 1], offset: ?>, #npu.address_space<gm>> to memref<128x32xf32, strided<[20, 1], offset: ?>, #npu.address_space<gm>>
    %c16384_i64 = arith.constant 16384 : i64
    %9 = npu.alloc(%c16384_i64) : memref<128x32xf32, #npu.address_space<ub>>
    %c0_i64 = arith.constant 0 : i64
    %10 = npu.alloc(%c0_i64) : memref<128x32xf32, #npu.address_space<ub>>
    npu.copy ins(%cast : memref<128x32xf32, strided<[20, 1], offset: ?>, #npu.address_space<gm>>) outs(%10 : memref<128x32xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %12 = npu.vload %10 : (memref<128x32xf32, #npu.address_space<ub>>) -> vector<128x32xf32>
      %13 = npu.vload %reinterpret_cast_5 : (memref<128x32xi1, #npu.address_space<ub>>) -> vector<128x32xi1>
      %14 = npu.select %13, %12, %cst : vector<128x32xi1>, vector<128x32xf32>, f32 -> vector<128x32xf32>
      npu.vstore %14, %9 : (vector<128x32xf32>, memref<128x32xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_9"} : () -> ()
    %c46752_i64 = arith.constant 46752 : i64
    %11 = npu.alloc(%c46752_i64) : memref<128xf32, #npu.address_space<ub>>
    npu.scope() {
      %12 = npu.vload %9 : (memref<128x32xf32, #npu.address_space<ub>>) -> vector<128x32xf32>
      %13 = npu.reduce %12, %c1_i64 : vector<128x32xf32>, i64 -> vector<128xf32> #npu.reduce_op<min> identities=[0x7F800000 : f32]
      npu.vstore %13, %11 : (vector<128xf32>, memref<128xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>, outline_tag = "__auto_vf_scope_10"} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %reinterpret_cast_7 = memref.reinterpret_cast %arg1 to offset: [%c0], sizes: [%c100], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<?xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    %cast_8 = memref.cast %reinterpret_cast_7 : memref<?xf32, strided<[1], offset: ?>, #npu.address_space<gm>> to memref<128xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%11 : memref<128xf32, #npu.address_space<ub>>) outs(%cast_8 : memref<128xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


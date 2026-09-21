module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @ub_scalar_kernel(%arg0: memref<?xbf16, #npu.address_space<gm>>, %arg1: memref<?xbf16, #npu.address_space<gm>>, %arg2: i32) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c32 = arith.constant {block_id = 2 : i32, core_type = "VECTOR"} 32 : index
    %c16 = arith.constant {block_id = 2 : i32, core_type = "VECTOR"} 16 : index
    %c128 = arith.constant {block_id = 2 : i32, core_type = "VECTOR"} 128 : index
    %c0 = arith.constant {block_id = 2 : i32, core_type = "VECTOR"} 0 : index
    %c1 = arith.constant {block_id = 2 : i32, core_type = "VECTOR"} 1 : index
    %c0_i64 = arith.constant 0 : i64
    %0 = npu.alloc(%c0_i64) : memref<1024xi8, #npu.address_space<ub>>
    %view = memref.view %0[%c0][] {block_id = 2 : i32, core_type = "VECTOR"} : memref<1024xi8, #npu.address_space<ub>> to memref<16x32xbf16, #npu.address_space<ub>>
    %c1024_i64 = arith.constant 1024 : i64
    %1 = npu.alloc(%c1024_i64) : memref<1024xi8, #npu.address_space<ub>>
    %view_0 = memref.view %1[%c0][] {block_id = 2 : i32, core_type = "VECTOR"} : memref<1024xi8, #npu.address_space<ub>> to memref<16x32xbf16, #npu.address_space<ub>>
    %2 = npu.get_block_idx() {block_id = 3 : i32, core_type = "VECTOR"} : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 32], strides: [32, 1] {block_id = 3 : i32, core_type = "VECTOR"} : memref<?xbf16, #npu.address_space<gm>> to memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [16, 32], strides: [32, 1] {block_id = 3 : i32, core_type = "VECTOR"} : memref<?xbf16, #npu.address_space<gm>> to memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x32xbf16, #npu.address_space<ub>>) {block_id = 3 : i32, core_type = "VECTOR"}
    npu.set_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_S>, <EVENT_ID0>]
    scf.for %arg3 = %c0 to %c128 step %c1 {
      scf.for %arg4 = %c0 to %c16 step %c1 {
        scf.for %arg5 = %c0 to %c32 step %c1 {
          %3 = memref.load %view[%arg4, %arg5] {block_id = 1 : i32, core_type = "VECTOR"} : memref<16x32xbf16, #npu.address_space<ub>>
          memref.store %3, %view_0[%arg4, %arg5] {block_id = 1 : i32, core_type = "VECTOR"} : memref<16x32xbf16, #npu.address_space<ub>>
        } {tilelang.loop_kind = "serial"}
      } {tilelang.loop_kind = "serial"}
    } {tilelang.loop_kind = "serial"}
    npu.set_flag[<PIPE_S>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_S>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_0 : memref<16x32xbf16, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<16x32xbf16, strided<[32, 1]>, #npu.address_space<gm>>) {block_id = 4 : i32, core_type = "VECTOR"}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


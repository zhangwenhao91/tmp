#!/usr/bin/env python3
"""生成 E1/E2 实验 mlir：
E1: vadd A+A→OUT（2 ptr + 1 i32，3 参数）——测减少参数是否修复
E2: reduce_max 双输出（3 ptr + 1 i32，4 参数）——测增加参数是否破坏已知能跑的算子
"""
VADD_DIR = "/home/z30086261/tmp/elementwise_kernels/vadd"
RMAX_DIR = "/home/z30086261/tmp/reduce_kernels/reduce_max"

# ============ E1: vadd A+A → OUT, 3 参数 ============
e1 = """module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @vadd_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c0 = arith.constant 0 : index
    %c16_i32 = arith.constant 16 : i32
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %c0_i64 = arith.constant 0 : i64
    %2 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<ub>>
    %view = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %c16384_i64 = arith.constant 16384 : i64
    %3 = npu.alloc(%c16384_i64) : memref<8192xi8, #npu.address_space<ub>>
    %view_1 = memref.view %3[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %4 = arith.muli %1, %c16_i32 : i32
    %5 = arith.index_cast %4 : i32 to index
    %6 = arith.muli %5, %c128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%6], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %9 = npu.vload %view {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %10 = npu.vload %view {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %11 = npu.add %9, %10 : vector<16x128xf32>, vector<16x128xf32> -> vector<16x128xf32> {tcore_type = #npu.tcore_type<VECTOR>}
      npu.vstore %11, %view_1 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16x128xf32>, memref<16x128xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %7 = arith.muli %1, %c16_i32 : i32
    %8 = arith.index_cast %7 : i32 to index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [%8], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_1 : memref<16x128xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}
"""

# ============ E2: reduce_max 双输出, 4 参数 ============
e2 = """module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @reduce_max_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: i32) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c1_i64 = arith.constant 1 : i64
    %c0 = arith.constant 0 : index
    %c16_i32 = arith.constant 16 : i32
    %c128 = arith.constant 128 : index
    %0 = npu.get_block_idx() : i64
    %1 = arith.trunci %0 : i64 to i32
    %c0_i64 = arith.constant 0 : i64
    %2 = npu.alloc(%c0_i64) : memref<8192xi8, #npu.address_space<ub>>
    %view = memref.view %2[%c0][] : memref<8192xi8, #npu.address_space<ub>> to memref<16x128xf32, #npu.address_space<ub>>
    %c8192_i64 = arith.constant 8192 : i64
    %3 = npu.alloc(%c8192_i64) : memref<64xi8, #npu.address_space<ub>>
    %view_0 = memref.view %3[%c0][] : memref<64xi8, #npu.address_space<ub>> to memref<16xf32, #npu.address_space<ub>>
    %4 = arith.muli %1, %c16_i32 : i32
    %5 = arith.index_cast %4 : i32 to index
    %6 = arith.muli %5, %c128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%6], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%reinterpret_cast : memref<16x128xf32, strided<[128, 1], offset: ?>, #npu.address_space<gm>>) outs(%view : memref<16x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.set_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.wait_flag[<PIPE_MTE2>, <PIPE_V>, <EVENT_ID0>]
    npu.scope() {
      %9 = npu.vload %view {tcore_type = #npu.tcore_type<VECTOR>} : (memref<16x128xf32, #npu.address_space<ub>>) -> vector<16x128xf32>
      %10 = npu.reduce %9, %c1_i64 : vector<16x128xf32>, i64 -> vector<16xf32> #npu.reduce_op<max> identities=[0xFF800000 : f32] {tcore_type = #npu.tcore_type<VECTOR>}
      npu.vstore %10, %view_0 {tcore_type = #npu.tcore_type<VECTOR>} : (vector<16xf32>, memref<16xf32, #npu.address_space<ub>>) -> ()
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    %7 = arith.muli %1, %c16_i32 : i32
    %8 = arith.index_cast %7 : i32 to index
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [%8], sizes: [16], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]
    npu.copy ins(%view_0 : memref<16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    %reinterpret_cast_2 = memref.reinterpret_cast %arg2 to offset: [%8], sizes: [16], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>
    npu.copy ins(%view_0 : memref<16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<16xf32, strided<[1], offset: ?>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}
"""

open(f"{VADD_DIR}/3_vadd_e1_mix_npu.mlir", "w").write(e1)
open(f"{RMAX_DIR}/3_reduce_max_e2_mix_npu.mlir", "w").write(e2)
print("E1:", f"{VADD_DIR}/3_vadd_e1_mix_npu.mlir")
print("E2:", f"{RMAX_DIR}/3_reduce_max_e2_mix_npu.mlir")

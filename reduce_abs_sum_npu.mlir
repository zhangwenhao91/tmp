#map = affine_map<(d0) -> (d0)>
module attributes {npu.module_core_type = #npu.module_core_type<AIV>} {
  func.func @reduce_abs_sum_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) attributes {func_core_type = #npu.func_core_type<AIV>} {
    %c2 = arith.constant 2 : index
    %c32 = arith.constant 32 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant -1.000000e+00 : f32
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1]>, #npu.address_space<gm>>
    %c0_i64 = arith.constant 0 : i64
    %1 = npu.alloc(%c0_i64) : memref<16384xi8, #npu.address_space<ub>>
    %view = memref.view %1[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<32x128xf32, #npu.address_space<ub>>
    %c16384_i64 = arith.constant 16384 : i64
    %2 = npu.alloc(%c16384_i64) : memref<128xi8, #npu.address_space<ub>>
    %view_2 = memref.view %2[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<32x128xf32, #npu.address_space<ub>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.scope() {
      %c768_i64 = arith.constant 768 : i64
      %3 = npu.alloc(%c768_i64) : memref<1xf32, 2>
      %c0_i64_3 = arith.constant 0 : i64
      %4 = npu.alloc(%c0_i64_3) : memref<64xf32, 2>
      %c256_i64 = arith.constant 256 : i64
      %5 = npu.alloc(%c256_i64) : memref<64xf32, 2>
      %c512_i64 = arith.constant 512 : i64
      %6 = npu.alloc(%c512_i64) : memref<64xf32, 2>
      %c800_i64 = arith.constant 800 : i64
      %7 = npu.alloc(%c800_i64) : memref<1xf32, 2>
      scf.for %arg3 = %c0 to %c32 step %c1 {
        %reinterpret_cast_4 = memref.reinterpret_cast %3 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        linalg.fill ins(%cst : f32) outs(%reinterpret_cast_4 : memref<f32, strided<[]>, 2>)
        scf.for %arg4 = %c0 to %c2 step %c1 {
          linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel"]} ins(%4 : memref<64xf32, 2>) outs(%5 : memref<64xf32, 2>) {
          ^bb0(%in: f32, %out: f32):
            %8 = arith.mulf %in, %cst_0 : f32
            linalg.yield %8 : f32
          }
          linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%4, %5 : memref<64xf32, 2>, memref<64xf32, 2>) outs(%6 : memref<64xf32, 2>) {
          ^bb0(%in: f32, %in_11: f32, %out: f32):
            %8 = arith.maximumf %in, %in_11 : f32
            linalg.yield %8 : f32
          }
          %reinterpret_cast_7 = memref.reinterpret_cast %7 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          linalg.fill ins(%cst : f32) outs(%reinterpret_cast_7 : memref<f32, strided<[]>, 2>)
          linalg.reduce ins(%6 : memref<64xf32, 2>) outs(%reinterpret_cast_7 : memref<f32, strided<[]>, 2>) dimensions = [0] 
            (%in: f32, %init: f32) {
              %8 = arith.addf %in, %init : f32
              linalg.yield %8 : f32
            }
          %reinterpret_cast_8 = memref.reinterpret_cast %3 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_9 = memref.reinterpret_cast %7 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_10 = memref.reinterpret_cast %3 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          linalg.add ins(%reinterpret_cast_8, %reinterpret_cast_9 : memref<f32, strided<[]>, 2>, memref<f32, strided<[]>, 2>) outs(%reinterpret_cast_10 : memref<f32, strided<[]>, 2>)
        } {tilelang.loop_kind = "serial"}
        %reinterpret_cast_5 = memref.reinterpret_cast %3 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        %reinterpret_cast_6 = memref.reinterpret_cast %view_2 to offset: [%arg3], sizes: [], strides: [] : memref<32xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
        tilelang.copy %reinterpret_cast_5, %reinterpret_cast_6 : memref<f32, strided<[]>, 2> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.copy ins(%view_2 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_1 : memref<32xf32, strided<[1]>, #npu.address_space<gm>>) {tcore_type = #npu.tcore_type<VECTOR>}
    npu.pipe_barrier[<PIPE_ALL>]
    return
  }
}


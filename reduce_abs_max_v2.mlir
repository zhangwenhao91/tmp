#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<() -> ()>
module {
  func.func @reduce_abs_max_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: i32) {
    %c2 = arith.constant 2 : index
    %c32 = arith.constant 32 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant -1.000000e+00 : f32
    %cst_1 = arith.constant 0xFF800000 : f32
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [32, 128], strides: [128, 1] : memref<?xf32, #npu.address_space<gm>> to memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [32], strides: [1] : memref<?xf32, #npu.address_space<gm>> to memref<32xf32, strided<[1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<16384xi8, #npu.address_space<ub>>
    %view = memref.view %alloc[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<32x128xf32, #npu.address_space<ub>>
    %alloc_3 = memref.alloc() : memref<128xi8, #npu.address_space<ub>>
    %view_4 = memref.view %alloc_3[%c0][] : memref<128xi8, #npu.address_space<ub>> to memref<32xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<32x128xf32, strided<[128, 1]>, #npu.address_space<gm>>) outs(%view : memref<32x128xf32, #npu.address_space<ub>>)
    npu.scope() {
      %alloc_5 = memref.alloc() : memref<1xf32, 2>
      %alloc_6 = memref.alloc() : memref<64xf32, 2>
      %alloc_7 = memref.alloc() : memref<64xf32, 2>
      %alloc_8 = memref.alloc() : memref<64xf32, 2>
      %alloc_9 = memref.alloc() : memref<1xf32, 2>
      scf.for %arg3 = %c0 to %c32 step %c1 {
        %reinterpret_cast_10 = memref.reinterpret_cast %alloc_5 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        linalg.fill ins(%cst : f32) outs(%reinterpret_cast_10 : memref<f32, strided<[]>, 2>)
        scf.for %arg4 = %c0 to %c2 step %c1 {
          linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel"]} ins(%alloc_6 : memref<64xf32, 2>) outs(%alloc_7 : memref<64xf32, 2>) {
          ^bb0(%in: f32, %out: f32):
            %1 = arith.mulf %in, %cst_0 : f32
            linalg.yield %1 : f32
          }
          linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%alloc_6, %alloc_7 : memref<64xf32, 2>, memref<64xf32, 2>) outs(%alloc_8 : memref<64xf32, 2>) {
          ^bb0(%in: f32, %in_17: f32, %out: f32):
            %1 = arith.maximumf %in, %in_17 : f32
            linalg.yield %1 : f32
          }
          %reinterpret_cast_13 = memref.reinterpret_cast %alloc_9 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          linalg.fill ins(%cst_1 : f32) outs(%reinterpret_cast_13 : memref<f32, strided<[]>, 2>)
          linalg.reduce ins(%alloc_8 : memref<64xf32, 2>) outs(%reinterpret_cast_13 : memref<f32, strided<[]>, 2>) dimensions = [0] 
            (%in: f32, %init: f32) {
              %1 = arith.maximumf %in, %init : f32
              linalg.yield %1 : f32
            }
          %reinterpret_cast_14 = memref.reinterpret_cast %alloc_5 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_15 = memref.reinterpret_cast %alloc_9 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          %reinterpret_cast_16 = memref.reinterpret_cast %alloc_5 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
          linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = []} ins(%reinterpret_cast_14, %reinterpret_cast_15 : memref<f32, strided<[]>, 2>, memref<f32, strided<[]>, 2>) outs(%reinterpret_cast_16 : memref<f32, strided<[]>, 2>) {
          ^bb0(%in: f32, %in_17: f32, %out: f32):
            %1 = arith.maximumf %in, %in_17 : f32
            linalg.yield %1 : f32
          }
        } {tilelang.loop_kind = "serial"}
        %reinterpret_cast_11 = memref.reinterpret_cast %alloc_5 to offset: [0], sizes: [], strides: [] : memref<1xf32, 2> to memref<f32, strided<[]>, 2>
        %reinterpret_cast_12 = memref.reinterpret_cast %view_4 to offset: [%arg3], sizes: [], strides: [] : memref<32xf32, #npu.address_space<ub>> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
        tilelang.copy %reinterpret_cast_11, %reinterpret_cast_12 : memref<f32, strided<[]>, 2> to memref<f32, strided<[], offset: ?>, #npu.address_space<ub>>
      } {tilelang.loop_kind = "serial"}
      npu.yield
    } {mode = #npu.scope_mode<simd>} : () -> ()
    npu.copy ins(%view_4 : memref<32xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<32xf32, strided<[1]>, #npu.address_space<gm>>)
    return
  }
}


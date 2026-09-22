module {
  func.func @l1ub_kernel(%arg0: memref<?xf32, #npu.address_space<gm>>, %arg1: memref<?xf32, #npu.address_space<gm>>, %arg2: memref<?xf32, #npu.address_space<gm>>, %arg3: memref<?xf32, #npu.address_space<gm>>, %arg4: memref<?xf32, #npu.address_space<gm>>, %arg5: i32) {
    %c16 = arith.constant 16 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = npu.get_block_idx() : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 256], strides: [256, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x256xf32, strided<[256, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [256, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [16, 16], strides: [16, 1] : memref<?xf32, #npu.address_space<gm>> to memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>
    %alloc = memref.alloc() : memref<16384xi8, #npu.address_space<cbuf>>
    %view = memref.view %alloc[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %alloc_4 = memref.alloc() : memref<16384xi8, #npu.address_space<cbuf>>
    %view_5 = memref.view %alloc_4[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<16x256xf32, #npu.address_space<cbuf>>
    %alloc_6 = memref.alloc() : memref<16384xi8, #npu.address_space<ub>>
    %view_7 = memref.view %alloc_6[%c0][] : memref<16384xi8, #npu.address_space<ub>> to memref<16x256xf32, #npu.address_space<ub>>
    %alloc_8 = memref.alloc() : memref<16384xi8, #npu.address_space<cbuf>>
    %view_9 = memref.view %alloc_8[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %alloc_10 = memref.alloc() : memref<16384xi8, #npu.address_space<cbuf>>
    %view_11 = memref.view %alloc_10[%c0][] : memref<16384xi8, #npu.address_space<cbuf>> to memref<256x16xf32, #npu.address_space<cbuf>>
    %alloc_12 = memref.alloc() : memref<16x16xf32, #npu.address_space<cc>>
    %alloc_13 = memref.alloc() : memref<16x16xf32, #npu.address_space<cc>>
    %alloc_14 = memref.alloc() : memref<1024xi8, #npu.address_space<ub>>
    %view_15 = memref.view %alloc_14[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    %alloc_16 = memref.alloc() : memref<1024xi8, #npu.address_space<ub>>
    %view_17 = memref.view %alloc_16[%c0][] : memref<1024xi8, #npu.address_space<ub>> to memref<16x16xf32, #npu.address_space<ub>>
    npu.copy ins(%reinterpret_cast : memref<16x256xf32, strided<[256, 1]>, #npu.address_space<gm>>) outs(%view : memref<16x256xf32, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_0 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_9 : memref<256x16xf32, #npu.address_space<cbuf>>)
    npu.copy ins(%reinterpret_cast_1 : memref<256x16xf32, strided<[16, 1]>, #npu.address_space<gm>>) outs(%view_11 : memref<256x16xf32, #npu.address_space<cbuf>>)
    scf.for %arg6 = %c0 to %c16 step %c1 {
      npu.copy ins(%view : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%view_7 : memref<16x256xf32, #npu.address_space<ub>>)
      npu.copy ins(%view_7 : memref<16x256xf32, #npu.address_space<ub>>) outs(%view_5 : memref<16x256xf32, #npu.address_space<cbuf>>)
      npu.mad_l1 ins(%view_5, %view_9 : memref<16x256xf32, #npu.address_space<cbuf>>, memref<256x16xf32, #npu.address_space<cbuf>>) outs(%alloc_12 : memref<16x16xf32, #npu.address_space<cc>>) {kloop_db_cond = 256 : i64, lhs_trans = false, rhs_trans = false, unit_flag = 0 : i8, zero_init = true}
      npu.copy ins(%view_5 : memref<16x256xf32, #npu.address_space<cbuf>>) outs(%view_7 : memref<16x256xf32, #npu.address_space<ub>>)
      npu.copy ins(%view_7 : memref<16x256xf32, #npu.address_space<ub>>) outs(%view : memref<16x256xf32, #npu.address_space<cbuf>>)
      npu.mad_l1 ins(%view, %view_11 : memref<16x256xf32, #npu.address_space<cbuf>>, memref<256x16xf32, #npu.address_space<cbuf>>) outs(%alloc_13 : memref<16x16xf32, #npu.address_space<cc>>) {kloop_db_cond = 256 : i64, lhs_trans = false, rhs_trans = false, unit_flag = 0 : i8, zero_init = true}
    } {tilelang.loop_kind = "serial"}
    npu.copy ins(%alloc_12 : memref<16x16xf32, #npu.address_space<cc>>) outs(%view_15 : memref<16x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_15 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_2 : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    npu.copy ins(%alloc_13 : memref<16x16xf32, #npu.address_space<cc>>) outs(%view_17 : memref<16x16xf32, #npu.address_space<ub>>)
    npu.copy ins(%view_17 : memref<16x16xf32, #npu.address_space<ub>>) outs(%reinterpret_cast_3 : memref<16x16xf32, strided<[16, 1]>, #npu.address_space<gm>>)
    return
  }
}


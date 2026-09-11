module attributes {cce.target = "dav-351x", npu.module_core_type = #npu.module_core_type<MIX>} {
  func.func @gemm_kernel_mix_aic(%arg0: memref<?xbf16, #cce.address_space<gm>>, %arg1: memref<?xbf16, #cce.address_space<gm>>, %arg2: memref<?xf32, #cce.address_space<gm>>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIC>, npu.part_of_mix} {
    %c36028797018968064_i64 = arith.constant 36028797018968064 : i64
    %c128_i64 = arith.constant 128 : i64
    %c4503599627374592_i64 = arith.constant 4503599627374592 : i64
    %c8796093022224_i64 = arith.constant 8796093022224 : i64
    %c549756864512_i64 = arith.constant 549756864512 : i64
    %c-6917529025493073904_i64 = arith.constant -6917529025493073904 : i64
    %c1_i64 = arith.constant 1 : i64
    %c524296_i64 = arith.constant 524296 : i64
    %c8830452760576_i64 = arith.constant 8830452760576 : i64
    %c65537_i64 = arith.constant 65537 : i64
    %c8800387989504_i64 = arith.constant 8800387989504 : i64
    %c549755879425_i64 = arith.constant 549755879425 : i64
    %c68719542273_i64 = arith.constant 68719542273 : i64
    %c0_i64 = arith.constant 0 : i64
    %c32768_i64 = arith.constant 32768 : i64
    %c48_i64 = arith.constant 48 : i64
    %c60_i64 = arith.constant 60 : i64
    %c0 = arith.constant 0 : index
    %0 = cce.get.ctrl -> i64
    %1 = cce.sbitset0(%0, %c60_i64) : (i64, i64) -> i64
    cce.set.ctrl(%1) : i64
    %2 = cce.get.ctrl -> i64
    %3 = cce.sbitset1(%2, %c48_i64) : (i64, i64) -> i64
    cce.set.ctrl(%3) : i64
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xbf16, #cce.address_space<gm>> to memref<16x128xbf16, strided<[128, 1]>, #cce.address_space<gm>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [128, 128], strides: [128, 1] : memref<?xbf16, #cce.address_space<gm>> to memref<128x128xbf16, strided<[128, 1]>, #cce.address_space<gm>>
    %4 = npu.alloc(%c32768_i64) : memref<4096xi8, #cce.address_space<cbuf>>
    %view = memref.view %4[%c0][] : memref<4096xi8, #cce.address_space<cbuf>> to memref<16x128xbf16, #cce.address_space<cbuf>>
    %5 = npu.alloc(%c0_i64) : memref<32768xi8, #cce.address_space<cbuf>>
    %view_1 = memref.view %5[%c0][] : memref<32768xi8, #cce.address_space<cbuf>> to memref<128x128xbf16, #cce.address_space<cbuf>>
    %6 = npu.alloc(%c0_i64) : memref<16x128xf32, #cce.address_space<cc>>
    %7 = npu.alloc(%c0_i64) : memref<8192xi8, #cce.address_space<ub>>
    %view_2 = memref.view %7[%c0][] : memref<8192xi8, #cce.address_space<ub>> to memref<16x128xf32, #cce.address_space<ub>>
    %8 = npu.alloc(%c0_i64) : memref<16x128xbf16, #cce.address_space<ca>>
    %9 = npu.alloc(%c0_i64) : memref<128x128xbf16, #cce.address_space<cb>>
    cce.set.mte2.nz.para(%c68719542273_i64) : i64
    cce.mov.out.to.l1.multi.nd2nz(%view, %reinterpret_cast, %c4503599627374592_i64, %c128_i64) : (memref<16x128xbf16, #cce.address_space<cbuf>>, memref<16x128xbf16, strided<[128, 1]>, #cce.address_space<gm>>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.set.mte2.nz.para(%c549755879425_i64) : i64
    cce.mov.out.to.l1.multi.nd2nz(%view_1, %reinterpret_cast_0, %c36028797018968064_i64, %c128_i64) : (memref<128x128xbf16, #cce.address_space<cbuf>>, memref<128x128xbf16, strided<[128, 1]>, #cce.address_space<gm>>, i64, i64)
    cce.set_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID0>
    cce.load.l1.to.l0a.2dv2(%8, %view, %c8800387989504_i64, %c65537_i64, %c0_i64) : (memref<16x128xbf16, #cce.address_space<ca>>, memref<16x128xbf16, #cce.address_space<cbuf>>, i64, i64, i64)
    cce.wait_flag pipe = <PIPE_MTE2> tpipe = <PIPE_MTE1> pipeID = <EVENT_ID1>
    cce.load.l1.to.l0b.2dv2(%9, %view_1, %c8830452760576_i64, %c524296_i64, %c1_i64) : (memref<128x128xbf16, #cce.address_space<cb>>, memref<128x128xbf16, #cce.address_space<cbuf>>, i64, i64, i64)
    cce.set_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_MTE1> tpipe = <PIPE_M> pipeID = <EVENT_ID0>
    cce.mad(%6, %8, %9, %c-6917529025493073904_i64) {cmatrixInitVal = true, cmatrixSource = false, gemvCtrl = true, k = 128 : i16, m = 16 : i16, n = 128 : i16, phase = 0 : i8} : (memref<16x128xf32, #cce.address_space<cc>>, memref<16x128xbf16, #cce.address_space<ca>>, memref<128x128xbf16, #cce.address_space<cb>>, i64)
    cce.set_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.wait_flag pipe = <PIPE_M> tpipe = <PIPE_FIX> pipeID = <EVENT_ID0>
    cce.set.loop3.para(%c1_i64) : i64
    cce.fix.l0c.to.ub(%view_2, %6, %c549756864512_i64, %c8796093022224_i64) {dmaMode = 0 : i32} : (memref<16x128xf32, #cce.address_space<ub>>, memref<16x128xf32, #cce.address_space<cc>>, i64, i64)
    cce.set.intra.blocki.mode pipe = <PIPE_FIX> syncid = %c0_i64
    cce.wait.intra.blocki.mode pipe = <PIPE_FIX> syncid = %c1_i64
    cce.barrier pipe = <PIPE_ALL>
    return
  }
  func.func @gemm_kernel_mix_aiv(%arg0: memref<?xbf16, #cce.address_space<gm>>, %arg1: memref<?xbf16, #cce.address_space<gm>>, %arg2: memref<?xf32, #cce.address_space<gm>>, %arg3: i32) attributes {cce.core = #cce.core, func_core_type = #npu.func_core_type<AIV>, npu.part_of_mix} {
    %c1_i64 = arith.constant 1 : i64
    %c35184372088864_i64 = arith.constant 35184372088864 : i64
    %c288230377225457664_i64 = arith.constant 288230377225457664 : i64
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %c60_i64 = arith.constant 60 : i64
    %c48_i64 = arith.constant 48 : i64
    %0 = cce.get.ctrl -> i64
    %1 = cce.sbitset0(%0, %c60_i64) : (i64, i64) -> i64
    cce.set.ctrl(%1) : i64
    %2 = cce.get.ctrl -> i64
    %3 = cce.sbitset1(%2, %c48_i64) : (i64, i64) -> i64
    cce.set.ctrl(%3) : i64
    %4 = cce.get_sub_block_idx -> i64
    %5 = arith.cmpi eq, %4, %c0_i64 : i64
    scf.if %5 {
      %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [0], sizes: [16, 128], strides: [128, 1] : memref<?xf32, #cce.address_space<gm>> to memref<16x128xf32, strided<[128, 1]>, #cce.address_space<gm>>
      %6 = npu.alloc(%c0_i64) : memref<8192xi8, #cce.address_space<ub>>
      %view = memref.view %6[%c0][] : memref<8192xi8, #cce.address_space<ub>> to memref<16x128xf32, #cce.address_space<ub>>
      cce.wait.intra.blocki.mode pipe = <PIPE_V> syncid = %c0_i64
      cce.mov.ub.to.out.align.v2.dv(%reinterpret_cast, %view, %c288230377225457664_i64, %c35184372088864_i64) : (memref<16x128xf32, strided<[128, 1]>, #cce.address_space<gm>>, memref<16x128xf32, #cce.address_space<ub>>, i64, i64)
      cce.set.intra.blocki.mode pipe = <PIPE_MTE3> syncid = %c1_i64
      cce.barrier pipe = <PIPE_ALL>
    }
    return
  }
}


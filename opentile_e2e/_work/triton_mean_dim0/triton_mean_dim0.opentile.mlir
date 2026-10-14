// RUN: tile-opt --npu-pipeline="target=dav-351x" --cce-pipeline="target=dav-351x" %s | FileCheck --check-prefix=PASS %s
// PASS-LABEL: llvm.func @triton_mean_dim0
// PASS-NOT: cce.intr.mov.out.to.ub.align.v2
// PASS-NOT: open_tile.assert
module {
  open_tile.module @open_tile.module {
    entry @triton_mean_dim0(%in_ptr0: tile<ptr<f16>>, %out_ptr0: tile<ptr<f16>>) optimization_hints=<Ascend910B3 = {num_warps = 4, occupancy = 1, warp_size = 32}> {
      %mmask = constant <i32: 128> : !open_tile.tile<256xi32>
      %nmask = constant <i32: 3> : !open_tile.tile<8xi32>
      %idx = constant <i32: 3> : !open_tile.tile<256x1xi32>
      %idx_0 = constant <i64: 2147483647> : !open_tile.tile<256x1xi64>
      %idx_1 = constant <i64: -2147483648> : !open_tile.tile<256x1xi64>
      %idx_2 = constant <i64: 2147483647> : !open_tile.tile<256x8xi64>
      %idx_3 = constant <i64: -2147483648> : !open_tile.tile<256x8xi64>
      %ret = constant <f32: 1.280000e+02> : !open_tile.tile<8xf32>
      %idx_4 = constant <i64: 3> : !open_tile.tile<256x1xi64>
      %x = constant <f16: 0.000000e+00> : !open_tile.tile<256x8xf16>
      %out_ptr0_5 = assume div_by<16>, %out_ptr0 : !open_tile.tile<!open_tile.ptr<f16>>
      %in_ptr0_6 = assume div_by<16>, %in_ptr0 : !open_tile.tile<!open_tile.ptr<f16>>
      %mblk_idx = iota : !open_tile.tile<256xi32>
      %nblk_idx = iota : !open_tile.tile<8xi32>
      %mmask_7 = cmpi less_than %mblk_idx, %mmask, signed : !open_tile.tile<256xi32> -> !open_tile.tile<256xi1>
      %nmask_8 = cmpi less_than %nblk_idx, %nmask, signed : !open_tile.tile<8xi32> -> !open_tile.tile<8xi1>
      %mask = reshape %mmask_7 : !open_tile.tile<256xi1> -> !open_tile.tile<256x1xi1>
      %mask_9 = reshape %nmask_8 : !open_tile.tile<8xi1> -> !open_tile.tile<1x8xi1>
      %mask_10 = broadcast %mask : !open_tile.tile<256x1xi1> -> !open_tile.tile<256x8xi1>
      %mask_11 = broadcast %mask_9 : !open_tile.tile<1x8xi1> -> !open_tile.tile<256x8xi1>
      %mask_12 = exti %mask_10  signed : !open_tile.tile<256x8xi1> -> !open_tile.tile<256x8xi16>
      %mask_13 = exti %mask_11  signed : !open_tile.tile<256x8xi1> -> !open_tile.tile<256x8xi16>
      %mask_14 = andi %mask_12, %mask_13 : !open_tile.tile<256x8xi16>
      %mask_15 = trunci %mask_14 : !open_tile.tile<256x8xi16> -> !open_tile.tile<256x8xi1>
      %idx_16 = reshape %mblk_idx : !open_tile.tile<256xi32> -> !open_tile.tile<256x1xi32>
      %idx_17 = exti %idx_16  signed : !open_tile.tile<256x1xi32> -> !open_tile.tile<256x1xi64>
      %idx_18 = muli %idx_17, %idx_4 : !open_tile.tile<256x1xi64>
      %idx_19 = cmpi less_than_or_equal %idx_18, %idx_0, signed : !open_tile.tile<256x1xi64> -> !open_tile.tile<256x1xi1>
      %idx_20 = cmpi greater_than_or_equal %idx_18, %idx_1, signed : !open_tile.tile<256x1xi64> -> !open_tile.tile<256x1xi1>
      %idx_21 = exti %idx_19  signed : !open_tile.tile<256x1xi1> -> !open_tile.tile<256x1xi16>
      %idx_22 = exti %idx_20  signed : !open_tile.tile<256x1xi1> -> !open_tile.tile<256x1xi16>
      %idx_23 = andi %idx_21, %idx_22 : !open_tile.tile<256x1xi16>
      %idx_24 = trunci %idx_23 : !open_tile.tile<256x1xi16> -> !open_tile.tile<256x1xi1>
      assert %idx_24, "int32 overflow detected for operation mul" : !open_tile.tile<256x1xi1>
      %idx_25 = muli %idx_16, %idx : !open_tile.tile<256x1xi32>
      %idx_26 = reshape %nblk_idx : !open_tile.tile<8xi32> -> !open_tile.tile<1x8xi32>
      %idx_27 = broadcast %idx_25 : !open_tile.tile<256x1xi32> -> !open_tile.tile<256x8xi32>
      %idx_28 = broadcast %idx_26 : !open_tile.tile<1x8xi32> -> !open_tile.tile<256x8xi32>
      %idx_29 = exti %idx_25  signed : !open_tile.tile<256x1xi32> -> !open_tile.tile<256x1xi64>
      %idx_30 = broadcast %idx_29 : !open_tile.tile<256x1xi64> -> !open_tile.tile<256x8xi64>
      %idx_31 = exti %idx_26  signed : !open_tile.tile<1x8xi32> -> !open_tile.tile<1x8xi64>
      %idx_32 = broadcast %idx_31 : !open_tile.tile<1x8xi64> -> !open_tile.tile<256x8xi64>
      %idx_33 = addi %idx_30, %idx_32 : !open_tile.tile<256x8xi64>
      %idx_34 = cmpi less_than_or_equal %idx_33, %idx_2, signed : !open_tile.tile<256x8xi64> -> !open_tile.tile<256x8xi1>
      %idx_35 = cmpi greater_than_or_equal %idx_33, %idx_3, signed : !open_tile.tile<256x8xi64> -> !open_tile.tile<256x8xi1>
      %idx_36 = exti %idx_34  signed : !open_tile.tile<256x8xi1> -> !open_tile.tile<256x8xi16>
      %idx_37 = exti %idx_35  signed : !open_tile.tile<256x8xi1> -> !open_tile.tile<256x8xi16>
      %idx_38 = andi %idx_36, %idx_37 : !open_tile.tile<256x8xi16>
      %idx_39 = trunci %idx_38 : !open_tile.tile<256x8xi16> -> !open_tile.tile<256x8xi1>
      assert %idx_39, "int32 overflow detected for operation add" : !open_tile.tile<256x8xi1>
      %idx_40 = addi %idx_27, %idx_28 : !open_tile.tile<256x8xi32>
      %x_41 = reshape %in_ptr0_6 : !open_tile.tile<!open_tile.ptr<f16>> -> !open_tile.tile<1x1x!open_tile.ptr<f16>>
      %x_42 = broadcast %x_41 : !open_tile.tile<1x1x!open_tile.ptr<f16>> -> !open_tile.tile<256x8x!open_tile.ptr<f16>>
      %x_43 = offset %x_42, %idx_40 : !open_tile.tile<256x8x!open_tile.ptr<f16>>, !open_tile.tile<256x8xi32> -> !open_tile.tile<256x8x!open_tile.ptr<f16>>
      %x_44, %x_45 = load_ptr_tko weak %x_43, %mask_15, %x : !open_tile.tile<256x8x!open_tile.ptr<f16>>, !open_tile.tile<256x8xi1>, !open_tile.tile<256x8xf16> -> !open_tile.tile<256x8xf16>, !open_tile.token optimization_hints=<Ascend910B3 = {latency = 3}>
      %ret_46 = reduce %x_44 dim=0 identities=[0.000000e+00 : f16] (%ret_49, %ret_50) : !open_tile.tile<256x8xf16> -> !open_tile.tile<8xf16> {
        %ret_51 = addf %ret_49, %ret_50 rounding<nearest_even> : !open_tile.tile<f16>
        yield %ret_51 : !open_tile.tile<f16>
      }
      %ret_47 = ftof %ret_46 : !open_tile.tile<8xf16> -> !open_tile.tile<8xf32>
      %ret_48 = divf %ret_47, %ret rounding<nearest_even> : !open_tile.tile<8xf32>
      %rshp = reshape %out_ptr0_5 : !open_tile.tile<!open_tile.ptr<f16>> -> !open_tile.tile<1x!open_tile.ptr<f16>>
      %bcast = broadcast %rshp : !open_tile.tile<1x!open_tile.ptr<f16>> -> !open_tile.tile<8x!open_tile.ptr<f16>>
      %0 = offset %bcast, %nblk_idx : !open_tile.tile<8x!open_tile.ptr<f16>>, !open_tile.tile<8xi32> -> !open_tile.tile<8x!open_tile.ptr<f16>>
      %1 = ftof %ret_48 : !open_tile.tile<8xf32> -> !open_tile.tile<8xf16>
      %2 = store_ptr_tko weak %0, %1, %nmask_8 : !open_tile.tile<8x!open_tile.ptr<f16>>, !open_tile.tile<8xf16>, !open_tile.tile<8xi1> -> !open_tile.token
      return
    }
  }
}

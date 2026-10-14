// RUN: tile-opt --npu-pipeline="target=dav-351x" --cce-pipeline="target=dav-351x" %s | FileCheck --check-prefix=PASS %s
// PASS-LABEL: llvm.func @triton_mean_dim1
// PASS-NOT: open_tile.assert
module {
  open_tile.module @open_tile.module {
    entry @triton_mean_dim1(%in_ptr0: tile<ptr<f16>>, %out_ptr0: tile<ptr<f16>>) optimization_hints=<Ascend910B3 = {num_warps = 4, occupancy = 1, warp_size = 32}> {
      %mmask = constant <i32: 263> : !open_tile.tile<512xi32>
      %nmask = constant <i32: 1> : !open_tile.tile<8xi32>
      %idx = constant <i64: 2147483647> : !open_tile.tile<512x1xi64>
      %idx_0 = constant <i64: -2147483648> : !open_tile.tile<512x1xi64>
      %idx_1 = constant <i64: 2147483647> : !open_tile.tile<512x8xi64>
      %idx_2 = constant <i64: -2147483648> : !open_tile.tile<512x8xi64>
      %x = constant <f16: 0.000000e+00> : !open_tile.tile<512x8xf16>
      %out_ptr0_3 = assume div_by<16>, %out_ptr0 : !open_tile.tile<!open_tile.ptr<f16>>
      %in_ptr0_4 = assume div_by<16>, %in_ptr0 : !open_tile.tile<!open_tile.ptr<f16>>
      %mblk_idx = iota : !open_tile.tile<512xi32>
      %nblk_idx = iota : !open_tile.tile<8xi32>
      %mmask_5 = cmpi less_than %mblk_idx, %mmask, signed : !open_tile.tile<512xi32> -> !open_tile.tile<512xi1>
      %nmask_6 = cmpi less_than %nblk_idx, %nmask, signed : !open_tile.tile<8xi32> -> !open_tile.tile<8xi1>
      %mask = reshape %mmask_5 : !open_tile.tile<512xi1> -> !open_tile.tile<512x1xi1>
      %mask_7 = reshape %nmask_6 : !open_tile.tile<8xi1> -> !open_tile.tile<1x8xi1>
      %mask_8 = broadcast %mask : !open_tile.tile<512x1xi1> -> !open_tile.tile<512x8xi1>
      %mask_9 = broadcast %mask_7 : !open_tile.tile<1x8xi1> -> !open_tile.tile<512x8xi1>
      %mask_10 = exti %mask_8  signed : !open_tile.tile<512x8xi1> -> !open_tile.tile<512x8xi16>
      %mask_11 = exti %mask_9  signed : !open_tile.tile<512x8xi1> -> !open_tile.tile<512x8xi16>
      %mask_12 = andi %mask_10, %mask_11 : !open_tile.tile<512x8xi16>
      %mask_13 = trunci %mask_12 : !open_tile.tile<512x8xi16> -> !open_tile.tile<512x8xi1>
      %idx_14 = reshape %mblk_idx : !open_tile.tile<512xi32> -> !open_tile.tile<512x1xi32>
      %idx_15 = exti %idx_14  signed : !open_tile.tile<512x1xi32> -> !open_tile.tile<512x1xi64>
      %idx_16 = cmpi less_than_or_equal %idx_15, %idx, signed : !open_tile.tile<512x1xi64> -> !open_tile.tile<512x1xi1>
      %idx_17 = cmpi greater_than_or_equal %idx_15, %idx_0, signed : !open_tile.tile<512x1xi64> -> !open_tile.tile<512x1xi1>
      %idx_18 = exti %idx_16  signed : !open_tile.tile<512x1xi1> -> !open_tile.tile<512x1xi16>
      %idx_19 = exti %idx_17  signed : !open_tile.tile<512x1xi1> -> !open_tile.tile<512x1xi16>
      %idx_20 = andi %idx_18, %idx_19 : !open_tile.tile<512x1xi16>
      %idx_21 = trunci %idx_20 : !open_tile.tile<512x1xi16> -> !open_tile.tile<512x1xi1>
      assert %idx_21, "int32 overflow detected for operation mul" : !open_tile.tile<512x1xi1>
      %idx_22 = reshape %nblk_idx : !open_tile.tile<8xi32> -> !open_tile.tile<1x8xi32>
      %idx_23 = broadcast %idx_14 : !open_tile.tile<512x1xi32> -> !open_tile.tile<512x8xi32>
      %idx_24 = broadcast %idx_22 : !open_tile.tile<1x8xi32> -> !open_tile.tile<512x8xi32>
      %idx_25 = broadcast %idx_15 : !open_tile.tile<512x1xi64> -> !open_tile.tile<512x8xi64>
      %idx_26 = exti %idx_22  signed : !open_tile.tile<1x8xi32> -> !open_tile.tile<1x8xi64>
      %idx_27 = broadcast %idx_26 : !open_tile.tile<1x8xi64> -> !open_tile.tile<512x8xi64>
      %idx_28 = addi %idx_25, %idx_27 : !open_tile.tile<512x8xi64>
      %idx_29 = cmpi less_than_or_equal %idx_28, %idx_1, signed : !open_tile.tile<512x8xi64> -> !open_tile.tile<512x8xi1>
      %idx_30 = cmpi greater_than_or_equal %idx_28, %idx_2, signed : !open_tile.tile<512x8xi64> -> !open_tile.tile<512x8xi1>
      %idx_31 = exti %idx_29  signed : !open_tile.tile<512x8xi1> -> !open_tile.tile<512x8xi16>
      %idx_32 = exti %idx_30  signed : !open_tile.tile<512x8xi1> -> !open_tile.tile<512x8xi16>
      %idx_33 = andi %idx_31, %idx_32 : !open_tile.tile<512x8xi16>
      %idx_34 = trunci %idx_33 : !open_tile.tile<512x8xi16> -> !open_tile.tile<512x8xi1>
      assert %idx_34, "int32 overflow detected for operation add" : !open_tile.tile<512x8xi1>
      %idx_35 = addi %idx_23, %idx_24 : !open_tile.tile<512x8xi32>
      %x_36 = reshape %in_ptr0_4 : !open_tile.tile<!open_tile.ptr<f16>> -> !open_tile.tile<1x1x!open_tile.ptr<f16>>
      %x_37 = broadcast %x_36 : !open_tile.tile<1x1x!open_tile.ptr<f16>> -> !open_tile.tile<512x8x!open_tile.ptr<f16>>
      %x_38 = offset %x_37, %idx_35 : !open_tile.tile<512x8x!open_tile.ptr<f16>>, !open_tile.tile<512x8xi32> -> !open_tile.tile<512x8x!open_tile.ptr<f16>>
      %x_39, %x_40 = load_ptr_tko weak %x_38, %mask_13, %x : !open_tile.tile<512x8x!open_tile.ptr<f16>>, !open_tile.tile<512x8xi1>, !open_tile.tile<512x8xf16> -> !open_tile.tile<512x8xf16>, !open_tile.token optimization_hints=<Ascend910B3 = {latency = 3}>
      %ret = reduce %x_39 dim=1 identities=[0.000000e+00 : f16] (%ret_41, %ret_42) : !open_tile.tile<512x8xf16> -> !open_tile.tile<512xf16> {
        %ret_43 = addf %ret_41, %ret_42 rounding<nearest_even> : !open_tile.tile<f16>
        yield %ret_43 : !open_tile.tile<f16>
      }
      %rshp = reshape %out_ptr0_3 : !open_tile.tile<!open_tile.ptr<f16>> -> !open_tile.tile<1x!open_tile.ptr<f16>>
      %bcast = broadcast %rshp : !open_tile.tile<1x!open_tile.ptr<f16>> -> !open_tile.tile<512x!open_tile.ptr<f16>>
      %0 = offset %bcast, %mblk_idx : !open_tile.tile<512x!open_tile.ptr<f16>>, !open_tile.tile<512xi32> -> !open_tile.tile<512x!open_tile.ptr<f16>>
      %1 = store_ptr_tko weak %0, %ret, %mmask_5 : !open_tile.tile<512x!open_tile.ptr<f16>>, !open_tile.tile<512xf16>, !open_tile.tile<512xi1> -> !open_tile.token optimization_hints=<Ascend910B3 = {latency = 3}>
      return
    }
  }
}

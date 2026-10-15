// RUN: tile-opt --npu-pipeline="target=dav-351x" --cce-pipeline="target=dav-351x" %s | FileCheck --check-prefix=LLVM %s
// LLVM: llvm.func
module {
  open_tile.module @open_tile.module {
    entry @otg_mul_d1_i16(%in_ptr0: tile<ptr<i16>>, %out_ptr0: tile<ptr<i16>>) optimization_hints=<Ascend910B3 = {num_warps = 4, occupancy = 1, warp_size = 32}> {
      %mmask = constant <i32: 64> : !open_tile.tile<64xi32>
      %nmask = constant <i32: 16> : !open_tile.tile<32xi32>
      %idx = constant <i32: 16> : !open_tile.tile<64x1xi32>
      %x = constant <i16: 1> : !open_tile.tile<64x32xi16>
      %out_ptr0_0 = assume div_by<16>, %out_ptr0 : !open_tile.tile<!open_tile.ptr<i16>>
      %in_ptr0_1 = assume div_by<16>, %in_ptr0 : !open_tile.tile<!open_tile.ptr<i16>>
      %mblk_idx = iota : !open_tile.tile<64xi32>
      %nblk_idx = iota : !open_tile.tile<32xi32>
      %mmask_2 = cmpi less_than %mblk_idx, %mmask, signed : !open_tile.tile<64xi32> -> !open_tile.tile<64xi1>
      %nmask_3 = cmpi less_than %nblk_idx, %nmask, signed : !open_tile.tile<32xi32> -> !open_tile.tile<32xi1>
      %mask = reshape %mmask_2 : !open_tile.tile<64xi1> -> !open_tile.tile<64x1xi1>
      %mask_4 = reshape %nmask_3 : !open_tile.tile<32xi1> -> !open_tile.tile<1x32xi1>
      %mask_5 = broadcast %mask : !open_tile.tile<64x1xi1> -> !open_tile.tile<64x32xi1>
      %mask_6 = broadcast %mask_4 : !open_tile.tile<1x32xi1> -> !open_tile.tile<64x32xi1>
      %mask_7 = exti %mask_5  signed : !open_tile.tile<64x32xi1> -> !open_tile.tile<64x32xi16>
      %mask_8 = exti %mask_6  signed : !open_tile.tile<64x32xi1> -> !open_tile.tile<64x32xi16>
      %mask_9 = andi %mask_7, %mask_8 : !open_tile.tile<64x32xi16>
      %mask_10 = trunci %mask_9 : !open_tile.tile<64x32xi16> -> !open_tile.tile<64x32xi1>
      %idx_11 = reshape %mblk_idx : !open_tile.tile<64xi32> -> !open_tile.tile<64x1xi32>
      %idx_12 = muli %idx_11, %idx : !open_tile.tile<64x1xi32>
      %idx_13 = reshape %nblk_idx : !open_tile.tile<32xi32> -> !open_tile.tile<1x32xi32>
      %idx_14 = broadcast %idx_12 : !open_tile.tile<64x1xi32> -> !open_tile.tile<64x32xi32>
      %idx_15 = broadcast %idx_13 : !open_tile.tile<1x32xi32> -> !open_tile.tile<64x32xi32>
      %idx_16 = addi %idx_14, %idx_15 : !open_tile.tile<64x32xi32>
      %x_17 = reshape %in_ptr0_1 : !open_tile.tile<!open_tile.ptr<i16>> -> !open_tile.tile<1x1x!open_tile.ptr<i16>>
      %x_18 = broadcast %x_17 : !open_tile.tile<1x1x!open_tile.ptr<i16>> -> !open_tile.tile<64x32x!open_tile.ptr<i16>>
      %x_19 = offset %x_18, %idx_16 : !open_tile.tile<64x32x!open_tile.ptr<i16>>, !open_tile.tile<64x32xi32> -> !open_tile.tile<64x32x!open_tile.ptr<i16>>
      %x_20, %x_21 = load_ptr_tko weak %x_19, %mask_10, %x : !open_tile.tile<64x32x!open_tile.ptr<i16>>, !open_tile.tile<64x32xi1>, !open_tile.tile<64x32xi16> -> !open_tile.tile<64x32xi16>, !open_tile.token optimization_hints=<Ascend910B3 = {latency = 3}>
      %ret = reduce %x_20 dim=1 identities=[1 : i16] (%ret_a, %ret_b) : !open_tile.tile<64x32xi16> -> !open_tile.tile<64xi16> {
        %ret_c = muli %ret_a, %ret_b : !open_tile.tile<i16>
        yield %ret_c : !open_tile.tile<i16>
      }
      %rshp = reshape %out_ptr0_0 : !open_tile.tile<!open_tile.ptr<i16>> -> !open_tile.tile<1x!open_tile.ptr<i16>>
      %bcast = broadcast %rshp : !open_tile.tile<1x!open_tile.ptr<i16>> -> !open_tile.tile<64x!open_tile.ptr<i16>>
      %0 = offset %bcast, %mblk_idx : !open_tile.tile<64x!open_tile.ptr<i16>>, !open_tile.tile<64xi32> -> !open_tile.tile<64x!open_tile.ptr<i16>>
      %1 = store_ptr_tko weak %0, %ret, %mmask_2 : !open_tile.tile<64x!open_tile.ptr<i16>>, !open_tile.tile<64xi16>, !open_tile.tile<64xi1> -> !open_tile.token
      return
    }
  }
}

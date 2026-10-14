// RUN: tile-opt --npu-pipeline="target=dav-351x" --cce-pipeline="target=dav-351x" %s | FileCheck --check-prefix=LLVM %s
// LLVM: llvm.func
module {
  open_tile.module @open_tile.module {
    entry @triton_max_dim0(%in_ptr0: tile<ptr<f32>>, %out_ptr0: tile<ptr<f32>>) optimization_hints=<Ascend910B3 = {num_warps = 4, occupancy = 1, warp_size = 32}> {
      %mmask = constant <i32: 64> : !open_tile.tile<64xi32>
      %nmask = constant <i32: 8> : !open_tile.tile<32xi32>
      %idx = constant <i32: 8> : !open_tile.tile<64x1xi32>
      %x = constant <f32: 0xFF800000> : !open_tile.tile<64x32xf32>
      %out_ptr0_0 = assume div_by<16>, %out_ptr0 : !open_tile.tile<!open_tile.ptr<f32>>
      %in_ptr0_1 = assume div_by<16>, %in_ptr0 : !open_tile.tile<!open_tile.ptr<f32>>
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
      %x_17 = reshape %in_ptr0_1 : !open_tile.tile<!open_tile.ptr<f32>> -> !open_tile.tile<1x1x!open_tile.ptr<f32>>
      %x_18 = broadcast %x_17 : !open_tile.tile<1x1x!open_tile.ptr<f32>> -> !open_tile.tile<64x32x!open_tile.ptr<f32>>
      %x_19 = offset %x_18, %idx_16 : !open_tile.tile<64x32x!open_tile.ptr<f32>>, !open_tile.tile<64x32xi32> -> !open_tile.tile<64x32x!open_tile.ptr<f32>>
      %x_20, %x_21 = load_ptr_tko weak %x_19, %mask_10, %x : !open_tile.tile<64x32x!open_tile.ptr<f32>>, !open_tile.tile<64x32xi1>, !open_tile.tile<64x32xf32> -> !open_tile.tile<64x32xf32>, !open_tile.token optimization_hints=<Ascend910B3 = {latency = 3}>
      %ret = reduce %x_20 dim=0 identities=[0xFF800000 : f32] (%ret_22, %ret_23) : !open_tile.tile<64x32xf32> -> !open_tile.tile<32xf32> {
        %ret_24 = maxf %ret_22, %ret_23 : !open_tile.tile<f32>
        yield %ret_24 : !open_tile.tile<f32>
      }
      %rshp = reshape %out_ptr0_0 : !open_tile.tile<!open_tile.ptr<f32>> -> !open_tile.tile<1x!open_tile.ptr<f32>>
      %bcast = broadcast %rshp : !open_tile.tile<1x!open_tile.ptr<f32>> -> !open_tile.tile<32x!open_tile.ptr<f32>>
      %0 = offset %bcast, %nblk_idx : !open_tile.tile<32x!open_tile.ptr<f32>>, !open_tile.tile<32xi32> -> !open_tile.tile<32x!open_tile.ptr<f32>>
      %1 = store_ptr_tko weak %0, %ret, %nmask_3 : !open_tile.tile<32x!open_tile.ptr<f32>>, !open_tile.tile<32xf32>, !open_tile.tile<32xi1> -> !open_tile.token
      return
    }
  }
}

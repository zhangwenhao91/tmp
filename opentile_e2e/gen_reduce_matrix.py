#!/usr/bin/env python3
"""生成 open_tile.reduce 矩阵用例（combiner x axis x dtype）。

产出：
  <PKG>/_src/<name>.opentile.mlir     降级输入
  <PKG>/<name>.opentile.json          kernel_runner 配置
  <PKG>/golden_impl.py                全部 golden（含原有 6 个用例）
"""
import json
import os

PKG = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(PKG, "_src")
os.makedirs(SRC, exist_ok=True)

# 固定几何：tile = Mt x Nt，逻辑有效区 M x N（N < Nt 用于锻炼 masked/pad 路径）
Mt, Nt, M, N = 64, 32, 64, 16

DT = {
    "f16": dict(ptr="f16", np="float16", torch="torch.float16"),
    "f32": dict(ptr="f32", np="float32", torch="torch.float32"),
    "i32": dict(ptr="i32", np="int32", torch="torch.int32"),
}
IDENT = {
    ("sum", "f16"): "0.000000e+00", ("sum", "f32"): "0.000000e+00", ("sum", "i32"): "0",
    ("max", "f16"): "0xFC00",       ("max", "f32"): "0xFF800000",   ("max", "i32"): "-2147483648",
    ("min", "f16"): "0x7C00",       ("min", "f32"): "0x7F800000",   ("min", "i32"): "2147483647",
}
COMB = {
    "sum": dict(f="addf", i="addi", round="addf"),
    "max": dict(f="maxf", i="maxi", round=None),
    "min": dict(f="minf", i="mini", round=None),
}

MLIR = r"""// RUN: tile-opt --npu-pipeline="target=dav-351x" --cce-pipeline="target=dav-351x" %s | FileCheck --check-prefix=LLVM %s
// LLVM: llvm.func
module {{
  open_tile.module @open_tile.module {{
    entry @{name}(%in_ptr0: tile<ptr<{T}>>, %out_ptr0: tile<ptr<{T}>>) optimization_hints=<Ascend910B3 = {{num_warps = 4, occupancy = 1, warp_size = 32}}> {{
      %mmask = constant <i32: {M}> : !open_tile.tile<{Mt}xi32>
      %nmask = constant <i32: {N}> : !open_tile.tile<{Nt}xi32>
      %idx = constant <i32: {N}> : !open_tile.tile<{Mt}x1xi32>
      %x = constant <{T}: {IDENT}> : !open_tile.tile<{Mt}x{Nt}x{T}>
      %out_ptr0_0 = assume div_by<16>, %out_ptr0 : !open_tile.tile<!open_tile.ptr<{T}>>
      %in_ptr0_1 = assume div_by<16>, %in_ptr0 : !open_tile.tile<!open_tile.ptr<{T}>>
      %mblk_idx = iota : !open_tile.tile<{Mt}xi32>
      %nblk_idx = iota : !open_tile.tile<{Nt}xi32>
      %mmask_2 = cmpi less_than %mblk_idx, %mmask, signed : !open_tile.tile<{Mt}xi32> -> !open_tile.tile<{Mt}xi1>
      %nmask_3 = cmpi less_than %nblk_idx, %nmask, signed : !open_tile.tile<{Nt}xi32> -> !open_tile.tile<{Nt}xi1>
      %mask = reshape %mmask_2 : !open_tile.tile<{Mt}xi1> -> !open_tile.tile<{Mt}x1xi1>
      %mask_4 = reshape %nmask_3 : !open_tile.tile<{Nt}xi1> -> !open_tile.tile<1x{Nt}xi1>
      %mask_5 = broadcast %mask : !open_tile.tile<{Mt}x1xi1> -> !open_tile.tile<{Mt}x{Nt}xi1>
      %mask_6 = broadcast %mask_4 : !open_tile.tile<1x{Nt}xi1> -> !open_tile.tile<{Mt}x{Nt}xi1>
      %mask_7 = exti %mask_5  signed : !open_tile.tile<{Mt}x{Nt}xi1> -> !open_tile.tile<{Mt}x{Nt}xi16>
      %mask_8 = exti %mask_6  signed : !open_tile.tile<{Mt}x{Nt}xi1> -> !open_tile.tile<{Mt}x{Nt}xi16>
      %mask_9 = andi %mask_7, %mask_8 : !open_tile.tile<{Mt}x{Nt}xi16>
      %mask_10 = trunci %mask_9 : !open_tile.tile<{Mt}x{Nt}xi16> -> !open_tile.tile<{Mt}x{Nt}xi1>
      %idx_11 = reshape %mblk_idx : !open_tile.tile<{Mt}xi32> -> !open_tile.tile<{Mt}x1xi32>
      %idx_12 = muli %idx_11, %idx : !open_tile.tile<{Mt}x1xi32>
      %idx_13 = reshape %nblk_idx : !open_tile.tile<{Nt}xi32> -> !open_tile.tile<1x{Nt}xi32>
      %idx_14 = broadcast %idx_12 : !open_tile.tile<{Mt}x1xi32> -> !open_tile.tile<{Mt}x{Nt}xi32>
      %idx_15 = broadcast %idx_13 : !open_tile.tile<1x{Nt}xi32> -> !open_tile.tile<{Mt}x{Nt}xi32>
      %idx_16 = addi %idx_14, %idx_15 : !open_tile.tile<{Mt}x{Nt}xi32>
      %x_17 = reshape %in_ptr0_1 : !open_tile.tile<!open_tile.ptr<{T}>> -> !open_tile.tile<1x1x!open_tile.ptr<{T}>>
      %x_18 = broadcast %x_17 : !open_tile.tile<1x1x!open_tile.ptr<{T}>> -> !open_tile.tile<{Mt}x{Nt}x!open_tile.ptr<{T}>>
      %x_19 = offset %x_18, %idx_16 : !open_tile.tile<{Mt}x{Nt}x!open_tile.ptr<{T}>>, !open_tile.tile<{Mt}x{Nt}xi32> -> !open_tile.tile<{Mt}x{Nt}x!open_tile.ptr<{T}>>
      %x_20, %x_21 = load_ptr_tko weak %x_19, %mask_10, %x : !open_tile.tile<{Mt}x{Nt}x!open_tile.ptr<{T}>>, !open_tile.tile<{Mt}x{Nt}xi1>, !open_tile.tile<{Mt}x{Nt}x{T}> -> !open_tile.tile<{Mt}x{Nt}x{T}>, !open_tile.token optimization_hints=<Ascend910B3 = {{latency = 3}}>
      %ret = reduce %x_20 dim={DIM} identities=[{IDENT} : {T}] (%ret_a, %ret_b) : !open_tile.tile<{Mt}x{Nt}x{T}> -> !open_tile.tile<{OUT}x{T}> {{
        %ret_c = {COMB} %ret_a, %ret_b{SUFFIX} : !open_tile.tile<{T}>
        yield %ret_c : !open_tile.tile<{T}>
      }}
      %rshp = reshape %out_ptr0_0 : !open_tile.tile<!open_tile.ptr<{T}>> -> !open_tile.tile<1x!open_tile.ptr<{T}>>
      %bcast = broadcast %rshp : !open_tile.tile<1x!open_tile.ptr<{T}>> -> !open_tile.tile<{OUT}x!open_tile.ptr<{T}>>
      %0 = offset %bcast, {OIDX} : !open_tile.tile<{OUT}x!open_tile.ptr<{T}>>, !open_tile.tile<{OUT}xi32> -> !open_tile.tile<{OUT}x!open_tile.ptr<{T}>>
      %1 = store_ptr_tko weak %0, %ret, {OMASK} : !open_tile.tile<{OUT}x!open_tile.ptr<{T}>>, !open_tile.tile<{OUT}x{T}>, !open_tile.tile<{OUT}xi1> -> !open_tile.token
      return
    }}
  }}
}}
"""

golden_lines = [
    "import torch",
    "",
    "def _mat(flat, m, n):",
    "    return flat[: m * n].reshape(m, n)",
    "",
    "# ---- 既有 6 个用例 ----",
    "def min_dim1(x):  return _mat(x, 64, 16).float().min(dim=1).values.to(torch.float16)",
    "def max_dim0(x):  return _mat(x, 64, 8).max(dim=0).values",
    "def sum_dim1(x):  return _mat(x, 57, 3).float().sum(dim=1).to(torch.float16)",
    "def sum_dim0(x):  return _mat(x, 263, 1).float().sum(dim=0).to(torch.float16)",
    "def mean_dim1(x): return _mat(x, 263, 1).float().mean(dim=1).to(torch.float16)",
    "def mean_dim0(x): return _mat(x, 128, 3).float().mean(dim=0).to(torch.float16)",
    "",
    "# ---- 矩阵扩样用例 ----",
]

cases = []
for comb in ("sum", "max", "min"):
    for dim in (0, 1):
        for dt in ("f16", "f32", "i32"):
            name = f"otr_{comb}_d{dim}_{dt}"
            out_tile = Mt if dim == 1 else Nt      # reduce 输出 tile 宽度（= 全 tile 行/列）
            buf = M if dim == 1 else N             # 有效（被 store）元素数
            oidx = "%mblk_idx" if dim == 1 else "%nblk_idx"
            omask = "%mmask_2" if dim == 1 else "%nmask_3"
            mlir = MLIR.format(
                name=name, T=DT[dt]["ptr"], Mt=Mt, Nt=Nt, M=M, N=N, DIM=dim,
                IDENT=IDENT[(comb, dt)], COMB=(COMB[comb]["i"] if dt == "i32" else COMB[comb]["f"]),
                SUFFIX=(" signed" if (dt == "i32" and comb in ("max", "min"))
                        else (" rounding<nearest_even>" if (comb == "sum" and dt != "i32") else "")),
                OUT=out_tile, OIDX=oidx, OMASK=omask,
            )
            with open(os.path.join(SRC, f"{name}.opentile.mlir"), "w") as f:
                f.write(mlir)

            is_int = dt == "i32"
            if is_int:
                cfg_arg = {"name": "x", "kind": "input", "shape": [2048], "dtype": "int32",
                           "generate": "random", "seed": 0, "low": -1000, "high": 1000}
                out_dt = "int32"
            else:
                cfg_arg = {"name": "x", "kind": "input", "shape": [2048], "dtype": DT[dt]["np"],
                           "generate": "random", "seed": 0}
                out_dt = DT[dt]["np"]
            cfg = {
                "kernel_o": f"{name}.o", "kernel_name": name, "device": 0,
                "mix_mode": "aiv", "blocknum": 1,
                "golden": {"module_path": "golden_impl.py", "function": name},
                "args": [cfg_arg, {"name": "out", "kind": "output", "shape": [buf], "dtype": out_dt}],
            }
            with open(os.path.join(PKG, f"{name}.opentile.json"), "w") as f:
                json.dump(cfg, f, indent=2)

            # golden
            fn = f"def {name}(x): "
            if comb == "sum":
                if is_int:
                    fn += f"return _mat(x, {M}, {N}).sum(dim={dim})"
                else:
                    fn += f"return _mat(x, {M}, {N}).float().sum(dim={dim}).to({DT[dt]['torch']})"
            elif comb == "max":
                if is_int:
                    fn += f"return _mat(x, {M}, {N}).max(dim={dim}).values"
                else:
                    fn += f"return _mat(x, {M}, {N}).float().amax(dim={dim}).to({DT[dt]['torch']})"
            else:
                if is_int:
                    fn += f"return _mat(x, {M}, {N}).min(dim={dim}).values"
                else:
                    fn += f"return _mat(x, {M}, {N}).float().amin(dim={dim}).to({DT[dt]['torch']})"
            golden_lines.append(fn)
            cases.append(name)

with open(os.path.join(PKG, "golden_impl.py"), "w") as f:
    f.write("\n".join(golden_lines) + "\n")

print(f"generated {len(cases)} cases")
for c in cases:
    print("  ", c)
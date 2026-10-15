#!/usr/bin/env python3
"""生成 open_tile.reduce 端到端用例矩阵（combiner x dtype x axis x shape）。

产出：
  <PKG>/_src/<stem>.opentile.mlir   降级输入
  <PKG>/<stem>.opentile.json        kernel_runner 配置
  <PKG>/golden_impl.py              全部 golden（含基线 6 例）
  <PKG>/_cases.tsv                  用例清单: stem \t srcref \t atol \t rtol \t group

group:
  base | f16 | f32 | i8 | i16 | i32   上机用例（i8 单列，便于分批）
  gap                                 探针用例：规格声称支持但工具链未必打通的组合

用例集合：
  A) e2e 矩阵：{sum,max,min} x {i8,i16,i32,f16,f32} x {dim0,dim1} x {S1,S2,S3}
     已知不可编译的组合已剔除（见下），改由 B) 以探针形式覆盖。
  B) 探针(规格声称支持 / 实测未打通)：
     - mul(prod) x 全部 dtype x {dim0,dim1}
     - i64 x {sum,max,min} x {dim0,dim1}
     - bf16 x {sum,max,min} x {dim0,dim1}
     探针在 build_local.sh 里同样走完整降级链；失败原因（哪一层、什么报错）
     写入 _build_gaps.txt，作为规格表「NPU/CCE Dialect 降级支持 + 修复进度」的实测证据。
     探针不进 _e2e_cases.txt（未打通者无法上机；bf16 dim0 虽可编译但 harness 无法喂数）。

实测边界（dav-351x, CANN9.1 ccec / tilelang-toolchain）：
  - sum dim1 x {i8,i16}      : ccec 无法选择横向加 intrinsic
  - sum dim1 x bf16          : ccec vf stack 溢出
  - max/min dim1 x bf16      : tile-translate 不翻译 cce.vcmax/vcmin(vector<bf16>)
  - mul(prod) x 全部          : ccec vf stack 溢出（未走真归约，逐元素展开）
  - i64 x 全部                : cce-pipeline "typed i64 vector lowering is not implemented"
  - bf16（整体）              : dim1 不可降级；dim0 可降级但 numpy 无 bf16 类型，harness 无法喂数
"""
import json
import os

PKG = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(PKG, "_src")
os.makedirs(SRC, exist_ok=True)

# ---- 形状：tile = Mt x Nt，逻辑有效区 M x N；inbuf 为输入缓冲区元素数 ----
SHAPES = [
    dict(key="s1", tag="",    Mt=64,  Nt=32, M=64,  N=16, inbuf=2048),
    dict(key="s2", tag="_s2", Mt=128, Nt=32, M=100, N=20, inbuf=4096),
    dict(key="s3", tag="_s3", Mt=32,  Nt=64, M=32,  N=48, inbuf=2048),
]
S1 = SHAPES[0]

COMB = ("sum", "max", "min")
DTYPES = ("i8", "i16", "i32", "f16", "f32")
INT = {"i8", "i16", "i32", "i64"}

MLIR_T = {"i8": "i8", "i16": "i16", "i32": "i32", "i64": "i64",
          "f16": "f16", "bf16": "bf16", "f32": "f32"}
NP_DT = {"i8": "int8", "i16": "int16", "i32": "int32", "i64": "int64",
         "f16": "float16", "bf16": "bfloat16", "f32": "float32"}
TORCH_DT = {"i8": "torch.int8", "i16": "torch.int16", "i32": "torch.int32",
            "i64": "torch.int64", "f16": "torch.float16", "bf16": "torch.bfloat16",
            "f32": "torch.float32"}

# 归约 identity（含乘性单位元，供 mul 探针使用）
IDENT_FLOAT = {
    ("sum", "f16"): "0.000000e+00", ("sum", "f32"): "0.000000e+00", ("sum", "bf16"): "0.000000e+00",
    ("mul", "f16"): "0x3C00",       ("mul", "f32"): "0x3F800000",   ("mul", "bf16"): "0x3F80",
    ("max", "f16"): "0xFC00",       ("max", "f32"): "0xFF800000",   ("max", "bf16"): "0xFF80",
    ("min", "f16"): "0x7C00",       ("min", "f32"): "0x7F800000",   ("min", "bf16"): "0x7F80",
}
IDENT_INT = {
    ("sum", "i8"): "0", ("sum", "i16"): "0", ("sum", "i32"): "0", ("sum", "i64"): "0",
    ("mul", "i8"): "1", ("mul", "i16"): "1", ("mul", "i32"): "1", ("mul", "i64"): "1",
    ("max", "i8"): "-128", ("max", "i16"): "-32768", ("max", "i32"): "-2147483648",
    ("max", "i64"): "-9223372036854775808",
    ("min", "i8"): "127", ("min", "i16"): "32767", ("min", "i32"): "2147483647",
    ("min", "i64"): "9223372036854775807",
}
COMB_OP = {
    "sum": {"f": "addf", "i": "addi"},
    "mul": {"f": "mulf", "i": "muli"},
    "max": {"f": "maxf", "i": "maxi"},
    "min": {"f": "minf", "i": "mini"},
}

# 输入取值范围：max/min 可用窄类型全域；sum 需保证真值不溢出输出类型，故收敛范围
RANGE = {
    "max": {"i8": (-128, 128), "i16": (-32768, 32768), "i32": (-1000, 1000), "i64": (-1000, 1000)},
    "min": {"i8": (-128, 128), "i16": (-32768, 32768), "i32": (-1000, 1000), "i64": (-1000, 1000)},
    "sum": {"i8": (-1, 2), "i16": (-100, 101), "i32": (-1000, 1000), "i64": (-100, 101)},
    "mul": {"i8": (1, 2), "i16": (1, 2), "i32": (1, 2), "i64": (1, 2)},
}
RANGE_FLOAT = {"sum": (None, None), "mul": (None, None), "max": (None, None), "min": (None, None)}


# 精度阈值
def tol(comb, dt, is_gap=False):
    if is_gap:
        return 0.0, 0.0
    if comb in ("max", "min"):
        return 0.0, 0.0
    if dt in INT:
        return 0.0, 0.0
    if dt == "f16":
        return 0.5, 0.02
    return 0.01, 0.01


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
    "# ---- 基线 6 例（既有 FullPipeline 用例）----",
    "def min_dim1(x):  return _mat(x, 64, 16).float().min(dim=1).values.to(torch.float16)",
    "def max_dim0(x):  return _mat(x, 64, 8).max(dim=0).values",
    "def sum_dim1(x):  return _mat(x, 57, 3).float().sum(dim=1).to(torch.float16)",
    "def sum_dim0(x):  return _mat(x, 263, 1).float().sum(dim=0).to(torch.float16)",
    "def mean_dim1(x): return _mat(x, 263, 1).float().mean(dim=1).to(torch.float16)",
    "def mean_dim0(x): return _mat(x, 128, 3).float().mean(dim=0).to(torch.float16)",
    "",
    "# ---- 矩阵用例 (comb x dtype x axis x shape) ----",
]

BASE = [
    ("triton_min_dim1",  "fp:test_min_dim1",  0.0,   0.0),
    ("triton_max_dim0",  "fp:test_max_dim0",  0.0,   0.0),
    ("triton_sum_dim1",  "fp:test_sum_dim1",  0.02,  0.02),
    ("triton_sum_dim0",  "fp:test_sum_dim0",  0.5,   0.01),
    ("triton_mean_dim1", "fp:test_mean_dim1", 0.002, 0.01),
    ("triton_mean_dim0", "fp:test_mean_dim0", 0.01,  0.01),
]

manifest = []
for stem, ref, a, r in BASE:
    manifest.append((stem, ref, a, r, "base"))


def emit(name, comb, dim, dt, sh, is_gap):
    """写 mlir + json + golden 定义，返回 manifest 项。"""
    Mt, Nt, M, N = sh["Mt"], sh["Nt"], sh["M"], sh["N"]
    is_int = dt in INT
    ident = IDENT_INT[(comb, dt)] if is_int else IDENT_FLOAT[(comb, dt)]
    if is_int and comb in ("max", "min"):
        suffix = " signed"
    elif (not is_int) and comb in ("sum", "mul"):
        suffix = " rounding<nearest_even>"
    else:
        suffix = ""
    mlir = MLIR.format(
        name=name, T=MLIR_T[dt], Mt=Mt, Nt=Nt, M=M, N=N, DIM=dim,
        IDENT=ident, COMB=COMB_OP[comb]["i"] if is_int else COMB_OP[comb]["f"],
        SUFFIX=suffix, OUT=Mt if dim == 1 else Nt,
        OIDX="%mblk_idx" if dim == 1 else "%nblk_idx",
        OMASK="%mmask_2" if dim == 1 else "%nmask_3",
    )
    with open(os.path.join(SRC, f"{name}.opentile.mlir"), "w") as f:
        f.write(mlir)

    out = M if dim == 1 else N
    arg = {"name": "x", "kind": "input", "shape": [sh["inbuf"]],
           "dtype": NP_DT[dt], "generate": "random", "seed": 0}
    if is_int:
        lo, hi = RANGE[comb][dt]
        arg["low"], arg["high"] = lo, hi
    cfg = {
        "kernel_o": f"{name}.o", "kernel_name": name, "device": 0,
        "mix_mode": "aiv", "blocknum": 1,
        "golden": {"module_path": "golden_impl.py", "function": name},
        "args": [arg, {"name": "out", "kind": "output", "shape": [out], "dtype": NP_DT[dt]}],
    }
    with open(os.path.join(PKG, f"{name}.opentile.json"), "w") as f:
        json.dump(cfg, f, indent=2)

    g = f"def {name}(x): return _mat(x, {M}, {N})"
    op = {"sum": "sum", "mul": "prod", "max": "max", "min": "min"}[comb]
    if comb == "max":
        g += (".max(dim=%d).values" % dim) if is_int else (".float().amax(dim=%d).to(%s)" % (dim, TORCH_DT[dt]))
    elif comb == "min":
        g += (".min(dim=%d).values" % dim) if is_int else (".float().amin(dim=%d).to(%s)" % (dim, TORCH_DT[dt]))
    else:
        g += (".%s(dim=%d)" % (op, dim)) if is_int else (".float().%s(dim=%d).to(%s)" % (op, dim, TORCH_DT[dt]))
    golden_lines.append(g)

    a, r = tol(comb, dt, is_gap)
    group = "gap" if is_gap else ("i8" if dt == "i8" else ("i16" if dt == "i16" else ("i32" if dt == "i32" else dt)))
    return (name, f"src:{name}", a, r, group)


# ---- A) e2e 矩阵 ----
n_new = 0
for sh in SHAPES:
    for comb in COMB:
        for dim in (0, 1):
            dts = ("i32", "f16", "f32") if (comb == "sum" and dim == 1) else DTYPES
            for dt in dts:
                manifest.append(emit(f"otr_{comb}_d{dim}_{dt}{sh['tag']}", comb, dim, dt, sh, False))
                n_new += 1

# ---- B) 探针：规格声称支持但工具链未必打通 ----
GAP_PROBES = (
    [("mul", dt, d) for dt in ("i8", "i16", "i32", "i64", "f16", "bf16", "f32") for d in (0, 1)]
    + [(c, "i64", d) for c in ("sum", "max", "min") for d in (0, 1)]
    + [(c, "bf16", d) for c in ("sum", "max", "min") for d in (0, 1)]
)
n_gap = 0
for comb, dt, dim in GAP_PROBES:
    manifest.append(emit(f"otg_{comb}_d{dim}_{dt}", comb, dim, dt, S1, True))
    n_gap += 1

with open(os.path.join(PKG, "golden_impl.py"), "w") as f:
    f.write("\n".join(golden_lines) + "\n")

with open(os.path.join(PKG, "_cases.tsv"), "w") as f:
    for stem, ref, a, r, g in manifest:
        f.write(f"{stem}\t{ref}\t{a}\t{r}\t{g}\n")

print(f"e2e matrix: {n_new} (+ baseline {len(BASE)}) ; gap probes: {n_gap} ; total {len(manifest)}")
print("shapes: " + ", ".join(f"{s['key']}={s['Mt']}x{s['Nt']}(valid {s['M']}x{s['N']})" for s in SHAPES))
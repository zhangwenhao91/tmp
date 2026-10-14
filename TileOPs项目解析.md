# TileOPs 项目解析与昇腾接入方案

分析日期：2026-10-14。分析对象：WSL `/home/hpc/gitProject/TileOPs`，提交 `a79a21e408d99cbd1363b7a3277c60c790995bc3`。

目标环境：用户确认 NPU 架构 351x，服务器 CANN 包为 `Ascend/9.2.0.B092/cann-9.2.0`。具体卡型号、核心数、峰值算力、HBM 带宽仍待确认。本文为源码静态分析，没有在服务器运行 NPU 编译或性能测试。期限暂按 2026-12-30 理解。

## 1. 核心结论

1. TileOPs 是基于 TileLang 的算子库，主体为 Python，设备代码由 JIT 编译生成；不能按是否出现 `.cu` 文件判断 GPU 实现。
2. 项目分为 Manifest 规格、Op API/调度、Kernel 设备实现三层，测试和 benchmark 共用 workload 的输入与数值参考。
3. Manifest 声明 205 个公共 Op：189 个 `implemented`，16 个 `spec-only`。这是规格状态统计，不等于 189 个独立设备 Kernel，也不证明在当前机器运行成功，更不证明昇腾支持。
4. 仓库已有第三方 backend 接入机制：`tileops.backends` entry point、设备 detector、每个 Op 的 kernel builder。建议利用它接入昇腾。
5. 测试可选择设备和 target，但 benchmark、硬件 profile、部分参考实现、依赖版本仍偏向 CUDA，不能只写 Kernel 就认为接入完成。
6. 现有仓库评分是 Roofline/SOL efficiency，不能直接作为标准 MFU。150 个算子的验收需先统一性能口径及计数口径。

## 2. 当前项目结构

```text
TileOPs/
├── src/tileops/
│   ├── gemm.py, norm.py, elementwise.py, ...  # 面向用户的 family 导出
│   ├── manifest/
│   │   ├── spec/*.yaml                      # 算子签名、workloads、roofline、状态
│   │   └── signature.py, plan.py, ...       # 规格解析与检查
│   ├── ops/                                # L2：Op 类、参数、检查、调度
│   │   ├── op_base.py
│   │   ├── _signature_codegen.py           # 由规格生成检查、输出推断等
│   │   ├── compile_boundary.py             # torch.compile 的算子边界
│   │   └── gemm/, norm/, attention/, ...
│   ├── kernels/                            # L1：TileLang Kernel、接口、配置
│   │   ├── kernel_base.py
│   │   ├── call_spec.py                     # 调用信息与设备信息
│   │   └── gemm/, norm/, attention/, ...
│   ├── backend/                            # 后端发现、注册、target 分派
│   ├── csrc/                               # GPU 用 C++/CUDA helper headers
│   ├── perf/                               # 运算量、带宽与性能模型
│   │   └── profiles/h200.yaml, h20_3e.yaml
│   ├── trace/                              # Kernel 时间线等工具
│   └── utils/
├── workloads/                              # 输入生成、reference、数值验证
├── tests/                                  # 正确性、接口、注册和规格测试
├── benchmarks/                             # 基准、竞品、计时、报告、硬件校准
├── scripts/                                # 规格校验、lint、打包与 CI 工具
├── docs/design/                            # 架构与边界规范
├── .github/workflows/                      # 当前 GPU CI
└── pyproject.toml                          # 包发现、依赖与发布
```

Manifest 是公共语义的事实来源，不存 Kernel 选择策略。Op 层不写 TileLang 设备程序；Kernel 层不重复实现用户输入检查。一个 Op 可对应多个 Kernel 实现；复合 Op 可调用多个子 Op。

## 3. GPU 实现在哪里

### 3.1 以 GEMM 为入口追踪

```text
from tileops.gemm import GemmFwdOp
  → src/tileops/gemm.py                  # 公共导出
  → src/tileops/ops/gemm/gemm.py         # GemmFwdOp
  → Op.__call__ / _run_call             # 规格检查、选择 target
  → 内置路径：GemmFwdOp.forward
  → kernel_for("gemm", GemmCall(...))   # 接口选择与 specialization 缓存
  → GemmTMAKernel / GemmCpAsyncKernel / GemvKernel
  → src/tileops/kernels/gemm/dense.py
  → @tilelang.jit + @T.prim_func        # 定义/编译设备程序
  → CUDA 设备执行
```

`kernel_types` 登记候选实现，`interfaces` 定义 Kernel 契约。选择先过滤 `devices`、`supported_archs`，再看 `refusal(call)`，候选重叠时由 `general`、`preferred_over` 决定优先关系。`entry_for` 提供构建身份和延迟构建函数。

### 3.2 明确的 CUDA 证据

| 证据 | 源码位置 | 说明 |
|---|---|---|
| `Kernel.devices = frozenset({"cuda"})` | `kernels/kernel_base.py` | 内置 Kernel 默认运行于 CUDA |
| `supported_archs` 与 SM 查询 | `kernels/gemm/dense.py`、`utils/utils.py` | NVIDIA compute capability/SM 架构筛选 |
| `tilelang.cuda.intrinsics...wgmma_macro_generator` | `kernels/gemm/dense.py` | 直接引用 CUDA WGMMA intrinsic emitter |
| TMA、WGMMA、warpgroup、barrier | `kernels/gemm/dense.py` | NVIDIA 专用数据搬运与矩阵乘机制 |
| `T.Kernel(..., threads=...)`、shared/fragment | `kernels/gemm/dense.py` | 网格、线程、共享存储与累加器组织 |
| `dense_wgmma_helper.h` 等 | `csrc/` | 部分低层 GPU helper |
| CUDA events、CUPTI | `benchmarks/timing.py` | GPU 计时与设备活动统计 |

例如 `dense.py` 的 `_gemm_kernel` 在 `@tilelang.jit` 内构造 `@T.prim_func`；采用 256 threads、shared memory 多阶段环形缓存、fragment 累加器与生产者/消费者同步。这些实现不能通过替换 `device="cuda"` 为 `"npu"` 完成移植。简单逐元素算法可以复用语义与组织思路，硬件特定的内存、指令和同步必须重写。

TileOPs 层的 `target="ascend"` 是算子后端路由名；TileLang 编译器的 `target="tile"` 是下层编译目标；`dav-351x` 又是 NPU→CCE 阶段的目标。三个名字处于不同层次。

## 4. 算子分类与数量

统计使用项目自己的 `tileops.manifest.load_manifest()`，以公共 Op key 为单位；FP8、前向/反向、带索引输出等独立公共 key 单独计数。完整 205 个名字见附录。

| 功能类别 | family | 已实现 | 仅规格 | 主要内容 |
|---|---|---:|---:|---|
| 逐元素 | elementwise | 70 | 0 | 算术、比较、逻辑/位运算、激活、数学函数、门控融合、mask、dropout、位置编码辅助 |
| 归约与扫描 | reduction | 19 | 0 | Softmax/LogSoftmax、Sum/Mean、Max/Min、方差、Argmax、逻辑归约、VectorNorm、Cumsum/Cumprod |
| 池化 | pool | 13 | 0 | Avg/Max Pool 1D/2D/3D、返回索引变体、自适应池化、MeanPooling |
| 注意力 | attention | 12 | 8 | GQA、MHA decode、MLA decode、DSA decode、NSA、FP8 indexer、TopKSelect |
| MoE | moe | 12 | 0 | 路由 TopK、排列/对齐、专家 GEMM/MLP、融合 MoE、shared expert |
| 归一化 | norm | 10 | 2 | RMSNorm、LayerNorm、AdaLayerNorm、融合 AddNorm、Batch/Group/InstanceNorm |
| 量化 | quantization | 10 | 0 | FP8、INT8 per tensor/channel/block、INT4 per group、SmoothQuant、INT8 反量化 |
| 线性注意力 | linear_attention | 10 | 0 | DeltaNet、GDN、KDA、GLA、recurrent/chunk、部分 backward |
| Mamba/状态空间 | mamba | 7 | 3 | SSD chunk 各阶段、recurrent、Mamba2 |
| 矩阵乘 | gemm | 6 | 2 | GEMM、FP8 GEMM、W4A16、GroupedGEMM、BMM、FP8 BMM |
| 采样 | sampling | 6 | 0 | TopK/TopP/MinP masks、概率采样、推测采样 |
| RoPE | rope | 5 | 0 | 标准 RoPE、Llama3.1、YaRN、LongRoPE、NeoX position IDs |
| 序列建模 | sequence_modeling | 5 | 0 | Engram gate/conv/decode、MHC pre/post |
| 卷积 | convolution | 3 | 0 | Conv1D/2D/3D forward |
| FFT | fft | 1 | 0 | Complex-to-complex FFT |
| 变换 | transform | 0 | 1 | Hadamard，仅规格 |
| **总计** | **16 个 family** | **189** | **16** | **205 个公共 Op** |

16 个仅规格条目：

- attention：`GQAPagedFwdOp`、`MLAPagedFwdOp`、`MLAVarlenFwdOp`、`PagedKVCacheWriteFwdOp`、`MLAKVCacheWriteFwdOp`、`MergeAttentionStatesFwdOp`、`DSAPagedFwdOp`、`PagedKVCacheGatherFwdOp`。
- gemm：`GemmINT8W8A8FwdOp`、`GemmW4A8FwdOp`。
- mamba：`CausalConv1dFwdOp`、`CausalConv1dUpdateFwdOp`、`SelectiveScanFwdOp`。
- norm：`FusedAddRMSNormPerTokenQuantFwdOp`、`FusedQKNormRoPEFwdOp`。
- transform：`HadamardTransformFwdOp`。

`implemented` 不能用来记录某后端是否完成。建议另建 backend 支持矩阵，逐行记录 Op、shape、dtype、布局、芯片、CANN、正确性、计时、MFU、SOL、验收状态。复合算子和基础算子的计数是否都算入 150 项，要由验收方确认。

## 5. 昇腾目录组织与注册

### 5.1 推荐：同一个 Git 仓内，增加独立 backend 子包

以下是建议的新布局，当前仓库尚未创建这些目录。

```text
TileOPs/
├── src/tileops/                           # 保留公共规格与 API
├── backends/ascend/
│   ├── pyproject.toml                    # 独立包，注册 entry point
│   ├── src/tileops_ascend/
│   │   ├── __init__.py                    # 触发注册，不编译 Kernel
│   │   ├── registration.py               # detector 与 builder 清单
│   │   ├── builders/
│   │   │   ├── gemm.py
│   │   │   ├── elementwise.py
│   │   │   └── norm.py
│   │   ├── kernels/
│   │   │   ├── gemm/dav351x/
│   │   │   ├── elementwise/dav351x/
│   │   │   └── norm/dav351x/
│   │   ├── runtime/                      # 编译/缓存/启动、环境查询适配
│   │   └── tuning/                       # NPU 配置与优化策略
│   ├── tests/                            # NPU 专属、编译/ABI/运行测试
│   └── support_matrix.yaml               # 后端支持与验收进度，建议新增
├── benchmarks/                           # 共用 workload 与报告，扩展设备计时
└── src/tileops/perf/profiles/             # 接入实际 NPU profile，需先扩展模型
```

优点是仍在 TileOPs 仓完成开发，但昇腾编译栈有独立依赖与包入口。主包采用 `src` 包发现，因此顶层 `backends/ascend` 不会自动成为主包内容；需要显式安装/发布该子包。也可把 `tileops_ascend` 放入根 `src/` 并在根 pyproject 注册，技术上可行，但会把主包发布和后端依赖耦合起来。

### 5.2 利用现有全 Op builder 协议

子包 `pyproject.toml` 的关键配置（完整文件还需 name、version、build-system、依赖等）：

```toml
[project.entry-points."tileops.backends"]
ascend = "tileops_ascend"

[tool.setuptools.packages.find]
where = ["src"]
```

`tileops_ascend/__init__.py`：

```python
from . import registration  # 导入时注册，不在这里编译
```

`registration.py` 的示例骨架：

```python
from tileops.backend import register_detector, register_kernel_builder
from .builders.gemm import build_gemm

register_detector("ascend", lambda device: device.type == "npu")
register_kernel_builder("GemmFwdOp", "ascend", build_gemm)
```

`builders/gemm.py` 的协议示例（`AscendGemm` 是待开发实现，并非项目现有类）：

```python
from tileops.backend import TensorSpec, OpNotAvailableError

def build_gemm(a: TensorSpec, b: TensorSpec, *, trans_a=False, trans_b=True):
    # 这里可检查本实现的 shape/dtype/芯片支持范围。
    # 不支持时给出明确诊断，不静默改用 CUDA 或高层 PyTorch 算子。
    from ..kernels.gemm.dav351x.gemm import AscendGemm
    return AscendGemm(a, b, trans_a=trans_a, trans_b=trans_b)
```

Builder 收到的是每个输入的 `TensorSpec(device, dtype, shape)`，不是 Tensor 数据；构造参数来自 Manifest `signature.params`，按关键字传入。缺省的可选输入保留 `None` 槽位。返回值必须可调用，执行时按输入顺序收到真实 Tensor，并可能收到 `out` 等写入缓冲区及执行参数。输出 dtype、shape、mutation、alias 必须符合同一个 Manifest。

### 5.3 用户调用与实际下发

```python
import torch
import torch_npu                   # 初始化实际安装的 NPU 扩展
from tileops.gemm import GemmFwdOp

a = torch.randn(1024, 1024, dtype=torch.float16, device="npu:0")
b = torch.randn(1024, 1024, dtype=torch.float16, device="npu:0")
op = GemmFwdOp(target="ascend")
c = op(a, b)                       # 默认 NT：a @ b.T
assert op.serving_target == "ascend"
```

自动检测可以省略 `target="ascend"`；也可以调用 `tileops.set_default_target("ascend")`。显式 target 优先于进程默认，默认优先于设备检测。后端需先安装或显式导入以完成注册。

```text
安装 backend → entry point 被首次 Op 构造发现 → 导入模块并注册
  → Op 调用、Manifest 检查
  → 选择 ascend target
  → 按 (Op 名字, ascend) 找到 builder
  → 传 TensorSpec + Manifest params，延迟编译/构建
  → 返回 callable，按设备/输入 dtype/shape 缓存
  → callable 收到 Tensor → NPU runtime 下发 → 输出检查
```

已有公共 Op 的昇腾实现通常无需复制 Op 类、无需重复添加 Manifest key，也不需要每写一个 Kernel 都注册 `torch.library`；公共 compile boundary 由主框架处理。必须通过 `op(...)` 调用，直接 `op.forward(...)` 会绕开公共路由。

一个 target 注册 builder 后会接管整个 Op；它负责自身内部 Kernel 选择。目标已选为 ascend 而缺少某非复合 Op builder 时会报 `OpNotAvailableError`，不会自动回退 CUDA。纯复合 Op（自身 `kernel_types` 为空）可以不注册顶层 builder，由组合层继续调子 Op，并传递 target；要逐个确认子 Op 及组合逻辑兼容性。

`request_tune()` 不会把调优请求传给全 Op builder，主框架会提示。因此后端需要自行管理调优和配置缓存，不能认为已有 GPU autotune 会自动适用。

### 5.4 另一条已有路径：注册 Kernel 类型

```python
register_kernel_type("GemmFwdOp", "ascend_gemm_351x", AscendGemmKernel)
```

适用于实现既有 `GemmFwdInterface` 的 Kernel 类，并与其他实现一起选择。类必须继承对应接口，设置 `devices = frozenset({"npu"})`，实现 `entry_for`/`refusal`/`forward` 等必要契约，避免沿用 CUDA 的 `supported_archs`、SM 查询与 CUDA 调优路径。接口重叠时明确 `preferred_over`。

这条路径与整 Op target builder 是不同接入方式：`register_kernel_type` 本身不会给 `target="ascend"` 注册 builder。对 150 个算子的首轮跨设备接入，建议统一采用全 Op builder；确定需要共享细粒度接口时再采用 Kernel 类型注册。

## 6. 351x 编译链与项目接入差距

本地已有 `tilelang-mlir-ascend` 和 `OpenTileAS` 可作为候选编译/runtime 基础。源码可确认以下路径，不等于当前服务器端已经验证：

```text
昇腾 TileLang DSL
  → @tilelang.jit(target="tile", execution_backend="tile_obj", ...)
  → TileLangIR/MLIR
  → OpenTileAS：NPU conversion、memory planning、split/sync 等 passes
  → --cce-pipeline=target=dav-351x
  → tile-translate：LLVM IR
  → CCEC：dav-c310-cube / dav-c310-vec，按 AIC/AIV/MIX 选择
  → object bytes + launch metadata
  → TileKernelAdapter / TileObjectKernel
  → ACL runtime，使用当前 NPU stream 下发
```

证据：前端仓 `tilelang/jit/kernel.py`、`tilelang/opentile/compiler.py`、`tilelang/jit/adapter/tile.py`、`tilelang/opentile/tile_obj.py`。`compiler.py` 已使用 351x 的 CCE pipeline。自动编译当前要求静态 Tensor shape，launch contract/ABI 与 MIX 轴组织有明确限制。适配 150 个算子前，应先用纯 AIV、纯 AIC、MIX 三类代表用例验证这一整条链。

| 接入事项 | 当前情况 | 昇腾工作 |
|---|---|---|
| 公共 Op、Manifest | 已有可复用协议 | 沿用语义，不能为当前实现任意缩窄公共规格 |
| backend 注册 | 已有 | 新增 ascend 子包、detector、builders |
| 设备 Kernel | 大量 CUDA 专用实现 | 以 351x Cube/Vector、UB/L1/L0、格式和同步重写 |
| Python/torch/TileLang | 根包固定 Python 3.12、torch 2.13、TileLang 0.1.12 | 建立与实际 torch_npu、CANN 9.2.0.B092、昇腾前端兼容的版本矩阵 |
| 导入 | 部分 family 导出会导入 CUDA Kernel 与 intrinsic 模块 | 先做 NPU-only 环境 import smoke，必要时改为延迟加载内置 Kernel |
| 正确性测试 | `--tileops-device`、`--tileops-target` 已有 | 复用通用用例；处理 CUDA marker/skip；增加 NPU 专属用例 |
| 参考实现 | 部分用 PyTorch，部分依赖 FLA/外部 GPU 库 | 检查 reference 能否在 NPU 上运行；必要时提供可靠 CPU 参考 |
| benchmark | CUDA events/CUPTI，非 CUDA 被明确拒绝 | 新增 NPU event/profiler 计时、同步、拷贝与 host latency 统计 |
| 性能 profile | H200、H20-3e；tensor_core/cuda_core 语义 | 扩展 NPU Cube/Vector profile、设备识别、roof key 与 effective 计算 |
| CI | 当前 GPU runner/依赖 | 增加对应 CANN/torch_npu 的 NPU runner 与结果归档 |

不能直接把根项目 requirements 安装到既有昇腾环境里就认为兼容：两个前端都占用 `tilelang` 包名，必须决定 NPU 环境安装哪个发行版/源码，并同步调整主包依赖声明和约束。CANN 路径只是版本信息，不提供整卡性能上限。

测试参数示意，在依赖、backend 和 NPU 扩展已正确加载后运行：

```bash
python -m pytest tests/ops/test_gemm.py \
  --tileops-device=npu:0 --tileops-target=ascend
```

这仅是现有测试入口，不能保证整文件所有 CUDA 特例都适用于 NPU。测试 harness 需要在设置设备前加载 torch_npu。benchmark 不能只套用同样参数，目前会拒绝非 CUDA 设备。

## 7. MFU ≥95% 的验收必须明确

标准计算利用率：

```text
MFU = useful_FLOPs / (actual_time × theoretical_peak_FLOPs_per_second)
```

仓库 SOL：

```text
memory_time  = minimum_bytes / effective_HBM_bandwidth
compute_time = declared_FLOPs / effective_compute_peak
SOL          = max(memory_time, compute_time) / measured_time
```

区别有三点：SOL 同时考虑访存，使用校准后的 effective roof，且仓库对 exp、比较等采用约定的 FLOP 计数（每元素一次），不是逐条硬件指令的成本。不能把 SOL 95% 改名为 MFU 95%。小 shape 还可能被 launch latency 主导；SFU/复杂指令可能需要更细的上限模型。

对内存受限算子，设运算强度 I=FLOPs/bytes、带宽 B、计算峰值 P，则理想访存条件下也有：

```text
MFU ≤ min(1, I × B / P)
```

因此逐元素、搬运、某些归约即使带宽利用率极高，也可能无法达到按整卡峰值定义的 95% MFU。位运算/纯搬运的浮点口径更需单独约定。若验收实际意图是“达到各算子理论上限的95%”，SOL 更接近这个表述；若是“达到参考实现性能95%”，又是另一指标。应让验收方提供原始公式。

建议同时保存 MFU、SOL、带宽利用率、时延与正确性，不用一个数字掩盖差异。性能验收还需冻结：物理设备与核心数、输入 shape/dtype/布局、稠密峰值及计算单元、全算子或单 Kernel 计时、预热/编译是否排除、重复次数与统计方式、逐 case 或聚合达标。

## 8. 150 个算子的推进建议

1. 先完成后端安装/发现、公共 API import、编译和运行的最小闭环；挑 Add（AIV）、GEMM（AIC）、带后处理的 GEMM（MIX）做代表验证。
2. 在现有 189 个已实现 Op 里选定 150 个公共 key；不要用 Kernel 文件数、shape 数或 dtype 变体凑计数。明确复合算子的计数规则和必要支持范围。
3. 候选优先覆盖易于共享设备模板的基础族：elementwise 70、reduction 19、norm 10、pool 13、convolution 3、quantization 10、rope 5、gemm 6，共 136 个；其余 14 个按业务优先级从 attention/MoE/linear_attention/sampling 等选取。136 只是范围统计，不是复杂度或性能承诺。
4. AIV 基础族与 Cube 计算族建立不同的调优模板；共享输入/参考/验证，保留每个公共 Op 的清晰语义。
5. 分别跟踪“规格确认→实现→编译→上板正确→性能达标→CI→评审/合并”，只有满足约定的验收范围才计为完成。每个 case 的 skip 都记录原因，不能把 skip 计为通过。
6. 到 12 月 30 日的排期需要结合人数、测试卡数量、实际设备型号和95%口径；当前源码分析不足以承诺150项全部达到标准MFU95%。

## 9. 主要依据

- `docs/design/architecture.md`：两层实现与 M1–M8 模块。
- `docs/design/layer-boundaries.md`：公共规格、实现、workload、测试与 benchmark 边界。
- `docs/design/ops-design.md`：target/Kernel 注册、组合 Op、缓存与调优规则。
- `docs/design/manifest.md`、`src/tileops/manifest/`：公共 key 与规格状态。
- `src/tileops/backend/{__init__,registry,dispatch,protocol}.py`：实际后端发现、构建与选择协议。
- `src/tileops/ops/op_base.py`：调用链、builder 缓存、缺失 builder 行为与调优限制。
- `src/tileops/kernels/gemm/dense.py`、`kernels/kernel_base.py`：CUDA 设备实现证据。
- 根 `conftest.py`、`workloads/device.py`：测试设备和 target 配置。
- `benchmarks/{conftest,api,timing}.py`：CUDA 专属计时及设备拒绝。
- `docs/design/roofline.md`、`src/tileops/perf/profile.py`：SOL 定义、校准上限与 profile schema。
- `pyproject.toml`：实际依赖锁定与包发现。


## 附录：完整算子清单与中文功能说明

以下按当前仓库 Manifest 的公共算子名称统计，共 **205 个**：**已实现 189 个，未实现（仅有规格）16 个**。

**状态说明：**“已实现”表示 Manifest 已标记存在实现，当前内置实现面向 GPU/CUDA；不表示支持昇腾，也不表示在本次分析中验证过正确性或性能。“未实现（仅有规格）”表示已有接口与语义声明，尚未标记实现完成。功能注释用于概述，具体 shape、dtype、布局、参数及副作用以 Manifest 为准。

### 注意力（attention）

共 20 个：已实现 12 个，未实现（仅有规格）8 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `GQADenseFwdOp` | 稠密分组查询注意力，多个查询头共享键和值头。 | 已实现 |
| `GQAVarlenFwdOp` | 处理批内不同序列长度的分组查询注意力。 | 已实现 |
| `GQAPagedFwdOp` | 通过分页键值缓存计算分组查询注意力。 | 未实现（仅有规格） |
| `GQAPrefillPagedWithKVCacheFwdOp` | 预填充阶段写入分页键值缓存并计算分组查询注意力。 | 已实现 |
| `GQABwdOp` | 分组查询注意力的梯度计算。 | 已实现 |
| `MHADecodePagedWithKVCacheFwdOp` | 使用分页键值缓存完成多头注意力解码。 | 已实现 |
| `MLADecodeWithKVCacheFwdOp` | 使用键值缓存完成多头潜在注意力（MLA）解码。 | 已实现 |
| `DSADecodeWithKVCacheFwdOp` | 按选定索引访问键值缓存，完成稀疏注意力解码。 | 已实现 |
| `NSACompressedVarlenFwdOp` | 对变长序列的压缩键和值计算原生稀疏注意力。 | 已实现 |
| `NSATopKVarlenFwdOp` | 为变长原生稀疏注意力选择得分最高的若干块。 | 已实现 |
| `NSAVarlenFwdOp` | 按已选块索引计算变长原生稀疏注意力。 | 已实现 |
| `MLAPagedFwdOp` | 使用分页潜在键值缓存计算 MLA 注意力。 | 未实现（仅有规格） |
| `MLAVarlenFwdOp` | 计算支持不同序列长度的 MLA 注意力。 | 未实现（仅有规格） |
| `PagedKVCacheWriteFwdOp` | 按槽位映射将键和值写入分页缓存。 | 未实现（仅有规格） |
| `MLAKVCacheWriteFwdOp` | 组合 MLA 潜在键值与位置分量，并写入缓存。 | 未实现（仅有规格） |
| `MergeAttentionStatesFwdOp` | 依据归一化统计合并两组注意力输出状态。 | 未实现（仅有规格） |
| `DSAPagedFwdOp` | 通过分页键值缓存和选定索引计算稀疏注意力。 | 未实现（仅有规格） |
| `PagedKVCacheGatherFwdOp` | 按页表收集键值缓存，可按规格执行反量化。 | 未实现（仅有规格） |
| `FP8LightningIndexerFwdOp` | 计算 FP8 注意力索引得分，为稀疏选择提供依据。 | 已实现 |
| `TopKSelectFwdOp` | 在指定候选区间选择得分最高的 K 个索引。 | 已实现 |

### 卷积（convolution）

共 3 个：已实现 3 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `Conv1dFwdOp` | 一维卷积前向计算。 | 已实现 |
| `Conv2dFwdOp` | 二维卷积前向计算。 | 已实现 |
| `Conv3dFwdOp` | 三维卷积前向计算。 | 已实现 |

### 逐元素计算（elementwise）

共 70 个：已实现 70 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `PreluFwdOp` | 带可学习负半轴斜率的 PReLU 激活。 | 已实现 |
| `MaskedFillTensorFwdOp` | 按布尔掩码用张量给定的值填充元素。 | 已实现 |
| `MaskedFillScalarFwdOp` | 按布尔掩码用标量填充元素。 | 已实现 |
| `AddFwdOp` | 逐元素加法，支持广播及对第二个输入乘以 alpha。 | 已实现 |
| `SubFwdOp` | 逐元素减法，支持广播及对第二个输入乘以 alpha。 | 已实现 |
| `MulFwdOp` | 逐元素乘法，支持广播。 | 已实现 |
| `DivFwdOp` | 逐元素除法，并按规格支持取整模式。 | 已实现 |
| `RemainderFwdOp` | 逐元素求余，余数符号遵循除数。 | 已实现 |
| `PowFwdOp` | 逐元素幂运算，支持广播。 | 已实现 |
| `FloorDivideFwdOp` | 逐元素除法后向负无穷方向取整。 | 已实现 |
| `LerpScalarFwdOp` | 使用标量权重在两个输入之间线性插值。 | 已实现 |
| `MaximumFwdOp` | 逐元素取两个输入中的较大值。 | 已实现 |
| `MinimumFwdOp` | 逐元素取两个输入中的较小值。 | 已实现 |
| `EqFwdOp` | 逐元素判断相等，输出布尔结果。 | 已实现 |
| `NeFwdOp` | 逐元素判断不相等，输出布尔结果。 | 已实现 |
| `GtFwdOp` | 逐元素判断第一个输入是否大于第二个输入。 | 已实现 |
| `LtFwdOp` | 逐元素判断第一个输入是否小于第二个输入。 | 已实现 |
| `GeFwdOp` | 逐元素判断大于或等于。 | 已实现 |
| `LeFwdOp` | 逐元素判断小于或等于。 | 已实现 |
| `LogicalAndFwdOp` | 逐元素逻辑与。 | 已实现 |
| `LogicalOrFwdOp` | 逐元素逻辑或。 | 已实现 |
| `BitwiseAndFwdOp` | 逐元素按位与。 | 已实现 |
| `BitwiseOrFwdOp` | 逐元素按位或。 | 已实现 |
| `BitwiseXorFwdOp` | 逐元素按位异或。 | 已实现 |
| `SiluAndMulFwdOp` | 将输入的门控部分做 SiLU 激活，再与值部分相乘。 | 已实现 |
| `GeluAndMulFwdOp` | 将输入的门控部分做 GELU 激活，再与值部分相乘。 | 已实现 |
| `GeluTanhAndMulFwdOp` | 采用 tanh 近似 GELU 的门控激活与乘法融合。 | 已实现 |
| `AlibiFwdOp` | 生成 ALiBi 线性位置偏置。 | 已实现 |
| `SinusoidalFwdOp` | 生成正弦与余弦形式的位置编码。 | 已实现 |
| `WhereFwdOp` | 按布尔条件逐元素从两个输入中选择结果。 | 已实现 |
| `LerpTensorFwdOp` | 使用张量权重在两个输入之间线性插值。 | 已实现 |
| `ReluFwdOp` | ReLU 激活，将负值置零。 | 已实现 |
| `GeluFwdOp` | 高斯误差线性单元 GELU 激活。 | 已实现 |
| `SiluFwdOp` | SiLU 激活，计算 x 乘以 sigmoid(x)。 | 已实现 |
| `HardswishFwdOp` | HardSwish 分段近似激活。 | 已实现 |
| `HardsigmoidFwdOp` | HardSigmoid 分段近似激活。 | 已实现 |
| `MishFwdOp` | Mish 激活，计算 x 乘以 tanh(softplus(x))。 | 已实现 |
| `SeluFwdOp` | 带缩放系数的指数线性单元 SELU 激活。 | 已实现 |
| `LeakyReluFwdOp` | 负半轴保留固定斜率的 LeakyReLU 激活。 | 已实现 |
| `EluFwdOp` | 指数线性单元 ELU 激活。 | 已实现 |
| `HardtanhFwdOp` | 将输入截断到给定区间的 HardTanh 激活。 | 已实现 |
| `SoftplusFwdOp` | 平滑的正值激活，核心表达为 log(1+exp(x))。 | 已实现 |
| `ClampTensorFwdOp` | 按张量给定的上下界逐元素截断。 | 已实现 |
| `ClampScalarFwdOp` | 按标量给定的上下界逐元素截断。 | 已实现 |
| `NanToNumFwdOp` | 将非数值、正无穷和负无穷替换为指定或默认值。 | 已实现 |
| `ExpFwdOp` | 逐元素计算自然指数 exp(x)。 | 已实现 |
| `LogFwdOp` | 逐元素计算自然对数 log(x)。 | 已实现 |
| `SqrtFwdOp` | 逐元素计算平方根。 | 已实现 |
| `RsqrtFwdOp` | 逐元素计算平方根的倒数。 | 已实现 |
| `AbsFwdOp` | 逐元素计算绝对值。 | 已实现 |
| `NegFwdOp` | 逐元素取负。 | 已实现 |
| `ReciprocalFwdOp` | 逐元素计算倒数。 | 已实现 |
| `SignFwdOp` | 逐元素提取正、负或零的符号。 | 已实现 |
| `SinFwdOp` | 逐元素计算正弦。 | 已实现 |
| `CosFwdOp` | 逐元素计算余弦。 | 已实现 |
| `FloorFwdOp` | 逐元素向负无穷方向取整。 | 已实现 |
| `CeilFwdOp` | 逐元素向正无穷方向取整。 | 已实现 |
| `RoundFwdOp` | 逐元素舍入到最接近的整数。 | 已实现 |
| `TruncFwdOp` | 逐元素向零方向取整。 | 已实现 |
| `ErfFwdOp` | 逐元素计算误差函数。 | 已实现 |
| `Log1pFwdOp` | 逐元素计算 log(1+x)，改善小输入时的数值精度。 | 已实现 |
| `Expm1FwdOp` | 逐元素计算 exp(x)-1，改善小输入时的数值精度。 | 已实现 |
| `SigmoidFwdOp` | Sigmoid 激活，将输入映射到零和一之间。 | 已实现 |
| `TanhFwdOp` | 逐元素计算双曲正切。 | 已实现 |
| `LogicalNotFwdOp` | 逐元素逻辑非。 | 已实现 |
| `BitwiseNotFwdOp` | 逐元素按位取反。 | 已实现 |
| `IsnanFwdOp` | 逐元素判断是否为非数值 NaN。 | 已实现 |
| `IsinfFwdOp` | 逐元素判断是否为正无穷或负无穷。 | 已实现 |
| `IsfiniteFwdOp` | 逐元素判断是否为有限数值。 | 已实现 |
| `DropoutFwdOp` | 按给定概率随机丢弃元素，并按保留概率缩放。 | 已实现 |

### 快速傅里叶变换（fft）

共 1 个：已实现 1 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `FFTC2CFwdOp` | 复数输入到复数输出的快速傅里叶变换。 | 已实现 |

### 矩阵乘法（gemm）

共 8 个：已实现 6 个，未实现（仅有规格）2 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `GemmFwdOp` | 稠密矩阵乘法，支持规格声明的转置布局。 | 已实现 |
| `GemmFP8FwdOp` | 带量化缩放及可选偏置的 FP8 矩阵乘法。 | 已实现 |
| `GemmW4A16FwdOp` | 4 位量化权重与 16 位激活的矩阵乘法。 | 已实现 |
| `GroupedGemmFwdOp` | 对多组矩阵执行分组矩阵乘法。 | 已实现 |
| `GemmINT8W8A8FwdOp` | 8 位整数量化权重与激活的矩阵乘法。 | 未实现（仅有规格） |
| `GemmW4A8FwdOp` | 4 位量化权重与 8 位激活的矩阵乘法。 | 未实现（仅有规格） |
| `BmmFwdOp` | 对批内各组矩阵独立执行矩阵乘法。 | 已实现 |
| `BmmFP8FwdOp` | 带量化缩放的 FP8 批量矩阵乘法。 | 已实现 |

### 线性注意力（linear_attention）

共 10 个：已实现 10 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `DeltaNetFwdOp` | 采用 Delta 更新规则的线性注意力。 | 已实现 |
| `GDNFwdOp` | 带门控的 DeltaNet 线性注意力。 | 已实现 |
| `KDAFwdOp` | Kimi Delta Attention 线性注意力。 | 已实现 |
| `DeltaNetRecurrentFwdOp` | 逐步递推更新 DeltaNet 状态并计算输出。 | 已实现 |
| `GLARecurrentFwdOp` | 逐步递推更新门控线性注意力状态并计算输出。 | 已实现 |
| `DeltaNetChunkFwdOp` | 按序列分块计算 DeltaNet 线性注意力。 | 已实现 |
| `DeltaNetChunkBwdOp` | 按序列分块计算 DeltaNet 线性注意力的反向梯度计算。 | 已实现 |
| `GLAFwdOp` | 门控线性注意力。 | 已实现 |
| `GLAChunkFwdOp` | 按序列分块计算门控线性注意力。 | 已实现 |
| `GLAChunkBwdOp` | 按序列分块计算门控线性注意力的反向梯度计算。 | 已实现 |

### Mamba 与状态空间（mamba）

共 10 个：已实现 7 个，未实现（仅有规格）3 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `SSDChunkCumsumFwdOp` | 对时间步与状态衰减参数进行块内处理及累积求和。 | 已实现 |
| `SSDChunkCouplingFwdOp` | 计算 SSD 块内 C 与 B 的耦合矩阵。 | 已实现 |
| `SSDChunkStateFwdOp` | 计算 SSD 各序列块的状态贡献。 | 已实现 |
| `SSDStatePassingFwdOp` | 将状态按衰减关系在序列块之间递推传递。 | 已实现 |
| `SSDChunkScanFwdOp` | 结合块内耦合与先前状态计算 SSD 块输出。 | 已实现 |
| `SSDRecurrentFwdOp` | 执行 SSD 单步状态更新并计算输出。 | 已实现 |
| `Mamba2FwdOp` | 组合 SSD 各阶段，完成 Mamba2 状态空间计算。 | 已实现 |
| `CausalConv1dFwdOp` | 执行因果一维卷积，可使用已有卷积状态。 | 未实现（仅有规格） |
| `CausalConv1dUpdateFwdOp` | 对新输入执行因果卷积并更新卷积状态。 | 未实现（仅有规格） |
| `SelectiveScanFwdOp` | 按输入相关参数执行选择性状态空间扫描。 | 未实现（仅有规格） |

### 混合专家（moe）

共 12 个：已实现 12 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `MoEPermuteAlignFwdOp` | 按专家对路由索引分组，并补齐到指定块大小。 | 已实现 |
| `FusedMoEExpertsFwdOp` | 融合专家计算及路由权重加权合并。 | 已实现 |
| `IndexedExpertMLPFwdOp` | 按专家索引直接执行专家 MLP 计算及加权合并。 | 已实现 |
| `FusedTopKFwdOp` | 计算路由分数并选择 TopK 专家，可执行分组与归一化。 | 已实现 |
| `FusedMoEFwdOp` | 融合路由、专家计算及结果合并的完整 MoE。 | 已实现 |
| `MoEPrePermuteFwdOp` | 按专家分配重新排列输入，准备专家计算布局。 | 已实现 |
| `MoEGroupedGemmFwdOp` | 按专家分组执行矩阵乘法。 | 已实现 |
| `MoEExpertMLPFwdOp` | 对分组专家输入执行门控 MLP。 | 已实现 |
| `MoEPostPermuteFwdOp` | 将专家输出恢复到原始顺序，并按配置加权合并。 | 已实现 |
| `SharedExpertMLPFwdOp` | 执行所有输入共享的专家门控 MLP。 | 已实现 |
| `FusedMoESharedExpertFwdOp` | 融合路由专家与共享专家计算，并组合输出。 | 已实现 |
| `MoEGroupedGemmFP8FwdOp` | 带量化缩放的 FP8 分组专家矩阵乘法。 | 已实现 |

### 归一化（norm）

共 12 个：已实现 10 个，未实现（仅有规格）2 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `RMSNormFwdOp` | 按均方根归一化输入，并应用权重。 | 已实现 |
| `LayerNormFwdOp` | 按指定维度进行层归一化。 | 已实现 |
| `AdaLayerNormFwdOp` | 使用条件提供的缩放与偏移执行自适应层归一化。 | 已实现 |
| `AdaLayerNormZeroFwdOp` | 执行 AdaLayerNorm-Zero 的条件归一化与调制输出。 | 已实现 |
| `FusedAddLayerNormFwdOp` | 融合残差加法与层归一化。 | 已实现 |
| `FusedAddRMSNormFwdOp` | 融合残差加法与均方根归一化。 | 已实现 |
| `FusedAddRMSNormPerTokenQuantFwdOp` | 融合残差加法、均方根归一化及逐令牌量化。 | 未实现（仅有规格） |
| `BatchNormFwdOp` | 批归一化。 | 已实现 |
| `BatchNormBwdOp` | 批归一化的反向梯度计算。 | 已实现 |
| `GroupNormFwdOp` | 按通道分组进行归一化。 | 已实现 |
| `InstanceNormFwdOp` | 对每个样本的各通道分别归一化。 | 已实现 |
| `FusedQKNormRoPEFwdOp` | 融合查询和键的归一化与旋转位置编码。 | 未实现（仅有规格） |

### 池化（pool）

共 13 个：已实现 13 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `AvgPool1dFwdOp` | 一维平均池化。 | 已实现 |
| `AvgPool2dFwdOp` | 二维平均池化。 | 已实现 |
| `AvgPool3dFwdOp` | 三维平均池化。 | 已实现 |
| `MaxPool1dFwdOp` | 一维最大池化。 | 已实现 |
| `MaxPool1dIndicesFwdOp` | 一维最大池化，同时返回最大值位置索引。 | 已实现 |
| `MaxPool2dFwdOp` | 二维最大池化。 | 已实现 |
| `MaxPool2dIndicesFwdOp` | 二维最大池化，同时返回最大值位置索引。 | 已实现 |
| `MaxPool3dFwdOp` | 三维最大池化。 | 已实现 |
| `MaxPool3dIndicesFwdOp` | 三维最大池化，同时返回最大值位置索引。 | 已实现 |
| `AdaptiveAvgPool2dFwdOp` | 二维自适应平均池化。 | 已实现 |
| `AdaptiveMaxPool2dFwdOp` | 二维自适应最大池化。 | 已实现 |
| `AdaptiveMaxPool2dIndicesFwdOp` | 二维自适应最大池化，同时返回最大值位置索引。 | 已实现 |
| `MeanPoolingFwdOp` | 按规格声明的维度执行均值池化。 | 已实现 |

### 量化与反量化（quantization）

共 10 个：已实现 10 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `FP8QuantFwdOp` | 将输入转换为带缩放的 FP8 量化表示。 | 已实现 |
| `INT8QuantPerTensorFwdOp` | 使用整张量量化粒度执行 INT8 量化。 | 已实现 |
| `INT8QuantPerChannelFwdOp` | 按通道粒度执行 INT8 量化。 | 已实现 |
| `INT8QuantPerBlockFwdOp` | 按数据块粒度执行 INT8 量化。 | 已实现 |
| `INT4QuantPerGroupFwdOp` | 按数据组粒度执行 INT4 量化与打包。 | 已实现 |
| `SmoothQuantFwdOp` | 平滑调整激活数值范围并执行量化。 | 已实现 |
| `INT8DequantPerTensorFwdOp` | 按整张量缩放将 INT8 数据反量化。 | 已实现 |
| `INT8DequantPerChannelFwdOp` | 按通道缩放将 INT8 数据反量化。 | 已实现 |
| `INT8DequantPerBlockFwdOp` | 按数据块缩放将 INT8 数据反量化。 | 已实现 |
| `FP8QuantPerBlockFwdOp` | 按数据块计算缩放并执行 FP8 量化。 | 已实现 |

### 归约与扫描（reduction）

共 19 个：已实现 19 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `SoftmaxFwdOp` | 沿指定维度计算归一化指数概率。 | 已实现 |
| `LogSoftmaxFwdOp` | 沿指定维度计算 Softmax 概率的对数。 | 已实现 |
| `LogSumExpFwdOp` | 沿指定维度稳定计算 log(sum(exp(x)))。 | 已实现 |
| `SumFwdOp` | 沿指定维度求和。 | 已实现 |
| `MeanFwdOp` | 沿指定维度求均值。 | 已实现 |
| `AmaxFwdOp` | 沿指定维度求最大值。 | 已实现 |
| `AminFwdOp` | 沿指定维度求最小值。 | 已实现 |
| `ProdFwdOp` | 沿指定维度求乘积。 | 已实现 |
| `VarFwdOp` | 沿指定维度计算方差。 | 已实现 |
| `StdFwdOp` | 沿指定维度计算标准差。 | 已实现 |
| `VarMeanFwdOp` | 同时计算指定维度上的方差和均值。 | 已实现 |
| `ArgmaxFwdOp` | 返回指定维度上的最大值位置。 | 已实现 |
| `ArgminFwdOp` | 返回指定维度上的最小值位置。 | 已实现 |
| `AllFwdOp` | 沿指定维度判断所有元素是否均为真。 | 已实现 |
| `AnyFwdOp` | 沿指定维度判断是否至少有一个元素为真。 | 已实现 |
| `CountNonzeroFwdOp` | 统计指定维度上的非零元素数量。 | 已实现 |
| `VectorNormFwdOp` | 沿指定维度计算向量范数。 | 已实现 |
| `CumsumFwdOp` | 沿指定维度计算前缀累积和。 | 已实现 |
| `CumprodFwdOp` | 沿指定维度计算前缀累积乘积。 | 已实现 |

### 旋转位置编码（rope）

共 5 个：已实现 5 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `RoPEFwdOp` | 对输入应用旋转位置编码。 | 已实现 |
| `RoPELlama31FwdOp` | 应用 Llama 3.1 使用的缩放旋转位置编码。 | 已实现 |
| `YaRNFwdOp` | 应用 YaRN 长上下文旋转位置编码缩放策略。 | 已实现 |
| `LongRoPEFwdOp` | 应用 LongRoPE 长上下文旋转位置编码缩放策略。 | 已实现 |
| `RoPENeoxPositionIdsFwdOp` | 按显式位置编号应用 NeoX 布局的旋转位置编码。 | 已实现 |

### 采样（sampling）

共 6 个：已实现 6 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `TopKMaskFwdOp` | 保留概率最高的 K 个候选，并屏蔽其余候选。 | 已实现 |
| `MinPMaskFwdOp` | 按相对于最高概率的阈值筛选候选。 | 已实现 |
| `TopPMaskFwdOp` | 保留累计概率达到阈值的候选集合，即核采样筛选。 | 已实现 |
| `TopKTopPMaskFwdOp` | 组合 TopK 与 TopP 条件筛选候选。 | 已实现 |
| `SamplingFromProbsFwdOp` | 按照输入概率分布随机采样。 | 已实现 |
| `ChainSpeculativeSamplingFwdOp` | 对链式草稿令牌执行推测采样的接受与补采样。 | 已实现 |

### 序列建模（sequence_modeling）

共 5 个：已实现 5 个，未实现（仅有规格）0 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `EngramGateConvFwdOp` | 融合 Engram 门控、归一化及卷积。 | 已实现 |
| `EngramGateConvBwdOp` | 融合 Engram 门控、归一化及卷积的反向梯度计算。 | 已实现 |
| `EngramDecodeFwdOp` | 执行 Engram 单步解码并更新卷积状态。 | 已实现 |
| `MHCPreFwdOp` | 计算 mHC 层前的混合系数与输入聚合，包含 Sinkhorn 归一化。 | 已实现 |
| `MHCPostFwdOp` | 按 mHC 混合系数组合层输出与残差流。 | 已实现 |

### 数学变换（transform）

共 1 个：已实现 0 个，未实现（仅有规格）1 个。

| 算子名称 | 中文功能说明 | 实现状态 |
|---|---|---|
| `HadamardTransformFwdOp` | 执行 Hadamard 变换，以加减运算完成正交混合。 | 未实现（仅有规格） |


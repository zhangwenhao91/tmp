# TileLang → 可执行对象(.o) 编译流程详解

本文档解析从 TileLang 高层表示降级到可被 NPU Runtime 加载执行的 `.o` 对象文件的完整 7 步流程，并解释每一步的作用与原理。

## 整体架构

```
TileLang → ① 环境初始化 → ② TileLang→NPU方言 → ③ NPU编译优化 → ④ CCE后端lowering
        → ⑤ MLIR→LLVM IR → ⑥ LLVM IR→.o对象 → ⑦ 设置路径 → ⑧ Python执行
```

更精确地，编译与执行链路为：

```
TileLang → NPU Dialect → CCE Backend → LLVM IR → .o 文件 → Runtime 加载 → NPU 执行
```

---

## Step 0：环境初始化

```bash
source /data/setenv.bash   # 设置编译工具链环境变量
which ccec                  # 确认 CCE 编译器可用
export PATH=/home/zwh/OpenTileAS/build/bin:$PATH   # 添加 tile-opt / tile-translate 到 PATH
which tile-opt
which tile-translate
```

**作用**：准备整个编译链路所需的工具链环境。
- `/data/setenv.bash` 设置编译器、运行时相关的环境变量。
- 将 `OpenTileAS` 编译产物的 `bin` 目录加入 `PATH`，使其下的 `tile-opt`、`tile-translate` 工具可被直接调用。
- `which` 命令用于校验相关工具是否就绪。

---

## Step 1：TileLang → MLIR NPU 方言

```bash
tile-opt --convert-tilelang-to-npu xxx_tilelang.mlir -o xxx.mlir
```

**作用**：将高层的 TileLang 表示（类 PyTorch 的矩阵分块/tiling 语言）降低为 MLIR 中间表示。

**原理**：
- TileLang 以块（tile）为单位描述矩阵计算，便于表达数据分片。
- 该 Pass 将 TileLang 语义转换为 NPU 硬件方言（`npu` dialect），在 MLIR 层级确定循环结构、数据流与硬件相关属性。
- 输出 `xxx.mlir` 是后续所有 NPU 优化 Pass 的输入基础。

---

## Step 2：NPU 编译优化 Pass

```bash
tile-opt --npu-split-dataflow --npu-plan-memory --npu-split-mix-kernel --npu-sync-pipeline xxx.mlir -o xxx_npu.mlir
```

**作用**：对 NPU 方言 IR 执行一系列面向多核硬件与内存的优化。

**原理**（各 Pass 职责）：
| Pass | 原理 |
|------|------|
| `--npu-split-dataflow` | 拆分数据流图，将计算映射到 NPU 的多核（AI Core）架构上。 |
| `--npu-plan-memory` | 进行内存规划，决定数据在 L1/L2 SRAM 与 HBM（片外内存）之间的分配和搬运策略。 |
| `--npu-split-mix-kernel` | 处理混合核（向量核 + 矩阵核）的任务拆分，将不同计算语义分配到对应的计算单元。 |
| `--npu-sync-pipeline` | 插入同步原语，处理多核/流水线之间的数据依赖与同步，避免竞态。 |

---

## Step 3：CCE Backend Lowering

```bash
tile-opt --cce-pipeline="target=dav-351x" xxx_npu.mlir -o xxx_cce.mlir
```

**作用**：将 NPU 方言进一步降低到 CCE（Custom Compute Engine）后端指令。

**原理**：
- 指定目标芯片架构 `dav-351x`，据此选择匹配的指令集与 peephole 优化。
- CCE pipeline 将 MLIR 设备方言翻译为贴近硬件的 CCE 指令表示，为后续生成 LLVM IR 做准备。
- 输出 `xxx_cce.mlir` 为面向特定芯片的底层表示。

---

## Step 4：MLIR → LLVM IR

```bash
tile-translate --cce-to-backend xxx_cce.mlir -o xxx_kernel.ll
```

**作用**：将 CCE 方言翻译为 LLVM IR（`.ll` 文本格式）。

**原理**：
- `tile-translate` 是 MLIR 的翻译工具，负责方言之间的 lowering。
- 生成标准 LLVM IR，这是能被 LLVM 后端/GCC 等进一步编译的通用中间表示。
- LLVM IR 携带内存操作、算术运算、控制流等底层语义。

---

## Step 5：LLVM IR → 目标文件

```bash
ccec --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -c -v xxx_kernel.ll -o xxx_kernel.o
```

**作用**：使用 CCE 编译器（类 GCC/Clang）将 LLVM IR 编译为目标文件（`.o`）。

**原理**（关键编译选项）：
| 选项 | 含义 |
|------|------|
| `--cce-aicore-arch=dav-c310-cube` | 指定 AI Core 架构为 `dav-c310`（cube 矩阵核）。 |
| `--cce-aicore-only` | 仅编译 AI Core 部分。 |
| `-cce-enable-mix` | 启用混合精度/混合核支持。 |
| `-O2` | 开启优化等级 2。 |
| `-cce-bitcode-is-aicore` | 声明输入 bitcode 属于 AI Core。 |
| `-c` | 只编译不链接，输出目标文件。 |

---

## Step 6：设置 Kernel 路径

```bash
export KERNEL_PATH=xxx_kernel.o
```

**作用**：将 kernel 对象文件路径导出为环境变量。

**原理**：Python 侧 runtime 通过读取该环境变量定位 kernel 二进制位置，为后续 `dlopen` 动态加载做准备。

---

## Step 7：执行推理

```bash
python xxx.py
```

**作用**：运行 Python 脚本，执行具体计算/推理任务。

**原理**：
- Python 脚本通过 CCE Runtime 按 `KERNEL_PATH` 加载 kernel。
- 将输入数据传入 NPU，调用已编译的 kernel 完成计算，并取回输出结果。
- 至此形成完整的 编译 → 加载 → 执行 闭环。

---

## 总结

| Step | 工具 | 输入 | 输出 | 核心动作 |
|------|------|------|------|----------|
| 0 | bash/source | 环境 | 工具就绪 | 环境初始化 |
| 1 | tile-opt | tilelang.mlir | xxx.mlir | TileLang→NPU方言 |
| 2 | tile-opt | xxx.mlir | xxx_npu.mlir | 数据流/内存/核拆分/同步优化 |
| 3 | tile-opt | xxx_npu.mlir | xxx_cce.mlir | CCE后端lowering (dav-351x) |
| 4 | tile-translate | xxx_cce.mlir | xxx_kernel.ll | CCE→LLVM IR |
| 5 | ccec | xxx_kernel.ll | xxx_kernel.o | LLVM IR→目标文件 |
| 6 | export | — | KERNEL_PATH | 设置kernel路径 |
| 7 | python | xxx.py | 执行结果 | Runtime加载并执行 |

**核心思想**：这是一条典型的**分层下降（tiered lowering）**编译链——从高层的块状矩阵语言，逐步经方言抽取、硬件优化、后端 lowering，最终落到可由 Runtime 加载执行的机器对象文件。

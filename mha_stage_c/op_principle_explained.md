# MHADecodePagedWithKVCacheFwdOp 原理详解（小白版）

> 2026-10-20。对应代码：TileOPs fork `ascend-mha-decode` 分支
> kernel: `src/tileops/backends/ascend/kernels/mha_decode_paged.py`
> builder: `src/tileops/backends/ascend/builders/attention.py`

分四层讲：数学 → 数据布局 → 硬件 → 逐行代码。先建立直觉，再看代码就不迷糊了。

---

## 一、这个算子在算什么数学题

### 1.1 Attention 的基本公式

Transformer 里每个 token 会产出三个向量：**Q**（我在找什么）、**K**（我能被怎么找到）、**V**（我的实际内容）。注意力就是：

```
score_i = Q_i · K_j / √D        ← 新 query 和每个旧 key 做点积（除 √D 缩放）
P_i     = softmax(score_i)      ← 变成一组加起来=1 的权重
O_i     = Σ_j P_i[j] · V_j      ← 用权重把所有 V 加权求和
```

### 1.2 "Decode" 阶段的特殊性

生成式推理一步步吐 token。第 1 步之后的每一步：

- **Query 只有 S_q 个新 token**（普通解码 S_q=1；speculative decoding 一次猜 4~16 个，所以 S_q 可以是 4）
- **Key/Value 是之前全部历史**（可能上千个 token），它们已经被算过、缓存在显存里了 —— 这就是 **KV Cache**

所以 decode 就是："拿 S_q 个新问题，去一屋子旧答案里查资料"。

### 1.3 Causal（因果）语义

S_q>1 时，S_q 个新 token 之间也有先后关系：**第 i 个新 token 只能看见自己之前的 key**。本算子的定义：

```
query i 能看见的 key 位置：j ≤ i + real_seqlen - S_q
```

直觉：S_q 个新 token 是"排在一个队列末尾"的，最后一个（i=S_q-1）能看见全部 real_seqlen 个 key，往前每个少看一个。如果一个 query 一个 key 都看不见，输出全 0。

---

## 二、KV Cache 为什么"分页"（Paged）

### 2.1 问题：缓存长度不定，显存怎么管？

每个请求的缓存长度随时在涨，如果每个请求预留一整块连续显存，碎片化会很严重。**PagedAttention**（vLLM 推广的思想）借鉴操作系统虚拟内存：

- 把 KV cache 切成固定大小的**页**（本算子 page_size=128/256 行）
- 显存里有一个大**物理页池**：`K/V = [POOL_ROWS, H, D]`，所有请求共享
- 每个请求有一张**页表** `block_table [B, W]`：第 n 个**逻辑页**实际存在池里第几个**物理页**

```
逻辑视图（请求 b 的缓存）          物理池（乱序存放）
 logical page 0 ──┐               物理页 7  ┐
 logical page 1 ──┼─ block_table ─→ 物理页 2  ├─ 每页 page_size 行
 logical page 2 ──┘   [7, 2, 5]     物理页 5  ┘
```

访问逻辑位置 `pos` 的 key：`物理行 = block_table[b, pos // page_size] * page_size + pos % page_size`。

### 2.2 契约（输入输出）

```
输入:  q [B, S_q, H, D]           新 token 的 query
       k/v [POOL_ROWS, H, D]      物理页池（所有请求共享！）
       real_seqlen_kv [B] int32   每个请求真实缓存长度
       block_table [B, W] int32   页表
参数:  page_size（%16==0）, is_causal
输出:  o [B, S_q, H, D]           注意力结果（scale 隐含 1/√D，无 LSE）
```

注意 **k/v 是全局共享池**——这也是 diag 脚本踩过坑的地方（自造页表让 batch1 指到池外就读到垃圾）。

---

## 三、昇腾硬件模型（看懂代码的钥匙）

d806（Ascend 950）的片上存储分几层，数据必须逐级搬运：

```
GM（显存,大而慢）
 │  T.copy  ←─ MTE 搬运引擎
 ├─ L1 (K_shared/V_shared/Q_shared/P_shared)   ←─ Cube 矩阵单元的输入
 │   ├─ L0A/L0B → Cube 做 T.gemm → L0C (fp32 累加器)
 ├─ UB (统一缓冲, Vector 单元的工作区)
 │   S_ub/bias_ub/m_ub/l_ub/O_ub ...
 └─ 结果再 dual_copy 写回 GM
```

两种计算单元分工：

- **Cube**：只做矩阵乘（`T.gemm`），吃 L1，吐 fp32 到 L0C
- **Vector（AIV）**：做逐元素/规约运算（加、指数、max、除法），在 UB 上干活

还有两个关键设定：

- `T.Kernel(B * H)`：启动 B×H 个 block，**每个 block 独立算一个 (batch, head) 对**——head 之间无依赖，天然并行
- **双 AIV**：一个 block 内部有两个向量核并行干活，每个管一半行（`ROWS = BR//2 = 8` 行），`T.dual_copy` 就是"把 L0C 数据分给两个 AIV"的搬运原语

---

## 四、Kernel 逐行讲解

### 4.1 编译入口与常量（L23-69）

```python
@functools.lru_cache(maxsize=64)
def compile_kernel(batch, seqlen_q, heads, dim, page_size, max_pages_per_req, pool_rows, dtype, num_stages):
```

形状全部是**编译期常量**（昇腾后端要求静态形状），同形状只编译一次，缓存在 lru_cache。

```python
BC = 128   # 每"块"处理 128 行 key
SP = PAGE // BC   # 一页被切成几个 key 块（page 256 → SP=2）
BR = 16  # 每个 block 摆 16 行 query（哪怕真实 S_q 只有 4，Cube 的 M 维最小 16）
ROWS = BR // 2  # 每个 AIV 管 8 行
VL = 64   # 一条向量指令 64 lane（D=128 就要 2 条盖满）
```

为什么 BR=16？Cube 单元矩阵乘最小规模是 16 行，S_q=1 也要凑满 16 行算力——这就是 decode 算术强度低、MFU 天花板低的根源。

### 4.2 `qk` 宏：算"新 query × 旧 key"打分（L71-77）

```python
T.copy(KP[base:base+BC, h, 0:D], K_shared)      # 池里 128 行 key：GM → L1
T.copy(Q_shared, qk_a_l0)                        # Q：L1 → L0A
T.copy(K_shared, qk_b_l0)                        # K：L1 → L0B
T.gemm(qk_a_l0, qk_b_l0, qk_acc_l0c, transpose_B=True)  # Cube: [16,D]@[D,128] → [16,128] 分数
T.dual_copy(qk_acc_l0c, S_ub)                    # 分数 L0C → UB，分给两个 AIV
```

得到 `S_ub[16, 128]`：16 个 query 对这 128 个 key 的原始分数。注意 `transpose_B=True` 是因为池内存布局是 `[行, D]`，gemm 要的是 `[D, 行]`。

### 4.3 `softmax` 宏：核心难点（L79-168）

标准 softmax 要先看完全部分数求 max，但 key 有几千个、不可能全放进片上。所以用**在线 softmax（online softmax）**：一块一块地处理，每块维护两个运行量：

- `m`：到目前为止见过的最大分数
- `l`：以 m 为基准的指数和

每处理一块，用 `alpha = exp(m_old - m_new)` 把之前的累加结果"打折"修正一次。

**第一段：加 bias、求行 max（L90-113）**

```python
S.vsts(old_m_ub[0], S.vld(m_ub[0]), ...)   # 存下旧 m（一会儿算 alpha 用）

for r in range(0, ROWS, 2):                # 每次处理一对行（r 和 r+1）
    b0lo = S.vld(bias_ub[r, 0])            # 行 r 的 bias 前 64 lane
    b0hi = S.vld(bias_ub[r, VL])           # 行 r 的 bias 后 64 lane
    s00 = S.vadd(S.vmuls(S.vld(S_ub[r,0]), scale), b0lo)   # score*scale + bias
    ...
    max0 = S.vcmax(S.vmax(s00, s01))       # 行内 max（64+64 lane 归约成 1 个数）
    S.vsts(m_ub[r], max0, "PAT_VL1")       # 存回 m_ub[r]
```

**bias 就是掩码的载体**：builder 预先算好一个 fp32 大表 `BIAS [B*16, 全部key位置]`，可见位置填 `0`，不可见位置填 `-1e30`。加到分数上之后，`exp(-1e30 - m) = 0`，被屏蔽的 key 权重精确为零——**乘法掩码会破坏 softmax 归一化，加性掩码不会**，这是 v1c 实验定下的方案。

**第二段：归一化指数、行和、打包（L120-161）**

```python
merged_max = S.vmax(S.vld(m_ub[0]), S.vld(old_m_ub[0]))  # 块间统一 max
S.mem_bar("VST_VLD")                       # 内存栅栏：确保上面的写先完成

for r in range(0, ROWS, 2):
    max0 = S.vld(m_ub[r], "BRC_B32")       # 广播读（1 个数广播给全向量）
    p00, p01 = S.vld2(S_ub[r, 0], "DINTLV_B32")   # 交织读回 2 条 64 lane
    e00 = S.vexpdif(p00, max0)             # exp(p - max)：减 max 防溢出
    row_sum0 = S.vcadd(S.vadd(e00, e01))   # 行内求和 → l 的增量
    even_pk = S.vcvt(e00, "float16", part=0)   # fp32 → fp16，压前半
    odd_pk  = S.vcvt(e01, part=1)              # 压后半
    merged = S.vor(reinterpret(even_pk, uint16x128), reinterpret(odd_pk, ...))
    dst_nz_ptr = S.vsstb(merged, dst_nz_ptr, ...)  # 按 NZ 布局散写到 UB
```

两个魔法指令：

- `vld2 DINTLV` / `vcvt part + vor + vsstb`：把两条 64-lane fp32 向量**交织压成一条 128-lane fp16**——因为 P 矩阵马上要进 Cube 做第二次 gemm，Cube 要求特定的 **NZ 密集布局**（按 16×16 小块内部转置存放），`vsstb`（scatter store）一条指令完成带布局的写
- `vexpdif(p, max)`：一条指令算 `exp(p - max)`，这是数值稳定的 softmax 写法（防 e^1000 溢出）

**第三段：算 alpha、更新 l（L163-168）**

```python
alpha_reg = S.vexpdif(S.vld(old_m_ub[0]), S.vld(m_ub[0]))  # exp(m_old - m_new)
l_updated = S.vmul(S.vld(l_ub[0]), alpha_reg) + row_sum     # l = l*alpha + 本块行和
```

注意 `m_ub` 的巧妙用法：每块结束把 `merged_max` 写回 `m_ub[0]`，下一块进来先存到 `old_m_ub` —— 两个"槽位"轮转就实现了跨块的在线状态。

### 4.4 `pv` + `accumulate_output`：加权求和（L170-192）

```python
T.copy(VP[base:..., h, :], V_shared, transpose=True)   # V 进 L1（转置成 [D, BC]）
T.gemm(pv_a_l0, pv_b_l0, pv_acc_l0c)                   # P[16,128] @ V[128,D] → O增量[16,D]
T.dual_copy(pv_acc_l0c, O_tmp_ub)

for i in range(ROWS):                                  # O = O*alpha + 本块增量
    alpha = S.vld(alpha_ub[i], "BRC_B32")
    updated = S.vadd(S.vmul(alpha, prev), cur)
```

这就是在线 softmax 的另一半：之前的输出 O 也要乘 alpha 修正。到此一个 key 块处理完毕，循环下一块。

### 4.5 主函数：调度与页寻址（L241-316）

```python
with T.Kernel(B * H) as bx:        # B*H 个 block 并行
    b, h = bx // H, bx % H         # 每个 block 认领一个 (batch, head)
```

内存分配（L259-281）：L1 四块（Q/K/V/P）、L0 六块（gemm 操作数和累加器）、UB 十一块。`annotate_buffer_versions` 告诉编译器哪些缓冲可以被 double-buffer 复用。

```python
T.copy(Q[b, 0:S_Q, h, 0:D], Q_shared)   # 本 block 的 S_q 行 Q，一次性装进 L1
init_m_l(m_ub, l_ub)                     # m = -inf, l = 0
clear_O_ub(O_ub)                         # O 累加器清零

for kv in T.serial(NUM_KV):              # 逐个 key 块（共 W*SP 块）
    with T.If(kv * BC < rl):             # 整块超出缓存长度 → 直接跳过（省算力）
        pg  = kv // SP                   # 逻辑页号
        off = (kv % SP) * BC             # 页内偏移（SP=2 时半页一跳）
        base = BT[b, pg] * PAGE + off    # ★ 物理地址 = 页表查出的物理页号×页大小 + 偏移
        kv_body(...)                     # qk → softmax → pack_p → pv → accumulate
```

`base` 那行就是**分页寻址的核心**：运行时从 GM 读页表标量，把逻辑块号翻译成物理行号——页表是乱的也无所谓，纯地址计算。

```python
finalize_cast(O, b, h, O_ub, O_cast_ub, l_ub)   # 收尾：O /= l（除以行和归一化）
                                                 # 再 fp32→fp16，dual_copy 写回 GM
```

---

## 五、Builder：kernel 之外的三个保障

kernel 只会"整块整块"地处理，边界情况都在 host 侧解决：

**① 加性 bias 构造**

```python
last_key = row_idx + rl_f - seqlen_q     # 每行的可见边界（第一节 1.3 的公式）
visible = kv_pos <= last_key             # [B, 16, 全部key位置] 的布尔表
bias = torch.where(visible, 0.0, -1.0e30)
```

可见处 0、不可见处 -1e30，kernel 里 `vadd` 加上去即完成逐行掩码。按 `(rl, device)` 缓存，解码连续步复用。

**② NaN 投毒池消毒**

测试会故意把"没人读的池行"填成 NaN。因为 kernel 整块读取，块尾巴上被 rl 切掉但还读进来的行会带着 NaN 污染分数。builder 先算**读掩码**：`read[物理行]=True` 若有请求会读它；存在未读行时 clone 池并把这些行清零（0 乘任何分数都是干净的 0）。全读时跳过 clone 省一次池大小的拷贝。

**③ 无 key 行清零**

`rl ≤ 15` 之类场景下，排前面的 query 一个 key 都看不见，softmax 分母为 0（0/0=NaN）。builder 事后把这些输出行直接置 0，符合契约。

---

## 六、端到端一张图

```
host(builder)                          device(kernel)
┌─────────────────────┐   GM    ┌──────────────────────────────┐
│ bias [B*16, key位]   │ ──────→ │ B*H 个 block，每 block:        │
│ 池消毒(按需 clone)    │         │  Q(≤16行) 装 L1               │
│ 无key行记 0          │         │  for 每个 128-key 块:          │
└─────────────────────┘         │   页表寻址→K/V 装 L1           │
                                │   Cube: QKᵀ → 分数[16,128]     │
                                │   Vector: +bias, online softmax│
                                │   NZ 打包 P → Cube: P@V        │
                                │   O = O*alpha + P@V            │
                                │  收尾: O/l → fp16 → GM         │
                                └──────────────────────────────┘
```

一句话总结：**这是一个"查表寻址 + 两段 Cube 矩阵乘夹一段 Vector 在线 softmax"的分页解码 kernel；页表乱序靠运行时地址计算消化，causal 掩码靠 host 预生成的加性 bias 消化，缓存切边靠 host 消毒和零行清零消化**。

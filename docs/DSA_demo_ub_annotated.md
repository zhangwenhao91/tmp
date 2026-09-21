# DSA_demo_ub.py 逐行解释

> persistent-kernel + 显式 CV 1:2 的 DSA sparse attention DSL demo
> 是 "ND2NZ 按 16 切块放 L1" 任务的 DSL 实现对照

---

## 第 1-4 行：导入

```python
import math                                    # softmax_scale 用 sqrt
import tilelang                                # lower 入口
import tilelang.language as T                  # DSL 语法（T.prim_func/T.Kernel/...）
```

## 第 7-15 行：函数签名

```python
def dsa_demo(
    batch_size=1,      # batch 维（此 demo 固定 1）
    seq_len=4096,     # query 行数
    seq_len_kv=4096,  # KV 行数
    num_heads=64,     # 注意力头数
    dim=256,          # 每头特征维
    top_k=128,        # 每行 query 只关注 top_k 个稀疏 KV 行
    num_cores=32,     # 逻辑核数（persistent kernel 用）
):
```

## 第 16-22 行：docstring

**Persistent-kernel（常驻核）变体**：逻辑核数固定为 `num_cores`（物理核数），
每核串行处理 `rows_per_core = seq_len // num_cores` 行 query——多个 query 共享一个
物理核。区别于"每核一行"的普通 launch（4096 行需要 4096 个核，超过物理上限）。

## 第 24-34 行：常量准备

```python
block_heads = num_heads           # 64：GEMM 的 M 维（所有头一起算）
half_heads = block_heads // 2     # 32：每个向量核分到的头数（1:2 split）
blocksize = 16                    # 16：KV 分块行数（= NZ fractal 行粒度）
dtype = "bfloat16"                # 计算用 bf16
accum_dtype = "float32"           # 累加用 f32（GEMM 累加/softmax 状态）
indices_dtype = "int32"           # TopK 索引用 i32
```

```python
assert top_k % blocksize == 0     # 128 % 16 == 0：top_k 必须按块整切
rows_per_core = seq_len // num_cores   # 4096 // 32 = 128 行/核
assert seq_len % num_cores == 0   # 4096 % 32 == 0：必须整除
softmax_scale = 1.0 / math.sqrt(dim)   # 1/16：Q 缩放系数
```

## 第 36-43 行：prim_func 签名

```python
@T.prim_func
def main(
    Q: T.Buffer((batch_size, seq_len, num_heads, dim), dtype),
    # Q [1, 4096, 64, 256] bf16：query
    KV: T.Buffer((batch_size, seq_len_kv, dim), dtype),
    # KV [1, 4096, 256] bf16：key/value 共用（S=Q@K^T 和 O=P@V 用同一份）
    AttnSink: T.Buffer((num_heads,), accum_dtype),
    # [64] f32：attention sink（每个头的偏置项，初始 m）
    TopKIndices: T.Buffer((batch_size, seq_len, top_k), indices_dtype),
    # [1, 4096, 128] i32：每行 query 的 top-128 KV 行索引
    O: T.Buffer((batch_size, seq_len, num_heads, dim), accum_dtype),
    # [1, 4096, 64, 256] f32：输出
):
```

## 第 47 行：Kernel 轴定义

```python
with T.Kernel(num_cores, 2) as (cid, vid):
    # cid = blockIdx.x：32 个物理核
    # vid = blockIdx.y：CV 1:2 的向量核轴（0 或 1，两个 sub_block）
```

**双轴是显式 1:2**。cid/vid 是编译期轴，映射到 AIC（cube）+ 两个 AIV（vector sub_block）。

## 第 49-53 行：L1/shared buffer（整块形状，两核共享）

```python
q_shared = T.alloc_shared((block_heads, dim), dtype)
    # [64, 256] bf16：Q 块，GEMM 的 A 操作数（整块，不分半）
kv_shared = T.alloc_shared((top_k, dim), dtype)
    # [128, 256] bf16：gather 来的 KV，两个 GEMM 共用的 B 操作数（整块）
p_shared = T.alloc_shared((block_heads, top_k), dtype)
    # [64, 128] bf16：softmax 后的 P，第二个 GEMM 的 A 操作数（整块）
idxs_ub = T.alloc_shared((top_k,), indices_dtype)
    # [128] i32：本行全部 top-k 索引（UB）
kv_ub = T.alloc_shared((blocksize, dim), dtype)
    # [16, 256] bf16：KV gather 的中转块（UB）
```

## 第 55-56 行：fragment（累加器，L0C）

```python
acc_s = T.alloc_fragment((block_heads, top_k), accum_dtype)
    # [64, 128] f32：S = Q@K^T 的累加器（L0C）
acc_o = T.alloc_fragment((block_heads, dim), accum_dtype)
    # [64, 256] f32：O = P@V 的累加器（L0C）
```

## 第 59-67 行：双向量核 UB buffer（半块形状，每核私有）

```python
s_ub = T.alloc_shared((half_heads, top_k), accum_dtype)
    # [32, 128] f32：S 的半块（L0C cut 后各核分一半头）
p_ub = T.alloc_shared((half_heads, top_k), dtype)
    # [32, 128] bf16：P 的半块（assemble 回 L1 前的暂存）
o_ub, o_tmp_ub = [32, 256] f32 × 2
    # O 累积值 / 新块 GEMM 结果的暂存
m_ub, old_m_ub = [32] f32 × 2
    # 行最大值状态（online softmax 的 m）/ 上一轮的 m
row_sum_ub = [32] f32    # 当前行 exp 之和
l_ub = [32] f32          # 归一化分母累积
alpha_ub = [32] f32      # exp(m_old - m_new)：新旧块缩放系数
```

**注意**：`half_heads=32` 意味着每个 sub_block 的 UB buffer 是"半头"形状——这是
CV12 的正确姿势（sb0/sb1 各只能访问半个 UB，buffer 必须按半块分）。

## 第 70-71 行：persistent 行循环

```python
for q_iter in T.Pipelined(rows_per_core, num_stages=2):
    row = cid * rows_per_core + q_iter
    # 核 cid 处理第 [cid*128, (cid+1)*128) 行
    # Pipelined num_stages=2：双缓冲流水（第 i 轮搬运与第 i-1 轮计算重叠）
```

## 第 73-81 行：载入 Q

```python
T.copy(Q[0, row, 0:num_heads, 0:dim], q_shared)
    # GM [64, 256] bf16 → L1，ND2NZ 重排
```

## 第 83-94 行：online softmax 状态初始化

```python
with T.SimdVF():
    T.fill(o_ub, 0.0)      # O 累积清零
    T.fill(l_ub, 1.0)      # l 初始为 1（不是 0！后面是乘法更新）
```
**注释强调了原因**：o/l/m 每行必须重置，否则第 2 行起会继承上一行的累积状态
（persistent kernel 特有的坑）。

```python
T.copy(AttnSink[vid * half_heads : (vid + 1) * half_heads], m_ub)
    # m 初始 = attention sink 值（不是 -inf！）
    # vid=0 取前 32 头，vid=1 取后 32 头——每个向量核只取自己那半
```

## 第 97-102 行：载入 TopK 索引

```python
for sparse_col in T.serial(top_k):
    idxs_ub[sparse_col] = TopKIndices[0, row, sparse_col]
    # GM → UB 逐标量循环加载 128 个索引（i32）
```

## 第 104-131 行：核心段——分块离散 gather + ND2NZ 摆放

这是 ND2NZ 任务的 DSL 实现对照。

```python
dtype_bytes = T.dtype(dtype).bytes    # bf16 = 2 字节
pre_block_col = 32 // dtype_bytes      # 32 // 2 = 16：每个 32B 块的列数
col_count = dim // pre_block_col       # 256 // 16 = 16：列方向切块数
row_count = kv_shared.shape[0] // blocksize  # 128 // 16 = 8：行方向切块数
```

**N0 对齐**：bf16 时 fractal 每行 16 个元素（32B），列必须按 16 对齐切——
`pre_block_col=16` 正是这个粒度。256 列 = 16 个列组，128 行 = 8 个行组。

```python
tmp_shared_l1 = T.alloc_shared((tile_row, tile_col), dtype)
    # ★ BUG：tile_row/tile_col 未定义 → NameError
    # 意图是 (blocksize, dim) = (16, 256)：UB→L1 的 NZ 中转块
```

```python
for i in T.serial(top_k // blocksize):    # 8 轮，每轮 gather 16 行 KV
    for j in T.serial(blocksize):          # 16 行
        topk_col = i * blocksize + j       # 全局 sparse 列号
        T.copy(KV[0, idxs_ub[topk_col], 0:dim], kv_ub[j, 0:dim])
            # ★ 运行时索引 gather：从 GM 按 idxs_ub[topk_col]（UB 里的值）
            #   离散取行 → kv_ub 第 j 行
            #   这是"行号来自数据"的动态行偏移搬运
    T.copy(kv_ub, tmp_shared_l1)
        # ★ 第一跳：UB [16,256] ND → L1 tmp（NZ 摆放）——ND2NZ
```

```python
    for col_idx in range(col_count):      # 16 个列组（Python 循环，trace 展开）
        T.copy(
            tmp_shared_l1[:, col_idx * 16 : (col_idx + 1) * 16],
                # L1 tmp 的第 col_idx 个 fractal 列组（16 行 × 16 列）
            kv_shared[i * blocksize:(i + 1) * blocksize,
                      col_idx * 16:(col_idx + 1) * 16]
                # L1 kv_shared 的第 i 行组 × 第 col_idx 列组位置
        )
        # ★ 第二跳：L1→L1，按 fractal 块搬运
        #   [16,256] 的 NZ = 1 行组 × 16 列组，fractal 是连续 512B；
        #   [128,256] 的 NZ 里 fractal(行组 i, 列组 j) 同样连续 512B。
        #   两边切片都是"一个 fractal = 512B 连续段"，
        #   所以 L1→L1 线性搬运即可，绕过"L1→L1 不支持 ND2NZ"
```

```python
    # TODO: 计算本块在 kv_shared 中的目标 offset（重点），
    # 然后将 kv_ub 拷贝到 L1 对应 offset 处：
    # T.copy(kv_ub, kv_shared[offset : offset + blocksize, 0:dim])
```
旧方案的遗留 TODO（直接算 offset 搬运），已被上面的两跳方案取代。

## 第 134-142 行：S = Q @ K^T

```python
T.gemm(q_shared, kv_shared, acc_s, transpose_B=True, clear_accum=True)
    # [64,256] @ [256,128] = [64,128] f32 累加
    # transpose_B=True：KV 是 [K,N] 摆的，B^T 即转置语义
    # clear_accum=True：覆盖累加器（每轮重算 S）
T.copy(acc_s, s_ub, split_dim=0)
    # L0C [64,128] → UB [32,128] × 2：CV12 cut（行方向切半，头维度）
    # sb0 拿前 32 头，sb1 拿后 32 头
```

## 第 144-155 行：Step 1 - 缩放 + 行最大值

```python
with T.SimdVF():
    s_frag = [32, 128] f32（UB→frag）
    row_max_frag = [32] f32

    T.copy(s_ub, s_frag)                       # UB → 片段
    T.vmuls(s_frag, softmax_scale, s_frag)     # S *= 1/16（标量乘）
    T.copy(s_frag, s_ub)                       # 写回 UB

    T.copy(m_ub, old_m_ub)                     # old_m = m（保存旧值）
    T.vreduce_max(s_frag, row_max_frag, dim=1) # 行最大值（128 列 → 1 值/行）
    T.copy(row_max_frag, m_ub)                 # m = row_max(S)（暂存，Step2 合并）
```

## 第 157-179 行：Step 2 - exp + 行求和

```python
    s_frag, p_frag = [32,128] f32；p_bf16_frag = [32,128] bf16
    m_frag, m_new_frag, row_max_frag = [32] f32
    m_new_bc = [32,128] f32；row_sum_frag = [32] f32

    T.copy(s_ub, s_frag)                       # 重读 S（已缩放）
    T.copy(m_ub, row_max_frag)                 # 本块行最大
    T.copy(old_m_ub, m_frag)                   # 旧 m
    T.vmax(row_max_frag, m_frag, m_new_frag)   # m_new = max(块max, 旧m)
    T.copy(m_new_frag, m_ub)                   # 更新 m
    T.broadcast(m_new_frag, m_new_bc)          # m_new 广播到 [32,128]
    T.vexpdif(s_frag, m_new_bc, p_frag)        # P = exp(S - m_new)
    T.vcvt(p_frag, p_bf16_frag, dtype)         # f32 → bf16（GEMM 输入要 bf16）
    T.copy(p_bf16_frag, p_ub)                  # 存 UB
    T.vreduce_sum(p_frag, row_sum_frag, dim=1)  # row_sum = Σ exp(...)
    T.copy(row_sum_frag, row_sum_ub)
```

## 第 181-197 行：Step 3 - alpha + l 更新

```python
    m_frag, m_new_frag, l_frag, alpha_frag, row_sum_frag = [32] f32

    T.vexpdif(m_frag, m_new_frag, alpha_frag)  # α = exp(m_old - m_new)
    T.copy(alpha_frag, alpha_ub)
    T.vmul(l_frag, alpha_frag, l_frag)        # l = l * α
    T.vadd(l_frag, row_sum_frag, l_frag)      # l = l*α + row_sum
    T.copy(l_frag, l_ub)
```

## 第 199-224 行：O = O*α + P@V

```python
T.copy(p_ub, p_shared, split_dim=0)
    # UB [32,128] × 2 → L1 [64,128]：CV12 assemble（半块拼整）
    # 两个向量核各搬自己那半头到 L1 的 p_shared
T.gemm(p_shared, kv_shared, acc_o, transpose_B=False, clear_accum=True)
    # [64,128] @ [128,256] = [64,256] f32
    # 注意 clear_accum=True：GEMM 前清 L0C，α 缩放由下面向量部分做
T.copy(acc_o, o_tmp_ub, split_dim=0)
    # L0C → UB 半块 cut
```

```python
with T.SimdVF():
    o_frag, o_tmp_frag = [32,256] f32；alpha_frag = [32] f32
    T.vmul(o_frag, alpha_bc, o_frag)    # O = O * α
    T.vadd(o_frag, o_tmp_frag, o_frag)  # O = O*α + P@V
    T.copy(o_frag, o_ub)
```

## 第 226-245 行：归一化 + 写回 GM

```python
with T.SimdVF():
    T.vdiv(o_frag, l_bc, o_frag)       # O /= l
    T.copy(o_frag, o_ub)
T.copy(o_ub, O[0, row, vid*32:(vid+1)*32, 0:dim])
    # UB → GM：每个向量核只写自己那半头（vid 偏移）
```

---

# 总流程图

```
persistent: for row in 128 行/核
 |- Q -> q_shared(L1)                         [GM->L1 ND2NZ]
 |- 状态重置: o=0, l=1, m=sink(半头)
 |- TopKIndices -> idxs_ub
 |- for 8 个 KV 块:
 |   |- 16 行 gather -> kv_ub (UB)             [GM->UB 动态行偏移] 难点
 |   |- kv_ub -> tmp_shared_l1                 [UB->L1 ND2NZ 第一跳] 任务
 |   `- 16 x 512B fractal -> kv_shared 对应块   [L1->L1 第二跳] 任务
 |- S = Q@K^T -> acc_s (L0C)
 |- acc_s -> s_ub                             [L0C->UB CV12 cut]
 |- online softmax (m/l/α, P=exp(S-m))       [AIV 向量]
 |- p_ub -> p_shared                          [UB->L1 CV12 assemble]
 |- O' = P@V -> acc_o (L0C)
 |- acc_o -> o_tmp_ub                         [L0C->UB CV12 cut]
 |- O = O*α + O'                             [AIV 向量]
 `- O/l -> O GM                                [UB->GM, vid 半头]
```

---

# 遗留问题

1. **112 行 `tile_row`/`tile_col` 未定义** → NameError。应为 `(blocksize, dim)` = (16, 256)
2. **108 行 `T.dtype(dtype).bytes`** 写法存疑，DSL 里不一定支持，可硬编码 2（bf16）
3. **111 行 `row_count`** 定义后未使用（死变量）
4. **两个关键验证点**（跑流水线时确认）：
   - tmp_shared_l1 的布局推断：必须是 NZ 布局（第一跳 ND2NZ 目的语义才对）。
     若 plan-memory 把纯中转 buffer 分配成线性 ND 布局，第一跳就不会做 ND2NZ，
     第二跳切片地址全错
   - 第二跳切片 T.copy 的 lowering：subview 的 NZ 地址映射
     （行组×512 + 列组×rows×32）有没有被正确算进 reinterpret_cast 的 offset
5. 117 行运行时索引 gather（行号来自 UB 数据）能否 lower 出动态行偏移 DMA 待验证
6. 125 行 Python 循环展开成 8×16=128 条 512B 小 DMA，效率存疑（先跑通再说）

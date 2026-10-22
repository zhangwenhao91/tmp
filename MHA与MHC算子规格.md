# MHA 与 mHC 算子规格

## 一、MHA（单头 FlashAttention 前向）

> 参考代码仓：`https://github.com/tile-ai/tilelang`（`examples/ascend/flash_attention/`）
> 主要文件：`example_mha.py`、`test_mha.py`、`core.py`

### 计算属性

| 计算属性 | | |
|---|---|---|
| num_heads | 静态 | 1 |
| head_dim | 静态 | 128（builder 内 assert 硬约束） |
| scaling（注意力分数缩放系数） | 静态 | 1/√128 = 0.0884 |
| causal（因果掩码） | 静态 | 无（全量双向注意力） |
| dropout（随机丢弃概率） | 静态 | 0 |
| batch_size/B | 动态 | —（本实现无 batch 轴，B=1） |
| seq_len/sq | 动态 | 需满足 sq % block_q == 0 |
| kv_length/T（KV 序列轴长度） | 动态 | 需满足 T % 128 == 0 |
| 稀疏索引 indices | 动态 | 不支持（稠密全量注意力） |
| attention_mask | 动态 | 不支持 |

### 输入输出

| 输入输出 | | | |
|---|---|---|---|
| input: | Q | shape:[sq, 128] | dtype:BF16 |
| | K | shape:[T, 128] | dtype:BF16 |
| | V | shape:[T, 128] | dtype:BF16 |
| output: | O | shape:[sq, 128] | dtype:FP32 |

## 二、mHC（流形约束超连接算子组）

> 参考代码仓：`https://github.com/deepseek-ai/TileKernels`（`tile_kernels/mhc/`，Ascend 后端为 `*_asc.py`）
> 模型规格依据：DeepSeek V4 config.json（`hc_mult=4, hc_sinkhorn_iters=20, hc_eps=1e-6`）

### 计算属性

| 计算属性 | | |
|---|---|---|
| hc_mult（流数 n） | 静态 | 4（派生 hc_mult3 = n×(n+2) = 24） |
| hidden_size | 静态（编译期确定） | V4-Pro = 7168 / V4-Flash = 4096（测试覆盖 1280~7168） |
| hc_sinkhorn_iters | 静态 | 20 |
| hc_eps / mhc_pre_eps | 静态 | 1e-6 |
| rms_eps | 静态 | 1e-6 |
| num_tokens | 动态 | 512 ~ 8192+（decode/prefill 通用） |
| 数据类型 | 静态 | residual/hidden：BF16；mix/scale/累加：FP32 |

### 输入输出（以 pre_big_fuse_fwd / post 为代表）

| 输入输出 | | | |
|---|---|---|---|
| input: | residual | shape:[num_tokens, 4, hidden] | dtype:BF16 |
| | comb_mix | shape:[num_tokens, 4, 4] | dtype:FP32 |
| | post_mix | shape:[num_tokens, 4] | dtype:FP32 |
| | mhc_scale / mhc_base | shape:[num_tokens, 24] | dtype:FP32 |
| | gemm_out_mul / gemm_out_sqrsum | shape:[n_splits, num_tokens, 24] / [n_splits, num_tokens] | dtype:FP32 |
| output: | layer_input | shape:[num_tokens, hidden] | dtype:BF16 |
| | residual（更新后） | shape:[num_tokens, 4, hidden] | dtype:BF16 |

### 算子清单（fwd + bwd）

| kernel | 功能 |
|---|---|
| expand | 单流 → n 流复制 |
| pre_split_mixes / pre_apply_mix | pre 混合矩阵切分与应用 |
| pre_big_fuse | 融合 RMSNorm + GEMM partials + Sinkhorn + mix |
| sinkhorn | 4×4 双随机投影（fwd/bwd，Ascend token_block=4） |
| norm_fn / normw_merge | RMSNorm 归一化 / 权重合并 |
| head_compute_mix | 输出头混合 |
| post | post 混合 + 残差相加 |
| multilayer_recompute | 多层重计算 |

## 三、备注

- MHA 为 tilelang 教学级单头实现，多头需按 batch 维展开；GQA 见同目录 `example_gqa.py`
- mHC 中 7168 对应 V4-Pro（61 层，1.6T 总参/49B 激活），4096 对应 V4-Flash（43 层，284B/13B）
- mHC 替换 V4 所有层间残差连接，每 block 含 attn_hc / ffn_hc 两个模块，流全程保持 [B, S, 4, D]，末尾 HyperHead 折叠回单流
- mHC 混合矩阵经 Sinkhorn-Knopp 迭代投影至双随机矩阵流形，保证深层堆叠非扩张

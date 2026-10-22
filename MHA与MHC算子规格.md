# MHA 与 mHC 算子规格

## 一、MHA

参考代码仓：`https://github.com/tile-ai/tilelang/blob/main/examples/ascend/flash_attention/example_mha.py`

参数配置：D=128（builder 内 assert 硬约束）、block_kv=128（kernel 内部 tile 固定）

### 计算属性

| 计算属性 | | |
|---|---|---|
| num_heads | 静态 | 1 |
| head_dim | 静态 | 128 |
| scaling（注意力分数缩放系数） | 静态 | 1/√128 = 0.0884 |
| causal（因果掩码） | 静态 | 无（全量双向注意力） |
| dropout（随机丢弃概率） | 静态 | 0 |
| seq_len/sq | 动态 | 需满足 sq % block_q == 0 |
| kv_length/T（KV 序列轴长度） | 动态 | 需满足 T % 128 == 0 |

### 输入输出

| 输入输出 | | | |
|---|---|---|---|
| input: | Q | shape:[sq, 128] | dtype:BF16 |
| | K | shape:[T, 128] | dtype:BF16 |
| | V | shape:[T, 128] | dtype:BF16 |
| output: | O | shape:[sq, 128] | dtype:FP32 |

## 二、mHC

参考代码仓：`https://github.com/deepseek-ai/TileKernels`（`tile_kernels/mhc/`）

参数配置：`hc_mult=4, hc_sinkhorn_iters=20, hc_eps=1e-6`（DeepSeek V4 config.json；hidden_size：V4-Pro = 7168 / V4-Flash = 4096）

### 计算属性

| 计算属性 | | |
|---|---|---|
| hc_mult（流数 n） | 静态 | 4 |
| hidden_size | 静态（编译期确定） | V4-Pro = 7168 / V4-Flash = 4096 |
| hc_sinkhorn_iters | 静态 | 20 |
| hc_eps / mhc_pre_eps | 静态 | 1e-6 |
| rms_eps | 静态 | 1e-6 |
| num_tokens | 动态 | 512 ~ 8192+ |
| 数据类型 | 静态 | residual/hidden：BF16；mix/scale/累加：FP32 |

### 输入输出（以 pre_big_fuse_fwd / post 为代表）

| 输入输出 | | | |
|---|---|---|---|
| input: | residual | shape:[num_tokens, 4, hidden] | dtype:BF16 |
| | comb_mix | shape:[num_tokens, 4, 4] | dtype:FP32 |
| | post_mix | shape:[num_tokens, 4] | dtype:FP32 |
| | mhc_scale | shape:[3] | dtype:FP32 |
| | mhc_base | shape:[24] | dtype:FP32 |
| | gemm_out_mul | shape:[1, num_tokens, 24] | dtype:FP32 |
| | gemm_out_sqrsum | shape:[1, num_tokens] | dtype:FP32 |
| output: | layer_input | shape:[num_tokens, hidden] | dtype:BF16 |
| | residual（更新后） | shape:[num_tokens, 4, hidden] | dtype:BF16 |

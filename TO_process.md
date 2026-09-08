如题所示, 本指南讲述 tilelang 生成 mlir 借助` triton-opentile` 框架跑通的流程

## 环境准备

### 安装`triton-opentile`

进入容器后, 一定要

1. `pip uninstall triton-ascend`
2. `pip uninstall triton-opentile` (如果有的话)

然后点击[链接](https://clouddrive.huawei.com/p/90c01ebefe401ed9940b65f503878f99) 下载指定版本 `triton-opentile` 进行安装

### 给TO 打 patch 跑自定义.o文件

点击[此链接](https://clouddrive.huawei.com/p/730f2d4ccdb9dd2ea790604664ff8745)下载打patch脚本 `patch_installed_kernel_path.py`

在安装 `TO` 后直接运行:

```python
python patch_installed_kernel_path.py
```

注意: 后续版本对相关代码改动较大, 该脚本只适用于以上指定版本`triton-opentile`

#### 后续运行算子所需环境变量

```shell
export KERNEL_PATH=/path/to/kernel.o

export KERNEL_CV_MODE=mix # FA is mix, can be aic, aiv
```

## 运行算子

### 编译mlir

将我提供的 `fa_m_s64x64_npu.mlir` 文件, 经过以下编译流程:

```shell
#step 1
tile-opt --cce-pipeline="target=dav-351x" fa_m_s64x64_npu.mlir -o fa_m_s64x64_cce.mlir

#step 2
tile-translate --cce-to-backend -allow-unregistered-dialect fa_m_s64x64_cce.mlir -o fa_64x64.ll

#step 3
ccec --cce-aicore-arch=dav-c310-cube --cce-aicore-only -cce-enable-mix -O2 -cce-bitcode-is-aicore -c -v fa_64x64.ll -o fa_64x64.o
```

获得二进制文件

### 运行triton测试文件

我运行的triton测试文件如下所示:

```python
"""Simple dense FlashAttention forward.

Inputs are only Q, K, V, O with layout [B, H, S, D] = [1, 1, 4096, 128].
No mask, cu_seqlens, GQA, or LSE. Full (non-causal) attention.

Usage:
    python test_fa_simple.py
"""

import math

import torch
import torch_npu
import triton
import triton.language as tl

BATCH = 1
HEADS = 1
SEQ_LEN = 4096
HEAD_DIM = 128
BLOCK_M = 64
BLOCK_N = 64

@triton.jit
def load_if(block_ptr, EVEN_M: tl.constexpr, EVEN_N: tl.constexpr):
    if EVEN_M & EVEN_N:
        return tl.load(block_ptr)
    elif EVEN_M:
        return tl.load(block_ptr, boundary_check=(1,), padding_option="zero")
    elif EVEN_N:
        return tl.load(block_ptr, boundary_check=(0,), padding_option="zero")
    else:
        return tl.load(block_ptr, boundary_check=(0, 1), padding_option="zero")

@triton.jit
def store_if(block_ptr, value, EVEN_M: tl.constexpr, EVEN_N: tl.constexpr):
    if EVEN_M & EVEN_N:
        tl.store(block_ptr, value)
    elif EVEN_N:
        tl.store(block_ptr, value, boundary_check=(0,))
    elif EVEN_M:
        tl.store(block_ptr, value, boundary_check=(1,))
    else:
        tl.store(block_ptr, value, boundary_check=(0, 1))

@triton.jit
def what_kernel( # use this name to bypass tile-opt's whitelist
    q_ptr,
    k_ptr,
    v_ptr,
    o_ptr,
    stride_qm,
    stride_qk,
    stride_kn,
    stride_kk,
    stride_vn,
    stride_vk,
    stride_om,
    stride_ok,
    scale,
    SEQ_LEN: tl.constexpr,
    HEAD_DIM: tl.constexpr,
    BLOCK_M: tl.constexpr,
    BLOCK_N: tl.constexpr,
):
    dtype = o_ptr.type.element_ty
    start_m = tl.program_id(0)

    q_block_ptr = tl.make_block_ptr(
        base=q_ptr,
        shape=(SEQ_LEN, HEAD_DIM),
        strides=(stride_qm, stride_qk),
        offsets=(start_m * BLOCK_M, 0),
        block_shape=(BLOCK_M, HEAD_DIM),
        order=(1, 0),
    )
    k_block_ptr = tl.make_block_ptr(
        base=k_ptr,
        shape=(HEAD_DIM, SEQ_LEN),
        strides=(stride_kk, stride_kn),
        offsets=(0, 0),
        block_shape=(HEAD_DIM, BLOCK_N),
        order=(0, 1),
    )
    v_block_ptr = tl.make_block_ptr(
        base=v_ptr,
        shape=(SEQ_LEN, HEAD_DIM),
        strides=(stride_vn, stride_vk),
        offsets=(0, 0),
        block_shape=(BLOCK_N, HEAD_DIM),
        order=(1, 0),
    )
    o_block_ptr = tl.make_block_ptr(
        base=o_ptr,
        shape=(SEQ_LEN, HEAD_DIM),
        strides=(stride_om, stride_ok),
        offsets=(start_m * BLOCK_M, 0),
        block_shape=(BLOCK_M, HEAD_DIM),
        order=(1, 0),
    )

    acc = tl.zeros((BLOCK_M, HEAD_DIM), dtype=tl.float32)
    m_i = tl.full((BLOCK_M,), value=-(2**30), dtype=tl.float32)
    l_i = tl.zeros((BLOCK_M,), dtype=tl.float32)
    q = load_if(q_block_ptr, True, True)

    for start_n in range(0, SEQ_LEN, BLOCK_N):
        start_n = tl.multiple_of(start_n, BLOCK_N)
        k = load_if(k_block_ptr, True, True)
        s = tl.dot(q, k) * scale
        m_new = tl.maximum(m_i, tl.max(s, 1), propagate_nan=tl.PropagateNan.ALL)
        p = tl.math.exp(s - m_new[:, None])
        v = load_if(v_block_ptr, True, True)
        acc = acc * tl.math.exp(m_i - m_new)[:, None] + tl.dot(p.to(dtype), v.to(dtype))
        l_i = l_i * tl.math.exp(m_i - m_new) + tl.sum(p, 1)
        m_i = m_new
        k_block_ptr = tl.advance(k_block_ptr, (0, BLOCK_N))
        v_block_ptr = tl.advance(v_block_ptr, (BLOCK_N, 0))

        store_if(o_block_ptr, (acc / l_i[:, None]).to(dtype), True, True)


def flash_attn_fwd(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    """q/k/v/o: [B, H, S, D] = [1, 1, 4096, 128], contiguous, fp16."""
    assert q.shape == k.shape == v.shape == (BATCH, HEADS, SEQ_LEN, HEAD_DIM)
    assert q.is_contiguous() and k.is_contiguous() and v.is_contiguous()
    o = torch.empty_like(q).float()
    scale = 1.0 / math.sqrt(HEAD_DIM)
    grid = ((SEQ_LEN // BLOCK_M),)
    what_kernel[grid](
        q,
        k,
        v,
        o,
        q.stride(2),
        q.stride(3),
        k.stride(2),
        k.stride(3),
        v.stride(2),
        v.stride(3),
        o.stride(2),
        o.stride(3),
        scale,
        SEQ_LEN=SEQ_LEN,
        HEAD_DIM=HEAD_DIM,
        BLOCK_M=BLOCK_M,
        BLOCK_N=BLOCK_N,
    )
    return o

def reference_attn(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    scale = 1.0 / math.sqrt(HEAD_DIM)
    qf, kf, vf = q.float(), k.float(), v.float()
    attn = torch.softmax(qf @ kf.transpose(-1, -2) * scale, dim=-1)
    return (attn @ vf).to(q.dtype)

def test_fa_simple_fwd():
    # torch.npu.manual_seed(42)
    dtype = torch.bfloat16
    q = torch.randn(BATCH, HEADS, SEQ_LEN, HEAD_DIM, device="npu", dtype=dtype) * 0.1
    k = torch.randn(BATCH, HEADS, SEQ_LEN, HEAD_DIM, device="npu", dtype=dtype) * 0.1
    v = torch.randn(BATCH, HEADS, SEQ_LEN, HEAD_DIM, device="npu", dtype=dtype) * 0.1

    o = flash_attn_fwd(q, k, v)
    torch.npu.synchronize()
    golden = reference_attn(q, k, v)
    torch.npu.synchronize()
    o = o.cpu()
    golden = golden.cpu()

    torch.testing.assert_close(o.float(), golden.float(), rtol=1e-3, atol=1e-3, equal_nan=True)
    print(
        f"pass: Q/K/V/O {[BATCH, HEADS, SEQ_LEN, HEAD_DIM]} "
        f"BLOCK_M={BLOCK_M} BLOCK_N={BLOCK_N} dtype={dtype} grid={(SEQ_LEN //  BLOCK_M)}"
    )

if __name__ == "__main__":
    test_fa_simple_fwd()

```

一定要先 export 上面的环境变量, 然后就可以了


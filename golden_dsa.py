"""Golden reference for DSA sparse attention with AttnSink.

kernel_runner 传入的 Q/KV 是 uint16 (bf16 的 bit pattern)，
需要 .view(torch.bfloat16) 恢复语义后再转 float32 计算。

Computes: for each query row q, select top_k KV rows by TopKIndices,
then O[q] = softmax(Q[q] @ K_sparse^T * scale, sink=AttnSink) @ V_sparse.

The online-softmax in the kernel initialises m = AttnSink, l = 1.0,
which is equivalent to adding a "sink" term exp(AttnSink - m_final) to
the denominator l.
"""

import math

import torch


def dsa_golden(Q, KV, AttnSink, TopKIndices, O=None, cid=None, vid=None):
    """
    Args:
        Q:            [batch, seq_len, num_heads, dim] uint16 (bf16 bits)
        KV:           [batch, seq_len_kv, dim]          uint16 (bf16 bits)
        AttnSink:     [num_heads]                       f32
        TopKIndices:  [batch, seq_len, top_k]           i32
        O:            output buffer (ignored)
        cid, vid:     block index args (ignored)
    Returns:
        O_golden:     [batch, seq_len, num_heads, dim]  f32
    """
    batch, seq_len, num_heads, dim = Q.shape
    top_k = TopKIndices.shape[-1]
    scale = 1.0 / math.sqrt(dim)

    # uint16 -> bfloat16 -> float32
    Q_f32 = Q.view(torch.bfloat16).float()
    KV_f32 = KV.view(torch.bfloat16).float()
    AttnSink_f32 = AttnSink.float()

    # Gather sparse K/V for all queries: [batch, seq_len, top_k, dim]
    K_sparse = KV_f32[
        torch.arange(batch, device=Q.device).view(batch, 1, 1),
        TopKIndices.long(),
    ]  # [batch, seq_len, top_k, dim]

    # S = Q @ K^T / sqrt(d): [batch, seq_len, num_heads, top_k]
    S = torch.einsum("bqhd,bqkd->bqhk", Q_f32, K_sparse) * scale

    # m = max(max(S), AttnSink): [batch, seq_len, num_heads]
    m = torch.maximum(
        S.max(dim=-1).values,
        AttnSink_f32.view(1, 1, num_heads),
    )

    # P = exp(S - m): [batch, seq_len, num_heads, top_k]
    P = torch.exp(S - m.unsqueeze(-1))

    # sink term: exp(AttnSink - m), accounts for initial l=1.0, m=AttnSink
    sink = torch.exp(AttnSink_f32.view(1, 1, num_heads) - m)

    # l = sum(P) + sink
    l = P.sum(dim=-1) + sink

    # O = P @ V / l, where V = K_sparse (same KV tensor)
    O_golden = torch.einsum("bqhk,bqkd->bqhd", P, K_sparse)
    O_golden = O_golden / l.unsqueeze(-1)

    return O_golden

"""speculative-decode 三次归因：完整 bias 行映射恢复。

diag2 Part2 已证：S_q=4 时 kernel 的全部输出行都等于"全可见"掩码的参考——
逐行 causal 掩码未生效。本脚本用 S_q=16（BR 全为真行）+ 互异 q 行，对每个
(batch, query行) 在 16 个候选掩码参考里找最近者，输出完整的
"输出行 -> bias行" 映射矩阵；错位模式（固定偏移 / 交织 / 分半）直接显形。
同时对比乱序表 vs 顺序表，复验 diag1 的 b0/b1 不对称现象。

在 ~/TileOPs 下运行：python3 diag3_specdec.py
"""

import torch
import torch_npu  # noqa: F401
import sys

sys.path.insert(0, "/home/z30086261/TileOPs")

from workloads.device import set_run_device  # noqa: E402

set_run_device(torch.device("npu", 0))

from workloads.attention.mha import MHADecodePagedWorkload  # noqa: E402
from tileops.ops import MHADecodePagedWithKVCacheFwdOp  # noqa: E402

B, H, S_Q, N_KV, D, PAGE = 2, 8, 16, 1024, 64, 256
RL = 1000
OP = MHADecodePagedWithKVCacheFwdOp(PAGE, target="ascend")


def ref_rows(q, k, v, real, table):
    """返回 rows[b][r] = "query 行 r 按 r 的语义掩码" 的参考输出（fp32）。"""
    W = table.shape[1]
    dev = q.device
    rows_out = []
    for b in range(q.shape[0]):
        prows = (table[b][:, None] * PAGE + torch.arange(PAGE, device=dev).view(1, -1)).reshape(-1)
        kb, vb = k[prows].float(), v[prows].float()
        rl = int(real[b])
        kb, vb = kb[:rl], vb[:rl]
        per_r = []
        for r in range(S_Q):
            seen = max(rl - S_Q + r + 1, 0)  # 官方语义：可见 kv <= r + rl - S_Q
            s = torch.einsum("hd,rhd->hr", q[b, r].float(), kb[:seen]) * (D ** -0.5)
            p = torch.softmax(s, dim=-1)
            per_r.append(torch.einsum("hr,rhd->hd", p, vb[:seen]))
        rows_out.append(per_r)
    return rows_out


def recover(tag, table_override=None):
    wl = MHADecodePagedWorkload(B, H, S_Q, N_KV, D, PAGE, True, torch.float16)
    q, k, v, real, table = wl.gen_inputs()
    real = torch.tensor([RL] * B, dtype=torch.int32, device=real.device)
    if table_override is not None:
        table = table_override.contiguous()
    got = OP(q, k, v, real, table)
    refs = ref_rows(q, k, v, real, table)
    print(f"\n[{tag}] 输出行 -> 最像的语义行（应为恒等 r->r）")
    for b in range(B):
        mapping = []
        for r in range(S_Q):
            dists = [(float((got[b, r].float() - refs[b][m]).abs().max()), m)
                     for m in range(S_Q)]
            dists.sort()
            mapping.append(f"r{r}->{dists[0][1]}({dists[0][0]:.1e})")
        print(f"  batch{b}: " + " ".join(mapping))


torch.manual_seed(0)
recover("A 乱序表(官方生成)")

ordered = torch.arange(B * (N_KV // PAGE), dtype=torch.int32,
                       device=torch.device("npu", 0)).reshape(B, N_KV // PAGE)
recover("B 顺序表", ordered)

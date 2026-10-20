"""speculative-decode 二次归因：rl 扫描失败边界 + bias 行映射恢复。

已证：基础路径（non-causal）全对；causal 下 rl=1000 失败（行 0-2 错、行 3 准），
而 cache_shorter 的 causal rl=700 通过——700 的尾 tile 全掩（被 T.If 跳过），
1000 的尾 tile 部分可见。本脚本：
  Part1  rl 扫描（896/960/992/1000/1024/704/768）画失败面：1024 应零错，
         768 应与 704 同构；看失败是否只在"尾 tile 部分可见"区间。
  Part2  同内容 q 行探针：B=1、4 个 q 行全同。causal 语义下行 r 的输出只随
         掩码 m_r 变化；对每个输出行在 4 个候选掩码参考里找最近者，恢复
         "输出行 -> 掩码行" 的实际映射。若非恒等，错位模式直接显形。

在 ~/TileOPs 下运行：python3 diag2_specdec.py
"""

import torch
import torch_npu  # noqa: F401
import sys

sys.path.insert(0, "/home/z30086261/TileOPs")

from workloads.device import set_run_device  # noqa: E402

set_run_device(torch.device("npu", 0))

from workloads.attention.mha import MHADecodePagedWorkload  # noqa: E402
from tileops.ops import MHADecodePagedWithKVCacheFwdOp  # noqa: E402

B, H, S_Q, N_KV, D, PAGE = 2, 8, 4, 1024, 64, 256
OP = MHADecodePagedWithKVCacheFwdOp(PAGE, target="ascend")


def ref_attn(q, k, v, real, table, mask_cut=None):
    """纯 torch 参考，按 head 分组；池全局共享，物理行经 block_table 间接寻址。"""
    S_q = q.shape[1]
    W = table.shape[1]
    dev = q.device
    out = torch.empty_like(q, dtype=torch.float32)
    for b in range(q.shape[0]):
        rows = (table[b][:, None] * PAGE + torch.arange(PAGE, device=dev).view(1, -1)).reshape(-1)
        kb, vb = k[rows].float(), v[rows].float()  # [W*PAGE, H, D]
        rl = int(real[b])
        kb, vb = kb[:rl], vb[:rl]
        for i in range(S_q):
            seen = rl - S_Q + i if mask_cut is None else rl - (mask_cut[i] if i < S_Q else 10**9)
            seen = max(seen, 0)
            s = torch.einsum("hd,rhd->hr", q[b, i].float(), kb[:seen]) * (D ** -0.5) * (D ** -0.5)
            p = torch.softmax(s, dim=-1)
            out[b, i] = torch.einsum("hr,rhd->hd", p, vb[:seen])
    return out


print("=== Part1: rl 扫描（per-(b,row) max_abs）===")
for rl in [1024, 1000, 992, 960, 896, 768, 704]:
    wl = MHADecodePagedWorkload(B, H, S_Q, N_KV, D, PAGE, True, torch.float16)
    q, k, v, real, table = wl.gen_inputs()
    real = torch.tensor([rl] * B, dtype=torch.int32, device=real.device)
    got = OP(q, k, v, real, table)
    exp = ref_attn(q, k, v, real, table)
    absd = (got.float() - exp).abs().reshape(B, S_Q, -1).amax(dim=2)
    n_bad = int(((got.float() - exp).abs() > 1e-3).sum())
    rows = "; ".join(" ".join(f"{absd[b, i]:7.1e}" for i in range(S_Q)) for b in range(B))
    print(f"  rl={rl:<5} bad={n_bad:<5} per-(b,row): {rows}")

print("\n=== Part2: 同内容 q 行探针（rl=1000, B=1）===")
wl = MHADecodePagedWorkload(1, H, S_Q, N_KV, D, PAGE, True, torch.float16)
q, k, v, real, table = wl.gen_inputs()
real = torch.tensor([1000], dtype=torch.int32, device=real.device)
q = q[:, 0:1].expand(-1, S_Q, -1, -1).contiguous()  # 4 行内容全同
got = OP(q, k, v, real, table)
# 4 个候选掩码参考：行 i 的语义 = 键可见到 rl-S_Q+i
cands = [ref_attn(q, k, v, real, table, mask_cut=[S_Q - 1 - i] * S_Q) for i in range(S_Q)]
for r in range(S_Q):
    dists = [(float((got[0, r].float() - c[0, 0].float()).abs().max()), m)
             for m, c in enumerate(cands)]
    dists.sort()
    print(f"  输出行{r} -> 最像掩码行{dists[0][1]} (差={dists[0][0]:.2e})；"
          f"次近=掩码行{dists[1][1]} (差={dists[1][0]:.2e})")

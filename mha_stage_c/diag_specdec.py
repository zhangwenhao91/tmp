"""speculative-decode 单 case 正交归因。

manifest 覆盖中该 case（B2 H8 S_q4 kv1000 p256 D64 causal）1e-3 判据下 28.5%
元素超差。本脚本用同一输入在四个正交变体下复算，分离因果因素：
  A baseline          ：causal + 乱序表（复现 FAIL）
  B non-causal        ：同输入关 causal（区分 causal 掩码 vs 基础路径）
  C causal + 顺序表   ：把乱序表换成顺序页（区分 causal 掩码 vs 页寻址）
  D S_q=1             ：其余不变只降 S_q（区分 S_q 多行路径）
每个变体打印逐 (b, q行, h) 的 max_abs 热力矩阵。

在 ~/TileOPs 下运行：python3 diag_specdec.py
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
KV_LENS = [1000, 1000]


def heat(tag, got, exp):
    g, e = got.float(), exp.float()
    absd = (g - e).abs()
    bad = absd > 1e-3
    per_row = absd.reshape(B, S_Q, H, D).amax(dim=(2, 3))
    print(f"\n[{tag}] 错元素 {bad.sum().item()}/{bad.numel()} "
          f"({100.0 * bad.sum().item() / bad.numel():.1f}%), "
          f"max_abs={absd.max().item():.4e}")
    print("  逐(b, q行) max_abs 矩阵：")
    for b in range(B):
        print("   ", " ".join(f"{per_row[b, i].item():8.2e}" for i in range(S_Q)) + f"   <- batch{b}")
    idx = absd.flatten().argmax().item()
    row = per_row.reshape(-1)
    print(f"  最差元素 (b={idx // (S_Q * H * D)}, sq={(idx // (H * D)) % S_Q}, "
          f"h={(idx // D) % H}, d={idx % D})")


def run(tag, sq, causal, order_table):
    wl = MHADecodePagedWorkload(B, H, sq, N_KV, D, PAGE, causal, torch.float16)
    q, k, v, real, table = wl.gen_inputs()
    real = torch.tensor(KV_LENS, dtype=torch.int32, device=real.device)
    if order_table:
        table = torch.arange(B * (N_KV // PAGE), dtype=torch.int32,
                             device=table.device).reshape(B, N_KV // PAGE).contiguous()
    got = MHADecodePagedWithKVCacheFwdOp(PAGE, target="ascend")(q, k, v, real, table)
    exp = wl.ref_program(q, k, v, real, table)
    heat(tag, got, exp)


run("A causal+乱序表(基线)", S_Q, True, False)
run("B non-causal 同输入", S_Q, False, False)
run("C causal+顺序表", S_Q, True, True)

wl1 = MHADecodePagedWorkload(B, H, 1, N_KV, D, PAGE, True, torch.float16)
q, k, v, real, table = wl1.gen_inputs()
real = torch.tensor(KV_LENS, dtype=torch.int32, device=real.device)
got1 = MHADecodePagedWithKVCacheFwdOp(PAGE, target="ascend")(q, k, v, real, table)
exp1 = wl1.ref_program(q, k, v, real, table)
heat("D S_q=1 其余不变", got1, exp1)

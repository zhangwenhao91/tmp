"""探针 1（tilelang 0.1.15 原生 Ascend JIT 链路）：运行时间接寻址。

验证点 R1：kernel 内从 GM load `block_table` 得到页号 pid（运行时标量），
再用 pid 计算偏移做 T.copy 页级 gather。与 torch gather 结果逐元素比对，
一致则"间接寻址"在本 JIT 链路成立（paged decode kernel 的最大风险点）。

说明：flash_attention 例子里 `K[kv*BC:(kv+1)*BC, ...]` 的 kv 是循环变量
（也是一种运行时值），本探针进一步验证"值来自 GM load"的场景。

shape：B=2, H=4, D=128, PAGE=64, W=8；pool [B*W*PAGE, H, D] fp16。
kernel：grid=B，block 内 T.serial(H)；每 (b, h) 取 block_table[b,0] 号页，
copy [pid*PAGE, (pid+1)*PAGE, h, :] → O[b, h, 0:PAGE, :]（纯拷贝，应逐位一致）。
"""

import torch
import tilelang
import tilelang.ascend.language as T

B, H, D, PAGE, W = 2, 4, 128, 64, 8
NKV = B * W * PAGE
dtype = "float16"


@T.prim_func
def gather_probe(
    BT: T.Buffer((B, W), "int32"),
    KP: T.Buffer((NKV, H, D), dtype),
    O: T.Buffer((B, H, PAGE, D), dtype),
):
    with T.Kernel(B) as bx:
        K_shared = T.alloc_l1((PAGE, D), dtype)
        for h in T.serial(H):
            pid = BT[bx, 0]
            T.copy(KP[pid * PAGE:(pid + 1) * PAGE, h, :], K_shared[0:PAGE, 0:D])
            T.copy(K_shared[0:PAGE, 0:D], O[bx, h, 0:PAGE, 0:D])


def main():
    torch.manual_seed(0)
    dev = torch.device("npu")
    bt = torch.randint(0, B * W, (B, W), dtype=torch.int32, device=dev)
    kp = torch.randn(NKV, H, D, dtype=torch.float16, device=dev)
    o = torch.zeros(B, H, PAGE, D, dtype=torch.float16, device=dev)

    print("compiling gather_probe ...")
    kernel = tilelang.compile(gather_probe)
    kernel(bt, kp, o)
    torch.npu.synchronize()

    # 期望：exp[b, h] = kp[pid_b*PAGE : (pid_b+1)*PAGE, h, :]
    rows = bt[:, 0].long() * PAGE + torch.arange(PAGE, device=dev)  # [B, PAGE]
    exp = kp[rows].permute(0, 2, 1, 3).contiguous()  # [B, H, PAGE, D]

    diff = (o.float() - exp.float()).abs().max().item()
    print(f"max_abs_diff = {diff}")
    ok = torch.equal(o, exp)
    print("PASS: probe_gather" if ok else f"FAIL: probe_gather (bitwise mismatch, diff={diff})")


if __name__ == "__main__":
    main()

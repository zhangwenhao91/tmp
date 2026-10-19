"""探针 2（tilelang 0.1.15 原生 Ascend JIT 链路）：运行时守卫 + 动态执行。

验证点 R2：kernel 内 load `real_seqlen_kv[b]`（GM int32 标量），
在 `T.serial(W)` 静态上限循环里用 `T.If` 守卫页拷贝——
seq 覆盖到的页执行拷贝，覆盖不到的页跳过（对应 decode 的变长早退语义）。

同时覆盖标量 LetStmt 形态（`rl = RL[bx]`、`pid = BT[bx, t]`）
以及循环变量+GM 标量混合的地址算术（`pid * PAGE`）。

方法：宿主端 O 预填 0；kernel 对每页写独立槽位（不累加，纯拷贝+控制流）。
校验：t*PAGE < rl 的槽位 == torch gather；其余槽位必须仍为 0。

shape：B=2, H=2, D=128, PAGE=64, W=8；pool [B*W*PAGE, H, D] fp16。
"""

import torch
import tilelang
import tilelang.language as T

B, H, D, PAGE, W = 2, 2, 128, 64, 8
NKV = B * W * PAGE
dtype = "float16"


@T.prim_func
def dynloop_probe(
    BT: T.Buffer((B, W), "int32"),
    RL: T.Buffer((B,), "int32"),
    KP: T.Buffer((NKV, H, D), dtype),
    O: T.Buffer((B, H, W, PAGE, D), dtype),
):
    with T.Kernel(B) as bx:
        K_shared = T.alloc_l1((PAGE, D), dtype)
        for h in T.serial(H):
            rl = RL[bx]
            for t in T.serial(W):
                with T.If(t * PAGE < rl):
                    with T.Then():
                        pid = BT[bx, t]
                        T.copy(KP[pid * PAGE:(pid + 1) * PAGE, h, :], K_shared[0:PAGE, 0:D])
                        T.copy(K_shared[0:PAGE, 0:D], O[bx, h, t, 0:PAGE, 0:D])


def main():
    torch.manual_seed(0)
    dev = torch.device("npu")
    bt = torch.randint(0, B * W, (B, W), dtype=torch.int32, device=dev)
    # 每请求覆盖不同页数：b=0 覆盖 3.5 页（100 个 key），b=1 覆盖 8 页（满）
    rl = torch.tensor([100, W * PAGE], dtype=torch.int32, device=dev)
    kp = torch.randn(NKV, H, D, dtype=torch.float16, device=dev)
    o = torch.zeros(B, H, W, PAGE, D, dtype=torch.float16, device=dev)

    print("compiling dynloop_probe ...")
    kernel = tilelang.compile(dynloop_probe)
    kernel(bt, rl, kp, o)
    torch.npu.synchronize()

    covered = torch.arange(W, device=dev) * PAGE < rl[:, None]  # [B, W]
    all_ok, max_diff = True, 0.0
    for b in range(B):
        for t in range(W):
            slot = o[b, :, t]  # [H, PAGE, D]
            if covered[b, t]:
                pid = int(bt[b, t])
                exp = kp[pid * PAGE:(pid + 1) * PAGE].permute(1, 0, 2)  # [H, PAGE, D]
                d = (slot.float() - exp.float()).abs().max().item()
                if not torch.equal(slot, exp):
                    all_ok = False
                max_diff = max(max_diff, d)
            else:
                if slot.abs().max().item() != 0.0:
                    print(f"FAIL: slot (b={b}, t={t}) should be untouched-zero but got "
                          f"{slot.abs().max().item()}")
                all_ok = False if slot.abs().max().item() != 0.0 else all_ok

    covered_n = int(covered.sum())
    print(f"covered slots: {covered_n}/{B * W}, max_abs_diff(covered) = {max_diff}")
    print("PASS: probe_dynloop" if all_ok else "FAIL: probe_dynloop")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""mHC AscendC 版 (cann/ops-transformer mhc_pre_sinkhorn_premix) vs TileLang 版
(deepseek-ai/TileKernels tile_kernels/mhc) 性能对比脚本。

在 Ascend 950PR/950DT 上运行（CANN >= 9.2.0）。

两边语义对齐（premix=None 时逐算子等价）：
  AscendC mhc_pre_sinkhorn_premix(x[T,N,C] bf16, phi[24,4C] fp32, alpha[3], bias[24], 4, 20, 1e-6, 1e-6)
      -> hin[T,C] bf16, hPost[T,4] fp32(=2*sigmoid), hRes[T,16] fp32(Sinkhorn 20 iters)
  TileLang mhc_pre_big_fuse_fwd(gemm_out_mul[1,T,24], gemm_out_sqrsum[1,T], scale[3], base[24],
                                residual[T,4,C] bf16, ...) -> layer_input, post_mix, comb_mix
  其中 gemm_out = residual_flat[T,4C] @ fn.T（TileLang 侧由外部 GEMM 产生，官方基准同样不含 GEMM）。

用法:
  python3 bench_mhc_compare.py                       # 全部对比
  python3 bench_mhc_compare.py --skip-ascendc        # 只跑 TileLang
  python3 bench_mhc_compare.py --skip-tilelang       # 只跑 AscendC
  python3 bench_mhc_compare.py --t 512 2048 8192 --c 4096 7168
"""

import argparse
import csv
import sys
import time

import torch
import torch_npu  # noqa: F401

HC = 4                     # 残差流数 N（两边均固定为 4）
HC3 = HC * 2 + HC * HC     # 24 = pre(4) + post(4) + res(16)
NUM_ITERS = 20             # Sinkhorn 迭代（AscendC 仅支持 20）
EPS = 1e-6                 # 两边所有 eps 统一为 1e-6
POST_MULT = 2.0            # TileLang 的 mhc_post_mult_value，对应 AscendC 内置的 2*sigmoid


def bench_us(fn, warmup=10, iters=50):
    """返回 (mean_us, min_us)：NPU 同步计时。"""
    for _ in range(warmup):
        fn()
    torch.npu.synchronize()
    ts = []
    for _ in range(iters):
        t0 = time.perf_counter()
        fn()
        torch.npu.synchronize()
        ts.append((time.perf_counter() - t0) * 1e6)
    return sum(ts) / len(ts), min(ts)


def make_inputs(t, c, device, seed=0):
    g = torch.Generator(device='cpu').manual_seed(seed)
    x = (torch.randn(t, HC, c, generator=g) * 0.5).to(torch.bfloat16).to(device)      # AscendC TND / TileLang residual
    phi = torch.randn(HC3, HC * c, generator=g).to(torch.float32).to(device) / (HC * c) ** 0.5
    alpha = (torch.randn(3, generator=g) * 0.5 + 1.0).to(torch.float32).to(device)
    bias = (torch.randn(HC3, generator=g) * 0.5).to(torch.float32).to(device)
    return x, phi, alpha, bias


# ---------------------------------------------------------------------------
# TileLang 侧
# ---------------------------------------------------------------------------
def make_gemm_partials(x, phi):
    """复刻 TileLang 官方基准：prenorm GEMM 的输出（GEMM 本体在 DeepGEMM 中，不计入 kernel 时间）。"""
    t, _, c = x.shape
    x_flat = x.float().reshape(t, HC * c)                 # [T, 4C] fp32
    out_mul = torch.einsum('tk,nk->tn', x_flat, phi)      # [T, 24] fp32
    sqrsum = x_flat.square().sum(-1)                      # [T] fp32
    return out_mul[None], sqrsum[None]                    # [1,T,24], [1,T]


def run_tilelang(x, phi, alpha, bias, sinkhorn_repeat=NUM_ITERS):
    from tile_kernels.mhc.pre_big_fuse_kernel import mhc_pre_big_fuse_fwd
    from tile_kernels.mhc.post_kernel import mhc_post_fwd

    t, _, c = x.shape
    gemm_mul, gemm_sqr = make_gemm_partials(x, phi)

    post_mix = torch.empty(1, t, HC, 1, dtype=torch.float32, device=x.device)
    comb_mix = torch.empty(1, t, HC, HC, dtype=torch.float32, device=x.device)
    layer_input = torch.empty(1, t, c, dtype=torch.bfloat16, device=x.device)

    def fused():
        mhc_pre_big_fuse_fwd(
            gemm_mul, gemm_sqr, alpha, bias,
            x.view(t, HC, c), post_mix.view(t, HC), comb_mix.view(t, HC * HC),
            layer_input.view(t, c),
            rms_eps=EPS, mhc_pre_eps=EPS, mhc_sinkhorn_eps=EPS,
            mhc_post_mult_value=POST_MULT, sinkhorn_repeat=sinkhorn_repeat, n_splits=1,
        )
        return layer_input, post_mix, comb_mix

    def fused_with_gemm():
        make_gemm_partials(x, phi)
        fused()

    # post（= AscendC 侧无 950 对应算子，仅与 torch 参考对比）
    xx = torch.randn(1, t, c, dtype=torch.bfloat16, device=x.device)
    residual_out = torch.randn(1, t, HC, c, dtype=torch.bfloat16, device=x.device)
    plm = torch.randn(1, t, HC, 1, dtype=torch.float32, device=x.device)
    crm = torch.randn(1, t, HC, HC, dtype=torch.float32, device=x.device)
    post = lambda: mhc_post_fwd(xx, residual_out, plm, crm)

    out = fused()
    return {
        'fused': fused,
        'fused_with_gemm': fused_with_gemm,
        'gemm_only': lambda: make_gemm_partials(x, phi),
        'post': post,
        'outputs': out,
    }


# ---------------------------------------------------------------------------
# AscendC 侧
# ---------------------------------------------------------------------------
def run_ascendc(x, phi, alpha, bias):
    import cann_ops_transformer_customize  # noqa: F401  单算子 vendor 包
    op = torch.ops.cann_ops_transformer.mhc_pre_sinkhorn_premix

    premix = torch.empty(0, dtype=torch.float32, device=x.device)

    def fwd():
        return op(x, phi, alpha, bias, premix, HC, NUM_ITERS, EPS, EPS, False)[0]

    def fwd_full():
        return op(x, phi, alpha, bias, premix, HC, NUM_ITERS, EPS, EPS, True)

    hin, hpost, hres = fwd_full()[:3]
    return {'fused': fwd, 'outputs': (hin, hpost, hres)}


# ---------------------------------------------------------------------------
# 正确性交叉验证
# ---------------------------------------------------------------------------
def correctness(x, phi, alpha, bias, asc, tl):
    hin_a, hpost_a, hres_a = asc['outputs']
    layer_t, post_t, comb_t = tl['outputs']

    def report(name, a, b, rtol, atol):
        a, b = a.float(), b.float()
        d = (a - b).abs().max().item()
        ok = 'OK' if d <= atol + rtol * b.abs().max().item() else 'MISMATCH'
        print(f'    {name:<12} max|diff|={d:.3e}  [{ok}]')
        return d

    print('  [交叉验证] AscendC mhc_pre_sinkhorn_premix vs TileLang pre_big_fuse:')
    report('hin/layer', hin_a.view(-1), layer_t.view(-1), 0, 2e-2)
    report('hPost', hpost_a.view(-1), post_t.view(-1), 1e-3, 1e-3)
    report('hRes/comb', hres_a.view(-1), comb_t.view(-1), 1e-3, 1e-3)

    # TileLang post kernel vs torch einsum 参考
    return


def post_correctness(x_dev):
    from tile_kernels.mhc.post_kernel import mhc_post_fwd
    t, _, c = x_dev.shape
    xx = torch.randn(1, t, c, dtype=torch.bfloat16, device=x_dev.device)
    residual = torch.randn(1, t, HC, c, dtype=torch.bfloat16, device=x_dev.device)
    plm = torch.randn(1, t, HC, 1, dtype=torch.float32, device=x_dev.device)
    crm = torch.randn(1, t, HC, HC, dtype=torch.float32, device=x_dev.device)
    out = mhc_post_fwd(xx, residual, plm, crm)
    term2 = torch.einsum('abmn,abmc->abnc', crm, residual.float())
    ref = (xx.float().unsqueeze(-2) * plm + term2).bfloat16()
    d = (out.float() - ref.float()).abs().max().item()
    print(f'    post kernel  max|diff|={d:.3e}  [{"OK" if d <= 2e-2 else "MISMATCH"}]')


# ---------------------------------------------------------------------------
def io_gb_pre_ascendc(t, c):
    """AscendC premix 端到端 IO：x + phi + hin + hPost + hRes。"""
    return (t * HC * c * 2 + HC3 * HC * c * 4 + 3 * 4 + HC3 * 4
            + t * c * 2 + t * HC * 4 + t * HC * HC * 4) / 1e9


def io_gb_pre_bigfuse(t, c):
    return (t * HC3 * 4 + t * 4            # gemm_out_mul + sqrsum
            + t * HC * c * 2               # residual read
            + t * HC * 4 + t * HC * HC * 4 + t * c * 2) / 1e9  # post/comb/layer


def io_gb_post(t, c):
    return (t * c * 2 + t * HC * c * 2 + t * HC * 4 + t * HC * HC * 4
            + t * HC * c * 2) / 1e9


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--t', type=int, nargs='+', default=[512, 2048, 8192])
    p.add_argument('--c', type=int, nargs='+', default=[4096, 7168])  # AscendC 950 仅支持 4096/7168
    p.add_argument('--warmup', type=int, default=10)
    p.add_argument('--iters', type=int, default=50)
    p.add_argument('--skip-ascendc', action='store_true')
    p.add_argument('--skip-tilelang', action='store_true')
    p.add_argument('--csv', default='mhc_bench_result.csv')
    args = p.parse_args()

    torch.npu.set_device(0)
    dev = torch.device('npu')

    prop = torch.npu.get_device_properties(0)
    print('=' * 78)
    print('mHC 性能对比: AscendC (ops-transformer) vs TileLang (TileKernels)')
    print(f'  device={prop.name}  aicore={prop.cube_core_num}  '
          f'torch={torch.__version__}  torch_npu={torch.__version__}')
    print(f'  N={HC}, sinkhorn_iters={NUM_ITERS}, eps={EPS}, dtype=x:bf16/param:fp32')
    print('=' * 78)

    rows = []

    def record(op, impl, t, c, mean_us, min_us, io_gb):
        bw = io_gb / (mean_us * 1e-6)  # GB/s
        rows.append({'op': op, 'impl': impl, 'T': t, 'C': c,
                     'mean_us': round(mean_us, 2), 'min_us': round(min_us, 2),
                     'io_GB': round(io_gb, 4), 'GBps': round(bw, 1)})
        print(f'  {impl:<38} mean={mean_us:9.2f} us  min={min_us:9.2f} us  ~{bw:7.1f} GB/s')

    for t in args.t:
        for c in args.c:
            print(f'\n### shape: T={t}, N={HC}, C={c}')
            x, phi, alpha, bias = make_inputs(t, c, dev)

            asc = tl = None
            if not args.skip_ascendc:
                try:
                    asc = run_ascendc(x, phi, alpha, bias)
                except Exception as e:
                    print(f'  [AscendC] 初始化失败: {e}')
                    print('    (提示: 需先安装 ops-transformer experimental 单算子包, 见操作说明)')
                else:
                    print('  [AscendC] mhc_pre_sinkhorn_premix (含 GEMM, 单算子端到端):')
                    m, mn = bench_us(asc['fused'], args.warmup, args.iters)
                    record('pre_sinkhorn(+GEMM)', 'AscendC premix', t, c, m, mn, io_gb_pre_ascendc(t, c))

            if not args.skip_tilelang:
                try:
                    tl = run_tilelang(x, phi, alpha, bias)
                except Exception as e:
                    print(f'  [TileLang] 初始化失败: {e}')
                    print('    (提示: 需 pip install -e TileKernels 且 tilelang>=0.1.15)')
                else:
                    print('  [TileLang] pre_big_fuse (官方口径, 不含 GEMM):')
                    m, mn = bench_us(tl['fused'], args.warmup, args.iters)
                    record('pre_big_fuse(no GEMM)', 'TileLang big_fuse', t, c, m, mn, io_gb_pre_bigfuse(t, c))

                    print('  [TileLang] torch GEMM 单独计时 (供端到端参考):')
                    m, mn = bench_us(tl['gemm_only'], args.warmup, args.iters)
                    record('prenorm GEMM (torch)', 'torch GEMM', t, c, m, mn,
                           (t * HC * c * 2 + HC3 * HC * c * 4 + t * HC3 * 4 + t * 4) / 1e9)

                    print('  [TileLang] big_fuse + GEMM (端到端, 对标 AscendC 单算子):')
                    m, mn = bench_us(tl['fused_with_gemm'], args.warmup, args.iters)
                    record('big_fuse + torch GEMM', 'TileLang e2e', t, c, m, mn, io_gb_pre_ascendc(t, c))

                    print('  [TileLang] mhc_post (post+res 融合, AscendC 无 950 对应):')
                    m, mn = bench_us(tl['post'], args.warmup, args.iters)
                    record('post (post+res fused)', 'TileLang post', t, c, m, mn, io_gb_post(t, c))

            if asc is not None and tl is not None:
                correctness(x, phi, alpha, bias, asc, tl)
                post_correctness(x)

    with open(args.csv, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['op', 'impl', 'T', 'C', 'mean_us', 'min_us', 'io_GB', 'GBps'])
        w.writeheader()
        w.writerows(rows)
    print(f'\n结果已写入 {args.csv}')

    print('\n=== 汇总（同一 shape 下 AscendC vs TileLang 端到端对比）===')
    for t in args.t:
        for c in args.c:
            asc_r = [r for r in rows if r['T'] == t and r['C'] == c and r['impl'] == 'AscendC premix']
            tl_r = [r for r in rows if r['T'] == t and r['C'] == c and r['impl'] == 'TileLang e2e']
            tl_k = [r for r in rows if r['T'] == t and r['C'] == c and r['impl'] == 'TileLang big_fuse']
            parts = []
            if asc_r:
                parts.append(f'AscendC {asc_r[0]["mean_us"]:>9.2f} us')
            if tl_r:
                parts.append(f'TileLang(e2e) {tl_r[0]["mean_us"]:>9.2f} us')
            if tl_k:
                parts.append(f'TileLang(kernel) {tl_k[0]["mean_us"]:>9.2f} us')
            if asc_r and tl_r:
                parts.append(f'speedup x{asc_r[0]["mean_us"] / tl_r[0]["mean_us"]:.2f}')
            if parts:
                print(f'  T={t:<6} C={c:<6} ' + ' | '.join(parts))


if __name__ == '__main__':
    sys.exit(main())

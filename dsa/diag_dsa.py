#!/usr/bin/env python3
"""DSA sparse attention 上板测试脚本。

用法:
  # 1. 编译 kernel_runner (首次):
  cd OpenTileAS/tools/kernel_runner && pip install -e .

  # 2. 预生成输入 + golden:
  python diag_dsa.py prep

  # 3. 运行 kernel:
  python diag_dsa.py run

  # 或一步到位:
  python diag_dsa.py all
"""

import os
import sys
import subprocess
from pathlib import Path

import numpy as np
import math

# ── 参数 (与 DSA_demo_ub.py 一致) ────────────────────────────
BATCH      = 1
SEQ_LEN    = 4096
SEQ_LEN_KV = 4096
NUM_HEADS  = 64
DIM        = 256
TOP_K      = 128
NUM_CORES  = 32

WORK_DIR   = Path(__file__).parent
KERNEL_O   = WORK_DIR / "dsa_6.o"
CONFIG_JSON = WORK_DIR / "dsa_config.json"

# ── bf16 支持 (优先 ml_dtypes, 回退 float16) ──────────────────
try:
    import ml_dtypes
    BF16 = ml_dtypes.bfloat16
    BF16_NAME = "bfloat16"
except ImportError:
    BF16 = np.float16
    BF16_NAME = "float16"
    print("[warn] ml_dtypes not found, using float16 instead of bfloat16")


def gen_inputs():
    """生成输入 .npy 文件。"""
    rng = np.random.default_rng(42)

    # Q: [1, 4096, 64, 256] bf16
    # bf16 保存为 uint16 view (numpy .npy 不保留 ml_dtypes 元数据)
    Q = rng.random((BATCH, SEQ_LEN, NUM_HEADS, DIM), dtype=np.float32).astype(BF16)
    np.save(WORK_DIR / "Q.npy", Q.view(np.uint16))
    print(f"  Q: {Q.shape} {BF16_NAME} (saved as uint16 view)")

    # KV: [1, 4096, 256] bf16
    KV = rng.random((BATCH, SEQ_LEN_KV, DIM), dtype=np.float32).astype(BF16)
    np.save(WORK_DIR / "KV.npy", KV.view(np.uint16))
    print(f"  KV: {KV.shape} {BF16_NAME} (saved as uint16 view)")

    # AttnSink: [64] f32 (小负值, 模拟 attention sink)
    AttnSink = rng.normal(-2.0, 1.0, NUM_HEADS).astype(np.float32)
    np.save(WORK_DIR / "AttnSink.npy", AttnSink)
    print(f"  AttnSink: {AttnSink.shape} f32")

    # TopKIndices: [1, 4096, 128] i32, 范围 [0, SEQ_LEN_KV)
    TopKIndices = rng.integers(0, SEQ_LEN_KV, size=(BATCH, SEQ_LEN, TOP_K), dtype=np.int32)
    np.save(WORK_DIR / "TopKIndices.npy", TopKIndices)
    print(f"  TopKIndices: {TopKIndices.shape} i32")

    return Q, KV, AttnSink, TopKIndices


def compute_golden(Q, KV, AttnSink, TopKIndices):
    """计算 golden reference (与 kernel 的 online-softmax 语义等价)。

    kernel 初始化 m=AttnSink, l=1.0, 等价于:
      m_final = max(AttnSink, max(S))
      P = exp(S - m_final)
      l = sum(P) + exp(AttnSink - m_final)   # sink term
      O = (P @ V) / l
    """
    scale = 1.0 / math.sqrt(DIM)

    Q_f32  = Q.astype(np.float32)
    KV_f32 = KV.astype(np.float32)

    # 收集稀疏 K/V: [batch, seq, top_k, dim]
    # TopKIndices: [batch, seq, top_k]
    row_idx = np.arange(BATCH).reshape(BATCH, 1, 1)
    K_sparse = KV_f32[row_idx, TopKIndices]  # [B, S, K, D]
    V_sparse = K_sparse  # KV 共享

    # S = Q @ K^T * scale: [batch, seq, heads, top_k]
    S = np.einsum("bqhd,bqkd->bqhk", Q_f32, K_sparse) * scale

    # m = max(max(S), AttnSink): [batch, seq, heads]
    m = np.maximum(
        S.max(axis=-1),
        AttnSink.reshape(1, 1, NUM_HEADS),
    )

    # P = exp(S - m): [batch, seq, heads, top_k]
    P = np.exp(S - m[..., None])

    # sink term
    sink = np.exp(AttnSink.reshape(1, 1, NUM_HEADS) - m)  # [B, S, H]

    # l = sum(P) + sink
    l = P.sum(axis=-1) + sink  # [B, S, H]

    # O = P @ V / l: [batch, seq, heads, dim]
    O_golden = np.einsum("bqhk,bqkd->bqhd", P, V_sparse)
    O_golden = O_golden / l[..., None]

    return O_golden.astype(np.float32)


def save_golden():
    """生成 golden .npy。"""
    # 从 uint16 view 恢复 bf16
    Q = np.load(WORK_DIR / "Q.npy").view(BF16)
    KV = np.load(WORK_DIR / "KV.npy").view(BF16)
    AttnSink = np.load(WORK_DIR / "AttnSink.npy")
    TopKIndices = np.load(WORK_DIR / "TopKIndices.npy")

    O_golden = compute_golden(Q, KV, AttnSink, TopKIndices)
    np.save(WORK_DIR / "golden_O.npy", O_golden)
    print(f"  golden_O: {O_golden.shape} f32")
    print(f"  golden stats: mean={O_golden.mean():.6f}, std={O_golden.std():.6f}")
    print(f"  golden[:2,0,:2,:4] =\n{O_golden[:2, 0, :2, :4]}")


def write_config():
    """生成 dsa_config.json。"""
    import json
    config = {
        "kernel_o": "dsa_6.o",
        "kernel_name": "main_mix_aic",
        "device": 0,
        "mix_mode": "mix",
        "blocknum": NUM_CORES,
        "golden": {
            "module_path": "golden_dsa.py",
            "function": "dsa_golden",
            "atol": 0.5,
            "rtol": 0.05,
        },
        "args": [
            {"name": "Q",           "kind": "input",  "dtype": BF16_NAME,   "shape": [BATCH, SEQ_LEN, NUM_HEADS, DIM], "path": "Q.npy"},
            {"name": "KV",          "kind": "input",  "dtype": BF16_NAME,   "shape": [BATCH, SEQ_LEN_KV, DIM],         "path": "KV.npy"},
            {"name": "AttnSink",    "kind": "input",  "dtype": "float32",  "shape": [NUM_HEADS],                      "path": "AttnSink.npy"},
            {"name": "TopKIndices", "kind": "input",  "dtype": "int32",    "shape": [BATCH, SEQ_LEN, TOP_K],          "path": "TopKIndices.npy"},
            {"name": "O",           "kind": "output", "dtype": "float32",  "shape": [BATCH, SEQ_LEN, NUM_HEADS, DIM], "path": "O_output.npy"},
            {"name": "cid", "kind": "scalar", "dtype": "int32", "value": 0},
            {"name": "vid", "kind": "scalar", "dtype": "int32", "value": 0},
        ],
    }
    with open(CONFIG_JSON, "w") as f:
        json.dump(config, f, indent=2)
    print(f"  config: {CONFIG_JSON}")


def run_kernel():
    """调用 kernel_runner CLI 运行 .o。"""
    if not KERNEL_O.exists():
        print(f"[error] {KERNEL_O} not found")
        sys.exit(1)

    cmd = [
        sys.executable, "-m", "kernel_runner",
        str(CONFIG_JSON),
        "--kernel-o", str(KERNEL_O),
    ]
    print(f"[run] {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=False)
    return result.returncode


def compare_output():
    """手动比较 kernel 输出与 golden (如果 kernel_runner 没有自动比较)。"""
    out_path = WORK_DIR / "O_output.npy"
    golden_path = WORK_DIR / "golden_O.npy"

    if not out_path.exists():
        print("[skip] O_output.npy not found (kernel may not have run)")
        return

    actual = np.load(out_path)
    print(f"\n[output] shape={actual.shape} dtype={actual.dtype}")
    print(f"  first 8: {actual.ravel()[:8]}")
    print(f"  last 8:  {actual.ravel()[-8:]}")

    # sentinel check: 如果全是同一个值, 说明 kernel 没写入
    unique_count = len(np.unique(actual))
    if unique_count <= 1:
        print("[FAIL] OUTPUT NOT WRITTEN: all values identical")
        return

    nan_count = np.isnan(actual).sum()
    if nan_count > 0:
        print(f"[WARN] {nan_count} NaN values in output")

    if golden_path.exists():
        golden = np.load(golden_path)
        diff = np.abs(actual - golden)
        print(f"\n[compare] golden vs output")
        print(f"  max |diff| = {diff.max():.6f}")
        print(f"  mean |diff| = {diff.mean():.6f}")
        print(f"  golden[:2,0,:2,:4] =\n{golden[:2, 0, :2, :4]}")
        print(f"  actual[:2,0,:2,:4] =\n{actual[:2, 0, :2, :4]}")

        atol, rtol = 0.5, 0.05
        close = np.isclose(actual, golden, atol=atol, rtol=rtol)
        pass_ratio = close.mean()
        print(f"\n  pass ratio (atol={atol}, rtol={rtol}): {pass_ratio:.4%}")
        if pass_ratio > 0.95:
            print("[PASS] output matches golden (>95%)")
        else:
            print("[FAIL] output does not match golden (<95%)")
    else:
        print("[skip] golden_O.npy not found, run 'diag_dsa.py prep' first")


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "all"

    if mode in ("prep", "all"):
        print("=== 1. Generating inputs ===")
        gen_inputs()
        print("\n=== 2. Computing golden ===")
        save_golden()
        print("\n=== 3. Writing config ===")
        write_config()

    if mode in ("run", "all"):
        print("\n=== 4. Running kernel ===")
        rc = run_kernel()
        if rc != 0:
            print(f"[error] kernel_runner exited with {rc}")
            print("  make sure kernel_runner is installed: cd OpenTileAS/tools/kernel_runner && pip install -e .")

    if mode in ("compare", "all"):
        print("\n=== 5. Comparing output ===")
        compare_output()


if __name__ == "__main__":
    main()

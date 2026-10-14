#!/usr/bin/env python3
"""Compare a kernel output .npy against a golden .npy and print PASS/FAIL."""
import argparse

import numpy as np


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("actual")
    ap.add_argument("expected")
    ap.add_argument("--atol", type=float, default=1e-3)
    ap.add_argument("--rtol", type=float, default=1e-3)
    ap.add_argument("--eps", type=float, default=1e-12)
    args = ap.parse_args()

    a = np.load(args.actual)
    e = np.load(args.expected)
    if a.shape != e.shape:
        print(f"FAIL shape mismatch actual={a.shape} expected={e.shape}")
        return 1

    af = a.astype(np.float64).ravel()
    ef = e.astype(np.float64).ravel()
    if af.size == 0:
        print("FAIL empty output")
        return 1

    abs_err = np.abs(af - ef)
    rel_err = abs_err / np.maximum(np.abs(ef), args.eps)
    max_abs = float(abs_err.max())
    max_rel = float(rel_err.max())
    ok = bool(np.all(abs_err <= args.atol + args.rtol * np.abs(ef)))
    print(
        f"  max_abs_error={max_abs:.6g} max_rel_error={max_rel:.6g} "
        f"atol={args.atol} rtol={args.rtol}"
    )
    print("PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
#!/usr/bin/env python3
"""Fix l1ub stage3 mix mlir: sync_block_set flag=5 is emitted once in the
AIC prologue while the matching AIV sync_block_wait flag=5 executes every
loop iteration -> cross-core deadlock (rtStreamSynchronize 0x7bc87).

Move the set into the AIC scf.for body (before the first per-iteration
sync_block_set, i.e. right after the per-round buf_a->ub_tmp readback),
so SET/WAIT counts match (one per round).

Usage: fix_sync_flag5.py <stage3_mix_npu.mlir>...
"""
import re
import sys

SET5 = "npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 5"
FIRST_SET_IN_LOOP = "npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 6"
WAIT5 = "npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_S>] flag = 5"


def fix(path: str) -> bool:
    with open(path) as f:
        lines = f.readlines()

    # Only rewrite the AIC function; it is the first func.func and its name
    # carries the _mix_aic suffix.
    aic_end = None
    for i, ln in enumerate(lines):
        if "_mix_aic" in ln and "func.func" in ln:
            # function body spans until the closing "  }"
            for j in range(i + 1, len(lines)):
                if lines[j].rstrip() == "  }":
                    aic_end = j
                    break
            break
    if aic_end is None:
        print(f"[skip] {path}: AIC function not found")
        return False

    if WAIT5 not in "".join(lines):
        print(f"[skip] {path}: no AIV wait flag=5 (nothing to fix)")
        return False

    # locate the misplaced prologue set (loop-head, 4-space indent)
    set5_idx = None
    for i, ln in enumerate(lines[:aic_end]):
        if ln.strip() == SET5:
            set5_idx = i
            break
    if set5_idx is None:
        print(f"[skip] {path}: prologue set flag=5 not found (already fixed?)")
        return False

    # locate the first per-iteration set inside the loop (6-space indent)
    anchor_idx = None
    for i, ln in enumerate(lines):
        if ln.strip() == FIRST_SET_IN_LOOP and i < aic_end:
            anchor_idx = i
            break
    if anchor_idx is None or anchor_idx < set5_idx:
        print(f"[skip] {path}: loop-body set flag=6 anchor not found")
        return False

    indent = lines[anchor_idx][: len(lines[anchor_idx]) - len(lines[anchor_idx].lstrip())]
    moved = indent + SET5 + "\n"

    del lines[set5_idx]
    # anchor index unchanged: deletion happened strictly before it
    lines.insert(anchor_idx, moved)

    with open(path, "w") as f:
        f.writelines(lines)
    print(f"[fixed] {path}: set flag=5 moved from prologue (line {set5_idx + 1}) "
          f"into loop body before set flag=6")
    return True


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    ok = 0
    for p in sys.argv[1:]:
        ok += 1 if fix(p) else 0
    print(f"fixed {ok}/{len(sys.argv) - 1}")
    sys.exit(0 if ok == len(sys.argv) - 1 else 1)

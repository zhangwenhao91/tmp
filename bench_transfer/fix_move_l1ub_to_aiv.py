#!/usr/bin/env python3
"""Move L1->UB copies from AIC half to AIV half and rebuild sync protocol.

v2: copy1/copy5 SSA names are now taken from anchors (copy7/copy3 outs,
scatter1 ins) instead of hardcoded %view/%view_8/%view_7, which broke on
M=64 files where view numbering shifts.
"""
import glob
import re
import sys

RE_L1UB_COPY = re.compile(
    r"^(\s*)npu\.copy ins\(%\w+ : memref<[^>]+, #npu\.address_space<cbuf>>\) "
    r"outs\(%\w+ : memref<[^>]+, #npu\.address_space<ub>>\) "
    r"\{tcore_type = #npu\.tcore_type<CUBE>\}$")
RE_SET_FLAG = re.compile(
    r"^(\s*)npu\.sync_block_set\[<CUBE>, <(PIPE_\w+)>, <(PIPE_\w+)>\] flag = (\d+)$")
RE_WAIT_FLAG = re.compile(
    r"^(\s*)npu\.sync_block_wait\[<CUBE>, <(PIPE_\w+)>, <(PIPE_\w+)>\] flag = (\d+)$")
MEMREF_TYPE = r"memref<[^>]*#npu\.address_space<\w+>>"
RE_SCATTER = re.compile(
    r"^(\s*)npu\.nd2nz_scatter ins\((%\w+) : (" + MEMREF_TYPE + r")\) "
    r"outs\((%\w+) : (" + MEMREF_TYPE + r")\)")
RE_COPY = re.compile(
    r"^(\s*)npu\.copy ins\((%\w+) : (" + MEMREF_TYPE + r")\) "
    r"outs\((%\w+) : (" + MEMREF_TYPE + r")\) \{linear_transfer, "
    r"tcore_type = #npu\.tcore_type<VECTOR>\}$")
RE_FOR = re.compile(r"^(\s*)scf\.for ")
RE_ENDFOR = re.compile(r"^\s*\} \{tilelang\.loop_kind = \"serial\"\}$")


def find_func_bounds(lines, func_name):
    start = None
    for i, ln in enumerate(lines):
        if f"func.func @{func_name}" in ln:
            start = i
            break
    if start is None:
        raise RuntimeError(f"func {func_name} not found")
    end = len(lines)
    for i in range(start + 1, len(lines)):
        if lines[i].rstrip() == "  }":
            end = i
            break
    return start, end


def process_aic(func_lines):
    out = []
    in_loop = False
    l1ub_copies_removed = 0
    inserted_after_mad1 = False
    inserted_after_mad2 = False
    init_inserted = False

    for ln in func_lines:
        if RE_FOR.match(ln):
            in_loop = True
            out.append(ln)
            continue
        if RE_ENDFOR.match(ln):
            in_loop = False
            out.append(ln)
            continue

        if in_loop and RE_L1UB_COPY.match(ln):
            l1ub_copies_removed += 1
            continue

        if in_loop:
            m = RE_SET_FLAG.match(ln)
            if m and int(m.group(4)) in (5, 6, 7, 8, 3):
                continue
            m = RE_WAIT_FLAG.match(ln)
            if m and int(m.group(4)) in (0, 11):
                continue

        if not init_inserted and "npu.wait_flag[<PIPE_MTE2>, <PIPE_MTE1>, <EVENT_ID0>]" in ln:
            out.append(ln)
            out.append("    npu.sync_block_set[<CUBE>, <PIPE_MTE2>, <PIPE_S>] flag = 7\n")
            out.append("    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 6\n")
            out.append("    npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 3\n")
            init_inserted = True
            continue

        out.append(ln)

        if in_loop and not inserted_after_mad1 and \
           ln.strip() == "npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID0>]":
            out.append("      npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID0>]\n")
            out.append("      npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID0>]\n")
            out.append("      npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 6\n")
            inserted_after_mad1 = True
            continue

        if in_loop and not inserted_after_mad2 and \
           ln.strip() == "npu.set_flag[<PIPE_M>, <PIPE_MTE1>, <EVENT_ID1>]":
            out.append("      npu.set_flag[<PIPE_M>, <PIPE_FIX>, <EVENT_ID1>]\n")
            out.append("      npu.wait_flag[<PIPE_FIX>, <PIPE_M>, <EVENT_ID1>]\n")
            out.append("      npu.sync_block_set[<CUBE>, <PIPE_FIX>, <PIPE_S>] flag = 3\n")
            inserted_after_mad2 = True
            continue

    if l1ub_copies_removed != 2:
        raise RuntimeError(f"expected 2 L1->UB copies, removed {l1ub_copies_removed}")
    if not (init_inserted and inserted_after_mad1 and inserted_after_mad2):
        raise RuntimeError("AIC insertion anchors not all hit")
    return out


def process_aiv(func_lines):
    for_start = None
    for_end = None
    for i, ln in enumerate(func_lines):
        if RE_FOR.match(ln) and for_start is None:
            for_start = i
        if for_start is not None and RE_ENDFOR.match(ln):
            for_end = i
            break
    if for_start is None or for_end is None:
        raise RuntimeError("AIV loop not found")

    loop_lines = func_lines[for_start + 1:for_end]

    scatter1 = None
    scatter2 = None
    copy3 = None
    copy7 = None
    for ln in loop_lines:
        if scatter1 is None and RE_SCATTER.match(ln):
            scatter1 = ln
        elif scatter2 is None and RE_SCATTER.match(ln):
            scatter2 = ln
        m = RE_COPY.match(ln)
        if m:
            if copy3 is None and m.group(2) != m.group(4):
                copy3 = ln
            elif copy7 is None:
                copy7 = ln
    if not all((scatter1, scatter2, copy3, copy7)):
        raise RuntimeError("AIV anchor ops not found")

    c3 = RE_COPY.match(copy3)
    c7 = RE_COPY.match(copy7)
    s1 = RE_SCATTER.match(scatter1)
    # SSA names taken from anchors:
    #   buf_a = copy7 outs (final writeback target, cbuf)
    #   buf_b = copy3 outs (UB->L1 target, cbuf)
    #   ub_mid = scatter1 ins (L1->UB staging, ub)
    buf_a = c7.group(4)
    buf_b = c3.group(4)
    ub_mid = s1.group(2)
    view_type = c7.group(5)      # cbuf 64x256 type
    view_7_type = c3.group(5)    # cbuf (buf_b) type
    view_8_type = s1.group(3)    # ub staging type

    # v1 bug: hardcoded %view_8/%view_7 broke M=64 (view numbering shifts).
    # copy1 = (f"      npu.copy ins(%view : {view_type}) outs(%view_8 : {view_8_type}) "
    #         f"{{linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}}\n")
    # copy5 = (f"      npu.copy ins(%view_7 : {view_7_type}) outs(%view_8 : {view_8_type}) "
    #         f"{{linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}}\n")
    copy1 = (f"      npu.copy ins({buf_a} : {view_type}) outs({ub_mid} : {view_8_type}) "
             f"{{linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}}\n")
    copy5 = (f"      npu.copy ins({buf_b} : {view_7_type}) outs({ub_mid} : {view_8_type}) "
             f"{{linear_transfer, tcore_type = #npu.tcore_type<VECTOR>}}\n")

    new_loop = [
        "      npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 6\n",
        copy1,
        "      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]\n",
        "      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]\n",
        scatter1,
        "      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID0>]\n",
        "      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]\n",
        copy3,
        "      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]\n",
        "      npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 1\n",
        copy5,
        "      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]\n",
        "      npu.wait_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID1>]\n",
        scatter2,
        "      npu.set_flag[<PIPE_V>, <PIPE_MTE3>, <EVENT_ID1>]\n",
        "      npu.wait_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]\n",
        "      npu.sync_block_wait[<VECTOR>, <PIPE_FIX>, <PIPE_V>] flag = 3\n",
        copy7,
        "      npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]\n",
        "      npu.sync_block_set[<VECTOR>, <PIPE_MTE3>, <PIPE_MTE1>] flag = 2\n",
    ]

    pre = []
    for ln in func_lines[:for_start]:
        if ln.strip() in ("npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID0>]",
                          "npu.set_flag[<PIPE_MTE3>, <PIPE_V>, <EVENT_ID1>]"):
            continue
        pre.append(ln)
    pre.append("    npu.sync_block_wait[<VECTOR>, <PIPE_MTE2>, <PIPE_V>] flag = 7\n")

    return pre + [func_lines[for_start]] + new_loop + func_lines[for_end:]


def main():
    files = sorted(glob.glob("3_l1ub_*_mix_npu.mlir"))
    if len(sys.argv) > 1:
        files = sys.argv[1:]
    for f in files:
        with open(f) as fh:
            lines = fh.readlines()
        aic_s, aic_e = find_func_bounds(lines, "l1ub_kernel_mix_aic")
        aiv_s, aiv_e = find_func_bounds(lines, "l1ub_kernel_mix_aiv")

        new_aic = process_aic(lines[aic_s:aic_e + 1])
        new_aiv = process_aiv(lines[aiv_s:aiv_e + 1])

        new_lines = (lines[:aic_s] + new_aic +
                     lines[aic_e + 1:aiv_s] + new_aiv + lines[aiv_e + 1:])
        with open(f, "w") as fh:
            fh.writelines(new_lines)
        print(f"[OK] {f}")
    print("done")


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""诊断脚本：隔离 l1ub_single 注册报 0x7bc78（rtFunctionRegister 阶段）的候选根因。

两个候选变量：
  A. kname 符号不匹配（已确认并修复 bench_run.py：应注册 .o 中的 l1ub_kernel，
     原代码错拼成 l1ub_single_kernel）
  B. .text 段对齐（纯 cube .o 默认 Al=4；此前 AIC ELF magic 路径注册成功的 .o 均为 Al=256；
     已在 build_l1ub_single.sh 打 align 256 补丁）

四个测试项逐个走 rtFunctionRegister（kname 一律用正确的 l1ub_kernel）：
  1. sanity-aiv  : 现有 ub2ub .o（AIVEC magic，Al=256）——环境基线，error.txt 中一直能注册
  2. fix-align256: 修复后 Al=256 的 l1ub_single .o（ccec 9.2.0-beta.2 编译）
  3. align4-910  : Al=4 产物（ccec 9.1.0 编译），区分 ccec 版本差异
  4. align4-920  : Al=4 产物（ccec 9.2.0-beta.2 编译，即 4962977 报错原物）
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from bench_run import _load_rt  # 复用 kernel_runner 探测逻辑

TESTS = [
    # (label, path, kname, mode)
    ("sanity-aiv",   "new_env/n6_ub2ub_bfloat16_16x256_r16.o",       "ub2ub_kernel", "aiv"),
    ("fix-align256", "new_env/n6_l1ub_bfloat16_16x256_r16_single.o", "l1ub_kernel",  "aic"),
    ("align4-910",   "new_env/diag_l1ub_bf16_16x256_r16_align4_ccec910.o", "l1ub_kernel", "aic"),
    ("align4-920",   "new_env/diag_l1ub_bf16_16x256_r16_align4_ccec920.o", "l1ub_kernel", "aic"),
]


def main():
    rt = _load_rt()
    rt.init_runtime(None)
    rt.set_device(0)

    results = {}
    for label, rel, kname, mode in TESTS:
        path = os.path.join(HERE, rel)
        if not os.path.exists(path):
            print(f"[{label:14s}] SKIP (missing {rel})")
            results[label] = "SKIP"
            continue
        with open(path, "rb") as f:
            obytes = f.read()
        try:
            rt.load_kernel(kname, obytes, 0, mode)
            print(f"[{label:14s}] PASS")
            results[label] = "PASS"
        except Exception as e:
            print(f"[{label:14s}] FAIL: {e}")
            results[label] = "FAIL"

    print("=" * 60)
    if results.get("sanity-aiv") != "PASS":
        print("结论：sanity-aiv 未通过，NPU 运行时/环境异常，先排查环境（此前 ub2ub 一直能注册，不应出现）。")
        return 1

    fix, a910, a920 = results.get("fix-align256"), results.get("align4-910"), results.get("align4-920")
    if fix == "PASS" and a920 == "FAIL":
        print("结论：.text 对齐(Al=4)是 0x7bc78 根因，align256 修复有效。")
        print("  下一步直接跑完整 bench：")
        print("  python bench_run.py prep && python bench_run.py run && python bench_run.py verify")
        if a910 == "PASS":
            print("  （附：ccec 9.1.0 的 Al=4 也能注册 -> 仅 9.2.0 严格；不影响修复结论）")
        return 0
    if fix == "PASS":
        print("结论：align256 与 align4 均可注册 -> 对齐不是根因；")
        print("  原 0x7bc78 主因应为 kname 不匹配（bench_run.py 已修复），直接跑 bench 验证。")
        return 0
    print("结论：fix-align256 仍失败 -> 对齐不是唯一根因。")
    if a910 == "PASS":
        print("  但 align4-910（ccec 9.1.0）通过 -> 怀疑 9.2.0-beta.2 产物结构差异，")
        print("  下一步：用 9.1.0 ccec 重编全量 n6_l1ub_*_single.o 再试。")
    else:
        print("  align4-910 也失败 -> 需 readelf -SW dump 段结构，")
        print("  与 AIC 注册成功的 mix .o（Al=256）逐段对比。")
    return 1


if __name__ == "__main__":
    sys.exit(main())

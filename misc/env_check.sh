#!/usr/bin/env bash
# 验证环境自检：torch_npu + triton-opentile + KERNEL_PATH 补丁（可选端到端跑一个 .o）
#
# 用法:
#   bash misc/env_check.sh                     # 只做环境自检
#   bash misc/env_check.sh --e2e               # 自检通过后，额外跑一个现成 .o 做端到端
#   bash misc/env_check.sh --e2e --rak DIR     # 指定 reduce_api_kernels 目录（默认 ../reduce_api_kernels）
#
# 解释器：默认 python，可用 TILELANG_PYTHON 覆盖（与 run_on_npu.sh 一致）。
# 全绿退出码 0；任一项失败退出码非 0。
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY="${TILELANG_PYTHON:-python}"
E2E=0
RAK="${RAK:-$(cd "$HERE/.." && pwd)/reduce_api_kernels}"

usage() { sed -n '2,9p' "$0"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --e2e)   E2E=1; shift ;;
    --rak)   RAK="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "未知参数: $1" >&2; usage; exit 2 ;;
  esac
done

fail=0
chk() { echo; echo "===== $1 ====="; }

chk "1) 解释器"
command -v "$PY" >/dev/null 2>&1 || { echo "FAIL: 找不到解释器 '$PY'（可 export TILELANG_PYTHON=/path/to/python）"; exit 1; }
"$PY" -c "import sys; print('python:', sys.executable, sys.version.split()[0])" || fail=1

chk "2) torch / torch_npu"
"$PY" - <<'PY' || fail=1
try:
    import torch
except Exception as e:
    print("FAIL torch import:", type(e).__name__, e)
    raise SystemExit(1)
print("torch:", torch.__version__)
try:
    import torch_npu
    print("torch_npu:", torch_npu.__version__)
except Exception as e:
    print("FAIL torch_npu import:", type(e).__name__, e)
    raise SystemExit(1)
try:
    n = torch.npu.device_count()
    print("npu device_count:", n)
    assert n > 0, "no npu device"
    x = torch.ones(4, device="npu")
    got = (x + 1).sum().item()
    print("npu smoke:", got, "(expect 8.0)")
    assert got == 8.0, got
except Exception as e:
    print("FAIL npu smoke:", type(e).__name__, e)
    raise SystemExit(1)
PY

chk "3) triton / triton-opentile"
"$PY" - <<'PY' || fail=1
try:
    import triton
    print("triton:", triton.__version__)
    print("triton:", triton.__file__)
    from triton.backends.opentile.conf import OpenTileEnvConf
    from triton.backends.opentile.targets.ascend.compiler import OpenTileNPUOptions, make_npubin
    print("opentile: import OK")
except Exception as e:
    print("FAIL triton-opentile:", type(e).__name__, e)
    raise SystemExit(1)
PY

chk "4) KERNEL_PATH 补丁是否生效"
"$PY" - <<'PY' || fail=1
try:
    from triton.backends.opentile.conf import OpenTileEnvConf
    from triton.backends.opentile.targets.ascend.compiler import OpenTileNPUOptions, make_npubin
except Exception as e:
    print("FAIL import opentile:", type(e).__name__, e)
    raise SystemExit(1)
ok = all([
    callable(getattr(OpenTileEnvConf, "kernel_path", None)),
    callable(getattr(OpenTileEnvConf, "kernel_cv_mode", None)),
    "kernel_path" in getattr(OpenTileNPUOptions, "__dataclass_fields__", {}),
    "if opt.kernel_path" in open(make_npubin.__code__.co_filename).read(),
])
print("KERNEL_PATH patch:", "verified" if ok else "NOT applied")
if not ok:
    print("  -> 运行: python misc/patch_installed_kernel_path.py")
    raise SystemExit(1)
PY

if [ "$E2E" = 1 ]; then
  chk "5) 端到端：跑一个 .o"
  o="$RAK/reduce_sum/6_reduce_sum_shared_float16_32x128.o"
  if [ ! -f "$o" ]; then
    echo "SKIP: 找不到 $o（用 --rak 指定 reduce_api_kernels 目录）"
  elif [ ! -d "$RAK" ]; then
    echo "SKIP: 目录不存在 $RAK"
  else
    ( cd "$RAK" && KERNEL_PATH="$o" "$PY" verify_precision.py reduce_sum shared float16 32 128 ) || {
      echo "  (若报 'npu device not found'：verify_precision.py 缺 import torch_npu，可在其顶部补一行)"; fail=1; }
  fi
fi

echo
if [ "$fail" = 0 ]; then
  echo "ALL CHECKS PASSED"
else
  echo "SOME CHECKS FAILED (see above)"
fi
exit "$fail"
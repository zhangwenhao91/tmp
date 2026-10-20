#!/bin/bash
# TileOPs MHA decode ascend backend：服务器冒烟
# 用法：bash mha_stage_c/run_tileops_mha.sh > error.txt 2>&1
set -x
# 必须在任何 cd 之前取脚本绝对路径，后面基准段要靠它拷 bench_mha.py
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" || exit 1
export PYTHONUNBUFFERED=1
source /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh || exit 1

python3 -c "import sys; print('python', sys.version)" || exit 1
python3 -c "import torch; print('torch', torch.__version__)" || exit 1
python3 -c "import torch_npu; print('torch_npu OK')" || exit 1
python3 -c "import tilelang; print('tilelang', tilelang.__version__)" || exit 1
python3 -c "import pytest; print('pytest', pytest.__version__)" 2>/dev/null \
  || python3 -m pip install pytest || exit 1

# TileOPs 固定放在 /home/z30086261/TileOPs（editable install 指向此路径，勿再迁动）
TILEOPS_DIR=/home/z30086261/TileOPs
if [ ! -d "$TILEOPS_DIR" ]; then
  # 服务器走内网 HTTP 代理，SSH 协议不通，必须用 HTTPS 拉公开仓库
  GIT_TERMINAL_PROMPT=0 git clone -b ascend-mha-decode https://github.com/zhangwenhao91/TileOPs.git "$TILEOPS_DIR" || exit 1
fi
cd "$TILEOPS_DIR"
git fetch origin ascend-mha-decode || exit 1
git checkout ascend-mha-decode || exit 1
git reset --hard origin/ascend-mha-decode || exit 1
git log --oneline -1

# tileops 主张 tilelang==0.1.12 / torch>=2.13 / python>=3.12；服务器是
# python 3.11 + tilelang 0.1.15 + torch_npu 环境。代码未用 3.12 专属语法与
# stdlib API（已核查），仅元数据门挡路：放宽 requires-python；旧 setuptools
# 不认 PEP 639 的 SPDX license 字符串与 license-files，一并改成旧式写法。
sed -i 's/requires-python = .*/requires-python = ">=3.11"/' pyproject.toml
sed -i 's/^license = .*/license = {text = "MIT"}/' pyproject.toml
sed -i '/^license-files/d' pyproject.toml
python3 -m pip install -e . --no-deps --no-build-isolation || {
  echo "PIP_INSTALL_FAILED"
  exit 1
}

# 诊断：entry point 是否注册、探测器是否认领 npu 设备
echo "=== backend registry diagnostic ==="
python3 - <<'PYEOF' || echo "DIAG_FAILED"
import torch
print("torch", torch.__version__)
import torch_npu  # noqa: F401
print("torch_npu imported")
import tileops
from tileops.backend import registry
registry.ensure_loaded()
print("LOAD_FAILURES:", registry.LOAD_FAILURES)
print("DETECTORS:", registry.DETECTORS)
print("BUILDERS:", sorted(registry.BUILDERS))
print("default_target:", registry.default_target)
d = torch.device("npu", 0)
print("device.type:", d.type)
from tileops.backend import dispatch
print("detect_target(npu):", dispatch.detect_target(d))
print("select_target(None, npu):", dispatch.select_target(None, d))
print("MHA registered_targets:", dispatch.registered_targets("MHADecodePagedWithKVCacheFwdOp"))
print("MHA builder:", registry.BUILDERS.get(("MHADecodePagedWithKVCacheFwdOp", "ascend")))
PYEOF

# 关键：conftest 的 --tileops-target 默认 builtin（强制 in-tree 内核，backend 不接管）。
# 要让已安装的 ascend backend 认领 npu 设备，必须显式 --tileops-target detect。
# 冒烟 + full：bf16（dtype1）已支持，不再排除。
python3 -m pytest tests/ops/test_mha.py -m smoke \
  --tileops-device npu --tileops-target detect -v 2>&1 | tail -100
PYTEST_RC=${PIPESTATUS[0]}
echo "pytest_rc=$PYTEST_RC"

# 冒烟 2：cache-shorter-than-bound（NaN 投毒池，验证 builder sanitize 路径）
python3 -m pytest tests/ops/test_mha.py -k "cache_shorter or table_width" \
  --tileops-device npu --tileops-target detect -v 2>&1 | tail -60
SHORT_RC=${PIPESTATUS[0]}
echo "cache_shorter_rc=$SHORT_RC"

# 补跑 1：compile-boundary 测试里的 mha_decode_paged 用例（同文件其余 op 无 ascend
# builder，属预期失败，必须 -k 过滤；mla/nsa 等 workload 模块 import 期需要 einops）
python3 -m pip install einops >/dev/null 2>&1
python3 -m pytest tests/ops/test_compile_boundary.py -k "mha-decode-paged" \
  --tileops-device npu --tileops-target detect -v 2>&1 | tail -40
CB_RC=${PIPESTATUS[0]}
echo "compile_boundary_rc=$CB_RC"

# 归因对照（不门禁）：同用例在 cpu+builtin 下跑。dynamo 对元组字典键的限制在
# op 公共派发层（_signature_codegen.py），与 backend 无关；若 cpu+builtin 同样
# 失败，即为服务器 torch 2.7 dynamo 版本限制，而非 ascend 路径问题。
python3 -m pytest tests/ops/test_compile_boundary.py -k "mha-decode-paged" \
  --tileops-device cpu --tileops-target builtin -v 2>&1 | tail -25
CB_REF_RC=${PIPESTATUS[0]}
echo "compile_boundary_cpu_builtin_rc=$CB_REF_RC (归因对照，不门禁)"

# 补跑 2：manifest 官方基准组（7 个 workload）。官方 benchmarks 框架计时走 CUDA
# events/CUPTI、conftest 硬拒 npu（"benchmarks run on cuda only"），无法在 NPU
# 上运行；改用 manifest_workloads.py 原样实例化官方 workload（gen_inputs/ref/
# verification 全部来自 workloads 层），功能等价覆盖。
cp "$SCRIPT_DIR/manifest_workloads.py" . || exit 1
python3 manifest_workloads.py 2>&1 | tail -20
MW_RC=${PIPESTATUS[0]}
echo "manifest_rc=$MW_RC"

# 带宽探针：实测 d806 峰值，替换 bench 的 3200 GB/s 占位；取不到就回落 3200
cp "$SCRIPT_DIR/bench_bw.py" "$SCRIPT_DIR/bench_mha.py" . || exit 1
cd "$TILEOPS_DIR"
python3 bench_bw.py 2>&1 | tail -10
MEASURED_PEAK=$(python3 bench_bw.py 2>/dev/null | sed -n 's/PEAK_GBPS=\([0-9]*\).*/\1/p')
echo "measured_peak=${MEASURED_PEAK:-FALLBACK_3200}"

# 基线基准：固定形状中位耗时 + 有效带宽 MBU（脚本自注口径，单形状失败不拖垮整表）
BENCH_PEAK_BW_GBPS=${MEASURED_PEAK:-3200} python3 bench_mha.py 2>&1 | tail -40
BENCH_RC=${PIPESTATUS[0]}
echo "bench_rc=$BENCH_RC"

# T.Pipelined A/B 已定论（精度过、s4 变慢 10%，serial 保持默认），不再重跑。

echo "FINAL: pytest=$PYTEST_RC cache_shorter=$SHORT_RC compile_boundary=$CB_RC manifest=$MW_RC bench=$BENCH_RC"
[ "$PYTEST_RC" = "0" ] && [ "$SHORT_RC" = "0" ] && [ "$CB_RC" = "0" ] && [ "$MW_RC" = "0" ] && [ "$BENCH_RC" = "0" ]
exit $?

#!/bin/bash
# TileOPs MHA decode ascend backend：服务器冒烟
# 用法：bash mha_stage_c/run_tileops_mha.sh > error.txt 2>&1
set -x
export PYTHONUNBUFFERED=1
source /home/CANN/9.3.0.weekly.20260930/cann-9.3.0/set_env.sh || exit 1

python3 -c "import sys; print('python', sys.version)" || exit 1
python3 -c "import torch; print('torch', torch.__version__)" || exit 1
python3 -c "import torch_npu; print('torch_npu OK')" || exit 1
python3 -c "import tilelang; print('tilelang', tilelang.__version__)" || exit 1
python3 -c "import pytest; print('pytest', pytest.__version__)" 2>/dev/null \
  || python3 -m pip install pytest || exit 1

cd ~
if [ ! -d TileOPs ]; then
  # 服务器走内网 HTTP 代理，SSH 协议不通，必须用 HTTPS 拉公开仓库
  GIT_TERMINAL_PROMPT=0 git clone -b ascend-mha-decode https://github.com/zhangwenhao91/TileOPs.git || exit 1
fi
cd ~/TileOPs
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

# 冒烟 1：pytest 官方 smoke（bf16 支持在后续轮次，先排除）
python3 -m pytest tests/ops/test_mha.py -m smoke -k "not bfloat16" \
  --tileops-device npu -v 2>&1 | tail -100
PYTEST_RC=${PIPESTATUS[0]}
echo "pytest_rc=$PYTEST_RC"

# 冒烟 2：cache-shorter-than-bound（NaN 投毒池，验证 builder sanitize 路径）
python3 -m pytest tests/ops/test_mha.py -k "cache_shorter or table_width" \
  --tileops-device npu -v 2>&1 | tail -60
SHORT_RC=${PIPESTATUS[0]}
echo "cache_shorter_rc=$SHORT_RC"

echo "FINAL: pytest=$PYTEST_RC cache_shorter=$SHORT_RC"
[ "$PYTEST_RC" = "0" ] && [ "$SHORT_RC" = "0" ]
exit $?

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
  GIT_TERMINAL_PROMPT=0 git clone -b ascend-mha-decode git@github.com:zhangwenhao91/TileOPs.git || exit 1
fi
cd ~/TileOPs
git fetch origin ascend-mha-decode || exit 1
git checkout ascend-mha-decode || exit 1
git reset --hard origin/ascend-mha-decode || exit 1
git log --oneline -1

# tileops 主张 tilelang==0.1.12 / torch>=2.13；服务器是 0.1.15 + torch_npu 环境，
# 用 --no-deps 跳过依赖检查（依赖已就位）。
python3 -m pip install -e . --no-deps --no-build-isolation || {
  echo "PIP_INSTALL_FAILED（python 版本需 >=3.12,<3.13，见上方 python 版本）"
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

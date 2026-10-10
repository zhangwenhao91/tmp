#!/usr/bin/env bash
#
# NPUIR reduction API end-to-end verification bundle.
#
# What it runs (76 cases per file, 152 total)
#   test_reduce_api_exp.py  -> thread domain  (Expert mode,   buffers in UB)
#   test_reduce_api_dev.py  -> shared->shared (Developer mode, inside SimdVF)
#
# Coverage per file
#   T.reduce_sum / reduce_max / reduce_min / reduce_abssum / reduce_absmax
#   T.reduce(dims=..., reduce_mode=..., clear=True/False)
#   dtypes: float16, float32      dims: 1 (row), 0 (col)      shape: (16, 16)
#
# Prerequisites on the NPU machine
#   1. A python env that has the npuir-enabled tilelang installed, plus a
#      matching torch + torch_npu. tilelang must support target="npuir".
#   2. CANN sourced once so the Bisheng compiler is on PATH, e.g.
#        source /usr/local/Ascend/ascend-toolkit/set_env.sh
#
# Usage
#   ./run.sh              # run on NPU device 0
#   ./run.sh 3            # run on NPU device 3
#   XDIST=2 ./run.sh      # add -n 2, needs pytest-xdist (what CI uses)
#
# Just count the cases without running:
#   python -m pytest --collect-only -q
#
set -uo pipefail

cd "$(dirname "$0")"

DEVICE="${1:-0}"
XDIST_ARGS=()
if [ -n "${XDIST:-}" ]; then
    XDIST_ARGS=(-n "${XDIST}")
fi

echo "### Environment sanity check"
python -c "
import torch, torch_npu, tilelang
print('torch      ', torch.__version__)
print('tilelang   ', tilelang.__version__)
print('npu devices', torch.npu.device_count())
"

echo
echo "### [1/2] Expert: thread domain, buffers in UB"
echo "###   python -m pytest -v test_reduce_api_exp.py --op=reduce --mode=Expert --npu-device=${DEVICE}"
python -m pytest -v test_reduce_api_exp.py \
    --op=reduce --mode=Expert --npu-device="${DEVICE}" "${XDIST_ARGS[@]}"
RC_EXP=$?

echo
echo "### [2/2] Developer: SimdVF shared->shared"
echo "###   python -m pytest -v test_reduce_api_dev.py --op=reduce --mode=Developer --npu-device=${DEVICE}"
python -m pytest -v test_reduce_api_dev.py \
    --op=reduce --mode=Developer --npu-device="${DEVICE}" "${XDIST_ARGS[@]}"
RC_DEV=$?

echo
echo "### Summary"
echo "Expert    (thread domain)   exit=${RC_EXP}"
echo "Developer (SimdVF shared)   exit=${RC_DEV}"

if [ "${RC_EXP}" -ne 0 ] || [ "${RC_DEV}" -ne 0 ]; then
    exit 1
fi
exit 0
#!/usr/bin/env bash
# NPU 机器环境探测：确认能否跑 tilelang 主仓 examples/ascend/flash_attention 的 MHA
# 用法: bash 0_probe_env.sh
set -uo pipefail

echo "=== [1] NPU 设备 ==="
npu-smi info 2>&1 | head -25 || echo "WARN: npu-smi 不可用"

echo
echo "=== [2] CANN 版本 ==="
for f in /usr/local/Ascend/ascend-toolkit/latest/version.cfg \
         /usr/local/Ascend/ascend-toolkit/latest/*/ascend_toolkit_install.info; do
  [ -f "$f" ] && { echo "$f:"; cat "$f"; break; }
done
ls -d /usr/local/Ascend/ascend-toolkit/* 2>/dev/null
echo "注: README 性能数据来自 CANN/Bisheng 9.2.0；<9.2 大概率不支持 dav-3510 (Ascend950)"

echo
echo "=== [3] Python / torch / torch_npu ==="
for PY in python3 python; do
  command -v $PY >/dev/null 2>&1 || continue
  echo "-- $PY ($($PY -V 2>&1)):"
  $PY - <<'EOF' 2>&1 | sed 's/^/   /'
import importlib.util
for m in ("torch", "torch_npu", "pytest"):
    spec = importlib.util.find_spec(m)
    print(f"{m}: {'OK ' + getattr(__import__(m), '__version__', '') if spec else '缺失'}")
EOF
done

echo
echo "=== [4] 编译工具链 ==="
echo "gcc: $(gcc --version 2>/dev/null | head -1 || echo 缺失)"
echo "cmake: $(cmake --version 2>/dev/null | head -1 || echo 缺失)"
echo "git: $(git --version 2>/dev/null || echo 缺失)"

echo
echo "=== [5] CANN 环境脚本 ==="
ls /usr/local/Ascend/ascend-toolkit/set_env.sh 2>/dev/null \
  || ls /etc/profile.d/*cann* 2>/dev/null \
  || echo "WARN: 未找到 set_env.sh，运行脚本可能需要手动 source"
echo "ASCEND_HOME_PATH=${ASCEND_HOME_PATH:-<未设置>}"
echo "ASCEND_RT_VISIBLE_DEVICES=${ASCEND_RT_VISIBLE_DEVICES:-<未设置>}"

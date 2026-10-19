#!/bin/bash
# 探测服务器上已安装的 CANN 版本（9.3.0+ 查找）
echo '===== 1) 常见安装根目录 ====='
for d in /usr/local/Ascend /opt/Ascend /usr/local/Ascend/ascend-toolkit /root/Ascend /home/z30086261/Ascend; do
  if [ -d "$d" ]; then
    echo "[存在] $d:"
    ls -1 "$d" 2>/dev/null | head -20
  else
    echo "[不存在] $d"
  fi
done

echo
echo '===== 2) ascend-toolkit 下的所有版本目录 ====='
for base in /usr/local/Ascend/ascend-toolkit /opt/Ascend/ascend-toolkit /root/Ascend/ascend-toolkit /home/z30086261/Ascend/ascend-toolkit; do
  if [ -d "$base" ]; then
    echo "-- $base:"
    ls -1 "$base"
  fi
done

echo
echo '===== 3) latest 指向与版本信息 ====='
for base in /usr/local/Ascend/ascend-toolkit /opt/Ascend/ascend-toolkit; do
  if [ -L "$base/latest" ]; then
    echo "$base/latest -> $(readlink "$base/latest")"
  fi
  f="$base/latest/ascend_toolkit_install.info"
  [ -f "$f" ] && echo "latest 版本: $(cat "$f")"
done

echo
echo '===== 4) 搜索 ascend_toolkit_install.info（限 3 层深度） ====='
find /usr/local /opt /root /home -maxdepth 3 -name 'ascend_toolkit_install.info' 2>/dev/null | while read -r f; do
  echo "$f: $(cat "$f" 2>/dev/null | tr '\n' ' ')"
done

echo
echo '===== 5) 当前环境变量与生效版本 ====='
echo "ASCEND_HOME_PATH=$ASCEND_HOME_PATH"
echo "ASCEND_TOOLKIT_HOME=$ASCEND_TOOLKIT_HOME"
[ -f /usr/local/Ascend/ascend-toolkit/set_env.sh ] && echo 'set_env.sh 存在于 /usr/local/Ascend/ascend-toolkit/'

echo
echo '===== 6) 驱动与固件 ====='
npu-smi info 2>/dev/null | head -15
cat /usr/local/Ascend/driver/version.info 2>/dev/null && echo ' (driver version)'

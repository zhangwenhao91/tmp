#!/bin/bash
# 补充探测：确认各版本目录内容、latest 指向、9.3+ 安装包是否存在
echo '===== A) /usr/local/Ascend 各版本目录内容 ====='
for d in /usr/local/Ascend/8.2.RC1.alpha002 /usr/local/Ascend/8.3.RC1 /usr/local/Ascend/8.5.0 /usr/local/Ascend/latest /usr/local/Ascend/ascend-toolkit/latest; do
  if [ -L "$d" ]; then
    echo "[软链] $d -> $(readlink -f "$d")"
  elif [ -d "$d" ]; then
    echo "[目录] $d:"
    ls -1 "$d" 2>/dev/null | head -15
  else
    echo "[不存在] $d"
  fi
  echo
done

echo '===== B) 深层搜索 ascend_toolkit_install.info（深度 5） ====='
find /usr/local/Ascend -maxdepth 5 -name 'ascend_toolkit_install.info' 2>/dev/null | while read -r f; do
  echo "$f: $(cat "$f" 2>/dev/null | tr '\n' ' ')"
done

echo
echo '===== C) full 搜索 9.x / 9.3 相关目录 ====='
find /usr/local /opt /data /home -maxdepth 4 -iname '*9.3*' 2>/dev/null | head -20
find /usr/local /opt /data /home -maxdepth 4 -iname '*9.5*' 2>/dev/null | head -10

echo
echo '===== D) 常见位置搜索 CANN 安装包（.run/.tar.gz/.zip） ====='
find /root /home/z30086261 /data /opt /tmp /mnt -maxdepth 4 \( -name 'Ascend-cann*.run' -o -name 'Ascend-cann*.tar.gz' -o -name '*toolkit*.run' \) 2>/dev/null | head -30

echo
echo '===== E) 磁盘整体大文件安装包兜底搜索（/ 下深度 3，>500MB） ====='
find / -maxdepth 3 -type f -size +500M \( -name '*.run' -o -name '*.tar.gz' \) 2>/dev/null | head -20

echo
echo '===== F) NPU 型号确认 ====='
npu-smi info 2>/dev/null | sed -n '1,20p'

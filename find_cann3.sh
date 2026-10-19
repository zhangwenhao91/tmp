#!/bin/bash
# 第三轮探测：ascend-toolkit/latest 版本、/home/CANN 9.3 目录性质、NPU 型号
echo '===== G) ascend-toolkit/latest 的版本 ====='
f=/usr/local/Ascend/ascend-toolkit/latest/version.cfg
[ -f "$f" ] && cat "$f"
f=/usr/local/Ascend/latest/version.cfg
[ -f "$f" ] && echo '-- /usr/local/Ascend/latest/version.cfg:' && cat "$f"
ls -ld /usr/local/Ascend/ascend-toolkit/latest /usr/local/Ascend/latest
ls -1 /usr/local/Ascend/ascend-toolkit/latest/x86_64-linux/ 2>/dev/null | head
cat /usr/local/Ascend/ascend-toolkit/latest/compiler/ccec_compiler/bin/../version.info 2>/dev/null
find /usr/local/Ascend/ascend-toolkit/latest -maxdepth 2 -name 'version*' 2>/dev/null | head

echo
echo '===== H) /home/CANN 9.3 两个 weekly 目录的性质 ====='
for d in /home/CANN/9.3.0.weekly.20260916/cann-9.3.0 /home/CANN/9.3.0.weekly.20260930/cann-9.3.0; do
  echo "-- $d:"
  ls -1 "$d" 2>/dev/null | head -20
  echo "   [set_env.sh 存在?] $( [ -f "$d/set_env.sh" ] && echo YES || echo NO )"
  echo "   [lib64 存在?] $( [ -d "$d/lib64" ] && echo YES || echo NO )"
  echo "   [compiler 存在?] $( [ -d "$d/compiler" ] && echo YES || echo NO )"
  echo
done
ls -1 /home/CANN/ 2>/dev/null

echo
echo '===== I) /home/CANN 权限（能否直接 source / 需要拷贝） ====='
ls -ld /home/CANN /home/CANN/9.3.0.weekly.20260930 /home/CANN/9.3.0.weekly.20260930/cann-9.3.0 2>/dev/null

echo
echo '===== J) NPU 型号（多种方式兜底） ====='
which npu-smi
npu-smi info -m 2>&1 | head -10
lspci 2>/dev/null | grep -iE '华为|huawei|d100|d200|910|950|ascend' | head -5
cat /usr/local/Ascend/driver/version.info 2>/dev/null | head -3

echo
echo '===== K) 950-ops 安装包信息 ====='
ls -lh /home/g00946757/Ascend-cann-950-ops_9.3.0~weekly.20260930.01_linux-x86_64.run 2>/dev/null
head -30 /home/g00946757/Ascend-cann-950-ops_9.3.0~weekly.20260930.01_linux-x86_64.run 2>/dev/null | grep -iE 'version|help|usage' | head -5

#!/bin/bash
# 在新服务器上构建 OpenTileAS 降级工具链 (tile-opt/tile-translate/opentileas)
# 已知良好 commit: 99bf5fe（含 tilelang.vmax 支持，>=78f11fb）
# 用法: nohup bash build_otas.sh > build_otas.log 2>&1 &   然后 tail -f build_otas.log
set -u
export GIT_TERMINAL_PROMPT=0   # gitcode 不通时快速失败，而不是挂在凭据提示上
R=$HOME/OpenTileAS
LOGDIR=$R/build_logs

echo "=== [0/5] 环境检查 ==="
for t in git cmake gcc g++ python3; do
  command -v $t >/dev/null 2>&1 || { echo "FATAL: $t 不存在"; exit 1; }
done
echo "cmake: $(cmake --version | head -1)"
cmake --version | head -1 | awk -F'[ .]' '{maj=$3; min=$4; if (maj<3 || (maj==3 && min<20)) exit 1}' \
  || { echo "FATAL: cmake < 3.20"; exit 1; }
echo "gcc: $(gcc --version | head -1)"
NPROC=$(nproc)
MEM_GB=$(awk '/MemTotal/{print int($2/1048576)}' /proc/meminfo)
JOBS=${JOBS:-$NPROC}
CAP=$((MEM_GB / 2))
[ "$CAP" -lt 1 ] && CAP=1
[ "$JOBS" -gt "$CAP" ] && JOBS=$CAP
echo "nproc=$NPROC mem=${MEM_GB}GB -> JOBS=$JOBS"
free -g | head -2
df -h "$HOME" | tail -1
AVAIL_KB=$(df -k "$HOME" | tail -1 | awk '{print $4}')
[ "$AVAIL_KB" -lt 62914560 ] && { echo "FATAL: HOME 所在分区可用空间 < 60GB（LLVM 构建很占盘）"; exit 1; }
git ls-remote https://gitcode.com/OpenTileIR/OpenTileAS.git HEAD >/dev/null 2>&1 \
  || { echo "FATAL: 无法访问 gitcode.com（匿名被拒或网络不通），需配置 token 或改用 GitHub 镜像"; exit 1; }
echo "env OK"

echo "=== [1/5] clone + checkout 99bf5fe + 子模块 ==="
if [ ! -d "$R/.git" ]; then
  rm -rf "$R"   # 清残留，保证 clone 目标不存在
  git clone https://gitcode.com/OpenTileIR/OpenTileAS.git "$R" >"$HOME/otas_1_clone.log" 2>&1 \
    || { echo "FATAL: clone 失败"; tail -5 "$HOME/otas_1_clone.log"; exit 1; }
fi
mkdir -p "$LOGDIR"
cd "$R" || exit 1
git checkout 99bf5fe >"$LOGDIR/1_checkout.log" 2>&1 \
  || { echo "FATAL: checkout 99bf5fe 失败"; tail -5 "$LOGDIR/1_checkout.log"; exit 1; }
git submodule update --init --recursive third_party/llvm-project third_party/OpenTileIR third_party/triton \
  >"$LOGDIR/1_submodules.log" 2>&1 \
  || { echo "FATAL: 子模块拉取失败"; tail -10 "$LOGDIR/1_submodules.log"; exit 1; }
git submodule status | head -5
echo "submodules OK"

echo "=== [2/5] apply patches ==="
./build-tools/apply_patch.sh >"$LOGDIR/2_patch.log" 2>&1 \
  || { echo "FATAL: patch 失败（若重复运行，先 git submodule deinit -f . 再重跑 stage1/2）"; tail -10 "$LOGDIR/2_patch.log"; exit 1; }
echo "patch OK"

echo "=== [3/5] LLVM/MLIR + triton 构建（最耗时，可能数小时） ==="
cd "$R/third_party/llvm-project" || exit 1
mkdir -p build && cd build || exit 1
cmake -G "Unix Makefiles" ../llvm \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_EXTERNAL_PROJECTS=triton \
  -DLLVM_EXTERNAL_TRITON_SOURCE_DIR=../../triton \
  -DLLVM_BUILD_EXAMPLES=OFF \
  -DLLVM_TARGETS_TO_BUILD="Native" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  >"$LOGDIR/3a_cmake.log" 2>&1 \
  || { echo "FATAL: llvm cmake 失败"; tail -10 "$LOGDIR/3a_cmake.log"; exit 1; }
echo "llvm cmake OK, 开始 make（完整日志: $LOGDIR/3b_make.log；下方 [n/m] 为实时进度）"
set -o pipefail
make -j"$JOBS" 2>&1 \
  | tee "$LOGDIR/3b_make.log" \
  | stdbuf -oL grep -E '^\[[0-9]+/[0-9]+\]|\*\*\*|error:' \
  | stdbuf -oL cut -c1-70 \
  || { echo "FATAL: llvm make 失败"; tail -20 "$LOGDIR/3b_make.log"; exit 1; }
set +o pipefail
echo "llvm OK"

echo "=== [4/5] OpenTileAS 构建 ==="
cd "$R" || exit 1
mkdir -p build && cd build || exit 1
cmake .. >"$LOGDIR/4a_cmake.log" 2>&1 \
  || { echo "FATAL: otas cmake 失败"; tail -10 "$LOGDIR/4a_cmake.log"; exit 1; }
make -j"$JOBS" 2>&1 \
  | tee "$LOGDIR/4b_make.log" \
  | stdbuf -oL grep -E '^\[[0-9]+/[0-9]+\]|\*\*\*|error:' \
  | stdbuf -oL cut -c1-70 \
  || { echo "FATAL: otas make 失败"; tail -20 "$LOGDIR/4b_make.log"; exit 1; }
echo "otas OK"

echo "=== [5/5] 验证 ==="
ls -la "$R/build/bin" || exit 1
"$R/build/bin/tile-opt" --help >/dev/null 2>&1 && echo "TILE_OPT_OK" || echo "TILE_OPT_MISSING"
"$R/build/bin/tile-translate" --help >/dev/null 2>&1 && echo "TILE_TRANSLATE_OK" || echo "TILE_TRANSLATE_MISSING"
"$R/build/bin/opentileas" --help >/dev/null 2>&1 && echo "OPENTILEAS_OK" || echo "OPENTILEAS_MISSING"
strings "$R/build/bin/tile-opt" | grep -x tilelang.vmax >/dev/null && echo "VMAX_OK" || echo "VMAX_MISSING"
echo "=== BUILD_DONE ==="

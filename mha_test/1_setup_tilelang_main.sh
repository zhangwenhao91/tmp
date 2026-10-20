#!/usr/bin/env bash
# 构建 tilelang 主仓（含 ascend 后端）到独立 venv，并做 import 冒烟检查
# 用法: bash 1_setup_tilelang_main.sh
# 可选环境变量:
#   TL_REPO   仓库地址       (默认 https://github.com/tile-ai/tilelang；github 不可达时
#                             可换 gitcode 镜像)
#   TL_COMMIT 检出 commit    (默认空 = main HEAD；README 性能验证用的是 8121f415，
#                             main 编译失败时可 export TL_COMMIT=8121f415 重试)
#   TL_DIR    克隆目标目录   (默认 ~/tilelang-main)
#   VENV_DIR  venv 目录      (默认 ~/venv-tlmain)
#   PIP_INDEX pip 源         (默认华为云镜像)
set -uo pipefail

TL_REPO="${TL_REPO:-https://github.com/tile-ai/tilelang}"
TL_COMMIT="${TL_COMMIT:-}"
TL_DIR="${TL_DIR:-$HOME/tilelang-main}"
VENV_DIR="${VENV_DIR:-$HOME/venv-tlmain}"
PIP_INDEX="${PIP_INDEX:-https://repo.huaweicloud.com/repository/pypi/simple}"
PIP_EXTRA=()
[ -n "$PIP_INDEX" ] && PIP_EXTRA=(--index-url "$PIP_INDEX")

step() { echo; echo "== $* =="; }
die() { echo "FAIL: $*" >&2; exit 1; }

step "[1/5] 克隆/更新主仓"
if [ -d "$TL_DIR/.git" ]; then
  git -C "$TL_DIR" fetch --all origin || die "git fetch 失败"
  git -C "$TL_DIR" checkout main || die "git checkout main 失败"
  git -C "$TL_DIR" pull --ff-only origin main || die "git pull 失败"
else
  git clone --depth 1 "$TL_REPO" "$TL_DIR" || die "git clone 失败（网络？可换 TL_REPO 镜像）"
fi
if [ -n "$TL_COMMIT" ]; then
  git -C "$TL_DIR" fetch origin "$TL_COMMIT" || die "fetch $TL_COMMIT 失败（浅克隆需先 unshallow）"
  git -C "$TL_DIR" checkout "$TL_COMMIT" || die "checkout $TL_COMMIT 失败"
fi
echo "HEAD: $(git -C "$TL_DIR" log --oneline -1)"
[ -d "$TL_DIR/tilelang/ascend" ] || die "该 commit 无 tilelang/ascend 包，过旧"

step "[2/5] 找系统 python 并确认 torch/torch_npu 可复用"
PY=""
for c in python3.12 python3.11 python3.10 python3; do
  command -v "$c" >/dev/null 2>&1 || continue
  if "$c" -c "import torch, torch_npu" >/dev/null 2>&1; then PY="$c"; break; fi
done
[ -n "$PY" ] || die "找不到带 torch+torch_npu 的系统 python（先装 CANN 配套的 torch/torch_npu）"
echo "使用 $PY ($($PY -V 2>&1))"
"$PY" -c "import torch, torch_npu; print('torch', torch.__version__, '| torch_npu', torch_npu.__version__)"

step "[3/5] 建 venv (--system-site-packages 复用 torch_npu)"
"$PY" -m venv --system-site-packages "$VENV_DIR" || die "venv 创建失败"
source "$VENV_DIR/bin/activate" || die "venv 激活失败"
pip install "${PIP_EXTRA[@]}" -q --upgrade pip || echo "WARN: pip 升级失败，继续"

step "[4/5] 源码安装 tilelang (编译 C++，含 ascend 后端)"
# 注意：不要 --no-build-isolation 之外再装 torch（system-site 已有）；
# setuptools/wheel/ninja 为构建依赖
pip install "${PIP_EXTRA[@]}" -q setuptools wheel "ninja" || die "构建依赖安装失败"
pip install "${PIP_EXTRA[@]}" -e "$TL_DIR" -v 2>&1 | tail -20 || die "tilelang 源码安装失败"

step "[5/5] import 冒烟检查"
python -c "
import tilelang
import tilelang.ascend
import tilelang.ascend.language as T
from tilelang.ascend.language import simd as S
print('tilelang', tilelang.__version__, '| ascend 包 + simd intrinsic OK')
print('TL_ENABLE_FAST_MATH:', int(tilelang.PassConfigKey.TL_ENABLE_FAST_MATH))
" || die "import 冒烟失败"
echo
echo "OK: 主仓就绪 ($TL_DIR, venv: $VENV_DIR)"

#!/usr/bin/env bash
# 新环境特殊路径全量重编译：baseline / l12l1 / ub_scalar / l1_scalar
# 产物输出到 new_env/，前缀 n*。l12l1 预期在 s3/s4 被拒（无 L1->L1 lowering）。
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="/home/z30086261/tmp/bench_transfer"
NEWD="$SRC/new_env"
mkdir -p "$NEWD"
cd "$SRC"

PY="/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend/.venv/bin/python"
OPT="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-opt"
TRANS="/home/z30086261/tilelang-ascend-private/OpenTileAS/build/bin/tile-translate"
CCEC="/home/z30086261/Ascend/cann-9.2.0-beta.2/bin/ccec"
export PYTHONPATH=/home/z30086261/tilelang-ascend-private/tilelang-tileir-ascend

pipeline_from_1() { # $1=tag（输入 1_${tag}_tilelangir.mlir 应已存在）$2=mixflag(auto)
  local tag="$1"
  echo "===== [$tag] ====="
  "$OPT" "1_${tag}_tilelangir.mlir" --convert-tilelang-to-npu --npu-normalize \
    -o "$NEWD/n2_${tag}_npu.mlir" 2>/tmp/sp_s2.err || { echo "[FAIL-s2] $tag"; head -3 /tmp/sp_s2.err; return 1; }
  grep -qE '(^| )error' /tmp/sp_s2.err && { echo "[DIAG-ERR-s2] $tag"; head -3 /tmp/sp_s2.err; return 1; }

  "$OPT" "$NEWD/n2_${tag}_npu.mlir" --npu-expand-ub-to-l1-nd2nz --npu-split-scope --npu-plan-memory \
    --npu-split-mix-kernel --npu-sync-pipeline -o "$NEWD/n3_${tag}_mix_npu.mlir" 2>/tmp/sp_s3.err \
    || { echo "[FAIL-s3] $tag"; head -5 /tmp/sp_s3.err; return 1; }
  grep -qE '(^| )error' /tmp/sp_s3.err && { echo "[DIAG-ERR-s3] $tag"; head -5 /tmp/sp_s3.err; return 1; }

  "$OPT" --cce-pipeline="target=dav-351x" "$NEWD/n3_${tag}_mix_npu.mlir" -o "$NEWD/n4_${tag}_cce.mlir" 2>/tmp/sp_s4.err \
    || { echo "[FAIL-s4] $tag"; head -5 /tmp/sp_s4.err; return 1; }
  grep -qE '(^| )error' /tmp/sp_s4.err && { echo "[DIAG-ERR-s4] $tag"; head -5 /tmp/sp_s4.err; return 1; }

  "$TRANS" --cce-to-backend -allow-unregistered-dialect "$NEWD/n4_${tag}_cce.mlir" \
    -o "$NEWD/n5_${tag}.ll" 2>/tmp/sp_s5.err || { echo "[FAIL-s5] $tag"; head -3 /tmp/sp_s5.err; return 1; }

  local MIXFLAG=""
  grep -q "part_of_mix" "$NEWD/n3_${tag}_mix_npu.mlir" && MIXFLAG="-cce-enable-mix"
  "$CCEC" --cce-aicore-arch=dav-c310-cube --cce-aicore-only $MIXFLAG -O2 \
    -cce-bitcode-is-aicore -c "$NEWD/n5_${tag}.ll" -o "$NEWD/n6_${tag}.o" 2>/tmp/sp_s6.err \
    || { echo "[FAIL-s6] $tag"; head -3 /tmp/sp_s6.err; return 1; }
  echo "[OK] n6_${tag}.o ($(stat -c%s "$NEWD/n6_${tag}.o") bytes)${MIXFLAG:+ [mix]}"
}

# ---- 1. baseline：GM 载入 + gemm + 输出（差分法基准）----
"$PY" 0_bench_transfer.py baseline 64 256 16 1 bfloat16 >/dev/null 2>&1 \
  && mv 1_bench_tilelangir.mlir 1_baseline_tilelangir.mlir
pipeline_from_1 baseline

echo ""

# ---- 2. l12l1：预期被拒（无 L1->L1 lowering），保留证据 ----
"$PY" 0_bench_transfer.py l12l1 64 256 16 4 bfloat16 >/dev/null 2>&1 \
  && mv 1_bench_tilelangir.mlir 1_l12l1_tilelangir.mlir
pipeline_from_1 l12l1
echo "（l12l1 编译被拒符合预期：stage4 mov.ub.to.l1 类型检查无 L1->L1 直连支持）"

echo ""

# ---- 3/4. ub_scalar / l1_scalar：标量中转 ----
for variant in ub_scalar l1_scalar; do
  "$PY" scalar_transfer.py $variant 16 256 16 2 bfloat16 >/dev/null 2>&1 \
    && mv 1_scalar_tilelangir.mlir "1_${variant}_tilelangir.mlir"
  pipeline_from_1 "$variant"
  echo ""
done

#!/usr/bin/env bash
# OpenTile reduce end-to-end pilot driver.
#
#   *.opentile.mlir -> tile-opt --npu-pipeline -> tile-opt --cce-pipeline
#                   -> tile-translate --cce-to-backend -> ccec -> kernel.o
#                   -> kernel_runner (on NPU) -> precision compare vs golden
#
# Usage:
#   TOOLCHAIN=$HOME/OpenTileAS bash run_all.sh                 # all cases
#   TOOLCHAIN=$HOME/OpenTileAS bash run_all.sh triton_min_dim1 # a subset
#
# Environment:
#   TOOLCHAIN  OpenTileAS repo root                (default: $HOME/OpenTileAS)
#   BUILD_DIR  dir containing bin/tile-opt         (default: $TOOLCHAIN/build)
#   CCEC       path to ccec                        (default: found in PATH)
#   PYTHON     python with numpy/torch             (default: python3)
#
# Prereq: CANN environment sourced (ccec + ascend runtime available).
set -u

PKG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLCHAIN="${TOOLCHAIN:-$HOME/OpenTileAS}"
BUILD_DIR="${BUILD_DIR:-$TOOLCHAIN/build}"
PYTHON="${PYTHON:-python3}"
RUN_SH="$TOOLCHAIN/tools/kernel_runner/run.sh"
SRC_DIR="$TOOLCHAIN/test/Integration/FullPipeline"
WORK="$PKG_DIR/_work"
LOGS="$PKG_DIR/_logs"

[[ -f "$RUN_SH" ]] || { echo "error: run.sh not found: $RUN_SH (set TOOLCHAIN=...)" >&2; exit 2; }
[[ -d "$SRC_DIR" ]] || { echo "error: test dir not found: $SRC_DIR" >&2; exit 2; }
command -v "$PYTHON" >/dev/null 2>&1 || { echo "error: $PYTHON not found" >&2; exit 2; }

mkdir -p "$WORK" "$LOGS"

# stem:subdir:atol:rtol
ALL_CASES=(
  "triton_min_dim1:test_min_dim1:0:0"
  "triton_max_dim1:test_max_dim1:0:0"
  "triton_min_dim0:test_min_dim0:0:0"
  "triton_max_dim0:test_max_dim0:0:0"
  "triton_sum_dim1:test_sum_dim1:0.02:0.02"
  "triton_sum_dim0:test_sum_dim0:0.5:0.01"
  "triton_mean_dim1:test_mean_dim1:0.002:0.01"
  "triton_mean_dim0:test_mean_dim0:0.01:0.01"
)

declare -A SUB ATOL RTOL
for spec in "${ALL_CASES[@]}"; do
  IFS=: read -r stem sub a r <<< "$spec"
  SUB[$stem]="$sub"; ATOL[$stem]="$a"; RTOL[$stem]="$r"
done

if [[ $# -gt 0 ]]; then
  SELECTED=("$@")
else
  SELECTED=()
  for spec in "${ALL_CASES[@]}"; do IFS=: read -r stem _ _ _ <<< "$spec"; SELECTED+=("$stem"); done
fi

pass=0; fail=0; failed=()
for stem in "${SELECTED[@]}"; do
  sub="${SUB[$stem]:-}"
  if [[ -z "$sub" ]]; then echo "!! unknown case: $stem" >&2; continue; fi

  d="$WORK/$stem"
  rm -rf "$d"; mkdir -p "$d"
  cp "$SRC_DIR/$sub/$stem.opentile.mlir" "$d/"
  cp "$PKG_DIR/$stem.opentile.json" "$d/"
  cp "$PKG_DIR/golden_impl.py" "$d/"
  log="$LOGS/$stem.log"

  echo "=== [$stem] $sub/$stem.opentile.mlir"
  ( cd "$d" && bash "$RUN_SH" "$stem.opentile.mlir" \
      --config "$stem.opentile.json" --build-dir "$BUILD_DIR" ) > "$log" 2>&1
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "  => FAIL (pipeline rc=$rc), log: $log"
    grep -iE 'error|failed|Traceback|assert|not found' "$log" | tail -4 | sed 's/^/     /'
    fail=$((fail+1)); failed+=("$stem"); continue
  fi
  if [[ ! -f "$d/out.npy" || ! -f "$d/golden.npy" ]]; then
    echo "  => FAIL (missing out.npy / golden.npy), log: $log"
    tail -4 "$log" | sed 's/^/     /'
    fail=$((fail+1)); failed+=("$stem"); continue
  fi

  result="$("$PYTHON" "$PKG_DIR/check.py" "$d/out.npy" "$d/golden.npy" \
              --atol "${ATOL[$stem]}" --rtol "${RTOL[$stem]}" 2>&1)"
  crc=$?
  echo "$result" | sed 's/^/  /'
  if [[ $crc -eq 0 ]]; then
    echo "  => PASS"; pass=$((pass+1))
  else
    echo "  => FAIL (log: $log)"; fail=$((fail+1)); failed+=("$stem")
  fi
done

echo
echo "================ summary ================"
echo "PASS=$pass FAIL=$fail"
if [[ $fail -gt 0 ]]; then
  printf 'failed: %s\n' "${failed[*]}"
  exit 1
fi
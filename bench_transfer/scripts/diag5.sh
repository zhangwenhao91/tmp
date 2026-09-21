#!/usr/bin/env bash
ASC=/home/z30086261/Ascend/ascend-toolkit/cann-9.1.0/x86_64-linux/asc
echo "===== [1] find copy_cbuf_to_ubuf ====="
grep -rln "copy_cbuf_to_ubuf" $ASC --include="*.h" 2>/dev/null | head -5
echo "===== [2] show its definition ====="
for f in $(grep -rln "copy_cbuf_to_ubuf" $ASC --include="*.h" 2>/dev/null | head -2); do
  echo "--- $f ---"
  grep -n -B3 -A15 "copy_cbuf_to_ubuf" "$f" | head -70
done
echo "===== done ====="

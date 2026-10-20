#!/usr/bin/env bash
# 跑 examples/ascend/flash_attention 的 MHA：先 pytest 正确性，再 example 全量正确性+性能
# 用法: bash 2_run_mha_test.sh
# 可选环境变量:
#   TL_DIR   主仓目录 (默认 ~/tilelang-main，与 1_setup 一致)
#   VENV_DIR venv     (默认 ~/venv-tlmain)
#   DEVICE   NPU 设备号 (默认 4；注意项目规则：0/2/3/7 在部分机器上有故障)
#   SKIP_PERF=1 只跑正确性
# 注意: 同一 NPU 设备同一时间只能跑一个实例，勿并行
set -uo pipefail

TL_DIR="${TL_DIR:-$HOME/tilelang-main}"
VENV_DIR="${VENV_DIR:-$HOME/venv-tlmain}"
DEVICE="${DEVICE:-4}"

step() { echo; echo "== $* =="; }
die() { echo "FAIL: $*" >&2; exit 1; }

step "[0/4] 环境"
[ -d "$VENV_DIR" ] || die "venv 不存在: $VENV_DIR（先跑 1_setup_tilelang_main.sh）"
source "$VENV_DIR/bin/activate" || die "venv 激活失败"

# CANN 环境：登录 shell 一般由 /etc/profile.d 注入；非登录 shell 手动 source
if [ -z "${ASCEND_HOME_PATH:-}" ]; then
  for f in /usr/local/Ascend/ascend-toolkit/set_env.sh /etc/profile.d/99-cann.sh; do
    [ -f "$f" ] && { source "$f"; echo "sourced $f"; break; }
  done
fi
[ -n "${ASCEND_HOME_PATH:-}" ] || die "CANN 环境未注入（ASCEND_HOME_PATH 为空），手动 source set_env.sh 后重试"

export ASCEND_RT_VISIBLE_DEVICES="$DEVICE"
export ASCEND_NPU_ARCH=dav-3510        # README 验证配置（Ascend950）
export TILELANG_DISABLE_CACHE=1
export PYTHONUNBUFFERED=1              # 输出重定向到文件时保证实时落盘
python -c "import torch_npu; print('torch_npu OK, 设备:', torch_npu.npu.device_count())" \
  || die "torch_npu 初始化失败"

EX="$TL_DIR/examples/ascend/flash_attention"
[ -f "$EX/example_mha.py" ] || die "找不到 $EX/example_mha.py"
cd "$EX" || die "cd 失败"

step "[1/4] 编译冒烟（只编译不跑，最快暴露链路问题）"
python - <<'EOF' || die "编译失败"
import tilelang
from core import flash_attention_fwd
program = flash_attention_fwd(q_len=4096, kv_len=4096, head_dim=128, out_dtype="float32")
kernel = tilelang.compile(program, out_idx=-1,
                          pass_configs={tilelang.PassConfigKey.TL_ENABLE_FAST_MATH: True})
print("compile OK:", type(kernel).__name__)
EOF

step "[2/4] pytest 正确性 (SEQ_LEN=4096, D=128)"
python -m pytest test_mha.py -v 2>&1 | tail -15 || die "test_mha 失败"

step "[3/4] 精度细节（rel 阈值 0.05，README 报告 <0.5%）"
python - <<'EOF' || die "精度校验失败"
import torch
import tilelang
from example_mha import mha, ref_program
kernel = tilelang.compile(mha(128, 4096), out_idx=-1,
                          pass_configs={tilelang.PassConfigKey.TL_ENABLE_FAST_MATH: True})
torch.manual_seed(42)
Q = torch.randn(4096, 128, dtype=torch.bfloat16, device="npu")
K = torch.randn(4096, 128, dtype=torch.bfloat16, device="npu")
V = torch.randn(4096, 128, dtype=torch.bfloat16, device="npu")
O = kernel(Q, K, V); torch.npu.synchronize()
expected = ref_program(Q, K, V)
diff = (O.cpu().float() - expected.cpu()).abs().max().item()
rel = diff / expected.cpu().abs().max().item()
print(f"max_abs_diff={diff:.6f}  rel={rel:.6f}  {'PASS' if rel < 0.05 else 'FAIL'}")
assert rel < 0.05
EOF

if [ "${SKIP_PERF:-0}" != 1 ]; then
  step "[4/4] 性能（example_mha.py 主程序：TFLOPS + 对比 Torch SDPA）"
  python example_mha.py 2>&1 | grep -vE "^\s*$" | tail -20 || die "性能测试失败"
fi

echo
echo "OK: MHA 测试完成（设备 $DEVICE，日志如需留档建议 tee 到文件重跑）"

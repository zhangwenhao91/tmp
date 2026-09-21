"""
验证 reduce 操作精度
TileLang 编译 → .o 文件 → Triton compiler.py 加载 → NPU 执行 → 对比 PyTorch CPU

在服务器上运行（需先 export KERNEL_PATH=...）:
    python verify_reduce_precision.py
"""

import torch
import triton
import triton.language as tl


# ==================== Triton Kernels ====================
# 这些 kernel 经过 compiler.py 时会被替换为 TileLang 编译的 .o

@triton.jit
def reduce_sum_kernel(input_ptr, output_ptr, num_elements, BLOCK_SIZE: tl.constexpr):
    pid = tl.program_id(axis=0)
    offsets = pid * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < num_elements
    data = tl.load(input_ptr + offsets, mask=mask, other=0.0)
    total = tl.sum(data, axis=0)
    tl.store(output_ptr + pid, total)


@triton.jit
def reduce_max_kernel(input_ptr, output_ptr, num_elements, BLOCK_SIZE: tl.constexpr):
    pid = tl.program_id(axis=0)
    offsets = pid * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < num_elements
    data = tl.load(input_ptr + offsets, mask=mask, other=-float("inf"))
    result = tl.max(data, axis=0)
    tl.store(output_ptr + pid, result)


@triton.jit
def reduce_min_kernel(input_ptr, output_ptr, num_elements, BLOCK_SIZE: tl.constexpr):
    pid = tl.program_id(axis=0)
    offsets = pid * BLOCK_SIZE + tl.arange(0, BLOCK_SIZE)
    mask = offsets < num_elements
    data = tl.load(input_ptr + offsets, mask=mask, other=float("inf"))
    result = tl.min(data, axis=0)
    tl.store(output_ptr + pid, result)


# ==================== Run Functions ====================

def run_reduce(a, op):
    """在 NPU 上执行 reduce（通过 compiler.py 加载 .o）"""
    a = a.contiguous().flatten()
    num_elements = a.numel()
    BLOCK_SIZE = triton.next_power_of_2(num_elements)
    output = torch.empty(1, device=a.device, dtype=a.dtype)

    if op == "sum":
        reduce_sum_kernel[(1,)](a, output, num_elements, BLOCK_SIZE=BLOCK_SIZE)
    elif op == "max":
        reduce_max_kernel[(1,)](a, output, num_elements, BLOCK_SIZE=BLOCK_SIZE)
    elif op == "min":
        reduce_min_kernel[(1,)](a, output, num_elements, BLOCK_SIZE=BLOCK_SIZE)
    elif op == "abssum":
        reduce_sum_kernel[(1,)](a.abs(), output, num_elements, BLOCK_SIZE=BLOCK_SIZE)
    elif op == "absmax":
        reduce_max_kernel[(1,)](a.abs(), output, num_elements, BLOCK_SIZE=BLOCK_SIZE)

    return output[0]


# ==================== PyTorch CPU 参考 ====================

def ref_reduce(a, op):
    a_flat = a.flatten()
    if op == "sum":
        return a_flat.sum().to(a.dtype)
    elif op == "max":
        return a_flat.max().values
    elif op == "min":
        return a_flat.min().values
    elif op == "abssum":
        return a_flat.abs().sum().to(a.dtype)
    elif op == "absmax":
        return a_flat.abs().max().values


# ==================== 测试场景 ====================

TEST_CASES = [
    # ---- float32 ----
    ("sum",    torch.float32, 128, 64),
    ("max",    torch.float32, 128, 64),
    ("min",    torch.float32, 128, 64),
    ("abssum", torch.float32, 128, 64),
    ("absmax", torch.float32, 128, 64),
    # ---- float16 ----
    ("sum",    torch.float16, 128, 64),
    ("max",    torch.float16, 128, 64),
    ("min",    torch.float16, 128, 64),
    ("abssum", torch.float16, 128, 64),
    ("absmax", torch.float16, 128, 64),
    # ---- bfloat16 ----
    ("sum",    torch.bfloat16, 128, 64),
    ("max",    torch.bfloat16, 128, 64),
    ("min",    torch.bfloat16, 128, 64),
    ("abssum", torch.bfloat16, 128, 64),
    ("absmax", torch.bfloat16, 128, 64),
    # ---- 大矩阵（N大，累加误差累积）----
    ("sum",    torch.float32, 128, 4096),
    ("max",    torch.float32, 128, 4096),
    ("min",    torch.float32, 128, 4096),
    ("abssum", torch.float32, 128, 4096),
    ("absmax", torch.float32, 128, 4096),
    # ---- 小矩阵 ----
    ("sum",    torch.float32, 8, 8),
    ("max",    torch.float32, 8, 8),
    ("min",    torch.float32, 8, 8),
    ("abssum", torch.float32, 8, 8),
    ("absmax", torch.float32, 8, 8),
]


# ==================== Main ====================

def main():
    print("=" * 60)
    print("Reduce 精度验证")
    print("链路: TileLang → .o → compiler.py → NPU → 对比 PyTorch CPU")
    print("=" * 60)

    passed = 0
    failed = 0
    errors = []

    for op, dtype, M, N in TEST_CASES:
        # CPU 生成输入
        a_cpu = torch.randn(M, N, dtype=dtype)

        # PyTorch CPU 参考
        ref = ref_reduce(a_cpu, op)

        # NPU 执行（经过 compiler.py 加载 .o）
        a_npu = a_cpu.to("npu")
        result = run_reduce(a_npu, op).cpu()

        # 容差
        tol = 1e-1 if dtype in (torch.float16, torch.bfloat16) else 1e-2

        # 对比
        match = torch.allclose(result, ref, atol=tol, rtol=tol)
        diff = (result - ref).abs().max().item()

        if match:
            passed += 1
            print(f"  [PASS] {op:7s} {str(dtype):15s} {M}x{N}  diff={diff:.6f}")
        else:
            failed += 1
            errors.append((op, dtype, M, N, diff, ref.item(), result.item()))
            print(f"  [FAIL] {op:7s} {str(dtype):15s} {M}x{N}  diff={diff:.6f}  ref={ref.item():.6f}  got={result.item():.6f}")

    # 汇总
    print("\n" + "=" * 60)
    print(f"结果: {passed} PASS / {failed} FAIL / {passed+failed} TOTAL")

    if errors:
        print("\n失败详情:")
        for op, dtype, M, N, diff, ref_val, got_val in errors:
            print(f"  {op} {dtype} {M}x{N}: diff={diff:.6f}, expected={ref_val:.6f}, got={got_val:.6f}")
    else:
        print("\n全部通过!")


if __name__ == "__main__":
    main()

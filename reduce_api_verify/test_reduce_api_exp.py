# Copyright (c) Huawei Technologies Co., Ltd. 2025.
"""End-to-end verification for every ``T.reduce_*`` / ``T.reduce`` entry point.

Form under test: thread domain (Expert mode, buffers in UB).
Both the reduction source and destination are UB (vector) buffers, so the
reduction is executed inside the thread/vector domain.
"""

import pytest
import torch
import torch_npu  # noqa: F401

import tilelang
import tilelang.language as T

from testcommon import assert_close, gen_tensor

pytestmark = [
    pytest.mark.op("reduce"),
    pytest.mark.mode("Expert"),
]

BLOCK_SIZE = 1
M, N = 16, 16

DTYPE_CASES = ["float16", "float32"]
DIM_CASES = [1, 0]
REDUCE_OPS = ["sum", "max", "min", "abssum", "absmax"]
ACCUM_OPS = ["sum", "max", "min", "absmax"]

TOLERANCE = {
    "float16": (1e-2, 1e-2),
    "float32": (1e-3, 1e-3),
}


def _out_shape(dim):
    return (M, 1) if dim == 1 else (1, N)


def _reduce_ref(a, op, dim):
    """Reference reduce on a CPU tensor, accumulated in fp32."""
    x = a.float()
    if op == "sum":
        out = torch.sum(x, dim=dim, keepdim=True)
    elif op == "abssum":
        out = torch.sum(torch.abs(x), dim=dim, keepdim=True)
    elif op == "max":
        out = torch.max(x, dim=dim, keepdim=True).values
    elif op == "min":
        out = torch.min(x, dim=dim, keepdim=True).values
    elif op == "absmax":
        out = torch.max(torch.abs(x), dim=dim, keepdim=True).values
    else:
        raise ValueError(f"Unsupported op: {op}")
    return out.to(a.dtype)


def _accum_ref(init, a, op, dim):
    """Reference for clear=False: dst = init <op> reduce(src)."""
    reduced = _reduce_ref(a, op, dim).float()
    base = init.float()
    if op in ("sum", "abssum"):
        out = base + reduced
    elif op in ("max", "absmax"):
        out = torch.maximum(base, reduced)
    elif op == "min":
        out = torch.minimum(base, reduced)
    else:
        raise ValueError(f"Unsupported op: {op}")
    return out.to(init.dtype)


def _reduce_kernel(dim, op, dtype, *, clear, via_generic):
    out_shape = _out_shape(dim)

    if clear:

        @T.prim_func
        def reduceThreadClear(
            A: T.Tensor((M, N), dtype),
            O: T.Tensor(out_shape, dtype),
        ):
            with T.Kernel(BLOCK_SIZE, is_npu=True) as (cid, _):
                a = T.alloc_ub((M, N), dtype)
                o = T.alloc_ub(out_shape, dtype)
                T.copy(A, a)
                if via_generic:
                    T.reduce(a, o, dims=dim, reduce_mode=op, clear=True)
                elif op == "sum":
                    T.reduce_sum(a, o, dim=dim, clear=True)
                elif op == "max":
                    T.reduce_max(a, o, dim=dim, clear=True)
                elif op == "min":
                    T.reduce_min(a, o, dim=dim, clear=True)
                elif op == "abssum":
                    T.reduce_abssum(a, o, dim=dim)
                elif op == "absmax":
                    T.reduce_absmax(a, o, dim=dim, clear=True)
                else:
                    T.assert_(False, "Unsupported op")
                T.copy(o, O)

        return reduceThreadClear

    @T.prim_func
    def reduceThreadAccum(
        A: T.Tensor((M, N), dtype),
        Init: T.Tensor(out_shape, dtype),
        O: T.Tensor(out_shape, dtype),
    ):
        with T.Kernel(BLOCK_SIZE, is_npu=True) as (cid, _):
            a = T.alloc_ub((M, N), dtype)
            o = T.alloc_ub(out_shape, dtype)
            T.copy(A, a)
            T.copy(Init, o)
            if via_generic:
                T.reduce(a, o, dims=dim, reduce_mode=op, clear=False)
            elif op == "sum":
                T.reduce_sum(a, o, dim=dim, clear=False)
            elif op == "max":
                T.reduce_max(a, o, dim=dim, clear=False)
            elif op == "min":
                T.reduce_min(a, o, dim=dim, clear=False)
            elif op == "absmax":
                T.reduce_absmax(a, o, dim=dim, clear=False)
            else:
                T.assert_(False, "Unsupported op")
            T.copy(o, O)

    return reduceThreadAccum


@pytest.mark.parametrize("dtype", DTYPE_CASES)
@pytest.mark.parametrize("dim", DIM_CASES)
@pytest.mark.parametrize("op", REDUCE_OPS)
def test_reduce_exp_clear_true(op, dim, dtype):
    """All ``T.reduce_*`` wrappers with clear=True."""
    A = gen_tensor((M, N), dtype, kind="randn")
    O = gen_tensor(_out_shape(dim), dtype, kind="zeros")
    ref = _reduce_ref(A.cpu(), op, dim)

    func = _reduce_kernel(dim, op, dtype, clear=True, via_generic=False)
    kernel = tilelang.compile(func, target="npuir")
    kernel(A, O)

    rtol, atol = TOLERANCE[dtype]
    assert_close(O.cpu(), ref, dtype=dtype, rtol=rtol, atol=atol)


@pytest.mark.parametrize("dtype", DTYPE_CASES)
@pytest.mark.parametrize("dim", DIM_CASES)
@pytest.mark.parametrize("op", ACCUM_OPS)
def test_reduce_exp_clear_false(op, dim, dtype):
    """clear=False accumulates onto the existing destination value."""
    A = gen_tensor((M, N), dtype, kind="randn")
    Init = gen_tensor(_out_shape(dim), dtype, kind="randn")
    O = gen_tensor(_out_shape(dim), dtype, kind="zeros")
    ref = _accum_ref(Init.cpu(), A.cpu(), op, dim)

    func = _reduce_kernel(dim, op, dtype, clear=False, via_generic=False)
    kernel = tilelang.compile(func, target="npuir")
    kernel(A, Init, O)

    rtol, atol = TOLERANCE[dtype]
    assert_close(O.cpu(), ref, dtype=dtype, rtol=rtol, atol=atol)


@pytest.mark.parametrize("dtype", DTYPE_CASES)
@pytest.mark.parametrize("dim", DIM_CASES)
@pytest.mark.parametrize("op", REDUCE_OPS)
def test_reduce_exp_generic_clear_true(op, dim, dtype):
    """T.reduce(dims=..., reduce_mode=..., clear=True) for every documented mode."""
    A = gen_tensor((M, N), dtype, kind="randn")
    O = gen_tensor(_out_shape(dim), dtype, kind="zeros")
    ref = _reduce_ref(A.cpu(), op, dim)

    func = _reduce_kernel(dim, op, dtype, clear=True, via_generic=True)
    kernel = tilelang.compile(func, target="npuir")
    kernel(A, O)

    rtol, atol = TOLERANCE[dtype]
    assert_close(O.cpu(), ref, dtype=dtype, rtol=rtol, atol=atol)


@pytest.mark.parametrize("dtype", DTYPE_CASES)
@pytest.mark.parametrize("dim", DIM_CASES)
@pytest.mark.parametrize("op", REDUCE_OPS)
def test_reduce_exp_generic_clear_false(op, dim, dtype):
    """T.reduce(dims=..., reduce_mode=..., clear=False) also covers abssum/absmax."""
    A = gen_tensor((M, N), dtype, kind="randn")
    Init = gen_tensor(_out_shape(dim), dtype, kind="randn")
    O = gen_tensor(_out_shape(dim), dtype, kind="zeros")
    ref = _accum_ref(Init.cpu(), A.cpu(), op, dim)

    func = _reduce_kernel(dim, op, dtype, clear=False, via_generic=True)
    kernel = tilelang.compile(func, target="npuir")
    kernel(A, Init, O)

    rtol, atol = TOLERANCE[dtype]
    assert_close(O.cpu(), ref, dtype=dtype, rtol=rtol, atol=atol)
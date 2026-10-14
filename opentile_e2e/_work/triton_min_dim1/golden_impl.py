"""Golden implementations for the OpenTile reduce end-to-end pilot cases.

Each function receives the *flat* input buffer exactly as the kernel sees it
(the buffer is over-allocated to the tile size to avoid out-of-bounds reads;
only the first M*N elements carry the packed logical row-major (M, N) matrix).

Semantics were reconstructed from the *.opentile.mlir in
test/Integration/FullPipeline/.  Reductions are performed in float32 and cast
back, mirroring the ftof -> reduce -> ftof pattern of the lowered IR.
"""

import torch


def _mat(flat, m, n):
    """Logical (m, n) matrix packed in the first m*n elements of the buffer."""
    return flat[: m * n].reshape(m, n)


def min_dim1(x):
    # tile (64,32) stride 16 -> logical (64,16); reduce dim=1, min
    return _mat(x, 64, 16).float().min(dim=1).values.to(torch.float16)


def max_dim1(x):
    # tile (64,32) stride 32 -> logical (64,32); i8 -> i32 max -> i8
    return _mat(x, 64, 32).to(torch.int32).max(dim=1).values.to(torch.int8)


def min_dim0(x):
    # tile (64,32) stride 32 -> logical (64,32); i8 -> i32 min -> i8
    return _mat(x, 64, 32).to(torch.int32).min(dim=0).values.to(torch.int8)


def max_dim0(x):
    # tile (64,32) stride 8 -> logical (64,8); reduce dim=0, max
    return _mat(x, 64, 8).max(dim=0).values


def sum_dim1(x):
    # tile (64,16) stride 3 -> logical (57,3); reduce dim=1, sum
    return _mat(x, 57, 3).float().sum(dim=1).to(torch.float16)


def sum_dim0(x):
    # tile (512,8) stride 1 -> logical (263,1); reduce dim=0, sum
    return _mat(x, 263, 1).float().sum(dim=0).to(torch.float16)


def mean_dim1(x):
    # tile (512,8) stride 1 -> logical (263,1); N == 1 so the /N is folded away
    return _mat(x, 263, 1).float().mean(dim=1).to(torch.float16)


def mean_dim0(x):
    # tile (256,8) stride 3 -> logical (128,3); sum / 128
    return _mat(x, 128, 3).float().mean(dim=0).to(torch.float16)
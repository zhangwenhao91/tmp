import torch

def _mat(flat, m, n):
    return flat[: m * n].reshape(m, n)

# ---- 既有 6 个用例 ----
def min_dim1(x):  return _mat(x, 64, 16).float().min(dim=1).values.to(torch.float16)
def max_dim0(x):  return _mat(x, 64, 8).max(dim=0).values
def sum_dim1(x):  return _mat(x, 57, 3).float().sum(dim=1).to(torch.float16)
def sum_dim0(x):  return _mat(x, 263, 1).float().sum(dim=0).to(torch.float16)
def mean_dim1(x): return _mat(x, 263, 1).float().mean(dim=1).to(torch.float16)
def mean_dim0(x): return _mat(x, 128, 3).float().mean(dim=0).to(torch.float16)

# ---- 矩阵扩样用例 ----
def otr_sum_d0_f16(x): return _mat(x, 64, 16).float().sum(dim=0).to(torch.float16)
def otr_sum_d0_f32(x): return _mat(x, 64, 16).float().sum(dim=0).to(torch.float32)
def otr_sum_d0_i32(x): return _mat(x, 64, 16).sum(dim=0)
def otr_sum_d1_f16(x): return _mat(x, 64, 16).float().sum(dim=1).to(torch.float16)
def otr_sum_d1_f32(x): return _mat(x, 64, 16).float().sum(dim=1).to(torch.float32)
def otr_sum_d1_i32(x): return _mat(x, 64, 16).sum(dim=1)
def otr_max_d0_f16(x): return _mat(x, 64, 16).float().amax(dim=0).to(torch.float16)
def otr_max_d0_f32(x): return _mat(x, 64, 16).float().amax(dim=0).to(torch.float32)
def otr_max_d0_i32(x): return _mat(x, 64, 16).max(dim=0).values
def otr_max_d1_f16(x): return _mat(x, 64, 16).float().amax(dim=1).to(torch.float16)
def otr_max_d1_f32(x): return _mat(x, 64, 16).float().amax(dim=1).to(torch.float32)
def otr_max_d1_i32(x): return _mat(x, 64, 16).max(dim=1).values
def otr_min_d0_f16(x): return _mat(x, 64, 16).float().amin(dim=0).to(torch.float16)
def otr_min_d0_f32(x): return _mat(x, 64, 16).float().amin(dim=0).to(torch.float32)
def otr_min_d0_i32(x): return _mat(x, 64, 16).min(dim=0).values
def otr_min_d1_f16(x): return _mat(x, 64, 16).float().amin(dim=1).to(torch.float16)
def otr_min_d1_f32(x): return _mat(x, 64, 16).float().amin(dim=1).to(torch.float32)
def otr_min_d1_i32(x): return _mat(x, 64, 16).min(dim=1).values

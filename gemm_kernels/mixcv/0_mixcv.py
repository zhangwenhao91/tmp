import tilelang
import torch
import tilelang.language as T

# out = a @ b + c
# a [M, K]
# b [K, N]
# c [M, N]
def mixCV(M, K, N):
  num_blocks = 1
  dtype = "float32"
  VL = 64

  @T.prim_func
  def mixCV_kernel(
    A: T.Buffer((M, K), dtype),
    B: T.Buffer((K, N), dtype),
    C: T.Buffer((M, N), dtype),
    OUT: T.Buffer((M, N), dtype)
  ):
    with T.Kernel(num_blocks) as bx:
      a_shared = T.alloc_shared((M, K), dtype)
      b_shared = T.alloc_shared((K, N), dtype)
      c_shared = T.alloc_shared((M, N), dtype)
      out_shared = T.alloc_shared((M, N), dtype)
      T.copy(A, a_shared)
      T.copy(B, b_shared)
      T.copy(C, c_shared)

      loc_frag = T.alloc_frag((M, N), dtype)
      T.gemm(a_shared, b_shared, loc_frag)  # [256x128xfloat16]

      cube_res = T.alloc_shared((M, N), dtype)
      T.copy(loc_frag, cube_res)

      with T.SimdVF():
        for r in range(0, M):
          for i in range(0, N // VL):
            cube_frag = T.alloc_frag((VL, ), dtype)
            c_frag = T.alloc_frag((VL, ), dtype)
            out_frag = T.alloc_frag((VL, ), dtype)

            T.copy(cube_res[r, i * VL : (i + 1) * VL], cube_frag)
            T.copy(c_shared[r, i * VL : (i + 1) * VL], c_frag)
            T.vadd(cube_frag, c_frag, out_frag)
            T.copy(out_frag, out_shared[r, i * VL : (i + 1) * VL])

      T.copy(out_shared, OUT)

  return mixCV_kernel


if __name__ == "__main__":
  M, K, N = 16, 128, 128
  program = mixCV(M, K, N)
  artifact = tilelang.lower(program, target="tile")
  with open("1_mixcv_tilelangir.mlir", "w") as f:
    f.write(artifact.kernel_source)
  print("saved 1_mixcv_tilelangir.mlir")

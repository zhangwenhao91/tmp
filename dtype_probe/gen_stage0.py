"""多 dtype 覆盖扫描：为 reduce 各 op × dtype 生成 stage0 MLIR。

线程域形态（T.Kernel 内直接 T.reduce_*），与任务点名的形态一致。
输出到 dtype_probe/ 下的 1_<op>_<dtype>_tilelangir.mlir。
"""

import os

import tilelang
import tilelang.language as T

HERE = os.path.dirname(os.path.abspath(__file__))


def make(op, dtype, M=32, K=128, BR=16):
    num_blocks = M // BR

    def body(A, OUT, a_shared, out_shared):
        from tilelang.language import reduce_op as R

        fn = {
            "sum": R.reduce_sum,
            "max": R.reduce_max,
            "min": R.reduce_min,
            "abssum": R.reduce_abssum,
            "absmax": R.reduce_absmax,
            "bitand": R.reduce_bitand,
            "bitor": R.reduce_bitor,
            "bitxor": R.reduce_bitxor,
        }[op]
        if op in ("abssum", "bitand", "bitor", "bitxor"):
            fn(a_shared, out_shared, dim=1)
        else:
            fn(a_shared, out_shared, dim=1, clear=True)

    @T.prim_func
    def kernel(A: T.Buffer((M, K), dtype), OUT: T.Buffer((M,), dtype)):
        with T.Kernel(num_blocks) as bx:
            a_shared = T.alloc_shared((BR, K), dtype)
            out_shared = T.alloc_shared((BR,), dtype)
            T.copy(A[bx * BR : (bx + 1) * BR, 0:K], a_shared)
            body(A, OUT, a_shared, out_shared)
            T.copy(out_shared, OUT[bx * BR : (bx + 1) * BR])

    return kernel


FLOAT_DTYPES = ["float16", "bfloat16", "float32"]
INT_DTYPES = ["int8", "int16", "int32", "int64"]

CASES = []
for op in ("sum", "max", "min"):
    for d in FLOAT_DTYPES + INT_DTYPES:
        CASES.append((op, d))
for op in ("abssum", "absmax"):
    for d in FLOAT_DTYPES:
        CASES.append((op, d))

if __name__ == "__main__":
    outdir = os.path.join(HERE, "stage0")
    os.makedirs(outdir, exist_ok=True)
    for op, dtype in CASES:
        name = f"{op}_{dtype}"
        try:
            art = tilelang.lower(make(op, dtype), target="tile")
            with open(os.path.join(outdir, f"1_{name}_tilelangir.mlir"), "w") as f:
                f.write(art.kernel_source)
            print(f"OK   {name}")
        except Exception as e:  # noqa: BLE001
            print(f"FAIL {name}: {type(e).__name__}: {e}")
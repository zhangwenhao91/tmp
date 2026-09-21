# vadd/vsub 算子实现步骤总结

本文总结在 TileLang 项目中添加向量算子 `vadd` 或 `vsub` 时需要经过的实现层次，以及每个层次对应的完整文件路径。

项目根目录：

```text
/home/lly/helloworld/tilelang-tileir-ascend
```

Git 已确认使用上述目录作为仓库根目录，`.git` 位于：

```text
/home/lly/helloworld/tilelang-tileir-ascend/.git
```

可在项目根目录用以下命令确认当前 Git 路径：

```bash
cd /home/lly/helloworld/tilelang-tileir-ascend
git rev-parse --show-toplevel
git rev-parse --git-dir
```

预期输出分别为：

```text
/home/lly/helloworld/tilelang-tileir-ascend
.git
```

当前远程仓库地址为：

```text
https://github.com/flutterfish/tilelang-tileir-ascend.git
```

## 一、整体实现链路

```text
Python DSL API
    -> TIRX TileOp
    -> C++ 算子注册
    -> TileLangIR Translator
    -> MLIR linalg 算子
    -> TileLangIR MLIR
```

以 `vsub` 为例：

```text
T.vsub(a_frag, b_frag, c_frag)
    -> tl.tileop.vsub
    -> TileLangIRTranslator.visit_call_()
    -> TileLangIRTranslator._emit_vsub()
    -> linalg.sub
```

## 二、Python 向量 API

文件路径：

```text
/home/lly/helloworld/tilelang-tileir-ascend/tilelang/language/simd/vector.py
```

该文件负责定义 Python 层的向量操作。

`vadd` 的实现形式：

```python
def vadd(src0: OperandType, src1: OperandType, dst: OperandType) -> tirx.PrimExpr:
    """Add two vector regions and write the result to a vector region."""
    return _binary_vector_op("vadd", src0, src1, dst)
```

对应的 `vsub` 实现：

```python
def vsub(src0: OperandType, src1: OperandType, dst: OperandType) -> tirx.PrimExpr:
    """Subtract two vector regions and write the result to a vector region."""
    return _binary_vector_op("vsub", src0, src1, dst)
```

`_binary_vector_op()` 会完成通用处理：

- 规范化输入和输出对象；
- 将 Buffer 或 BufferRegion 转换为 TileLang region；
- 将输入标记为只读；
- 将输出标记为只写；
- 创建 `tl.tileop.vadd` 或 `tl.tileop.vsub` 调用。

## 三、导出 SIMD API

文件路径：

```text
/home/lly/helloworld/tilelang-tileir-ascend/tilelang/language/simd/__init__.py
```

需要在导入列表中加入：

```python
from .vector import (
    vadd,
    vsub,
    ...
)
```

同时在 `__all__` 中加入：

```python
__all__ = [
    "vadd",
    "vsub",
    ...
]
```

## 四、导出到 `T` 命名空间

文件路径：

```text
/home/lly/helloworld/tilelang-tileir-ascend/tilelang/language/__init__.py
```

在 SIMD 导入列表中加入：

```python
from .simd import (
    vadd,
    vsub,
    ...
)
```

完成后，示例代码才能使用：

```python
T.vsub(a_frag, b_frag, c_frag)
```

## 五、C++ TileOp 注册

文件路径：

```text
/home/lly/helloworld/tilelang-tileir-ascend/src/op/vector.cc
```

需要注册 `tl.tileop.vsub`：

```cpp
TVM_REGISTER_OP("tl.tileop.vsub")
    .set_num_inputs(3)
    .set_attr<TScriptPrinterName>("TScriptPrinterName", "vsub")
    .set_attr<TCallEffectKind>("TCallEffectKind",
                               Integer(CallEffectKind::kOpaque));
```

这一步负责让 TVM/TIRX 识别 `tl.tileop.vsub`。

注意：C++ 注册本身不执行减法，只是注册算子名称、输入数量和副作用属性。

## 六、MLIR Translator 转换

文件路径：

```text
/home/lly/helloworld/tilelang-tileir-ascend/tilelangir/translator.py
```

### 1. 在 `visit_call_()` 中分发

加入：

```python
elif op_name == "tl.tileop.vsub":
    self._emit_vsub(op)
```

### 2. 添加 `_emit_vsub()`

加入：

```python
def _emit_vsub(self, call: tirx.Call) -> None:
    if len(call.args) != 3:
        raise ValueError(
            f"tl.tileop.vsub expects 3 arguments, but received {len(call.args)}"
        )

    src0 = self._get_or_create_expr_value(call.args[0])
    src1 = self._get_or_create_expr_value(call.args[1])
    dst = self._get_or_create_expr_value(call.args[2])

    self._linalg.sub(src0, src1, outs=[dst])
```

`vadd` 的转换是：

```python
self._linalg.add(src0, src1, outs=[dst])
```

`vsub` 的转换是：

```python
self._linalg.sub(src0, src1, outs=[dst])
```

因此最终的 MLIR 应包含：

```mlir
linalg.sub
```

## 七、添加示例程序

文件路径：

```text
/home/lly/helloworld/tilelang-tileir-ascend/examples/ascend/vsub_demo.py
```

可以参考：

```text
/home/lly/helloworld/tilelang-tileir-ascend/examples/ascend/vadd_demo.py
```

主要修改如下：

```python
def vsub(M=1024, N=256, block_M=32):
```

将：

```python
T.vadd(a_frag, b_frag, c_frag)
```

改为：

```python
T.vsub(a_frag, b_frag, c_frag)
```

入口改为：

```python
if __name__ == "__main__":
    program = vsub()
    tilelang.lower(program, target="tile")
```

## 八、CMake 构建

由于修改了 C++ 文件：

```text
/home/lly/helloworld/tilelang-tileir-ascend/src/op/vector.cc
```

需要重新构建。

进入项目目录并激活虚拟环境：

```bash
cd /home/lly/helloworld/tilelang-tileir-ascend
source .venv/bin/activate
```

CMake 构建可能会编译以下目标：

```text
libtilelang.so
libtvm_compiler.so
libtvm_runtime.so
tilelang_cython_wrapper
```

## 九、运行环境变量

运行源码版本时，使用以下环境变量：

```bash
cd /home/lly/helloworld/tilelang-tileir-ascend
source .venv/bin/activate

export TVM_LIBRARY_PATH="$PWD/build/lib"
export PYTHONPATH="$PWD:$PWD/tilelangir:$PWD/3rdparty/tvm/python${PYTHONPATH:+:$PYTHONPATH}"
export LD_PRELOAD="$PWD/3rdparty/tvm/3rdparty/tvm-ffi/build/lib/libtvm_ffi.so"
```

运行 vsub 示例：

```bash
python /home/lly/helloworld/tilelang-tileir-ascend/examples/ascend/vsub_demo.py
```

保存下降后的 IR：

```bash
python /home/lly/helloworld/tilelang-tileir-ascend/examples/ascend/vsub_demo.py \
  > /mnt/c/Users/lly/Desktop/vsub_demo_lowered_ir.txt 2>&1
```

验证是否生成减法 MLIR：

```bash
grep -n "linalg.sub" \
  /mnt/c/Users/lly/Desktop/vsub_demo_lowered_ir.txt
```

## 十、vadd 和 vsub 的区别

| 层次 | vadd | vsub |
|---|---|---|
| Python API | `T.vadd(a, b, c)` | `T.vsub(a, b, c)` |
| TIRX Operation | `tl.tileop.vadd` | `tl.tileop.vsub` |
| Translator 函数 | `_emit_vadd()` | `_emit_vsub()` |
| MLIR Operation | `linalg.add` | `linalg.sub` |
| 计算含义 | `c[i] = a[i] + b[i]` | `c[i] = a[i] - b[i]` |

## 十一、完整文件清单

实现 `vadd` 或 `vsub` 时，重点文件的完整路径如下：

```text
/home/lly/helloworld/tilelang-tileir-ascend/tilelang/language/simd/vector.py

/home/lly/helloworld/tilelang-tileir-ascend/tilelang/language/simd/__init__.py

/home/lly/helloworld/tilelang-tileir-ascend/tilelang/language/__init__.py

/home/lly/helloworld/tilelang-tileir-ascend/src/op/vector.cc

/home/lly/helloworld/tilelang-tileir-ascend/tilelangir/translator.py

/home/lly/helloworld/tilelang-tileir-ascend/examples/ascend/vadd_demo.py

/home/lly/helloworld/tilelang-tileir-ascend/examples/ascend/vsub_demo.py
```

# DMALowering.cpp 逐行解释

> 文件路径: `OpenTileAS/lib/Conversion/NpuToCCE/DMA/DMALowering.cpp`
> 748 行，是 NpuToCCE 转换的核心——所有数据搬运的"翻译"都在这里。

---

## 1. 文件头与 include（1-29）

```cpp
#include "DMALowering.h"              // 本 pass 的头文件
#include "../Common/LoweringUtils.h"  // 通用 lowering 工具（createConstantI64 等）
#include "DMALoweringInternal.h"      // 内部声明（lowerGM2UB/lowerUB2GM/lowerUBCopy）
```

第 11-24 行引入 CCE dialect、NPU dialect、硬件常量、MovConfig（参数计算）、地址空间工具、MLIR 的 arith/memref/scf dialect、pattern 匹配和 LLVM 的 DenseMap/STLExtras。

**文件作用**：把 `npu.copy` op（NPU dialect 层的搬运指令）降级成具体的 CCE 硬件指令（如 `cce.mov.out.to.l1.multi.nd2nz`、`cce.fix.l0c.to.ub` 等）。

---

## 2. CopyDirection 枚举（34-47）

```cpp
enum class CopyDirection {
  GM2UB,         // GM → UB
  UB2GM,         // UB → GM
  GM2L1,         // GM → L1（带 ND2NZ 重排）
  UB2L1Linear,   // UB → L1（线性搬运，源已是 NZ）
  UB2L1NZ,       // UB → L1（ND→NZ 重排）
  UB2L1NZSplit,  // UB → L1（CV12 半块拼整 + ND→NZ）
  L12UB,         // L1 → UB
  L12L1,         // L1 → L1
  L12L0A,        // L1 → L0A
  L12L0B,        // L1 → L0B
  L0C2Any,       // L0C → UB/L1/GM（FIX pipe）
  Unknown        // 不认识的方向
};
```

所有可能的搬运方向。`lowerCopy` 里的 switch 就分发到这些方向各自的函数。

---

## 3. DMACopyCompiler 类（52-97）

```cpp
class DMACopyCompiler {
public:
  explicit DMACopyCompiler(const HardwareConfig &hardware)
      : hardware(hardware) {}
```

构造函数，传入硬件配置（含 `vectorRegisterBytes` 等）。

```cpp
  LogicalResult lower(npu::CopyOp copy, RewriterBase &builder) const;
  bool hasDefinedMapping(Operation *operation) const;
```

两个公开接口：`lower` 执行降级，`hasDefinedMapping` 查询是否支持某个方向。

```cpp
private:
  FailureOr<int64_t> computeContiguousLocalCopyCfg(MemRefType type) const;
```

计算连续块搬运的 config（32B 块数编码，给 `mov.ub.to.l1.v310` 用）。

```cpp
  bool isRank2F32ColumnMajorView(MemRefType type) const;
```

判断是不是 f32 列优先视图（strides[0]=1, strides[1]>1）——L0C→GM 时用来区分 NZ2DN 和 NZ2ND 模式。

```cpp
  bool hasStaticNegativeOffset(Value value) const;
```

检查 GM 源是否有静态负偏移（负偏移搬运非法，直接报错）。

```cpp
  CopyDirection classifyCopyDirection(Operation *op, int64_t srcSpace,
                                      int64_t dstSpace) const;
```

核心分发函数：根据源/目的地址空间 + 属性标记，决定走哪条 lowering 路径。

下面是 11 个 `lower*` 私有方法，每个对应一个 CopyDirection：

- `lowerGM2L1`（176-290）：GM→L1 ND2NZ
- `lowerUB2L1Linear`（294-305）：UB→L1 线性
- `lowerL12UB`（308-321）：L1→UB
- `lowerL12L1`（327-340）：L1→L1
- `lowerUB2L1NZ`（343-407）：UB→L1 ND→NZ
- `lowerUB2L1NZSplit`（412-507）：UB→L1 CV12 半块
- `lowerL12L0A`（510-538）：L1→L0A
- `lowerL12L0B`（541-559）：L1→L0B
- `lowerL0C2Any`（562-641）：L0C→UB/L1/GM
- `lowerCopy`（644-701）：总分发器
- `lowerGM2UB`/`lowerUB2GM`/`lowerUBCopy`：在 DMALoweringInternal.h 声明，实现在别的文件

---

## 4. computeContiguousLocalCopyCfg（99-109）

```cpp
FailureOr<int64_t>
DMACopyCompiler::computeContiguousLocalCopyCfg(MemRefType type) const {
  if (!type.hasStaticShape())
    return failure();                          // 动态形状不算
  uint64_t elements = type.getNumElements();
  uint64_t bytes = elements * getElementByteWidth(type.getElementType());
  if (bytes == 0 || bytes % 32 != 0 || bytes / 32 > 0xFFFF)
    return failure();                          // 必须是 32B 对齐，块数 ≤ 65535
  uint64_t blockCount = bytes / 32;
  return static_cast<int64_t>((uint64_t{1} << 4) | (blockCount << 16));
}
```

编码格式：`bit4=1`（标记"有效"）+ `blockCount << 16`（32B 块数量）。这个 config 传给 `mov.ub.to.l1.v310` 等线性搬运指令，告诉硬件"连续搬 N 个 32B 块"。

**约束**：总字节数必须是 32 的整数倍且不超过 65535×32B≈2MB——超了就 failure，走逐元素 fallback。

---

## 5. isRank2F32ColumnMajorView（111-120）

```cpp
bool DMACopyCompiler::isRank2F32ColumnMajorView(MemRefType type) const {
  if (!type || type.getRank() != 2 || !type.hasStaticShape())
    return false;
  SmallVector<int64_t, 2> strides;
  int64_t offset;
  if (failed(type.getStridesAndOffset(strides, offset)) || strides.size() != 2)
    return false;
  return type.getElementType().isF32() && strides[0] == 1 &&
         (ShapedType::isDynamic(strides[1]) || strides[1] > 1);
}
```

判断条件：f32 + 2D + strides[0]=1（行 stride=1，即列优先）+ strides[1]>1（列 stride 大）。这决定了 L0C→GM 时用 NZ2DN（列优先输出）还是 NZ2ND（行优先输出）。

---

## 6. hasStaticNegativeOffset（122-134）

```cpp
bool DMACopyCompiler::hasStaticNegativeOffset(Value value) const {
  auto reinterpret = value.getDefiningOp<memref::ReinterpretCastOp>();
  if (!reinterpret || reinterpret.getMixedOffsets().empty())
    return false;
```

只有 `memref.reinterpret_cast` 生成的 view 才有偏移属性。不是 reinterpret_cast 直接返回 false。

```cpp
  OpFoldResult offset = reinterpret.getMixedOffsets().front();
  if (auto attr = dyn_cast<Attribute>(offset))
    return cast<IntegerAttr>(attr).getInt() < 0;    // 静态属性：直接看值
  if (auto constant =
          cast<Value>(offset).getDefiningOp<arith::ConstantIndexOp>())
    return constant.value() < 0;                    // 常量 Value：看值
  return false;                                     // 动态偏移：不报错
}
```

GM 偏移为负意味着读 GM 负地址——非法。静态可检测就拦住。

---

## 7. classifyCopyDirection（136-173）

**总分发函数**——根据 src/dst 地址空间 + 属性标记决定走哪条 lowering 路径。

```cpp
if (srcSpace == ADDRSPACE_GM) {
    if (dstSpace == ADDRSPACE_UB)  return CopyDirection::GM2UB;
    if (dstSpace == ADDRSPACE_L1)  return CopyDirection::GM2L1;
    return CopyDirection::Unknown;
  }
```
GM 源：去 UB 或去 L1，其他不认。

```cpp
  if (srcSpace == ADDRSPACE_UB) {
    if (dstSpace == ADDRSPACE_GM)  return CopyDirection::UB2GM;
    if (dstSpace == ADDRSPACE_L1)
      return op->hasAttr("linear_transfer")
                 ? CopyDirection::UB2L1Linear
                 : (op->hasAttr("split_dim") ? CopyDirection::UB2L1NZSplit
                                             : CopyDirection::UB2L1NZ);
    return CopyDirection::Unknown;
  }
```
UB 源去 L1 时**三级判定**：
1. 有 `linear_transfer` → 线性搬运（源已被 scatter 过，已是 NZ）
2. 有 `split_dim` → CV12 半块路径
3. 都没有 → 普通 ND→NZ 重排

```cpp
  if (srcSpace == ADDRSPACE_L1) {
    if (dstSpace == ADDRSPACE_UB)  return CopyDirection::L12UB;
    if (dstSpace == ADDRSPACE_L1)  return CopyDirection::L12L1;
    if (dstSpace == ADDRSPACE_L0A) return CopyDirection::L12L0A;
    if (dstSpace == ADDRSPACE_L0B) return CopyDirection::L12L0B;
    return CopyDirection::Unknown;
  }
```
L1 源：去 UB/L1/L0A/L0B 四个方向。

```cpp
  if (srcSpace == ADDRSPACE_L0C &&
      (dstSpace == ADDRSPACE_UB || dstSpace == ADDRSPACE_L1 ||
       dstSpace == ADDRSPACE_GM))
    return CopyDirection::L0C2Any;
  return CopyDirection::Unknown;
}
```
L0C 源：FIX pipe 去 UB/L1/GM，统一走 `lowerL0C2Any`。

---

## 8. lowerGM2L1（176-290）— GM→L1 ND2NZ

**最重要的函数之一**，把 GM 的 ND 数据搬进 L1 并重排成 NZ。

```cpp
auto movSrcType = srcType;
if (!srcType.hasStaticShape() && dstType.hasStaticShape())
    movSrcType = dstType;
```
动态形状时用 L1 目的的类型计算参数（因为 GM tail tile 可能比静态形状小，但 L1 是按完整 shape 分配的）。

```cpp
auto cfg = mov_config::computeMovOutToL1Cfg(movSrcType, dstType,
                                            /*transposed=*/false);
if (!cfg.hasDynamicRowStride && cfg.config0 == 0 && cfg.config1 == 0)
    return op->emitError("failed to compute GM→L1 MOV config");
```
调 MovConfig.cpp 计算两个 config 和 mte2NzPara。全 0 说明算不出参数。

```cpp
ResolvedValidDomain domain = resolveValidDomain(src, srcType, builder, loc);
```
**valid domain**——处理 mask 搬运。GM 源可能是 `reinterpret_cast` 出来的子视图，valid domain 解析出实际有效行列数（运行时动态值）。

```cpp
if (domain.state == ValidDomainState::Complete && srcType.getRank() >= 2) {
    validRows = domain.extents[srcType.getRank() - 2];
    validColumns = domain.extents[srcType.getRank() - 1];
  }
```
如果能解析出完整 domain，取运行时行列数——用来覆盖 config 里的静态 nvalue/dvalue。

```cpp
createOperation(builder, loc, cce::SET_MTE2_NZ_PARAOp::getOperationName(),
                {createConstantI64(builder, loc, cfg.mte2NzPara)});
```
**先发 SET.MTE2.NZ.PARA**——设置打包参数（ndNum | loop2DstStride<<16 | loop3DstStride<<32）。

### 动态行距分支（231-253）

```cpp
if (cfg.hasDynamicRowStride) {
    Value stride64 = extractDynamicRowStride(src, builder, loc);
```
从 reinterpret_cast 链里抽取出运行时行距。

```cpp
    Value loop1SrcStride = arith::MulIOp::create(builder, loc, stride64, typeSizeC);
```
行距（元素数）× typeSize = 行距（字节）。

```cpp
    Value shiftedStride = arith::ShLIOp::create(
        builder, loc, loop1SrcStride, createConstantI64(builder, loc, 4));
```
左移 4 位（config0 的 bit4-43 是 loop1SrcStride）。

```cpp
    nvalue = arith::AndIOp::create(builder, loc, nvalue,
                                   createConstantI64(builder, loc, 0xffff));
    Value nvalueShifted = arith::ShLIOp::create(
        builder, loc, nvalue, createConstantI64(builder, loc, 48));
    config0Val =
        arith::OrIOp::create(builder, loc, shiftedStride, nvalueShifted);
```
运行时拼 config0：`nvalue(16bit) << 48 | stride(40bit) << 4`。

```cpp
    config1Val = arith::AndIOp::create(
        builder, loc, dvalue, createConstantI64(builder, loc, 0x1fffff));
```
config1 取低 21 位做 dvalue。

### 静态分支（254-282）

```cpp
} else {
    config0Val = createConstantI64(builder, loc, cfg.config0);
    config1Val = createConstantI64(builder, loc, cfg.config1);
```
静态分支：直接用编译期算好的常量。但如果 validRows/validColumns 有运行时值：

```cpp
    if (validRows) {
      Value maskedRows = arith::AndIOp::create(
          builder, loc, validRows, createConstantI64(builder, loc, 0xffff));
      Value shiftedRows = arith::ShLIOp::create(
          builder, loc, maskedRows, createConstantI64(builder, loc, 48));
      constexpr uint64_t kConfig0WithoutNValue = 0x0000FFFFFFFFFFFFULL;
      Value config0WithoutNValue = createConstantI64(
          builder, loc,
          static_cast<int64_t>(static_cast<uint64_t>(cfg.config0) &
                               kConfig0WithoutNValue));
      config0Val =
          arith::OrIOp::create(builder, loc, config0WithoutNValue, shiftedRows);
    }
```
用运行时 validRows 覆盖 config0 高 16 位的 nvalue 字段：先清零高 16 位，再 OR 上运行时行数。

```cpp
    if (validColumns) {
      constexpr uint64_t kDValueMask = 0x1fffffULL;
      Value maskedColumns =
          arith::AndIOp::create(builder, loc, validColumns,
                                createConstantI64(builder, loc, kDValueMask));
      Value config1WithoutDValue = createConstantI64(
          builder, loc,
          static_cast<int64_t>(static_cast<uint64_t>(cfg.config1) &
                               ~kDValueMask));
      config1Val = arith::OrIOp::create(builder, loc, config1WithoutDValue,
                                        maskedColumns);
    }
```
同理，用运行时 validColumns 覆盖 config1 低 21 位的 dvalue。

### 最终发射（283-290）

```cpp
  if (failed(emitDynamicExtentGuardedGMUbMove(
          builder, loc, cce::MovOutToL1MultiNd2nzOp::getOperationName(), dst,
          src, src, srcType, config0Val, config1Val)))
    return op->emitError(
        "cannot guard GM->L1 copy with its complete valid domain");
  builder.eraseOp(op);
  return success();
}
```
最终发出 `MOV.OUT.TO.L1.MULTI.ND2NZ` 指令，带 valid domain guard（mask 场景确保不越界）。删掉原 copy。

---

## 9. lowerUB2L1Linear（294-305）— UB→L1 线性搬运

```cpp
FailureOr<int64_t> cfg = computeContiguousLocalCopyCfg(srcType);
if (failed(cfg))
    return lowerStaticElementwise(
        op, dst, src, builder, [](OpBuilder &, Value input) { return input; });
```
先算连续块 config。算不出（不对齐/超限）就走逐元素 fallback（`lowerStaticElementwise` 生成逐元素 copy 循环）。

```cpp
createOperation(builder, loc, cce::MovUbToL1V310Op::getOperationName(),
                {dst, src, createConstantI64(builder, loc, *cfg)});
builder.eraseOp(op);
return success();
```
直接发 `mov.ub.to.l1.v310(dst, src, cfg)`——线性连续搬运，不做 ND2NZ 重排。源已是 NZ（被 ExpandUbToL1Nd2nz pass 预处理过了）。

---

## 10. lowerL12UB（308-321）— L1→UB

```cpp
FailureOr<int64_t> cfg = computeContiguousLocalCopyCfg(srcType);
if (failed(cfg))
    return lowerStaticElementwise(
        op, dst, src, builder, [](OpBuilder &, Value input) { return input; });
createOperation(builder, loc, cce::MovL1ToUbV310Op::getOperationName(),
                {dst, src, createConstantI64(builder, loc, *cfg)});
builder.eraseOp(op);
return success();
```
和 lowerUB2L1Linear 结构一模一样，只是指令换成 `mov.l1.to.ub.v310`（方向反过来）。同样线性搬运 + 逐元素 fallback。

---

## 11. lowerL12L1（327-340）— L1→L1

```cpp
// L1 to L1 hand-off across buffers or CV blocks.
// Both operands live in L1; a contiguous whole-tile transfer uses the same
// linear burst encoding as UB->L1 (one burst sequence, no gap). Falls back
// to the elementwise copy for unaligned or oversized tiles.
```
注释说明：L1→L1 用和 UB→L1 **相同的线性 burst 编码**（因为 `mov.ub.to.l1.v310` 硬件指令的源可以是 L1 的 addrspace(2)）。

```cpp
FailureOr<int64_t> cfg = computeContiguousLocalCopyCfg(srcType);
if (failed(cfg))
    return lowerStaticElementwise(
        op, dst, src, builder, [](OpBuilder &, Value input) { return input; });
createOperation(builder, loc, cce::MovUbToL1V310Op::getOperationName(),
                {dst, src, createConstantI64(builder, loc, *cfg)});
```
注意用的是 `MovUbToL1V310Op`（不是 `MovL1ToL1V310Op`）——硬件上 L1→L1 复用 UB→L1 指令，靠源指针的 addrspace(2) 区分。

**这里就是"L1→L1 不支持 ND2NZ"的位置**：只有线性搬运，没有 NZ 重排分支。需要 NZ 重排得走 UB 中转。

---

## 12. lowerUB2L1NZ（343-407）— UB→L1 ND→NZ 重排

```cpp
auto dstShape = dstType.getShape();
if (dstShape.size() < 2)
    return op->emitError("UB→L1 copy requires rank→  memref");
uint32_t rows = dstShape[dstShape.size() - 2];
uint32_t cols = dstShape[dstShape.size() - 1];
uint32_t tSize = getElementByteWidth(dstType.getElementType());
constexpr uint32_t BLOCK_BYTE = 32;
constexpr uint32_t FRACTAL_ROW = 16;
uint32_t burstElems = BLOCK_BYTE * FRACTAL_ROW / tSize; // 256 for f16, 128 for f32
uint32_t burstLen = burstElems / FRACTAL_ROW;           // 16 for f16, 8 for f32
uint32_t N = (cols + burstLen - 1) / burstLen;
```

关键参数计算：
- `burstElems` = 一个"NZ 列组"的元素数 = 32B × 16行 / typeSize。f16 时 256 个，f32 时 128 个。
- `burstLen` = 每行的 burst 元素数 = burstElems / 16。f16 时 16，f32 时 8。
- `N` = 列组数量 = cols / burstLen（向上取整）。

```cpp
int64_t cfgVal = mov_config::computeMovUbToL1V310Cfg(
    static_cast<uint16_t>(rows), static_cast<uint16_t>(N - 1));
```
cfg = nBurst=rows, srcGap=N-1（源每搬一组跳一个 gap）, lenBurst=1, dstGap=0。

```cpp
auto loop = scf::ForOp::create(builder, loc, zeroIdx, nIdx, oneIdx);
OpBuilder lb(loop.getBody()->getTerminator());
Value i = loop.getInductionVar();
```
生成循环，遍历 N 个列组。

```cpp
Value srcOff = arith::MulIOp::create(lb, loc, i, burstLenIdx);
Value dstOff = arith::MulIOp::create(lb, loc, srcOff, rowsIdx);
```
- 源偏移 = i × burstLen（UB 里按列组顺序读）
- 目的偏移 = srcOff × rows（L1 里 NZ 布局每个列组占 rows×burstLen 个元素）

```cpp
auto srcTileType = MemRefType::get({tileElems}, elemType, ..., srcMemSpace);
auto dstTileType = MemRefType::get({tileElems}, elemType, ..., dstMemSpace);
Value srcTile = memref::ReinterpretCastOp::create(lb, loc, srcTileType, src, ...).getResult();
Value dstTile = memref::ReinterpretCastOp::create(lb, loc, dstTileType, dst, ...).getResult();
createOperation(lb, loc, cce::MovUbToL1V310Op::getOperationName(),
                {dstTile, srcTile, cfg});
```
每次迭代：构造 1D tile view（src 和 dst 各一个），发 `mov.ub.to.l1.v310` 搬一个列组。循环 N 次搬完全部。

**和 gitcode 版 ExpandUbToL1Nd2nz 的区别**：这里直接用 DMA 指令的 burst+gap 模式做 ND→NZ（靠 srcGap=N-1 在 UB 里跳着读，实现 NZ 布局）。gitcode 版先在 UB 内用向量指令 scatter 重排，再线性搬运。

---

## 13. lowerUB2L1NZSplit（412-507）— CV12 半块路径

```cpp
auto copy = cast<npu::CopyOp>(op);
auto splitDimAttr = copy.getSplitDimAttr();
if (!splitDimAttr)
    return op->emitError("UB→L1 split copy missing split_dim attribute");
int64_t splitDim = splitDimAttr.getInt();
```
取 split_dim 属性（0=按行切，1=按列切）。

```cpp
ArrayRef<int64_t> fullDstShape = dstType.getShape();
unsigned rowDim = fullDstShape.size() - 2;
uint32_t fullRows = fullDstShape[rowDim];      // 整块行数
```
取目的（完整 L1）的行数。

```cpp
uint32_t elementBytes = getElementByteWidth(dstType.getElementType());
constexpr uint32_t blockBytes = 32;
uint32_t burstLen = blockBytes / elementBytes;  // f16→16, f32→8
```
每行 burst 元素数（= 32B / 元素大小）。

```cpp
ArrayRef<int64_t> halfShape = srcType.getShape();
uint32_t halfRows = halfShape[halfShape.size() - 2];
uint32_t halfCols = halfShape[halfShape.size() - 1];
if (halfCols % burstLen != 0)
    return op->emitError() << "UB→L1 ND→NZ split copy requires the innermost dimension "
                              "to be N0-aligned (N0="
                           << burstLen << " elements for " << dstType.getElementType()
                           << "), but got " << halfCols;
```
取源（半块 UB）的行列数。**列数必须 N0 对齐**——半块的列数必须是 burstLen 的整数倍，否则报错。

```cpp
builder.setInsertionPointToStart(op->getBlock());
Value subBlockId =
    cce::GetSubBlockIdxInstrOp::create(builder, loc, builder.getI64Type())
        .getResult();
builder.setInsertionPoint(op);
```
在 block 入口处插入 `GET.SUBBLOCKID()` 指令——取当前 sub_block ID（0 或 1）。放到 block 开头是为了让物理偏移计算在循环之前就就绪。

```cpp
Value subBlockIdIndex = arith::IndexCastOp::create(builder, loc, builder.getIndexType(), subBlockId);
Value halfSplitDim = arith::ConstantIndexOp::create(builder, loc, halfShape[splitDim]);
Value subBlockOffset = arith::MulIOp::create(builder, loc, subBlockIdIndex, halfSplitDim);
```
subBlockOffset = subBlockId × halfSize[splitDim]——sb0 偏移=0，sb1 偏移=halfSize。

```cpp
uint32_t physicalScale = splitDim == rowDim ? burstLen : fullRows;
Value dstBaseOffset =
    arith::MulIOp::create(builder, loc, subBlockOffset, physicalScaleValue);
```
目的基址偏移：
- **行切（splitDim==rowDim）**：物理 scale = burstLen（每行 burstLen 个元素，行偏移 × burstLen）
- **列切（splitDim!=rowDim）**：物理 scale = fullRows（每列 fullRows 个元素，列偏移 × fullRows）

```cpp
uint32_t columnGroups = halfCols / burstLen;
int64_t cfgVal = mov_config::computeMovUbToL1V310Cfg(
    static_cast<uint16_t>(halfRows), static_cast<uint16_t>(columnGroups - 1));
```
cfg = nBurst=halfRows, srcGap=columnGroups-1。

```cpp
auto loop = scf::ForOp::create(builder, loc, lower, upper, step);
Value induction = loop.getInductionVar();
```
遍历 columnGroups 个列组。

```cpp
Value srcOffset = arith::MulIOp::create(loopBuilder, loc, induction, burstLenValue);
Value dstColumnOffset = arith::MulIOp::create(loopBuilder, loc, srcOffset, fullRowsValue);
Value dstOffset = arith::AddIOp::create(loopBuilder, loc, dstBaseOffset, dstColumnOffset);
```
目的偏移 = 基址偏移（由 sub_block ID 决定） + 列组偏移。sb0 写前半区，sb1 写后半区。

```cpp
Value srcTile = memref::ReinterpretCastOp::create(loopBuilder, loc, srcTileType, src, ...).getResult();
Value dstTile = memref::ReinterpretCastOp::create(loopBuilder, loc, dstTileType, dst, ...).getResult();
createOperation(loopBuilder, loc, cce::MovUbToL1V310Op::getOperationName(),
                {dstTile, srcTile, cfg});
```
每次迭代搬一个列组。两个 sub_block 各跑一遍循环，各写各自的半区，拼成完整 NZ 布局。

**这就是手修 gemm 时"FIX 拆两条 DMA 写各自半区"的编译器自动化版本**。

---

## 14. lowerL12L0A（510-538）— L1→L0A

```cpp
auto copy = cast<npu::CopyOp>(op);
std::optional<bool> requestedTranspose = copy.getTransposed();
for (Operation *user : dst.getUsers()) {
    auto mad = dyn_cast<npu::MadOp>(user);
    if (!mad || mad.getSrc0() != dst)
      continue;
    bool lhsTranspose = mad.getLhsTrans();
    if (requestedTranspose && *requestedTranspose != lhsTranspose)
      return op->emitError("L0A copy transpose disagrees with an npu.mad lhs_trans user");
    requestedTranspose = lhsTranspose;
  }
```
**转置推断**：如果 L0A 的用户是 MAD（矩阵乘加），看 MAD 的 `lhs_trans` 属性推断是否需要转置。如果 copy 自己带了 Transposed 属性且和 MAD 的不一致，报错。

```cpp
bool wantTranspose = requestedTranspose.value_or(false);
auto cfg = mov_config::computeLoadL1ToL0ACfg(srcType, dstType, /*transposed=*/wantTranspose);
createOperation(builder, loc, cce::LoadL1ToL0A2Dv2Op::getOperationName(),
                {dst, src, createConstantI64(builder, loc, cfg.cfg0),
                 createConstantI64(builder, loc, cfg.cfg1),
                 createConstantI64(builder, loc, wantTranspose ? 1 : 0)});
```
发 `LOAD.L1.TO.L0A.2Dv2` 指令，带 cfg0/cfg1/transpose 三个参数。A 操作数可能需要转置（取决于 MAD 的 lhs_trans）。

---

## 15. lowerL12L0B（541-559）— L1→L0B

```cpp
bool wantTranspose = cast<npu::CopyOp>(op).getTransposed().value_or(false);
auto cfg = mov_config::computeLoadL1ToL0BCfg(srcType, dstType, /*transposed=*/wantTranspose);
createOperation(builder, loc, cce::LoadL1ToL0B2Dv2Op::getOperationName(),
                {dst, src, createConstantI64(builder, loc, cfg.cfg0),
                 createConstantI64(builder, loc, cfg.cfg1),
                 createConstantI64(builder, loc, cfg.doTranspose ? 1 : 0)});
```
和 L0A 类似，但不做 MAD 用户推断（B 的转置只看 copy 自己的属性）。发 `LOAD.L1.TO.L0B.2Dv2`。

---

## 16. lowerL0C2Any（562-641）— FIX pipe（L0C→UB/L1/GM）

```cpp
bool columnMajorGm =
    dstSpace == ADDRSPACE_GM && isRank2F32ColumnMajorView(dstType);
cce::dma_mode dmaMode =
    columnMajorGm ? cce::dma_mode::NZ2DN : cce::dma_mode::NZ2ND;
```
判断 FIX 模式：GM 目的是 f32 列优先 → NZ2DN（列优先输出），否则 NZ2ND（行优先输出）。

```cpp
std::optional<int64_t> splitDim;
if (auto splitDimAttr = copy.getSplitDimAttr())
    splitDim = splitDimAttr.getInt();
```
取 split_dim（CV12 半块）。

```cpp
mov_config::FixL0cToConfig cfg;
if (dstSpace == ADDRSPACE_UB) {
    mov_config::FixL0cToUbSplitMode splitMode = mov_config::FixL0cToUbSplitMode::None;
    if (splitDim && *splitDim == 0)
      splitMode = mov_config::FixL0cToUbSplitMode::Row;      // 行切
    else if (splitDim && *splitDim == 1)
      splitMode = mov_config::FixL0cToUbSplitMode::Column;   // 列切
    cfg = mov_config::computeFixL0cToUbCfg(srcType, dstType, dmaMode, splitMode);
  } else if (dstSpace == ADDRSPACE_L1) {
    cfg = mov_config::computeFixL0cToL1Cfg(srcType, dstType, dmaMode);
  } else {
    cfg = mov_config::computeFixL0cToGmCfg(srcType, dstType, dmaMode);
  }
```
按目的地址空间调不同的 config 计算函数。L0C→UB 时还要传 splitMode（CV12 Row/Column/None）——这就是手修 `dual_dst_ctl=Row` 的编译器版本。

```cpp
if (cfg.hasDynamicDstStride) {
    Value stride64 = columnMajorGm
        ? extractDynamicStride(dst, dstType.getRank() - 1, builder, loc)
        : extractDynamicRowStride(dst, builder, loc);
```
动态目的行距：列优先取列 stride，行优先取行 stride。

```cpp
    Value dstColBits = arith::ShLIOp::create(builder, loc, stride64, ...32);
    xmReg = arith::OrIOp::create(builder, loc, dstColBits, createConstantI64(builder, loc, cfg.xmRegStaticPart));
    xtReg = createConstantI64(builder, loc, cfg.xtReg);
} else {
    xmReg = createConstantI64(builder, loc, cfg.xmReg);
    xtReg = createConstantI64(builder, loc, cfg.xtReg);
}
```
xmReg = 目的行距<<32 | 静态部分（FIX 的地址模式参数）。xtReg = 第二个 FIX 寄存器值。

```cpp
createOperation(builder, loc, cce::SET_LOOP3_PARAOp::getOperationName(),
                {createConstantI64(builder, loc, 1)]);
```
**SET.LOOP3.PARA(1)**——FIX 的循环参数，设为 1（一个 rank-2 tile 只含一个 ND 矩阵）。

```cpp
if (dstSpace == ADDRSPACE_GM) {
    uint64_t channelConfig = columnMajorGm ? 1ULL << 48 : 0;
    createOperation(builder, loc, cce::SetChannelParaOp::getOperationName(),
                    {createConstantI64(builder, loc, channelConfig)]);
}
```
GM 目的额外设 channel 参数：列优先时 bit48=1（启用列优先通道）。

```cpp
NamedAttribute dmaModeAttr = builder.getNamedAttr(
    "dmaMode", cce::dma_modeAttr::get(builder.getContext(), dmaMode));
```
构造 dmaMode 属性（NZ2ND/NZ2DN），附在 FIX 指令上。

```cpp
if (dstSpace == ADDRSPACE_UB) {
    createOperation(builder, loc, cce::FixL0cToUBOp::getOperationName(),
                    {dst, src, xmReg, xtReg}, {}, {dmaModeAttr});
    builder.eraseOp(op);
    return success();
  }
  createOperation(builder, loc,
                  dstSpace == ADDRSPACE_L1
                      ? cce::FixL0cToL1Op::getOperationName()
                      : cce::FixL0cToOutOp::getOperationName(),
                  {dst, src, xmReg, xtReg}, {}, {dmaModeAttr});
```
按目的发不同的 FIX 指令：
- L0C→UB：`FIX.L0C.TO.UB`
- L0C→L1：`FIX.L0C.TO.L1`
- L0C→GM：`FIX.L0C.TO.OUT`

三个都带 xmReg/xtReg 和 dmaMode。

---

## 17. lowerCopy（644-701）— 总分发器

```cpp
Value dst = op->getOperand(0);
Value src = op->getOperand(1);
std::optional<int64_t> dstSpace = getMemorySpace(dst);
std::optional<int64_t> srcSpace = getMemorySpace(src);
if (!dstSpace || !srcSpace)
    return op->emitError("copy requires known NPU memory spaces");
```
取源/目的地址空间。拿不到就报错。

```cpp
if (*srcSpace == ADDRSPACE_GM && hasStaticNegativeOffset(src))
    return op->emitError("unmasked copy from a statically negative GM offset is unsupported");
```
GM 负偏移拦截。

```cpp
builder.setInsertionPoint(op);
```
设插入点——防止 aux 操作被前一个 lowering 的 eraseOp 影响。

```cpp
switch (classifyCopyDirection(op, *srcSpace, *dstSpace)) {
  case CopyDirection::GM2UB:
    return lowerGM2UB(op, builder, dst, src, dstType, srcType, loc);
  case CopyDirection::UB2GM:
    return lowerUB2GM(op, builder, dst, src, dstType, srcType, loc);
  case CopyDirection::GM2L1:
    return lowerGM2L1(op, builder, dst, src, dstType, srcType, loc);
  ...
  case CopyDirection::Unknown:
    op->emitRemark() << "NPU copy mapping " << *srcSpace << " -> " << *dstSpace
                     << " is not defined yet; operation is preserved";
    return failure();
}
```
**总分发**：classifyCopyDirection 决定方向 → switch 到对应 lower 函数。不认识的方向发 remark（保留原 op，不报错）。

---

## 18. lower（703-710）— 公开入口

```cpp
LogicalResult DMACopyCompiler::lower(npu::CopyOp copy,
                                     RewriterBase &builder) const {
  std::optional<int64_t> dstSpace = getMemorySpace(copy.getDst());
  std::optional<int64_t> srcSpace = getMemorySpace(copy.getSrc());
  if (dstSpace == ADDRSPACE_UB && srcSpace == ADDRSPACE_UB)
    return lowerUBCopy(copy.getOperation(), builder, hardware);
  return lowerCopy(copy.getOperation(), builder);
}
```
**UB→UB 特殊处理**：走 `lowerUBCopy`（在别的文件，可能涉及向量指令做 UB 内搬运）。其他都走 `lowerCopy` 总分发。

---

## 19. hasDefinedMapping（712-724）

```cpp
bool DMACopyCompiler::hasDefinedMapping(Operation *operation) const {
  auto copy = dyn_cast<npu::CopyOp>(operation);
  if (!copy)
    return false;
  std::optional<int64_t> dstSpace = getMemorySpace(copy.getDst());
  std::optional<int64_t> srcSpace = getMemorySpace(copy.getSrc());
  if (!srcSpace || !dstSpace)
    return true;    // 地址空间未知，默认"已定义"（交给 lower 时再报错）
  if (*srcSpace == ADDRSPACE_UB && *dstSpace == ADDRSPACE_UB)
    return true;    // UB→UB 有映射
  return classifyCopyDirection(operation, *srcSpace, *dstSpace) !=
         CopyDirection::Unknown;
}
```
查询接口：判断一个 copy op 是否有对应的 lowering 路径。用于 pass 管线决定是否报"未降级"错误。

---

## 20. CopyOpLowering pattern（726-736）

```cpp
struct CopyOpLowering : public OpRewritePattern<npu::CopyOp> {
  CopyOpLowering(MLIRContext *context, const HardwareConfig &config)
      : OpRewritePattern(context), config(config) {}

  LogicalResult matchAndRewrite(npu::CopyOp op,
                                PatternRewriter &rewriter) const override {
    return DMACopyCompiler(config).lower(op, rewriter);
  }

  const HardwareConfig &config;
};
```
标准 MLIR pattern：匹配 `npu.copy`，委托给 `DMACopyCompiler.lower`。

---

## 21. DMALowering 接口（740-748）

```cpp
void DMALowering::populatePatterns(RewritePatternSet &patterns) const {
  patterns.add<CopyOpLowering>(patterns.getContext(), hardware);
}

bool DMALowering::hasDefinedMapping(Operation *operation) const {
  return DMACopyCompiler(hardware).hasDefinedMapping(operation);
}
```
`DMALowering` 是 pass 层接口，注册 pattern 和查询映射——委托给 `DMACopyCompiler`。

---

## 全局架构图

```
npu.copy(src, dst)
    |
    +-- UB->UB -> lowerUBCopy (别处)
    |
    +-- lowerCopy
         |
         +-- classifyCopyDirection
         |
         +-- GM->UB     -> lowerGM2UB (别处)
         +-- UB->GM     -> lowerUB2GM (别处)
         +-- GM->L1     -> lowerGM2L1        -> SET.MTE2.NZ.PARA + MOV.OUT.TO.L1.MULTI.ND2NZ
         +-- UB->L1线性 -> lowerUB2L1Linear  -> MOV.UB.TO.L1.V310
         +-- UB->L1 NZ  -> lowerUB2L1NZ      -> 循环 MOV.UB.TO.L1.V310 (burst+gap)
         +-- UB->L1 split-> lowerUB2L1NZSplit -> GET.SUBBLOCKID + 循环 MOV.UB.TO.L1.V310
         +-- L1->UB     -> lowerL12UB        -> MOV.L1.TO.UB.V310
         +-- L1->L1     -> lowerL12L1        -> MOV.UB.TO.L1.V310 (复用，无NZ)
         +-- L1->L0A   -> lowerL12L0A       -> LOAD.L1.TO.L0A.2Dv2
         +-- L1->L0B   -> lowerL12L0B       -> LOAD.L1.TO.L0B.2Dv2
         +-- L0C->Any  -> lowerL0C2Any      -> SET.LOOP3.PARA + FIX.L0C.TO.{UB,L1,OUT}
```

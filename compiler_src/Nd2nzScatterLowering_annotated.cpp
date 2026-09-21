//===- Nd2nzScatterLowering.cpp - Lower UB ND-to-NZ scatter -------------===//
//
// OpenTileAS compiler project
//
//===----------------------------------------------------------------------===//
//
// 文件作用：把 Nd2nzScatterOp（UB 内 ND→NZ 重排）降级成 CCE 向量指令
//          （vld + vsstb）。这是 ExpandUbToL1Nd2nz pass 展开后产生的
//          scatter op 的具体实现。
//
// 核心思路：把源矩阵按列切成多个 pass，每个 pass 宽 = 一个向量寄存器
//          （256B），逐行用 vld 读、vsstb 按固定间隔散布写。
//

#include "DMALoweringInternal.h"

#include "Dialect/CCE/IR/CCE.h"
#include "Dialect/Npu/IR/NPU.h"
#include "Target/Npu/NpuTargetInfo.h"
#include "Utils/AddressSpaces.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/PatternMatch.h"

using namespace mlir;
using namespace mlir::opentile;

namespace mlir::npu {
namespace {

// ---------------------------------------------------------------------------
// 辅助函数：flattenStaticMemref
// 把多维静态 memref 展平成 1D（带 stride=1 的线性视图）。
// 如果已经是 1D 则直接返回。
// 用 memref.reinterpret_cast 实现：保留原始 buffer，只改类型描述。
// ---------------------------------------------------------------------------
static Value flattenStaticMemref(OpBuilder &builder, Location loc,
                                 Value memref) {
  auto type = cast<MemRefType>(memref.getType());
  if (type.getRank() == 1)
    return memref;                          // 已是 1D，无需转换

  int64_t elements = type.getNumElements(); // 总元素数（如 32×32=1024）
  // 构造 1D 类型：形状=[elements]，stride=1（连续），地址空间不变
  auto flatType = MemRefType::get(
      {elements}, type.getElementType(),
      StridedLayoutAttr::get(builder.getContext(), ShapedType::kDynamic, {1}),
      type.getMemorySpace());
  // reinterpret_cast：offset=0，sizes=[elements]，strides=[1]
  return memref::ReinterpretCastOp::create(
             builder, loc, flatType, memref, builder.getIndexAttr(0),
             ArrayRef<OpFoldResult>{builder.getIndexAttr(elements)},
             ArrayRef<OpFoldResult>{builder.getIndexAttr(1)})
      .getResult();
}

// ---------------------------------------------------------------------------
// 辅助函数：createDynamicLinearTile
// 从一个 1D source 上截取 [offset, offset+size) 的一段的 1D tile view。
// 用 reinterpret_cast 实现：动态 offset（运行时值），固定大小 size。
// 用于在循环内为每行/每个 pass 截取 src/dst 的小片段。
// ---------------------------------------------------------------------------
static Value createDynamicLinearTile(OpBuilder &builder, Location loc,
                                     Value source, Value offset, int64_t size) {
  auto sourceType = cast<MemRefType>(source.getType());
  // 构造 tile 类型：形状=[size]，stride=1，地址空间同 source
  auto tileType = MemRefType::get(
      {size}, sourceType.getElementType(),
      StridedLayoutAttr::get(builder.getContext(), ShapedType::kDynamic, {1}),
      sourceType.getMemorySpace());
  // reinterpret_cast：offset=动态值，sizes=[size]，strides=[1]
  return memref::ReinterpretCastOp::create(
             builder, loc, tileType, source, OpFoldResult(offset),
             ArrayRef<OpFoldResult>{builder.getIndexAttr(size)},
             ArrayRef<OpFoldResult>{builder.getIndexAttr(1)})
      .getResult();
}

// ---------------------------------------------------------------------------
// 辅助函数：createVsstb
// 生成一条 CCE vsstb 指令（向量散布存储）。
// 参数：
//   data      - 要存的向量数据（<lanes x elemType>）
//   destination - 目的地址（UB 内的 1D tile）
//   strideConfig - 散布间隔配置（高16位=块stride in 32B units，低16位=0）
//   postUpdateEnable - 后更新使能（这里恒为 0=关闭，由软件手动推进地址）
//   mask      - 谓词掩码（pset 结果，控制哪些 lane 有效）
// ---------------------------------------------------------------------------
static void createVsstb(OpBuilder &builder, Location loc, Value data,
                        Value destination, Value strideConfig,
                        Value postUpdateEnable, Value mask) {
  createOperation(builder, loc, cce::VSstbOp::getOperationName(),
                  {data, destination, strideConfig, postUpdateEnable, mask});
}

// ---------------------------------------------------------------------------
// 对齐约束说明（注释，非代码）
//
// 两个源对齐约束：
// 1. 列对齐：cols 必须是 vectorLanes 的整数倍（256B / elementBytes）。
//    不满足时 ExpandUbToL1Nd2nz pass 返回 failure，copy 回退到 npu.copy
//    路径，所以这种输入不会到达本函数。
//
// 2. 行对齐：rows 必须是 16 的整数倍（NZ fractal 行粒度）。
//    这是 Nd2nzScatterOp::verify() 中的硬性检查，不满足直接编译报错
//    （不是回退，是拒绝）。
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// 核心注释：scatter 的写入模式图解
//
// 源矩阵 A[rows][cols]，按列切成 numPasses 个 pass，每个 pass 宽=lanes：
//
//              cols = numPasses * lanes
//        +---------------+---------------+---------------+
//        |    pass 0     |    pass 1     |      ...      |
//        | B0 B1 ... B7  | B0 B1 ... B7  |      ...      |
//  rows  |      ...      |      ...      |      ...      |
//        +---------------+---------------+---------------+
//         +-- lanes el --+
//
//     lanes            = vectorRegisterBytes / elementBytes  // 每 pass 元素数
//     numPasses        = cols / lanes                          // pass 数量
//     elementsPerBlock = 32 / elementBytes                     // 每个 32B 块的元素数
//     1 pass = 256B    = 8 x 32B                              // 一个 pass 搬 8 个 32B 块
//
// 每次 (pass, row) 迭代：
//     srcOffset = row * cols + pass * lanes     （元素，行优先）
//     dstOffset = pass * (rows + 1) * lanes + row * elementsPerBlock
//
// (rows + 1) 的含义：
//   vsstb 把 256B 数据拆成 8 个 32B 块，按 (rows+1) 个 32B 块的间隔散布。
//   +1 让相邻块落在不同 UB bank（避免 bank 冲突）。
//   strideConfig = (rows + 1) << 16  （高16位=块间隔，低16位=0=关闭后更新）
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// 核心函数：lowerNd2nzScatter
// 把 Nd2nzScatterOp 降级成嵌套 scf.for 循环 + vld + vsstb
// ---------------------------------------------------------------------------
static LogicalResult lowerNd2nzScatter(Nd2nzScatterOp scatter,
                                       RewriterBase &rewriter,
                                       const HardwareConfig &config) {
  Operation *operation = scatter.getOperation();
  Value src = scatter.getSrc();      // 源：UB 里的 ND 布局数据（2D memref）
  Value dst = scatter.getDst();      // 目的：UB 里的 NZ 布局 scratch buffer（1D memref）
  auto srcType = dyn_cast<MemRefType>(src.getType());
  auto dstType = dyn_cast<MemRefType>(dst.getType());
  if (!srcType || !dstType)
    return operation->emitError("nd2nz_scatter requires memref operands");

  // 地址空间检查：源和目的都必须在 UB 内
  std::optional<int64_t> srcSpace = getMemorySpace(src);
  std::optional<int64_t> dstSpace = getMemorySpace(dst);
  if (srcSpace != ADDRSPACE_UB || dstSpace != ADDRSPACE_UB)
    return operation->emitError(
        "nd2nz_scatter requires UB source and destination");

  // 形状检查：源必须是静态 2D，目的必须是静态 1D
  if (!srcType.hasStaticShape() || srcType.getRank() != 2 ||
      !dstType.hasStaticShape() || dstType.getRank() != 1)
    return operation->emitError(
        "nd2nz_scatter requires static rank-2 source and rank-1 destination");

  Type elementType = srcType.getElementType();
  int64_t elementBytes = getElementByteWidth(elementType);  // f16=2, f32=4
  if (elementBytes <= 0 || config.vectorRegisterBytes <= 0 ||
      config.vectorRegisterBytes % elementBytes != 0)
    return operation->emitError(
        "unsupported element type or vector width for nd2nz_scatter");

  int64_t lanes = config.vectorRegisterBytes / elementBytes;
  // lanes = 256 / elementBytes
  //   f16: 256/2 = 128（一个向量寄存器放 128 个 f16）
  //   f32: 256/4 = 64（一个向量寄存器放 64 个 f32）

  int64_t rows = srcType.getDimSize(0);   // 源矩阵行数
  int64_t cols = srcType.getDimSize(1);   // 源矩阵列数

  // 列对齐检查（理论上不会到这里，Expand pass 已提前拦截，但作为安全冗余）
  if (cols % lanes != 0)
    return operation->emitError(
        "source cols must be a multiple of vector lane count");

  int64_t elementsPerBlock = 32 / elementBytes;
  // elementsPerBlock = 32 / elementBytes
  //   f16: 32/2 = 16（一个 32B 块放 16 个 f16）
  //   f32: 32/4 = 8（一个 32B 块放 8 个 f32）

  int64_t numPasses = cols / lanes;   // pass 数量 = 总列数 / 每 pass 列数
  // strideConfig：vsstb 的散布间隔
  // 高 16 位 = (rows + 1) = 块间隔（以 32B 块为单位）
  // 低 16 位 = 0 = 关闭后更新（由软件手动推进目的地址）
  int32_t strideConfig = static_cast<int32_t>((rows + 1) << 16);
  Location loc = operation->getLoc();

  // emitInVectorScope：把生成的循环和指令包在一个 AIV 向量 scope 内
  // （对应 !llvm.loop !{!"llvm.loop.aivector_scope"} metadata）
  return emitInVectorScope(
      operation, rewriter, [&](OpBuilder &bodyBuilder) -> LogicalResult {
        // 常量准备
        Value zeroI32 = createConstantI32(bodyBuilder, loc, 0);
        Value stride = createConstantI32(bodyBuilder, loc, strideConfig);
        // mask = pset(0) = 全 1 谓词（所有 lane 都有效）
        // PAT_ALL(0) 启用完整寄存器，后更新关闭
        Value mask = createMask(bodyBuilder, loc, elementType, zeroI32);
        // 向量类型：<lanes x elemType>（如 <128 x f16>）
        VectorType vectorType = VectorType::get({lanes}, elementType);

        // index 类型常量（循环边界和步长用）
        Value zero = arith::ConstantIndexOp::create(bodyBuilder, loc, 0);
        Value one = arith::ConstantIndexOp::create(bodyBuilder, loc, 1);
        Value passUpper =
            arith::ConstantIndexOp::create(bodyBuilder, loc, numPasses);
        Value rowUpper =
            arith::ConstantIndexOp::create(bodyBuilder, loc, rows);
        Value colsValue =
            arith::ConstantIndexOp::create(bodyBuilder, loc, cols);
        Value lanesValue =
            arith::ConstantIndexOp::create(bodyBuilder, loc, lanes);
        // passStride = (rows + 1) * lanes —— 目的里每个 pass 的间距
        // （含 bank 交错洞：rows+1 而非 rows）
        Value passStride = arith::ConstantIndexOp::create(bodyBuilder, loc,
                                                          (rows + 1) * lanes);
        // rowStride = elementsPerBlock —— 目的里每行的间距
        // （每行写一个 32B 块 = elementsPerBlock 个元素）
        Value rowStride =
            arith::ConstantIndexOp::create(bodyBuilder, loc, elementsPerBlock);

        // 把源和目的都展平成 1D（方便用线性偏移访问）
        Value flatSrc = flattenStaticMemref(bodyBuilder, loc, src);
        Value flatDst = flattenStaticMemref(bodyBuilder, loc, dst);

        // 外层循环：遍历 numPasses 个列段
        auto passLoop =
            scf::ForOp::create(bodyBuilder, loc, zero, passUpper, one);
        OpBuilder passBuilder = OpBuilder::atBlockBegin(passLoop.getBody());
        Value pass = passLoop.getInductionVar();    // pass = 当前列段索引

        // 内层循环：遍历 rows 行
        auto rowLoop =
            scf::ForOp::create(passBuilder, loc, zero, rowUpper, one);
        OpBuilder rowBuilder = OpBuilder::atBlockBegin(rowLoop.getBody());
        Value row = rowLoop.getInductionVar();      // row = 当前行索引

        // ---- 源偏移计算 ----
        // srcOffset = row * cols + pass * lanes
        // （行优先寻址：先跳到第 row 行，再跳到第 pass 个列段）
        Value srcRowOffset =
            arith::MulIOp::create(rowBuilder, loc, row, colsValue);
        Value srcPassOffset =
            arith::MulIOp::create(rowBuilder, loc, pass, lanesValue);
        Value srcOffset =
            arith::AddIOp::create(rowBuilder, loc, srcRowOffset, srcPassOffset);
        // 从展平的源里截取 [srcOffset, srcOffset + lanes) 的一段
        Value srcTile =
            createDynamicLinearTile(rowBuilder, loc, flatSrc, srcOffset, lanes);
        // 向量加载：vld 从 UB 读 lanes 个元素到向量寄存器
        Value loaded = createVectorLoad(rowBuilder, loc, srcTile, vectorType,
                                        zeroI32, zeroI32);

        // ---- 目的偏移计算 ----
        // dstOffset = pass * passStride + row * rowStride
        //   passStride = (rows+1) * lanes（每个 pass 的目的间距，含 bank 交错洞）
        //   rowStride = elementsPerBlock（每行写一个 32B 块）
        Value dstPassOffset =
            arith::MulIOp::create(rowBuilder, loc, pass, passStride);
        Value dstRowOffset =
            arith::MulIOp::create(rowBuilder, loc, row, rowStride);
        Value dstOffset =
            arith::AddIOp::create(rowBuilder, loc, dstPassOffset, dstRowOffset);
        // 从展平的目的里截取 [dstOffset, dstOffset + elementsPerBlock) 的一段
        // 注意：目的 tile 大小 = elementsPerBlock（一个 32B 块），
        //       但写入的数据是 lanes 个元素（256B = 8 个 32B 块）。
        //       vsstb 会自动把 256B 数据按 strideConfig 散布成 8 个 32B 块。
        Value dstTile = createDynamicLinearTile(rowBuilder, loc, flatDst,
                                                dstOffset, elementsPerBlock);
        // 向量散布存储：vsstb 把 256B 数据拆成 8 个 32B 块，
        // 按 (rows+1) 个 32B 块的间隔散布到 UB 的不同 bank
        createVsstb(rowBuilder, loc, loaded, dstTile, stride, zeroI32, mask);
        return success();
      });
}

// ---------------------------------------------------------------------------
// Pattern 类：Nd2nzScatterOpLowering
// 标准的 OpRewritePattern，匹配 Nd2nzScatterOp 并委托给 lowerNd2nzScatter
// ---------------------------------------------------------------------------
class Nd2nzScatterOpLowering : public OpRewritePattern<npu::Nd2nzScatterOp> {
public:
  Nd2nzScatterOpLowering(MLIRContext *context, const HardwareConfig &config)
      : OpRewritePattern(context), config(config) {}

  LogicalResult matchAndRewrite(npu::Nd2nzScatterOp operation,
                                PatternRewriter &rewriter) const override {
    return lowerNd2nzScatter(operation, rewriter, config);
  }

private:
  const HardwareConfig &config;
};

} // namespace

// ---------------------------------------------------------------------------
// 公开接口：populateNd2nzScatterLoweringPatterns
// 注册 lowering pattern 到 RewritePatternSet，供 NpuToCCE pass 调用
// ---------------------------------------------------------------------------
void populateNd2nzScatterLoweringPatterns(RewritePatternSet &patterns,
                                          const HardwareConfig &config) {
  patterns.add<Nd2nzScatterOpLowering>(patterns.getContext(), config);
}

} // namespace mlir::npu

// ============================================================================
// 完整执行流程
// ============================================================================
//
// 输入 IR（ExpandUbToL1Nd2nz pass 产出）：
//   %ub_data : memref<M×Nxf16, UB>     （ND 布局，2D）
//   %scratch : memref<(M+1)*Nxf16, UB> （NZ scratch，1D，含 bank 交错洞）
//   npu.nd2nz_scatter %ub_data → %scratch
//
// 降级后 IR：
//   emitInVectorScope {                              // AIV 向量 scope
//     %flat_src = reinterpret_cast %ub_data to 1D   // 展平源
//     %flat_dst = reinterpret_cast %scratch to 1D    // 展平目的
//     scf.for %pass = 0 to numPasses {               // 外层：列段循环
//       scf.for %row = 0 to rows {                   // 内层：行循环
//         %src_off = %row * cols + %pass * lanes     // 源偏移
//         %src_tile = reinterpret_cast %flat_src[%src_off : lanes]
//         %loaded = cce.vld %src_tile                 // 向量加载 256B
//         %dst_off = %pass * (rows+1)*lanes + %row * elemsPerBlock
//         %dst_tile = reinterpret_cast %flat_dst[%dst_off : elemsPerBlock]
//         cce.vsstb %loaded, %dst_tile, strideConfig, 0, mask  // 散布存储
//       }
//     }
//   }
//
// 后续：linear_transfer copy 把 scratch（已是 NZ）线性搬运到 L1
// ============================================================================

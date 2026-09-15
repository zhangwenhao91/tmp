//===- ExpandUbToL1Nd2nz.cpp - Expand UB-to-L1 ND-to-NZ copy ------------===//
//
// 文件作用：把 npu.copy(UB->L1) 这条单条 ND->NZ 搬运指令，展开成两步：
//   1. Nd2nzScatterOp 在 UB 内做 ND->NZ 重排到临时 buffer
//   2. 带有 linear_transfer 标记的线性搬运到 L1
// 属于 NPU dialect 层的 pass（在 NpuToCCE lowering 之前跑）
//
// OpenTileAS compiler project
//
//===----------------------------------------------------------------------===//

// NPU dialect 的 op 定义（CopyOp, Nd2nzScatterOp 等）
#include "Dialect/Npu/IR/NPU.h"
// NPU pass 基类声明
#include "Dialect/Npu/Transforms/Passes.h"

// memref::AllocOp（分配临时 buffer 用）
#include "mlir/Dialect/MemRef/IR/MemRef.h"
// ModuleOp（pass 入口）
#include "mlir/IR/BuiltinOps.h"
// OperationState（手动构造新 op 用）
#include "mlir/IR/OperationSupport.h"
// OpRewritePattern（重写 pattern 基类）
#include "mlir/IR/PatternMatch.h"
// Pass 基类
#include "mlir/Pass/Pass.h"
// applyPatternsGreedily（贪心 pattern 执行器）
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

// std::optional（getSpace 返回类型）
#include <optional>

// 从 tablegen 自动生成的代码里导入 ExpandUbToL1Nd2nzBase 基类
// GEN_PASS_DEF_ 是固定前缀，后面跟 pass 名大写
#define GEN_PASS_DEF_EXPANDUBTOL1ND2NZ
#include "Dialect/Npu/Transforms/Passes.h.inc"

using namespace mlir;

namespace mlir::npu {
namespace {

// ---------------------------------------------------------------------------
// getSpace: 取一个 Value 的地址空间（GM=1, L1=2, UB=6 等）
// 拿不到返回 nullopt。支持两种 memory space 格式：
//   1. NPU 自定义的 AddressSpaceAttr（枚举类型）
//   2. 裸 IntegerAttr（整数 1=GM, 2=L1, 6=UB）
// ---------------------------------------------------------------------------
static std::optional<AddressSpace> getSpace(Value value) {
  // 先尝试转成 MemRefType（只有 memref 才有地址空间概念）
  auto type = dyn_cast<MemRefType>(value.getType());
  if (!type)
    return std::nullopt;                  // 不是 memref（比如 tensor），不处理

  // 取 memref 的 memory space 属性
  Attribute space = type.getMemorySpace();

  // 形式1：NPU 自定义的 AddressSpaceAttr（枚举类型 GM/L1/UB/...）
  if (auto npuSpace = dyn_cast_or_null<AddressSpaceAttr>(space))
    return npuSpace.getAddressSpace();

  // 形式2：裸整数（1=GM, 2=L1, 6=UB），强转成枚举
  if (auto integerSpace = dyn_cast_or_null<IntegerAttr>(space))
    return static_cast<AddressSpace>(integerSpace.getInt());

  // 两种都不是，返回空
  return std::nullopt;
}

// ---------------------------------------------------------------------------
// getElementBytes: 返回元素字节大小
//   f16/bf16 -> 2 字节
//   f32      -> 4 字节
//   其他     -> 0（不支持，调用方会报错拒绝）
// ---------------------------------------------------------------------------
static int64_t getElementBytes(Type type) {
  if (type.isF16() || type.isBF16())
    return 2;                             // 半精度：2 字节
  if (type.isF32())
    return 4;                             // 单精度：4 字节
  return 0;                               // 不支持的其他类型
}

// ---------------------------------------------------------------------------
// isRowSplitAssemble: 判断这条 copy 是不是 CV12 行方向（M 轴）半块拼整块
//
// 8 个条件全部满足才返回 true：
//   1. 有 split_dim 属性且值为 0（0 = 行方向/M 轴切分）
//   2. 源是静态形状
//   3. 目的是静态形状
//   4. 源是 2D（rank=2）
//   5. 目的是 2D（rank=2）
//   6. 源行数 > 0（防退化）
//   7. 源行数 * 2 == 目的行数（半块拼成整块，CV12 的核心）
//   8. 列数不变（只按行切，不按列切）
// ---------------------------------------------------------------------------
static bool isRowSplitAssemble(CopyOp copy, MemRefType srcType,
                               MemRefType dstType) {
  // 取 split_dim 属性，没有就是 nullptr
  IntegerAttr split = copy.getSplitDimAttr();

  // 条件1-8 全部 and 起来
  return split && split.getInt() == 0 && srcType.hasStaticShape() &&
         dstType.hasStaticShape() && srcType.getRank() == 2 &&
         dstType.getRank() == 2 && srcType.getDimSize(0) > 0 &&
         srcType.getDimSize(0) * 2 == dstType.getDimSize(0) &&
         srcType.getDimSize(1) == dstType.getDimSize(1);
}

// ===========================================================================
// ExpandUbToL1Nd2nzPattern: 核心重写 pattern
// 匹配 npu.copy op，只处理 UB->L1 方向的 ND->NZ 搬运
// ===========================================================================
class ExpandUbToL1Nd2nzPattern : public OpRewritePattern<CopyOp> {
public:
  // 继承基类构造函数
  using OpRewritePattern::OpRewritePattern;

  // MLIR pattern 标准接口：matchAndRewrite
  // copy = 匹配到的 op，rewriter = 用于构造新 IR 和删除旧 IR
  // 返回 success 表示改写成功，failure 表示不匹配
  LogicalResult matchAndRewrite(CopyOp copy,
                                PatternRewriter &rewriter) const override {

    // ---- 前置过滤：跳过已标记的线性搬运 ----
    // 如果 copy 已经带了 linear_transfer 属性，说明已经被这个 pass 展开过了
    // 第二次扫到时跳过，防止无限递归
    if (copy->hasAttr("linear_transfer"))
      return failure();

    // ---- 前置过滤：只处理 UB->L1 ----
    // 源必须是 UB（addrspace 6），目的必须是 L1（addrspace 2）
    // 其他方向的 copy 不归这个 pass 管
    if (getSpace(copy.getSrc()) != AddressSpace::UB ||
        getSpace(copy.getDst()) != AddressSpace::L1)
      return failure();

    // ---- 类型检查：源和目的都是 MemRefType ----
    auto srcType = dyn_cast<MemRefType>(copy.getSrc().getType());
    auto dstType = dyn_cast<MemRefType>(copy.getDst().getType());

    // 四个条件：
    //   - 源和目的都是 MemRefType（不能是 tensor）
    //   - 两者都是静态形状
    //   - 两者都是 2D（rank=2）
    if (!srcType || !dstType || !srcType.hasStaticShape() ||
        !dstType.hasStaticShape() || srcType.getRank() != 2 ||
        dstType.getRank() != 2)
      return failure();

    // ---- 取行列数 ----
    // 2D memref 的 dim(0)=行数 M，dim(1)=列数 N
    int64_t rows = srcType.getDimSize(0);   // 源行数 M
    int64_t cols = srcType.getDimSize(1);   // 源列数 N
    if (rows <= 0 || cols <= 0)
      return failure();                     // 防退化

    // ---- split_dim 分支 ----
    IntegerAttr split = copy.getSplitDimAttr();
    if (split) {
      // 有 split_dim -> 这是 CV12 半块搬运
      // 只处理"行方向半->整"的 split（split_dim=0）
      // 列切（split_dim=1）或其他形状不匹配的，本 pass 不处理，留给别的 lowering
      //
      // This path implements only the pre-sliced row half-to-full hardware
      // contract. In particular, an equal-shape copy carrying split_dim is
      // not silently converted into an invalid padded split copy.
      if (!isRowSplitAssemble(copy, srcType, dstType))
        return failure();
    } else if (srcType.getShape() != dstType.getShape()) {
      // 没有 split_dim 时，要求源和目的形状完全一样（普通整块 ND->NZ 搬运）
      // 形状不同又没 split 的，不处理
      return failure();
    }

    // ---- 元素类型检查 ----
    int64_t elementBytes = getElementBytes(srcType.getElementType());
    if (elementBytes == 0)
      // 只支持 f16/bf16/f32，其他类型报错
      return copy.emitOpError("unsupported element type for nd2nz expand");

    // 源和目的元素类型必须一致（不能 f16->f32 这种跨类型搬运）
    if (srcType.getElementType() != dstType.getElementType())
      return failure();

    // ---- 列对齐检查 ----
    // 256 是 NZ 大行（scatter 最小搬运对齐单元）的字节数
    // 除以每元素字节数得到每行可容纳的元素数 vectorLanes
    //   f16（2B）：256/2 = 128，列数必须是 128 的倍数
    //   f32（4B）：256/4 = 64，列数必须是 64 的倍数
    // 列数不整除 vectorLanes 时，scatter 没法对齐到完整的 NZ 大行，跳过
    int64_t vectorLanes = 256 / elementBytes;
    if (cols % vectorLanes != 0)
      return failure();

    // ==================== 开始展开 ====================

    Location loc = copy.getLoc();  // 取原 copy 的位置信息（调试用）

    // ---- 第一步：分配 UB scratch buffer ----
    // 构造一个 1D memref 类型：
    //   形状 = (rows + 1) * cols  <- 多一行是 UB bank 交错布局的一部分
    //   vsstb 按 (rows+1) 个 32B 块的间隔散布 8 个块，+1 让相邻块
    //   落在不同 UB bank（避免 bank 冲突）；写入恰好铺满 (rows+1)*cols，
    //   每 pass 留 8 个 32B 的洞（交错间隔本身）
    //   元素类型同源
    //   布局 = 默认（连续）
    //   地址空间 = UB
    auto scratchType = MemRefType::get(
        {(rows + 1) * cols}, srcType.getElementType(),
        MemRefLayoutAttrInterface{},
        AddressSpaceAttr::get(rewriter.getContext(), AddressSpace::UB));

    // 在 IR 里插入一条 memref.alloc，分配这个 scratch buffer
    auto scratch = memref::AllocOp::create(rewriter, loc, scratchType);

    // 给 alloc 打上 npu.mem_unique 属性
    // 告诉后续内存规划 pass：这个 buffer 不可和其他 buffer 复用同一块地址
    // （因为 scatter 写入的 NZ 布局有 stride，复用会出错）
    scratch->setAttr("npu.mem_unique",
                     NpuMemoryUniqueAttr::get(rewriter.getContext()));

    // ---- 第二步：生成 Nd2nzScatterOp（整个 pass 的核心）----
    // 把原 UB 数据（ND 布局）重排成 NZ 布局，写到 scratch buffer 里
    //   目的 = 刚分配的 scratch buffer
    //   源   = 原 copy 的 UB 输入
    auto scatter = Nd2nzScatterOp::create(rewriter, loc, scratch.getResult(),
                                          copy.getSrc());

    // 把原 copy 上的 tcore_type（核类型标记：AIC/AIV）和 tiled_op（分块标记）
    // 属性传给 scatter，保持语义一致
    for (StringRef name : {"tcore_type", "tiled_op"})
      if (Attribute attr = copy->getAttr(name))
        scatter->setAttr(name, attr);

    // ---- 第三步：生成线性搬运替换原 copy ----
    // 新 copy 的源是 1D 的 NZ scratch buffer（不是原来的 2D ND tile）
    // 需要先设好属性才能通过 verifier
    //
    // Add verifier-significant attributes before creating the replacement
    // op: its source is rank-1 padded NZ storage rather than the original ND
    // rank-2 tile.
    OperationState state(loc, CopyOp::getOperationName());

    // 调用 CopyOp::build：
    //   目的 = 原 copy 的目的（L1）
    //   源   = scratch buffer（UB，已是 NZ 布局）
    //   Transposed = 空（不转置）
    //   split = 原 copy 的 split_dim（CV12 半块拼整的标记传下去）
    CopyOp::build(rewriter, state, copy.getDst(), scratch.getResult(),
                  /*Transposed=*/BoolAttr(), split);

    // 关键：加 linear_transfer 标记
    // 告诉后续 lowering：这条 copy 的源已经是 NZ 布局了，直接走线性搬运
    // （mov.ub.to.l1.v310 的 linear burst 模式），不要再做 ND2NZ
    state.addAttribute("linear_transfer", rewriter.getUnitAttr());

    // 把原 copy 上的其他属性复制到新 copy 上
    // 但跳过 4 个已手动设置的属性（Transposed/transposed/split_dim/linear_transfer）
    // 且不覆盖已有的
    for (NamedAttribute attr : copy->getAttrs()) {
      StringRef name = attr.getName().strref();
      if (name == "Transposed" || name == "transposed" || name == "split_dim" ||
          name == "linear_transfer")
        continue;
      if (!state.attributes.get(name))
        state.addAttribute(attr.getName(), attr.getValue());
    }

    // 在 IR 中插入新 copy
    rewriter.create(state);

    // 删除原 copy，返回成功
    // 一条 ND2NZ copy 被展开成了两步：scatter + linear copy
    rewriter.eraseOp(copy);
    return success();
  }
};

// ===========================================================================
// ExpandUbToL1Nd2nzPass: Pass 类
// 标准的 MLIR pass 模板，贪心驱动 pattern 重写
// 在 pass 管线里用 --npu-expand-ub-to-l1-nd2nz 调用
// ===========================================================================
class ExpandUbToL1Nd2nzPass
    : public ::impl::ExpandUbToL1Nd2nzBase<ExpandUbToL1Nd2nzPass> {
public:
  void runOnOperation() override {
    // 创建 pattern 集合
    RewritePatternSet patterns(&getContext());
    // 注册上面的 ExpandUbToL1Nd2nzPattern
    patterns.add<ExpandUbToL1Nd2nzPattern>(&getContext());
    // 对当前操作（通常是 ModuleOp）贪心执行所有 pattern
    if (failed(applyPatternsGreedily(getOperation(), std::move(patterns))))
      signalPassFailure();
  }
};

} // namespace

// ---------------------------------------------------------------------------
// 工厂函数：外部注册 pass 时调用
// 返回 pass 实例，在 pass 管线里用 --npu-expand-ub-to-l1-nd2nz 调用
// ---------------------------------------------------------------------------
std::unique_ptr<Pass> createExpandUbToL1Nd2nzPass() {
  return std::make_unique<ExpandUbToL1Nd2nzPass>();
}

} // namespace mlir::npu

// =============================================================================
// 完整执行流程示意：
//
// 输入 IR:
//   %ub_data : memref<MxNxf16, UB>  (ND 布局)
//   %l1_buf  : memref<MxNxf16, L1>  (NZ 布局)
//   npu.copy %ub_data -> %l1_buf     (要 ND->NZ 重排)
//
//         ↓ pass 执行后
//
// 输出 IR:
//   %scratch : memref<(M+1)xNxf16, UB>  (临时 NZ buffer，含 bank 交错洞)
//   %ub_data : memref<MxNxf16, UB>       (原数据不变)
//   npu.nd2nz_scatter %ub_data -> %scratch (在 UB 内做 ND->NZ 重排)
//   npu.copy %scratch -> %l1_buf           (linear_transfer，线性搬运，不再重排)
//
// 步骤说明：
//   1. alloc scratch    分配 UB 临时空间（NZ 重排需要中间 buffer）
//   2. Nd2nzScatterOp   ND->NZ 重排（在 UB 内完成布局转换）
//   3. copy+linear      线性搬运到 L1（源已是 NZ，直接搬不需再重排）
//   4. (rows+1)*cols   UB bank 交错布局（防 bank 冲突），写入恰好铺满
// =============================================================================

//===- ExpandUbToL1Nd2nz.cpp - Expand UB-to-L1 ND-to-NZ copy ------------===//
//
// OpenTileAS compiler project
//
//===----------------------------------------------------------------------===//

#include "Dialect/Npu/IR/NPU.h"
#include "Dialect/Npu/Transforms/Passes.h"

#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/OperationSupport.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include <optional>

#define GEN_PASS_DEF_EXPANDUBTOL1ND2NZ
#include "Dialect/Npu/Transforms/Passes.h.inc"

using namespace mlir;

namespace mlir::npu {
namespace {

static std::optional<AddressSpace> getSpace(Value value) {
  auto type = dyn_cast<MemRefType>(value.getType());
  if (!type)
    return std::nullopt;
  Attribute space = type.getMemorySpace();
  if (auto npuSpace = dyn_cast_or_null<AddressSpaceAttr>(space))
    return npuSpace.getAddressSpace();
  if (auto integerSpace = dyn_cast_or_null<IntegerAttr>(space))
    return static_cast<AddressSpace>(integerSpace.getInt());
  return std::nullopt;
}

static int64_t getElementBytes(Type type) {
  if (type.isF16() || type.isBF16())
    return 2;
  if (type.isF32())
    return 4;
  return 0;
}

static bool isRowSplitAssemble(CopyOp copy, MemRefType srcType,
                               MemRefType dstType) {
  IntegerAttr split = copy.getSplitDimAttr();
  return split && split.getInt() == 0 && srcType.hasStaticShape() &&
         dstType.hasStaticShape() && srcType.getRank() == 2 &&
         dstType.getRank() == 2 && srcType.getDimSize(0) > 0 &&
         srcType.getDimSize(0) * 2 == dstType.getDimSize(0) &&
         srcType.getDimSize(1) == dstType.getDimSize(1);
}

class ExpandUbToL1Nd2nzPattern : public OpRewritePattern<CopyOp> {
public:
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(CopyOp copy,
                                PatternRewriter &rewriter) const override {
    if (copy->hasAttr("linear_transfer"))
      return failure();
    if (getSpace(copy.getSrc()) != AddressSpace::UB ||
        getSpace(copy.getDst()) != AddressSpace::L1)
      return failure();

    auto srcType = dyn_cast<MemRefType>(copy.getSrc().getType());
    auto dstType = dyn_cast<MemRefType>(copy.getDst().getType());
    if (!srcType || !dstType || !srcType.hasStaticShape() ||
        !dstType.hasStaticShape() || srcType.getRank() != 2 ||
        dstType.getRank() != 2)
      return failure();

    int64_t rows = srcType.getDimSize(0);
    int64_t cols = srcType.getDimSize(1);
    if (rows <= 0 || cols <= 0)
      return failure();

    IntegerAttr split = copy.getSplitDimAttr();
    if (split) {
      // This path implements only the pre-sliced row half-to-full hardware
      // contract. In particular, an equal-shape copy carrying split_dim is
      // not silently converted into an invalid padded split copy.
      if (!isRowSplitAssemble(copy, srcType, dstType))
        return failure();
    } else if (srcType.getShape() != dstType.getShape()) {
      return failure();
    }

    int64_t elementBytes = getElementBytes(srcType.getElementType());
    if (elementBytes == 0)
      return copy.emitOpError("unsupported element type for nd2nz expand");
    if (srcType.getElementType() != dstType.getElementType())
      return failure();

    int64_t vectorLanes = 256 / elementBytes;
    if (cols % vectorLanes != 0)
      return failure();

    Location loc = copy.getLoc();
    auto scratchType = MemRefType::get(
        {(rows + 1) * cols}, srcType.getElementType(),
        MemRefLayoutAttrInterface{},
        AddressSpaceAttr::get(rewriter.getContext(), AddressSpace::UB));
    auto scratch = memref::AllocOp::create(rewriter, loc, scratchType);
    scratch->setAttr("npu.mem_unique",
                     NpuMemoryUniqueAttr::get(rewriter.getContext()));

    auto scatter = Nd2nzScatterOp::create(rewriter, loc, scratch.getResult(),
                                          copy.getSrc());
    for (StringRef name : {"tcore_type", "tiled_op"})
      if (Attribute attr = copy->getAttr(name))
        scatter->setAttr(name, attr);

    // Add verifier-significant attributes before creating the replacement
    // op: its source is rank-1 padded NZ storage rather than the original ND
    // rank-2 tile.
    OperationState state(loc, CopyOp::getOperationName());
    CopyOp::build(rewriter, state, copy.getDst(), scratch.getResult(),
                  /*Transposed=*/BoolAttr(), split);
    state.addAttribute("linear_transfer", rewriter.getUnitAttr());
    for (NamedAttribute attr : copy->getAttrs()) {
      StringRef name = attr.getName().strref();
      if (name == "Transposed" || name == "transposed" || name == "split_dim" ||
          name == "linear_transfer")
        continue;
      if (!state.attributes.get(name))
        state.addAttribute(attr.getName(), attr.getValue());
    }
    rewriter.create(state);
    rewriter.eraseOp(copy);
    return success();
  }
};

class ExpandUbToL1Nd2nzPass
    : public ::impl::ExpandUbToL1Nd2nzBase<ExpandUbToL1Nd2nzPass> {
public:
  void runOnOperation() override {
    RewritePatternSet patterns(&getContext());
    patterns.add<ExpandUbToL1Nd2nzPattern>(&getContext());
    if (failed(applyPatternsGreedily(getOperation(), std::move(patterns))))
      signalPassFailure();
  }
};

} // namespace

std::unique_ptr<Pass> createExpandUbToL1Nd2nzPass() {
  return std::make_unique<ExpandUbToL1Nd2nzPass>();
}

} // namespace mlir::npu

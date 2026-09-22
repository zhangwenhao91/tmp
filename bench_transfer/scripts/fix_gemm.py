# -*- coding: utf-8 -*-
import pathlib

P = pathlib.Path(
    "/home/z30086261/tilelang-ascend-private/OpenTileAS/lib/Conversion/TilelangToNpu/TilelangToNPUGemm.cpp"
)
s = P.read_text(encoding="utf-8")

ARROW = "\u2192"

# 1) input address-space check: only L1 is accepted (catlass mad_l1)
old1 = (
    "  if ((*aSpace != npu::AddressSpace::L1 && *aSpace != npu::AddressSpace::L0A) ||\n"
    "      (*bSpace != npu::AddressSpace::L1 && *bSpace != npu::AddressSpace::L0B))\n"
    '    return op.emitError("gemm inputs must reside in cbuf (L1) or already be "\n'
    '                        "in L0A/L0B; found ")\n'
    '           << npu::stringifyAddressSpace(*aSpace) << " and "\n'
    "           << npu::stringifyAddressSpace(*bSpace);"
)
new1 = (
    "  if (*aSpace != npu::AddressSpace::L1 || *bSpace != npu::AddressSpace::L1)\n"
    '    return op.emitError("catlass mad_l1 requires both gemm inputs in L1 "\n'
    '                        "(cbuf); found ")\n'
    '           << npu::stringifyAddressSpace(*aSpace) << " and "\n'
    "           << npu::stringifyAddressSpace(*bSpace);"
)

# 2) drop now-unused ctx
old2 = (
    "  Location loc = op.getLoc();\n"
    "  MLIRContext *ctx = rewriter.getContext();\n"
    "  rewriter.setInsertionPoint(op);"
)
new2 = (
    "  Location loc = op.getLoc();\n"
    "  rewriter.setInsertionPoint(op);"
)

# 3) replace L1->L0A/L0B staging + npu.mad with npu.mad_l1
old3 = (
    "  // ---- src0: reuse if already in L0A, else stage L1 " + ARROW + " L0A ----\n"
    "  // The hardware performs the transpose during the L0A load; the mad operand\n"
    "  // keeps the physical shape and the copy carries Transposed = transpose_a.\n"
    "  Value l0a = op.getA();\n"
    "  if (*aSpace == npu::AddressSpace::L1) {\n"
    "    auto l0aAttr = npu::AddressSpaceAttr::get(ctx, npu::AddressSpace::L0A);\n"
    "    auto l0aType = MemRefType::get(aType.getShape(), aType.getElementType(),\n"
    "                                   aType.getLayout(), l0aAttr);\n"
    "    Value l0aAlloc = memref::AllocOp::create(rewriter, loc, l0aType);\n"
    "    npu::CopyOp::create(rewriter, loc, l0aAlloc, op.getA(),\n"
    "                        transposeA ? rewriter.getBoolAttr(true) : BoolAttr());\n"
    "    l0a = l0aAlloc;\n"
    "  }\n"
    "\n"
    "  // ---- src1: reuse if already in L0B, else stage L1 " + ARROW + " L0B ----\n"
    "  Value l0b = op.getB();\n"
    "  if (*bSpace == npu::AddressSpace::L1) {\n"
    "    auto l0bAttr = npu::AddressSpaceAttr::get(ctx, npu::AddressSpace::L0B);\n"
    "    auto l0bType = MemRefType::get(bType.getShape(), bType.getElementType(),\n"
    "                                   bType.getLayout(), l0bAttr);\n"
    "    Value l0bAlloc = memref::AllocOp::create(rewriter, loc, l0bType);\n"
    "    npu::CopyOp::create(rewriter, loc, l0bAlloc, op.getB(),\n"
    "                        transposeB ? rewriter.getBoolAttr(true) : BoolAttr());\n"
    "    l0b = l0bAlloc;\n"
    "  }\n"
    "\n"
    "  // ---- mad ----\n"
    "  auto mad = npu::MadOp::create(rewriter, loc, TypeRange{}, madDst, l0a, l0b,\n"
    "                                transposeA, transposeB, zeroInit);"
)
new3 = (
    "  // ---- mad_l1 (catlass-style) ----\n"
    "  // A/B stay in L1; the L1" + ARROW + "L0A/L0B transfer is Catlass-internal. A plain\n"
    "  // npu.mad with explicit L0A/L0B operands would force split-mix-kernel to\n"
    "  // insert a cross-core L0A/L0B" + ARROW + "L1 back-copy (write-only cube resources have\n"
    "  // no read-back pipe mapping), which breaks plan-memory for MIX kernels.\n"
    "  IntegerAttr noEvent;\n"
    "  auto madL1 = rewriter.create<npu::MadL1Op>(\n"
    "      loc, TypeRange{}, madDst, op.getA(), op.getB(),\n"
    "      /*l1bias=*/Value(), transposeA, transposeB, zeroInit,\n"
    "      /*unit_flag=*/0,\n"
    "      /*wait_l1_ready_event_a=*/noEvent,\n"
    "      /*wait_l1_ready_event_b=*/noEvent,\n"
    "      /*l1a_recycle_event=*/noEvent,\n"
    "      /*l1b_recycle_event=*/noEvent,\n"
    "      /*kloop_db_cond=*/rewriter.getI64IntegerAttr(k),\n"
    "      /*l0_db_event0=*/noEvent,\n"
    "      /*l0_db_event1=*/noEvent);"
)

# 4) accumulator-group tag references the new op name
old4 = (
    "  // Loop-carried L0C accumulation: tag the accumulator group so that\n"
    "  // NpuToCCE::lowerMad emits the loop-entry barrier, keeping the next\n"
    "  // iteration's L0A/L0B copies from overwriting operands the previous\n"
    "  // iteration's mad is still reading.\n"
    "  if (!zeroInit && op->getParentOfType<scf::ForOp>())\n"
    "    mad->setAttr(kMadAccumulatorGroupAttr,\n"
    "                 rewriter.getI64IntegerAttr(nextMadAccumulatorGroupId++));"
)
new4 = (
    "  // Loop-carried L0C accumulation is Catlass-internal for mad_l1; keep the\n"
    "  // accumulator-group tag only for the (currently unused) plain-mad fallback.\n"
    "  if (!zeroInit && op->getParentOfType<scf::ForOp>())\n"
    "    madL1->setAttr(kMadAccumulatorGroupAttr,\n"
    "                   rewriter.getI64IntegerAttr(nextMadAccumulatorGroupId++));"
)

for name, old, new in (
    ("old1", old1, new1),
    ("old2", old2, new2),
    ("old3", old3, new3),
    ("old4", old4, new4),
):
    cnt = s.count(old)
    if cnt != 1:
        raise SystemExit(f"[FAIL] {name}: count={cnt} (expected 1)")
    s = s.replace(old, new)

P.write_text(s, encoding="utf-8")
print("[OK] TilelangToNPUGemm.cpp patched")
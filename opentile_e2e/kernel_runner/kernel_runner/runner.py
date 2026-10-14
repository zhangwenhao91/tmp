from __future__ import annotations

import argparse
import importlib.util
import inspect
import json
from contextlib import suppress
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import numpy as np

from . import _ascend_runtime as rt


POINTER_KINDS = {"input", "output", "input_output"}
SCALAR_DTYPES = {
    "int8",
    "uint8",
    "int16",
    "uint16",
    "int32",
    "uint32",
    "int64",
    "uint64",
    "float32",
    "float64",
}


@dataclass
class DeviceAllocation:
    ptr: int
    nbytes: int


def _resolve_path(path: str | Path, base: Path | None) -> Path:
    value = Path(path)
    if value.is_absolute() or base is None:
        return value
    return base / value


def _load_config(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def _as_contiguous(array: np.ndarray, dtype: str | None) -> np.ndarray:
    if dtype is not None:
        array = array.astype(np.dtype(dtype), copy=False)
    return np.ascontiguousarray(array)


def _empty_output(spec: dict[str, Any]) -> np.ndarray:
    if "shape" not in spec:
        raise ValueError(f"output arg {spec.get('name', '<unnamed>')} needs shape")
    if "dtype" not in spec:
        raise ValueError(f"output arg {spec.get('name', '<unnamed>')} needs dtype")
    return np.empty(tuple(spec["shape"]), dtype=np.dtype(spec["dtype"]))


def _generated_input(spec: dict[str, Any]) -> np.ndarray:
    if "shape" not in spec:
        raise ValueError(f"generated input arg {spec.get('name', '<unnamed>')} needs shape")
    if "dtype" not in spec:
        raise ValueError(f"generated input arg {spec.get('name', '<unnamed>')} needs dtype")

    shape = tuple(spec["shape"])
    dtype = np.dtype(spec["dtype"])
    mode = spec.get("generate", "random")

    if "fill_value" in spec:
        return np.full(shape, spec["fill_value"], dtype=dtype)
    if mode == "zeros":
        return np.zeros(shape, dtype=dtype)
    if mode == "ones":
        return np.ones(shape, dtype=dtype)
    if mode == "arange":
        return np.arange(np.prod(shape), dtype=dtype).reshape(shape)
    if mode == "random":
        rng = np.random.default_rng(spec["seed"] if "seed" in spec else None)
        if np.issubdtype(dtype, np.floating):
            if dtype == np.dtype("float16"):
                return rng.random(shape, dtype=np.float32).astype(dtype)
            return rng.random(shape, dtype=dtype)
        if np.issubdtype(dtype, np.integer):
            low = int(spec.get("low", 0))
            high = int(spec.get("high", 10))
            return rng.integers(low, high, size=shape, dtype=dtype)
        if np.issubdtype(dtype, np.bool_):
            return rng.integers(0, 2, size=shape).astype(dtype)
    raise ValueError(f"unsupported generate mode {mode!r}")


def _default_arg_path(spec: dict[str, Any], suffix: str = ".npy") -> str:
    return f"{spec.get('name', 'input')}{suffix}"


def _scalar_value(spec: dict[str, Any]) -> tuple[str, Any]:
    dtype = spec.get("dtype")
    if dtype not in SCALAR_DTYPES:
        raise ValueError(f"unsupported scalar dtype {dtype!r}; supported: {sorted(SCALAR_DTYPES)}")
    if "value" not in spec:
        raise ValueError(f"scalar arg {spec.get('name', '<unnamed>')} needs value")
    value = spec["value"]
    if dtype.startswith("float"):
        return dtype, float(value)
    return dtype, int(value)


def _allocate_and_upload(spec: dict[str, Any], base_dir: Path | None) -> tuple[np.ndarray, DeviceAllocation]:
    kind = spec["kind"]
    if kind == "output" and "path" not in spec:
        array = _empty_output(spec)
    elif kind == "output" and "initialize" not in spec:
        array = _empty_output(spec)
    elif "path" not in spec:
        array = _generated_input(spec)
        if spec.get("save_generated", True):
            generated_path = _resolve_path(_default_arg_path(spec), base_dir)
            generated_path.parent.mkdir(parents=True, exist_ok=True)
            np.save(generated_path, array)
    else:
        input_path = _resolve_path(spec["path"], base_dir)
        array = np.load(input_path)
        array = _as_contiguous(array, spec.get("dtype"))

    alloc = DeviceAllocation(rt.malloc_device(array.nbytes), array.nbytes)
    if kind in {"input", "input_output"} or spec.get("initialize", False):
        rt.memcpy_h2d(alloc.ptr, array.tobytes(order="C"))
    return array, alloc


def _save_output(path: Path, ptr: int, template: np.ndarray) -> None:
    raw = rt.memcpy_d2h(ptr, template.nbytes)
    output = np.frombuffer(raw, dtype=template.dtype).reshape(template.shape).copy()
    path.parent.mkdir(parents=True, exist_ok=True)
    np.save(path, output)


def _load_golden_function(spec: dict[str, Any], base_dir: Path):
    module_path = spec.get("module_path")
    function_name = spec.get("function")
    if not module_path:
        raise ValueError("golden.module_path is required")
    if not function_name:
        raise ValueError("golden.function is required")

    path = _resolve_path(module_path, base_dir)
    module_name = f"_kernel_runner_golden_{path.stem}"
    module_spec = importlib.util.spec_from_file_location(module_name, path)
    if module_spec is None or module_spec.loader is None:
        raise RuntimeError(f"failed to load golden module from {path}")
    module = importlib.util.module_from_spec(module_spec)
    module_spec.loader.exec_module(module)

    fn = getattr(module, function_name, None)
    if fn is None or not callable(fn):
        raise RuntimeError(f"golden function {function_name!r} not found in {path}")
    return fn


def _to_numpy(value: Any) -> np.ndarray:
    if isinstance(value, np.ndarray):
        return value
    if hasattr(value, "detach"):
        value = value.detach()
    if hasattr(value, "cpu"):
        value = value.cpu()
    if hasattr(value, "numpy"):
        return value.numpy()
    return np.asarray(value)


def _call_with_named_args(fn, values: dict[str, Any]) -> Any:
    signature = inspect.signature(fn)
    if any(param.kind == inspect.Parameter.VAR_KEYWORD for param in signature.parameters.values()):
        return fn(**values)
    accepted = {
        name: values[name]
        for name in signature.parameters
        if name in values
    }
    return fn(**accepted)


def _save_golden_outputs(result: Any, output_base: Path) -> dict[str, Path]:
    output_base.mkdir(parents=True, exist_ok=True)
    saved: dict[str, Path] = {}
    if isinstance(result, dict):
        for name, value in result.items():
            path = output_base / f"golden_{name}.npy"
            np.save(path, _to_numpy(value))
            print_npy(path)
            saved[f"golden_{name}"] = path
        return saved

    path = output_base / "golden.npy"
    np.save(path, _to_numpy(result))
    print_npy(path)
    saved["golden"] = path
    return saved


def _run_golden_if_configured(
    config: dict[str, Any],
    config_dir: Path,
    output_base: Path,
    values: dict[str, Any],
) -> dict[str, Path]:
    golden_spec = config.get("golden")
    if not golden_spec:
        return {}

    import torch

    fn = _load_golden_function(golden_spec, config_dir)
    torch_values: dict[str, Any] = {}
    for name, value in values.items():
        if isinstance(value, np.ndarray):
            torch_values[name] = torch.from_numpy(value)
        else:
            torch_values[name] = value
    result = _call_with_named_args(fn, torch_values)
    golden_dir = _resolve_path(golden_spec.get("output_dir", "."), output_base)
    return _save_golden_outputs(result, golden_dir)


def _compare_with_golden_if_available(
    output_name: str,
    output_path: Path,
    golden_saved: dict[str, Path],
    golden_spec: dict[str, Any],
    output_count: int,
) -> None:
    golden_path = golden_saved.get(f"golden_{output_name}")
    if golden_path is None and output_count == 1:
        golden_path = golden_saved.get("golden")
    if golden_path is None:
        return

    compare_npy(
        output_path,
        golden_path,
        atol=float(golden_spec.get("atol", 1e-3)),
        rtol=float(golden_spec.get("rtol", 1e-3)),
        eps=float(golden_spec.get("eps", 1e-12)),
    )


def print_npy(array_or_path: np.ndarray | str | Path, count: int = 16, name: str | None = None) -> None:
    if isinstance(array_or_path, np.ndarray):
        array = array_or_path
        display_name = name or "<array>"
    else:
        path = Path(array_or_path)
        array = np.load(path)
        display_name = name or str(path)

    flat = np.ravel(array)
    head = flat[:count]
    tail = flat[-count:] if flat.size > count else flat
    mean = float(np.mean(flat)) if flat.size else float("nan")

    print(f"[npy-summary] {display_name}")
    print(f"  shape: {array.shape}, dtype: {array.dtype}, size: {flat.size}")
    print(f"  first {min(count, flat.size)}: {head}")
    print(f"  last {min(count, flat.size)}: {tail}")
    print(f"  mean: {mean}")

def compare_npy(
    actual_path: str | Path,
    expected_path: str | Path,
    *,
    atol: float = 1e-3,
    rtol: float = 1e-3,
    eps: float = 1e-12,
) -> dict[str, float]:
    actual = np.load(Path(actual_path))
    expected = np.load(Path(expected_path))
    if actual.shape != expected.shape:
        raise ValueError(f"shape mismatch: actual {actual.shape}, expected {expected.shape}")

    actual_flat = actual.astype(np.float64, copy=False).ravel()
    expected_flat = expected.astype(np.float64, copy=False).ravel()
    diff = actual_flat - expected_flat
    abs_error = np.abs(diff)
    rel_error = abs_error / np.maximum(np.abs(expected_flat), eps)

    actual_norm = np.linalg.norm(actual_flat)
    expected_norm = np.linalg.norm(expected_flat)
    if actual_flat.size == 0:
        cosine = float("nan")
    elif actual_norm <= eps and expected_norm <= eps:
        cosine = 1.0
    elif actual_norm <= eps or expected_norm <= eps:
        cosine = 0.0
    else:
        cosine = float(np.dot(actual_flat, expected_flat) / (actual_norm * expected_norm))

    abs_pass_ratio = float(np.mean(abs_error <= atol)) if abs_error.size else float("nan")
    rel_pass_ratio = float(np.mean(rel_error <= rtol)) if rel_error.size else float("nan")
    metrics = {
        "cosine_similarity": cosine,
        "abs_pass_ratio": abs_pass_ratio,
        "rel_pass_ratio": rel_pass_ratio,
        "max_abs_error": float(np.max(abs_error)) if abs_error.size else float("nan"),
        "mean_abs_error": float(np.mean(abs_error)) if abs_error.size else float("nan"),
        "max_rel_error": float(np.max(rel_error)) if rel_error.size else float("nan"),
        "mean_rel_error": float(np.mean(rel_error)) if rel_error.size else float("nan"),
    }

    print("[npy-compare]")
    print(f"  actual: {actual_path}")
    print(f"  expected: {expected_path}")
    print(f"  shape: {actual.shape}")
    print(f"  dtype: actual {actual.dtype}, expected {expected.dtype}")
    print(f"  cosine_similarity: {metrics['cosine_similarity']}")
    print(f"  abs_pass_ratio(atol={atol}): {metrics['abs_pass_ratio']:.6%}")
    print(f"  rel_pass_ratio(rtol={rtol}, eps={eps}): {metrics['rel_pass_ratio']:.6%}")
    print(f"  max_abs_error: {metrics['max_abs_error']}")
    print(f"  mean_abs_error: {metrics['mean_abs_error']}")
    print(f"  max_rel_error: {metrics['max_rel_error']}")
    print(f"  mean_rel_error: {metrics['mean_rel_error']}")
    return metrics


def run_from_config(
    config_path: str | Path,
    *,
    kernel_o: str | Path | None = None,
    input_dir: str | Path | None = None,
    output_dir: str | Path | None = None,
) -> dict[str, Path]:
    config_path = Path(config_path)
    config = _load_config(config_path)
    config_dir = config_path.parent

    kernel_path = Path(kernel_o) if kernel_o is not None else _resolve_path(config["kernel_o"], config_dir)
    input_base = Path(input_dir) if input_dir is not None else config_dir
    output_base = Path(output_dir) if output_dir is not None else config_dir

    device = int(config.get("device", 0))
    runtime_initialized = False
    rt.init_runtime(config.get("acl_config"))
    runtime_initialized = True
    rt.set_device(device)

    module_handle = None
    stream = 0
    allocations: list[DeviceAllocation] = []
    outputs: list[tuple[str, Path, DeviceAllocation, np.ndarray]] = []
    golden_values: dict[str, Any] = {}

    try:
        kernel_bytes = kernel_path.read_bytes()
        module_handle, function = rt.load_kernel(
            config["kernel_name"],
            kernel_bytes,
            device,
            config.get("mix_mode", "aic"),
        )
        _ = module_handle
        stream = rt.create_stream()

        blocknum = int(config.get("blocknum", 1))
        if blocknum <= 0:
            raise ValueError("blocknum must be a positive integer")

        kernel_args: list[tuple[str, Any]] = []
        for spec in config.get("args", []):
            kind = spec.get("kind")
            if kind in POINTER_KINDS:
                array, alloc = _allocate_and_upload(spec, input_base)
                allocations.append(alloc)
                kernel_args.append(("ptr", alloc.ptr))
                if kind in {"input", "input_output"}:
                    golden_values[spec["name"]] = array
                if kind in {"output", "input_output"}:
                    out_path = _resolve_path(spec.get("path", _default_arg_path(spec, ".npy")), output_base)
                    outputs.append((spec["name"], out_path, alloc, array))
            elif kind == "scalar":
                scalar_arg = _scalar_value(spec)
                kernel_args.append(scalar_arg)
                golden_values[spec["name"]] = scalar_arg[1]
            else:
                raise ValueError(f"unsupported arg kind {kind!r}")

        golden_saved = _run_golden_if_configured(config, config_dir, output_base, golden_values)

        print(f"[launch] kernel={config['kernel_name']} blocknum={blocknum}")
        rt.launch_kernel(
            func=function,
            stream=stream,
            blocknum=blocknum,
            kernel_args=kernel_args,
        )
        rt.synchronize_stream(stream)

        saved: dict[str, Path] = {}
        saved.update(golden_saved)
        golden_spec = config.get("golden") or {}
        for output_name, out_path, alloc, array in outputs:
            _save_output(out_path, alloc.ptr, array)
            print_npy(out_path)
            _compare_with_golden_if_available(output_name, out_path, golden_saved, golden_spec, len(outputs))
            saved[out_path.stem] = out_path
        return saved
    finally:
        if stream:
            with suppress(Exception):
                rt.destroy_stream(stream)
        for alloc in allocations:
            with suppress(Exception):
                rt.free_device(alloc.ptr)
        if module_handle is not None:
            with suppress(Exception):
                rt.unregister_kernel(module_handle)
        if runtime_initialized:
            with suppress(Exception):
                rt.finalize_runtime(device, int(config.get("reset_device", True)))


def main() -> None:
    parser = argparse.ArgumentParser(description="Run an Ascend kernel.o with npy inputs.")
    parser.add_argument("config", type=Path, nargs="?")
    parser.add_argument("--kernel-o", type=Path, default=None)
    parser.add_argument("--input-dir", type=Path, default=None)
    parser.add_argument("--output-dir", type=Path, default=None)
    parser.add_argument("--peek", type=Path, default=None, help="Only print an npy summary.")
    parser.add_argument("--count", type=int, default=16, help="Number of head/tail values to print.")
    parser.add_argument("--compare", nargs=2, metavar=("ACTUAL", "EXPECTED"), type=Path, default=None,
                        help="Only compare two npy files.")
    parser.add_argument("--atol", type=float, default=1e-3, help="Absolute error threshold for --compare.")
    parser.add_argument("--rtol", type=float, default=1e-3, help="Relative error threshold for --compare.")
    parser.add_argument("--eps", type=float, default=1e-12, help="Denominator epsilon for relative error.")
    args = parser.parse_args()

    if args.peek is not None:
        print_npy(args.peek, args.count)
        return
    if args.compare is not None:
        compare_npy(args.compare[0], args.compare[1], atol=args.atol, rtol=args.rtol, eps=args.eps)
        return
    if args.config is None:
        parser.error("config is required unless --peek or --compare is used")

    saved = run_from_config(
        args.config,
        kernel_o=args.kernel_o,
        input_dir=args.input_dir,
        output_dir=args.output_dir,
    )
    for name, path in saved.items():
        print(f"{name}: {path}")


if __name__ == "__main__":
    main()

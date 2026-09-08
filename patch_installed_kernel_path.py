#!/usr/bin/env python3
"""Patch KERNEL_PATH support into a pip-installed triton-opentile package.

Locates the install with `python -m pip show`. Run this with the same
interpreter that has triton-opentile (venv, conda, or system). Re-run is
idempotent. Use --restore to revert from `.bak` backups.

Examples:
  python patch_installed_kernel_path.py
  python patch_installed_kernel_path.py --python /path/to/venv/bin/python
  python patch_installed_kernel_path.py --conda-env tileir
  python patch_installed_kernel_path.py --restore
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path

PACKAGE_NAMES = ("triton-opentile", "triton")

CONF_HELPERS = '''
    @staticmethod
    def kernel_path():
        """Path to a precompiled NPU object that replaces the opentileas binary."""
        return os.getenv("KERNEL_PATH", "")

    @staticmethod
    def kernel_cv_mode():
        """Optional cv_mode override for KERNEL_PATH binaries: aiv, aic, or mix."""
        return os.getenv("KERNEL_CV_MODE", "").lower()
'''

KERNEL_OPTION_FIELDS = '''    kernel_path: str = ""
    kernel_bin_hash: str = ""
    kernel_cv_mode: str = ""
'''

KERNEL_POST_INIT = '''        kernel_path = OpenTileEnvConf.kernel_path()
        if kernel_path:
            path = Path(kernel_path)
            if not path.is_file():
                raise FileNotFoundError(f"KERNEL_PATH={kernel_path!r} is not a readable file")
            object.__setattr__(self, "kernel_path", str(path.resolve()))
            object.__setattr__(self, "kernel_bin_hash", hashlib.sha256(path.read_bytes()).hexdigest())
        kernel_cv_mode = OpenTileEnvConf.kernel_cv_mode()
        if kernel_cv_mode:
            if kernel_cv_mode not in ("aiv", "aic", "mix"):
                raise ValueError(f"Invalid KERNEL_CV_MODE '{kernel_cv_mode}'. Valid: [aiv, aic, mix]")
            object.__setattr__(self, "kernel_cv_mode", kernel_cv_mode)

'''

# 3c8b7592 (server) has fewer OpenTileNPUOptions fields than later main.
OPTION_FIELD_ANCHORS = (
    '    fusion_mode: str = "no_fuse"\n',
    "    flush_to_zero_modifier: bool = False\n",
)

POST_INIT_ANCHORS = (
    '''        if os.environ.get("FUSION_MODE"):
            object.__setattr__(self, "fusion_mode", os.environ.get("FUSION_MODE"))

        if self.arch and self.arch not in VALID_NPU_ARCHS:
''',
    '''        if os.environ.get("TRITON_DEBUG") == "1":
            object.__setattr__(self, "debug", True)

        if self.arch and self.arch not in VALID_NPU_ARCHS:
''',
)

MAKE_NPUBIN_OVERRIDE = '''def _apply_cv_mode(ir_text: str, metadata, opt):
    if opt.kernel_cv_mode:
        metadata["cv_mode"] = opt.kernel_cv_mode
        return
    # Extract auto-detected cv_mode from optimization_hints and update
    # metadata for downstream use (e.g. NPU compiler).
    match = re.search(r'cv_mode\\s*=\\s*"(\\w+)"', ir_text)
    if match:
        metadata["cv_mode"] = match.group(1)


def make_npubin(ir_text: str, metadata, opt):
    _apply_cv_mode(ir_text, metadata, opt)
    if opt.kernel_path:
        data = Path(opt.kernel_path).read_bytes()
        print(
            f"[KERNEL_PATH] replacing compiled npubin with {opt.kernel_path} "
            f"({len(data)} bytes) for kernel {metadata['name']!r} "
            f"cv_mode={metadata.get('cv_mode', 'aiv')}"
        )
        if opt.debug:
            dump_manager = get_dump_manager(metadata["hash"])
            dump_manager.put(data, f"{metadata['name']}.o", binary=True)
        return data

    with tempfile.TemporaryDirectory() as tmpdir:
        opentileir_path = os.path.join(tmpdir, f"{metadata['name']}.opentileir.mlir")
        npubin_path = os.path.join(tmpdir, f"{metadata['name']}.o")
        Path(opentileir_path).write_text(ir_text)
'''

ORIGINAL_MAKE_NPUBIN = '''def make_npubin(ir_text: str, metadata, opt):
    with tempfile.TemporaryDirectory() as tmpdir:
        opentileir_path = os.path.join(tmpdir, f"{metadata['name']}.opentileir.mlir")
        npubin_path = os.path.join(tmpdir, f"{metadata['name']}.o")
        # Extract auto-detected cv_mode from optimization_hints and update
        # metadata for downstream use (e.g. NPU compiler).
        match = re.search(r'cv_mode\\s*=\\s*"(\\w+)"', ir_text)
        if match:
            metadata["cv_mode"] = match.group(1)
        Path(opentileir_path).write_text(ir_text)
'''


class PatchError(RuntimeError):
    pass


def run(cmd: list[str]) -> str:
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode != 0:
        raise PatchError(
            f"command failed ({result.returncode}): {' '.join(cmd)}\n{result.stderr.strip()}"
        )
    return result.stdout.strip()


def parse_pip_show(output: str) -> dict[str, str]:
    fields: dict[str, str] = {}
    for line in output.splitlines():
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip()
    return fields


def pip_show(python_bin: str, package: str) -> dict[str, str] | None:
    result = subprocess.run(
        [python_bin, "-m", "pip", "show", package],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0 or not result.stdout.strip():
        return None
    return parse_pip_show(result.stdout)


def resolve_python(args: argparse.Namespace) -> str:
    if args.python:
        return str(Path(args.python).expanduser().resolve())
    if args.conda_env:
        conda = shutil.which("conda")
        if conda is None:
            raise PatchError("conda not found; pass --python or run with the env already activated")
        return run([conda, "run", "-n", args.conda_env, "which", "python"])
    return sys.executable


def locate_opentile_root(python_bin: str) -> Path:
    errors = []
    for name in PACKAGE_NAMES:
        info = pip_show(python_bin, name)
        if info is None:
            errors.append(f"{name}: not installed for {python_bin}")
            continue
        location = info.get("Location")
        if not location:
            errors.append(f"{name}: pip show has no Location field")
            continue
        root = Path(location) / "triton" / "backends" / "opentile"
        if (root / "conf.py").is_file() and (root / "targets" / "ascend" / "compiler.py").is_file():
            print(f"package: {info.get('Name', name)} {info.get('Version', '')}".rstrip())
            print(f"location: {location}")
            return root
        errors.append(f"{name}: Location={location} has no triton/backends/opentile")

    raise PatchError(
        "could not locate triton-opentile via pip show. "
        "Activate the env that has it, or pass --python.\n" + "\n".join(errors)
    )


def backup(path: Path) -> None:
    bak = path.with_suffix(path.suffix + ".bak")
    if not bak.exists():
        shutil.copy2(path, bak)
        print(f"backed up {path} -> {bak}")


def restore(path: Path) -> bool:
    bak = path.with_suffix(path.suffix + ".bak")
    if not bak.exists():
        print(f"skip restore, no backup: {bak}")
        return False
    shutil.copy2(bak, path)
    print(f"restored {path} from {bak}")
    return True


def replace_once(text: str, old: str, new: str, path: Path) -> str:
    if new.strip() in text and old not in text:
        return text
    if old not in text:
        raise PatchError(
            f"{path} does not contain the expected snippet. "
            "The installed package may have diverged; inspect the file and patch by hand."
        )
    return text.replace(old, new, 1)


def insert_after_anchor(text: str, anchors: tuple[str, ...], insert: str, path: Path) -> str:
    for old in anchors:
        if old not in text:
            continue
        if "VALID_NPU_ARCHS" in old:
            lines = old.splitlines(keepends=True)
            new = "".join(lines[:-1]) + insert + ("\n" if not insert.endswith("\n") else "") + lines[-1]
        else:
            new = old + insert
        return text.replace(old, new, 1)
    raise PatchError(
        f"{path} does not contain a known snippet for this package version. "
        "The installed package may have diverged; inspect the file and patch by hand."
    )


def patch_conf(path: Path) -> bool:
    text = path.read_text()
    if "def kernel_path(" in text:
        print(f"already patched: {path}")
        return False
    old = '''        return os.getenv("TRITON_ASCEND_ARCH", "")
'''
    new = old + CONF_HELPERS
    path.write_text(replace_once(text, old, new, path))
    print(f"patched {path}")
    return True


def patch_compiler(path: Path) -> bool:
    text = path.read_text()
    changed = False

    if 'kernel_path: str = ""' not in text:
        text = insert_after_anchor(text, OPTION_FIELD_ANCHORS, KERNEL_OPTION_FIELDS, path)
        changed = True

    if "OpenTileEnvConf.kernel_path()" not in text:
        text = insert_after_anchor(text, POST_INIT_ANCHORS, KERNEL_POST_INIT, path)
        changed = True

    if "if opt.kernel_path:" not in text:
        text = replace_once(text, ORIGINAL_MAKE_NPUBIN, MAKE_NPUBIN_OVERRIDE, path)
        changed = True

    if not changed:
        print(f"already patched: {path}")
        return False
    path.write_text(text)
    print(f"patched {path}")
    return True


def verify(python_bin: str) -> None:
    snippet = """
from triton.backends.opentile.conf import OpenTileEnvConf
from triton.backends.opentile.targets.ascend.compiler import OpenTileNPUOptions, make_npubin
assert callable(OpenTileEnvConf.kernel_path)
assert callable(OpenTileEnvConf.kernel_cv_mode)
assert "kernel_path" in OpenTileNPUOptions.__dataclass_fields__
assert "if opt.kernel_path" in open(make_npubin.__code__.co_filename).read()
print("KERNEL_PATH patch verified")
"""
    print(run([python_bin, "-c", snippet]))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--python",
        help="python interpreter that has triton-opentile (default: this script's interpreter)",
    )
    parser.add_argument(
        "--conda-env",
        help="optional conda env name; ignored unless --python is omitted",
    )
    parser.add_argument("--restore", action="store_true", help="restore files from .bak backups")
    parser.add_argument("--dry-run", action="store_true", help="print target files without writing")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    python_bin = resolve_python(args)
    root = locate_opentile_root(python_bin)
    conf = root / "conf.py"
    compiler = root / "targets" / "ascend" / "compiler.py"
    for path in (conf, compiler):
        if not path.is_file():
            raise PatchError(f"missing {path}")

    print(f"python: {python_bin}")
    print(f"opentile: {root}")
    if args.dry_run:
        return 0

    if args.restore:
        restore(conf)
        restore(compiler)
        return 0

    backup(conf)
    backup(compiler)
    patch_conf(conf)
    patch_compiler(compiler)
    verify(python_bin)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except PatchError as exc:
        print(f"error: {exc}", file=sys.stderr)
        sys.exit(1)

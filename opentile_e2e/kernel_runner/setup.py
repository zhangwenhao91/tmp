from pathlib import Path
from setuptools import Extension, setup

import os
import sysconfig


def _candidate_roots():
    keys = ("ASCEND_HOME_PATH", "ASCEND_TOOLKIT_HOME", "ASCEND_OPP_PATH")
    roots = [os.environ[k] for k in keys if os.environ.get(k)]
    if not roots:
        roots = [
            "/usr/local/Ascend/ascend-toolkit/latest",
            "/usr/local/Ascend/latest",
        ]

    dedup_roots = []
    seen = set()
    for root in roots:
        path = Path(root).expanduser()
        key = path.resolve() if path.exists() else path.absolute()
        if key in seen:
            continue
        seen.add(key)
        dedup_roots.append(path)
    return dedup_roots


def _existing(paths):
    return [str(p) for p in paths if p.exists()]


roots = _candidate_roots()
include_dirs = _existing(
    [r / "include" for r in roots]
    + [r / "include" / "experiment" for r in roots]
    + [r / "pkg_inc" for r in roots]
    + [r / "runtime" / "include" for r in roots]
)
library_dirs = _existing(
    [r / "lib64" for r in roots]
    + [r / "runtime" / "lib64" for r in roots]
    + [r / "runtime" / "lib64" / "stub" for r in roots]
)

python_include = sysconfig.get_path("include")
if python_include:
    include_dirs.append(python_include)

ext = Extension(
    "kernel_runner._ascend_runtime",
    sources=["csrc/ascend_runtime.cpp"],
    include_dirs=include_dirs,
    library_dirs=library_dirs,
    libraries=["runtime", "ascendcl"],
    language="c++",
    extra_compile_args=["-std=c++17", "-O2"],
)

setup(
    name="kernel-runner",
    version="0.1.0",
    description="Standalone Ascend kernel.o runner for npy inputs",
    packages=["kernel_runner"],
    ext_modules=[ext],
    python_requires=">=3.8",
    install_requires=["numpy"],
    entry_points={
        "console_scripts": [
            "kernel_runner=kernel_runner.runner:main",
        ],
    },
)

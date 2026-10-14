__all__ = ["run_from_config", "print_npy", "compare_npy"]


def run_from_config(*args, **kwargs):
    from .runner import run_from_config as _run_from_config

    return _run_from_config(*args, **kwargs)


def print_npy(*args, **kwargs):
    from .runner import print_npy as _print_npy

    return _print_npy(*args, **kwargs)


def compare_npy(*args, **kwargs):
    from .runner import compare_npy as _compare_npy

    return _compare_npy(*args, **kwargs)

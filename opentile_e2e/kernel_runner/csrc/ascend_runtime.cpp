#define PY_SSIZE_T_CLEAN
#include <Python.h>

#include <algorithm>
#include <cstdint>
#include <cstring>
#include <memory>
#include <stdexcept>
#include <string>
#include <tuple>
#include <vector>

#include "acl/acl.h"
#include "runtime/runtime/rt.h"

namespace {

std::vector<std::unique_ptr<std::string>> launch_names;

void raiseRtError(const char *what, rtError_t err) {
  PyErr_Format(PyExc_RuntimeError, "%s failed, error code: 0x%x", what, err);
}

void raiseAclError(const char *what, aclError err) {
  PyErr_Format(PyExc_RuntimeError, "%s failed, error code: 0x%x", what, err);
}

uint64_t asU64(PyObject *obj, const char *name) {
  unsigned long long value = PyLong_AsUnsignedLongLong(obj);
  if (PyErr_Occurred()) {
    PyErr_Format(PyExc_TypeError, "%s must be an unsigned integer", name);
    return 0;
  }
  return static_cast<uint64_t>(value);
}

int64_t asI64(PyObject *obj, const char *name) {
  long long value = PyLong_AsLongLong(obj);
  if (PyErr_Occurred()) {
    PyErr_Format(PyExc_TypeError, "%s must be an integer", name);
    return 0;
  }
  return static_cast<int64_t>(value);
}

double asDouble(PyObject *obj, const char *name) {
  double value = PyFloat_AsDouble(obj);
  if (PyErr_Occurred()) {
    PyErr_Format(PyExc_TypeError, "%s must be a number", name);
    return 0.0;
  }
  return value;
}

template <typename T> void appendBytes(std::vector<uint8_t> &buffer, T value) {
  const size_t old_size = buffer.size();
  buffer.resize(old_size + sizeof(T));
  std::memcpy(buffer.data() + old_size, &value, sizeof(T));
}

std::tuple<void *, void *> registerKernel(const char *name, const void *data,
                                          size_t data_size, int device,
                                          const char *kernel_mode_str) {
  rtDevBinary_t devbin;
  devbin.data = data;
  devbin.length = data_size;
  const std::string kernel_mode{kernel_mode_str};
  devbin.magic = kernel_mode == "aiv" ? RT_DEV_BINARY_MAGIC_ELF_AIVEC
                                      : RT_DEV_BINARY_MAGIC_ELF;
  devbin.version = 0;

  rtError_t ret = rtSetDevice(device);
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtSetDevice", ret);
    return {nullptr, nullptr};
  }

  void *devbin_handle = nullptr;
  ret = rtDevBinaryRegister(&devbin, &devbin_handle);
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtDevBinaryRegister", ret);
    return {nullptr, nullptr};
  }

  launch_names.push_back(std::make_unique<std::string>(name));
  const char *launch_name = launch_names.back()->c_str();
  void *func_stub_handle =
      reinterpret_cast<void *>(const_cast<char *>(launch_name));
  ret = rtFunctionRegister(
      devbin_handle, func_stub_handle, launch_name,
      reinterpret_cast<void *>(const_cast<char *>(launch_name)), 0);
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtFunctionRegister", ret);
    return {nullptr, nullptr};
  }

  return {devbin_handle, func_stub_handle};
}

PyObject *initRuntime(PyObject *, PyObject *args) {
  const char *config_path = nullptr;
  if (!PyArg_ParseTuple(args, "|z", &config_path)) {
    return nullptr;
  }
  aclError ret = aclInit(config_path);
  if (ret != ACL_SUCCESS) {
    raiseAclError("aclInit", ret);
    return nullptr;
  }
  Py_RETURN_NONE;
}

PyObject *finalizeRuntime(PyObject *, PyObject *args) {
  int device = 0;
  int reset_device = 1;
  if (!PyArg_ParseTuple(args, "|ii", &device, &reset_device)) {
    return nullptr;
  }
  aclError acl_ret = aclFinalize();
  if (acl_ret != ACL_SUCCESS) {
    raiseAclError("aclFinalize", acl_ret);
    return nullptr;
  }
  if (reset_device) {
    rtError_t rt_ret = rtDeviceReset(device);
    if (rt_ret != RT_ERROR_NONE) {
      raiseRtError("rtDeviceReset", rt_ret);
      return nullptr;
    }
  }
  Py_RETURN_NONE;
}

PyObject *loadKernel(PyObject *, PyObject *args) {
  const char *name = nullptr;
  const char *data = nullptr;
  Py_ssize_t data_size = 0;
  int device = 0;
  const char *kernel_mode = nullptr;

  if (!PyArg_ParseTuple(args, "sy#is", &name, &data, &data_size, &device,
                        &kernel_mode)) {
    return nullptr;
  }

  auto [module_handle, func_handle] = registerKernel(
      name, data, static_cast<size_t>(data_size), device, kernel_mode);
  if (PyErr_Occurred()) {
    return nullptr;
  }
  return Py_BuildValue("(KK)", reinterpret_cast<uint64_t>(module_handle),
                       reinterpret_cast<uint64_t>(func_handle));
}

PyObject *unregisterKernel(PyObject *, PyObject *args) {
  uint64_t module_value = 0;
  if (!PyArg_ParseTuple(args, "K", &module_value)) {
    return nullptr;
  }
  if (module_value == 0) {
    Py_RETURN_NONE;
  }
  rtError_t ret = rtDevBinaryUnRegister(reinterpret_cast<void *>(module_value));
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtDevBinaryUnRegister", ret);
    return nullptr;
  }
  Py_RETURN_NONE;
}

PyObject *setDevice(PyObject *, PyObject *args) {
  int device = 0;
  if (!PyArg_ParseTuple(args, "i", &device)) {
    return nullptr;
  }
  rtError_t ret = rtSetDevice(device);
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtSetDevice", ret);
    return nullptr;
  }
  Py_RETURN_NONE;
}

PyObject *createStream(PyObject *, PyObject *) {
  rtStream_t stream = nullptr;
  rtError_t ret = rtStreamCreate(&stream, 0);
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtStreamCreate", ret);
    return nullptr;
  }
  return Py_BuildValue("K", reinterpret_cast<uint64_t>(stream));
}

PyObject *destroyStream(PyObject *, PyObject *args) {
  uint64_t stream_value = 0;
  if (!PyArg_ParseTuple(args, "K", &stream_value)) {
    return nullptr;
  }
  rtError_t ret = rtStreamDestroy(reinterpret_cast<rtStream_t>(stream_value));
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtStreamDestroy", ret);
    return nullptr;
  }
  Py_RETURN_NONE;
}

PyObject *synchronizeStream(PyObject *, PyObject *args) {
  uint64_t stream_value = 0;
  if (!PyArg_ParseTuple(args, "K", &stream_value)) {
    return nullptr;
  }
  rtError_t ret =
      rtStreamSynchronize(reinterpret_cast<rtStream_t>(stream_value));
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtStreamSynchronize", ret);
    return nullptr;
  }
  Py_RETURN_NONE;
}

PyObject *mallocDevice(PyObject *, PyObject *args) {
  uint64_t num_bytes = 0;
  if (!PyArg_ParseTuple(args, "K", &num_bytes)) {
    return nullptr;
  }
  void *ptr = nullptr;
  rtError_t ret = rtMalloc(&ptr, num_bytes, RT_MEMORY_HBM, 0);
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtMalloc", ret);
    return nullptr;
  }
  return Py_BuildValue("K", reinterpret_cast<uint64_t>(ptr));
}

PyObject *freeDevice(PyObject *, PyObject *args) {
  uint64_t ptr_value = 0;
  if (!PyArg_ParseTuple(args, "K", &ptr_value)) {
    return nullptr;
  }
  if (ptr_value == 0) {
    Py_RETURN_NONE;
  }
  rtError_t ret = rtFree(reinterpret_cast<void *>(ptr_value));
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtFree", ret);
    return nullptr;
  }
  Py_RETURN_NONE;
}

PyObject *memcpyH2D(PyObject *, PyObject *args) {
  uint64_t dst_value = 0;
  const char *data = nullptr;
  Py_ssize_t size = 0;
  if (!PyArg_ParseTuple(args, "Ky#", &dst_value, &data, &size)) {
    return nullptr;
  }
  rtError_t ret =
      rtMemcpy(reinterpret_cast<void *>(dst_value), size,
               const_cast<char *>(data), size, RT_MEMCPY_HOST_TO_DEVICE);
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtMemcpy H2D", ret);
    return nullptr;
  }
  Py_RETURN_NONE;
}

PyObject *memcpyD2H(PyObject *, PyObject *args) {
  uint64_t src_value = 0;
  Py_ssize_t size = 0;
  if (!PyArg_ParseTuple(args, "Kn", &src_value, &size)) {
    return nullptr;
  }
  PyObject *bytes = PyBytes_FromStringAndSize(nullptr, size);
  if (bytes == nullptr) {
    return nullptr;
  }
  char *dst = PyBytes_AsString(bytes);
  rtError_t ret = rtMemcpy(dst, size, reinterpret_cast<void *>(src_value), size,
                           RT_MEMCPY_DEVICE_TO_HOST);
  if (ret != RT_ERROR_NONE) {
    Py_DECREF(bytes);
    raiseRtError("rtMemcpy D2H", ret);
    return nullptr;
  }
  return bytes;
}

bool appendArgBytes(std::vector<uint8_t> &buffer, PyObject *item) {
  const char *type = nullptr;
  PyObject *value = nullptr;
  if (!PyArg_ParseTuple(item, "sO", &type, &value)) {
    PyErr_SetString(PyExc_TypeError, "arg item must be a (type, value) tuple");
    return false;
  }

  std::string ty(type);
  if (ty == "ptr") {
    appendBytes<uint64_t>(buffer, asU64(value, "ptr"));
  } else if (ty == "int8") {
    appendBytes<int8_t>(buffer, static_cast<int8_t>(asI64(value, "int8")));
  } else if (ty == "uint8") {
    appendBytes<uint8_t>(buffer, static_cast<uint8_t>(asU64(value, "uint8")));
  } else if (ty == "int16") {
    appendBytes<int16_t>(buffer, static_cast<int16_t>(asI64(value, "int16")));
  } else if (ty == "uint16") {
    appendBytes<uint16_t>(buffer,
                          static_cast<uint16_t>(asU64(value, "uint16")));
  } else if (ty == "int32") {
    appendBytes<int32_t>(buffer, static_cast<int32_t>(asI64(value, "int32")));
  } else if (ty == "uint32") {
    appendBytes<uint32_t>(buffer,
                          static_cast<uint32_t>(asU64(value, "uint32")));
  } else if (ty == "int64") {
    appendBytes<int64_t>(buffer, asI64(value, "int64"));
  } else if (ty == "uint64") {
    appendBytes<uint64_t>(buffer, asU64(value, "uint64"));
  } else if (ty == "float32") {
    appendBytes<float>(buffer, static_cast<float>(asDouble(value, "float32")));
  } else if (ty == "float64") {
    appendBytes<double>(buffer, asDouble(value, "float64"));
  } else {
    PyErr_Format(PyExc_ValueError, "unsupported arg type: %s", type);
    return false;
  }
  return !PyErr_Occurred();
}

PyObject *launchKernel(PyObject *, PyObject *args, PyObject *kwargs) {
  static const char *kwlist[] = {"func", "stream", "blocknum", "kernel_args",
                                 nullptr};

  uint64_t func_value = 0;
  uint64_t stream_value = 0;
  uint32_t block_num = 0;
  PyObject *kernel_args = nullptr;

  if (!PyArg_ParseTupleAndKeywords(args, kwargs, "KKIO",
                                   const_cast<char **>(kwlist), &func_value,
                                   &stream_value, &block_num, &kernel_args)) {
    return nullptr;
  }
  if (!PySequence_Check(kernel_args)) {
    PyErr_SetString(PyExc_ValueError, "kernel_args must be a sequence");
    return nullptr;
  }

  Py_ssize_t arg_count = PySequence_Size(kernel_args);
  std::vector<uint8_t> args_buffer;
  for (Py_ssize_t i = 0; i < arg_count; ++i) {
    PyObject *item = PySequence_GetItem(kernel_args, i);
    if (item == nullptr) {
      return nullptr;
    }
    bool ok = appendArgBytes(args_buffer, item);
    Py_DECREF(item);
    if (!ok) {
      return nullptr;
    }
  }

  void *args_ptr =
      args_buffer.empty() ? nullptr : static_cast<void *>(args_buffer.data());
  rtError_t ret = rtKernelLaunch(
      reinterpret_cast<void *>(func_value), block_num, args_ptr,
      args_buffer.size(), nullptr, reinterpret_cast<rtStream_t>(stream_value));
  if (ret != RT_ERROR_NONE) {
    raiseRtError("rtKernelLaunch", ret);
    return nullptr;
  }

  Py_RETURN_NONE;
}

PyMethodDef methods[] = {
    {"init_runtime", initRuntime, METH_VARARGS, "Initialize ACL runtime."},
    {"finalize_runtime", finalizeRuntime, METH_VARARGS,
     "Finalize ACL runtime."},
    {"load_kernel", loadKernel, METH_VARARGS,
     "Register an Ascend kernel object and return (module, function)."},
    {"unregister_kernel", unregisterKernel, METH_VARARGS,
     "Unregister a registered kernel object."},
    {"set_device", setDevice, METH_VARARGS, "Set current device."},
    {"create_stream", createStream, METH_NOARGS, "Create an rtStream."},
    {"destroy_stream", destroyStream, METH_VARARGS, "Destroy an rtStream."},
    {"synchronize_stream", synchronizeStream, METH_VARARGS,
     "Synchronize an rtStream."},
    {"malloc_device", mallocDevice, METH_VARARGS, "Allocate device memory."},
    {"free_device", freeDevice, METH_VARARGS, "Free device memory."},
    {"memcpy_h2d", memcpyH2D, METH_VARARGS, "Copy bytes from host to device."},
    {"memcpy_d2h", memcpyD2H, METH_VARARGS, "Copy bytes from device to host."},
    {"launch_kernel", reinterpret_cast<PyCFunction>(launchKernel),
     METH_VARARGS | METH_KEYWORDS, "Launch a registered kernel."},
    {nullptr, nullptr, 0, nullptr},
};

PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "_ascend_runtime",
    "Small CANN runtime wrapper for standalone kernel.o execution.",
    -1,
    methods,
};

} // namespace

PyMODINIT_FUNC PyInit__ascend_runtime(void) { return PyModule_Create(&module); }

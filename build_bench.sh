#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

if [[ -z "${INSTALL_DIR:-}" ]]; then
  if [[ -d /usr/local/Ascend/cann-8.5.0 ]]; then
    INSTALL_DIR=/usr/local/Ascend/cann-8.5.0
  elif [[ -d /usr/local/Ascend/cann ]]; then
    INSTALL_DIR=/usr/local/Ascend/cann
  else
    echo "Set INSTALL_DIR to your CANN install path before building." >&2
    exit 1
  fi
fi

export PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/compiler/ccec_compiler/bin:${PATH}"
export RT_INC="${INSTALL_DIR}/include"
export RT_LIB="${INSTALL_DIR}/lib64"
export NPU_ARCH="${NPU_ARCH:-dav-2201}"

if [[ -d "${INSTALL_DIR}/include/ascendc/aicpu_api" ]]; then
  AICPU_INC="${INSTALL_DIR}/include/ascendc/aicpu_api"
elif [[ -d "${INSTALL_DIR}/toolkit/include/ascendc/aicpu_api" ]]; then
  AICPU_INC="${INSTALL_DIR}/toolkit/include/ascendc/aicpu_api"
else
  echo "Could not find ascendc/aicpu_api under ${INSTALL_DIR}" >&2
  exit 1
fi

if [[ -d "${INSTALL_DIR}/lib64/device/lib64" ]]; then
  AICPU_DEV_LIB="${INSTALL_DIR}/lib64/device/lib64"
elif [[ -d "${INSTALL_DIR}/toolkit/lib64/device/lib64" ]]; then
  AICPU_DEV_LIB="${INSTALL_DIR}/toolkit/lib64/device/lib64"
else
  echo "Could not find device lib64 under ${INSTALL_DIR}" >&2
  exit 1
fi

if [[ -d "${INSTALL_DIR}/toolkit/toolchain/hcc/bin" ]]; then
  HCC_BIN="${INSTALL_DIR}/toolkit/toolchain/hcc/bin"
else
  echo "Could not find HCC linker path under ${INSTALL_DIR}" >&2
  exit 1
fi

echo "Using INSTALL_DIR=${INSTALL_DIR}"
echo "Using NPU_ARCH=${NPU_ARCH}"
echo "Using AICPU_INC=${AICPU_INC}"

bisheng -x aicpu -O2 bench.aicpu -c -o bench.aicpu.o \
  --cce-aicpu-L"${AICPU_DEV_LIB}" \
  --cce-aicpu-laicpu_api \
  --cce-aicpu-toolkit-path="${HCC_BIN}" \
  -I"${AICPU_INC}" \
  -D__AICPU_DEVICE__

bisheng --shared -o libbench_aicpu.so bench.aicpu.o \
  -L"${RT_LIB}" -lascendc_runtime

bisheng --npu-arch="${NPU_ARCH}" -x cce -O2 bench_main.cce -c -o bench_main.o \
  -I"${RT_INC}"

bisheng --npu-arch="${NPU_ARCH}" bench_main.o -L"${RT_LIB}" \
  -lprofapi -lascendalog -lascendcl -lruntime -lc_sec -lmmpa \
  -lerror_manager -lascend_dump -L. -lbench_aicpu \
  -lpthread -lstdc++ -ldl -o bench_aicpu

echo
echo "Build complete."
echo "Run with:"
echo "  export LD_LIBRARY_PATH=${RT_LIB}:\$PWD:\${LD_LIBRARY_PATH:-}"
echo "  ./bench_aicpu"

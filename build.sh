#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${INSTALL_DIR:-}" ]]; then
  if [[ -d /usr/local/Ascend/cann ]]; then
    INSTALL_DIR=/usr/local/Ascend/cann
  elif [[ -n "${HOME:-}" && -d "${HOME}/Ascend/cann" ]]; then
    INSTALL_DIR="${HOME}/Ascend/cann"
  else
    echo "Set INSTALL_DIR to your CANN install path before building." >&2
    exit 1
  fi
fi

export PATH="${INSTALL_DIR}/compiler/ccec_compiler/bin:${PATH}"
export RT_INC="${INSTALL_DIR}/include"
export RT_LIB="${INSTALL_DIR}/lib64"
export NPU_ARCH="${NPU_ARCH:-dav-2201}"

echo "Using INSTALL_DIR=${INSTALL_DIR}"
echo "Using NPU_ARCH=${NPU_ARCH}"

bisheng -x aicpu -O2 test.aicpu -c -o test_aicpu.o \
  --cce-aicpu-L"${INSTALL_DIR}/lib64/device/lib64" \
  --cce-aicpu-laicpu_api \
  --cce-aicpu-toolkit-path="${INSTALL_DIR}/toolkit/toolchain/hcc/bin" \
  -I"${INSTALL_DIR}/include/ascendc/aicpu_api" \
  -D__AICPU_DEVICE__

bisheng --npu-arch="${NPU_ARCH}" -x cce -O2 test_main.cce -c -o test_main.o \
  -I"${RT_INC}"

bisheng --npu-arch="${NPU_ARCH}" test_aicpu.o test_main.o -o test_aicpu -L"${RT_LIB}" \
  -lascendc_runtime \
  -lprofapi -lascendalog -lascendcl -lruntime -lc_sec -lmmpa \
  -lerror_manager -lascend_dump \
  -lpthread -lstdc++ -ldl

echo
echo "Build complete."
echo "Run with:"
echo "  export LD_LIBRARY_PATH=${RT_LIB}:\$PWD:\${LD_LIBRARY_PATH:-}"
echo "  ./test_aicpu"

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

echo "Using INSTALL_DIR=${INSTALL_DIR}"

bisheng -O2 --std=c++17 test.aicpu -c -o test_aicpu.o \
  --cce-aicpu-L"${INSTALL_DIR}/lib64/device/lib64" \
  --cce-aicpu-laicpu_api \
  --cce-aicpu-toolkit-path="${INSTALL_DIR}/toolkit/toolchain/hcc/bin" \
  -I"${INSTALL_DIR}/include/ascendc/aicpu_api" \
  -D__AICPU_DEVICE__

bisheng --shared -o libtest_aicpu.so test_aicpu.o \
  -L"${INSTALL_DIR}/lib64" -lascendc_runtime

bisheng --std=c++17 test_main.cce -I"${RT_INC}" -L"${RT_LIB}" \
  -lprofapi -lascendalog -lascendcl -lruntime -lc_sec -lmmpa \
  -lerror_manager -lascend_dump -L. -ltest_aicpu \
  -lpthread -lstdc++ -ldl -o test_aicpu

echo
echo "Build complete."
echo "Run with:"
echo "  export LD_LIBRARY_PATH=${RT_LIB}:\$PWD:\${LD_LIBRARY_PATH:-}"
echo "  ./test_aicpu"

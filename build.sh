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
export BASENAME="${BASENAME:-foo}"

AICPU_SRC="${BASENAME}.aicpu"
HOST_SRC="${BASENAME}.cce"
AICPU_OBJ="${BASENAME}.aicpu.o"
HOST_OBJ="${BASENAME}.cce.o"
BIN_NAME="${BASENAME}"

echo "Using INSTALL_DIR=${INSTALL_DIR}"
echo "Using NPU_ARCH=${NPU_ARCH}"
echo "Using BASENAME=${BASENAME}"

if [[ ! -f "${AICPU_SRC}" ]]; then
  echo "Missing ${AICPU_SRC}" >&2
  exit 1
fi

if [[ ! -f "${HOST_SRC}" ]]; then
  echo "Missing ${HOST_SRC}" >&2
  exit 1
fi

bisheng -x aicpu -O2 "${AICPU_SRC}" -c -o "${AICPU_OBJ}" \
  --cce-aicpu-L"${INSTALL_DIR}/lib64/device/lib64" \
  --cce-aicpu-laicpu_api \
  --cce-aicpu-toolkit-path="${INSTALL_DIR}/toolkit/toolchain/hcc/bin" \
  -I"${INSTALL_DIR}/include/ascendc/aicpu_api" \
  -D__AICPU_DEVICE__

bisheng --npu-arch="${NPU_ARCH}" -x cce -O2 "${HOST_SRC}" -c -o "${HOST_OBJ}" \
  -I"${RT_INC}"

bisheng --npu-arch="${NPU_ARCH}" "${AICPU_OBJ}" "${HOST_OBJ}" -o "${BIN_NAME}" -L"${RT_LIB}" \
  -lascendc_runtime \
  -lprofapi -lascendalog -lascendcl -lruntime -lc_sec -lmmpa \
  -lerror_manager -lascend_dump \
  -lpthread -lstdc++ -ldl

echo
echo "Build complete."
echo "Run with:"
echo "  export LD_LIBRARY_PATH=${RT_LIB}:\$PWD:\${LD_LIBRARY_PATH:-}"
echo "  ./${BIN_NAME}"

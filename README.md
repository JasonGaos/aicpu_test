# Ascend AICPU Smoke Test

This directory contains minimal AICPU samples:

- `foo.aicpu` + `foo.cce`: the smallest end-to-end example
- `test.aicpu` + `test_main.cce`: a slightly larger example with a result copy-back path

Build on a machine with CANN and an Ascend device available.

## Quick start

```bash
cd ascend_aicpu_test
source /usr/local/Ascend/cann/set_env.sh
export NPU_ARCH=dav-2201
export BASENAME=foo
bash build.sh
export LD_LIBRARY_PATH=/usr/local/Ascend/cann/lib64:$PWD:${LD_LIBRARY_PATH}
./foo
```

Expected output:

```text
Hello from AICPU
```

If your install path differs, set `INSTALL_DIR` first:

```bash
export INSTALL_DIR=/path/to/Ascend/cann
export NPU_ARCH=dav-2201
export BASENAME=foo
bash build.sh
```

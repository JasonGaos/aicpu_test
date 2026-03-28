# Ascend AICPU Smoke Test

This directory contains a minimal two-file AICPU sample:

- `test.aicpu`: AI CPU device code
- `test_main.cce`: host code that launches the AICPU kernel

Build on a machine with CANN and an Ascend device available.

## Quick start

```bash
cd ascend_aicpu_test
source /usr/local/Ascend/cann/set_env.sh
bash build.sh
export LD_LIBRARY_PATH=/usr/local/Ascend/cann/lib64:$PWD:${LD_LIBRARY_PATH}
./test_aicpu
```

Expected output:

```text
Get Result in host: 0x00000003
Device result 3
```

If your install path differs, set `INSTALL_DIR` first:

```bash
export INSTALL_DIR=/path/to/Ascend/cann
bash build.sh
```

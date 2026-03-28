# Ascend AICPU Smoke Test

This directory contains:

- `test.aicpu`: device-side AICPU code
- `test_main.cce`: host-side launcher and result copy-back
- `bench_target.h` + `bench_target.c`: example C function to benchmark
- `bench.aicpu` + `bench_main.cce`: benchmark harness for a normal C function
- `build_bench.sh`: build script for the benchmark template

Build on a machine with CANN and an Ascend device available.

## Quick start

```bash
cd ascend_aicpu_test
source /usr/local/Ascend/cann/set_env.sh
export NPU_ARCH=dav-2201
bash build.sh
export LD_LIBRARY_PATH=/usr/local/Ascend/cann/lib64:$PWD:${LD_LIBRARY_PATH}
./test_aicpu
```

Expected output:

```text
Get Result in host: 0x00000003
Device Result: 0x00000003
```

If your install path differs, set `INSTALL_DIR` first:

```bash
export INSTALL_DIR=/path/to/Ascend/cann
export NPU_ARCH=dav-2201
bash build.sh
```

For the benchmark template, see [BENCHMARK_TEMPLATE.md](/Users/alba/Desktop/aice_test/ascend_aicpu_test/BENCHMARK_TEMPLATE.md).

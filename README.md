# Ascend AICPU Benchmarks

This directory now contains only the encrypt/decrypt benchmark harness:

- `bench_target.h` + `bench_target.c`: encrypt/decrypt declarations and placeholder implementations
- `bench.aicpu` + `bench_main.cce`: device kernels and host benchmark harness
- `build_bench.sh`: build script for the benchmark template

Build on a machine with CANN and an Ascend device available.

## Quick start

```bash
cd ascend_aicpu_test
source /usr/local/Ascend/cann-8.5.0/set_env.sh
export INSTALL_DIR=/usr/local/Ascend/cann-8.5.0
export NPU_ARCH=dav-2201
bash build_bench.sh
export LD_LIBRARY_PATH=${INSTALL_DIR}/lib64:$PWD:${LD_LIBRARY_PATH}
./bench_aicpu
```

For customization notes, see [BENCHMARK_TEMPLATE.md](/Users/alba/Desktop/aice_test/ascend_aicpu_test/BENCHMARK_TEMPLATE.md).

# AICPU Benchmark Template

This template shows how to benchmark a normal C function on AICPU.

Files:

- `bench_target.h`: the function declaration you will replace with your own
- `bench_target.c`: the C implementation under test
- `bench.aicpu`: the AICPU entry kernel that calls the target function
- `bench_main.cce`: the host-side harness that launches the kernel and times it
- `build_bench.sh`: build script for the benchmark template

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

## How to adapt it

1. Replace the declaration in `bench_target.h` with your function signature.
2. Replace the implementation in `bench_target.c` with your actual C code.
3. Update `BenchArgs` in `bench.aicpu` and `bench_main.cce` to carry your inputs and outputs.
4. Update `BenchKernel` in `bench.aicpu` to call your function inside the `repeat` loop.
5. Update host buffer allocation and input initialization in `bench_main.cce`.

This template keeps `bench_target.c` in the same AICPU translation unit by including it from `bench.aicpu`.

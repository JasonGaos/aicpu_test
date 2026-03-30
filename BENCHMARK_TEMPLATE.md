# AICPU Benchmark Template

This template shows how to benchmark a normal C function on AICPU.

Files:

- `bench_target.h`: the function declaration under test
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

The current template already matches this shape:

```c
void func(const uint8 *key, const uint8 *iv, const uint8 *plaintext,
          uint8 *ciphertext, const size_t msg_len);
```

1. Replace the placeholder implementation in `bench_target.c` with your real function body.
2. Keep the implementation compiled into `bench.aicpu`; including only your header is not enough.
3. Keep `BenchArgs` in `bench.aicpu` and `bench_main.cce` aligned byte-for-byte.
4. Make sure `key`, `iv`, `plaintext`, and `ciphertext` inside `BenchArgs` are device pointers from `aclrtMalloc`.
5. Start with tiny values in `bench_main.cce` (`msg_len = 64`, `repeat = 1`, `warmups = 1`, `launches = 1`) and raise them gradually after correctness is confirmed.
6. Adjust the key and IV lengths in `bench_main.cce` to match your algorithm.

This template keeps `bench_target.c` in the same AICPU translation unit by including it from `bench.aicpu`.

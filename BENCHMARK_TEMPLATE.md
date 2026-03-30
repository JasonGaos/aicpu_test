# AICPU Benchmark Template

This template shows how to benchmark encrypt/decrypt functions on AICPU and
check round-trip correctness.

Files:

- `bench_target.h`: declarations for `func` and `decryp`
- `bench_target.c`: placeholder implementations you will replace
- `bench.aicpu`: separate AICPU kernels for encrypt and decrypt
- `bench_main.cce`: host-side harness that times encrypt and decrypt separately and checks correctness
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

The current template already matches these shapes:

```c
void func(const uint8 *key, const uint8 *iv, const uint8 *plaintext,
          uint8 *ciphertext, const size_t msg_len);
void decryp(const uint8 *key, const uint8 *iv, const uint8 *ciphertext,
            uint8 *plaintext, const size_t msg_len);
```

1. Replace the placeholder implementations in `bench_target.c` with your real encrypt/decrypt bodies.
2. Keep the implementation compiled into `bench.aicpu`; including only your header is not enough.
3. Keep `BenchArgs` in `bench.aicpu` and `bench_main.cce` aligned byte-for-byte.
4. Make sure `key`, `iv`, `input`, and `output` inside `BenchArgs` are device pointers from `aclrtMalloc`.
5. Start with tiny values in `bench_main.cce` (`msg_len = 64`, `repeat = 1`, `warmups = 1`, `launches = 1`) and raise them gradually after correctness is confirmed.
6. Adjust the key and IV lengths in `bench_main.cce` to match your algorithm.
7. After the decrypt benchmark, the harness compares decrypted plaintext against the original input plaintext and prints PASS/FAIL.

Each benchmark summary prints throughput as both `GB/s` (10^9 bytes/second) and `GiB/s` (2^30 bytes/second), computed from:

```text
timed encrypted bytes = msg_len * repeat * launches
```

For a more stable throughput number after correctness is confirmed, increase `msg_len`, `repeat`, and `launches`.

This template keeps `bench_target.c` in the same AICPU translation unit by including it from `bench.aicpu`.

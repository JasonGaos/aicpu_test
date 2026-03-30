#ifndef BENCH_TARGET_H
#define BENCH_TARGET_H

#include <stddef.h>
#include <stdint.h>

#ifndef BENCH_UINT8_TYPE
typedef uint8_t uint8;
#define BENCH_UINT8_TYPE
#endif

#ifdef __cplusplus
extern "C" {
#endif

void func(const uint8 *key, const uint8 *iv, const uint8 *plaintext, uint8 *ciphertext,
          const size_t msg_len);

#ifdef __cplusplus
}
#endif

#endif

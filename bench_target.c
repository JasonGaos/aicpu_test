#include "bench_target.h"

enum {
    BENCH_KEY_BYTES = 32,
    BENCH_IV_BYTES = 16,
};

void func(const uint8 *key, const uint8 *iv, const uint8 *plaintext, uint8 *ciphertext,
          const size_t msg_len) {
    for (size_t i = 0; i < msg_len; ++i) {
        ciphertext[i] = (uint8)(plaintext[i] ^ key[i % BENCH_KEY_BYTES] ^ iv[i % BENCH_IV_BYTES]);
    }
}

void decryp(const uint8 *key, const uint8 *iv, const uint8 *ciphertext, uint8 *plaintext,
            const size_t msg_len) {
    for (size_t i = 0; i < msg_len; ++i) {
        plaintext[i] = (uint8)(ciphertext[i] ^ key[i % BENCH_KEY_BYTES] ^ iv[i % BENCH_IV_BYTES]);
    }
}

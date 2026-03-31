#include "bench_target.h"
#include "../aes/aes.h"

void func(const uint8 *key, const uint8 *iv, const uint8 *plaintext, uint8 *ciphertext,
          const size_t msg_len) {
    aes_encrypt_msg(key, iv, plaintext, ciphertext, msg_len);
}

void decryp(const uint8 *key, const uint8 *iv, const uint8 *ciphertext, uint8 *plaintext,
            const size_t msg_len) {
    aes_decrypt_msg(key, iv, ciphertext, plaintext, msg_len);
}

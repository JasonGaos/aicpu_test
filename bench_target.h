#ifndef BENCH_TARGET_H
#define BENCH_TARGET_H

#include <stddef.h>
#include <stdint.h>

#ifndef BENCH_UINT8_TYPE
typedef uint8_t uint8;
#define BENCH_UINT8_TYPE
#endif

#define AES_BLOCK_SIZE 16u
#define AES_KEY_SIZE 16u
#define AES_IV_SIZE 16u

#define BENCH_KEY_BYTES AES_KEY_SIZE
#define BENCH_IV_BYTES AES_IV_SIZE

#ifdef __cplusplus
extern "C" {
#endif

/*
 * AES-128 in CTR mode.
 * `key` must point to 16 bytes.
 * `iv` must point to a 16-byte initial counter block.
 * The counter is incremented as a big-endian 128-bit integer.
 */
void aes_encrypt_msg(const uint8_t *key,
                     const uint8_t *iv,
                     const uint8_t *plaintext,
                     uint8_t *ciphertext,
                     const size_t msg_len);

void aes_decrypt_msg(const uint8_t *key,
                     const uint8_t *iv,
                     const uint8_t *ciphertext,
                     uint8_t *plaintext,
                     const size_t msg_len);

/*
 * Thin aliases used by the AICPU benchmark wrapper.
 */
void func(const uint8 *key,
          const uint8 *iv,
          const uint8 *plaintext,
          uint8 *ciphertext,
          const size_t msg_len);

void decryp(const uint8 *key,
            const uint8 *iv,
            const uint8 *ciphertext,
            uint8 *plaintext,
            const size_t msg_len);

#ifdef __cplusplus
}
#endif

#endif

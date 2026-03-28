#include "bench_target.h"

int bench_target_sum(const int *input, int n) {
    int total = 0;
    for (int i = 0; i < n; ++i) {
        total += input[i];
    }
    return total;
}

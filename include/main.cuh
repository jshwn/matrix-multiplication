#include <benchmark/benchmark.h>

void BM_DGEMM_CUDA01(benchmark::State&);
void BM_DGEMM_CUDA02(benchmark::State&);
void BM_DGEMM_CUDA03(benchmark::State&);
void BM_DGEMM_CUDA04(benchmark::State&);

void BM_SGEMM_CUDA01(benchmark::State&);
#include <benchmark/benchmark.h>

#include "dgemm.cuh"
#include "cuda_common.cuh"

//  n=64까지만 동작함.
void BM_DGEMM_CUDA01(benchmark::State& state) {
    int n = state.range(0);
    size_t size = sizeof(double) * n * n;

    double* h_A = (double*)malloc(size);
    double* h_B = (double*)malloc(size);
    double* h_C = (double*)malloc(size);

    double *d_A; cudaMallocManaged(&d_A, size);
    double *d_B; cudaMallocManaged(&d_B, size);
    double *d_C; cudaMallocManaged(&d_C, size);

    srand((unsigned int)time(NULL));
    initializeDM(h_A, n);
    initializeDM(h_B, n);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    for (auto _ : state){
        dgemm_cuda_01<<<1,1>>>(d_A, d_B, d_C, n);
    }

    cudaFree(d_A); free(h_A);
    cudaFree(d_B); free(h_B);
    cudaFree(d_C); free(h_C);
}

void BM_DGEMM_CUDA02(benchmark::State& state) {
    int n = state.range(0);
    size_t size = sizeof(double) * n * n;

    double* h_A = (double*)malloc(size);
    double* h_B = (double*)malloc(size);
    double* h_C = (double*)malloc(size);

    double *d_A; cudaMalloc(&d_A, size);
    double *d_B; cudaMalloc(&d_B, size);
    double *d_C; cudaMalloc(&d_C, size);

    // int threadsPerBlock = 256;
    // int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;

    dim3 threads(1024, 1024);
    dim3 grid(ceil(n / (float)threads.x), ceil(n / (float)threads.y));

    srand((unsigned int)time(NULL));
    initializeDM(h_A, n);
    initializeDM(h_B, n);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    for (auto _ : state){
        cuda_event_timer raii{state};
        dgemm_cuda_02<<<grid,threads>>>(d_A, d_B, d_C, n);
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    free(h_A);
    free(h_B);
    free(h_C);
}


//  use unified memory
//  n=2^14에서 왜 Segmentatioin Fault가 나는가?
void BM_DGEMM_CUDA03(benchmark::State& state) {
    int n = state.range(0);
    size_t size = sizeof(double) * n * n;

    double* a; cudaMallocManaged(&a, size);
    double* b; cudaMallocManaged(&b, size);
    double* c; cudaMallocManaged(&c, size);

    dim3 threads(1024, 1024);
    dim3 grid(ceil(n / (float)threads.x), ceil(n / (float)threads.y));

    srand((unsigned int)time(NULL));
    initializeDM(a, n);
    initializeDM(b, n);

    for (auto _ : state){
        cuda_event_timer raii{state};
        dgemm_cuda_02<<<grid,threads>>>(a, b, c, n);
    }

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}


//  for Geforce 3080 ti
//  core number: 10240
/*
    Maximum Texture Dimension Size (x,y,z)
    1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
*/
void BM_DGEMM_CUDA04(benchmark::State& state) {
    int n = state.range(0);
    size_t size = sizeof(double) * n * n;

    double* a; cudaMallocManaged(&a, size);
    double* b; cudaMallocManaged(&b, size);
    double* c; cudaMallocManaged(&c, size);

    dim3 threads(1024, 1024);
    dim3 grid(ceil(n / (float)threads.x), ceil(n / (float)threads.y));

    srand((unsigned int)time(NULL));
    initializeDM(a, n);
    initializeDM(b, n);

    for (auto _ : state){
        cuda_event_timer raii{state};
        dgemm_cuda_02<<<grid,threads>>>(a, b, c, n);
    }

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
}


void BM_SGEMM_CUDA01(benchmark::State& state) {
    int n = state.range(0);
    size_t size = sizeof(double) * n * n;

    float* h_A = (float*)malloc(size);
    float* h_B = (float*)malloc(size);
    float* h_C = (float*)malloc(size);

    float *d_A; cudaMallocManaged(&d_A, size);
    float *d_B; cudaMallocManaged(&d_B, size);
    float *d_C; cudaMallocManaged(&d_C, size);

    dim3 threads(1024, 1024);
    dim3 grid(ceil(n / (float)threads.x), ceil(n / (float)threads.y));

    srand((unsigned int)time(NULL));
    initializeFM(h_A, n);
    initializeFM(h_B, n);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    for (auto _ : state){
        cuda_event_timer raii{state};
        sgemm_cuda_01<<<grid,threads>>>(d_A, d_B, d_C, n);
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    free(h_A);
    free(h_B);
    free(h_C);
}
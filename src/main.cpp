#include <benchmark/benchmark.h>
#include <iostream>
#include <cstdlib>
#include <cmath>

#include "main.hpp"

void BM_INTMM(benchmark::State& state){
    int M_SIZE = state.range(0);

    int** a = createIntMatrix(M_SIZE);
    int** b = createIntMatrix(M_SIZE);
    int** c = createIntMatrix(M_SIZE);

    for (auto _ : state){
        srand((unsigned int)time(NULL));
        initializeIntMatrix(a, M_SIZE);
        initializeIntMatrix(b, M_SIZE);
        
        intmm01(a,b,c, M_SIZE);
    }

    deleteIntMatrix(a, M_SIZE);
    deleteIntMatrix(b, M_SIZE);
    deleteIntMatrix(c, M_SIZE);
}

void BM_DGEMM01(benchmark::State& state) {
    int M_SIZE = state.range(0);

    double** a = createDoubleMatrix(M_SIZE);
    double** b = createDoubleMatrix(M_SIZE);
    double** c = createDoubleMatrix(M_SIZE);

    for (auto _ : state){
        srand((unsigned int)time(NULL));
        initializeDoubleMatrix(a, M_SIZE);
        initializeDoubleMatrix(b, M_SIZE);
        
        dgemm01(a,b,c, M_SIZE);
    }

    deleteDoubleMatrix(a, M_SIZE);
    deleteDoubleMatrix(b, M_SIZE);
    deleteDoubleMatrix(c, M_SIZE);
}

void BM_DGEMM02(benchmark::State& state) {
    int M_SIZE = state.range(0);

    double** a = createDoubleMatrix(M_SIZE);
    double** b = createDoubleMatrix(M_SIZE);
    double** c = createDoubleMatrix(M_SIZE);
    
    srand((unsigned int)time(NULL));
    initializeDoubleMatrix(a, M_SIZE);
    initializeDoubleMatrix(b, M_SIZE);

    for (auto _ : state){
        // srand((unsigned int)time(NULL));
        // initializeDoubleMatrix(a, M_SIZE);
        // initializeDoubleMatrix(b, M_SIZE);
        
        dgemm02(a,b,c, M_SIZE);
    }

    deleteDoubleMatrix(a, M_SIZE);
    deleteDoubleMatrix(b, M_SIZE);
    deleteDoubleMatrix(c, M_SIZE);
}



void BM_DGEMM03(benchmark::State& state) {
    int n = state.range(0);

    // https://codeng.tistory.com/169
    // https://stackoverflow.com/a/14635961


    double* a = (double*)aligned_alloc(32, 32*n*n);
    double* b = (double*)aligned_alloc(32, 32*n*n);
    double* c = (double*)aligned_alloc(32, 32*n*n);

    for (int i = 0; i < n * n; i++){
        c[i] = 0.0f;
    }

    srand((unsigned int)time(NULL));
    initializeMD(a, n);
    initializeMD(b, n);

    for (auto _ : state){        
        dgemm03(a,b,c,n);
    }

    free(a);
    free(b);
    free(c);
}

// BENCHMARK(BM_DGEMM02)
// ->Arg(pow(2,6))->Arg(pow(2,8))->Arg(pow(2,10));

BENCHMARK(BM_DGEMM_CUDA02)->UseManualTime()
->Arg(pow(2,8))->Arg(pow(2,10))->Arg(pow(2,12));

BENCHMARK(BM_DGEMM_CUDA03)->UseManualTime()
->Arg(pow(2,8))->Arg(pow(2,10))->Arg(pow(2,12)); // Arg(pow(2,14))에서 Segmentation Fault

BENCHMARK_MAIN();
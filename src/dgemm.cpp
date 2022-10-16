#include <x86intrin.h>
#include <iostream>

void dgemm01(double** a, double** b, double** c, int M_SIZE){
    for(int i=0; i<M_SIZE; i++){
        for(int j=0; j<M_SIZE; j++){
            for(int k=0; k<M_SIZE; k++){
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}


//  cache friendly
void dgemm02(double** a, double** b, double** c, int M_SIZE){
    int i, j, k;
    #pragma omp parallel for
    for(i=0; i<M_SIZE; i++){
        for(k=0; k<M_SIZE; k++){
            for(j=0; j<M_SIZE; j++){
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

//  cache friendly가 전제된 ILP 코드
void dgemm03(double* a, double* b, double* c, int n){
    #pragma omp parallel for
    for(int i=0; i<n; i+=4){    // 4 * 64bit(8Byte) = 256bit
        for(int j=0; j<n; ++j) {
            __m256d c0 = _mm256_load_pd(c+i+j*n);   // c0 = c[i][j]

            for(int k=0; k<n; k++){    
                __m256d a4 = _mm256_broadcastsd_pd(_mm_load_sd(a+(j*n)+k));
                c0 = _mm256_fmadd_pd(_mm256_load_pd(b+(k*n)+i), a4, c0);

                // std::cout << i << j << k << std::endl;
            }
            // _mm256_store_pd(c+i*n+j, c0);   // c[i][j] = c0
            _mm256_store_pd(c+i+(j*n), c0);   // c[i][j] = c0
            
            // std::cout << "stored: " << i << j << std::endl;
        }
    }
};
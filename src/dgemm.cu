//  with 1 thread 1 block
__global__ void dgemm_cuda_01(double *a, double *b, double *c, int N) {
    for(int i=0; i<N; i++){
        for(int j=0; j<N; j++){
            for(int k=0; k<N; k++){
                *(c+i*N+j) += (*(a+i*N+k)) * (*(b+k*N+j));
            }
        }
    }
}

//  standard
__global__ void dgemm_cuda_02(double *a, double *b, double *c, int N) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if(row<N && col<N){
        double v = 0.0;
        for(int i=0;i<N;i++){
            v += *(a+row*N+i) + *(b+i*N+col);
        }
        *(c+row*N+col) = v;
    }
}

//  cache friendly
__global__ void dgemm_cuda_03(double *a, double *b, double *c, int N) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if(row<N && col<N){
        double v = 0.0;
        for(int i=0;i<N;i++){
            v += *(a+row*N+i) + *(b+i*N+col);
        }
        *(c+row*N+col) = v;
    }
}


__global__ void sgemm_cuda_01(float* a, float* b, float* c, int N){
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if(row<N && col<N){
        double v = 0.0;
        for(int i=0;i<N;i++){
            v += *(a+row*N+i) + *(b+i*N+col);
        }
        *(c+row*N+col) = v;
    }
};
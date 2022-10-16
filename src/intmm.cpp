void intmm01(int** a, int **b, int **c, int M_SIZE){
    for(int i=0; i<M_SIZE; i++){
        for(int j=0; j<M_SIZE; j++){
            for(int k=0; k<M_SIZE; k++){
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}
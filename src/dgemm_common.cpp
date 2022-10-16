#include <cstdlib>
#include <iostream>

double** createDoubleMatrix(int M_SIZE) {
    double** m = new double*[M_SIZE];
    for(int i = 0; i < M_SIZE; ++i)
        m[i] = new double[M_SIZE];
    return m;
}

void initializeDoubleMatrix(double** matrix, int M_SIZE){
    for(int i=0; i<M_SIZE; i++){
        for(int j=0; j<M_SIZE; j++){
            matrix[i][j] = std::rand() % 10;
        }
    }
}


void printDoubleMatrix(double** matrix, int M_SIZE){
    for(int i=0; i<M_SIZE; i++){
        for(int j=0; j<M_SIZE; j++){
            printf("%f, ", matrix[i][j]);
        }
        printf("\n");
    }
}


void deleteDoubleMatrix(double** m, int M_SZIE){
    for(int i=0; i<M_SZIE; i++)
	    delete[] m[i];
    delete[] m;
}

void initializeMD(double* m, int n){
    for(int i=0; i<n*n; i++){
        m[i] = std::rand() % 10;
    }
};
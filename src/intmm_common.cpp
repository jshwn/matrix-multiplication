#include <cstdlib>
#include <iostream>


// void createIntMatrices(int** a, int** b, int** c, int M_SIZE){
//     int** matrices[3] = {a, b, c};
// };


int** createIntMatrix(int M_SIZE) {
    int** m = new int*[M_SIZE];
    for(int i = 0; i < M_SIZE; i++)
        m[i] = new int[M_SIZE];
    return m;
}

void initializeIntMatrix(int** matrix, int M_SIZE){
    for(int i=0; i<M_SIZE; i++){
        for(int j=0; j<M_SIZE; j++){
            matrix[i][j] = std::rand() % 10;
        }
    }
}


void printIntMatrix(int** matrix, int M_SIZE){
    for(int i=0; i<M_SIZE; i++){
        for(int j=0; j<M_SIZE; j++){
            printf("%d, ", matrix[i][j]);
        }
        printf("\n");
    }
}


void deleteIntMatrix(int** m, int M_SZIE){
    for(int i=0; i<M_SZIE; i++)
	    delete[] m[i];
    delete[] m;
}
#include <cstdlib>

void initializeDM(double* m, int n){
    for(int i=0; i<n*n; i++){
        m[i] = std::rand() % 10;
    }
};

void initializeFM(float* m, int n){
    for(int i=0; i<n*n; i++){
        m[i] = std::rand() % 10;
    }
};
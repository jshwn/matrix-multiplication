#   cmake --build ./build && make -C ./build && ./build/test

cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(test LANGUAGES CXX CUDA)

find_package(benchmark REQUIRED)
find_package(OpenMP REQUIRED)

set(CMAKE_CXX_STANDARD 11)

set(CMAKE_BUILD_TYPE Release)#은 google benchmark의 DEBUG warining을 해제한다.
# add_compile_options()#은 nvcc에도 적용됨.

# enable avx in cmake
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -O2 -Wall -Werror -march=native")

# enable Amphere Architecture GPU
set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -arch=sm_80")

file(GLOB SRC "./src/*")

add_executable(test ${SRC})

set_target_properties(test PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

target_link_libraries(test PRIVATE benchmark::benchmark OpenMP::OpenMP_CXX)

target_include_directories(test PUBLIC ${CMAKE_SOURCE_DIR}/include)
#   README

##  빌드 및 실행
```sh
$ cmake --build ./build && make -C ./build && ./build/test
```
설치 및 세팅은 이후에 추가 예정


##  최적화 방법
*   캐시 최적화 1: 행 우선 참조
*   캐시 최적화 2: 캐시 블로킹
*   ILP 향상: AVX256 사용(행 우선 참조 전제)
*   스레드 사용: openMP
*   GPU 사용(CUDA)

##  Runtime
Run on (12 X 3693.07 MHz CPU s)
CPU Caches:
  L1 Data 32 KiB (x6)
  L1 Instruction 32 KiB (x6)
  L2 Unified 512 KiB (x6)
  L3 Unified 32768 KiB (x1)
Load Average: 0.04, 0.08, 0.04

##  기본
### O0
BM_INTMM/2           1201 ns         1201 ns       576923
BM_INTMM/100      5844541 ns      5844547 ns          118
BM_DGEMM01/2         1211 ns         1211 ns       580857
BM_DGEMM01/100    5804065 ns      5804038 ns          118
BM_DGEMM02/2         1204 ns         1204 ns       577726
BM_DGEMM02/100    5870344 ns      5870362 ns          119
BM_DGEMM03/4         3230 ns         3230 ns       216246
BM_DGEMM03/100    2603215 ns      2603221 ns          267

### O1
BM_INTMM/2           1158 ns         1158 ns       603747
BM_INTMM/100      2338690 ns      2338657 ns          297
BM_DGEMM01/2         1166 ns         1166 ns       605406
BM_DGEMM01/100    2546807 ns      2546815 ns          278
BM_DGEMM02/2         1174 ns         1174 ns       602705
BM_DGEMM02/100    2389040 ns      2389032 ns          292
BM_DGEMM03/4         1370 ns         1370 ns       509837
BM_DGEMM03/100     296519 ns       296441 ns         2353

### O2
BM_INTMM/2           1141 ns         1141 ns       610114
BM_INTMM/100       607452 ns       607444 ns         1190
BM_DGEMM01/2         1143 ns         1143 ns       613795
BM_DGEMM01/100     683005 ns       683003 ns         1020
BM_DGEMM02/2         1140 ns         1140 ns       612589
BM_DGEMM02/100     591606 ns       591607 ns         1165
BM_DGEMM03/4         1280 ns         1280 ns       539849
BM_DGEMM03/100     268964 ns       268962 ns         2586


### O3
BM_INTMM/2           1143 ns         1143 ns       610617
BM_INTMM/100       599123 ns       599117 ns         1127
BM_DGEMM01/2         1146 ns         1146 ns       601965
BM_DGEMM01/100     680452 ns       680449 ns          979
BM_DGEMM02/2         1152 ns         1152 ns       601005
BM_DGEMM02/100     244212 ns       244211 ns         2881
BM_DGEMM03/4         1280 ns         1280 ns       541457
BM_DGEMM03/100     270185 ns       270184 ns         2567






## openMP 적용
### 미적용
BM_DGEMM02/1024        148 ms          148 ms            4
BM_DGEMM02/4096      21518 ms        21518 ms            1

### #pragma omp parallel for
BM_DGEMM02/1024       44.1 ms         44.0 ms           15
BM_DGEMM02/4096       4476 ms         4361 ms            1
BM_DGEMM03/1024        106 ms          104 ms            6
BM_DGEMM03/4096      21270 ms        19235 ms            1

### #pragma omp parallel num_threads(12) for
BM_DGEMM02/1024       46.2 ms         46.2 ms           15
BM_DGEMM02/4096       5396 ms         5026 ms            1
BM_DGEMM03/1024        114 ms          108 ms            6
BM_DGEMM03/4096      26299 ms        22810 ms            1


##  CUDA와 비교
* BM_DGEMM은 `#pragma omp parallel for` 전제
BM_DGEMM02/1024             46.9 ms         46.9 ms           16
BM_DGEMM02/4096             5490 ms         5282 ms            1
BM_DGEMM_CUDA02/1024        14.9 ms         14.9 ms           47
BM_DGEMM_CUDA02/4096         249 ms          249 ms            3
BM_DGEMM_CUDA02/16384       4356 ms         4356 ms            1
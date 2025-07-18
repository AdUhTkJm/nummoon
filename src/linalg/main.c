#include <stdio.h>
#include <time.h>
#include "vector.h"

double current() {
  struct timespec t;
  clock_gettime(CLOCK_MONOTONIC, &t);
  return t.tv_sec + t.tv_nsec * 1e-9;
}

void benchmark() {
  vector_t vec1, vec2;
  vec_create(&vec1);
  vec_create(&vec2);

  vec_linspace(&vec1, 0, 1023, 1024000);
  vec_linspace(&vec2, 0, 2047, 1024000);
  
  // Warm-up
  vec_add_inplace(&vec1, vec2);

  double start = current();
  for (int i = 0; i < 10000; i++) {
    vec_add_inplace(&vec1, vec2);
  }
  double end = current();
  printf("time: %2f us\n", (end - start) * 1000000);

  vec_release(vec1);
  vec_release(vec2);
}

void functional() {
  vector_t vec1, vec2;
  vec_create(&vec1);
  vec_create(&vec2);

  vec_linspace(&vec1, 0, 5, 6);
  vec_linspace(&vec2, 0, 5, 6);

  printf("%.2f\n", vec_dot(vec1, vec2));
}

int main() {
  functional();
  return 0;
}

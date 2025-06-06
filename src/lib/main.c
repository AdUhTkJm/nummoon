#include <stdio.h>
#include "matrix.h"

int main() {
  vector_t vec1, vec2;
  vec_create(&vec1);
  vec_create(&vec2);

  vec_linspace(&vec1, 0, 15, 16);
  vec_linspace(&vec2, 0, 45, 16);

  vec_add_inplace(&vec1, vec2);
  for (int i = 0; i < 16; i++)
    printf("%2f ", vec1.dat[i]);
  printf("\n");
  return 0;
}

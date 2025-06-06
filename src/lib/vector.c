#include "matrix.h"
#include "intrin.h"
#include <stdlib.h>

unsigned round16(unsigned x) {
  if (x % 16)
    return x / 16 * 16 + 16;

  return x;
}

void vec_reserve(vector_t *self, unsigned size) {
  int rnd = round16(size) * sizeof(float);
  if (self->cap >= rnd)
    return;
  free(self->dat);
  self->cap = rnd << 1;
  self->dat = aligned_alloc(32, self->cap * sizeof(float));
}

void vec_create(vector_t *self) {
  self->sz = 0;
  self->cap = 0;
  self->dat = NULL;
}

void vec_add_inplace(vector_t *self, vector_t other) {
  vfadd_avx2(self->dat, other.dat, self->dat, round16(other.sz));
}

void vec_linspace(vector_t *self, float start, float end, unsigned size) {
  self->sz = size;
  vec_reserve(self, size);
  vflinspace_avx2(self->dat, start, (end - start) / (size - 1), round16(size));
}

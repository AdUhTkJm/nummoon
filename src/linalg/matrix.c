#include "matrix.h"
#include "stdlib.h"
#include "intrin.h"

void mat_reserve(matrix_t *self, unsigned cap) {
  if (self->cap >= cap)
    return;
  free(self->dat);
  self->cap = ((self->cap << 1) < cap) ? cap : (self->cap << 1);
  self->cap = round16(self->cap);
  self->dat = aligned_alloc(32, self->cap * sizeof(float));
}

void mat_create(matrix_t *self) {
  self->r = self->c = 0;
  self->cap = 0;
  self->dat = NULL;
}

void mat_add_inplace(matrix_t *self, matrix_t other) {
  mfadd_avx2(self->dat, other.dat, self->dat, other.r, round16(other.c));
}

#include "matrix.h"
#include "stdlib.h"
#include "intrin.h"
#include <stdio.h>
#include <string.h>

// Suppress warning of unused headers.
void _unused() { printf("a"); }

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

void mat_sub_inplace(matrix_t *self, matrix_t other) {
  mfsub_avx2(self->dat, other.dat, self->dat, other.r, round16(other.c));
}

void mat_mul_inplace(matrix_t *self, matrix_t other) {
  mfmul_avx2(self->dat, other.dat, self->dat, other.r, round16(other.c));
}

void mat_div_inplace(matrix_t *self, matrix_t other) {
  mfdiv_avx2(self->dat, other.dat, self->dat, other.r, round16(other.c));
}

void mat_add(matrix_t *self, matrix_t a, matrix_t b) {
  self->c = a.c;
  self->r = a.r;
  mat_reserve(self, round16(a.c) * a.r);
  mfadd_avx2(a.dat, b.dat, self->dat, a.r, round16(a.c));
}

void mat_sub(matrix_t *self, matrix_t a, matrix_t b) {
  self->c = a.c;
  self->r = a.r;
  mat_reserve(self, round16(a.c) * a.r);
  mfsub_avx2(a.dat, b.dat, self->dat, a.r, round16(a.c));
}

void mat_mul(matrix_t *self, matrix_t a, matrix_t b) {
  self->c = a.c;
  self->r = a.r;
  mat_reserve(self, round16(a.c) * a.r);
  mfmul_avx2(a.dat, b.dat, self->dat, a.r, round16(a.c));
}

void mat_div(matrix_t *self, matrix_t a, matrix_t b) {
  self->c = a.c;
  self->r = a.r;
  mat_reserve(self, round16(a.c) * a.r);
  mfdiv_avx2(a.dat, b.dat, self->dat, a.r, round16(a.c));
}

void mat_mmul(matrix_t *self, matrix_t a, matrix_t b) {
  self->r = a.r;
  self->c = b.c;
  mat_reserve(self, round16(self->c) * self->r);
  // Zero-out self.
  memset(self->dat, 0, self->cap * sizeof(float));
  mfmmul_avx2(a.dat, b.dat, self->dat, a.r, a.c, round16(b.c));
}

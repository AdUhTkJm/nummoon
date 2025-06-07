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

void vec_sub_inplace(vector_t *self, vector_t other) {
  vfsub_avx2(self->dat, other.dat, self->dat, round16(other.sz));
}

void vec_mul_inplace(vector_t *self, vector_t other) {
  vfmul_avx2(self->dat, other.dat, self->dat, round16(other.sz));
}

void vec_div_inplace(vector_t *self, vector_t other) {
  vfdiv_avx2(self->dat, other.dat, self->dat, round16(other.sz));
}

void vec_add_inplace_f(vector_t *self, float num) {
  vfaddf_avx2(self->dat, num, self->dat, round16(self->sz));
}

void vec_sub_inplace_f(vector_t *self, float num) {
  vfsubf_avx2(self->dat, num, self->dat, round16(self->sz));
}

void vec_mul_inplace_f(vector_t *self, float num) {
  vfmulf_avx2(self->dat, num, self->dat, round16(self->sz));
}

void vec_div_inplace_f(vector_t *self, float num) {
  vfdivf_avx2(self->dat, num, self->dat, round16(self->sz));
}

void vec_add(vector_t *self, vector_t a, vector_t b) {
  unsigned sz = round16(a.sz);
  self->sz = a.sz;
  vec_reserve(self, sz);
  vfadd_avx2(a.dat, b.dat, self->dat, sz);
}

void vec_sub(vector_t *self, vector_t a, vector_t b) {
  unsigned sz = round16(a.sz);
  self->sz = a.sz;
  vec_reserve(self, sz);
  vfsub_avx2(a.dat, b.dat, self->dat, sz);
}

void vec_mul(vector_t *self, vector_t a, vector_t b) {
  unsigned sz = round16(a.sz);
  self->sz = a.sz;
  vec_reserve(self, sz);
  vfmul_avx2(a.dat, b.dat, self->dat, sz);
}

void vec_div(vector_t *self, vector_t a, vector_t b) {
  unsigned sz = round16(a.sz);
  self->sz = a.sz;
  vec_reserve(self, sz);
  vfdiv_avx2(a.dat, b.dat, self->dat, sz);
}

void vec_linspace(vector_t *self, float start, float end, unsigned size) {
  self->sz = size;
  vec_reserve(self, size);
  vflinspace_avx2(self->dat, start, (end - start) / (size - 1), round16(size));
}

void vec_release(vector_t self) {
  free(self.dat);
}

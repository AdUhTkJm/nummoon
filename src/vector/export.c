#include "matrix.h"
#include "moonbit.h"
#include <string.h>

void mbt_vfrelease(void *payload) {
  vec_release(*(vector_t*) payload);
}

void *mbt_vfcreate() {
  vector_t *vec = moonbit_make_external_object(mbt_vfrelease, sizeof(vector_t));
  vec_create(vec);
  return vec;
}

float *mbt_vf2mbtarr(void *vec) {
  float *dat = ((vector_t*) vec)->dat;
  int sz = ((vector_t*) vec)->sz;
  
  float *arr = moonbit_make_float_array(sz, 0);
  memcpy(arr, dat, sz * sizeof(float));
  return arr;
}

void mbt_vflinspace(void *vec, float start, float end, int size) {
  vec_linspace((vector_t*) vec, start, end, size);
}

void *mbt_vfcopy(void *vec_) {
  vector_t *vec = vec_;
  vector_t *copy = mbt_vfcreate();
  copy->sz = vec->sz;
  vec_reserve(copy, vec->cap);
  memcpy(copy->dat, vec->dat, copy->sz * sizeof(float));
  return copy;
}

void *mbt_vfcopyf(float *arr) {
  vector_t *copy = mbt_vfcreate();
  int sz = Moonbit_array_length(arr);
  copy->sz = sz;
  vec_reserve(copy, sz);
  memcpy(copy->dat, arr, sz * sizeof(float));
  return copy;
}

void *mbt_vfzero(unsigned sz) {
  vector_t *zeroes = mbt_vfcreate();
  zeroes->sz = sz;
  vec_reserve(zeroes, sz);
  memset(zeroes->dat, 0, sz * sizeof(float));
  return zeroes;
}

void mbt_vfaddeqv(void *vec, void *vec2) {
  vec_add_inplace((vector_t*) vec, *(vector_t*) vec2);
}

void mbt_vfsubeqv(void *vec, void *vec2) {
  vec_sub_inplace((vector_t*) vec, *(vector_t*) vec2);
}

void mbt_vfmuleqv(void *vec, void *vec2) {
  vec_mul_inplace((vector_t*) vec, *(vector_t*) vec2);
}

void mbt_vfdiveqv(void *vec, void *vec2) {
  vec_div_inplace((vector_t*) vec, *(vector_t*) vec2);
}

void mbt_vfaddeqf(void *vec, float num) {
  vec_add_inplace_f((vector_t*) vec, num);
}

void mbt_vfsubeqf(void *vec, float num) {
  vec_sub_inplace_f((vector_t*) vec, num);
}

void mbt_vfmuleqf(void *vec, float num) {
  vec_mul_inplace_f((vector_t*) vec, num);
}

void mbt_vfdiveqf(void *vec, float num) {
  vec_div_inplace_f((vector_t*) vec, num);
}

void mbt_vfadd(void *tgt, void *vec, void *vec2) {
  vec_add((vector_t*) tgt, *(vector_t*) vec, *(vector_t*) vec2);
}

void mbt_vfsub(void *tgt, void *vec, void *vec2) {
  vec_sub((vector_t*) tgt, *(vector_t*) vec, *(vector_t*) vec2);
}

void mbt_vfmul(void *tgt, void *vec, void *vec2) {
  vec_mul((vector_t*) tgt, *(vector_t*) vec, *(vector_t*) vec2);
}

void mbt_vfdiv(void *tgt, void *vec, void *vec2) {
  vec_div((vector_t*) tgt, *(vector_t*) vec, *(vector_t*) vec2);
}

float mbt_vfsum(void *vec) {
  return vec_sum(*(vector_t*) vec);
}

unsigned mbt_vfgetsize(void *vec) {
  return ((vector_t*) vec)->sz;
}

float mbt_vfget(void *vec, unsigned i) {
  return ((vector_t*) vec)->dat[i];
}

void mbt_vfset(void *vec, unsigned i, float f) {
  ((vector_t*) vec)->dat[i] = f;
}

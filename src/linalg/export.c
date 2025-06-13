#include "vector.h"
#include "matrix.h"
#include "moonbit.h"
#include "intrin.h"
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

float mbt_vfdot(void *x, void *y) {
  return vec_dot(*(vector_t*) x, *(vector_t*) y);
}

void mbt_mfrelease(void *payload) {
  mat_release(*(matrix_t*) payload);
}

void *mbt_mfcreate() {
  matrix_t *mat = moonbit_make_external_object(mbt_mfrelease, sizeof(matrix_t));
  mat_create(mat);
  return mat;
}

void mbt_mfaddeq(void *x, void *y) {
  mat_add_inplace((matrix_t*) x, *(matrix_t*) y);
}

void mbt_mfsubeq(void *x, void *y) {
  mat_sub_inplace((matrix_t*) x, *(matrix_t*) y);
}

void mbt_mfmuleq(void *x, void *y) {
  mat_mul_inplace((matrix_t*) x, *(matrix_t*) y);
}

void mbt_mfdiveq(void *x, void *y) {
  mat_div_inplace((matrix_t*) x, *(matrix_t*) y);
}

void mbt_mfadd(void *tgt, void *x, void *y) {
  mat_add((matrix_t*) tgt, *(matrix_t*) x, *(matrix_t*) y);
}

void mbt_mfsub(void *tgt, void *x, void *y) {
  mat_sub((matrix_t*) tgt, *(matrix_t*) x, *(matrix_t*) y);
}

void mbt_mfmul(void *tgt, void *x, void *y) {
  mat_mul((matrix_t*) tgt, *(matrix_t*) x, *(matrix_t*) y);
}

void mbt_mfdiv(void *tgt, void *x, void *y) {
  mat_div((matrix_t*) tgt, *(matrix_t*) x, *(matrix_t*) y);
}

void *mbt_mfcopyf(float **arr) {
  matrix_t *mat = mbt_mfcreate();
  mat->r = Moonbit_array_length(arr);
  mat->c = Moonbit_array_length(arr[0]);

  // Round `r` to 16 floats.
  int rlen = round16(mat->c);
  int cap = rlen * mat->r;
  mat_reserve(mat, cap);
  // The outer loop can hardly be vectorized;
  // The arrays in `arr` are not necessarily contiguous.
  for (int i = 0; i < mat->r; i++)
    memcpy(mat->dat + i * rlen, arr[i], mat->c * sizeof(float));
  
  return mat;
}

float *mbt_mf2mbtarr(void *mat_) {
  matrix_t *mat = mat_;
  int rlen = round16(mat->c);
  
  float *arr = moonbit_make_float_array(mat->r * mat->c, 0);
  for (int i = 0; i < mat->r; i++)
    memcpy(arr + i * mat->c, mat->dat + i * rlen, mat->c * sizeof(float));
  
  return arr;
}

int mbt_mfrows(void *mat) {
  return ((matrix_t*) mat)->r;
}

int mbt_mfcols(void *mat) {
  return ((matrix_t*) mat)->c;
}

void *mbt_mfmmul(void *x, void *y) {
  matrix_t *mat = mbt_mfcreate();
  mat_mmul(mat, *(matrix_t*) x, *(matrix_t*) y);
  return mat;
}

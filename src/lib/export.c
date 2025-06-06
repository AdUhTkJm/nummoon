#include "matrix.h"
#include "moonbit.h"

void mbt_vrelease(void *payload) {
  vec_release(*(vector_t*) payload);
}

void *mbt_vcreate() {
  void *vec = moonbit_make_external_object(mbt_vrelease, sizeof(vector_t));
  return vec;
}

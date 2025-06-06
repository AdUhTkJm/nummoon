#include "matrix.h"
#include "moonbit.h"

void mbt_vfrelease(void *payload) {
  vec_release(*(vector_t*) payload);
}

void *mbt_vfcreate() {
  void *vec = moonbit_make_external_object(mbt_vfrelease, sizeof(vector_t));
  return vec;
}

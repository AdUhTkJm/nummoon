// When not explicitly stated otherwise, `size` is assumed to be a multiple of 16,
// and addresses must be 32-byte aligned.

// For these functions,
// `out` can never partially overlap with either `a` or `b`,
// but it's allowed to be exactly the same with `a` or `b`.

void vfadd_avx2(float *a, float *b, float *out, unsigned size);
void vfsub_avx2(float *a, float *b, float *out, unsigned size);
void vfmul_avx2(float *a, float *b, float *out, unsigned size);
void vfdiv_avx2(float *a, float *b, float *out, unsigned size);

// Note that `stop` is not provided.
void vflinspace_avx2(float *out, float start, float step, unsigned size);

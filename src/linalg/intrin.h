// When not explicitly stated otherwise, `size` is assumed to be a multiple of 16,
// and addresses must be 32-byte aligned.

// For these functions,
// `out` can never partially overlap with either `a` or `b`,
// but it's allowed to be exactly the same with `a` or `b`.

void vfadd_avx2(float *a, float *b, float *out, unsigned size);
void vfsub_avx2(float *a, float *b, float *out, unsigned size);
void vfmul_avx2(float *a, float *b, float *out, unsigned size);
void vfdiv_avx2(float *a, float *b, float *out, unsigned size);

void vfaddf_avx2(float *a, float num, float *out, unsigned size);
void vfsubf_avx2(float *a, float num, float *out, unsigned size);
void vfmulf_avx2(float *a, float num, float *out, unsigned size);
void vfdivf_avx2(float *a, float num, float *out, unsigned size);

// Note that `stop` is not provided.
void vflinspace_avx2(float *out, float start, float step, unsigned size);
void vflinspace_avx2_acc(float *out, float start, float step, unsigned size);

float vfsum_avx2(const float *out, unsigned size);
float vfdot_avx2(const float *x, const float *y, unsigned size);

void mfadd_avx2(float *a, float *b, float *out, unsigned int r, unsigned int c);

// These are actually not intrinsics; normal C will do.
unsigned round16(unsigned x);
unsigned round16down(unsigned x);

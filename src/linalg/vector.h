typedef struct vector {
  float *dat;
  unsigned cap;
  unsigned sz;
} vector_t;

void vec_add_inplace(vector_t *self, vector_t other);
void vec_sub_inplace(vector_t *self, vector_t other);
void vec_mul_inplace(vector_t *self, vector_t other);
void vec_div_inplace(vector_t *self, vector_t other);

void vec_add_inplace_f(vector_t *self, float num);
void vec_sub_inplace_f(vector_t *self, float num);
void vec_mul_inplace_f(vector_t *self, float num);
void vec_div_inplace_f(vector_t *self, float num);

void vec_add(vector_t *self, vector_t a, vector_t b);
void vec_sub(vector_t *self, vector_t a, vector_t b);
void vec_mul(vector_t *self, vector_t a, vector_t b);
void vec_div(vector_t *self, vector_t a, vector_t b);

void vec_linspace(vector_t *self, float start, float end, unsigned size);

void vec_create(vector_t *self);
void vec_release(vector_t self);
void vec_reserve(vector_t *self, unsigned size);

float vec_sum(vector_t self);
float vec_dot(vector_t x, vector_t y);

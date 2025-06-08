typedef struct matrix {
  // Row-major format.
  // Every row is padded to a multiple of 16 floats (64 bytes).
  // The total space taken up is, of course, a multiple of 64 bytes.
  float *dat;
  
  // Rows and columns.
  unsigned r, c;
  unsigned cap;
} matrix_t;

void mat_create(matrix_t *self);
void mat_release(matrix_t self);
void mat_reserve(matrix_t *self, unsigned size);

void mat_add_inplace(matrix_t *self, matrix_t other);

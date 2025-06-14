import numpy as np;
import time;

SIZE = 1048576
REPEAT = 50

x = np.fromfunction(lambda i, j: i * 1.028 - j * 0.906, (500, 500), dtype=float)
y = np.fromfunction(lambda i, j: i * -0.775 + j * 1.313, (500, 500), dtype=float)

# Warm-up
mat = x @ y

start = time.perf_counter()
for _ in range(REPEAT):
  mat = x @ y
end = time.perf_counter()

# 2339240487062
print(np.sum(mat))
print(f"time: {(end - start) * 1000000 / REPEAT:.2f} us")
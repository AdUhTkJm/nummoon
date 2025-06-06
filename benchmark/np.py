#!/bin/python3
import numpy as np
import time

SIZE = 1024000
REPEAT = 10000

a = np.arange(SIZE, dtype=np.float32) * 0.001
b = np.arange(SIZE, dtype=np.float32) * 0.002

# Warm-up
a += b

start = time.perf_counter()
for _ in range(REPEAT):
  a += b
end = time.perf_counter()

print(f"time: {(end - start) * 1000000:.2f} us")

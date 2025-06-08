#!/bin/python3
import numpy as np
import time

SIZE = 1048576
REPEAT = 1000

a = np.linspace(0.2795, 6.8704, 1048576, dtype=np.float32)
b = np.linspace(-1.6269, 3.5057, 1048576, dtype=np.float32)

# Warm-up
a.dot(b)

start = time.perf_counter()
for _ in range(REPEAT):
  sum = a.dot(b)
end = time.perf_counter()

# 6477271.5
print(sum)
print(f"time: {(end - start) * 1000000 / REPEAT:.2f} us")

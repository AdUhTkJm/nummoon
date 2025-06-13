# AdUhTkJm/nummoon

This is a high-speed numerical library, in its very early stage.

To enable the SIMD operations, it is required that you are compiling with native backend. Currently, it makes following assumptions:

- You're using System-V ABI, which is the ABI used on most Unix distributions;
- You're using x86 with AVX-2 enabled.

When native backend is not enabled, the library falls back to a Moonbit implementation. However, this will experience much slow down. See [benchmark](#benchmark) as an example.

If you're willing to, I'm welcome for contributions.

## Examples

### Vectors

NOTE: The vectors are all float vectors.

The operators can only accept two identical types, due to constraints of the Moonbit language.

```mbt
let x = Vector::arange(6);
let y = Vector::arange(6);

inspect(x + y, content="[0, 2, 4, 6, 8, 10]");
inspect(x - y, content="[0, 0, 0, 0, 0, 0]");
inspect(x * y, content="[0, 1, 4, 9, 16, 25]");
inspect(x / y, content="[NaN, 1, 1, 1, 1, 1]");
```

For broadcasting, please use the methods of type `Vector`, which will modify the object in-place:

```mbt
let x = Vector::arange(6);
let y = Vector::arange(6);

inspect(x.add(y),   content="[0, 2, 4, 6, 8, 10]");
inspect(x.add(1.F), content="[1, 3, 5, 7, 9, 11]");
inspect(x.add(1),   content="[2, 4, 6, 8, 10, 12]");
```

If you wish to preserve the vector, use `clone()`.

```mbt
let x = Vector::from_array([2, 5, 7, 8, 9, 3]);
let y = x.clone();
y.sub(1).ignore(); // Changes `y`, but `x` will not change.
inspect(x, content="[2, 5, 7, 8, 9, 3]");
```

Otherwise, a direct assignment will only capture reference:

```mbt
let x = Vector::from_array([2, 5, 7, 8, 9, 3]);
let y = x;
y.mul(2).ignore(); // Now `y` and `x` will both change.
inspect(x, content="[4, 10, 14, 16, 18, 6]");
```

### Matrices

Normal arithmetic of matrices are like vectors.

```mbt
let x = Matrix::from_array([[1, 2], [3, 4]]);
let y = Matrix::from_array([[5, 6], [7, 8]]);
inspect(x.rows(), content="2");
inspect(x.cols(), content="2");

inspect(x + y, content="[[6, 8], [10, 12]]");
inspect(x - y, content="[[-4, -4], [-4, -4]]");
inspect(x * y, content="[[5, 12], [21, 32]]");
// Float will lose precision at about 7th digit.
inspect(x / y, content="[[0.20000000298023224, 0.3333333432674408], [0.4285714328289032, 0.5]]");
```

Similarly, `add`, `sub`, `mul` and `div` will modify the matrix inplace.

For matrix multiplication, use `mmul`. It will allocate a new matrix without modifying the sources, as it is usually undesirable to also change the source size.

```mbt
let x = Matrix::from_array([[1, 2, 3], [4, 5, 6]]);
let y = Matrix::from_array([[7, 8], [9, 10], [11, 12]]);
inspect(x.mmul(y), content="[[58, 64], [139, 154]]");
// `x` and `y` remain unchanged
```

## Benchmark

We will compare between Moonbit fallback implementation of WASM-GC backend, the native AVX-2 implementaion, and the well-known python library `numpy`. We will present the Moonbit benchmark here; for the python benchmark, please visit the [repository](https://github.com/AdUhTkJm/nummoon/tree/main/benchmark).

*Why comparing WASM-GC with native?* Actually, I tried to run the fallback implementation on native backend as well. However, the result turned out to be that Moonbit's native backend is extremely slow: it will experience ~20x slow down compared to WASM-GC when executing the following benchmarks. The reason is still unclear to me (did Moonbit interpret the C code rather than compile and execute?). If you have any idea, please file an issue in the repository, and I would appreciate your help.

In the following sections, we will also calculate the speedup brought by the native to fallback implementation.

(CPU: AMD Ryzen 9 7945HX)

### Addition

```mbt
test "benchmark_add" {
  let summary = @bench.single_bench(fn () {
    let n = 1048576;
    let c = Vector::zeroes(n);
    let a = Vector::arange(n.to_float());
    for i = 0; i < 1000; i = i + 1 {
      c.add(a).ignore();
    }
    println(c.sum());
  });
  println(summary.to_json().stringify());
}
```

Output comparison:

- Moonbit WASM-GC implementation: 1301093.91 us
- Native AVX-2 implementation: 70971.59 us
- Numpy: 75820.92 us

Speedup: 13.8x

### Dot product

```mbt
test "benchmark_dot" {
  let x = Vector::linspace(0.2795, 6.8704, 1048576);
  let y = Vector::linspace(-1.6269, 3.5057, 1048576);
  let mut sum = 0.F;
  let summary = @bench.single_bench(fn () {
    sum += x.dot(y);
  });
  println(sum);
  println(summary.to_json().stringify());
}
```

Output comparison:

- Moonbit WASM-GC implementation: 2551.06 us
- Native AVX-2 implementation: 82.66 us
- Numpy: 639.09 us

Speedup: 30.9x

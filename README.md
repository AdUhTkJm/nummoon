# AdUhTkJm/nummoon

This is a high-speed numerical library, in its very early stage.

To enable the SIMD operations, it is required that you are compiling with native backend. Currently, it makes following assumptions:

- You're using System-V ABI, which is the ABI used on most Unix distributions;
- You're using x86 with AVX-2 enabled.

When native backend is not enabled, the library falls back to a Moonbit implementation. However, this will experience much slow down. See [benchmark](#benchmark) as an example.

If you're willing to, I'm welcome for contributions.

## Examples

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
y.sub(1); // Changes `y`, but `x` will not change.
inspect(x, content="[2, 5, 7, 8, 9, 3]");
```

Otherwise, a direct assignment will only capture reference:

```mbt
let x = Vector::from_array([2, 5, 7, 8, 9, 3]);
let y = x;
y.mul(2); // Now `y` and `x` will both change.
inspect(x, content="[4, 10, 14, 16, 18, 6]");
```

## Benchmark

We will compare between Moonbit fallback implementation of WASM-GC backend, the native AVX-2 implementaion, and the well-known python library `numpy`. We will present the Moonbit benchmark here; for the python benchmark, please visit the [repository](https://github.com/AdUhTkJm/nummoon/tree/main/benchmark).

We will also calculate the speedup between the native and fallback.

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

# AdUhTkJm/nummoon

This is a high-speed native numerical library, in its very early stage.

Currently it only supports System-V ABI, which is the ABI used on most Unix distributions. It also assumes x86, and assumes that you have AVX-2 enabled.

Other than those prerequisites, there's nothing extra to set up.

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

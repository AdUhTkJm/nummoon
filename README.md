# AdUhTkJm/nummoon

This is a high-speed native numerical library.

Currently it only supports System-V ABI, which is the ABI used on most Unix distributions. It also assumes x86, and assumes that you have AVX-2 enabled.

Other than those prerequisites, there's nothing extra to set up.

If you're willing to, I'm welcome for contributions.

### Examples

The operators can only accept two identical types, due to constraints of the Moonbit language.

```mbt
let x = Vector::linspace(6);
let y = Vector::linspace(6);

inspect(x + y, content="[0, 2, 4, 6, 8, 10]");
inspect(x - y, content="[0, 0, 0, 0, 0, 0]");
inspect(x * y, content="[0, 1, 4, 9, 16, 25]");
inspect(x / y, content="[NaN, 1, 1, 1, 1, 1]");
```

For broadcasting, please use the methods of type `Vector`, which will modify the object in-place:

```mbt
let x = Vector::linspace(6);
let y = Vector::linspace(6);

inspect(x.add(y),   content="[0, 2, 4, 6, 8, 10]");
inspect(x.add(1.F), content="[1, 3, 5, 7, 9, 11]");
inspect(x.add(1),   content="[2, 4, 6, 8, 10, 12]");
```

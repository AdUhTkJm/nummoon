///| Pointwise (element-wise) operable with a vector.
/// By default, Int, Float and Vector implement this trait.
pub(open) trait VPointwiseOperable {
  add_inplace(Vector, Self) -> Unit
  sub_inplace(Vector, Self) -> Unit
  mul_inplace(Vector, Self) -> Unit
  div_inplace(Vector, Self) -> Unit
};

// ======= Int =======

pub impl VPointwiseOperable for Int with add_inplace(v: Vector, self: Int) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] += self.to_float();
  }
}

pub impl VPointwiseOperable for Int with sub_inplace(v: Vector, self: Int) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] -= self.to_float();
  }
}

pub impl VPointwiseOperable for Int with mul_inplace(v: Vector, self: Int) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] *= self.to_float();
  }
}

pub impl VPointwiseOperable for Int with div_inplace(v: Vector, self: Int) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] /= self.to_float();
  }
}

// ======= Float =======

pub impl VPointwiseOperable for Float with add_inplace(v: Vector, self: Float) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] += self;
  }
}

pub impl VPointwiseOperable for Float with sub_inplace(v: Vector, self: Float) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] -= self;
  }
}

pub impl VPointwiseOperable for Float with mul_inplace(v: Vector, self: Float) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] *= self;
  }
}

pub impl VPointwiseOperable for Float with div_inplace(v: Vector, self: Float) -> Unit {
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] /= self;
  }
}

// ======= Vector =======

pub impl VPointwiseOperable for Vector with add_inplace(v: Vector, self: Vector) -> Unit {
  guard v.size() == self.size();
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] += self.data[i];
  }
}

pub impl VPointwiseOperable for Vector with sub_inplace(v: Vector, self: Vector) -> Unit {
  guard v.size() == self.size();
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] -= self.data[i];
  }
}

pub impl VPointwiseOperable for Vector with mul_inplace(v: Vector, self: Vector) -> Unit {
  guard v.size() == self.size();
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] *= self.data[i];
  }
}

pub impl VPointwiseOperable for Vector with div_inplace(v: Vector, self: Vector) -> Unit {
  guard v.size() == self.size();
  for i = 0; i < v.data.length(); i = i + 1 {
    v.data[i] /= self.data[i];
  }
}

pub struct Vector {
  data: Array[Float];
};

pub impl Show for Vector with to_string(self) -> String {
  return self.data.to_string();
}

pub impl Show for Vector with output(self, logger: &Logger) -> Unit {
  logger.write_string(self.to_string());
}

pub impl Add for Vector with op_add(self: Vector, other: Vector) -> Vector {
  let copied = self.clone();
  return { data: copied.add(other).data };
}

pub impl Sub for Vector with op_sub(self: Vector, other: Vector) -> Vector {
  let copied = self.clone();
  return { data: copied.sub(other).data };
}

pub impl Mul for Vector with op_mul(self: Vector, other: Vector) -> Vector {
  let copied = self.clone();
  return { data: copied.mul(other).data };
}

pub impl Div for Vector with op_div(self: Vector, other: Vector) -> Vector {
  let copied = self.clone();
  return { data: copied.div(other).data };
}

///| Add inplace. Returns a reference to self.
pub fn[T: VPointwiseOperable] Vector::add(self: Vector, other: T) -> Vector {
  T::add_inplace(self, other);
  return self;
}

///| Subtract inplace. Returns a reference to self.
pub fn[T: VPointwiseOperable] Vector::sub(self: Vector, other: T) -> Vector {
  T::sub_inplace(self, other);
  return self;
}

///| Multiply inplace. Returns a reference to self.
pub fn[T: VPointwiseOperable] Vector::mul(self: Vector, other: T) -> Vector {
  T::mul_inplace(self, other);
  return self;
}

///| Divide inplace. Returns a reference to self.
pub fn[T: VPointwiseOperable] Vector::div(self: Vector, other: T) -> Vector {
  T::div_inplace(self, other);
  return self;
}

///| Create a vector containing numbers from 0 (inclusive) to stop (exclusive).
/// 
/// WARNING: The function panics when `stop` is greater than 16777216. See `linspace()` for explanation.
/// 
/// **Example**:
/// ```mbt
/// let x = Vector::arange(6);
/// println(x); // [0, 1, 2, 3, 4, 5]
/// let x = Vector::arange(6.5);
/// println(x); // [0, 1, 2, 3, 4, 5, 6]
/// ```
pub fn Vector::arange(stop: Float) -> Vector {
  let s = stop.ceil().to_int();
  let data = Array::new(capacity = s);
  for i = 0; i < s; i = i + 1 {
    data.push(i.to_float());
  }
  return { data: data };
}

test "arithmetic" {
  let x = Vector::arange(6);
  let y = Vector::arange(6);

  inspect(x + y, content="[0, 2, 4, 6, 8, 10]");
  inspect(x - y, content="[0, 0, 0, 0, 0, 0]");
  inspect(x * y, content="[0, 1, 4, 9, 16, 25]");
  inspect(x / y, content="[NaN, 1, 1, 1, 1, 1]");

  inspect(x.add(y),   content="[0, 2, 4, 6, 8, 10]");
  inspect(x.add(1.F), content="[1, 3, 5, 7, 9, 11]");
  inspect(x.add(1),   content="[2, 4, 6, 8, 10, 12]");

  inspect(x.sub(y),   content="[2, 3, 4, 5, 6, 7]");
  inspect(x.sub(1.F), content="[1, 2, 3, 4, 5, 6]");
  inspect(x.sub(1),   content="[0, 1, 2, 3, 4, 5]");

  inspect(x.mul(y),   content="[0, 1, 4, 9, 16, 25]");
  inspect(x.mul(2.F), content="[0, 2, 8, 18, 32, 50]");
  inspect(x.mul(2),   content="[0, 4, 16, 36, 64, 100]");

  inspect(x.div(y),   content="[NaN, 4, 8, 12, 16, 20]");
  inspect(x.div(2.F), content="[NaN, 2, 4, 6, 8, 10]");
  inspect(x.div(2),   content="[NaN, 1, 2, 3, 4, 5]");
}


///| Create an empty vector.
pub fn Vector::new() -> Vector {
  return { data: [] };
}

///| Clone a vector.
pub fn Vector::clone(self: Vector) -> Vector {
  return { data: self.data.copy() };
}

///| Sums up all elements inside this vector.
pub fn Vector::sum(self: Vector) -> Float {
  let s = self.size().reinterpret_as_int();
  let mut sum = 0.F;
  for i = 0; i < s; i = i + 1 {
    sum += self.data[i];
  }
  return sum;
}

///| Creates a new vector from the array.
/// 
/// Data is copied from the argument; subsequent changes to the vector won't affect the array.
pub fn Vector::from_array(array: Array[Float]) -> Vector {
  return { data: array };
}

///| Creates a new vector from a fixed array.
/// 
/// Data is copied from the argument; subsequent changes to the vector won't affect the array.
pub fn Vector::from_fixed_array(array: FixedArray[Float]) -> Vector {
  return { data: Array::from_fixed_array(array) };
}

///| Returns the size (element count) of the vector.
pub fn Vector::size(self: Vector) -> UInt {
  return self.data.length().reinterpret_as_uint();
}

///| Returns the length (element count) of the vector,
/// and converts it to signed integer.
/// 
/// NOTE: this is **not** the norm of the vector.
/// To calculate the length of this vector in Euclidean space, use `norm()` instead.
pub fn Vector::length(self: Vector) -> Int {
  return self.data.length();
}

///| Retrieves the i'th element, starting from 0.
pub fn Vector::op_get(self: Vector, i: UInt) -> Float {
  guard i < self.size();
  return self.data[i.reinterpret_as_int()];
}

///| Sets the i'th element, starting from 0.
pub fn Vector::op_set(self: Vector, i: UInt, f: Float) -> Unit {
  guard i < self.size();
  self.data[i.reinterpret_as_int()] = f;
}

///| Create a vector filled with zeroes.
/// 
/// When `len < 0`, return an empty vector instead.
pub fn Vector::zeroes(len: Int) -> Vector {
  if (len < 0) {
    return Vector::new();
  }

  return { data: Array::make(len, 0) };
}

///| Ignores the result given by self-reference.
pub fn Vector::ignore(_: Vector) -> Unit {}

test "create" {
  let v = Vector::from_array([ 1, 9, 2, 8, 6, 4, 7, 5, 3 ]);
  inspect(v.sum(), content="45");

  let x = v.clone();
  x[1] = 0;
  inspect(x[1], content="0");
  inspect(v.sum(), content="45");
  inspect(x.sum(), content="36");

  let y = v;
  y[2] = 0;
  inspect(y.sum(), content="43");
  inspect(v.sum(), content="43");
}

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

///| Calculate dot product of two vectors.
pub fn Vector::dot(self: Vector, other: Vector) -> Float {
  guard self.size() == other.size();
  let mut sum = 0.F;
  for i = 0; i < self.length(); i = i + 1 {
    sum += self.data[i] * other.data[i];
  }
  return sum;
}

///| Calculate the L2 norm (the length in Euclidean space) of the vector.
pub fn Vector::norm(self: Vector) -> Float {
  return self.dot(self).sqrt();
}

///| Calculate the cosine value between two vectors.
pub fn Vector::cos_between(self: Vector, other: Vector) -> Float {
  return self.dot(other) / (self.norm() * other.norm());
}

///| Create a vector containing numbers from `start` to `stop`, with a total of `num` elements.
/// 
/// The i'th element of the result vector is `start + i * step`,
/// where `step` is equal to `(stop - start) / (num - 1)`.
/// 
/// Note that there might be some difference because of the limited precision of float.
///  
/// WARNING: When supplied `num > 16777216` (which is 2^24), the function panics. Beyond that number,
/// `float` cannot precisely represent integers. As a workaround, concatenate multiple vectors together
/// if you need such long vectors. 
/// 
/// The restriction does not apply to the fallback implementation. However, for compatibility, it is
/// still recommended to not supply an overly large argument.
pub fn Vector::linspace(start: Float, stop: Float, num: Int) -> Vector {
  if (num == 1) {
    return { data: [start] };
  }

  let step = (stop - start) / (num.to_float() - 1);
  let data = Array::new(capacity=num);
  for i = 0; i < num; i = i + 1 {
    data.push(start + i.to_float() * step);
  }
  return { data: data }
}

test "dot" {
  let x = Vector::from_array([3, 4]);
  inspect(x.norm(), content="5");

  let y = Vector::linspace(0, 6.4, 5);
  inspect(y, content="[0, 1.600000023841858, 3.200000047683716, 4.800000190734863, 6.400000095367432]");
  let z = Vector::arange(5);
  inspect(y.dot(z), content="48");
}

test "benchmark_dot" {
  let x = Vector::linspace(0.2795, 6.8704, 1048576);
  let y = Vector::linspace(-1.6269, 3.5057, 1048576);
  let mut sum = 0.F;
  let summary = @bench.single_bench(fn () {
    sum = x.dot(y);
  });
  inspect(sum, content="6477421");
  println(summary.to_json().stringify());
}

///| Create a view from internal data type.
fn Vector::view(data: Array[Float]) -> Vector {
  return { data: data };
}

extern type CVector;

extern "C" fn vfcreate() -> CVector = "mbt_vfcreate";
extern "C" fn vf2mbtarr(vec: CVector) -> FixedArray[Float] = "mbt_vf2mbtarr";
extern "C" fn vflinspace(vec: CVector, start: Float, stop: Float, size: Int) -> Unit = "mbt_vflinspace";
extern "C" fn vfaddeq(vec: CVector, vec2: CVector) -> Unit = "mbt_vfaddeq";
extern "C" fn vfsubeq(vec: CVector, vec2: CVector) -> Unit = "mbt_vfsubeq";
extern "C" fn vfmuleq(vec: CVector, vec2: CVector) -> Unit = "mbt_vfmuleq";
extern "C" fn vfdiveq(vec: CVector, vec2: CVector) -> Unit = "mbt_vfdiveq";
extern "C" fn vfadd(tgt: CVector, vev: CVector, vec2: CVector) -> Unit = "mbt_vfadd";
extern "C" fn vfsub(tgt: CVector, vev: CVector, vec2: CVector) -> Unit = "mbt_vfsub";
extern "C" fn vfmul(tgt: CVector, vev: CVector, vec2: CVector) -> Unit = "mbt_vfmul";
extern "C" fn vfdiv(tgt: CVector, vev: CVector, vec2: CVector) -> Unit = "mbt_vfdiv";
extern "C" fn vfcopy(vec: CVector) -> CVector = "mbt_vfcopy";

pub struct Vector {
  priv data: CVector;
};

pub impl Show for Vector with to_string(self) -> String {
  return vf2mbtarr(self.data).to_string();
}

pub impl Show for Vector with output(self, logger: &Logger) -> Unit {
  logger.write_string(self.to_string());
}

pub impl Add for Vector with op_add(self: Vector, other: Vector) -> Vector {
  let copied = vfcreate();
  vfadd(copied, self.data, other.data);
  return { data: copied };
}

pub impl Sub for Vector with op_sub(self: Vector, other: Vector) -> Vector {
  let copied = vfcreate();
  vfsub(copied, self.data, other.data);
  return { data: copied };
}

pub impl Mul for Vector with op_mul(self: Vector, other: Vector) -> Vector {
  let copied = vfcreate();
  vfmul(copied, self.data, other.data);
  return { data: copied };
}

pub impl Div for Vector with op_div(self: Vector, other: Vector) -> Vector {
  let copied = vfcreate();
  vfdiv(copied, self.data, other.data);
  return { data: copied };
}

///| Add inplace. Returns a reference to self.
pub fn Vector::add(self: Vector, other: Vector) -> Vector {
  vfaddeq(self.data, other.data);
  return self;
}

///| Subtract inplace. Returns a reference to self.
pub fn Vector::sub(self: Vector, other: Vector) -> Vector {
  vfsubeq(self.data, other.data);
  return self;
}

///| Multiply inplace. Returns a reference to self.
pub fn Vector::mul(self: Vector, other: Vector) -> Vector {
  vfmuleq(self.data, other.data);
  return self;
}

///| Divide inplace. Returns a reference to self.
pub fn Vector::div(self: Vector, other: Vector) -> Vector {
  vfdiveq(self.data, other.data);
  return self;
}

///| Create a vector containing numbers from 0 (inclusive) to stop (exclusive).
/// **Example**:
/// ```mbt
/// let x = Vector::linspace(6);
/// println(x); // [0, 1, 2, 3, 4, 5]
/// let x = Vector::linspace(6.5);
/// println(x); // [0, 1, 2, 3, 4, 5, 6]
/// ```
pub fn Vector::linspace(stop: Float) -> Vector {
  let data = vfcreate();
  let s = stop.ceil().to_int();
  vflinspace(data, 0, (s - 1).to_float(), s);
  return {
    data: data
  };
}

///| Create an empty vector.
pub fn Vector::new() -> Vector {
  return {
    data: vfcreate()
  };
}

test {
  let x = Vector::linspace(6);
  let y = Vector::linspace(6);

  inspect(x + y, content="[0, 2, 4, 6, 8, 10]");
  inspect(x - y, content="[0, 0, 0, 0, 0, 0]");
  inspect(x * y, content="[0, 1, 4, 9, 16, 25]");
  inspect(x / y, content="[NaN, 1, 1, 1, 1, 1]");
  inspect(x.add(y), content="[0, 2, 4, 6, 8, 10]");
  inspect(x.sub(y), content="[0, 1, 2, 3, 4, 5]");
  inspect(x.mul(y), content="[0, 1, 4, 9, 16, 25]");
  inspect(x.div(y), content="[NaN, 1, 2, 3, 4, 5]");
}

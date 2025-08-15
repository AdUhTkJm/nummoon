///|
#external
type CMatrix

///|
extern "C" fn mfaddeq(x : CMatrix, y : CMatrix) -> Unit = "mbt_mfaddeq"

///|
extern "C" fn mfsubeq(x : CMatrix, y : CMatrix) -> Unit = "mbt_mfsubeq"

///|
extern "C" fn mfmuleq(x : CMatrix, y : CMatrix) -> Unit = "mbt_mfmuleq"

///|
extern "C" fn mfdiveq(x : CMatrix, y : CMatrix) -> Unit = "mbt_mfdiveq"

///|
extern "C" fn mfadd(tgt : CMatrix, x : CMatrix, y : CMatrix) -> Unit = "mbt_mfadd"

///|
extern "C" fn mfsub(tgt : CMatrix, x : CMatrix, y : CMatrix) -> Unit = "mbt_mfsub"

///|
extern "C" fn mfmul(tgt : CMatrix, x : CMatrix, y : CMatrix) -> Unit = "mbt_mfmul"

///|
extern "C" fn mfdiv(tgt : CMatrix, x : CMatrix, y : CMatrix) -> Unit = "mbt_mfdiv"

///|
extern "C" fn mfmmul(x : CMatrix, y : CMatrix) -> CMatrix = "mbt_mfmmul"

///|
extern "C" fn mfcreate() -> CMatrix = "mbt_mfcreate"

///|
extern "C" fn mfcopyf(arr : FixedArray[FixedArray[Float]]) -> CMatrix = "mbt_mfcopyf"

///|
extern "C" fn mf2mbtarr(x : CMatrix) -> FixedArray[Float] = "mbt_mf2mbtarr"

///|
extern "C" fn mfrows(x : CMatrix) -> Int = "mbt_mfrows"

///|
extern "C" fn mfcols(x : CMatrix) -> Int = "mbt_mfcols"

///|
extern "C" fn mfviewv(x : CMatrix, i : Int) -> CVector = "mbt_mfviewv"

///| Pointwise (element-wise) operable with a matrix.
/// By default, Int, Float and Vector implement this trait.
pub(open) trait MPointwiseOperable {
  add_inplace(Matrix, Self) -> Unit
  sub_inplace(Matrix, Self) -> Unit
  mul_inplace(Matrix, Self) -> Unit
  div_inplace(Matrix, Self) -> Unit
}

// ======= Matrix =======

///|
pub impl MPointwiseOperable for Matrix with add_inplace(
  mat : Matrix,
  self : Matrix,
) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols()
  mfaddeq(mat.data, self.data)
}

///|
pub impl MPointwiseOperable for Matrix with sub_inplace(
  mat : Matrix,
  self : Matrix,
) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols()
  mfsubeq(mat.data, self.data)
}

///|
pub impl MPointwiseOperable for Matrix with mul_inplace(
  mat : Matrix,
  self : Matrix,
) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols()
  mfmuleq(mat.data, self.data)
}

///|
pub impl MPointwiseOperable for Matrix with div_inplace(
  mat : Matrix,
  self : Matrix,
) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols()
  mfdiveq(mat.data, self.data)
}

///|
pub struct Matrix {
  data : CMatrix
}

///| Adds in-place.
pub fn[T : MPointwiseOperable] Matrix::add(self : Matrix, other : T) -> Matrix {
  T::add_inplace(self, other)
  return self
}

///| Returns the number of rows in the matrix.
pub fn Matrix::rows(self : Matrix) -> Int {
  return mfrows(self.data)
}

///| Returns the number of columns in the matrix.
pub fn Matrix::cols(self : Matrix) -> Int {
  return mfcols(self.data)
}

///| Creates an empty matrix.
pub fn Matrix::new() -> Matrix {
  return { data: mfcreate() }
}

///|
pub fn Matrix::from_array(arr : Array[Array[Float]]) -> Matrix {
  let fixed = FixedArray::from_array(arr.map(FixedArray::from_array))
  return { data: mfcopyf(fixed) }
}

///|
pub impl Show for Matrix with to_string(self) -> String {
  let flattened = mf2mbtarr(self.data)
  // Un-flatten the array.
  let rows = self.rows()
  let cols = self.cols()
  let array = Array::new(capacity=rows)
  for i = 0; i < rows; i = i + 1 {
    array.push(Array::make(cols, 0.F))
  }
  for i = 0; i < rows; i = i + 1 {
    for j = 0; j < cols; j = j + 1 {
      array[i][j] = flattened[i * cols + j]
    }
  }
  return array.to_string()
}

///|
pub impl Show for Matrix with output(self, logger) -> Unit {
  return logger.write_string(self.to_string())
}

///|
pub impl Add for Matrix with op_add(self : Matrix, other : Matrix) -> Matrix {
  let copied = mfcreate()
  mfadd(copied, self.data, other.data)
  return { data: copied }
}

///|
pub impl Sub for Matrix with op_sub(self : Matrix, other : Matrix) -> Matrix {
  let copied = mfcreate()
  mfsub(copied, self.data, other.data)
  return { data: copied }
}

///|
pub impl Mul for Matrix with op_mul(self : Matrix, other : Matrix) -> Matrix {
  let copied = mfcreate()
  mfmul(copied, self.data, other.data)
  return { data: copied }
}

///|
pub impl Div for Matrix with op_div(self : Matrix, other : Matrix) -> Matrix {
  let copied = mfcreate()
  mfdiv(copied, self.data, other.data)
  return { data: copied }
}

///|
test "arithmetic" {
  let x = Matrix::from_array([[1, 2], [3, 4]])
  let y = Matrix::from_array([[5, 6], [7, 8]])
  inspect(x.rows(), content="2")
  inspect(x.cols(), content="2")
  inspect(x + y, content="[[6, 8], [10, 12]]")
  inspect(x - y, content="[[-4, -4], [-4, -4]]")
  inspect(x * y, content="[[5, 12], [21, 32]]")
  // Float will lose precision at about 7th digit.
  inspect(
    x / y,
    content="[[0.20000000298023224, 0.3333333432674408], [0.4285714328289032, 0.5]]",
  )
}

///| Matrix multiplication. Returns a new matrix without changing self.
pub fn Matrix::mmul(self : Matrix, other : Matrix) -> Matrix {
  return { data: mfmmul(self.data, other.data) }
}

///|
test "mmul" {
  let x = Matrix::from_array([[1, 2, 3], [4, 5, 6]])
  let y = Matrix::from_array([[7, 8], [9, 10], [11, 12]])
  inspect(x.mmul(y), content="[[58, 64], [139, 154]]")
}

///| Returns the sum of every element in the matrix.
pub fn Matrix::sum(self : Matrix) -> Float {
  return self.sum_rows().sum()
}

///| Returns the sum of every column.
/// 
/// This will result in a vector with dimension equal to `self.rows()`.
pub fn Matrix::sum_rows(self : Matrix) -> Vector {
  if self.rows() < 1 {
    return Vector::new()
  }
  let vec = self[0].clone()
  for i = 1; i < self.rows(); i = i + 1 {
    vec.add(self[i]).ignore()
  }
  return vec
}

///|
pub fn Matrix::op_get(self : Matrix, i : Int) -> Vector {
  guard i >= 0 && i <= self.rows()
  return { data: mfviewv(self.data, i) }
}

///|
test "sum" {
  let x = Matrix::from_array([[1, 2, 3], [4, 5, 6]])
  inspect(x.sum(), content="21")
  inspect(x.sum_rows(), content="[5, 7, 9]")
}

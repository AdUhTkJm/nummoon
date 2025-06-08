extern type CMatrix;

extern "C" fn mfaddeq(x: CMatrix, y: CMatrix) -> Unit = "mbt_mfaddeq";
extern "C" fn mfcreate() -> CMatrix = "mbt_mfcreate";
extern "C" fn mfcopyf(arr: FixedArray[FixedArray[Float]]) -> CMatrix = "mbt_mfcopyf";
extern "C" fn mf2mbtarr(x: CMatrix) -> FixedArray[Float] = "mbt_mf2mbtarr";
extern "C" fn mfrows(x: CMatrix) -> Int = "mbt_mfrows";
extern "C" fn mfcols(x: CMatrix) -> Int = "mbt_mfcols";

///| Pointwise (element-wise) operable with a matrix.
/// By default, Int, Float and Vector implement this trait.
pub(open) trait MPointwiseOperable {
  add_inplace(Matrix, Self) -> Unit
  sub_inplace(Matrix, Self) -> Unit
  mul_inplace(Matrix, Self) -> Unit
  div_inplace(Matrix, Self) -> Unit
};

// ======= Matrix =======

pub impl MPointwiseOperable for Matrix with add_inplace(mat: Matrix, self: Matrix) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols();
  mfaddeq(mat.data, self.data);
}

pub impl MPointwiseOperable for Matrix with sub_inplace(mat: Matrix, self: Matrix) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols();
}

pub impl MPointwiseOperable for Matrix with mul_inplace(mat: Matrix, self: Matrix) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols();
}

pub impl MPointwiseOperable for Matrix with div_inplace(mat: Matrix, self: Matrix) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols();
}

pub struct Matrix {
  data: CMatrix
};

///| Adds in-place.
pub fn[T: MPointwiseOperable] Matrix::add(self: Matrix, other: T) -> Matrix {
  T::add_inplace(self, other);
  return self;
}

///| Returns the number of rows in the matrix.
pub fn Matrix::rows(self: Matrix) -> Int {
  return mfrows(self.data);
}

///| Returns the number of columns in the matrix.
pub fn Matrix::cols(self: Matrix) -> Int {
  return mfcols(self.data);
}

///| Creates an empty matrix.
pub fn Matrix::new() -> Matrix {
  return { data: mfcreate() };
}

pub fn Matrix::from_array(arr: Array[Array[Float]]) -> Matrix {
  let fixed = FixedArray::from_array(arr.map(FixedArray::from_array));
  return { data: mfcopyf(fixed) };
}

pub impl Show for Matrix with to_string(self) -> String {
  let flattened = mf2mbtarr(self.data);
  // Un-flatten the array.
  let rows = self.rows();
  let cols = self.cols();
  let array = Array::new(capacity=rows);
  for i = 0; i < rows; i = i + 1 {
    array.push(Array::make(cols, 0.F));
  }
  for i = 0; i < rows; i = i + 1 {
    for j = 0; j < cols; j = j + 1 {
      array[i][j] = flattened[i * cols + j];
    }
  }
  return array.to_string();
}

pub impl Show for Matrix with output(self, logger) -> Unit {
  return logger.write_string(self.to_string());
}

test "arithmetic" {
  let x = Matrix::from_array([[1, 2], [3, 4]]);
  let y = Matrix::from_array([[5, 6], [7, 8]]);
  inspect(x.add(y), content="[[6, 8], [10, 12]]");
}

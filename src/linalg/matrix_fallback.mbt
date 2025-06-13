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
  for i = 0; i < mat.rows(); i = i + 1 {
    for j = 0; j < mat.cols(); j = j + 1 {
      mat.data[i][j] += self.data[i][j];
    }
  }
}

pub impl MPointwiseOperable for Matrix with sub_inplace(mat: Matrix, self: Matrix) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols();
  for i = 0; i < mat.rows(); i = i + 1 {
    for j = 0; j < mat.cols(); j = j + 1 {
      mat.data[i][j] -= self.data[i][j];
    }
  }
}

pub impl MPointwiseOperable for Matrix with mul_inplace(mat: Matrix, self: Matrix) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols();
  for i = 0; i < mat.rows(); i = i + 1 {
    for j = 0; j < mat.cols(); j = j + 1 {
      mat.data[i][j] *= self.data[i][j];
    }
  }
}

pub impl MPointwiseOperable for Matrix with div_inplace(mat: Matrix, self: Matrix) -> Unit {
  guard self.rows() == mat.rows() && self.cols() == mat.cols();
  for i = 0; i < mat.rows(); i = i + 1 {
    for j = 0; j < mat.cols(); j = j + 1 {
      mat.data[i][j] /= self.data[i][j];
    }
  }
}

pub struct Matrix {
  data: Array[Array[Float]]
};

///| Creates an empty matrix.
pub fn Matrix::new() -> Matrix {
  return { data: [] };
}

///| Creates a matrix from the given array.
/// 
/// The array must be homogeneous, or in other words, each of its sub-arrays must have the same length.
pub fn Matrix::from_array(arr: Array[Array[Float]]) -> Matrix {
  if (arr.length() == 0) {
    return Matrix::new();
  }
  let cols = arr[0].length();
  for i = 1; i < arr.length(); i = i + 1 {
    guard cols == arr[i].length();
  }

  return { data: arr };
}
///| Returns the number of rows in the matrix.
pub fn Matrix::rows(self: Matrix) -> Int {
  return self.data.length();
}

///| Returns the number of columns in the matrix.
pub fn Matrix::cols(self: Matrix) -> Int {
  if (self.rows() == 0) {
    return 0;
  }

  return self.data[0].length();
}

///| Returns the i'th row vector.
/// 
/// For column vector, use `col(i: Int)`.
/// It is not recommended to use `transpose()[i]` as that would be very slow.
pub fn Matrix::op_get(self: Matrix, i: Int) -> Vector {
  return Vector::view(self.data[i]);
}

///| Creates a matrix with data copied from `self`.
pub fn Matrix::clone(self: Matrix) -> Matrix {
  let copied = Array::makei(self.data.length(), fn (i) { self.data[i].copy() });
  return { data: copied };
}

///| Adds in-place.
pub fn[T: MPointwiseOperable] Matrix::add(self: Matrix, other: T) -> Matrix {
  T::add_inplace(self, other);
  return self;
}

pub fn[T: MPointwiseOperable] Matrix::sub(self: Matrix, other: T) -> Matrix {
  T::sub_inplace(self, other);
  return self;
}

pub fn[T: MPointwiseOperable] Matrix::mul(self: Matrix, other: T) -> Matrix {
  T::mul_inplace(self, other);
  return self;
}

pub fn[T: MPointwiseOperable] Matrix::div(self: Matrix, other: T) -> Matrix {
  T::div_inplace(self, other);
  return self;
}

pub impl Show for Matrix with to_string(self) -> String {
  return self.data.to_string();
}

pub impl Show for Matrix with output(self, logger) -> Unit {
  return logger.write_string(self.to_string());
}

pub impl Add for Matrix with op_add(self, other) -> Matrix {
  return self.clone().add(other);
}

pub impl Sub for Matrix with op_sub(self, other) -> Matrix {
  return self.clone().sub(other);
}

pub impl Mul for Matrix with op_mul(self, other) -> Matrix {
  return self.clone().mul(other);
}

pub impl Div for Matrix with op_div(self, other) -> Matrix {
  return self.clone().div(other);
}

test "arithmetic" {
  let x = Matrix::from_array([[1, 2], [3, 4]]);
  let y = Matrix::from_array([[5, 6], [7, 8]]);
  inspect(x.rows(), content="2");
  inspect(x.cols(), content="2");

  inspect(x + y, content="[[6, 8], [10, 12]]");
  inspect(x - y, content="[[-4, -4], [-4, -4]]");
  inspect(x * y, content="[[5, 12], [21, 32]]");
  // Float will lose precision at about 7th digit.
  inspect(x / y, content="[[0.20000000298023224, 0.3333333432674408], [0.4285714328289032, 0.5]]");
}

pub fn Matrix::zeroes(n: Int, m: Int) -> Matrix {
  if (n <= 0 || m <= 0) {
    return Matrix::new();
  }
  let data = Array::makei(n, fn (_) { Array::make(m, 0.F); });
  return { data: data };
}

///| Matrix multiplication. Returns a new matrix without changing self.
pub fn Matrix::mmul(self: Matrix, other: Matrix) -> Matrix {
  guard self.cols() == other.rows();
  let n = self.rows();
  let m = self.cols();
  let k_ = other.cols();
  let mat = Matrix::zeroes(n, k_);
  for k = 0; k < m; k = k + 1 {
    for i = 0; i < n; i = i + 1 {
      for j = 0; j < k_; j = j + 1 {
        mat.data[i][j] += self.data[i][k] * other.data[k][j];
      }
    }
  }
  return mat;
}

test "mmul" {
  let x = Matrix::from_array([[1, 2, 3], [4, 5, 6]]);
  let y = Matrix::from_array([[7, 8], [9, 10], [11, 12]]);
  inspect(x.mmul(y), content="[[58, 64], [139, 154]]");
}

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
  for i = 0; i < mat.rows(); i = i + 1 {
    for j = 0; j < mat.cols(); j = j + 1 {
      mat.data[i][j] += self.data[i][j];
    }
  }
}

pub impl MPointwiseOperable for Matrix with sub_inplace(mat: Matrix, self: Matrix) -> Unit {

}

pub impl MPointwiseOperable for Matrix with mul_inplace(mat: Matrix, self: Matrix) -> Unit {

}

pub impl MPointwiseOperable for Matrix with div_inplace(mat: Matrix, self: Matrix) -> Unit {

}

pub struct Matrix {
  data: Array[Array[Float]]
};

pub fn Matrix::new() -> Matrix {
  return { data: [] };
}

pub fn Matrix::rows(self: Matrix) -> Int {
  return self.data.length();
}

pub fn Matrix::cols(self: Matrix) -> Int {
  if (self.rows() == 0) {
    return 0;
  }

  return self.data[0].length();
}

pub fn Matrix::op_get(self: Matrix, i: Int) -> Vector {
  return Vector::view(self.data[i]);
}

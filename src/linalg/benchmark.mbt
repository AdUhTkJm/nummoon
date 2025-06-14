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

test "benchmark_mmul" {
  let farr = Array::makei(500, fn (i) {
    Array::makei(500, fn (j) {
      return i.to_float() * 1.028F - j.to_float() * 0.906F;
    })
  });
  let garr = Array::makei(500, fn (i) {
    Array::makei(500, fn (j) {
      return i.to_float() * -0.775F + j.to_float() * 1.313F;
    })
  });
  let x = Matrix::from_array(farr);
  let y = Matrix::from_array(garr);
  let mut mat = Matrix::new();
  let summary = @bench.single_bench(fn () {
    mat = x.mmul(y);
  });
  println(mat.sum());
  println(summary.to_json().stringify());
}

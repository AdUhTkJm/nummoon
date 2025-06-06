fn main {
  let x = @vector.Vector::linspace(6);
  println(x);
  let y = @vector.Vector::linspace(6);
  println(y);

  println(x + y);
  println(x - y);
  println(x * y);
  println(x / y);
}

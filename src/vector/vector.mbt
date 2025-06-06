extern type CVector;

extern "C" fn vf2str(vec: CVector) -> String = "mbt_vf2str";
extern "C" fn vfcreate() -> CVector = "mbt_vfcreate";

pub struct Vector {
  priv data: CVector;
};

impl Show for Vector with to_string(self) -> String {
  return vf2str(self.data);
}

impl Show for Vector with output(self, logger: &Logger) -> Unit {
  logger.write_string(self.to_string());
}

pub fn Vector::new() -> Vector {
  return {
    data: vfcreate()
  };
}

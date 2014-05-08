class BigDecimal

  def to_deg
    self * Terraformer::DEGREES_PER_RADIAN
  end

  def to_rad
    self * Terraformer::RADIANS_PER_DEGREE
  end

end


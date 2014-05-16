class BigDecimal

  def to_deg
    (self * Terraformer::DEGREES_PER_RADIAN).round Terraformer::PRECISION
  end

  def to_rad
    (self * Terraformer::RADIANS_PER_DEGREE).round Terraformer::PRECISION
  end

end


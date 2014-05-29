class BigDecimal

  def to_deg
    (self * Terraformer::DEGREES_PER_RADIAN).round Terraformer::PRECISION
  end

  def to_rad
    (self * Terraformer::RADIANS_PER_DEGREE).round Terraformer::PRECISION
  end

  def to_json *args
    finite? ? to_f.to_json : NilClass::AS_JSON
  end

end

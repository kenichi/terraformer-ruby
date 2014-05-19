module BigMath

  N_ONE = -1.to_d
  ZERO = 0.to_d
  ONE = 1.to_d
  TWO = 2.to_d

  # http://en.wikipedia.org/wiki/Atan2#Definition_and_computation
  #
  def self.atan2 y, x, precision
    case
    when x > ZERO
      BigMath.atan((y / x), precision)
    when y >= ZERO && x < ZERO
      BigMath.atan((y / x), precision) + Terraformer::PI
    when y < ZERO && x < ZERO
      BigMath.atan((y / x), precision) - Terraformer::PI
    when x == ZERO
      case
      when y > ZERO
        Terraformer::PI / TWO
      when y < ZERO
        -(Terraformer::PI / TWO)
      when y == ZERO
        BigDecimal::NAN
      end
    end
  end

  # http://en.wikipedia.org/wiki/Trigonometric_functions#Right-angled_triangle_definitions
  #
  def self.tan theta, precision
    BigMath.sin(theta, precision) / BigMath.cos(theta, precision)
  end

end

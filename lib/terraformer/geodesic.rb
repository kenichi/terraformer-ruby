module Terraformer

  class Geodesic

    MAX_ITERS = 20
    attr_accessor :precision

    def self.test
      a = Coordinate.new -122.6764, 45.5165
      b = a + [0.02, 0.02]
      r = a.distance_and_bearing_to b
      puts "distance between #{a} and #{b} : #{r[:distance]}"
      puts "initial bearing: #{r[:bearing][:initial]}"
      puts "final bearing: #{r[:bearing][:final]}"
    end

    class << self
      [:sin, :cos, :tan, :sqrt, :atan, :atan2].each do |m|
        define_method m do |*a|
          BigMath.__send__ m, *a.push(PRECISION)
        end
      end
    end

    # http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
    #
    # ported from https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/location/java/android/location/Location.java
    #
    def self.compute_distance_and_bearing lat_1, lon_1, lat_2, lon_2
      lat_1 = lat_1.to_rad
      lat_2 = lat_2.to_rad
      lon_1 = lon_1.to_rad
      lon_2 = lon_2.to_rad

      a = 6378137.to_d
      b = 6356752.3142.to_d
      f = (a - b) / a
      a_sq_minus_b_sq_over_b_sq = (a * a - b * b) / (b * b)

      _l = lon_2 - lon_1
      _a = BigMath::ZERO
      _u1 = atan((BigMath::ONE - f) * tan(lat_1))
      _u2 = atan((BigMath::ONE - f) * tan(lat_2))

      cos_u1 = cos(_u1)
      cos_u2 = cos(_u2)
      sin_u1 = sin(_u1)
      sin_u2 = sin(_u2)
      cos_u1_cos_u2 = cos_u1 * cos_u2
      sin_u1_sin_u2 = sin_u1 * sin_u2

      sigma = BigMath::ZERO
      delta_sigma = BigMath::ZERO
      cos_sq_alpha = BigMath::ZERO
      cos2_s_m = BigMath::ZERO
      cos_sigma = BigMath::ZERO
      sin_sigma = BigMath::ZERO
      cos_lambda = BigMath::ZERO
      sin_lambda = BigMath::ZERO

      _lambda = _l
      MAX_ITERS.times do |n|
        _lambda_orig = _lambda
        cos_lambda = cos(_lambda)
        sin_lambda = sin(_lambda)
        t1 = cos_u2 * sin_lambda
        t2 = cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda
        sin_sq_sigma = t1 * t1 + t2 * t2
        sin_sigma = sqrt(sin_sq_sigma)
        cos_sigma = sin_u1_sin_u2 + cos_u1_cos_u2 * cos_lambda
        sigma = atan2(sin_sigma, cos_sigma)
        sin_alpha = (sin_sigma == BigMath::ZERO) ? BigMath::ZERO : (cos_u1_cos_u2 * sin_lambda / sin_sigma)
        cos_sq_alpha = BigMath::ONE - sin_alpha * sin_alpha
        cos_2_s_m = (cos_sq_alpha == BigMath::ZERO) ? BigMath::ZERO : (cos_sigma - BigMath::TWO * sin_u1_sin_u2 / cos_sq_alpha)

        u_squared = cos_sq_alpha * a_sq_minus_b_sq_over_b_sq
        _a = BigMath::ONE + (u_squared / 16384.0) *
               (4096.0 + u_squared *
                 (-768.0 + u_squared * (320.0 - 175.0 * u_squared)))
        _b = (u_squared / 1024.0) *
               (256.0 + u_squared *
                 (-128.0 + u_squared * (74.0 - 47.0 * u_squared)))
        _c = (f / 16.0) *
               cos_sq_alpha *
               (4.0 + f * (4.0 - 3.0 * cos_sq_alpha))
        cos2_s_m_sq = cos2_s_m * cos2_s_m
        delta_sigma = _b * sin_sigma *
                        (cos2_s_m + (_b / 4.0) *
                          (cos_sigma * (BigMath::N_ONE + BigMath::TWO * cos2_s_m_sq) -
                          (_b / 6.0) * cos2_s_m *
                          (-3.0 + 4.0 * sin_sigma * sin_sigma) *
                          (-3.0 + 4.0 * cos2_s_m_sq)))

        _lambda = _l +
                    (BigMath::ONE - _c) * f * sin_alpha *
                    (sigma + _c * sin_sigma *
                      (cos2_s_m + _c * cos_sigma *
                      (BigMath::N_ONE + BigMath::TWO * cos2_s_m * cos2_s_m)))

        delta = (_lambda - _lambda_orig) / _lambda
        if delta.abs < 1.0e-12
          break
        end
      end

      { distance: (b * _a * (sigma - delta_sigma)),
        bearing: {
          initial: atan2(cos_u2 * sin_lambda, cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda).to_deg,
          final: atan2(cos_u1 * sin_lambda, -(sin_u1) * cos_u2 + cos_u1 * sin_u2 * cos_lambda).to_deg
        }
      }
    end

  end

end

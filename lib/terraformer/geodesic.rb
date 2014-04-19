module Terraformer
  module Geodesic

    def self.inverse_geodetic_solver a, b

      # raise if not Coordinate
      #
      [a,b].each {|x| raise ArgumentError unless Coordinate === x}

      # convert to rads
      #
      lat1 = a.y.to_rad
      lon1 = a.x.to_rad
      lat2 = b.y.to_rad
      lon2 = b.x.to_rad

      # WSG84 ellipsoid params
      #
      a = 6378137.to_d
      b = 6356752.31424518.to_d
      f = 1.to_d / 298.257223563.to_d

      _l = lon2 - lon1
      u1 = BigMath.atan(((1 - f) * Math.tan(lat1.to_f).to_d), PRECISION)
      u2 = BigMath.atan(((1 - f) * Math.tan(lat2.to_f).to_d), PRECISION)

      sin_u1 = BigMath.sin u1, PRECISION
      cos_u1 = BigMath.cos u1, PRECISION

      sin_u2 = BigMath.sin u2, PRECISION
      cos_u2 = BigMath.cos u2, PRECISION

      _lambda = _l
      iter_limit = 1000

      begin

        sin_lambda = BigMath.sin _lambda, PRECISION
        cos_lambda = BigMath.cos _lambda, PRECISION
        sin_sigma = BigMath.sqrt(
          ((cos_u2 * sin_lambda) * (cos_u2 * sin_lambda) + (cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda) *
          (cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda)),
          PRECISION)

        return 0 if sin_sigma == 0

        cos_sigma = sin_u1 * sin_u2 + cos_u1 * cos_u2 * cos_lambda
        sigma = Math.atan2 sin_sigma.to_f, cos_sigma.to_f
        sin_alpha = cos_u1 * cos_u2 * sin_lambda / sin_sigma
        cos_sq_alpha = 1 - sin_alpha * sin_alpha
        cos_2_sigma_m = cos_sigma - 2 * sin_u1 * sin_u2 / cos_sq_alpha

        # todo KEEP GOING

      end while (_lambda - _lambda_p).to_f.abs > 1e-12 and (iterLimit -= 1) > 0


    end

=begin
    function _inverseGeodeticSolver( /*radians*/ lat1, /*radians*/ lon1, /*radians*/ lat2, /*radians*/ lon2) {
      var a = 6378137,
      b = 6356752.31424518,
      f = 1 / 298.257223563; // WGS84 ellipsoid params
      var L = (lon2 - lon1);
      var U1 = Math.atan((1 - f) * Math.tan(lat1));
      var U2 = Math.atan((1 - f) * Math.tan(lat2));
      var sinU1 = Math.sin(U1),
        cosU1 = Math.cos(U1);
      var sinU2 = Math.sin(U2),
        cosU2 = Math.cos(U2);
      var lambda = L,
        lambdaP, iterLimit = 1000;
      var cosSqAlpha, sinSigma, cos2SigmaM, cosSigma, sigma;
      do {
        var sinLambda = Math.sin(lambda),
        cosLambda = Math.cos(lambda);
        sinSigma = Math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
        if (sinSigma === 0) {
          return 0;
        }
        cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
        sigma = Math.atan2(sinSigma, cosSigma);
        var sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
        cosSqAlpha = 1 - sinAlpha * sinAlpha;
        cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
        if (isNaN(cos2SigmaM)) {
          cos2SigmaM = 0;
        }
        var C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
        lambdaP = lambda;
        lambda = L + (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
      }
      while (Math.abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);
        if (iterLimit === 0) {
          //return NaN;
          //As Vincenty pointed out, when two points are nearly antipodal, the formula may not converge
          //It's time to switch to other formula, which may not as highly accurate as Vincenty's. Just for the special case.
            //Here implements Haversine formula
          var haversine_R = 6371009; // km
          var haversine_d = Math.acos(Math.sin(lat1)*Math.sin(lat2) + Math.cos(lat1)*Math.cos(lat2) * Math.cos(lon2-lon1)) * haversine_R;
          var dLon = lon2-lon1;
          var y = Math.sin(dLon) * Math.cos(lat2);
          var x = Math.cos(lat1)*Math.sin(lat2) - Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
          var brng = Math.atan2(y, x);
          return {"azimuth": brng, "geodesicDistance": haversine_d};
        }
        var uSq = cosSqAlpha * (a * a - b * b) / (b * b);
        var A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
        var B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
        var deltaSigma = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
        var s = b * A * (sigma - deltaSigma);
        var alpha1 = Math.atan2(cosU2 * Math.sin(lambda), cosU1 * sinU2 - sinU1 * cosU2 * Math.cos(lambda));
        var alpha2 = Math.atan2(cosU1 * Math.sin(lambda), cosU1 * sinU2 * Math.cos(lambda) - sinU1 * cosU2);
        var inverseResult = {
          azimuth: alpha1,
          geodesicDistance: s,
          reverseAzimuth: alpha2
        };
        return inverseResult;
    }
=end

  end
end

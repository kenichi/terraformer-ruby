module ArcGIS
  module Terraformer

    class Coordinate < ::Array

      class << self

        def from arys
          arys.map {|e| Coordinate.from_array e}
        end

        def from_array a
          Coordinate.__send__ Numeric === a[0] ? :new : :from, a
        end

        def big_decimal n
          case n
          when String
            BigDecimal.new n
          when BigDecimal
            n
          when Float
            n.to_d
          end
        end

      end

      def initialize _x, _y = nil, _z = nil, _m = nil
        super 4
        case _x
        when Array
          raise ArgumentError if _y
          self.x = _x[0]
          self.y = _x[1]
        when Numeric
          raise ArgumentError unless _y
          self.x = _x
          self.y = _y
        end
      end

      def x
        self[0]
      end

      def x= _x
        self[0] = Coordinate.big_decimal _x
      end

      def y
        self[1]
      end

      def y= _y
        self[1] = Coordinate.big_decimal _y
      end

      def z
        self[2]
      end

      def m
        self[3]
      end

      [:z=, :m=, :<<, :+ , :-, :*, :&, :|].each do |sym|
        define_method(sym){|*a| raise NotImplementedError }
      end

      def to_geographic
        xerd = (x / EARTH_RADIUS).to_deg
        _x = xerd - (((xerd + 180.0) / 360.0).floor * 360.0)
        _y = (
          (Math::PI / 2).to_d -
          (2 * BigMath.atan(BigMath.exp(-1.0 * y / EARTH_RADIUS, PRECISION), PRECISION))
        ).to_deg
        self.class.new _x, _y
      end

      def to_mercator
        _x = x.to_rad * EARTH_RADIUS
        syr = BigMath.sin y.to_rad, PRECISION
        _y = (EARTH_RADIUS / 2.0) * BigMath.log((1.0 + syr) / (1.0 - syr), PRECISION)
        self.class.new _x, _y
      end

      def to_json *args
        [x, y, z, m].map! {|e| e.nil? ? nil : e.to_f}.compact.to_json(*args)
      end

    end

  end
end

module Terraformer

  class Coordinate < ::Array

    # http://en.wikipedia.org/wiki/Earth_radius#Mean_radius
    #
    EARTH_MEAN_RADIUS = 6371009.to_d

    attr_accessor :crs

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
          BigDecimal(n)
        when BigDecimal
          n
        when Numeric
          BigDecimal(n.to_s)
        else
          raise ArgumentError
        end
      end

    end

    def initialize _x, _y = nil, _z = nil
      super 3
      case
      when Array === _x
        raise ArgumentError if _y
        self.x = _x[0]
        self.y = _x[1]
        self.z = _x[2] if _x[2]
      when Numeric === _x || String === _x
        raise ArgumentError unless _y
        self.x = _x
        self.y = _y
        self.z = _z if _z
      else
        raise ArgumentError.new "invalid argument: #{_x}"
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

    def z= _z
      self[2] = Coordinate.big_decimal _z
    end

    [:<<, :*, :&, :|].each do |sym|
      define_method(sym){|*a| raise NotImplementedError }
    end

    def to_geographic
      xerd = (x / EARTH_RADIUS).to_deg
      _x = xerd - (((xerd + 180.0) / 360.0).floor * 360.0)
      _y = (
        (Math::PI / 2).to_d -
        (2 * BigMath.atan(BigMath.exp(-1.0 * y / EARTH_RADIUS, PRECISION), PRECISION))
      ).to_deg
      geog = self.class.new _x.round(PRECISION), _y.round(PRECISION)
      geog.crs = GEOGRAPHIC_CRS
      geog
    end

    def to_mercator
      _x = x.to_rad * EARTH_RADIUS
      syr = BigMath.sin y.to_rad, PRECISION
      _y = (EARTH_RADIUS / 2.0) * BigMath.log((1.0 + syr) / (1.0 - syr), PRECISION)
      merc = self.class.new _x.round(PRECISION), _y.round(PRECISION)
      merc.crs = MERCATOR_CRS
      merc
    end

    def to_s
      [x,y,z].compact.join ','
    end

    def to_json *args
      compact.to_json(*args)
    end

    def to_point
      Point.new self
    end

    def geographic?
      crs.nil? or crs == GEOGRAPHIC_CRS
    end

    def mercator?
      crs == MERCATOR_CRS
    end

    def buffer radius, resolution = DEFAULT_BUFFER_RESOLUTION
      center = to_mercator unless mercator?
      coordinates = (1..resolution).map {|step|
        radians = step.to_d * (360.to_d / resolution.to_d) * PI / 180.to_d
        [center.x + radius.to_d * BigMath.cos(radians, PRECISION),
         center.y + radius.to_d * BigMath.sin(radians, PRECISION)]
      }
      coordinates << coordinates[0]
      Polygon.new(coordinates).to_geographic
    end

    def <=> other
      raise ArgumentError unless Coordinate === other
      dx = x - other.x
      dy = y - other.y
      case
      when dx > dy; 1
      when dx < dy; -1
      else;         0
      end
    end

    def arithmetic operator, obj
      case obj
      when Array
        _x = self.x.__send__ operator, obj[0] if obj[0]
        _y = self.y.__send__ operator, obj[1] if obj[1]
        Coordinate.new((_x || x), (_y || y))
      else
        raise NotImplementedError
      end
    end
    private :arithmetic

    def + obj
      arithmetic :+, obj
    end

    def - obj
      arithmetic :-, obj
    end

    def squared_euclidean_distance_to obj
      raise ArgumentError unless Coordinate === obj
      dx = obj.x - x
      dy = obj.y - y
      dx * dx + dy * dy
    end

    def euclidean_distance_to obj
      BigMath.sqrt squared_euclidean_distance_to(obj), PRECISION
    end

    def haversine_distance_to other
      raise ArgumentError unless Coordinate === other

      d_lat = (self.y - other.y).to_rad
      d_lon = (self.x - other.x).to_rad

      lat_r = self.y.to_rad
      other_lat_r = other.y.to_rad

      a = BigMath.sin(d_lat / 2, PRECISION)**2 +
          BigMath.sin(d_lon / 2, PRECISION)**2 *
          BigMath.cos(lat_r, PRECISION) * BigMath.cos(other_lat_r, PRECISION)

      y = BigMath.sqrt a, PRECISION
      x = BigMath.sqrt (1 - a), PRECISION
      c = 2 * BigMath.atan2(y, x, PRECISION)

      c * EARTH_MEAN_RADIUS
    end

    def distance_and_bearing_to obj
      raise ArgumentError unless Coordinate === obj
      Geodesic.compute_distance_and_bearing y, x, obj.y, obj.x
    end

    def distance_to obj
      distance_and_bearing_to(obj)[:distance]
    end

    def initial_bearing_to obj
      distance_and_bearing_to(obj)[:bearing][:initial]
    end

    def final_bearing_to obj
      distance_and_bearing_to(obj)[:bearing][:final]
    end

  end

end

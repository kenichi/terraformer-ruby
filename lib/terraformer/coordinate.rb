module Terraformer

  class Coordinate < ::Array

    # http://en.wikipedia.org/wiki/Earth_radius#Mean_radius
    #
    MEAN_RADIUS_EARTH = 6371009.to_d

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
          BigDecimal.new n
        when BigDecimal
          n
        when Numeric
          n.to_d
        end
      end

      # http://tixxit.wordpress.com/2009/12/09/jarvis-march
      #
      def turn p, q, r
        ((q[0] - p[0]) * (r[1] - p[1]) - (r[0] - p[0]) * (q[1] - p[1])) <=> 0
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
      when String
        raise ArgumentError unless _y
        self.x = BigDecimal(_x)
        self.y = BigDecimal(_y)
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
      geog = self.class.new _x, _y
      geog.crs = GEOGRAPHIC_CRS
      geog
    end

    def to_mercator
      _x = x.to_rad * EARTH_RADIUS
      syr = BigMath.sin y.to_rad, PRECISION
      _y = (EARTH_RADIUS / 2.0) * BigMath.log((1.0 + syr) / (1.0 - syr), PRECISION)
      merc = self.class.new _x, _y
      merc.crs = MERCATOR_CRS
      merc
    end

    def to_s
      [x,y,z,m].compact.join ','
    end

    def to_json *args
      [x, y, z, m].map! {|e| e.nil? ? nil : e.to_f}.compact.to_json(*args)
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

    # todo - this is also probably algorithmically bad, fix that sucker
    #
    def great_circle_distance other
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

      c * MEAN_RADIUS_EARTH
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

    def squared_euclidean_distance other
      raise ArgumentError unless Coordinate === other
      dx = other.x - x
      dy = other.y - y
      dx**2 + dy**2
    end

    def euclidean_distance other
      BigMath.sqrt squared_euclidean_distance(other), PRECISION
    end

    def + obj
      case obj
      when Array
        _x = self.x + obj[0] if obj[0]
        _y = self.y + obj[1] if obj[1]
        Coordinate.new((_x || x), (_y || y))
      else
        raise NotImplementedError
      end
    end

  end

end

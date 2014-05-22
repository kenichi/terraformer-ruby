module Terraformer

  class Point < Geometry

    def first_coordinate
      coordinates
    end

    def distance_and_bearing_to obj
      case obj
      when Point
        first_coordinate.distance_and_bearing_to obj.first_coordinate

      # todo other cases
      end
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

    def contains? obj
      case obj
      when Point
        self == obj
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

    def within? obj
      case obj
      when Point
        self == obj
      when MultiPoint
        obj.coordinates.any? {|c| self.coordinates == c}
      when LineString
        obj.coordinates.any? {|c| self.coordinates == c}
      when MultiLineString
        obj.line_strings.any? {|ls| within? ls}
      when Polygon
        obj.contains? self
      when MultiPolygon
        obj.polygons.any? {|p| p.contains? self}
      else
        raise ArgumentError unless Geometry === obj
      end
    end

  end

end

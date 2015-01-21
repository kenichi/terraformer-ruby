module Terraformer

  class Point < Geometry

    def initialize *args
      super

      # must be a single point
      unless Terraformer::Coordinate === coordinates
        raise ArgumentError.new 'invalid coordinates for Terraformer::Point'
      end
    end

    def first_coordinate
      coordinates
    end

    def distance_and_bearing_to obj
      dabt = case obj
             when Point
               [first_coordinate.distance_and_bearing_to(obj.first_coordinate)]

             when MultiPoint
               obj.coordinates.map {|c| first_coordinate.distance_and_bearing_to c}

             when LineString
               obj.coordinates.map {|c| first_coordinate.distance_and_bearing_to c}

             when MultiLineString
               obj.line_strings.map {|ls| distance_and_bearing_to ls}

             when Polygon
               obj.line_strings[0].coordinates.map {|c| first_coordinate.distance_and_bearing_to c}

             when MultiPolygon
               obj.polygons.map {|p| distance_and_bearing_to p}

             # todo other cases

             else
               raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
             end
      dabt.flatten!
      dabt.minmax_by {|db| db[:distance]}
    end

    def distance_to obj, minmax = :min
      distance_and_bearing_to(obj)[minmax == :min ? 0 : 1][:distance]
    end

    def initial_bearing_to obj
      distance_and_bearing_to(obj)[0][:bearing][:initial]
    end

    def final_bearing_to obj
      distance_and_bearing_to(obj)[0][:bearing][:final]
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

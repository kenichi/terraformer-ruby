module Terraformer

  class LineString < Geometry

    def first_coordinate
      coordinates[0]
    end

    def linear_ring?
      coordinates.length > 3 and coordinates.first == coordinates.last
    end

    def contains? obj
      case obj
      when LineString
        self == obj or coordinates.slice_exists? obj.coordinates
      when MultiLineString
        obj.line_strings.any? {|ls| ls.within? self}
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

    def within? obj
      case obj
      when LineString
        self == obj or obj.coordinates.slice_exists? coordinates
      when MultiLineString
        obj.line_strings.any? {|ls| ls.contains? self}
      when Polygon
        obj.contains? self
      when MultiPolygon
        obj.polygons.any? {|p| p.contains? self}
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

  end

end

module Terraformer

  class LineString < Geometry

    def initialize *args
      super *args

      unless Array === coordinates &&
             Terraformer::Coordinate === coordinates[0]
        raise ArgumentError.new 'invalid coordinates for Terraformer::LineString'
      end
    end

    def first_coordinate
      coordinates[0]
    end

    def linear_ring?
      coordinates.length > 3 and coordinates.first == coordinates.last
    end

    def lines
      ls = []
      coordinates.each_cons(2) {|l| ls << l}
      ls
    end

    def contains? obj
      case obj
      when Point
        lines.any? {|l| Geometry.line_contains_point? l, obj.coordinates}
      when LineString
        self == obj or coordinates.slice_exists? obj.coordinates
        # todo this does not case for a line string of different coordinates
        #      that is actually contained yet
      when MultiLineString
        obj.line_strings.all? {|ls| ls.within? self}
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

    def within? obj
      case obj
      when LineString
        self == obj or obj.coordinates.slice_exists? coordinates
        # todo this does not case for a line string of different coordinates
        #      that is actually contained yet
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

    def points
      coordinates.map &:to_point
    end
    alias_method :vertices, :points

    def point_at idx
      coordinates[idx].to_point
    end
    alias_method :vertex_at, :point_at

    def add_vertex p
      p = p.coordinates if Point === p
      raise ArgumentError unless Coordinate === p
      coordinates << p
    end
    alias_method :<<, :add_vertex

    def insert_vertex idx, p
      p = p.coordinates if Point === p
      raise ArgumentError unless Coordinate === p
      coordinates.insert idx, p
    end

    def remove_vertex p
      p = p.coordinates if Point === p
      raise ArgumentError unless Coordinate === p
      coordinates.delete p
    end

    def remove_vertex_at idx
      coordinates.delete_at idx
    end

  end

end

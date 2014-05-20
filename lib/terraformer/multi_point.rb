module Terraformer

  class MultiPoint < Geometry

    def initialize *args
      case
      when Point === args[0]
        self.coordinates = args.map &:coordinates
      else
        super *args
      end
    end

    def first_coordinate
      coordinates[0]
    end

    def points
      coordinates.map {|p| Point.new p}
    end

    def == obj
      super obj do |o|
        self.coordinates.sort == obj.coordinates.sort
      end
    end

    def contains? obj
      points.any? {|p| p.contains? obj}
    end

    def within? obj
      within = false
      case obj
      when MultiPoint || LineString || MultiLineString
        points.all? {|p| obj.contains? p}
      when Polygon
        obj.contains? self
      when MultiPolygon
        points.all? {|p| obj.polygons.any? {|polygon| polygon.contains? p}}
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
      within
    end

  end

end

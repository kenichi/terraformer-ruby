module Terraformer

  class MultiPolygon < Geometry

    def initialize *args
      case
      when Coordinate === args[0] # only one
        self.coordinates = [[Coordinate.from_array(args)]]
      when Array === args[0] # multiple?
        self.coordinates = [Coordinate.from(args)]
      when Polygon === args[0]
        self.coordinates = args.map &:coordinates
      else
        super *args
      end
    end

    def first_coordinate
      coordinates[0][0][0]
    end

    def polygons
      coordinates.map {|p| Polygon.new *p}
    end

    def == obj
      super obj do |o|
        equal = true
        ps = polygons.sort
        ops = o.polygons.sort
        ps.each_with_index do |p, i|
          equal = p == ops[i]
          break unless equal
        end
        equal
      end
    end

    def contains? obj
      polygons.any? {|p| p.contains? obj}
    end

    def within? obj
      within = false
      case obj
      when Polygon
        within = polygons.all? {|p| p.within? obj}
      when MultiPolygon
        within = polygons.map {|p, i| all_in[i] = obj.polygons.any? {|op| op.contains? p}}.all?
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
      within
    end

  end

end

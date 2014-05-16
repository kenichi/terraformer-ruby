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
      coordinates.map {|p| Polygon.new p}
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

  end

end

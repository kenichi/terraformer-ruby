module Terraformer

  class MultiPolygon < Geometry

    def initialize *args
      case

      # arg is an array of arrays of polygon, holes
      when Array === args[0] && Array === args[0][0] && Array === args[0][0][0] && Array === args[0][0][0][0]
        self.coordinates = Coordinate.from_array(*args)

      when Coordinate === args[0] # only one
        self.coordinates = [[Coordinate.from_array(args)]]
      when Array === args[0] # multiple?
        self.coordinates = [Coordinate.from_array(args)]
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
        ps = polygons
        ops = o.polygons
        ps.each_with_index do |p, i|
          equal = p == ops[i] rescue false
          break unless equal
        end
        equal
      end
    end

    def contains? obj
      polygons.any? {|p| p.contains? obj}
    end

    def within? obj
      case obj
      when Polygon
        polygons.all? {|p| p.within? obj}
      when MultiPolygon
        polygons.all? {|p| obj.polygons.any? {|op| op.contains? p}}
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

  end

end

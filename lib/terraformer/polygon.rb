module Terraformer

  class Polygon < Geometry

    def initialize *args
      case
      when Coordinate === args[0] # each arg is a position of the polygon
        self.coordinates = [Coordinate.from_array(args)]
      when Array === args[0] # each arg is an array of positions; first is polygon, rest are "holes"
        self.coordinates = Coordinate.from args
      else
        super *args
      end
    end

    def has_holes?
      coordinates.length > 1
    end

    def first_coordinate
      coordinates[0][0]
    end

  end

end

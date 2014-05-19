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

      if line_strings.map(&:linear_ring?).include? false
        raise ArgumentError.new 'not linear ring'
      end
    end

    def has_holes?
      coordinates.length > 1
    end

    def first_coordinate
      coordinates[0][0]
    end

    def == obj
      super obj do |o|

        equal = true

        # first check outer polygon
        equal = self.coordinates[0].polygonally_equal_to? obj.coordinates[0]


        # then inner polygons (holes)
        #
        if equal and obj.coordinates.length > 1
          1.upto(obj.coordinates.length - 1) do |i|
            equal = self.coordinates[i].polygonally_equal_to? obj.coordinates[i]
            break unless equal
          end
        end

        equal
      end
    end

    def line_strings
      coordinates.map {|lr| LineString.new lr}
    end

  end

end

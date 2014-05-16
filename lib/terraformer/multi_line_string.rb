module Terraformer

  class MultiLineString < Geometry

    def initialize *args
      case
      when Coordinate === args[0] # only one
        self.coordinates = [Coordinate.from_array(args)]
      when Array === args[0] # multiple?
        self.coordinates = Coordinate.from args
      when LineString === args[0]
        self.coordinates = args.map &:coordinates
      else
        super *args
      end
    end

    def first_coordinate
      coordinates[0][0]
    end

    def line_strings
      coordinates.map {|ls| LineString.new ls}
    end

    def == obj
      super obj do |o|
        equal = true
        lses = line_strings.sort
        olses = o.line_strings.sort
        lses.each_with_index do |ls, i|
          equal = ls == olses[i]
          break unless equal
        end
        equal
      end
    end

  end

end

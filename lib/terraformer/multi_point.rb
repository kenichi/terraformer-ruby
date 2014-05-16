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

  end

end

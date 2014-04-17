module Terraformer

  class Polygon < Geometry

    def has_holes?
      coordinates.length > 1
    end

    def first_coordinate
      coordinates[0][0]
    end

  end

end

module Terraformer

  class MultiPolygon < Geometry

    def first_coordinate
      coordinates[0][0][0]
    end

  end

end

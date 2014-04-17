module Terraformer

  class LineString < Geometry

    def first_coordinate
      coordinates[0]
    end

  end

end

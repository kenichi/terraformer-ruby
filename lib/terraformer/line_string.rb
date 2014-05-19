module Terraformer

  class LineString < Geometry

    def first_coordinate
      coordinates[0]
    end

    def linear_ring?
      coordinates.length > 3 and coordinates.first == coordinates.last
    end

  end

end

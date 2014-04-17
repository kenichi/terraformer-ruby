module Terraformer

  class MultiLineString < Geometry

    def first_coordinate
      coordinates[0][0]
    end

  end

end

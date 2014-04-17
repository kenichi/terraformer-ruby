module Terraformer

  class MultiPoint < Geometry

    def first_coordinate
      coordinates[0]
    end

  end

end

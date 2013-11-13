module Terraformer

  class Polygon < Geometry

    def has_holes?
      coordinates.length > 1
    end

  end

end

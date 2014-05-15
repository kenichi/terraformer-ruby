module Terraformer

  class Point < Geometry

    def first_coordinate
      coordinates
    end

    def distance_and_bearing_to obj
      case obj
      when Point
        first_coordinate.distance_and_bearing_to obj.first_coordinate

      # todo other cases
      end
    end

    def distance_to obj
      distance_and_bearing_to(obj)[:distance]
    end

    def initial_bearing_to obj
      distance_and_bearing_to(obj)[:bearing][:initial]
    end

    def final_bearing_to obj
      distance_and_bearing_to(obj)[:bearing][:final]
    end

  end

end

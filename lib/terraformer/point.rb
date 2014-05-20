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

    def contains? obj
      case obj
      when Point
        self == obj
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

    def within? obj
      within = false
      case obj
      when Point
        within = self == obj
      when MultiPoint || LineString
        obj.each_coordinate do |c|
          if self == c
            within = true
            break
          end
        end
      when MultiLineString
        within = obj.line_strings.any? {|ls| within? ls}
      when Polygon
        within = obj.contains? self
      when MultiPolygon
        within = obj.polygons.any? {|p| p.contains? self}
      else
        raise ArgumentError unless Geometry === obj
      end
      within
    end

  end

end

module Terraformer
  class Geometry < Primitive

    # geometric "helpers"
    #
    module ClassMethods

      def coordinates_contain_point? coordinates, point
        contains = false
        i = -1
        l = coordinates.length
        j = l - 1
        loop do
          break unless (i += 1) < l

          if ((coordinates[i][1] <= point[1] && point[1] < coordinates[j][1]) ||
              (coordinates[j][1] <= point[1] && point[1] < coordinates[i][1])) &&
             (point[0] < (coordinates[j][0] - coordinates[i][0]) *
              (point[1] - coordinates[i][1]) / (coordinates[j][1] - coordinates[i][1]) + coordinates[i][0])

             contains = !contains
          end
          j = i
        end
        contains
      end

      def edge_intersects_edge? a1, a2, b1, b2
        ua_t = (b2[0] - b1[0]) * (a1[1] - b1[1]) - (b2[1] - b1[1]) * (a1[0] - b1[0])
        ub_t = (a2[0] - a1[0]) * (a1[1] - b1[1]) - (a2[1] - a1[1]) * (a1[0] - b1[0])
        u_b  = (b2[1] - b1[1]) * (a2[0] - a1[0]) - (b2[0] - b1[0]) * (a2[1] - a1[1])
        if u_b != 0
          ua = ua_t / u_b
          ub = ub_t / u_b
          return true if  0 <= ua && ua <= 1 && 0 <= ub && ub <= 1
        end
        false
      end

      def arrays_intersect_arrays? a, b
        case
        when a[0].class == Coordinate
          case
          when b[0].class == Coordinate
            a.each_cons(2) do |a1, a2|
              b.each_cons(2) do |b1, b2|
                return true if edge_intersects_edge?(a1, a2, b1, b2)
              end
            end
          when b[0].class == Array
            b.each {|e| return true if intersects = arrays_intersect_arrays?(a, e)}
          end
        when a[0].class == Array
          a.each {|e| return true if intersects = arrays_intersect_arrays?(e, b)}
        end
        false
      end

      def line_contains_point? line, point
        raise ArgumentError unless Array === line and
                                   line.length == 2 and
                                   Coordinate === line[0] and
                                   Coordinate === line[1]
        point = point.coordinates if Point === point
        raise ArgumentError unless Coordinate === point

        return true if line[0] == point or line[1] == point

        dxp = point.x - line[0].x
        dyp = point.y - line[0].y

        dxl = line[1].x - line[0].x
        dyl = line[1].y - line[0].y

        cross = dxp * dyl - dyp * dxl
        return false unless cross == BigMath::ZERO

        if dxl.abs >= dyl.abs
          return dxl > BigMath::ZERO ?
            line[0].x <= point.x && point.x <= line[1].x :
            line[1].x <= point.x && point.x <= line[0].x
        else
          return dyl > BigMath::ZERO ?
            line[0].y <= point.y && point.y <= line[1].y :
            line[1].y <= point.y && point.y <= line[0].y
        end
      end

    end

  end
end

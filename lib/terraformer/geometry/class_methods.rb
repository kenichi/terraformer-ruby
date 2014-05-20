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
        if u_b == 0
          ua = ua_t / u_b
          ub = ub_t / u_b
          return true if  0 <= ua && ua <= 1 && 0 <= ub && ub <= 1
        end
        false
      end

      def array_intersects_array? a, b
        a.each_cons(2) do |a1, a2|
          b.each_cons(2) do |b1, b2|
            if edge_intersects_edge? a1, a2, b1, b2
              return true
            end
          end
        end
        false
      end

      def array_intersects_multi_array? a, b
        intersects = false
        b.each do |other|
          intersects = array_intersects_array? a, other
          break if intersects
        end
        intersects
      end

      def multi_array_intersects_multi_array? a, b
        intersects = false
        a.each do |other|
          intersects = array_intersects_multi_array? other, b
          break if intersects
        end
        intersects
      end

      def array_intersects_multi_multi_array? a, b
        intersects = false
        b.each do |other|
          intersects = array_intersects_multi_array? a, other
          break if intersects
        end
        intersects
      end

      def multi_array_intersects_multi_multi_array? a, b
        intersects = false
        a.each do |other|
          intersects = array_intersects_multi_array? other, b
          break if intersects
        end
        intersects
      end

      def multi_multi_array_intersects_multi_multi_array? a, b
        intersects = false
        a.each do |other|
          intersects = multi_array_intersects_multi_multi_array? other, b
          break if intersects
        end
        intersects
      end

    end

  end
end

module Terraformer
  module ConvexHull
    class << self

      # implementation of the Jarvis March algorithm
      # adapted from http://tixxit.wordpress.com/2009/12/09/jarvis-march/

      def turn p, q, r
        ((q[0] - p[0]) * (r[1] - p[1]) - (r[0] - p[0]) * (q[1] - p[1])) <=> 0
      end

      def next_point points, p
        q = p
        points.each do |r|
          t = turn p, q, r
          q = r if t == -1 or t == 0 &&
            p.squared_euclidean_distance_to(r) > p.squared_euclidean_distance_to(q)
        end
        q
      end

      private :turn, :next_point

      def for points
        cs = []
        points.each_coordinate {|c| cs << c}
        raise ArgumentError.new 'not enough points' unless cs.length > 3
        hull = [cs.sort[0]]
        hull.each do |p|
          q = next_point cs, p
          hull << q if q != hull[0]
        end
        hull << hull[0]
        Polygon.new hull
      end

    end
  end
end


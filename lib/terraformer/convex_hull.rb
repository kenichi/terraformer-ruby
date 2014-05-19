module Terraformer
  module ConvexHull

    DEFAULT_IMPL = :monotone

    class << self

      attr_accessor :impl

      def test
        require 'ruby-prof'
        wc = Terraformer.parse 'test/examples/waldocanyon.geojson'
        RubyProf.start
        wc.convex_hull
        result = RubyProf.stop
        printer = RubyProf::FlatPrinter.new(result)
        printer.print(STDOUT)
        # printer = RubyProf::GraphPrinter.new(result)
        # printer.print(STDOUT, {})
      end

      def for points
        hull = __send__ @impl || DEFAULT_IMPL, flatten_coordinates_from(points)
        if hull.length == 1
          Point.new hull[0]
        else
          Polygon.new hull
        end
      end

      private

      def flatten_coordinates_from points
        cs = []
        points.each_coordinate {|c| cs << c}
        cs.sort!.uniq!
        cs
      end

      # http://tixxit.wordpress.com/2009/12/09/jarvis-march/
      #
      def turn p, q, r
        ((q[0] - p[0]) * (r[1] - p[1]) - (r[0] - p[0]) * (q[1] - p[1])) <=> BigMath::ZERO
      end

      def next_point points, p
        q = p
        points.each do |r|
          t = turn p, q, r
          q = r if t == BigMath::N_ONE or t == BigMath::ZERO &&
            p.squared_euclidean_distance_to(r) > p.squared_euclidean_distance_to(q)
        end
        q
      end

      def jarvis_march points
        return points if points.length < 3
        hull = [points.sort[0]]
        hull.each do |p|
          q = next_point points, p
          hull << q if q != hull[0]
        end
        hull << hull[0]
        hull
      end

      # http://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain#Ruby
      #
      def cross o, a, b
        (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])
      end

      def monotone points
        return points if points.length < 3
        lower = Array.new
        points.each{|p|
          while lower.length > 1 and cross(lower[-2], lower[-1], p) <= 0 do lower.pop end
          lower.push(p)
        }
        upper = Array.new
        points.reverse_each{|p|
          while upper.length > 1 and cross(upper[-2], upper[-1], p) <= 0 do upper.pop end
          upper.push(p)
        }
        hull = lower[0...-1] + upper[0...-1]
        hull << hull[0]
      end

    end
  end
end


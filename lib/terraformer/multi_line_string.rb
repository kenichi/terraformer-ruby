module Terraformer

  class MultiLineString < Geometry

    def initialize *args

      case
      when LineString === args[0]
        self.coordinates = args.map &:coordinates
      else
        super *args
      end

      unless Array === coordinates &&
             Array === coordinates[0] &&
             Terraformer::Coordinate === coordinates[0][0]
        raise ArgumentError.new 'invalid coordinates for Terraformer::MultiLineString'
      end
    end

    def first_coordinate
      coordinates[0][0]
    end

    def line_strings
      coordinates.map {|ls| LineString.new ls}
    end

    def == obj
      super obj do |o|
        equal = true
        lses = line_strings.sort
        olses = o.line_strings.sort
        lses.each_with_index do |ls, i|
          equal = ls == olses[i]
          break unless equal
        end
        equal
      end
    end

    def contains? obj
      case obj
      when Point
        line_strings.any? {|ls| ls.contains? obj}
      when MultiPoint
        obj.points.all? {|p| line_strings.any? {|ls| ls.contains? p}}
      when LineString
        line_strings.any? {|ls| ls == obj or ls.coordinates.slice_exists? obj.coordinates}
      when MultiLineString
        obj.line_strings.all? do |ols|
          line_strings.any? do |ls|
            ls == ols or ls.coordinates.slice_exists? ols.coordinates
          end
        end
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

    def within? obj
      case obj
      when MultiLineString
        obj.contains? self
      when Polygon
        obj.contains? self
      when MultiPolygon
        obj.contains? self
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

  end

end

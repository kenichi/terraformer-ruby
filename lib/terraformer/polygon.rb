module Terraformer

  class Polygon < Geometry

    def initialize *args

      # each arg is a position of the polygon
      if Coordinate === args[0] || (Array === args[0] && Numeric === args[0][0])
        self.coordinates = [Coordinate.from_array(args)]

      elsif Array === args[0]

        # each arg is an array of positions; first is polygon, rest are "holes"
        if Coordinate === args[0][0] ||
           Array === args[0][0] && Numeric === args[0][0][0]
          self.coordinates = Coordinate.from_array args

        # arg is an array of polygon, holes
        elsif Array === args[0][0] && Array === args[0][0][0]
          self.coordinates = Coordinate.from_array *args
        end

      else
        super *args
      end

      if line_strings.map(&:linear_ring?).include? false
        raise ArgumentError.new 'not linear ring'
      end
    end

    def has_holes?
      coordinates.length > 1
    end

    def first_coordinate
      coordinates[0][0]
    end

    def == obj
      super obj do |o|

        equal = true

        # first check outer polygon
        equal = Polygon.polygonally_equal? self.coordinates[0], obj.coordinates[0]

        # then inner polygons (holes)
        #
        if equal
          if self.coordinates.length == obj.coordinates.length and obj.coordinates.length > 1

            self_holes = self.coordinates[1..-1].sort
            obj_holes = obj.coordinates[1..-1].sort

            self_holes.each_with_index do |hole, idx|
              equal = Polygon.polygonally_equal? hole, obj_holes[idx]
              break unless equal
            end
          end
        end

        equal
      end
    end

    def line_strings
      coordinates.map {|lr| LineString.new lr}
    end

    def holes
      return nil unless has_holes?
      coordinates[1..-1].map {|hole| Polygon.new hole}
    end

    def contains? obj
      obj = Coordinate.new obj if Array === obj and Numeric === obj[0]
      obj = obj.to_point if Coordinate === obj
      contained = false
      case obj
      when Point
        contained = Geometry.coordinates_contain_point? coordinates[0], obj.coordinates
        contained = !holes.any? {|h| h.contains? obj} if contained and has_holes?
      when MultiPoint
        contained = obj.points.all? {|p| contains? p}
      when LineString
        contained = contains?(obj.first_coordinate) && !Geometry.array_intersects_multi_array?(obj.coordinates, coordinates)
      when MultiLineString
        contained = obj.line_strings.all? {|ls| contains? ls}
      when Polygon
        contained = obj.within? self
      when MultiPolygon
        contained = obj.polygons.all? {|p| p.within? self}
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
      contained
    end

    def within? obj
      case obj
      when Polygon
        if self == obj
          true
        elsif obj.contains? first_coordinate
          !Geometry.arrays_intersect_arrays?(coordinates, obj.coordinates)
        end
      when MultiPolygon
        obj.polygons.any? {|p| p.contains? self}
      else
        raise ArgumentError.new "unsupported type: #{obj.type rescue obj.class}"
      end
    end

    def add_vertex p
      insert_vertex -2, p
    end
    alias_method :<<, :add_vertex

    def insert_vertex idx, p
      p = p.coordinates if Point === p
      raise ArgumentError unless Coordinate === p
      coordinates[0].insert idx, p
    end

    def remove_vertex p
      p = p.coordinates if Point === p
      raise ArgumentError unless Coordinate === p
      coordinates[0].delete p
    end

    def remove_vertex_at idx
      coordinates[0].delete_at idx
    end


    def self.polygonally_equal? a, b
      if Terraformer::Coordinate === a ||
         Terraformer::Coordinate === b
        return a == b
      end

      raise ArgumentError unless Enumerable === a
      raise ArgumentError unless Enumerable === b

      # polygons must be the same length
      return false if a.length != b.length

      # polygons must have the last element be a duplicate
      # polygon-closing coordinate
      return false if a[0] != a[-1]
      return false if b[0] != b[-1]

      equal = true

      # clone so can pop/rotate
      a = a.clone
      b = b.clone

      # pop to drop the duplicate, polygon-closing, coordinate
      a.pop
      b.pop

      begin
        b.rotate_until_first_equals a[0]
        return a == b
      rescue IndexError
        return false
      end
    end

  end

end

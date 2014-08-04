require 'terraformer/geometry/class_methods'

module Terraformer

  class Geometry < Primitive
    extend Terraformer::Geometry::ClassMethods

    MULTI_REGEX = /^Multi/

    attr_accessor :coordinates, :crs

    def initialize *args
      case
      when args.length > 1
        self.coordinates = Coordinate.from_array args
      when Array === args[0]
        self.coordinates = Coordinate.from_array args[0]
      else
        super *args do |arg|
          self.coordinates = Coordinate.from_array arg['coordinates']
        end
      end
    end

    def to_hash *args
      h = {
        type: type,
        coordinates: coordinates
      }
      h[:crs] = crs if crs
      h[:bbox] = bbox if Hash === args.last and args.last[:include_bbox]
      h
    end

    def to_mercator
      self.class.new *coordinates.map_coordinate(&:to_mercator)
    end

    def to_geographic
      self.class.new *coordinates.map_coordinate(&:to_geographic)
    end

    def to_feature
      f = Feature.new
      f.geometry = self
      f
    end

    def first_coordinate
      raise NotImplementedError
    end

    def mercator?
      first_coordinate.mercator?
    end

    def geographic?
      first_coordinate.geographic?
    end

    def get index
      if MULTI_REGEX.match type
        sub = type.sub MULTI_REGEX, ''
        Terraformer.const_get(sub).new *coordinates[index]
      else
        raise NotImplementedError
      end
    end

    def convex_hull
      ConvexHull.for coordinates
    end

    def contains? other
      raise NotImplementedError
    end

    def within? other
      raise NotImplementedError
    end

    def intersects? other
      [self, other].each do |e|
        if [Point, MultiPoint].include? e.class
          raise ArgumentError.new "unsupported type: #{e.type rescue e.class}"
        end
      end
      return true if begin
        within? other or other.within? self
      rescue ArgumentError
        false
      end
      Terraformer::Geometry.arrays_intersect_arrays? coordinates, other.coordinates
    end

    def == obj
      return false unless obj.class == self.class
      if block_given?
        yield obj
      else
        self.coordinates == obj.coordinates
      end
    end

  end

  class GeometryCollection < Primitive

    attr_writer :geometries

    def initialize *args
      unless args.empty?
        super *args do |arg|
          self.geometries = arg['geometries'].map {|g| Terraformer.parse g}
        end
      end
    end

    def geometries
      @geometries ||= []
    end

    def to_hash
      {
        type: type,
        geometries: geometries.map(&:to_hash)
      }
    end

    def convex_hull
      ConvexHull.for geometries.map &:coordinates
    end

  end

end

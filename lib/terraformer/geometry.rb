module Terraformer

  class Geometry < Primitive

    MULTI_REGEX = /^Multi/

    attr_accessor :coordinates

    def initialize *args
      if args.length > 1 or Array === args[0]
        self.coordinates = Coordinate.from_array args
      else
        super *args do |arg|
          self.coordinates = Coordinate.from_array arg['coordinates']
        end
      end
    end

    def to_hash
      {
        type: type,
        coordinates: coordinates
      }
    end

    def to_mercator
      self.class.new *coordinates.map_coordinate(&:to_mercator)
    end

    def to_geographic
      self.class.new *coordinates.map_coordinate(&:to_geographic)
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
      raise NotImplementedError
    end

    def contains other
      raise NotImplementedError
    end

    def within other
      raise NotImplementedError
    end

    def intersects other
      raise NotImplementedError
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

  end

end

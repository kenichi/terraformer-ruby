module ArcGIS
  module Terraformer

    class Geometry

      MULTI_REGEX = /^Multi/

      attr_accessor :coordinates

      def initialize *args
        if args.length > 1
          self.coordinates = Coordinate.from_array args
        else
          arg = String === args[0] ? JSON.parse(args[0]) : args[0]
          raise ArgumentError.new "invalid argument(s): #{args}" unless Hash === arg
          raise ArgumentError.new "invalid type: #{arg['type']}" unless arg['type'] == self.type
          self.coordinates = Coordinate.from_array arg['coordinates']
        end
      end

      def type
        self.class.to_s.sub 'ArcGIS::Terraformer::', ''
      end

      def to_hash
        {
          type: type,
          coordinates: coordinates
        }
      end

      def to_json *args
        self.to_hash.to_json *args
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

      def envelope
        Bounds.envelope self
      end

      def bbox
        Bounds.bounds self
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

  end
end

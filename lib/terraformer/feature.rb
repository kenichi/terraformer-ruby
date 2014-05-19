module Terraformer

  class Feature < Primitive
    extend Forwardable

    attr_accessor :id, :geometry
    attr_writer :properties

    def_delegator :@geometry, :convex_hull

    def initialize *args
      unless args.empty?
        super *args do |arg|
          self.id = arg['id'] if arg.key? 'id'
          self.properties = arg['properties'] if arg.key? 'properties'
          self.geometry = Terraformer.parse arg['geometry']
        end
      end
    end

    def properties
      @properties ||= {}
    end

    def to_hash
      h = {
        type: type,
        properties: properties,
        geometry: geometry.to_hash
      }
      h.merge! id: id if id
      h
    end

    def great_circle_distance other
      other = other.geometry if Feature === other
      self.geometry.great_circle_distance other
    end

  end

  class FeatureCollection < Primitive

    attr_writer :features

    def initialize *args
      unless args.empty?
        super *args do |arg|
          self.features = arg['features'].map {|f| Terraformer.parse f}
        end
      end
    end

    def features
      @features ||= []
    end

    def << feature
      raise ArgumentError unless Feature === feature
      features << feature
    end

    def to_hash
      {
        type: type,
        features: features.map(&:to_hash)
      }
    end

    def convex_hull
      ConvexHull.for features.map(&:geometry).map(&:coordinates)
    end

  end

end

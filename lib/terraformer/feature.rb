module Terraformer

  class Feature < Primitive

    attr_accessor :id, :geometry
    attr_writer :properties

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

    def to_hash
      {
        type: type,
        features: features.map(&:to_hash)
      }
    end

  end

end

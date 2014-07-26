module Terraformer
  class Circle
    extend Forwardable

    attr_accessor :polygon
    attr_reader :center, :radius, :resolution
    def_delegators :@polygon, :contains?, :within?, :intersects?, :to_feature, :to_json, :to_hash

    def initialize c, r, res = DEFAULT_BUFFER_RESOLUTION
      self.center = c
      self.radius = r
      self.resolution = res
      recalculate
    end

    def recalculate
      @polygon = @center.buffer @radius, @resolution
      @dirty = false
      self
    end

    def center= c
      c = Coordinate.from_array c if Array === c and Numeric === c[0]
      c = c.coordinates if Point === c
      raise ArgumentError unless Coordinate === c
      @center = c
      @dirty = true
      self
    end

    def radius= r
      raise ArgumentError unless Numeric === r
      @radius = r
      @dirty = true
      self
    end

    def resolution= res
      raise ArgumentError unless Fixnum === res
      @resolution = res
      @dirty = true
      self
    end

    def dirty?
      @dirty
    end

  end
end

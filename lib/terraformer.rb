require 'json'
require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'

module Terraformer

  PRECISION = 8
  PI = BigMath.PI PRECISION
  DEFAULT_BUFFER_RESOLUTION = 64

  EARTH_RADIUS = 6378137.to_d
  DEGREES_PER_RADIAN = 180.0.to_d / PI
  RADIANS_PER_DEGREE = PI / 180.0.to_d
  MERCATOR_CRS = {
    type: "link",
    properties: {
      href: "http://spatialreference.org/ref/sr-org/6928/ogcwkt/",
      type: "ogcwkt"
    }
  }
  GEOGRAPHIC_CRS = {
    type: "link",
    properties: {
      href: "http://spatialreference.org/ref/epsg/4326/ogcwkt/",
      type: "ogcwkt"
    }
  }

  def self.parse geojson
    if String === geojson
      geojson = File.read geojson if File.readable? geojson
      geojson = JSON.parse geojson
    end
    raise ArgumentError.new "invalid arg: #{geojson}" unless Hash === geojson

    if klass = Terraformer.const_get(geojson['type'])
      klass.new geojson
    else
      raise ArgumentError.new 'unknown type: ' + geojson['type']
    end
  end

  class Primitive

    def initialize *args
      arg = String === args[0] ? JSON.parse(args[0]) : args[0]
      raise ArgumentError.new "invalid argument(s): #{args}" unless Hash === arg
      raise ArgumentError.new "invalid type: #{arg['type']}" unless arg['type'] == self.type
      yield arg if block_given?
    end

    def type
      self.class.to_s.sub 'Terraformer::', ''
    end

    def envelope
      Bounds.envelope self
    end

    def bbox type = :bbox
      Bounds.bounds self, type
    end

    def to_json *args
      self.to_hash.to_json *args
    end

    def [] prop
      self.__send__ prop.to_sym
    end

  end

end

module Enumerable

  def each_coordinate opts = {}, &block
    iter_coordinate :each, opts, &block
  end

  def map_coordinate opts = {}, &block
    iter_coordinate :map, opts, &block
  end
  alias_method :collect_coordinate, :map_coordinate

  def map_coordinate! opts = {}, &block
    iter_coordinate :map!, opts, &block
  end
  alias_method :collect_coordinate!, :map_coordinate!

  def iter_coordinate meth, opts = {}, &block
    opts[:recurse] = true if opts[:recurse].nil?

    if Array === self and Numeric === self[0]
      yield self
    else

      self.__send__ meth do |pair|
        raise IndexError unless Array === pair
        case pair[0]
        when Numeric
          yield pair
        when Array
          pair.iter_coordinate meth, opts, &block if opts[:recurse]
        else
          raise IndexError.new "#{pair[0]} is not a Numeric or Array type"
        end
      end
    end
  end

end

class BigDecimal

  def to_deg
    self * Terraformer::DEGREES_PER_RADIAN
  end

  def to_rad
    self * Terraformer::RADIANS_PER_DEGREE
  end

end

require 'terraformer/coordinate'
require 'terraformer/bounds'
require 'terraformer/geometry'
require 'terraformer/feature'
require 'terraformer/point'
require 'terraformer/multi_point'
require 'terraformer/line_string'
require 'terraformer/multi_line_string'
require 'terraformer/polygon'
require 'terraformer/multi_polygon'

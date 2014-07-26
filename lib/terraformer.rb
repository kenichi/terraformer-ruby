require 'json'
require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'
require 'ext/array'
require 'ext/big_decimal'
require 'ext/big_math'
require 'ext/enumerable'
require 'ext/hash'
require 'forwardable'

module Terraformer

  PRECISION = BigDecimal.double_fig
  BigDecimal.limit PRECISION
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

  def self.geojson_io data
    require 'launchy'
    Launchy.open "http://geojson.io/#data=data:application/json,#{URI.encode_www_form_component data.to_json}"
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
      h = self.to_hash *args
      args.pop if Hash === args.last
      h.to_json *args
    end

  end

end

require 'terraformer/coordinate'
require 'terraformer/geodesic'
require 'terraformer/bounds'
require 'terraformer/geometry'
require 'terraformer/feature'
require 'terraformer/point'
require 'terraformer/multi_point'
require 'terraformer/line_string'
require 'terraformer/multi_line_string'
require 'terraformer/polygon'
require 'terraformer/multi_polygon'
require 'terraformer/convex_hull'
require 'terraformer/circle'

require 'terraformer/version'

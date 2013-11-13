require 'json'
require 'bigdecimal'
require 'bigdecimal/math'
require 'bigdecimal/util'

module ArcGIS
  module Terraformer

    PRECISION = 8

    EARTH_RADIUS = 6378137.to_d
    DEGREES_PER_RADIAN = 180.0.to_d / Math::PI.to_d
    RADIANS_PER_DEGREE = Math::PI.to_d / 180.0.to_d
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
      geojson = JSON.parse geojson if String === geojson
      raise ArgumentError unless Hash === geojson

      if klass = Terraformer.const_get(geojson['type'])
        klass.new geojson
      else
        raise ArgumentError.new 'unknown type: ' + geojson['type']
      end
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
    self * ArcGIS::Terraformer::DEGREES_PER_RADIAN
  end

  def to_rad
    self * ArcGIS::Terraformer::RADIANS_PER_DEGREE
  end

end

require 'arcgis/terraformer/coordinate'
require 'arcgis/terraformer/bounds'
require 'arcgis/terraformer/geometry'
require 'arcgis/terraformer/point'
require 'arcgis/terraformer/multi_point'
require 'arcgis/terraformer/line_string'
require 'arcgis/terraformer/multi_line_string'
require 'arcgis/terraformer/polygon'
require 'arcgis/terraformer/multi_polygon'

module ArcGIS
  module Terraformer

    module Bounds
      class << self

        def bounds geojson = nil

          geojson = JSON.parse geojson if String === geojson
          unless Hash === geojson
            raise ArgumentError.new 'must be parsed or parseable geojson'
          end

          case geojson['type']
          when 'Point'
            [ geojson['coordinates'][0], geojson['coordinates'][1],
              geojson['coordinates'][0], geojson['coordinates'][1] ]
          when 'MultiPoint'
            bounds_for_array geojson['coordinates']
          when 'LineString'
            bounds_for_array geojson['coordinates']
          when 'MultiLineString'
            bounds_for_array geojson['coordinates'], 1
          when 'Polygon'
            bounds_for_array geojson['coordinates'], 1
          when 'MultiPolygon'
            bounds_for_array geojson['coordinates'], 2
          when 'Feature'
            geojson['geometry'] ? bounds(geojson['geometry']) : nil
          when 'FeatureCollection'
            bounds_for_feature_collection geojson
          when 'GeometryCollection'
            bounds_for_geometry_collection geojson
          else
            raise ArgumentError.new 'unknown type: ' + geojson['type']
          end
        end

        X1, Y1, X2, Y2 = 0, 1, 2, 3

        def bounds_for_array array, nesting = 0, box = Array.new(4)
          if nesting > 0
            array.reduce box do |b, a|
              bounds_for_array a, (nesting - 1), b
            end
          else
            array.reduce box do |b, lonlat|
              lon, lat = *lonlat
              set = ->(d, i, t){ b[i] = d if b[i].nil? or d.send(t, b[i]) }
              set[lon, X1, :<]
              set[lon, X2, :>]
              set[lat, Y1, :<]
              set[lat, Y2, :>]
              b
            end
          end
        end

        def bounds_for_feature_collection fc
          bounds_for_collection 'features', fc {|f| f['geometry']}
        end

        def bounds_for_geometry_collection gc
          bounds_for_collection 'geomteries', gc
        end

        def bounds_for_collection type, collection, &block
          extents = []
          collection[type].each do |e|
            es = bounds (block_given? ? yield(e) : e)
            extents << [ es[0], es[1] ]
            extents << [ es[2], es[3] ]
          end
          bounds extents
        end
        private :bounds_for_collection

        def envelope geojson
          b = bounds geojson
          {
            x: b[0],
            y: b[1],
            w: (b[0] - b[2]).abs,
            h: (b[1] - b[3]).abs
          }
        end

      end
    end

  end
end

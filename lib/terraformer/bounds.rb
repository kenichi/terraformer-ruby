module Terraformer

  module Bounds
    class << self

      def bounds obj, format = :bbox

        obj = Terraformer.parse obj unless Primitive === obj

        bbox = case obj.type
               when 'Point'
                 [ obj.coordinates[0], obj.coordinates[1],
                   obj.coordinates[0], obj.coordinates[1] ]
               when 'MultiPoint'
                 bounds_for_array obj.coordinates
               when 'LineString'
                 bounds_for_array obj.coordinates
               when 'MultiLineString'
                 bounds_for_array obj.coordinates, 1
               when 'Polygon'
                 bounds_for_array obj.coordinates, 1
               when 'MultiPolygon'
                 bounds_for_array obj.coordinates, 2
               when 'Feature'
                 obj.geometry ? bounds(obj.geometry) : nil
               when 'FeatureCollection'
                 bounds_for_feature_collection obj
               when 'GeometryCollection'
                 bounds_for_geometry_collection obj
               else
                 raise ArgumentError.new 'unknown type: ' + obj.type
               end

        case format
        when :bbox
          bbox
        when :polygon
          Polygon.new [[bbox[0], bbox[1]],
                       [bbox[0], bbox[3]],
                       [bbox[2], bbox[3]],
                       [bbox[2], bbox[1]],
                       [bbox[0], bbox[1]]]
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
        bounds_for_collection fc.features, &:geometry
      end

      def bounds_for_geometry_collection gc
        bounds_for_collection gc
      end

      def bounds_for_collection collection
        bounds_for_array collection.map {|e| bounds(block_given? ? yield(e) : e)}
      end
      private :bounds_for_collection

      def envelope geometry
        b = bounds geometry
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

module Terraformer

  module Bounds
    class << self

      def bounds obj, format = :bbox

        obj = Terraformer.parse obj unless Geometry === obj

        bbox = case obj
               when Point
                 [ obj.coordinates[0], obj.coordinates[1],
                   obj.coordinates[0], obj.coordinates[1] ]
               when MultiPoint, LineString,
                    MultiLineString, Polygon,
                    MultiPolygon
                 bounds_for_array obj.coordinates
               when Feature
                 obj.geometry ? bounds(obj.geometry) : nil
               when FeatureCollection
                 bounds_for_feature_collection obj
               when GeometryCollection
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

      def bounds_for_array array, box = Array.new(4)
        array.reduce box do |b, a|
          case a
          when Coordinate
            set = ->(d, i, t){ b[i] = d if b[i].nil? or d.send(t, b[i])}
            set[a[0], X1, :<]
            set[a[0], X2, :>]
            set[a[1], Y1, :<]
            set[a[1], Y2, :>]
            b
          else
            bounds_for_array a, box
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

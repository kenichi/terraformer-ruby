module Terraformer
  module ArcGIS

    COMPRESSED_REGEX = /((\+|\-)[^\+\-]+)/
    OBJECT_ID = 'OBJECTID'

    class << self

      def require_array a
        raise ArgumentError.new 'argument is not an Array' unless Array === a
      end
      private :require_array

      def decompress_geometry str
        raise ArgumentError.new 'argument is not a String' unless String === str
        x_diff_prev, y_diff_prev = 0, 0
        points = []
        x,y = nil,nil
        strings = str.scan(COMPRESSED_REGEX).map {|m| m[0]}
        coefficient = Integer(strings.shift, 32).to_f
        strings.each_slice(2) do |m,n|
          x = Integer(m, 32) + x_diff_prev
          x_diff_prev = x
          y = Integer(n, 32) + y_diff_prev
          y_diff_prev = y
          points << [x/coefficient, y/coefficient]
        end
        points
      end

      def close_ring cs
        require_array cs
        cs << cs.first if cs.first != cs.last
        cs
      end

      def clockwise? ring
        require_array ring
        total, i = 0, 0
        r_lim = ring.length - 1
        ring.each_cons(2) do |a,b|
          total += (b[0] - a[0]) * (b[1] + a[1])
          i += 1
          break if i == r_lim
        end
        total >= 0
      end

      def orient_rings polygon
        require_array polygon
        oriented = []
        outer_ring = close_ring polygon.shift
        if outer_ring.length >= 4
          outer_ring.reverse! unless clockwise? outer_ring
          oriented << outer_ring
          polygon.each do |hole|
            hole = close_ring hole
            if hole.length >= 4
              hole.reverse if clockwise? hole
            end
            oriented << hole
          end
        end
        oriented
      end

      def convert_rings rings
        require_array rings
        outer_rings, holes = [], []

        rings.each do |ring|
          ring = close_ring ring
          next if ring.length < 4
          if clockwise? ring
            outer_rings << [ring]
          else
            holes << ring
          end
        end

        holes.each do |hole|
          matched = false
          outer_rings.each do |oring|
            if Polygon.new(oring[0]).contains? Polygon.new(hole)
              oring << hole
              matched = true
              break
            end
          end
          outer_rings << [hole.reverse] unless matched
        end

        if outer_rings.length == 1
          Polygon.new outer_rings.first
        else
          polygons = outer_rings.map {|r| Polygon.new r}
          MultiPolygon.new *polygons
        end
      end

      def parse arcgis, opts = {}
        arcgis = JSON.parse arcgis if String === arcgis
        raise ArgumentError.new 'argument not hash nor json' unless Hash === arcgis

        obj = case
              when Numeric === arcgis['x'] && Numeric === arcgis['y']
                Coordinate.new(%w[x y z].map {|k| arcgis[k]}).to_point

              when arcgis['points']
                require_array arcgis['points']
                MultiPoint.new arcgis['points']

              when arcgis['paths']
                require_array arcgis['paths']
                if arcgis['paths'].length == 1
                  LineString.new arcgis['paths'][0]
                else
                  MultiLineString.new arcgis['paths']
                end

              when arcgis['rings']
                convert_rings arcgis['rings']

              when !(%w[compressedGeometry geometry attributes].map {|k| arcgis[k]}.empty?)

                if arcgis['compressedGeometry']
                  arcgis['geometry'] = {'paths' => [decompress_geometry(arcgis['compressedGeometry'])]}
                end

                o = Feature.new
                o.geometry = parse arcgis['geometry'] if arcgis['geometry']
                if attrs = arcgis['attributes']
                  o.properties = attrs.clone
                  if opts[:id_attribute] and o.properties[opts[:id_attribute]]
                    o.id = o.properties.delete opts[:id_attribute]
                  elsif o.properties[OBJECT_ID]
                    o.id = o.properties.delete OBJECT_ID
                  elsif o.properties['FID']
                    o.id = o.properties.delete 'FID'
                  end
                end
                o

              end

        isr = arcgis['geometry'] ? arcgis['geometry']['spatialReference'] : arcgis['spatialReference']
        if isr and Integer(isr['wkid']) == 102100
          if Feature === obj
            obj.geometry = obj.geometry.to_geographic
          else
            obj = obj.to_geographic
          end
        end

        obj
      end

      def convert geojson, opts = {}
        geojson = Terraformer.parse geojson unless Primitive === geojson
        opts[:id_attribute] ||= OBJECT_ID

        sr = {wkid: opts[:sr] || 4326}
        geojson_crs = GeometryCollection === geojson ? geojson.geometries.first.crs : geojson.crs
        sr[:wkid] = 102100 if geojson_crs == Terraformer::MERCATOR_CRS

        arcgis = {}

        case geojson
        when Point
          fc = geojson.first_coordinate
          arcgis[:x] = fc.x
          arcgis[:y] = fc.y
          arcgis[:z] = fc.z if fc.z
          arcgis[:spatialReference] = sr

        when MultiPoint
          arcgis[:points] = geojson.coordinates.clone
          arcgis[:spatialReference] = sr

        when LineString
          arcgis[:paths] = [geojson.coordinates.clone]
          arcgis[:spatialReference] = sr

        when MultiLineString
          arcgis[:paths] = geojson.coordinates.clone
          arcgis[:spatialReference] = sr

        when Polygon
          arcgis[:rings] = orient_rings geojson.coordinates.clone
          arcgis[:spatialReference] = sr

        when MultiPolygon
          arcgis[:rings] = flatten_multi_polygon_rings geojson.coordinates.clone
          arcgis[:spatialReference] = sr

        when Feature
          arcgis[:geometry] = convert(geojson.geometry, opts) if geojson.geometry
          arcgis[:attributes] = geojson.properties ? geojson.properties.clone : {}
          arcgis[:attributes][opts[:id_attribute]] = geojson.id if geojson.id

        when FeatureCollection
          arcgis = geojson.features.map {|f| convert f, opts}

        when GeometryCollection
          arcgis = geojson.geometries.map {|f| convert f, opts}

        end

        arcgis
      end

      def flatten_multi_polygon_rings rings
        out = []
        rings.each do |r|
          polygon = orient_rings r
          polygon.reverse.each do |p|
            out << p.dup
          end
        end
        out
      end

    end

  end
end

require_relative './helper'

describe Terraformer::Geometry do

  describe 'construction' do

    describe Terraformer::Point do

      it 'constructs from coordinate' do
        c = Terraformer::Coordinate.new -122.6764, 45.5165
        p = Terraformer::Point.new c
        p.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiPoint do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        mp = Terraformer::MultiPoint.new a, b
        mp.must_be_valid_geojson
      end

      it 'constructs from Point objects' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        mp = Terraformer::MultiPoint.new a.to_point, b.to_point
        mp.must_be_valid_geojson
      end

    end

    describe Terraformer::LineString do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        ls = Terraformer::LineString.new a, b, c
        ls.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiLineString do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        mls = Terraformer::MultiLineString.new a, b, c
        mls.must_be_valid_geojson
      end

      it 'constructs from coordinates arrays' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        d = c + [1,1]
        e = d + [0.02, 0.02]
        f = e + [0.1, -0.1]
        mls = Terraformer::MultiLineString.new [a, b, c], [d, e, f]
        mls.must_be_valid_geojson
      end

      it 'constructs from LineString objects' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        d = c + [1,1]
        e = d + [0.02, 0.02]
        f = e + [0.1, -0.1]
        ls_1 = Terraformer::LineString.new a, b, c
        ls_2 = Terraformer::LineString.new d, e, f
        mls = Terraformer::MultiLineString.new ls_1, ls_2
        mls.must_be_valid_geojson
      end

    end

    describe Terraformer::Polygon do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p = Terraformer::Polygon.new a, b, c, d, a
        p.must_be_valid_geojson
      end

      it 'constructs from coordinates array' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p = Terraformer::Polygon.new [a, b, c, d, a]
        p.must_be_valid_geojson
      end

      it 'constructs with holes from coordinates arrays' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        hole = [
          [ -122.67072200775145, 45.52438983143154 ],
          [ -122.67072200775145, 45.53241707548722 ],
          [ -122.6617956161499, 45.53241707548722 ],
          [ -122.6617956161499, 45.52438983143154 ],
          [ -122.67072200775145, 45.52438983143154 ]
        ].map {|c| Terraformer::Coordinate.new c}
        p = Terraformer::Polygon.new [a, b, c, d, a], hole
        p.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiPolygon do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        mp = Terraformer::MultiPolygon.new a, b, c, d, a
        mp.must_be_valid_geojson
      end

      it 'constructs from coordinates array' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        mp = Terraformer::MultiPolygon.new [a, b, c, d, a]
        mp.must_be_valid_geojson
      end

      it 'constructs with holes from coordinates arrays' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        hole = [
          [ -122.67072200775145, 45.52438983143154 ],
          [ -122.67072200775145, 45.53241707548722 ],
          [ -122.6617956161499, 45.53241707548722 ],
          [ -122.6617956161499, 45.52438983143154 ],
          [ -122.67072200775145, 45.52438983143154 ]
        ].map {|c| Terraformer::Coordinate.new c}
        mp = Terraformer::MultiPolygon.new [a, b, c, d, a], hole
        mp.must_be_valid_geojson
      end

      it 'constructs from Polygon objects' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p_1 = Terraformer::Polygon.new a, b, c, d, a
        e = Terraformer::Coordinate.new -122.6764, 45.5165
        f = a + [0, 0.02]
        g = b + [0.02, 0]
        h = c + [0, -0.02]
        hole = [
          [ -122.67072200775145, 45.52438983143154 ],
          [ -122.67072200775145, 45.53241707548722 ],
          [ -122.6617956161499, 45.53241707548722 ],
          [ -122.6617956161499, 45.52438983143154 ],
          [ -122.67072200775145, 45.52438983143154 ]
        ].map {|c| Terraformer::Coordinate.new c}
        p_2 = Terraformer::Polygon.new [a, b, c, d, a], hole
        mp = Terraformer::MultiPolygon.new p_1, p_2
        mp.must_be_valid_geojson
      end

    end

  end

end

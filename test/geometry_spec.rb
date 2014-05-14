require_relative './helper'

describe Terraformer::Geometry do

  describe 'construction' do

    describe Terraformer::Point do

      it 'constructs from coordinate properly' do
        c = Terraformer::Coordinate.new -122.6764, 45.5165
        p = Terraformer::Point.new c
        p.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiPoint do

      it 'constructs from coordinates properly' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        mp = Terraformer::MultiPoint.new a, b
        mp.must_be_valid_geojson
      end

    end

    describe Terraformer::LineString do

      it 'constructs from coordinates properly' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        ls = Terraformer::LineString.new a, b, c
        ls.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiLineString do

      # todo

    end

    describe Terraformer::Polygon do

      it 'constructs from coordinates properly' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p = Terraformer::Polygon.new a, b, c, d, a
        binding.pry
        p.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiPolygon do

      # todo

    end

  end

end

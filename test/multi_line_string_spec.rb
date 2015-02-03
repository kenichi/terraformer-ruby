require_relative './helper'

describe Terraformer::MultiLineString do

  describe 'construction' do

    it 'constructs from coordinates' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      b = a + [0.02, 0.02]
      c = b + [0.1, -0.1]
      mls = Terraformer::MultiLineString.new [[a, b, c]]
      mls.to_json.must_equal '{"type":"MultiLineString","coordinates":[[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]]]}'
      mls.must_be_valid_geojson
    end

    it 'constructs from array - single line' do
      mls = Terraformer::MultiLineString.new [[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]]]
      mls.to_json.must_equal '{"type":"MultiLineString","coordinates":[[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]]]}'
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
      mls.to_json.must_equal '{"type":"MultiLineString","coordinates":[[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]],[[-121.5564,46.4365],[-121.5364,46.4565],[-121.4364,46.3565]]]}'
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
      mls.to_json.must_equal '{"type":"MultiLineString","coordinates":[[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]],[[-121.5564,46.4365],[-121.5364,46.4565],[-121.4364,46.3565]]]}'
      mls.must_be_valid_geojson
    end

    it 'constructs from array - multiple lines' do
      mls = Terraformer::MultiLineString.new [[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]],[[-121.5564,46.4365],[-121.5364,46.4565],[-121.4364,46.3565]]]
      mls.to_json.must_equal '{"type":"MultiLineString","coordinates":[[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]],[[-121.5564,46.4365],[-121.5364,46.4565],[-121.4364,46.3565]]]}'
      mls.must_be_valid_geojson
    end

  end

  describe 'methods' do
    before :each do
      @a = Terraformer::Coordinate.new -122.6764, 45.5165
      @b = @a + [0.02, 0.02]
      @c = @b + [0.1, -0.1]
      @d = @c + [1,1]
      @e = @d + [0.02, 0.02]
      @f = @e + [0.1, -0.1]
      @mls = Terraformer::MultiLineString.new [@a, @b, @c], [@d, @e, @f]
    end

    it 'should have coordinates' do
      @mls.coordinates.must_equal [[@a, @b, @c], [@d, @e, @f]]
    end

    it 'should have first coordinates' do
      @mls.first_coordinate.must_equal @a
    end
  end
end

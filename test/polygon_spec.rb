require_relative './helper'

describe Terraformer::Polygon do

  describe 'construction' do
    it 'constructs from coordinates' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      b = a + [0, 0.02]
      c = b + [0.02, 0]
      d = c + [0, -0.02]
      p = Terraformer::Polygon.new a, b, c, d, a
      p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]}'
      p.must_be_valid_geojson
    end

    it 'constructs from coordinates array' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      b = a + [0, 0.02]
      c = b + [0.02, 0]
      d = c + [0, -0.02]
      p = Terraformer::Polygon.new [a, b, c, d, a]
      p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]}'
      p.must_be_valid_geojson
    end

    it 'constructs from array' do
      p = Terraformer::Polygon.new [[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]
      p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]}'
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
      p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]}'
      p.must_be_valid_geojson
    end

    it 'constructs with holes from array' do
      p = Terraformer::Polygon.new [[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]
      p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]}'
      p.must_be_valid_geojson
    end

    describe 'modification methods' do

      before :each do
        @a = Terraformer::Coordinate.new -122, 45
        @b = @a + [0.1, 0.1]
        @c = @b + [0.1, 0.1]

        @p = Terraformer::Polygon.new @a, @b, @c, @a

        @d = @c + [0.1, 0.1]
      end

      it 'should add coordinate' do
        @p.add_vertex @d
        @p.coordinates.must_equal [[ @a, @b, @c, @d, @a ]]
      end

      it 'should add point' do
        d = Terraformer::Point.new @d
        @p.add_vertex d
        @p.coordinates.must_equal [[ @a, @b, @c, @d, @a ]]
      end

      it 'should return add argument error' do
        assert_raises ArgumentError do
          @p.add_vertex 1
        end
      end

      it 'should << coordinate' do
        @p << @d
        @p.coordinates.must_equal [[ @a, @b, @c, @d, @a ]]
      end

      it 'should << point' do
        d = Terraformer::Point.new @d
        @p << d
        @p.coordinates.must_equal [[ @a, @b, @c, @d, @a ]]
      end

      it 'should return << argument error' do
        assert_raises ArgumentError do
          @p << 1
        end
      end

      it 'should insert coordinate' do
        @p.insert_vertex 1, @d
        @p.coordinates.must_equal [[ @a, @d, @b, @c, @a ]]
      end

      it 'should insert point' do
        d = Terraformer::Point.new @d
        @p.insert_vertex 1, d
        @p.coordinates.must_equal [[ @a, @d, @b, @c, @a ]]
      end

      it 'should return insert argument error' do
        assert_raises ArgumentError do
          @p.insert_vertex 1, 1
        end
      end

      it 'should remove coordinate' do
        @p.remove_vertex @b
        @p.coordinates.must_equal [[ @a, @c, @a ]]
      end

      it 'should remove point' do
        d = Terraformer::Point.new @b
        @p.remove_vertex d
        @p.coordinates.must_equal [[ @a, @c, @a ]]
      end

      it 'should return remove argument error' do
        assert_raises ArgumentError do
          @p.remove_vertex 1
        end
      end

      it 'should remove vertex at index' do
        @p.remove_vertex_at 1
        @p.coordinates.must_equal [[ @a, @c, @a ]]
      end
    end

  end
end

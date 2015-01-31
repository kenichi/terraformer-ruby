require_relative './helper'

describe Terraformer::LineString do

  describe 'construction' do

    it 'constructs from coordinates' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      b = a + [0.02, 0.02]
      c = b + [0.1, -0.1]
      ls = Terraformer::LineString.new a, b, c
      ls.to_json.must_equal '{"type":"LineString","coordinates":[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]]}'
      ls.must_be_valid_geojson
    end

    it 'constructs from array' do
      ls = Terraformer::LineString.new [[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]]
      ls.to_json.must_equal '{"type":"LineString","coordinates":[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]]}'
      ls.must_be_valid_geojson
    end

    it 'constructs from array of points' do
      ls = Terraformer::LineString.new [-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]
      ls.to_json.must_equal '{"type":"LineString","coordinates":[[-122.6764,45.5165],[-122.6564,45.5365],[-122.5564,45.4365]]}'
      ls.must_be_valid_geojson
    end
  end

  describe 'methods' do
    before :each do
      @c1 = Terraformer::Coordinate.new -122.6764, 45.5165
      @c2 = @c1 + [0.02, 0.02]
      @c3 = @c2 + [0.1, -0.1]
      @l = Terraformer::LineString.new @c1, @c2, @c3
    end

    it 'should have coordinates' do
      @l.coordinates.must_equal [@c1, @c2, @c3]
    end

    it 'should have first coordinates' do
      @l.first_coordinate.must_equal @c1
    end

    describe 'linear ring' do
      it 'should not be linear ring' do
        assert !@l.linear_ring?
      end

      it 'should be linear ring' do
        @l.add_vertex @c1
        assert @l.linear_ring?
      end
    end

    it 'should get points' do
      points = [@c1.to_point, @c2.to_point, @c3.to_point]

      @l.points.must_equal points
      @l.vertices.must_equal points
    end

    it 'should get point at' do
      @l.point_at(1).must_equal Terraformer::Point.new(@c2)
      @l.vertex_at(1).must_equal Terraformer::Point.new(@c2)
    end

  end

  describe 'modification methods' do
    before :each do
      @c1 = Terraformer::Coordinate.new -122.6764, 45.5165
      @c2 = @c1 + [0.02, 0.02]
      @c3 = @c2 + [0.1, -0.1]
      @l = Terraformer::LineString.new @c1, @c2, @c3

      @c4 = @c3 + [0.5, -0.3]
    end

    it 'should add coordinate' do
      @l.add_vertex @c4
      @l.coordinates.must_equal [ @c1, @c2, @c3, @c4 ]
    end

    it 'should add point' do
      p = Terraformer::Point.new @c4
      @l.add_vertex p
      @l.coordinates.must_equal [ @c1, @c2, @c3, @c4 ]
    end

    it 'should return add argument error' do
      assert_raises ArgumentError do
        @l.add_vertex 1
      end
    end

    it 'should << coordinate' do
      @l << @c4
      @l.coordinates.must_equal [ @c1, @c2, @c3, @c4 ]
    end

    it 'should << point' do
      p = Terraformer::Point.new @c4
      @l << p
      @l.coordinates.must_equal [ @c1, @c2, @c3, @c4 ]
    end

    it 'should return add argument error' do
      assert_raises ArgumentError do
        @l << 1
      end
    end

    it 'should insert coordinate' do
      @l.insert_vertex 1, @c4
      @l.coordinates.must_equal [ @c1, @c4, @c2, @c3 ]
    end

    it 'should insert point ' do
      p = Terraformer::Point.new @c4
      @l.insert_vertex 1, p
      @l.coordinates.must_equal [ @c1, @c4, @c2, @c3 ]
    end

    it 'should return insert argument error' do
      assert_raises ArgumentError do
        @l.insert_vertex 1, 1
      end
    end

    it 'should remove coordinate' do
      @l.remove_vertex @c3
      @l.coordinates.must_equal [ @c1, @c2 ]
    end

    it 'should remove point' do
      @l.remove_vertex Terraformer::Point.new(@c3)
      @l.coordinates.must_equal [ @c1, @c2 ]
    end

    it 'should return remove argument error' do
      assert_raises ArgumentError do
        @l.remove_vertex 1
      end
    end

    it 'should remove vertex at index' do
      @l.remove_vertex_at 1
      @l.coordinates.must_equal [ @c1, @c3 ]
    end

  end

end

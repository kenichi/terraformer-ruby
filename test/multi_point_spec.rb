require_relative './helper'

describe Terraformer::MultiPoint do

  describe 'construction' do

    it 'constructs from coordinates' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      b = a + [0.02, 0.02]
      mp = Terraformer::MultiPoint.new a, b
      mp.to_json.must_equal '{"type":"MultiPoint","coordinates":[[-122.6764,45.5165],[-122.6564,45.5365]]}'
      mp.must_be_valid_geojson
    end

    it 'constructs from Point objects' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      b = a + [0.02, 0.02]
      mp = Terraformer::MultiPoint.new a.to_point, b.to_point
      mp.to_json.must_equal '{"type":"MultiPoint","coordinates":[[-122.6764,45.5165],[-122.6564,45.5365]]}'
      mp.must_be_valid_geojson
    end

    it 'constructs from array' do
      mp = Terraformer::MultiPoint.new [[-122.6764, 45.5165],[-122.6564, 45.5365]]
      mp.to_json.must_equal '{"type":"MultiPoint","coordinates":[[-122.6764,45.5165],[-122.6564,45.5365]]}'
      mp.must_be_valid_geojson
    end

    it 'constructs from multiple point arrays' do
      mp = Terraformer::MultiPoint.new [-122.6764, 45.5165],[-122.6564, 45.5365]
      mp.to_json.must_equal '{"type":"MultiPoint","coordinates":[[-122.6764,45.5165],[-122.6564,45.5365]]}'
      mp.must_be_valid_geojson
    end

  end
  describe 'methods' do
    before :each do
      @p1 = Terraformer::Point.new -122.6764, 45.5165
      @p2 = Terraformer::Point.new -122.6564, 45.5365
      @mp = Terraformer::MultiPoint.new @p1, @p2
    end

    it 'should have coordinates' do
      c = Terraformer::Coordinate.new -122.6764, 45.5165
      d = Terraformer::Coordinate.new -122.6564, 45.5365
      @mp.coordinates.must_equal [c,d]
    end

    it 'should have first_coordinate' do
      c = Terraformer::Coordinate.new -122.6764, 45.5165
      @mp.first_coordinate.must_equal c
    end

    it 'should return points' do
      @mp.points.must_equal [ @p1, @p2 ]
    end

    describe 'contains?' do
      it 'should contain any included points' do
        assert @mp.contains?(@p1)

      end

      it 'should not contain point' do
        p = Terraformer::Point.new -122, 45
        assert !@mp.contains?(p)
      end
    end
  end

  describe 'modification methods' do
    before :each do
      @p1 = Terraformer::Point.new -122.6764, 45.5165
      @p2 = Terraformer::Point.new -122.6564, 45.5365
      @mp = Terraformer::MultiPoint.new @p1, @p2

      @p3 = Terraformer::Point.new -122.6364, 45.5565
    end

    it 'should add point' do
      @mp.add_point @p3
      @mp.points.must_equal [ @p1, @p2, @p3 ]
    end

    it 'should add coordinate' do
      @mp.add_point @p3.first_coordinate
      @mp.points.must_equal [ @p1, @p2, @p3 ]
    end

    it 'should return add argument error' do
      assert_raises ArgumentError do
        @mp.add_point 1
      end
    end

    it 'should << point' do
      @mp << @p3
      @mp.points.must_equal [ @p1, @p2, @p3 ]
    end

    it 'should << coordinate' do
      @mp << @p3.first_coordinate
      @mp.points.must_equal [ @p1, @p2, @p3 ]
    end

    it 'should return << argument error' do
      assert_raises ArgumentError do
        @mp << 1
      end
    end

    it 'should insert point' do
      @mp.insert_point 1, @p3
      @mp.points.must_equal [ @p1, @p3, @p2 ]
    end

    it 'should insert coordinate' do
      @mp.insert_point 1, @p3.first_coordinate
      @mp.points.must_equal [ @p1, @p3, @p2 ]
    end

    it 'should return insert argument error' do
      assert_raises ArgumentError do
        @mp.insert_point 1, 1
      end
    end

    it 'should remove point' do
      @mp.remove_point @p2
      @mp.points.must_equal [ @p1 ]
    end

    it 'should remove coordinate' do
      @mp.remove_point @p2.first_coordinate
      @mp.points.must_equal [ @p1 ]
    end

    it 'should return remove argument error' do
      assert_raises ArgumentError do
        @mp.remove_point 1
      end
    end

    it 'should remove point at index' do
      @mp.remove_point_at 0
      @mp.points.must_equal [ @p2 ]
    end

  end

end

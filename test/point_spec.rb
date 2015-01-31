require_relative './helper'

describe Terraformer::Point do

  describe 'construction' do
    it 'constructs from coordinate' do
      c = Terraformer::Coordinate.new -122.6764, 45.5165
      p = Terraformer::Point.new c
      p.must_be_valid_geojson
      p.to_json.must_equal '{"type":"Point","coordinates":[-122.6764,45.5165]}'
    end

    it 'constructs from array' do
      p = Terraformer::Point.new [-122.6764, 45.5165]
      p.must_be_valid_geojson
      p.to_json.must_equal '{"type":"Point","coordinates":[-122.6764,45.5165]}'
    end

    it 'costructs from numeric' do
      p = Terraformer::Point.new -122.6764, 45.5165
      p.must_be_valid_geojson
      p.to_json.must_equal '{"type":"Point","coordinates":[-122.6764,45.5165]}'
    end
  end

  describe 'methods' do
    before :each do
      @p = Terraformer::Point.new [-122.6764, 45.5165]
    end

    it 'should have coordinates' do
      c = Terraformer::Coordinate.new -122.6764, 45.5165
      @p.coordinates.must_equal c
    end

    it 'first_coordinate should equal coordinates' do
      @p.first_coordinate.must_equal @p.coordinates
    end

    describe 'distance and bearing' do
      before :each do
        @p2 = Terraformer::Point.new [-122, 45]
      end

      it 'should get distance_and_bearing_to point' do
        dabt = @p.distance_and_bearing_to(@p2)
        dabt[0][:distance].must_equal 78159.08126203461
        dabt[0][:bearing][:initial].must_equal 136.9932756675306
        dabt[0][:bearing][:final].must_equal 137.473721440933
      end

      it 'should get distance_to point' do
        @p.distance_to(@p2).must_equal 78159.08126203461
      end

      it 'should get initial_bearing_to point' do
        @p.initial_bearing_to(@p2).must_equal 136.9932756675306
      end

      it 'should get final_bearing_to point' do
        @p.final_bearing_to(@p2).must_equal 137.473721440933
      end

      # TODO: write tests for different types of objects
    end

    describe 'contains?' do

      it 'should contains equal point' do
        assert @p.contains?(@p)
      end

      it 'should not contains unequal point' do
        p2 = Terraformer::Point.new [-122, 45]
        assert !@p.contains?(p2)
      end

      it 'should error on contains for other type' do
        l = Terraformer::LineString.new [-122, 45], [-123, 46]

        assert_raises ArgumentError do
          !@p.contains?(l)
        end

      end
    end

    describe 'within?' do

      it 'should be within same point' do
        assert @p.within?(@p)
      end

      it 'should not be within unequal point' do
        p2 = Terraformer::Point.new [-122, 45]
        assert !@p.within?(p2)
      end

      # TODO: write tests for other classes
    end

  end


end

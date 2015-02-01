require_relative './helper'

describe Terraformer::Circle do

  describe 'construction' do
    it 'constrcuts from integers' do
      c = Terraformer::Circle.new [-122.6764, 45.5165], 100

      assert !c.dirty?
      c.center.x.must_equal -122.6764
      c.center.y.must_equal 45.5165
      c.radius.must_equal 100
      c.resolution.must_equal Terraformer::DEFAULT_BUFFER_RESOLUTION
    end

    it 'constructs from coordinate' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      c = Terraformer::Circle.new a, 100

      assert !c.dirty?
      c.center.must_equal a
      c.radius.must_equal 100
      c.resolution.must_equal Terraformer::DEFAULT_BUFFER_RESOLUTION
    end

    it 'constructs from point' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      p = Terraformer::Point.new a
      c = Terraformer::Circle.new p, 100

      assert !c.dirty?
      c.center.must_equal a
      c.radius.must_equal 100
      c.resolution.must_equal Terraformer::DEFAULT_BUFFER_RESOLUTION
    end


    it 'constructs from coordinate with res' do
      a = Terraformer::Coordinate.new -122.6764, 45.5165
      c = Terraformer::Circle.new a, 100, 10

      assert !c.dirty?
      c.center.must_equal a
      c.radius.must_equal 100
      c.resolution.must_equal 10

      # todo: how to test size of polygon?
    end
  end

  describe 'modification' do
    before :each do
      @c = Terraformer::Circle.new [-122.6764, 45.5165], 100
    end

    it 'should be dirty after setting center' do
      @c.center = [-122, 45]

      assert @c.dirty?
      @c.center.x.must_equal -122
    end

  end
end

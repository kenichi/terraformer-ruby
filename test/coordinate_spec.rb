require_relative './helper'

describe Terraformer::Coordinate do

  describe 'from' do
    it 'should accept nested arrays' do
      arys = [[100,0], [101,1], [102,2]]
      c = Terraformer::Coordinate.from arys

      c.class.must_equal Array
      c[0].class.must_equal Terraformer::Coordinate
      c[0].x.must_equal 100
      c[0].y.must_equal 0
      c[1].class.must_equal Terraformer::Coordinate
      c[1].x.must_equal 101
      c[1].y.must_equal 1
      c[2].class.must_equal Terraformer::Coordinate
      c[2].x.must_equal 102
      c[2].y.must_equal 2
    end

    it 'should accept double nested arrays' do
      arys = [[[100,0], [101,1]], [[102,2], [103,3]]]
      c = Terraformer::Coordinate.from arys

      c.class.must_equal Array
      c[0].class.must_equal Array
      c[0][0].class.must_equal Terraformer::Coordinate
      c[0][0].x.must_equal 100
      c[0][0].y.must_equal 0
    end
  end

  describe 'from_array' do

    it 'should be called from Array.to_c' do
      c = [100,0].to_c

      c.class.must_equal Terraformer::Coordinate
      c.x.must_equal 100
      c.y.must_equal 0
    end

    it 'should accept [100, 0]' do
      c = Terraformer::Coordinate.from_array [100, 0]

      c.class.must_equal Terraformer::Coordinate
      c.x.must_equal 100
      c.y.must_equal 0
    end

    it 'should accept nested arrays' do
      arys = [[100,0], [101,1], [102,2]]
      c = Terraformer::Coordinate.from_array arys

      c.class.must_equal Array
      c[0].class.must_equal Terraformer::Coordinate
      c[0].x.must_equal 100
      c[0].y.must_equal 0
      c[1].class.must_equal Terraformer::Coordinate
      c[1].x.must_equal 101
      c[1].y.must_equal 1
      c[2].class.must_equal Terraformer::Coordinate
      c[2].x.must_equal 102
      c[2].y.must_equal 2
    end

    it 'should accept double nested arrays' do
      arys = [[[100,0], [101,1]], [[102,2], [103,3]]]
      c = Terraformer::Coordinate.from_array arys

      c.class.must_equal Array
      c[0].class.must_equal Array
      c[0][0].class.must_equal Terraformer::Coordinate
      c[0][0].x.must_equal 100
      c[0][0].y.must_equal 0
    end

    it 'should accept triple nested arrays' do
      arys = [[[[100,0], [101,1]]]]
      c = Terraformer::Coordinate.from_array arys

      c.class.must_equal Array
      c[0].class.must_equal Array
      c[0][0].class.must_equal Array
      c[0][0][0].class.must_equal Terraformer::Coordinate
      c[0][0][0].x.must_equal 100
      c[0][0][0].y.must_equal 0
    end
  end

  describe 'initialize' do

    it 'accepts numbers as params: x,y' do
      c = Terraformer::Coordinate.new 100, 0

      c.x.must_equal 100
      c.y.must_equal 0
      c.z.must_equal nil
      #c.to_s.must_equal '100,0'
    end

    it 'accepts numbers as params: x,y,z' do
      c = Terraformer::Coordinate.new 100, 0, 0

      c.x.must_equal 100
      c.y.must_equal 0
      c.z.must_equal 0
      #c.to_s.must_equal '100,0,0'
    end

    it 'accepts an array as params: x,y' do
      c = Terraformer::Coordinate.new [100, 0]

      c.x.must_equal 100
      c.y.must_equal 0
      c.z.must_equal nil
      #c.to_s.must_equal '100,0'
    end

    it 'accepts an array as params: x,y,z' do
      c = Terraformer::Coordinate.new [100, 0, 0]

      c.x.must_equal 100
      c.y.must_equal 0
      c.z.must_equal 0
      #c.to_s.must_equal '100,0,0'
    end

    it 'does not allow mixed params' do
      assert_raises ArgumentError do
        Terraformer::Coordinate.new [100,0], 0
      end

      assert_raises ArgumentError do
        Terraformer::Coordinate.new 100
      end

      assert_raises ArgumentError do
        Terraformer::Coordinate.new {}
      end
    end
  end

  describe 'equality' do
    it 'should be equal' do
      c1 = Terraformer::Coordinate.new 100, 0
      c2 = Terraformer::Coordinate.new 100, 0

      c1.must_equal c2
    end

    it 'should not be equal' do
      c1 = Terraformer::Coordinate.new 100, 0
      c2 = Terraformer::Coordinate.new 101, 0

      c1.wont_equal c2
    end
  end

  describe 'maths' do
    it 'should add' do
      c = Terraformer::Coordinate.new 100, 0
      c = c + [1, 1]

      c.x.must_equal 101
      c.y.must_equal 1
    end

    it 'should subtract' do
      c = Terraformer::Coordinate.new 100, 0
      c = c - [1, 1]

      c.x.must_equal 99
      c.y.must_equal -1
    end

    it 'should calculate euclidean distance' do
      c1 = Terraformer::Coordinate.new 100, 0
      c2 = Terraformer::Coordinate.new 102, 2

      ed = c1.euclidean_distance_to(c2)
      ed.to_s('F').must_equal "2.82842712474619"
    end

    it 'should calculate squared euclidean distance' do
      c1 = Terraformer::Coordinate.new 100, 0
      c2 = Terraformer::Coordinate.new 102, 2

      ed = c1.squared_euclidean_distance_to(c2)
      ed.to_s('F').must_equal "8.0"
    end

    it 'should calculate haversine distance' do
      c1 = Terraformer::Coordinate.new 100, 0
      c2 = Terraformer::Coordinate.new 102, 2

      ed = c1.haversine_distance_to(c2)
      ed.to_s('F').must_equal "314475.2493440403"
    end

    it 'should calculate distance and bearing' do
      c1 = Terraformer::Coordinate.new 100, 0
      c2 = Terraformer::Coordinate.new 102, 2

      db = c1.distance_and_bearing_to(c2)
      db.class.must_equal Hash

      db[:distance].to_s('F').must_equal "314037.6739419673"
      db[:bearing][:initial].to_s('F').must_equal "45.17484844056842"
      db[:bearing][:final].to_s('F').must_equal "45.20976211316248"

      d = c1.distance_to c2
      d.must_equal db[:distance]

      ib = c1.initial_bearing_to c2
      ib.must_equal db[:bearing][:initial]

      fb = c1.final_bearing_to c2
      fb.must_equal db[:bearing][:final]

    end
  end
end


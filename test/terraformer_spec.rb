require_relative './helper'

describe Terraformer do

  it 'dont be terrible ok' do
    Terraformer.dont_be_terrible_ok
  end

  describe 'parsing' do

    it 'parses points' do
      p = Terraformer.parse EXAMPLES[:point]
      p.dont_be_terrible_ok
      p.type.must_equal 'Point'
      p.coordinates.must_be_instance_of Terraformer::Coordinate
      p.coordinates.must_equal Terraformer::Coordinate.new 100, 0
    end

    it 'parses multi points' do
      p = Terraformer.parse EXAMPLES[:multi_point]
      p.dont_be_terrible_ok
      p.type.must_equal 'MultiPoint'
      p.coordinates.must_be_instance_of Array
      p.coordinates.length.must_equal 2
      p.coordinates[0].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[1].must_equal Terraformer::Coordinate.new 101, 1
    end

    it 'parses line strings' do
      p = Terraformer.parse EXAMPLES[:line_string]
      p.dont_be_terrible_ok
      p.type.must_equal 'LineString'
      p.coordinates.must_be_instance_of Array
      p.coordinates.length.must_equal 2
      p.coordinates[0].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[1].must_equal Terraformer::Coordinate.new 101, 1
    end

    it 'parses multi line strings' do
      p = Terraformer.parse EXAMPLES[:multi_line_string]
      p.dont_be_terrible_ok
      p.type.must_equal 'MultiLineString'
      p.coordinates.must_be_instance_of Array
      p.coordinates.length.must_equal 2
      p.coordinates[0].must_be_instance_of Array
      p.coordinates[0][0].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[0][1].must_equal Terraformer::Coordinate.new 101, 1
      p.coordinates[1].must_be_instance_of Array
      p.coordinates[1][0].must_equal Terraformer::Coordinate.new 102, 2
      p.coordinates[1][1].must_equal Terraformer::Coordinate.new 103, 3
    end

    it 'parses polygons' do
      p = Terraformer.parse EXAMPLES[:polygon]
      p.dont_be_terrible_ok
      p.type.must_equal 'Polygon'
      p.coordinates.must_be_instance_of Array
      p.coordinates[0].must_be_instance_of Array
      p.coordinates[0][0].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[0][1].must_equal Terraformer::Coordinate.new 101, 0
      p.coordinates[0][2].must_equal Terraformer::Coordinate.new 101, 1
      p.coordinates[0][3].must_equal Terraformer::Coordinate.new 100, 1
      p.coordinates[0][4].must_equal Terraformer::Coordinate.new 100, 0
      refute p.has_holes?
    end

    it 'parses polygons with holes' do
      p = Terraformer.parse EXAMPLES[:polygon_with_holes]
      p.dont_be_terrible_ok
      p.type.must_equal 'Polygon'
      p.coordinates.must_be_instance_of Array
      p.coordinates[0].must_be_instance_of Array
      p.coordinates[0][0].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[0][1].must_equal Terraformer::Coordinate.new 101, 0
      p.coordinates[0][2].must_equal Terraformer::Coordinate.new 101, 1
      p.coordinates[0][3].must_equal Terraformer::Coordinate.new 100, 1
      p.coordinates[0][4].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[1].must_be_instance_of Array
      p.coordinates[1][0].must_equal Terraformer::Coordinate.new 100.2, 0.2
      p.coordinates[1][1].must_equal Terraformer::Coordinate.new 100.8, 0.2
      p.coordinates[1][2].must_equal Terraformer::Coordinate.new 100.8, 0.8
      p.coordinates[1][3].must_equal Terraformer::Coordinate.new 100.2, 0.8
      p.coordinates[1][4].must_equal Terraformer::Coordinate.new 100.2, 0.2
      assert p.has_holes?
    end

    it 'parses multipolygons' do
      p = Terraformer.parse EXAMPLES[:multi_polygon]
      p.dont_be_terrible_ok
      p.type.must_equal 'MultiPolygon'
      p.coordinates[0].must_be_instance_of Array
      p.coordinates[0][0].must_be_instance_of Array
      p.coordinates[0][0][0].must_equal Terraformer::Coordinate.new 102, 2
      p.coordinates[0][0][1].must_equal Terraformer::Coordinate.new 103, 2
      p.coordinates[0][0][2].must_equal Terraformer::Coordinate.new 103, 3
      p.coordinates[0][0][3].must_equal Terraformer::Coordinate.new 102, 3
      p.coordinates[0][0][4].must_equal Terraformer::Coordinate.new 102, 2
      p.coordinates[1].must_be_instance_of Array
      p.coordinates[1][0].must_be_instance_of Array
      p.coordinates[1][0][0].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[1][0][1].must_equal Terraformer::Coordinate.new 101, 0
      p.coordinates[1][0][2].must_equal Terraformer::Coordinate.new 101, 1
      p.coordinates[1][0][3].must_equal Terraformer::Coordinate.new 100, 1
      p.coordinates[1][0][4].must_equal Terraformer::Coordinate.new 100, 0
      p.coordinates[1][1].must_be_instance_of Array
      p.coordinates[1][1][0].must_equal Terraformer::Coordinate.new 100.2, 0.2
      p.coordinates[1][1][1].must_equal Terraformer::Coordinate.new 100.8, 0.2
      p.coordinates[1][1][2].must_equal Terraformer::Coordinate.new 100.8, 0.8
      p.coordinates[1][1][3].must_equal Terraformer::Coordinate.new 100.2, 0.8
      p.coordinates[1][1][4].must_equal Terraformer::Coordinate.new 100.2, 0.2
    end

    it 'parses as geographic' do
      [:point, :multi_point, :line_string, :multi_line_string,
       :polygon, :polygon_with_holes, :multi_polygon].each do |type|
        g = Terraformer.parse EXAMPLES[type]
        assert g.geographic?
      end
    end

  end

  describe 'coordinates' do

    it 'buffers into circles' do
      p = Terraformer.parse EXAMPLES[:point]
      p.dont_be_terrible_ok
      p.type.must_equal 'Point'
      p.coordinates.must_be_instance_of Terraformer::Coordinate
      p.coordinates.must_equal Terraformer::Coordinate.new 100, 0
      c = p.coordinates.buffer 100
      JSON.parse(c.to_json).must_equal JSON.parse(EXAMPLES[:circle])
    end

    it 'rounds buffered vertices to PRECISION' do
      p = Terraformer.parse EXAMPLES[:point]
      p.dont_be_terrible_ok
      c = p.coordinates.buffer 100
      splitter = ->(d) {
        a = d.split
        a[1][a[3]..-1].length
      }
      c.coordinates.each_coordinate do |c|
        splitter[c.x].must_be :<=, Terraformer::PRECISION
        splitter[c.x].must_be :<=, Terraformer::PRECISION
      end
    end

  end

end

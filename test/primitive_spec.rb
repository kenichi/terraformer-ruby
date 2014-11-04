require_relative './helper'

describe Terraformer::Primitive do

  describe 'envelope' do

    it 'returns envelope with ne origin and size' do
      c = Terraformer.parse EXAMPLES[:circle]
      c.dont_be_terrible_ok
      env = c.envelope
      env[:x].must_equal BigDecimal("0.9999910168471585E2")
      env[:y].must_equal BigDecimal("-0.8983152838976E-3")
      env[:w].must_equal BigDecimal("0.179663056825E-2")
      env[:h].must_equal BigDecimal("0.17966305681389E-2")
    end

  end

  describe 'bbox' do

    it 'returns a geojson bounding box' do
      c = Terraformer.parse EXAMPLES[:circle]
      c.dont_be_terrible_ok
      bbox = c.bbox
      bbox.must_equal ["0.9999910168471585E2",
                       "-0.8983152838976E-3",
                       "0.1000008983152841E3",
                       "0.8983152842413E-3"].map {|n| BigDecimal(n)}
    end

    it 'returns a geojson polygon of the bounding box' do
      c = Terraformer.parse EXAMPLES[:circle]
      c.dont_be_terrible_ok
      bbox = c.bbox :polygon
      expected = Terraformer::Polygon.new [[99.99910168471585, -0.0008983152838976],
                                           [99.99910168471585, 0.0008983152842413],
                                           [100.0008983152841, 0.0008983152842413],
                                           [100.0008983152841, -0.0008983152838976],
                                           [99.99910168471585, -0.0008983152838976]]
      bbox.must_equal expected
    end

    it 'works on features' do
      wc = Terraformer.parse EXAMPLES[:waldocanyon]
      bbox = wc.bbox
      bbox.dont_be_terrible_ok
    end

  end

  describe 'to_json' do

    it 'returns a geojson object' do
      c = Terraformer.parse EXAMPLES[:circle]
      JSON.parse(c.to_json).must_equal JSON.parse(EXAMPLES[:circle])
    end

    it 'returns a geojson object with bbox' do
      c = Terraformer.parse EXAMPLES[:circle]
      expected = JSON.parse(EXAMPLES[:circle])
      expected['bbox'] = [0.9999910168471585E2,
                          -0.8983152838976E-3,
                          0.1000008983152841E3,
                          0.8983152842413E-3]
      JSON.parse(c.to_json(include_bbox: true)).must_equal expected
    end

  end

end

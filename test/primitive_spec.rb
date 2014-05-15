require_relative './helper'

describe Terraformer::Primitive do

  describe 'envelope' do

    it 'returns envelope with ne origin and size' do
      c = Terraformer.parse EXAMPLES[:circle]
      c.dont_be_terrible_ok
      env = c.envelope
      env[:x].must_equal BigDecimal('0.999991016847159E2')
      env[:y].must_equal BigDecimal('-0.898315283897559E-3')
      env[:w].must_equal BigDecimal('0.17966305681E-2')
      env[:h].must_equal BigDecimal('0.1796630568138893E-2')
    end

  end

  describe 'bbox' do

    it 'returns a geojson bounding box' do
      c = Terraformer.parse EXAMPLES[:circle]
      c.dont_be_terrible_ok
      bbox = c.bbox
      bbox.must_equal ["0.999991016847159E2",
                       "-0.898315283897559E-3",
                       "0.100000898315284E3",
                       "0.898315284241334E-3"].map {|n| BigDecimal(n)}
    end

    it 'returns a geojson polygon of the bounding box' do
      c = Terraformer.parse EXAMPLES[:circle]
      c.dont_be_terrible_ok
      bbox = c.bbox :polygon
      expected = Terraformer::Polygon.new [ [ 99.9991016847159, -0.000898315283897559 ],
                                            [ 99.9991016847159, 0.000898315284241334 ],
                                            [ 100.000898315284, 0.000898315284241334 ],
                                            [ 100.000898315284, -0.000898315283897559 ],
                                            [ 99.9991016847159, -0.000898315283897559 ] ]
      binding.pry
      bbox.must_equal expected
    end

  end

  describe 'to_json' do
  end

  describe 'property accessor' do
  end

end

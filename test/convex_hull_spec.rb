require_relative './helper'

describe Terraformer::ConvexHull do

  EXAMPLES.not(:multi_line_string).each do |key, geo|
    it "works on #{key}" do
      ch = Terraformer.parse(geo).convex_hull
      ch.dont_be_terrible_ok
      ch.must_be_valid_geojson
    end
  end

  it 'raises without enough points' do
    ->{ Terraformer.parse(EXAMPLES[:multi_line_string]).convex_hull }.must_raise ArgumentError
  end

  it 'works on feature collections' do
    fc = Terraformer::FeatureCollection.new
    fc << Terraformer.parse(EXAMPLES[:waldocanyon])
    fc << Terraformer.parse(EXAMPLES[:sf_county]).to_feature
    ch = fc.convex_hull
    ch.dont_be_terrible_ok
    ch.must_be_valid_geojson
  end

end

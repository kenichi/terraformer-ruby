require 'bundler'
Bundler.require :default, :test

require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path '../../lib', __FILE__
$:.unshift lib unless $:.include? lib
require 'terraformer'

module MiniTest::Expectations

  GEOJSON_VALIDATE_URL = 'http://geojsonlint.com/validate'

  def validate_geojson geojson_h
    r = JSON.parse HTTP['Content-Type' => 'application/json'].post(GEOJSON_VALIDATE_URL, json: geojson_h).body
    r['status'].must_equal 'ok'
  end

  infect_an_assertion :refute_nil, :dont_be_terrible_ok, :unary
  infect_an_assertion :validate_geojson, :must_be_valid_geojson, :unary
end

examples = File.expand_path '../examples', __FILE__
EXAMPLES = Dir[examples + '/*.geojson'].reduce({}) do |h, gj|
  h[gj.sub(examples+'/','').sub(/\.geojson$/,'').to_sym] =
    File.read(gj).gsub(/\r*\n*/,'').gsub('  ',' ')
  h
end

PARSED_EXAMPLES = EXAMPLES.keys.reduce({}){|h,k| h[k] = Terraformer.parse EXAMPLES[k]; h}


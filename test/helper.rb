require 'bundler'
Bundler.require :default, :test

require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path '../../lib', __FILE__
$:.unshift lib unless $:.include? lib
require 'terraformer'

module MiniTest::Expectations
  infect_an_assertion :refute_nil, :dont_be_terrible_ok, :unary
end

examples = File.expand_path '../examples', __FILE__
EXAMPLES = Dir[examples + '/*.geojson'].reduce({}) do |h, gj|
  h[gj.sub(examples+'/','').sub(/\.geojson$/,'').to_sym] =
    File.read(gj).gsub(/\r*\n*/,'').gsub('  ',' ')
  h
end

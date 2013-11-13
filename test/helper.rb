require 'bundler'
Bundler.require :default, :test

require 'minitest/autorun'
require 'minitest/pride'

lib = File.expand_path '../../..', __FILE__
$:.unshift lib unless $:.include? lib
require 'arcgis/terraformer'

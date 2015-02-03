# -*- encoding: utf-8 -*-
require File.expand_path('../lib/terraformer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kenichi Nakamura", "Davy Stevenson"]
  gem.email         = ["kenichi.nakamura@gmail.com", "davy.stevenson@gmail.com"]
  gem.description   = gem.summary = "toolkit for working with GeoJSON in pure Ruby"
  gem.homepage      = "https://github.com/kenichi/terraformer-ruby"
  gem.files         = `git ls-files | grep -Ev '^(myapp|examples)'`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "terraformer"
  gem.require_paths = ["lib"]
  gem.version       = Terraformer::VERSION
  gem.license       = 'apache'
  gem.add_runtime_dependency 'launchy', '~>2.4'
end

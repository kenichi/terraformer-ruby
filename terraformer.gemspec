# -*- encoding: utf-8 -*-
require File.expand_path('../lib/terraformer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kenichi Nakamura"]
  gem.email         = ["kenichi.nakamura@gmail.com"]
  gem.description   = gem.summary = ""
  gem.homepage      = "https://github.com/esripdx/terraformer-ruby"
  gem.files         = `git ls-files | grep -Ev '^(myapp|examples)'`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "terraformer"
  gem.require_paths = ["lib"]
  gem.version       = Terraformer::VERSION
  gem.license       = 'apache'
  gem.add_runtime_dependency 'launchy', '~>2.4'
end

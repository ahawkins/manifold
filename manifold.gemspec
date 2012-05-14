# -*- encoding: utf-8 -*-
require File.expand_path('../lib/manifold/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["twinturbo"]
  gem.email         = ["me@broadcastingadam.com"]
  gem.description   = %q{Rack middleware to enabled CORS}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/twinturbo/manifold"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "manifold"
  gem.require_paths = ["lib"]
  gem.version       = Manifold::VERSION

  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "rails"
  gem.add_development_dependency "simplecov"
end

require 'simplecov'
SimpleCov.start

require 'manifold'

require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require 'rack/test'


TestApp = Rack::Builder.app do
  use Manifold
  lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'OK'] }
end

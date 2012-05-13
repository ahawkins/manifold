require 'simplecov'
SimpleCov.start

require 'manifold'

require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun'

require 'rack/test'

class HelloWorld
  def self.call(env)
    [200, {}, ["Hi"]]
  end
end

TestApp = Rack::Builder.new do
  use Manifold::Middleware
  run HelloWorld
end

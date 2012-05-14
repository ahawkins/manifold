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

ENV['RAILS_ENV'] = "test"

require 'rails'
require 'action_controller/railtie'
require 'manifold/railtie'

class TestRailsApp < Rails::Application
  config.active_support.deprecation = proc { |message, stack| }
  initialize!
end

require 'test_helper'

class RailsIntegrationTest < MiniTest::Unit::TestCase
  def test_loads_middleware
    middleware = TestRailsApp.config.middleware
    assert_equal Manifold::Middleware, middleware.first.klass
  end

  def tests_exposes_headers_uses_in_rails_applications
    config = TestRailsApp.config.manifold

    assert_includes config.expose, 'X-Request-Id'
    assert_includes config.expose, 'X-Runtime'
    assert_includes config.expose, 'X-Rack-Cache'
  end
end

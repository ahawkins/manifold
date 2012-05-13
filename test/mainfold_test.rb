require 'test_helper'

class ManifoldTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp
  end

  def preflight(method, headers)
    options '/', {}, { 'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => method , 'HTTP_ACCESS_REQUEST_HEADERS' => headers }
  end

  def tests_can_handle_preflight_requests
    preflight "GET", "Content-Type"

    assert last_reponse.ok?

    headers = last_response.headers

    assert_equal "foo", headers['Access-Control-Accept-Origin']
  end
end

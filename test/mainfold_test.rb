require 'test_helper'

class ManifoldTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
    Manifold.config.expose = []
    Manifold.config.accept = []
  end

  def app
    TestApp
  end

  def preflight(method, headers = "Content-Type", origin = "http://example.com")
    options '/', {}, { 'HTTP_ORIGIN' => origin, 'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => method , 'HTTP_ACCESS_CONTROL_REQUEST_HEADERS' => headers }
  end

  def test_allows_any_origin
    preflight "GET", "Content-Type", "foo.com"

    assert last_response.ok?
    headers = last_response.headers
    assert_equal "*", headers['Access-Control-Allow-Origin']
  end

  def tests_echos_requested_method_for_preflight
    preflight "PATCH"

    assert last_response.ok?
    headers = last_response.headers
    assert_includes headers['Access-Control-Allow-Methods'], "PATCH"
  end

  def tests_echos_requested_headers_for_preflight
    preflight "PUT", "X-Custom-Header"

    assert last_response.ok?
    headers = last_response.header
    assert_includes headers['Access-Control-Allow-Headers'], "X-Custom-Header"
  end

  def test_allows_http_auth_in_preflight
    preflight "POST"

    assert last_response.ok?
    headers = last_response.headers
    assert_includes headers['Access-Control-Allow-Headers'], "Authorization"
  end

  def test_allows_cookies_in_preflight
    preflight "GET"

    assert last_response.ok?
    headers = last_response.headers
    assert_equal "true", headers['Access-Control-Allow-Credentials']
  end

  def test_sends_the_content_type_header_for_preflight
    preflight "PATCH"

    assert_equal 'text/plain', last_response.content_type
  end

  def test_allows_for_custom_headers_exposed
    Manifold.config.expose = ["X-Request-ID"]

    preflight "PATCH"

    assert last_response.ok?
    headers = last_response.headers
    assert_equal "X-Request-ID", headers['Access-Control-Expose-Headers']
  end

  def tests_allow_for_custom_headers_accept
    Manifold.config.accept = ["X-Rate-Limit"]

    preflight "PATCH"

    assert last_response.ok?
    headers = last_response.headers
    assert_includes headers['Access-Control-Allow-Headers'], 'X-Rate-Limit'
  end

  def test_preflight_is_cachable
    preflight "PATCH"

    assert last_response.ok?
    headers = last_response.header
    assert headers['Access-Control-Max-Age']
  end

  def test_adds_cors_support_for_simple_requests
    get '/'

    assert last_response.ok?
    headers = last_response.headers
    assert_equal "*", headers['Access-Control-Allow-Origin']
  end
end

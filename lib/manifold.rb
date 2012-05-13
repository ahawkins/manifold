require "manifold/version"

module Manifold
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if preflight?(env)
        env['HTTP_ORIGIN'] = 'file://' if env['HTTP_ORIGIN'] == 'null'
        env['HTTP_ORIGIN'] ||= env['HTTP_X_ORIGIN']

        headers = cors_headers(env)
        headers['Content-Type'] = 'text/plain'

        [200, headers, []]
      else
        status, headers, body =  @app.call env

        [status, headers.merge(cors_headers(env)), body]
      end
    end

    def cors_headers(env)
      headers = {}

      headers['Access-Control-Allow-Origin'] = env['HTTP_ORIGIN']

      headers['Access-Control-Allow-Methods'] = %w(GET POST PUT DELETE).join(", ")

      headers['Access-Control-Allow-Headers'] = [
        env['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'],
        'Authorization'
      ].compact.join(', ')

      headers['Access-Control-Expose-Headers'] = ['X-Request-Log-ID'].join(', ')

      headers['Access-Control-Allow-Credentials'] = "true"

      headers
    end

    def preflight?(env)
      env['REQUEST_METHOD'] == "OPTIONS" &&
        env['HTTP_ACCESS_CONTROL_REQUEST_METHOD'] &&
        env['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']
    end
  end
end

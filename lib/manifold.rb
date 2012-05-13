require "manifold/version"

module Manifold
  class Config
    attr_accessor :expose, :accept

    def initialize
      @expose = []
      @accept = []
    end
  end

  def self.config
    @config ||= Config.new
  end

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

        headers['Access-Control-Allow-Origin'] = "*"

        [status, headers, body]
      end
    end

    def cors_headers(env)
      headers = {}

      headers['Access-Control-Allow-Origin'] = "*"

      headers['Access-Control-Allow-Methods'] = env['HTTP_ACCESS_CONTROL_REQUEST_METHOD']

      headers['Access-Control-Allow-Headers'] = [
        env['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'],
        Manifold.config.accept,
        'Authorization'
      ].compact.join(', ')

      if Manifold.config.expose
        headers['Access-Control-Expose-Headers'] = Manifold.config.expose.join(', ')
      end

      headers['Access-Control-Allow-Credentials'] = "true"

      headers['Access-Control-Max-Age'] = "1728000"

      headers
    end

    def preflight?(env)
      env['REQUEST_METHOD'] == "OPTIONS" &&
        env['HTTP_ACCESS_CONTROL_REQUEST_METHOD'] &&
        env['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']
    end
  end
end

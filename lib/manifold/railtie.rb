module Manifold
  class Engine < Rails::Railtie
    config.manifold = Manifold.config

    initializer "manifold.middleware" do |app|
      app.config.middleware.insert 0, Manifold::Middleware
    end

    initializer "manifold.headers" do |app|
      app.config.manifold.expose << "X-Request-Id"
      app.config.manifold.expose << "X-Runtime"
      app.config.manifold.expose << "X-Rack-Cache"
    end
  end
end

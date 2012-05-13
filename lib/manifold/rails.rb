module Manifold
  class Engine < Rails::Engine
    config.manifold = Manifold.config
    config.cors = manifold

    middleware.insert 0, Manifold::Middleware

    config.manifold.expose << "X-Request-Id"
    config.manifold.expose << "X-Runtime"
    config.manifold.expose << "X-Rack-Cache"
  end
end

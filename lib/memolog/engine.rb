# frozen_string_literal: true

class Memolog::Engine < Rails::Engine
  initializer "memolog.use_rack_middleware" do |app|
    app.config.middleware.insert_before(0, Memolog::Middleware)
  end
end

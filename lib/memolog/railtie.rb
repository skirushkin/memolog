# frozen_string_literal: true

class Memolog::Railtie < Rails::Railtie
  initializer "memolog.configure_rails_initialization" do |app|
    app.middleware.insert_before(0, Memolog::Middleware)
  end
end

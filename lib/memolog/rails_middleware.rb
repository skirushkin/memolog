# frozen_string_literal: true

class Memolog::RailsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    Memolog.run { @app.call(env) }
  end
end

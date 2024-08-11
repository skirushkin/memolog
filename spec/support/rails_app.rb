# frozen_string_literal: true

require "rails"
require "action_controller"

def make_rails_app
  app = Class.new(Rails::Application) do
    def self.name
      "App"
    end

    yield if block_given?
  end

  app.config.logger = Logger.new(nil)
  app.config.hosts = nil
  app.config.secret_key_base = "test"
  app.config.eager_load = true

  app.initialize!

  Rails.application = app
  app
end

# frozen_string_literal: true

module Memolog::Init
  extend self

  def init_middlewares!
    init_rails_middleware!
    init_sidekiq_middleware!
  end

  def init_rails_middleware!
    return unless Memolog.config.middlewares.include?(:rails)
    return unless Object.const_defined?(:Rails)
    return if Object.const_defined?(:Sidekiq) && Sidekiq.server?

    Rails.application.middleware.insert_before(0, Memolog::RailsMiddleware)
  end

  def init_sidekiq_middleware!
    return unless Memolog.config.middlewares.include?(:sidekiq)
    return unless Object.const_defined?(:Sidekiq)

    Sidekiq.configure_server do |config|
      config.server_middleware do |chain|
        chain.prepend(Memolog::SidekiqMiddleware)
      end
    end
  end
end

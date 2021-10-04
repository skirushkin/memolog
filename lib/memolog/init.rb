# frozen_string_literal: true

class Memolog::Init
  def call
    init_rails!
    init_sentry!
    init_sidekiq!
  end

  private

  def init_rails!
    return unless defined?(Rails) && Memolog.config.initializers.include?(:rails)
    return if defined?(Sidekiq) && Sidekiq.server?

    Rails.application.middleware.insert_before(0, Memolog::Middleware)
  end

  def init_sentry!
    return unless defined?(Sentry::Scope) && Memolog.config.initializers.include?(:sentry)
    Sentry::Scope.prepend(Memolog::SentryScopeExtension)
  end

  def init_sidekiq!
    return unless defined?(Sidekiq) && Memolog.config.initializers.include?(:sidekiq)

    Sidekiq.configure_server do |config|
      config.server_middleware do |chain|
        chain.prepend(Memolog::SentrySidekiqMiddleware)
      end
    end
  end
end

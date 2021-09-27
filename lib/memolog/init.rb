# frozen_string_literal: true

if defined?(Rails::Railtie)
  require "memolog/railtie"
end

if defined?(Sentry::Scope)
  Sentry::Scope.prepend(Memolog::SentryScopeExtension)
end

if defined?(Sidekiq)
  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.prepend(Memolog::SentrySidekiqMiddleware)
    end
  end
end

# frozen_string_literal: true

class Memolog::Init
  def call
    init_rails!
    init_sentry!
    init_sidekiq!
  end

  private

  def init_rails!
    return unless Memolog.config.initializers.include?(:rails)
    return unless Object.const_defined?("Rails")
    return if Object.const_defined?("Sidekiq") && Sidekiq.server?

    Rails.application.middleware.insert_before(0, Memolog::Middleware)
  end

  def init_sentry!
    return unless Memolog.config.initializers.include?(:sentry)
    return unless Object.const_defined?("Sentry::Scope")

    Sentry::Scope.prepend(Memolog::SentryScopeExtension)
  end

  def init_sidekiq!
    return unless Memolog.config.initializers.include?(:sidekiq)
    return unless Object.const_defined?("Sidekiq")

    Sidekiq.configure_server do |config|
      config.server_middleware do |chain|
        chain.prepend(Memolog::SentrySidekiqMiddleware)
      end
    end
  end
end

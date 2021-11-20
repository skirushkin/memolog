# frozen_string_literal: true

class Memolog::SentrySidekiqMiddleware
  def call(*)
    Memolog.run do
      yield
    rescue => error
      memolog_dump = Memolog.dump
      Sentry.set_extras(Memolog.config.sentry_key => memolog_dump) if memolog_dump.present?

      raise error
    end
  end
end

# frozen_string_literal: true

Memolog::Config = Struct.new(
  :debug,
  :formatter,
  :initializers,
  :log_size_limit,
  :sentry_key,
  :uuid_callable,
) do
  def initialize
    self.debug = false
    self.formatter = ::Memolog::Formatter.new
    self.initializers = %i[rails sentry sidekiq]
    self.log_size_limit = 50_000
    self.sentry_key = :memolog
    self.uuid_callable = -> { SecureRandom.uuid }
  end
end
